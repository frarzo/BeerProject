-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Versione server:              8.0.32 - MySQL Community Server - GPL
-- S.O. server:                  Win64
-- HeidiSQL Versione:            12.5.0.6677
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Dump della struttura del database beer
CREATE DATABASE IF NOT EXISTS `beer` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `beer`;

-- Dump della struttura di tabella beer.birra
CREATE TABLE IF NOT EXISTS `birra` (
  `id` int NOT NULL,
  `nome` varchar(20) NOT NULL,
  `prezzo_litro` decimal(5,2) NOT NULL,
  `disp` enum('DISP','NON_DISP') NOT NULL,
  `gradi` decimal(4,2) DEFAULT NULL,
  `tipo` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dump dei dati della tabella beer.birra: ~12 rows (circa)
REPLACE INTO `birra` (`id`, `nome`, `prezzo_litro`, `disp`, `gradi`, `tipo`) VALUES
	(111, 'Crux', 16.00, 'DISP', 5.00, 'Sour'),
	(112, 'Isaac', 15.00, 'DISP', 5.00, 'Blanche'),
	(116, 'Black Hole', 18.00, 'DISP', 10.50, 'Imperial Stout'),
	(120, 'Lone Wolf', 13.00, 'DISP', 6.66, 'IPA'),
	(121, 'Pop', 13.00, 'DISP', 6.00, 'APA'),
	(124, 'Guinness', 12.00, 'DISP', 4.20, 'Stout'),
	(125, 'Guerrilla', 15.00, 'DISP', 5.80, 'IPA'),
	(126, 'Kilkenny RED', 14.00, 'DISP', 4.30, 'Red Ale'),
	(127, 'Heineken', 9.00, 'NON_DISP', 3.40, 'Lager'),
	(128, 'Peroni', 10.00, 'DISP', 4.70, 'Lager'),
	(234, 'Grim Reaper', 12.00, 'NON_DISP', 7.00, 'IPA'),
	(312, 'Poretti IPA', 12.00, 'DISP', 5.90, 'IPA');

-- Dump della struttura di tabella beer.consumazione
CREATE TABLE IF NOT EXISTS `consumazione` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` varchar(8) NOT NULL,
  `beer_id` int NOT NULL,
  `quantita` int NOT NULL,
  `importo` decimal(6,2) DEFAULT NULL,
  `data_consumazione` datetime DEFAULT (now()),
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `beer_id` (`beer_id`),
  CONSTRAINT `consumazione_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `utente` (`id`),
  CONSTRAINT `consumazione_ibfk_2` FOREIGN KEY (`beer_id`) REFERENCES `birra` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1000187 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dump dei dati della tabella beer.consumazione: ~183 rows (circa)
REPLACE INTO `consumazione` (`id`, `user_id`, `beer_id`, `quantita`, `importo`, `data_consumazione`) VALUES
	(1000000, '00aaa000', 128, 202, 2.02, '2023-09-20 10:16:17'),
	(1000001, '00aaa000', 128, 182, 1.82, '2023-09-20 22:22:54'),
	(1000002, '00aaa000', 128, 44, 0.44, '2023-09-20 22:22:56'),
	(1000003, '00aaa000', 128, 46, 0.46, '2023-09-20 22:26:55'),
	(1000004, '00aaa000', 128, 43, 0.43, '2023-09-20 22:26:57'),
	(1000005, '00aaa000', 128, 35, 0.35, '2023-09-20 22:26:58'),
	(1000006, '00aaa000', 128, 32, 0.32, '2023-09-20 22:30:37'),
	(1000007, '00aaa000', 128, 38, 0.38, '2023-09-20 22:30:39'),
	(1000008, '00aaa000', 128, 16, 0.16, '2023-09-20 22:30:40'),
	(1000009, '00aaa000', 128, 12, 0.12, '2023-09-20 22:30:41'),
	(1000010, '00aaa000', 128, 3, 0.03, '2023-09-20 22:30:42'),
	(1000011, '00aaa000', 128, 58, 0.58, '2023-09-20 22:30:44'),
	(1000012, '00aaa000', 128, 50, 0.50, '2023-09-20 22:30:46'),
	(1000013, '00aaa000', 128, 3, 0.03, '2023-09-20 22:30:47'),
	(1000014, '00aaa000', 128, 147, 1.47, '2023-09-20 22:39:35'),
	(1000015, '00aaa000', 128, 41, 0.41, '2023-09-20 22:39:42'),
	(1000016, '00aaa000', 128, 43, 0.43, '2023-09-20 22:39:43'),
	(1000017, '00aaa000', 128, 107, 1.07, '2023-09-20 22:45:52'),
	(1000018, '00aaa000', 128, 139, 1.39, '2023-09-20 22:45:57'),
	(1000019, '00aaa000', 128, 39, 0.39, '2023-09-20 22:45:59'),
	(1000020, '00aaa000', 128, 38, 0.38, '2023-09-20 22:46:02'),
	(1000021, '00aaa000', 128, 55, 0.55, '2023-09-20 22:53:11'),
	(1000022, '00aaa000', 128, 79, 0.79, '2023-09-20 22:53:15'),
	(1000023, '00aaa000', 128, 89, 0.89, '2023-09-20 22:54:33'),
	(1000024, '00aaa000', 128, 299, 2.99, '2023-09-20 22:56:14'),
	(1000025, '00aaa000', 128, 84, 0.84, '2023-09-20 23:02:43'),
	(1000026, '00aaa000', 128, 59, 0.59, '2023-09-20 23:03:54'),
	(1000027, '00aaa000', 128, 161, 1.61, '2023-09-20 23:04:03'),
	(1000028, '00aaa000', 128, 106, 1.06, '2023-09-20 23:04:10'),
	(1000029, '00aaa000', 128, 90, 0.90, '2023-09-20 23:09:29'),
	(1000030, '00aaa000', 128, 95, 0.95, '2023-09-20 23:09:34'),
	(1000053, '00aaa000', 128, 22, 0.22, '2023-09-21 09:19:25'),
	(1000054, '00aaa000', 128, 217, 2.17, '2023-09-21 09:19:38'),
	(1000055, '00aaa000', 128, 214, 2.14, '2023-09-21 09:19:53'),
	(1000056, '00aaa000', 128, 29, 0.29, '2023-09-21 09:19:59'),
	(1000057, '00aaa000', 128, 237, 2.37, '2023-09-21 09:20:05'),
	(1000058, '00aaa000', 128, 141, 1.41, '2023-09-21 09:20:11'),
	(1000059, '00aaa000', 128, 168, 1.68, '2023-09-21 09:20:23'),
	(1000060, 'a1b2c3d4', 128, 156, 1.56, '2023-09-21 17:51:56'),
	(1000061, '00aaa000', 128, 145, 1.45, '2023-09-21 17:52:04'),
	(1000062, '00aaa000', 128, 126, 1.26, '2023-09-21 17:54:07'),
	(1000063, 'a1b2c3d4', 128, 57, 0.57, '2023-09-21 17:54:13'),
	(1000064, 'a1b2c3d4', 128, 127, 1.27, '2023-09-21 17:54:16'),
	(1000065, 'a1b2c3d4', 128, 154, 1.54, '2023-09-21 17:55:38'),
	(1000066, 'a1b2c3d4', 128, 103, 1.03, '2023-09-21 17:57:41'),
	(1000067, '00aaa000', 128, 117, 1.17, '2023-09-21 18:01:16'),
	(1000068, 'a1b2c3d4', 128, 355, 3.55, '2023-09-21 18:03:07'),
	(1000069, 'a1b2c3d4', 128, 6226, 62.26, '2023-09-21 18:06:48'),
	(1000070, 'a1b2c3d4', 128, 38, 0.38, '2023-09-21 18:06:52'),
	(1000071, 'a1b2c3d4', 128, 217, 2.17, '2023-09-21 18:44:57'),
	(1000072, 'a1b2c3d4', 128, 142, 1.42, '2023-09-21 18:45:02'),
	(1000073, 'a1b2c3d4', 128, 1793, 17.93, '2023-09-21 20:39:30'),
	(1000074, 'a1b2c3d4', 128, 101, 1.01, '2023-09-21 20:39:42'),
	(1000075, 'a1b2c3d4', 128, 62, 0.62, '2023-09-21 20:39:49'),
	(1000076, 'a1b2c3d4', 128, 77, 0.77, '2023-09-21 21:39:29'),
	(1000077, 'a1b2c3d4', 128, 96, 0.96, '2023-09-21 21:39:37'),
	(1000078, 'a1b2c3d4', 128, 107, 1.07, '2023-09-21 21:40:05'),
	(1000079, 'a1b2c3d4', 128, 81, 0.81, '2023-09-21 21:40:43'),
	(1000080, 'a1b2c3d4', 128, 114, 1.14, '2023-09-21 21:41:06'),
	(1000081, 'a1b2c3d4', 128, 835, 8.35, '2023-09-21 21:45:05'),
	(1000082, 'a1b2c3d4', 128, 84, 0.84, '2023-09-22 14:50:37'),
	(1000083, 'a1b2c3d4', 128, 111, 1.11, '2023-09-22 14:50:41'),
	(1000084, 'a1b2c3d4', 128, 59, 0.59, '2023-09-22 14:50:53'),
	(1000085, 'a1b2c3d4', 128, 47, 0.47, '2023-09-22 14:50:55'),
	(1000086, 'a1b2c3d4', 128, 50, 0.50, '2023-09-22 14:50:58'),
	(1000087, '00aaa000', 128, 63, 0.63, '2023-09-22 14:51:01'),
	(1000088, '00aaa000', 128, 153, 1.53, '2023-09-22 14:51:06'),
	(1000089, '00aaa000', 128, 128, 1.28, '2023-09-22 14:51:10'),
	(1000090, '00aaa000', 128, 97, 0.97, '2023-09-22 14:51:13'),
	(1000091, '00aaa000', 128, 84, 0.84, '2023-09-22 14:51:28'),
	(1000092, 'a1b2c3d4', 128, 48, 0.48, '2023-09-22 14:51:30'),
	(1000093, 'a1b2c3d4', 128, 204, 2.04, '2023-09-22 14:52:04'),
	(1000094, 'a1b2c3d4', 128, 156, 1.56, '2023-09-22 14:52:09'),
	(1000095, 'a1b2c3d4', 128, 85, 0.85, '2023-09-22 14:52:19'),
	(1000096, 'a1b2c3d4', 128, 190, 1.90, '2023-09-22 14:52:42'),
	(1000097, 'a1b2c3d4', 128, 119, 1.19, '2023-09-22 14:52:54'),
	(1000098, 'a1b2c3d4', 128, 116, 1.16, '2023-09-22 14:52:57'),
	(1000099, '00aaa000', 128, 63, 0.63, '2023-09-22 14:53:00'),
	(1000100, '00aaa000', 128, 133, 1.33, '2023-09-22 14:55:05'),
	(1000101, 'a1b2c3d4', 128, 69, 0.69, '2023-09-22 14:55:10'),
	(1000102, '00aaa000', 128, 95, 0.95, '2023-09-22 14:55:20'),
	(1000103, 'a1b2c3d4', 128, 107, 1.07, '2023-09-22 14:55:24'),
	(1000104, 'a1b2c3d4', 128, 126, 1.26, '2023-09-22 14:55:29'),
	(1000105, 'a1b2c3d4', 128, 71, 0.71, '2023-09-22 14:55:31'),
	(1000106, '00aaa000', 128, 222, 2.22, '2023-09-22 15:02:50'),
	(1000107, 'a1b2c3d4', 128, 184, 1.84, '2023-09-22 15:03:20'),
	(1000108, '00aaa000', 128, 78, 0.78, '2023-09-22 15:03:24'),
	(1000109, 'a1b2c3d4', 128, 111, 1.11, '2023-09-22 15:03:30'),
	(1000110, 'a1b2c3d4', 128, 1813, 18.13, '2023-09-22 15:04:21'),
	(1000111, 'a1b2c3d4', 128, 203, 2.03, '2023-09-22 15:04:24'),
	(1000112, 'a1b2c3d4', 128, 138, 1.38, '2023-09-22 15:04:32'),
	(1000113, 'a1b2c3d4', 128, 410, 4.10, '2023-09-22 15:06:08'),
	(1000114, 'a1b2c3d4', 128, 111, 1.11, '2023-09-22 15:06:16'),
	(1000115, 'a1b2c3d4', 128, 43, 0.43, '2023-09-22 15:08:15'),
	(1000116, 'a1b2c3d4', 128, 31, 0.31, '2023-09-22 15:19:33'),
	(1000117, 'a1b2c3d4', 128, 81, 0.81, '2023-09-22 15:19:36'),
	(1000118, 'a1b2c3d4', 128, 73, 0.73, '2023-09-22 15:19:39'),
	(1000119, '00aaa000', 128, 89, 0.89, '2023-09-22 15:19:45'),
	(1000120, 'a1b2c3d4', 128, 302, 3.02, '2023-09-22 15:19:53'),
	(1000121, 'a1b2c3d4', 128, 136, 1.36, '2023-09-22 15:19:57'),
	(1000122, 'a1b2c3d4', 128, 147, 1.47, '2023-09-22 15:20:01'),
	(1000123, 'a1b2c3d4', 128, 54, 0.54, '2023-09-22 15:24:17'),
	(1000124, '00aaa000', 128, 96, 0.96, '2023-09-22 15:24:25'),
	(1000125, '00aaa000', 128, 237, 2.37, '2023-09-22 15:24:32'),
	(1000126, '00aaa000', 128, 217, 2.17, '2023-09-22 15:24:39'),
	(1000127, 'a1b2c3d4', 128, 131, 1.31, '2023-09-22 15:24:46'),
	(1000128, 'a1b2c3d4', 128, 63, 0.63, '2023-09-22 15:25:18'),
	(1000129, 'a1b2c3d4', 128, 131, 1.31, '2023-09-22 15:25:23'),
	(1000130, 'a1b2c3d4', 128, 135, 1.35, '2023-09-22 15:25:28'),
	(1000131, 'a1b2c3d4', 128, 176, 1.76, '2023-09-22 15:28:41'),
	(1000132, '00aaa000', 128, 95, 0.95, '2023-09-22 15:28:48'),
	(1000133, '00aaa000', 128, 46, 0.46, '2023-09-22 15:29:17'),
	(1000134, '00aaa000', 128, 106, 1.06, '2023-09-22 15:29:34'),
	(1000135, '00aaa000', 128, 62, 0.62, '2023-09-22 15:29:40'),
	(1000136, '00aaa000', 128, 51, 0.51, '2023-09-22 15:29:55'),
	(1000137, '00aaa000', 128, 35, 0.35, '2023-09-22 15:35:01'),
	(1000138, '00aaa000', 128, 9, 0.09, '2023-09-22 15:35:02'),
	(1000139, '00aaa000', 128, 82, 0.82, '2023-09-22 15:35:08'),
	(1000140, '00aaa000', 128, 152, 1.52, '2023-09-22 15:35:26'),
	(1000141, '00aaa000', 128, 90, 0.90, '2023-09-22 15:36:31'),
	(1000142, 'a1b2c3d4', 128, 134, 1.34, '2023-09-22 15:36:40'),
	(1000143, 'a1b2c3d4', 128, 78, 0.78, '2023-09-22 15:38:56'),
	(1000144, 'a1b2c3d4', 128, 185, 1.85, '2023-09-22 15:39:05'),
	(1000145, 'a1b2c3d4', 128, 106, 1.06, '2023-09-22 15:39:27'),
	(1000146, '00aaa000', 128, 101, 1.01, '2023-09-22 15:39:47'),
	(1000147, 'a1b2c3d4', 128, 60, 0.60, '2023-09-22 15:40:23'),
	(1000148, 'a1b2c3d4', 128, 54, 0.54, '2023-09-22 15:40:37'),
	(1000149, 'a1b2c3d4', 128, 114, 1.14, '2023-09-22 15:41:12');


-- Dump della struttura di tabella beer.pompa
CREATE TABLE IF NOT EXISTS `pompa` (
  `id` int NOT NULL AUTO_INCREMENT,
  `beer_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `beer_id` (`beer_id`),
  CONSTRAINT `pompa_ibfk_1` FOREIGN KEY (`beer_id`) REFERENCES `birra` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dump dei dati della tabella beer.pompa: ~3 rows (circa)
REPLACE INTO `pompa` (`id`, `beer_id`) VALUES
	(3, 116),
	(2, 125),
	(1, 128);

-- Dump della struttura di tabella beer.utente
CREATE TABLE IF NOT EXISTS `utente` (
  `id` varchar(8) NOT NULL,
  `nome` varchar(20) NOT NULL,
  `cognome` varchar(20) NOT NULL,
  `email` varchar(45) NOT NULL,
  `psw` varchar(30) NOT NULL,
  `saldo` decimal(10,2) DEFAULT (0),
  `data_reg` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dump dei dati della tabella beer.utente: ~102 rows (circa)
REPLACE INTO `utente` (`id`, `nome`, `cognome`, `email`, `psw`, `saldo`, `data_reg`) VALUES
	('00aaa000', 'Francesco', 'Arzon', 'franz9700@gmail.com', 'abcd1234', 116.31, '2010-02-06 10:00:00'),
	('0goy8k2o', 'Stewart', 'Laneham', 'slaneham1k@irs.gov', 'fkkI5552a`kS.', 167.15, '2023-02-11 12:43:45'),
	('0khrh2yt', 'Hildagard', 'Berfoot', 'hberfootn@virginia.edu', 'prtE171N$4%)', 343.28, '2015-02-26 17:20:57'),
	('0tpa35oo', 'Devonna', 'McPheat', 'dmcpheatb@pcworld.com', 'adjC967Q.', 278.20, '2015-05-16 14:42:30'),
	('15msfysg', 'Rossy', 'Norcliff', 'rnorcliff3@gmpg.org', 'eadT9017px5nGif', 544.66, '2016-06-14 22:53:34'),
	('18vr179r', 'Isaiah', 'Clarkson', 'iclarkson1@auda.org.au', 'lriN987..4Am', 179.16, '2016-04-09 13:42:50'),
	('1ammoms5', 'Hermina', 'Cazereau', 'hcazereaus@fema.gov', 'rcrU3268', 162.30, '2021-03-10 22:00:24'),
	('1nuz8684', 'Lynnell', 'Ferrulli', 'lferrullip@mtv.com', 'edjH027THb_,qC{', 877.36, '2015-11-05 04:55:59'),
	('262a7g8p', 'Brianna', 'Sabater', 'bsabater23@paginegialle.it', 'yycL630}2=', 145.16, '2020-01-26 10:21:11'),
	('278vhpm9', 'Skipper', 'Gerish', 'sgerish1w@senate.gov', 'opjY804Ypp+', 89.65, '2015-03-25 07:41:33'),
	('29lmqylf', 'Vivianna', 'Ernshaw', 'vernshaw2@printfriendly.com', 'pgbP731$', 42.19, '2015-01-27 01:38:34'),
	('2aupnrez', 'Leoine', 'Youtead', 'lyoutead20@biglobe.ne.jp', 'nczZ108pGf{x@O$', 65.09, '2015-10-20 01:01:28'),
	('2hq29bqh', 'Zak', 'Cordoba', 'zcordobaj@surveymonkey.com', 'gyhE728a}', 528.34, '2019-03-20 14:23:54'),
	('4gv2dhu2', 'Lilla', 'Myers', 'lmyers18@deliciousdays.com', 'owoM448gJv', 929.72, '2015-03-16 09:20:52'),
	('5q4p9gmv', 'Morena', 'Davydychev', 'mdavydychev1n@hud.gov', 'bbaS282F/MNjKV9', 10.81, '2017-07-15 03:29:44'),
	('622t7xql', 'Binni', 'Chantree', 'bchantreeg@hubpages.com', 'ckfI493I%', 13.15, '2022-12-04 04:02:03'),
	('6bt3dv9w', 'Reese', 'Basindale', 'rbasindale2g@wisc.edu', 'gmrQ711+', 28.97, '2022-04-26 18:51:22'),
	('6nuelvxi', 'Ardene', 'Katt', 'akatt1f@walmart.com', 'qziL063N$TYs01Ra', 982.64, '2017-04-09 18:57:35'),
	('74fm231v', 'Nikita', 'Heater', 'nheater1t@goo.gl', 'opzY6015QysTN,@', 407.79, '2015-10-15 14:07:32'),
	('7atff18a', 'Sergei', 'Jiggens', 'sjiggens2f@netvibes.com', 'wvbZ6226>Avv|', 755.34, '2022-05-03 04:17:20'),
	('80fuv8x1', 'Dyann', 'Thickins', 'dthickins15@smugmug.com', 'qcoL150.8z~/N~@', 657.00, '2016-09-22 23:01:26'),
	('8diekma4', 'Nikolaos', 'Orrobin', 'norrobin27@cnet.com', 'smjY432*B', 173.93, '2022-10-30 15:25:47'),
	('914vxu43', 'Guido', 'Pakenham', 'gpakenham1z@answers.com', 'adfU93995`mD', 787.25, '2015-01-21 19:59:27'),
	('9l1vbt45', 'Danita', 'Turnpenny', 'dturnpenny25@google.it', 'flqR471vC%iu', 312.17, '2019-04-24 22:43:56'),
	('a1b2c3d4', 'Davide', 'Sancin', 'sancdav@gmail.com', 'applicazione', 642.53, '2023-09-21 17:21:47'),
	('b8ck7r24', 'Aldis', 'Aston', 'aaston2k@slideshare.net', 'qtvY991Z', 863.08, '2023-01-03 20:13:59'),
	('bds8sl3t', 'Ado', 'Sheridan', 'asheridan2i@pagesperso-orange.fr', 'jajE869O73l', 557.06, '2021-03-19 18:53:26'),
	('bz85yftg', 'Barbe', 'Beecker', 'bbeecker1s@huffingtonpost.com', 'xhuI917p', 525.51, '2017-07-02 20:05:11'),
	('c1g0o9bh', 'Olivie', 'Bome', 'obome1b@spiegel.de', 'yaqL0065..s.&e', 892.45, '2022-09-02 19:31:09'),
	('c24kk0xg', 'Brenden', 'Dutnell', 'bdutnell1e@printfriendly.com', 'nckE363!', 825.43, '2018-08-30 22:35:24'),
	('c252owwc', 'Maryann', 'Domney', 'mdomneyc@abc.net.au', 'pasE758UZ5>1hS89', 432.07, '2021-05-18 13:25:06'),
	('crgcbe7i', 'Maible', 'Bidwell', 'mbidwell2h@reuters.com', 'zqbD804%GfkH.b8', 889.14, '2017-10-28 11:47:04'),
	('cw66vqjk', 'Ansley', 'Toffetto', 'atoffetto1c@sbwire.com', 'klrF065b', 468.09, '2019-04-02 13:08:33'),
	('d2761520', 'test', 'tost', 'test@mail.com', 'fhbieufwe', 0.00, '2023-08-15 10:33:09'),
	('ddi2jaip', 'Lisetta', 'McEnery', 'lmcenery2n@spiegel.de', 'ukpW566.S~Jvn59x', 672.09, '2021-06-03 01:03:38'),
	('dfa7ln9m', 'Philippa', 'Butterley', 'pbutterley2q@epa.gov', 'eznH22011H+gMPN', 772.83, '2017-10-15 00:26:14'),
	('dvvww4b4', 'Jeffy', 'MacCleay', 'jmaccleay13@ihg.com', 'xelA309P3IN', 573.89, '2016-06-27 00:25:32'),
	('e6mq99x2', 'Alissa', 'Halladey', 'ahalladeyz@tinypic.com', 'xgpY954&i..%$x', 988.19, '2022-05-27 23:05:30'),
	('e7mw8u2v', 'Elyssa', 'Cradduck', 'ecradducku@issuu.com', 'rcwD476@', 64.15, '2021-02-08 11:58:30'),
	('eqwmm3s6', 'Aristotle', 'Hurdidge', 'ahurdidgex@cbc.ca', 'whkR5510_ffs..0', 239.14, '2017-08-04 07:42:04'),
	('gi64t2a0', 'Nathanael', 'Swatton', 'nswattonr@slate.com', 'zweV331~NFI/Fx+9', 508.68, '2022-08-05 14:00:03'),
	('hpu54c3u', 'Debor', 'Redholes', 'dredholes16@reference.com', 'twoE706k1ZS', 327.47, '2015-09-03 09:42:15'),
	('hu5sesfy', 'Octavia', 'Ollander', 'oollander7@dailymail.co.uk', 'rccX859gmfP5c', 809.88, '2018-08-16 03:27:58'),
	('ibddeykv', 'Hephzibah', 'Mollene', 'hmollene1x@flickr.com', 'abhE373j(', 685.77, '2019-06-10 13:37:25'),
	('ixftmy8g', 'Clare', 'Brackpool', 'cbrackpool1a@i2i.jp', 'zmhP68647~|p+', 870.82, '2020-11-05 04:46:09'),
	('j2xv4h8v', 'Horton', 'Petrushka', 'hpetrushka2l@cnet.com', 'etiU957h?K', 686.73, '2022-06-30 11:31:11'),
	('j7iyu75r', 'Deeanne', 'Ratnege', 'dratnege6@mozilla.com', 'lirE668Q0)Mxpwt', 189.89, '2017-06-18 03:11:01'),
	('j9ar8xo6', 'Gene', 'Sprague', 'gsprague10@trellian.com', 'bsfD303I', 186.46, '2015-02-07 14:26:36'),
	('jj1es2kf', 'Scott', 'Andrag', 'sandrag1r@clickbank.net', 'czqO060jJ', 340.42, '2017-07-19 09:30:11'),
	('jp596h56', 'Michael', 'Simione', 'msimionem@icio.us', 'julB482DKMtekA3', 315.67, '2016-12-07 16:52:31'),
	('jr613bjm', 'Robinett', 'Brando', 'rbrandoi@ebay.co.uk', 'qlkC930e', 149.05, '2015-01-25 09:21:24'),
	('k2quixfq', 'Claudina', 'Rizzello', 'crizzello1q@amazon.co.jp', 'tkgH708YoJBh%x', 682.89, '2015-07-13 17:48:41'),
	('k771angm', 'Judie', 'McFarlan', 'jmcfarlan2o@w3.org', 'jhyR395n}uD~TZ', 57.70, '2021-03-28 01:40:07'),
	('kjs3getm', 'Sylas', 'Lenton', 'slenton2c@privacy.gov.au', 'hlfK406lb', 870.07, '2018-10-17 00:02:14'),
	('lmopvjt6', 'Sibbie', 'McVitie', 'smcvitied@ihg.com', 'vxkZ7392&rk9VB&', 822.99, '2022-08-14 20:25:21'),
	('m6susavv', 'Dante', 'Callaghan', 'dcallaghan1o@dailymotion.com', 'kcoO0650ut!', 585.18, '2019-05-02 18:41:03'),
	('mlzhq9y9', 'Chloris', 'Kirvin', 'ckirvinl@cloudflare.com', 'avyH470+*IS.uDum', 911.92, '2015-05-29 15:30:19'),
	('mxcrurpz', 'Kirbie', 'Bernardon', 'kbernardon2r@weather.com', 'oueG326F+*1', 523.61, '2019-04-07 23:39:06'),
	('npbzfuk7', 'Trula', 'Ridsdale', 'tridsdalet@springer.com', 'qjzF683?4~|lWlJ', 737.29, '2019-02-11 02:29:25'),
	('obpw1ysw', 'De', 'Webbe', 'dwebbe8@miitbeian.gov.cn', 'arcY391p', 403.69, '2020-07-07 17:20:52'),
	('onb14sxe', 'Bing', 'Craigheid', 'bcraigheid1l@free.fr', 'jrwR709%', 547.58, '2022-09-04 08:06:49'),
	('oxoglcx6', 'Cecilla', 'MacCarrick', 'cmaccarrick1h@1und1.de', 'obzK992.$c', 177.17, '2018-04-07 00:05:29'),
	('p16wov2i', 'Hildagard', 'Alkin', 'halkin28@amazonaws.com', 'cevA6072ApWWIFkp', 508.56, '2022-10-12 01:41:40'),
	('pai106mc', 'Gage', 'Davidoff', 'gdavidoff1m@auda.org.au', 'dvgU483x6fk&', 65.32, '2017-11-26 09:45:01'),
	('patinrqa', 'Lynda', 'Wordley', 'lwordley1u@hatena.ne.jp', 'qcbW596Mv7cr{', 936.93, '2016-02-22 02:55:47'),
	('pd1pvdpm', 'Pierson', 'Fann', 'pfannf@jalbum.net', 'ilfG754uB<cD.', 774.05, '2019-03-06 12:15:04'),
	('pok7yr00', 'Elena', 'Huburn', 'ehuburn1j@admin.ch', 'uyhC078r', 42.95, '2017-04-12 05:50:37'),
	('pqtmiwoo', 'Willis', 'Ormston', 'wormston12@php.net', 'ejtO116=.dY', 322.16, '2022-12-23 23:20:29'),
	('pv543s8h', 'Nikolos', 'Stain', 'nstain4@weather.com', 'xdmH383v', 555.64, '2019-05-01 17:22:32'),
	('pxwjo155', 'Xavier', 'Sargerson', 'xsargerson0@newyorker.com', 'wweL911xGjfcg', 550.78, '2015-08-09 18:16:01'),
	('q099x056', 'Marley', 'Cabbell', 'mcabbellk@ftc.gov', 'ciqR997?', 407.76, '2021-10-06 19:10:31'),
	('q3vgyms7', 'Simon', 'Worcs', 'sworcso@si.edu', 'izlF623>', 873.19, '2019-02-24 10:25:47'),
	('qps1wi6b', 'Egor', 'Franzolini', 'efranzolini1g@imgur.com', 'gxbL017uczTqOX', 927.82, '2016-01-09 17:04:57'),
	('qsxsb3cu', 'Hendrick', 'Lorant', 'hlorant19@walmart.com', 'mkvZ387}V', 268.66, '2019-07-29 23:04:29'),
	('r290wvgx', 'Ewan', 'Cardiff', 'ecardiff2p@uiuc.edu', 'ptnR916x', 562.22, '2019-08-11 15:52:22'),
	('rxdq7aih', 'Eleni', 'Nyssens', 'enyssensa@nhs.uk', 'jrlL023F(pU8mN', 657.48, '2021-11-08 08:43:34'),
	('sa9bssv7', 'Bordy', 'Mullenger', 'bmullenger2j@cdc.gov', 'awgW827#a', 993.33, '2015-06-16 17:43:31'),
	('szfpzl4g', 'Nickey', 'Louche', 'nlouche1v@google.ru', 'ahtD9469#cyr', 446.72, '2016-10-06 15:52:55'),
	('t0u7bl8o', 'Danette', 'Gallahue', 'dgallahue5@gravatar.com', 'zmyT0235Hfug', 166.13, '2022-01-05 17:10:20'),
	('uctl2v9b', 'Boycie', 'Clench', 'bclench17@smh.com.au', 'bpwT641pk0', 216.52, '2016-05-02 08:01:05'),
	('ugm200dt', 'Livvyy', 'Thripp', 'lthripp2m@wordpress.org', 'uahO495o1', 697.85, '2017-11-09 16:02:08'),
	('v0a99umc', 'Claudine', 'Dalgety', 'cdalgety24@blogs.com', 'hwvU9038dU(wZuO/', 352.91, '2019-05-04 06:39:58'),
	('v1g43950', 'Ailee', 'Jeske', 'ajeskeh@pbs.org', 'idoA735+=l0V_D<=', 665.02, '2016-12-07 02:21:02'),
	('v1idhafw', 'Kristopher', 'Tollett', 'ktolletty@bloglines.com', 'xboV584RI=', 351.04, '2019-09-05 12:18:38'),
	('v22jdhe6', 'Anjanette', 'Bearcock', 'abearcock2b@uol.com.br', 'pucA442`F0p<', 111.61, '2021-08-10 18:39:40'),
	('v4m6vxyb', 'Gretna', 'Northbridge', 'gnorthbridgev@boston.com', 'mvrK078$`N', 91.47, '2016-01-19 08:40:52'),
	('v4sj7toz', 'Dorene', 'Merwede', 'dmerwede2d@about.com', 'axoZ847<p7CDR', 697.00, '2016-10-19 02:54:36'),
	('v6mdo8fa', 'Florence', 'Rushbury', 'frushbury2e@unblog.fr', 'ispW951mn', 441.74, '2020-05-03 23:26:15'),
	('veh56roh', 'Bobby', 'Dewis', 'bdewis1i@dagondesign.com', 'tpxD959!0', 423.72, '2018-07-09 08:42:31'),
	('vgi5c93u', 'Coriss', 'Fronczak', 'cfronczak29@symantec.com', 'vkqU431NcSW&/)', 982.43, '2016-09-10 01:54:14'),
	('vkqm2ucy', 'Cesar', 'Laetham', 'claetham2a@eventbrite.com', 'bxhU498qW+gX8', 980.27, '2021-03-23 20:48:55'),
	('vrn93dnp', 'Ashlie', 'Wilbor', 'awilborw@oracle.com', 'dokD925o', 280.06, '2016-11-09 05:34:16'),
	('vtufj691', 'Rachael', 'Wemes', 'rwemes14@tuttocitta.it', 'zlmT033qD5W|1Y_r', 960.04, '2015-12-25 23:18:40'),
	('vv8mivlu', 'Lazare', 'Hembry', 'lhembry9@paypal.com', 'wvvY485JYd..+a<', 603.75, '2018-11-16 09:48:55'),
	('wbchylz4', 'Engelbert', 'Worstall', 'eworstall11@instagram.com', 'waeS983Jxc>u', 132.40, '2017-06-28 10:52:29'),
	('x8uxayl7', 'Cami', 'Pepis', 'cpepise@howstuffworks.com', 'roxW686gz?f', 985.97, '2020-09-22 06:23:38'),
	('xdu0t1hs', 'Marrilee', 'Natte', 'mnatte22@about.com', 'xzlL068.wpJ', 617.58, '2017-07-10 14:49:11'),
	('xz6udjzq', 'Nicholas', 'Tzar', 'ntzar1y@quantcast.com', 'xxlV465oxegKM', 826.57, '2018-06-05 07:50:42'),
	('y83hpnke', 'Fernandina', 'Cowell', 'fcowell26@businessweek.com', 'ulwL4124u3y..Rg!', 104.00, '2015-02-27 19:00:37'),
	('yllegsqk', 'Zea', 'Harman', 'zharmanq@yahoo.co.jp', 'xluW046Ac1zip=', 726.29, '2017-12-15 21:50:41'),
	('yzab8u6e', 'Aleksandr', 'Starten', 'astarten1p@comcast.net', 'uxeB8479', 913.34, '2020-10-31 19:09:07'),
	('zi9smm20', 'Marcellina', 'Redmain', 'mredmain21@dot.gov', 'nnuC064bf~pG.', 447.31, '2022-09-21 21:44:49'),
	('zx1f9v5e', 'Sinclair', 'MacCome', 'smaccome1d@mlb.com', 'xbjQ694Em5{w@<C|', 941.67, '2017-07-01 18:26:18');

-- Dump della struttura di trigger beer.ifDateisNullonRegister
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `ifDateisNullonRegister` BEFORE INSERT ON `utente` FOR EACH ROW BEGIN
	-- Se l'utente non ha una data di registrazione, si assegna now()
	IF NEW.data_reg IS NULL THEN
		SET NEW.data_reg=NOW();
	END IF;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Dump della struttura di trigger beer.updateImporto
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `updateImporto` BEFORE INSERT ON `consumazione` FOR EACH ROW BEGIN
	DECLARE prezzo DECIMAL(6,2);
	-- Inserisco il costo della consumazione nella query
	SELECT prezzo_litro INTO prezzo FROM birra WHERE birra.id=NEW.beer_id;
	SET NEW.importo = NEW.quantita*prezzo/1000;
	-- Aggiorno il valore saldo nella tabella Utente sommando
	-- il prezzo della consumazione
	UPDATE utente SET saldo = saldo + NEW.importo WHERE id = NEW.user_id;

END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Dump della struttura di trigger beer.utente_before_insert
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `utente_before_insert` BEFORE INSERT ON `utente` FOR EACH ROW BEGIN
	-- Se id è omesso, ne creo uno e controllo eventuali duplicati prima di inserire
	DECLARE RandomId VARCHAR(8);
	DECLARE Corrispondenze INT;
   IF NEW.id IS NULL THEN
		REPEAT
         SET RandomId = SUBSTRING(MD5(RAND()), 1, 8);
      	SET Corrispondenze = (SELECT COUNT(*) FROM Utente WHERE id = RandomId);
      UNTIL Corrispondenze = 0 END REPEAT;        
            
      SET NEW.id = RandomId;
   END IF;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
