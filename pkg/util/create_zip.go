package util

import (
	"archive/zip"
	"io"
	"os"
	"path/filepath"

	"github.com/gin-gonic/gin"
)

func CreateZip(c *gin.Context, dir string) {
	zipPath := "./backup.zip"
	zipFile, _ := os.Create(zipPath)
	defer zipFile.Close()
	zw := zip.NewWriter(zipFile)
	defer zw.Close()

	filepath.Walk(dir, func(filePath string, info os.FileInfo, err error) error {
		if !info.IsDir() {
			zf, _ := zw.Create(info.Name())
			fsFile, _ := os.Open(filePath)
			defer fsFile.Close()
			io.Copy(zf, fsFile)
		}
		return nil
	})
	c.File(zipPath)
}
