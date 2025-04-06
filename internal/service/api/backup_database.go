package api

import (
	"context"
	"log"
	"net/http"
	"os"
	"os/exec"
	"path/filepath"

	"github.com/gin-gonic/gin"
	"github.com/hisshihi/shop-back/pkg/util"
)

func (server *Server) createSQLBackup(ctx *gin.Context) {
	filePath := "./backup.sql"
	cmd := exec.Command("pg_dump", "-U", "root", "-h", "localhost", "-p", "5432", "-F", "p", "-f", filePath, "shop_db")
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
	outputDir := "./csv_backup"
	if err := os.MkdirAll(outputDir, os.ModePerm); err != nil {
		c.JSON(500, gin.H{"error": "Не удалось создать директорию"})
		return
	}

	// Получаем список таблиц через стандартное подключение (это не меняется)
	rows, err := server.store.DB().Query("SELECT tablename FROM pg_tables WHERE schemaname = 'public'")
	if err != nil {
		c.JSON(500, gin.H{"error": "Ошибка при получении списка таблиц"})
		return
	}
	defer rows.Close()

	for rows.Next() {
		var tableName string
		if err := rows.Scan(&tableName); err != nil {
			continue
		}
		csvPath := filepath.Join(outputDir, tableName+".csv")

		// Получаем соединение из pgx pool
		conn, err := server.store.PgxPool.Acquire(context.Background())
		if err != nil {
			log.Printf("Ошибка получения pgx соединения: %v", err)
			continue
		}
		// Освобождаем соединение после работы
		// (заметьте, что если Acuire вернул ошибку, Release не требуется)
		defer conn.Release()

		query := "COPY (SELECT * FROM public." + tableName + ") TO STDOUT WITH CSV HEADER"

		// Создаем файл для записи
		file, err := os.Create(csvPath)
		if err != nil {
			log.Printf("Ошибка создания файла %s: %v", csvPath, err)
			continue
		}

		// Используем pgx для выполнения COPY TO STDOUT
		// Функция CopyTo принимает контекст, объект-назначение (в нашем случае файл) и запрос.
		_, err = conn.Conn().PgConn().CopyTo(context.Background(), file, query)
		if err != nil {
			log.Printf("Ошибка экспорта таблицы %s: %v", tableName, err)
			file.Close()
			continue
		}
		file.Close()
	}

	// После экспорта таблиц упаковываем файлы в ZIP
	util.CreateZip(c, outputDir)
}
