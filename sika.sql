-- ============================================================
-- sika.sql : Database SIKA (Sistem Informasi Akademik)
-- Tugas 5 - Aplikasi Berbasis Platform | Bab 5 - MariaDB
-- Penyusun : Ahmad Rosihan Efendi (TI22250001)
-- ============================================================
-- CATATAN RESTORE: untuk mengimpor file ini ke database uji
-- (mis. sika_restore_test), hapus blok antara [DB-AWAL] dan
-- [DB-AKHIR], lalu pilih database uji sebelum menekan Import.
-- PERINGATAN: skrip ini menjalankan DROP TABLE pada 4 tabel SIKA.
-- ============================================================

SET NAMES utf8mb4;

-- [DB-AWAL]
CREATE DATABASE IF NOT EXISTS sika_db
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;
USE sika_db;
-- [DB-AKHIR]

-- Hapus tabel lama (urutan dibalik agar foreign key tidak menghalangi)
DROP TABLE IF EXISTS krs;
DROP TABLE IF EXISTS mata_kuliah;
DROP TABLE IF EXISTS mahasiswa;
DROP TABLE IF EXISTS prodi;

-- ------------------------------------------------------------
-- Tabel prodi
-- ------------------------------------------------------------
CREATE TABLE prodi (
  id_prodi   INT AUTO_INCREMENT PRIMARY KEY,
  kode_prodi VARCHAR(10)  NOT NULL UNIQUE,
  nama_prodi VARCHAR(100) NOT NULL
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- Tabel mahasiswa (FK -> prodi)
-- ------------------------------------------------------------
CREATE TABLE mahasiswa (
  nim        VARCHAR(20)  PRIMARY KEY,
  nama       VARCHAR(100) NOT NULL,
  email      VARCHAR(120) NOT NULL UNIQUE,
  angkatan   YEAR         NOT NULL,
  id_prodi   INT          NOT NULL,
  created_at TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_mahasiswa_prodi
    FOREIGN KEY (id_prodi) REFERENCES prodi(id_prodi)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- Tabel mata_kuliah
-- ------------------------------------------------------------
CREATE TABLE mata_kuliah (
  kode_mk  VARCHAR(15)  PRIMARY KEY,
  nama_mk  VARCHAR(100) NOT NULL,
  sks      TINYINT UNSIGNED NOT NULL,
  semester TINYINT UNSIGNED NOT NULL
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- Tabel krs (tabel perantara mahasiswa <-> mata_kuliah)
-- ------------------------------------------------------------
CREATE TABLE krs (
  id_krs         INT AUTO_INCREMENT PRIMARY KEY,
  nim            VARCHAR(20) NOT NULL,
  kode_mk        VARCHAR(15) NOT NULL,
  tahun_akademik VARCHAR(9)  NOT NULL,
  semester_ambil ENUM('Ganjil','Genap') NOT NULL,
  CONSTRAINT fk_krs_mahasiswa
    FOREIGN KEY (nim) REFERENCES mahasiswa(nim)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_krs_mk
    FOREIGN KEY (kode_mk) REFERENCES mata_kuliah(kode_mk)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT uq_krs UNIQUE (nim, kode_mk, tahun_akademik, semester_ambil)
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- Data uji
-- ------------------------------------------------------------
INSERT INTO prodi (kode_prodi, nama_prodi) VALUES
('TI', 'Teknik Informatika'),
('SI', 'Sistem Informasi');

INSERT INTO mahasiswa (nim, nama, email, angkatan, id_prodi) VALUES
('24010001', 'Andi Saputra',   'andi@sika.test',  2024, 1),
('24010002', 'Siti Rahma',     'siti@sika.test',  2024, 1),
('24010003', 'Nurul Hidayah',  'nurul@sika.test', 2024, 1),
('24020001', 'Budi Santoso',   'budi@sika.test',  2024, 2),
('24020002', 'Rina Aulia',     'rina@sika.test',  2024, 2);

INSERT INTO mata_kuliah (kode_mk, nama_mk, sks, semester) VALUES
('ABP301',  'Aplikasi Berbasis Platform', 3, 3),
('PWEB201', 'Pemrograman Web 1',          3, 2),
('BD202',   'Basis Data',                 3, 2),
('TWS401',  'Teknologi Web Services',     3, 4);

INSERT INTO krs (nim, kode_mk, tahun_akademik, semester_ambil) VALUES
('24010001', 'ABP301',  '2026/2027', 'Ganjil'),
('24010001', 'BD202',   '2026/2027', 'Ganjil'),
('24010002', 'ABP301',  '2026/2027', 'Ganjil'),
('24010003', 'PWEB201', '2026/2027', 'Ganjil'),
('24020001', 'BD202',   '2026/2027', 'Ganjil'),
('24020002', 'ABP301',  '2026/2027', 'Ganjil');
