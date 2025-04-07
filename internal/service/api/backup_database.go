package api

import (
	"archive/zip"
	"bytes"
	"context"
	"fmt"
	"io/fs"
	"log"
	"net/http"
	"os"
	"os/exec"
	"path/filepath"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/jackc/pgx/v4"
	"github.com/jackc/pgx/v4/pgxpool"
)

func (server *Server) createSQLBackup(ctx *gin.Context) {
	filePath := "./backup.sql"
	cmd := exec.Command("pg_dump", "-U", server.config.DBUser, "-h", server.config.DBHost, "-p", server.config.DBPort, "-F", "p", "-f", filePath, server.config.DBDatabase)
	cmd.Env = append(os.Environ(), "PGPASSWORD=secret")

	output, err := cmd.CombinedOutput() // Получаем как стандартный вывод, так и вывод ошибок
	if err != nil {
		log.Printf("Ошибка выполнения pg_dump: %s\nВывод: %s", err, output)
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": "Не удалось создать SQL-дамп"})
		return
	}
	ctx.Header("Content-Description", "File Transfer")
	ctx.Header("Content-Transfer-Encoding", "binary")
	ctx.Header("Content-Disposition", "attachment; filename=backup.sql")
	ctx.File(filePath)
}

func (server *Server) createCSVBackup(c *gin.Context) {
	outputDir, err := os.MkdirTemp("", "csv_backup_*")
	if err != nil {
		c.JSON(500, gin.H{"error": "Не удалось создать временную директорию"})
		return
	}
	defer os.RemoveAll(outputDir)

	rows, err := server.store.DB().Query(`
        SELECT tablename 
        FROM pg_tables 
        WHERE schemaname = 'public'
        AND tablename NOT LIKE 'pg_%'
    `)
	if err != nil {
		c.JSON(500, gin.H{"error": "Ошибка при получении списка таблиц"})
		return
	}
	defer rows.Close()

	var exportedTables int
	for rows.Next() {
		var tableName string
		if err := rows.Scan(&tableName); err != nil {
			continue
		}

		csvPath := filepath.Join(outputDir, tableName+".csv")
		if err := exportTableToCSV(server.store.PgxPool, tableName, csvPath); err == nil {
			exportedTables++
		}
	}

	if exportedTables == 0 {
		c.JSON(500, gin.H{"error": "Не удалось экспортировать ни одной таблицы"})
		return
	}

	zipBuffer := new(bytes.Buffer)
	zipWriter := zip.NewWriter(zipBuffer)

	err = filepath.WalkDir(outputDir, func(path string, d fs.DirEntry, err error) error {
		if d.IsDir() {
			return nil
		}

		relPath, _ := filepath.Rel(outputDir, path)
		data, _ := os.ReadFile(path)

		header := &zip.FileHeader{
			Name:     relPath,
			Method:   zip.Deflate,
			Flags:    0x800,
			Modified: time.Now(),
		}

		writer, _ := zipWriter.CreateHeader(header)
		writer.Write(data)
		return nil
	})
	if err != nil {
		c.JSON(500, gin.H{"error": "Ошибка упаковки архива"})
		return
	}

	zipWriter.Close()

	c.Header("Content-Type", "application/zip")
	c.Header("Content-Disposition", fmt.Sprintf("attachment; filename=backup_%s.zip", time.Now().Format("20060102-150405")))
	c.Data(200, "application/zip", zipBuffer.Bytes())
}

func exportTableToCSV(pool *pgxpool.Pool, tableName, csvPath string) error {
	conn, err := pool.Acquire(context.Background())
	if err != nil {
		return fmt.Errorf("ошибка подключения: %w", err)
	}
	defer conn.Release()

	// Указываем кодировку UTF-8 и разделители
	query := fmt.Sprintf(
		"COPY (SELECT * FROM %s) TO STDOUT WITH (FORMAT CSV, HEADER, ENCODING 'UTF-8', DELIMITER ',')",
		pgx.Identifier{tableName}.Sanitize(),
	)

	file, err := os.Create(csvPath)
	if err != nil {
		return fmt.Errorf("ошибка создания файла: %w", err)
	}
	defer file.Close()

	// Записываем BOM для UTF-8 (необязательно, но помогает некоторым программам)
	if _, err := file.Write([]byte{0xEF, 0xBB, 0xBF}); err != nil {
		return fmt.Errorf("ошибка записи BOM: %w", err)
	}

	_, err = conn.Conn().PgConn().CopyTo(context.Background(), file, query)
	if err != nil {
		return fmt.Errorf("ошибка экспорта данных: %w", err)
	}

	return nil
}
