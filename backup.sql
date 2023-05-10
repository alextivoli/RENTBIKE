-- MySQL dump 10.13  Distrib 8.0.25, for Linux (aarch64)
--
-- Host: localhost    Database: bikerent
-- ------------------------------------------------------
-- Server version	8.0.25-0ubuntu0.20.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `bike`
--

DROP TABLE IF EXISTS `bike`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bike` (
  `IDbike` int NOT NULL AUTO_INCREMENT,
  `nTelaio` char(20) NOT NULL,
  `brand` varchar(20) NOT NULL,
  `model` varchar(20) NOT NULL,
  `available` char(1) NOT NULL DEFAULT 'Y',
  `datePurchase` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `bSize` char(1) NOT NULL,
  `km` float(8,2) NOT NULL DEFAULT '0.00',
  `cost` float(8,2) NOT NULL,
  `type` varchar(8) NOT NULL,
  `rentCost` float(8,2) NOT NULL DEFAULT '30.00',
  PRIMARY KEY (`IDbike`),
  UNIQUE KEY `nTelaio` (`nTelaio`),
  CONSTRAINT `bike_chk_1` CHECK (((`available` = _utf8mb4'Y') or (`available` = _utf8mb4'M') or (`available` = _utf8mb4'N'))),
  CONSTRAINT `bike_chk_2` CHECK (((`bSize` = _utf8mb4'K') or (`bSize` = _utf8mb4'S') or (`bSize` = _utf8mb4'M') or (`bSize` = _utf8mb4'L'))),
  CONSTRAINT `bike_chk_3` CHECK ((`cost` > 0))
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bike`
--

LOCK TABLES `bike` WRITE;
/*!40000 ALTER TABLE `bike` DISABLE KEYS */;
INSERT INTO `bike` VALUES (1,'ABCDEFGHI1234','Merida','e-One Sixty 800','Y','2021-03-05 23:33:15','M',0.00,3000.00,'tour',50.00),(2,'GTSDBOTYN2409','Merida','e-One Sixty 800','Y','2021-03-05 23:35:33','S',0.01,2000.00,'tour',30.00),(3,'QPOEFNSHT4556','Merida','e-One Sixty 900','Y','2021-03-05 23:37:12','L',0.00,3000.00,'top',40.00),(4,'LKIJDERGV9081','Merida','e-One Sixty 500','Y','2021-03-05 23:38:04','S',2.95,2500.00,'tour',35.00),(5,'ABCDEFGHI6784','Merida','e-One Sixty 800','Y','2021-03-09 18:29:28','S',0.00,3000.00,'tour',45.00),(6,'LKIJDERGV9345','Merida','e-One Sixty 500','Y','2021-03-11 16:03:34','M',0.00,5000.00,'tour',30.00),(8,'WVWR56','merida','model one','Y','2021-05-13 09:04:14','S',0.00,4500.00,'tour',45.00),(9,'WVWEV','Merida','model one','Y','2021-05-13 09:23:38','S',0.00,2144.00,'tour',34.00),(10,'ERBRR353','Merida','model two','Y','2021-05-13 09:27:06','S',0.00,2144.00,'tour',56.00),(11,'WREVERV','Merida','model two','Y','2021-05-13 09:29:45','S',0.00,2144.00,'tour',56.00),(12,'RETBTB','Merida','model two','Y','2021-05-13 09:30:40','S',0.00,2144.00,'tour',56.00),(13,'QPOEFNSHT45779','Merida','e-One Sixty 500','Y','2021-05-13 09:35:11','L',0.00,3456.00,'tour',23.00),(14,'QPOEFNSHT4334','Merida','e-One Sixty 500','Y','2021-05-13 09:42:58','S',0.00,2345.00,'tour',23.00),(15,'WEFEW2324','piaggio','model one','Y','2021-05-13 15:32:54','S',0.00,2654.00,'tour',45.00),(16,'ESVWRG34','piaggio','model two','Y','2021-05-13 15:39:00','S',0.00,3245.00,'tour',22.00),(17,'ESVWRG35','piaggio','model two','Y','2021-05-13 15:41:10','S',0.00,3245.00,'tour',22.00),(18,'ESVWRG37','piaggio','model two','Y','2021-05-13 15:42:01','S',24.52,3245.00,'tour',22.00),(19,'ASRV4V4','piaggio','model four','Y','2021-05-13 15:54:45','S',0.00,2124.00,'tour',23.00),(20,'WRRGERBEB43','merida','modello 10','Y','2021-05-13 16:01:11','S',0.00,4565.00,'tour',12.00);
/*!40000 ALTER TABLE `bike` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `booking`
--

DROP TABLE IF EXISTS `booking`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `booking` (
  `IDbooking` int NOT NULL AUTO_INCREMENT,
  `dateBook` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `cfUser` char(16) NOT NULL,
  `costTotal` float(8,2) NOT NULL,
  `idCoupon` int DEFAULT NULL,
  PRIMARY KEY (`IDbooking`),
  KEY `cfUser` (`cfUser`),
  KEY `idCoupon` (`idCoupon`),
  CONSTRAINT `booking_ibfk_1` FOREIGN KEY (`cfUser`) REFERENCES `client` (`cf`),
  CONSTRAINT `booking_ibfk_2` FOREIGN KEY (`idCoupon`) REFERENCES `coupon` (`IDcoupon`),
  CONSTRAINT `booking_chk_1` CHECK ((`costTotal` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=234 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `booking`
--

LOCK TABLES `booking` WRITE;
/*!40000 ALTER TABLE `booking` DISABLE KEYS */;
INSERT INTO `booking` VALUES (23,'2021-04-28 20:36:01','TVLLXA98P03G337R',125.00,NULL),(24,'2021-04-28 20:42:22','TVLLXA98P03G337R',115.00,50),(25,'2021-04-28 20:46:03','TVLLXA98P03G337R',80.00,NULL),(26,'2021-04-28 20:49:42','TVLLXA98P03G337R',160.00,NULL),(27,'2021-04-28 20:56:37','TVLLXA98P03G337R',80.00,NULL),(28,'2021-04-28 21:02:31','TVLLXA98P03G337R',80.00,NULL),(29,'2021-04-28 21:09:35','TVLLXA98P03G337R',80.00,NULL),(30,'2021-04-28 21:18:57','TVLLXA98P03G337R',50.00,NULL),(31,'2021-05-04 17:27:31','TVLLXA98P03G337R',50.00,NULL),(32,'2021-05-05 20:47:43','TVLLXA98P03G337R',50.00,NULL),(33,'2021-05-05 20:50:59','TVLLXA98P03G337R',50.00,NULL),(34,'2021-05-05 20:54:25','TVLLXA98P03G337R',50.00,NULL),(35,'2021-05-05 20:58:34','TVLLXA98P03G337R',50.00,NULL),(37,'2021-05-05 20:59:55','TVLLXA98P03G337R',50.00,NULL),(38,'2021-05-05 21:03:57','TVLLXA98P03G337R',30.00,NULL),(39,'2021-05-05 21:08:47','TVLLXA98P03G337R',30.00,NULL),(40,'2021-05-05 22:41:33','TVLLXA98P03G337R',40.00,NULL),(41,'2021-05-05 22:43:39','TVLLXA98P03G337R',35.00,NULL),(42,'2021-05-06 08:00:45','BRTMTT99C28H223X',30.00,NULL),(43,'2021-05-06 08:21:22','BRTMTT99C28H223X',50.00,NULL),(44,'2021-05-06 08:29:53','BRTMTT99C28H223X',30.00,NULL),(45,'2021-05-06 20:58:51','TVLLXA98P03G337R',45.00,NULL),(46,'2021-05-10 22:05:37','BRTMTT99C28H223X',80.00,NULL),(47,'2021-05-10 22:06:23','BRTMTT99C28H223X',0.00,NULL),(48,'2021-05-10 22:06:26','BRTMTT99C28H223X',0.00,NULL),(49,'2021-05-10 22:06:28','BRTMTT99C28H223X',0.00,NULL),(50,'2021-05-10 22:06:32','BRTMTT99C28H223X',0.00,NULL),(51,'2021-05-10 22:06:39','BRTMTT99C28H223X',0.00,NULL),(52,'2021-05-10 22:06:40','BRTMTT99C28H223X',0.00,NULL),(53,'2021-05-10 22:06:42','BRTMTT99C28H223X',0.00,NULL),(54,'2021-05-10 22:06:43','BRTMTT99C28H223X',0.00,NULL),(55,'2021-05-10 22:06:44','BRTMTT99C28H223X',0.00,NULL),(56,'2021-05-10 22:06:45','BRTMTT99C28H223X',0.00,NULL),(57,'2021-05-14 21:46:59','TVLLXA98P03G337R',80.00,NULL),(58,'2021-05-14 22:01:13','TVLLXA98P03G337R',50.00,NULL),(59,'2021-05-14 22:11:35','TVLLXA98P03G337R',105.00,NULL),(60,'2021-05-16 22:49:06','TVLLXA98P03G337R',120.00,NULL),(61,'2021-05-17 22:12:20','BRTMTT99C28H223X',70.00,NULL),(62,'2021-05-21 21:07:35','TVLLXA98P03G337R',240.00,NULL),(63,'2021-05-23 20:40:43','TVLLXA98P03G337R',250.00,NULL),(64,'2021-05-23 21:48:47','TVLLXA98P03G337R',360.00,NULL),(65,'2021-05-24 21:51:14','TVLLXA98P03G337R',192.00,NULL),(66,'2021-05-25 17:06:26','TVLLXA98P03G337R',90.00,NULL),(67,'2021-05-26 21:35:03','TVLLXA98P03G337R',180.00,NULL),(68,'2021-05-27 22:02:32','TVLLXA98P03G337R',240.00,NULL),(69,'2021-05-29 21:56:20','TVLLXA98P03G337R',225.00,NULL),(70,'2021-06-09 13:06:13','TVLLXA98P03G337R',80.00,NULL),(71,'2021-06-09 13:10:56','TVLLXA98P03G337R',50.00,NULL),(72,'2021-06-09 13:22:41','BRTMTT99C28H223X',75.00,NULL),(73,'2021-06-09 13:25:23','BRTMTT99C28H223X',75.00,NULL),(74,'2021-06-09 13:27:36','BRTMTT99C28H223X',79.00,NULL),(75,'2021-06-09 13:29:37','BRTMTT99C28H223X',112.00,NULL),(76,'2021-06-09 13:30:57','BRTMTT99C28H223X',79.00,NULL),(77,'2021-06-09 13:37:00','BRTMTT99C28H223X',68.00,NULL),(78,'2021-06-09 13:44:09','BRTMTT99C28H223X',44.00,NULL),(79,'2021-06-09 13:54:23','BRTMTT99C28H223X',70.00,NULL),(80,'2021-06-09 13:55:24','BRTMTT99C28H223X',80.00,NULL),(81,'2021-06-09 13:59:31','BRTMTT99C28H223X',75.00,NULL),(82,'2021-06-09 14:02:09','BRTMTT99C28H223X',45.00,NULL),(83,'2021-06-09 14:04:58','BRTMTT99C28H223X',34.00,NULL),(84,'2021-06-09 14:05:57','BRTMTT99C28H223X',360.00,NULL),(85,'2021-06-09 14:11:40','TVLLXA98P03G337R',50.00,NULL),(86,'2021-06-11 11:17:03','BRTMTT99C28H223X',15.00,65),(87,'2021-06-11 21:14:44','TVLLXA98P03G337R',70.00,NULL),(88,'2021-06-11 22:22:53','TVLLXA98P03G337R',80.00,NULL),(89,'2021-06-13 20:34:09','TVLLXA98P03G337R',140.00,NULL),(90,'2021-06-13 21:08:39','BRTMTT99C28H223X',35.00,NULL),(91,'2021-06-13 22:22:08','TVLLXA98P03G337R',35.00,NULL),(92,'2021-06-15 20:35:59','TVLLXA98P03G337R',310.00,NULL),(93,'2021-06-17 21:07:39','TVLLXA98P03G337R',160.00,NULL),(94,'2021-06-17 21:09:47','FRRPRI99H16H223X',45.00,NULL),(95,'2021-06-19 07:54:37','TVLLXA98P03G337R',80.00,NULL),(96,'2021-06-19 08:20:05','TVLLXA98P03G337R',75.00,NULL),(97,'2021-06-21 20:44:03','TVLLXA98P03G337R',240.00,NULL),(98,'2021-06-22 20:40:43','TVLLXA98P03G337R',160.00,NULL),(99,'2021-06-23 20:49:30','TVLLXA98P03G337R',160.00,NULL),(100,'2021-06-24 22:12:51','TVLLXA98P03G337R',320.00,NULL),(101,'2021-06-24 22:16:15','TVLLXA98P03G337R',300.00,NULL),(102,'2021-07-01 21:36:15','TVLLXA98P03G337R',160.00,NULL),(103,'2021-07-01 22:31:06','TVLLXA98P03G337R',110.00,NULL),(104,'2021-07-01 22:32:56','TVLLXA98P03G337R',190.00,NULL),(105,'2021-07-01 22:38:09','TVLLXA98P03G337R',64.00,NULL),(106,'2021-07-01 22:39:51','TVLLXA98P03G337R',90.00,NULL),(107,'2021-07-01 22:41:44','TVLLXA98P03G337R',80.00,NULL),(108,'2021-07-01 22:47:51','TVLLXA98P03G337R',80.00,NULL),(109,'2021-07-01 22:49:56','TVLLXA98P03G337R',56.00,NULL),(110,'2021-07-04 13:49:20','TVLLXA98P03G337R',160.00,NULL),(111,'2021-07-05 08:42:49','TVLLXA98P03G337R',120.00,NULL),(112,'2021-07-05 08:50:37','TVLLXA98P03G337R',30.00,NULL),(113,'2021-07-05 08:51:48','TVLLXA98P03G337R',0.00,NULL),(114,'2021-07-05 08:51:53','TVLLXA98P03G337R',0.00,NULL),(115,'2021-07-05 08:52:46','TVLLXA98P03G337R',0.00,NULL),(116,'2021-07-05 08:53:59','TVLLXA98P03G337R',0.00,NULL),(117,'2021-07-05 08:55:36','TVLLXA98P03G337R',0.00,NULL),(118,'2021-07-05 08:55:39','TVLLXA98P03G337R',0.00,NULL),(119,'2021-07-05 08:57:55','TVLLXA98P03G337R',0.00,NULL),(120,'2021-07-05 08:58:18','TVLLXA98P03G337R',0.00,NULL),(121,'2021-07-05 09:00:09','TVLLXA98P03G337R',0.00,NULL),(122,'2021-07-05 09:00:25','TVLLXA98P03G337R',0.00,NULL),(123,'2021-07-05 09:00:57','TVLLXA98P03G337R',0.00,NULL),(124,'2021-07-05 09:03:57','TVLLXA98P03G337R',0.00,NULL),(125,'2021-07-05 09:06:15','TVLLXA98P03G337R',0.00,NULL),(126,'2021-07-05 09:07:35','TVLLXA98P03G337R',0.00,NULL),(127,'2021-07-05 09:07:39','TVLLXA98P03G337R',0.00,NULL),(128,'2021-07-05 09:08:27','TVLLXA98P03G337R',0.00,NULL),(129,'2021-07-05 09:10:02','TVLLXA98P03G337R',0.00,NULL),(130,'2021-07-05 09:16:50','TVLLXA98P03G337R',45.00,NULL),(131,'2021-07-05 09:18:31','TVLLXA98P03G337R',34.00,NULL),(132,'2021-07-05 09:21:24','TVLLXA98P03G337R',0.00,NULL),(133,'2021-07-05 09:21:45','TVLLXA98P03G337R',0.00,NULL),(134,'2021-07-05 09:22:50','TVLLXA98P03G337R',56.00,NULL),(135,'2021-07-05 09:51:42','BRTMTT99C28H223X',30.00,NULL),(136,'2021-07-05 09:52:10','BRTMTT99C28H223X',0.00,NULL),(137,'2021-07-05 09:57:57','TVLLXA98P03G337R',30.00,NULL),(138,'2021-07-05 09:58:26','BRTMTT99C28H223X',30.00,NULL),(139,'2021-07-05 15:34:46','BRTMTT99C28H223X',35.00,NULL),(140,'2021-07-05 15:49:39','TVLLXA98P03G337R',56.00,NULL),(141,'2021-07-05 15:50:34','TVLLXA98P03G337R',50.00,NULL),(142,'2021-07-05 16:03:12','TVLLXA98P03G337R',56.00,NULL),(143,'2021-07-05 16:19:43','TVLLXA98P03G337R',40.00,NULL),(144,'2021-07-05 16:22:59','TVLLXA98P03G337R',23.00,NULL),(145,'2021-07-05 16:25:18','TVLLXA98P03G337R',23.00,NULL),(146,'2021-07-05 16:26:10','TVLLXA98P03G337R',45.00,NULL),(147,'2021-07-05 16:28:05','TVLLXA98P03G337R',22.00,NULL),(148,'2021-07-05 16:30:36','TVLLXA98P03G337R',22.00,NULL),(149,'2021-07-05 16:34:35','BRTMTT99C28H223X',12.00,NULL),(150,'2021-07-05 16:49:42','TVLLXA98P03G337R',10.00,62),(151,'2021-07-05 17:00:34','TVLLXA98P03G337R',23.00,NULL),(152,'2021-07-05 17:02:22','TVLLXA98P03G337R',12.00,NULL),(153,'2021-07-05 17:04:24','TVLLXA98P03G337R',35.00,NULL),(154,'2021-07-05 17:06:14','TVLLXA98P03G337R',45.00,NULL),(155,'2021-07-05 17:29:25','BRTMTT99C28H223X',30.00,NULL),(156,'2021-07-05 17:29:44','TVLLXA98P03G337R',30.00,NULL),(157,'2021-07-05 17:32:13','BRTMTT99C28H223X',45.00,NULL),(158,'2021-07-05 17:41:11','BRTMTT99C28H223X',45.00,NULL),(159,'2021-07-05 17:41:25','TVLLXA98P03G337R',45.00,NULL),(160,'2021-07-05 17:46:02','BRTMTT99C28H223X',34.00,NULL),(161,'2021-07-05 17:46:21','TVLLXA98P03G337R',34.00,NULL),(162,'2021-07-05 17:48:13','BRTMTT99C28H223X',56.00,NULL),(163,'2021-07-05 17:48:26','TVLLXA98P03G337R',56.00,NULL),(164,'2021-07-05 17:50:06','BRTMTT99C28H223X',56.00,NULL),(165,'2021-07-05 17:51:14','TVLLXA98P03G337R',56.00,NULL),(166,'2021-07-05 18:04:51','BRTMTT99C28H223X',56.00,NULL),(167,'2021-07-05 18:17:24','BRTMTT99C28H223X',23.00,NULL),(168,'2021-07-05 21:33:45','TVLLXA98P03G337R',23.00,NULL),(169,'2021-07-05 21:34:01','BRTMTT99C28H223X',23.00,NULL),(170,'2021-07-05 21:38:14','BRTMTT99C28H223X',12.00,NULL),(171,'2021-07-05 21:42:34','TVLLXA98P03G337R',23.00,NULL),(172,'2021-07-05 21:43:17','BRTMTT99C28H223X',23.00,NULL),(173,'2021-07-05 21:45:23','TVLLXA98P03G337R',45.00,NULL),(174,'2021-07-05 21:45:42','BRTMTT99C28H223X',45.00,NULL),(175,'2021-07-05 21:48:59','BRTMTT99C28H223X',22.00,NULL),(176,'2021-07-05 21:50:01','TVLLXA98P03G337R',22.00,NULL),(178,'2021-07-05 21:54:37','TVLLXA98P03G337R',22.00,NULL),(180,'2021-07-05 21:58:12','TVLLXA98P03G337R',23.00,NULL),(182,'2021-07-05 22:10:07','TVLLXA98P03G337R',50.00,NULL),(183,'2021-07-05 22:10:21','BRTMTT99C28H223X',50.00,NULL),(184,'2021-07-05 22:22:39','TVLLXA98P03G337R',30.00,NULL),(185,'2021-07-05 22:28:20','TVLLXA98P03G337R',40.00,NULL),(187,'2021-07-05 22:34:14','BRTMTT99C28H223X',35.00,NULL),(188,'2021-07-05 22:35:44','TVLLXA98P03G337R',45.00,NULL),(190,'2021-07-05 22:41:31','TVLLXA98P03G337R',30.00,NULL),(192,'2021-07-05 22:59:25','TVLLXA98P03G337R',45.00,NULL),(193,'2021-07-05 23:02:38','TVLLXA98P03G337R',45.00,NULL),(194,'2021-07-05 23:09:23','TVLLXA98P03G337R',34.00,NULL),(196,'2021-07-05 23:16:24','TVLLXA98P03G337R',56.00,NULL),(199,'2021-07-05 23:20:34','TVLLXA98P03G337R',56.00,NULL),(200,'2021-07-05 23:22:09','TVLLXA98P03G337R',56.00,NULL),(202,'2021-07-05 23:26:34','TVLLXA98P03G337R',23.00,NULL),(204,'2021-07-06 14:04:21','TVLLXA98P03G337R',11.00,63),(205,'2021-07-06 14:37:41','TVLLXA98P03G337R',50.00,NULL),(206,'2021-07-06 16:08:14','TVLLXA98P03G337R',45.00,NULL),(207,'2021-07-06 16:09:51','TVLLXA98P03G337R',0.00,75),(208,'2021-07-06 16:11:45','BRTMTT99C28H223X',0.00,79),(209,'2021-07-06 16:25:59','TVLLXA98P03G337R',0.00,73),(210,'2021-07-06 16:31:22','TVLLXA98P03G337R',22.00,NULL),(211,'2021-07-07 14:15:25','TVLLXA98P03G337R',30.00,NULL),(212,'2021-07-07 18:28:21','BRTMTT99C28H223X',529.00,NULL),(213,'2021-07-07 20:45:16','BRTMTT99C28H223X',33.00,69),(214,'2021-07-07 21:04:57','TVLLXA98P03G337R',40.00,NULL),(215,'2021-07-07 21:06:01','TVLLXA98P03G337R',35.00,NULL),(216,'2021-07-07 21:07:10','TVLLXA98P03G337R',45.00,NULL),(217,'2021-07-07 21:11:10','TVLLXA98P03G337R',30.00,NULL),(218,'2021-07-07 21:18:56','TVLLXA98P03G337R',45.00,NULL),(219,'2021-07-08 20:46:30','TVLLXA98P03G337R',56.00,NULL),(220,'2021-07-09 18:10:28','VNTLSN98H19G337S',34.00,NULL),(221,'2021-07-09 18:12:09','VNTLSN98H19G337S',40.00,NULL),(222,'2021-07-10 21:14:20','BRTMTT99C28H223Y',56.00,NULL),(223,'2021-07-11 12:49:56','TVLLXA98P03G337R',70.00,NULL),(224,'2021-07-11 12:55:55','TVLLXA98P03G337R',30.00,NULL),(225,'2021-07-11 12:58:09','TVLLXA98P03G337R',35.00,NULL),(226,'2021-07-12 12:22:22','TVLLXA98P03G337R',30.00,NULL),(227,'2021-07-12 13:45:37','FNLMTT99P03G337S',40.00,NULL),(228,'2021-07-12 15:37:15','TVLLXE34K05G443T',35.00,NULL),(229,'2021-07-12 16:06:53','TVLLXE34K05G443T',45.00,NULL),(230,'2021-07-13 12:36:17','BRTMTT99C28H223X',50.00,NULL),(231,'2021-07-13 12:39:33','TVLLXA98P03G334H',30.00,NULL),(232,'2021-07-13 13:53:11','TVLLXA98P03G334H',40.00,NULL),(233,'2021-07-13 14:52:44','PSNNDR99M09L452V',35.00,NULL);
/*!40000 ALTER TABLE `booking` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `client`
--

DROP TABLE IF EXISTS `client`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `client` (
  `cf` char(16) NOT NULL,
  `name` varchar(20) NOT NULL,
  `surname` varchar(20) NOT NULL,
  `mail` varchar(30) NOT NULL,
  `phone` varchar(13) DEFAULT NULL,
  `password` varchar(70) DEFAULT NULL,
  `birthday` date DEFAULT NULL,
  `address` varchar(40) DEFAULT NULL,
  `dateRegistration` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `forgotpsw` varchar(5) DEFAULT NULL,
  PRIMARY KEY (`cf`),
  UNIQUE KEY `mail` (`mail`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `client`
--

LOCK TABLES `client` WRITE;
/*!40000 ALTER TABLE `client` DISABLE KEYS */;
INSERT INTO `client` VALUES ('BRTFPP02H29H223O','Filippo','Bertolini','filloberto02@gmail.com','3405016520','filloberto','2002-06-29','Via Lanzi 2/1','2021-03-23 19:24:16',NULL),('BRTLCU71T51H223V','Lucia ','Bertolini','luciabertolini11@gmail.com','3894955124','lucia71','1971-12-11','Via Valentino Lanzi','2021-03-30 22:01:47',NULL),('BRTMTT99C28H223X','Matteo','Bertolini','poldomatti@yahoo.it','3894955124','a165dd3c2e98d5d607181d0b87a4c66b','1999-03-28','Via Lanzi 2/1','2021-03-05 23:26:21',NULL),('BRTMTT99C28H223Y','Mike','Mike','biancomichael26@libero.it','3894955124','4503c2e01dec0c439580a9a260b3df11','2000-09-26','Via Valentino Lanzi 2/1','2021-07-10 21:11:55',NULL),('FNLMTT99P03G337S','mattia','fanelli','mattiphone3999@gmail.com','3457445856','38fe8951595f01a3c16f3d50ea0bcc53','1999-03-09','via matti fanelli','2021-07-12 13:45:03',NULL),('FRRPRI99H16H223X','Pier','Ferrari','pierferrari6@gmail.com','3663077977','cerretolaghi','1999-06-16','Via san Francesco 6/4','2021-06-17 21:07:41',NULL),('PSNNDR99M09L452V','Andrea','Pisani','aptrp99@gmail.com','3333333333','d0333f9f24bac25982926edf542924d0','2021-07-05','Via Germano Mosconi 18','2021-07-05 21:24:57',NULL),('RMLFNC99P08F463A','Francesco ','Ramolini ','ramolinif@gmail.com','3890418038','8cbd328ebf65f30f4b1f43015e8c7d77','1999-09-08','Enzo landi ','2021-07-06 15:59:56',NULL),('TGLLXA98R03T334F','alex','cipolla','sdfghj@gmail.com','3454574745','ciaociao','2023-02-02','via ciao','2021-05-03 22:06:01',NULL),('TVLLDE34J04G334T','matisse','cagnolino','mattissolo99@gmail.com','3454744125','951c4202ebc69207fe8f7a04599dae8a','2018-07-17','via crocchettte','2021-07-04 21:56:46',NULL),('TVLLXA98P03G334E','SANDO','KAN','sandokan@gmail.com','3454745458','alex','2021-05-26','via ciao ciao','2021-05-16 22:55:22',NULL),('TVLLXA98P03G334F','matisse','cagnolino','maticane@libero.it','345457454856','ciaociao','2021-04-13','via ciao ciao','2021-04-28 20:32:25',NULL),('TVLLXA98P03G334H','alex','sandokan','alextivoli98@gmail.com','39645745856','pappaina','2025-06-01','via ciao','2021-05-03 21:55:56',NULL),('TVLLXA98P03G334W','ciao','ciaoee','wejnwrug@libero.it','3457447445','ciao','2021-05-26','via ciao','2021-05-09 21:37:44',NULL),('TVLLXA98P03G335L','ciao','ciao','ASDFGG@GMAIL.COM','3525447456','ciaociao','2021-05-04','VIA CIAO','2021-05-03 22:08:38',NULL),('TVLLXA98P03G337R','Alex','Tivoli','al.tivoli@libero.it','3934761091','911d3bc6113431c90341fcbe35f509f9','2002-08-02','via paradigna','2021-04-22 20:41:27',NULL),('TVLLXE34K05G443T','Marco','Santo','alextivoli@icloud.com','3544744744','911d3bc6113431c90341fcbe35f509f9','1996-05-14','via cipolla 67','2021-05-09 12:53:08',NULL),('VNTLSN98H19G337S','alessandro','ventura','alessandroventura981@yahoo.com','3394578259','e996cbd653abc0590f3e448ef5ad9753','1993-06-02','via luigi franco 4','2021-07-09 18:03:33',NULL);
/*!40000 ALTER TABLE `client` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `clientPeer`
--

DROP TABLE IF EXISTS `clientPeer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clientPeer` (
  `idClPeer` int NOT NULL AUTO_INCREMENT,
  `idSpecBook` int DEFAULT NULL,
  `idPeer` varchar(50) NOT NULL,
  `lastLng` double DEFAULT NULL,
  `lastLat` double DEFAULT NULL,
  `idActive` bit(1) NOT NULL DEFAULT b'1',
  `sosEnable` bit(1) NOT NULL DEFAULT b'0',
  `unlockId` bit(1) NOT NULL DEFAULT b'0',
  `role` char(1) NOT NULL DEFAULT 'C',
  `notes` varchar(300) DEFAULT NULL,
  PRIMARY KEY (`idClPeer`),
  KEY `idSpecBook` (`idSpecBook`),
  CONSTRAINT `clientPeer_ibfk_1` FOREIGN KEY (`idSpecBook`) REFERENCES `specsbook` (`IDspecBook`),
  CONSTRAINT `clientPeer_chk_1` CHECK (((`role` = _utf8mb4'C') or (`role` = _utf8mb4'A') or (`role` = _utf8mb4'S') or (`role` = _utf8mb4'F')))
) ENGINE=InnoDB AUTO_INCREMENT=222 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clientPeer`
--

LOCK TABLES `clientPeer` WRITE;
/*!40000 ALTER TABLE `clientPeer` DISABLE KEYS */;
INSERT INTO `clientPeer` VALUES (14,NULL,'e569c21b-a673-49ac-a4cb-228885479ce6',NULL,NULL,_binary '',_binary '\0',_binary '\0','S',NULL),(28,64,'4453f31f-7fdf-4901-9be8-2b1d71fc959e',10.492313385009766,44.63656997680664,_binary '',_binary '\0',_binary '\0','C',NULL),(29,65,'87fe00dd-80d3-476a-bb92-dbbb5d8d3157',10.343710899353027,44.836082458496094,_binary '\0',_binary '\0',_binary '\0','C',NULL),(30,73,'c335a9cd-c2da-44f3-89d6-6828259f5eb5',10.492313385009766,44.63656997680664,_binary '\0',_binary '\0',_binary '\0','A',NULL),(31,74,'a57639dd-e50c-462a-94ba-1b08d80ad280',10.343709945678711,44.83608627319336,_binary '',_binary '\0',_binary '\0','C',NULL),(32,NULL,'09c072fe-7c8d-4d0a-bdc0-ff3549962281',NULL,NULL,_binary '',_binary '\0',_binary '\0','F','poldomatti@yahoo.it'),(33,75,'a7ff8e16-0521-4c0c-af4b-c29dcf647772',11.218639373779297,44.59675979614258,_binary '',_binary '\0',_binary '\0','C',NULL),(34,76,'7be98b93-815b-4707-84d0-18e444d9d71d',10.3436918258667,44.836082458496094,_binary '',_binary '\0',_binary '\0','C',NULL),(35,77,'2a2b0c98-a899-4ebb-a0b2-7dba3d0bb462',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(36,78,'810fda48-414b-4ecd-8772-42f79eb1f1e7',10.33482837677002,44.8401985168457,_binary '',_binary '\0',_binary '\0','C',NULL),(37,79,'b8fcd7cc-fb03-4537-9b9a-3e68b4afa768',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(38,80,'c7e6b7e2-3f74-4353-82fe-846c1cf7f6a0',10.492313385009766,44.63656997680664,_binary '',_binary '\0',_binary '\0','C',NULL),(39,81,'f5a15cc5-2a4f-4077-8380-ab562b1f9802',10.344127655029297,44.835811614990234,_binary '',_binary '\0',_binary '\0','C',NULL),(40,82,'a9548343-546a-42ea-86c4-d388c95676e4',11.218639373779297,44.59675979614258,_binary '',_binary '\0',_binary '\0','C',NULL),(41,83,'28b0785e-5b9d-4556-ad48-8b004461ddca',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(42,84,'e357fb9e-b6d2-4102-8cf3-4a1e3dc21ff5',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(43,85,'2b5be27a-3fb3-4115-9faf-a6948c2d8146',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(44,86,'25214692-9131-428c-8803-9f8572d1716f',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(45,87,'c8f12d5c-d1ba-48ed-a25e-36266e9fe367',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(46,88,'9ec69982-60f6-4635-964e-903df62297db',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(47,89,'a250c7a7-3d25-405d-a3d9-634164603b63',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(48,90,'ad017a33-b4ce-4b80-a789-cca7e7ec5ca2',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(49,91,'98501008-b16f-4fc3-8035-3dc29afde3f2',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(50,92,'af48fa05-4998-430c-a0be-893d745d3afe',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(51,93,'e6d1c434-be4c-411e-a813-ef65a8f3c6c3',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(52,94,'2de853d9-a8b1-4f1f-8931-827887c1e0fb',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(53,95,'87a59fc2-7f55-4472-b4b7-1c0f1004c59f',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(54,96,'28a059ab-6b9e-4452-8a90-6b785c9a20a2',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(55,97,'6cf085cc-2d13-440e-8fb0-7f43758acb29',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(56,98,'87dc19b9-3add-4932-9e1a-0eb9515b41be',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(57,99,'5226148e-5827-48b8-9880-1d24a3808ee5',10.33482837677002,44.8401985168457,_binary '',_binary '\0',_binary '\0','C',NULL),(58,100,'d21276d2-a319-47ca-a652-42c995442052',10.343703269958496,44.83609390258789,_binary '',_binary '\0',_binary '\0','C',NULL),(59,101,'b79230a0-47e8-4b6d-80c7-103f5b8efc76',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(60,102,'347e8cc8-89ca-4729-9b7f-592e78e5994b',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(61,103,'0463c22d-c045-437e-afbd-7026857fd9ec',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(62,104,'3a6384d1-f037-4417-8f08-4f04dc512199',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(63,105,'276d32dc-71f8-4936-8d3f-3e6f5b84526b',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(64,106,'df47bdb4-7b73-4266-87d8-463c129549f5',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(65,107,'82a84647-0d49-4579-8ba8-c94c96cdc539',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(66,108,'ace45d95-a795-47d8-afbe-95ca00052b4e',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(67,109,'028356ad-946e-4f1f-8b26-8e76669dcafb',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(68,110,'47fa7daf-d626-4d73-b558-a61aa6dca0a9',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(69,111,'0fff7f4b-82a0-4744-bd05-768162c7ba0a',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(70,112,'3742214e-0488-4bb2-8bbd-4bfea3c345dd',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(71,113,'87657e11-209c-4bb6-acee-069364b7c078',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(72,114,'f3646111-23f3-46fa-a7be-b20744006cd3',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(73,115,'0e93f190-6bfd-42d1-ab1b-d29f2558b0e4',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(74,116,'e332d91b-fa8d-4d7d-a4ad-77116da24217',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(75,117,'21378397-9d07-440a-a9a5-1cd9280359c2',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(76,118,'fb87863e-0dd4-4d2e-819c-bd37c22afed0',10.343707084655762,44.836097717285156,_binary '',_binary '\0',_binary '\0','C',NULL),(77,119,'76e23c3a-87db-404d-b0fc-508b0ccd5361',10.33482837677002,44.8401985168457,_binary '\0',_binary '\0',_binary '\0','A','poldomatti@yahoo.it'),(81,123,'69720405-b87d-43ea-9af0-dcaddb3bec2f',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(82,124,'508b740c-944e-460f-a107-ec1ce86832a5',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(83,125,'c61e2e29-dcd3-447d-b35f-91691dd00830',10.33482837677002,44.8401985168457,_binary '',_binary '\0',_binary '\0','C',NULL),(84,126,'a84e8e2f-ac65-4711-b578-52806bf2b405',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(85,127,'43bf676b-7471-4078-9db8-02bf35865050',10.343704223632812,44.836097717285156,_binary '',_binary '\0',_binary '\0','C',NULL),(86,128,'7638f300-56a9-4083-8745-ba1598ce6993',10.343709945678711,44.83605194091797,_binary '',_binary '\0',_binary '\0','C',NULL),(87,129,'ca2f4d69-0834-465b-ae27-19622a46d2dc',10.343724250793457,44.836063385009766,_binary '\0',_binary '\0',_binary '\0','C',NULL),(88,130,'1fd3f521-3e7a-4db7-ab5a-5eded3c43d74',9.845243453979492,45.479068756103516,_binary '\0',_binary '\0',_binary '\0','C',NULL),(89,131,'f7add39b-9ece-4793-8b66-e55455d9786b',10.34371280670166,44.836097717285156,_binary '\0',_binary '\0',_binary '\0','A','poldomatti@yahoo.it'),(90,132,'1b0540c6-b72c-4b00-923f-d38da24dfbaf',10.343709945678711,44.836063385009766,_binary '\0',_binary '\0',_binary '\0','A','poldomatti@yahoo.it'),(91,133,'01942622-5ee2-4f98-89fa-d5a74f1e9da2',10.34371566772461,44.83604431152344,_binary '',_binary '\0',_binary '\0','C',NULL),(92,134,'6c2e7b6b-ed9f-40a9-a6bd-43d04f651236',NULL,NULL,_binary '\0',_binary '\0',_binary '\0','A','poldomatti@yahoo.it'),(93,135,'ae40eb04-896a-499a-b87d-67f512d0a4c2',NULL,NULL,_binary '\0',_binary '\0',_binary '\0','A','poldomatti@yahoo.it'),(94,138,'5d3ad093-91b5-437e-bbec-d828461b9b18',10.493016242980957,44.63411331176758,_binary '',_binary '\0',_binary '\0','C',NULL),(95,139,'c1d522c9-7ddf-4348-bbc8-0857d4ef036a',10.33482837677002,44.8401985168457,_binary '',_binary '\0',_binary '\0','C',NULL),(96,140,'6e8e83da-f80e-4e76-a075-d5e06f469404',10.343707084655762,44.83609390258789,_binary '',_binary '\0',_binary '\0','C',NULL),(97,141,'d1ec270e-7653-4629-8cab-bb7785872757',9.845243453979492,45.479068756103516,_binary '',_binary '\0',_binary '\0','C',NULL),(98,142,'ea89c512-c18e-4613-aa32-10c2a15b1d5c',NULL,NULL,_binary '\0',_binary '\0',_binary '\0','A','poldomatti@yahoo.it'),(99,143,'0364a622-a9c7-4538-86e4-d5837da325fb',NULL,NULL,_binary '\0',_binary '\0',_binary '\0','A','poldomatti@yahoo.it'),(100,144,'91c70420-56ed-448f-8247-4557e24ad36f',NULL,NULL,_binary '\0',_binary '\0',_binary '\0','A','poldomatti@yahoo.it'),(101,145,'6f9520c8-162b-4c0b-8178-d671cd462bdd',10.33482837677002,44.8401985168457,_binary '\0',_binary '\0',_binary '\0','A','poldomatti@yahoo.it'),(102,146,'69031e4e-1394-474d-bc75-759c9e686627',NULL,NULL,_binary '\0',_binary '\0',_binary '\0','A','poldomatti@yahoo.it'),(103,147,'cb0fb87a-280b-4c7b-b917-e6e31dab97bf',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(104,148,'0035c1fc-781c-41fc-be00-5562e4f82d3f',10.343698501586914,44.836090087890625,_binary '',_binary '\0',_binary '\0','C',NULL),(105,149,'39e43471-a8f6-42d5-8892-040234671a91',NULL,NULL,_binary '\0',_binary '\0',_binary '\0','C',NULL),(106,150,'47080f52-e6db-471b-9efd-6c4cc39272c8',10.607139587402344,44.64444351196289,_binary '\0',_binary '\0',_binary '\0','C',NULL),(107,151,'aea9aa61-9dfe-4237-a3e4-cf566d627963',10.607131004333496,44.64444351196289,_binary '\0',_binary '\0',_binary '\0','C',NULL),(108,152,'25dd9172-5aac-4216-8d8e-df03d3b6375e',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(109,153,'22e850bd-9739-4542-acab-ba2ef90ea49a',10.534856796264648,44.63648986816406,_binary '',_binary '\0',_binary '\0','C',NULL),(110,154,'d9a17e42-69b7-4e27-8194-45f10b2ed96e',10.3437082,44.8360925,_binary '\0',_binary '\0',_binary '\0','C',NULL),(111,155,'925a2029-42ac-437f-be09-fb6b461ff319',10.343721,44.836093999999996,_binary '\0',_binary '\0',_binary '\0','C',NULL),(112,156,'8fd58727-9ae0-402a-b210-0a4d584eb6b1',10.3438678,44.836108,_binary '\0',_binary '\0',_binary '\0','C',NULL),(113,157,'9b88e166-131b-4b6c-8d30-1a67f0e92f33',10.3437274,44.8360425,_binary '\0',_binary '\0',_binary '\0','C',NULL),(114,158,'b1f11d39-c03b-4356-8f1c-84e1ffc17daf',10.3437097,44.836093,_binary '\0',_binary '\0',_binary '\0','C',NULL),(115,159,'60c7fb4a-6120-43af-abbc-cb791680e917',10.3437156,44.836092099999995,_binary '\0',_binary '\0',_binary '\0','C',NULL),(116,160,'9e05932a-6fe7-4bc2-aad5-784553a583cf',10.343715399999999,44.836040999999994,_binary '',_binary '\0',_binary '\0','C',NULL),(117,161,'49003077-fa2e-496f-befc-ee38468665cf',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(118,162,'0980964c-001f-4d1a-8baf-542232818b1a',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(119,163,'d695f302-1081-4559-a0ea-9b234f3de53e',10.3436967,44.8361006,_binary '',_binary '\0',_binary '\0','C',NULL),(120,164,'5a320f39-2d1f-45d6-ae4b-30d1b21c3495',10.4930473,44.6341186,_binary '\0',_binary '\0',_binary '\0','C',NULL),(121,165,'fd4a2f00-d917-4b17-9869-e59da4bdbfbd',10.3437493,44.8360899,_binary '',_binary '\0',_binary '\0','A','poldomatti@yahoo.it'),(122,166,'2b66726b-c911-4679-aea6-7d229f23e064',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(123,167,'733cad5b-a2cd-4120-8295-d91642140dbf',10.3437132,44.836105599999996,_binary '',_binary '\0',_binary '\0','C',NULL),(124,168,'ad5a0aa8-60d6-4a21-a1e7-42ea7cc7253c',NULL,NULL,_binary '',_binary '\0',_binary '\0','A','poldomatti@yahoo.it'),(125,169,'8d3c37ff-fa95-447a-9d73-d10cb403240d',10.4865635,44.6355126,_binary '',_binary '\0',_binary '\0','A','poldomatti@yahoo.it'),(126,170,'36ec7dd6-49b5-464d-b1b9-277eb0693472',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(127,171,'71fdc5d8-ff8e-4f1d-84b1-d752fd692280',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(128,172,'e9da7d03-d556-4af4-b552-36f4325ee49b',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(129,173,'e9ead182-c5cc-409f-8fc5-dcc42adfe702',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(130,174,'567146f8-3692-42e6-9d21-faed035c1b76',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(131,175,'8eb3f2f8-624e-4314-9c19-9025f8df1af3',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(132,176,'7a83fc20-54f0-4c08-ab36-3f4ffbf98eb3',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(133,177,'65acffd2-d857-459a-9bcc-4191e9ce61d4',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(134,178,'0ab195c2-2035-4622-b893-ca8e45dde20c',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(135,179,'7c61cfa9-87a9-41c4-b17e-0ad062a29edd',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(136,180,'15ddc569-9509-4b3f-8000-3cbb10da33b3',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(137,181,'bdac3813-e425-4bb7-a35b-686dd5d5c019',NULL,NULL,_binary '',_binary '\0',_binary '\0','A','poldomatti@yahoo.it'),(138,182,'6aa87011-fa35-49a4-889c-d26636e41d21',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(139,183,'f772711e-e7d0-4f00-8aa1-6eafadd8ec08',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(140,184,'b071fba2-f04a-4435-8fc5-a286ebfc5e8e',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(141,185,'d147e037-911a-42ed-b538-aca116792420',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(142,186,'019ef331-b907-43ee-890f-00e8fd86e218',10.3436989,44.836104399999996,_binary '',_binary '\0',_binary '\0','C',NULL),(143,NULL,'6f8c9440-3b77-415d-a71a-143e7169deaf',NULL,NULL,_binary '',_binary '\0',_binary '\0','F','al.tivoli@libero.it'),(144,NULL,'394ef328-4041-4164-a02a-58aa2512de39',NULL,NULL,_binary '',_binary '\0',_binary '\0','F','mattissolo99@gmail.com'),(145,187,'956f53d3-9e61-42c6-9ab9-a2961421379b',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(146,188,'53b6d8b8-5d6a-49c3-90ac-71b45f8656ef',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(147,189,'b594d6b5-a0ab-417d-82f4-60024bef36ab',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(148,190,'bc7f6d49-d4ca-4780-a6f5-6b70d058037f',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(149,191,'1de3e5e1-2989-4693-bcb2-bcd56af79811',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(150,192,'f931ad09-a921-4174-9582-ed838101f514',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(151,193,'6d681f6e-2b4c-474d-93a4-1dc7901a2097',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(152,194,'d84a9c5f-9a1b-4bfa-9819-c89dc328a0d9',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(153,195,'095372df-5487-4d40-877a-d2aae1c5a68c',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(154,196,'53a71f10-4135-4fa2-9950-5d49f8bd68b9',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(155,197,'07ab72b2-62f4-4b9a-8850-3221adf3a54e',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(156,198,'b955bd46-3dfc-44fa-b26e-cd4a2137a11b',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(157,199,'652b3d93-6151-4a76-9ffc-bdfb7bed34de',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(158,200,'d205b460-23cb-49f2-8601-cc0c48f7fb8e',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(159,201,'346aca2c-303d-463c-b406-ea79b83f1d44',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(160,202,'28cebceb-7a63-477d-9ccc-5a0a22e1db37',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(161,203,'92da70cd-aaeb-4004-972f-3aebcbc23c41',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(162,204,'bab2e74d-e8b3-4bac-a886-7308f3cfc838',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(163,205,'b01464f0-c39a-4383-8755-97364761e534',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(164,206,'a1c578e2-8650-44e8-b799-a8ccfb5acaea',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(165,207,'8470f75d-6382-463e-982c-2de9a1bef291',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(166,208,'35a1684f-6e57-4836-ac79-ae4e9b09e607',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(167,209,'e4846ce5-8056-432e-8a15-d2dbf5ec8014',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(168,210,'946268a9-bc21-4406-ad60-476b965e8804',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(169,211,'4d09617d-c04c-49a7-9afd-39ebea2f3224',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(170,212,'04a6307f-7e2f-46ed-b8b5-cb45114e0a9f',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(171,213,'4913409b-d535-4f1c-823b-ce25cf958c71',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(172,214,'a5bbb09f-3e28-4416-983b-430e83939fde',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(173,215,'34fd453e-67dc-4a3b-8f33-cfff48076849',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(174,216,'7c8bf23b-ca78-4d92-9573-a799ca5a7e69',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(175,217,'95a2fa9c-652d-4615-b8f7-5bb18c90a1ab',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(176,218,'ed5c560c-4d7d-4b2e-92bc-7c54e009fb9e',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(177,219,'db9bbab3-631a-4361-94b3-6b9f1284945d',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(178,220,'0def603f-4699-4a0c-b71f-6f338b8bd273',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(179,221,'224f54b0-0df2-4c06-acbf-cab6d4ce79b8',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(180,222,'8755be3a-765b-4580-aa29-c4f8261ff4ef',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(181,223,'37528301-e114-4a15-8cda-4ac34a2f9245',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(182,243,'7bf98365-c8ed-426a-90a4-e2fe70c6aed1',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(183,244,'4a497802-edb4-4fa4-9407-0c514a6f033d',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(184,245,'f0acd2f9-4d1d-4e44-9a69-ac2500e5fb86',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(185,246,'3eb23388-3b68-4f72-bd6b-07edbb309ac3',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(186,247,'53502a15-deb5-446b-b0e3-b5c9898b5cbf',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(187,248,'68ef9a3a-3d1f-4be1-88c9-51eceb78e1f5',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(188,249,'3f7839ff-b73b-4c43-a03d-f92467f1c695',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(189,250,'30040439-220d-412a-a073-dab790c4468f',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(190,251,'3b1b0990-e8c4-43b9-ad70-88273eab9c27',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(191,252,'d5c9458b-707f-406c-898d-d0386db0f5fb',10.5472016,44.7274849,_binary '\0',_binary '\0',_binary '\0','C',NULL),(192,253,'7927185c-948e-48c6-9114-5915f8e0f890',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(193,254,'b364295b-2eab-4f56-a9bf-56f813d5b3b1',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(194,255,'584d7320-499f-46e9-800f-84b0325a462c',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(195,256,'8acde107-1562-479b-b4a8-7ccd1067bed1',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(196,257,'435849a8-bb60-485c-944a-9d20dbc79dbe',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(197,258,'a3c66e2a-c70f-432a-859d-94eff60319be',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(198,259,'47c69dc3-f2d5-4496-b5a4-c89f58119b04',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(199,260,'c50eb96c-6470-49f2-bacb-092183552b95',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(202,263,'7e88dd22-bf26-4c48-bb18-f40f4b4529eb',10.3437962,44.8361302,_binary '\0',_binary '\0',_binary '\0','A','poldomatti@yahoo.it'),(203,264,'8f669769-4f24-4fca-b5f6-ead4440cd1c3',10.3437092,44.8361066,_binary '\0',_binary '\0',_binary '\0','A','poldomatti@yahoo.it'),(204,265,'246ccb32-d179-485d-96c6-2276bb2932bb',10.3436679,44.8360925,_binary '',_binary '\0',_binary '\0','C',NULL),(205,266,'3e2abbb0-ba4d-45c9-a2cc-7948a9efcb2b',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(206,267,'b39648a9-afa3-4439-a83d-c7a96e15d368',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(207,268,'f91bc5e0-d0a2-459a-82d7-a0f28200c36b',10.3436781,44.8360906,_binary '\0',_binary '\0',_binary '\0','A','al.tivoli@libero.it'),(208,269,'05198bcb-a440-4679-a015-d945127b3929',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(209,270,'4f702d00-5738-42f9-b4ce-9041e787c2ec',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(210,272,'53050021-4e8a-4cd5-a8c1-770f84fc3162',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(211,273,'8a3b321c-7706-471e-b643-c8d41a7561e7',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(212,274,'1e620e1d-749e-468e-907b-99dc644019e2',NULL,NULL,_binary '',_binary '\0',_binary '\0','A','al.tivoli@libero.it'),(213,275,'10e34bbe-3827-4447-999e-cc5983bbb1ca',10.344040618237743,44.83595577834268,_binary '',_binary '\0',_binary '\0','A','poldomatti@yahoo.it'),(214,276,'c292a8b9-4112-4a36-8cc7-d012769e26b4',10.6066913,44.6442524,_binary '',_binary '\0',_binary '\0','C',NULL),(215,277,'7c5c1ec0-3c4a-4c6e-9715-fdd57367e36f',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(216,278,'c25d4b85-ed67-49f1-a55a-760c07f98fd9',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(217,279,'aa987150-1631-4a1a-a0a0-719ac5e19aa7',NULL,NULL,_binary '',_binary '\0',_binary '\0','C',NULL),(218,280,'76eab32c-8e5b-4945-9d13-84449e700160',10.6071318,44.6442764,_binary '',_binary '\0',_binary '\0','C',NULL),(219,281,'f3786fc5-6b68-4c17-aaf8-ef5299e1165e',10.3348283,44.8401992,_binary '\0',_binary '\0',_binary '\0','C',NULL),(220,282,'61ad4b9e-dc81-4ee0-a45a-acfd8ee33827',10.3348283,44.8401992,_binary '\0',_binary '\0',_binary '\0','C',NULL),(221,283,'d7e43c02-4578-4663-80ee-cc004cc49080',10.5259,44.6946,_binary '',_binary '\0',_binary '\0','C',NULL);
/*!40000 ALTER TABLE `clientPeer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `coupon`
--

DROP TABLE IF EXISTS `coupon`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `coupon` (
  `IDcoupon` int NOT NULL AUTO_INCREMENT,
  `name` char(10) NOT NULL,
  `amount` float(8,2) NOT NULL DEFAULT '0.00',
  `percent` int NOT NULL DEFAULT '0',
  `idUser` varchar(30) DEFAULT NULL,
  `expire` date DEFAULT NULL,
  PRIMARY KEY (`IDcoupon`),
  KEY `idUser` (`idUser`),
  CONSTRAINT `fkcoupon` FOREIGN KEY (`idUser`) REFERENCES `client` (`mail`)
) ENGINE=InnoDB AUTO_INCREMENT=81 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `coupon`
--

LOCK TABLES `coupon` WRITE;
/*!40000 ALTER TABLE `coupon` DISABLE KEYS */;
INSERT INTO `coupon` VALUES (49,'CIAO99',10.00,0,'poldomatti@yahoo.it',NULL),(50,'CIAO89',10.00,0,'al.tivoli@libero.it',NULL),(51,'NATALE2020',0.00,5,NULL,'2021-05-10'),(52,'NATALE2023',0.00,5,NULL,'2021-05-12'),(53,'NATALE2026',0.00,5,NULL,'2021-05-12'),(54,'NATALE2029',0.00,5,NULL,'2021-05-12'),(55,'NATALE2071',0.00,5,NULL,'2021-05-12'),(56,'NATALE2078',0.00,5,NULL,'2021-05-12'),(57,'NATALE2079',0.00,5,NULL,'2021-05-12'),(58,'NATALE2089',0.00,5,NULL,'2021-05-13'),(59,'NATALE2087',0.00,5,NULL,'2021-05-13'),(60,'NATALEPASQ',12.00,0,'poldomatti@yahoo.it',NULL),(61,'NATALEPAS3',12.00,0,NULL,'2021-05-21'),(62,'NATALEPAS1',12.00,0,NULL,NULL),(63,'NATALEPAS7',12.00,0,NULL,NULL),(64,'NATALEPA78',12.00,0,'poldomatti@yahoo.it',NULL),(65,'BELLO2021',0.00,70,'poldomatti@yahoo.it',NULL),(66,'BELLOBIMBO',0.00,50,'poldomatti@yahoo.it',NULL),(67,'CREDIT177',22.00,0,'poldomatti@yahoo.it',NULL),(68,'CREDIT179',22.00,0,'poldomatti@yahoo.it',NULL),(69,'CREDIT181',23.00,0,'poldomatti@yahoo.it',NULL),(70,'CREDIT186',40.00,0,'poldomatti@yahoo.it',NULL),(71,'CREDIT189',45.00,0,'poldomatti@yahoo.it',NULL),(72,'CREDIT191',30.00,0,'poldomatti@yahoo.it',NULL),(73,'CREDIT195',34.00,0,'al.tivoli@libero.it',NULL),(74,'CREDIT197',56.00,0,'al.tivoli@libero.it',NULL),(75,'CREDIT198',56.00,0,'al.tivoli@libero.it',NULL),(76,'CREDIT201',56.00,0,'poldomatti@yahoo.it',NULL),(77,'CREDIT203',1.00,0,'poldomatti@yahoo.it',NULL),(78,'BELLOFIGO',0.00,50,'al.tivoli@libero.it',NULL),(79,'CIAOCIAO',12.00,0,NULL,'2021-07-07'),(80,'MATTEPUZZA',0.00,60,'ramolinif@gmail.com','2021-07-08');
/*!40000 ALTER TABLE `coupon` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employee`
--

DROP TABLE IF EXISTS `employee`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employee` (
  `idemployee` int NOT NULL AUTO_INCREMENT,
  `cfemployee` char(16) NOT NULL,
  `hiring` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `salary` float(8,2) DEFAULT '0.00',
  `password` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`idemployee`),
  UNIQUE KEY `cfemployee` (`cfemployee`),
  CONSTRAINT `fkprim` FOREIGN KEY (`cfemployee`) REFERENCES `client` (`cf`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employee`
--

LOCK TABLES `employee` WRITE;
/*!40000 ALTER TABLE `employee` DISABLE KEYS */;
INSERT INTO `employee` VALUES (1,'BRTMTT99C28H223X','2021-03-08 23:00:00',5.00,'e00cf25ad42683b3df678c61f42c6bda'),(6,'TVLLXA98P03G337R','2021-07-04 21:54:04',2.00,'c84258e9c39059a89ab77d846ddab909'),(7,'TVLLDE34J04G334T','2021-07-04 21:56:46',52.00,'951c4202ebc69207fe8f7a04599dae8a');
/*!40000 ALTER TABLE `employee` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `maintenance`
--

DROP TABLE IF EXISTS `maintenance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `maintenance` (
  `IDrepair` int NOT NULL AUTO_INCREMENT,
  `idBike` int NOT NULL,
  `notes` varchar(100) DEFAULT NULL,
  `manodop` float(8,2) NOT NULL,
  `repaired` bit(1) NOT NULL DEFAULT b'0',
  `startRepair` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `stopRepair` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`IDrepair`),
  KEY `idBike` (`idBike`),
  CONSTRAINT `maintenance_ibfk_1` FOREIGN KEY (`idBike`) REFERENCES `bike` (`IDbike`),
  CONSTRAINT `maintenance_chk_1` CHECK ((`manodop` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `maintenance`
--

LOCK TABLES `maintenance` WRITE;
/*!40000 ALTER TABLE `maintenance` DISABLE KEYS */;
INSERT INTO `maintenance` VALUES (11,1,'manubrio rotto',50.00,_binary '','2021-05-08 22:00:00','2021-05-10 17:34:20'),(12,1,'manubrio rotto',10.00,_binary '','2021-05-09 22:00:00','2021-05-10 17:40:43'),(13,4,'rotta',10.00,_binary '','2021-05-09 22:00:00','2021-05-10 17:43:00');
/*!40000 ALTER TABLE `maintenance` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payment`
--

DROP TABLE IF EXISTS `payment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payment` (
  `idpayment` int NOT NULL AUTO_INCREMENT,
  `idclient` char(16) NOT NULL,
  `idbook` int NOT NULL,
  `paid` bit(1) NOT NULL DEFAULT b'0',
  PRIMARY KEY (`idpayment`),
  KEY `fk1` (`idbook`),
  KEY `fk2` (`idclient`),
  CONSTRAINT `fk1` FOREIGN KEY (`idbook`) REFERENCES `booking` (`IDbooking`),
  CONSTRAINT `fk2` FOREIGN KEY (`idclient`) REFERENCES `client` (`cf`)
) ENGINE=InnoDB AUTO_INCREMENT=169 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payment`
--

LOCK TABLES `payment` WRITE;
/*!40000 ALTER TABLE `payment` DISABLE KEYS */;
INSERT INTO `payment` VALUES (24,'TVLLXA98P03G337R',30,_binary ''),(29,'TVLLXA98P03G337R',35,_binary ''),(30,'TVLLXA98P03G337R',37,_binary ''),(31,'TVLLXA98P03G337R',38,_binary ''),(32,'TVLLXA98P03G337R',39,_binary ''),(33,'TVLLXA98P03G337R',41,_binary ''),(34,'BRTMTT99C28H223X',43,_binary ''),(35,'BRTMTT99C28H223X',44,_binary ''),(36,'TVLLXA98P03G337R',45,_binary ''),(37,'BRTMTT99C28H223X',46,_binary ''),(38,'BRTMTT99C28H223X',47,_binary ''),(39,'BRTMTT99C28H223X',48,_binary ''),(40,'BRTMTT99C28H223X',49,_binary ''),(41,'BRTMTT99C28H223X',50,_binary ''),(42,'BRTMTT99C28H223X',51,_binary ''),(43,'BRTMTT99C28H223X',52,_binary ''),(44,'BRTMTT99C28H223X',53,_binary ''),(45,'BRTMTT99C28H223X',54,_binary ''),(46,'BRTMTT99C28H223X',55,_binary ''),(47,'BRTMTT99C28H223X',56,_binary ''),(48,'TVLLXA98P03G337R',57,_binary ''),(49,'TVLLXA98P03G337R',58,_binary ''),(50,'TVLLXA98P03G337R',59,_binary ''),(51,'TVLLXA98P03G337R',60,_binary ''),(52,'BRTMTT99C28H223X',61,_binary ''),(53,'TVLLXA98P03G337R',62,_binary ''),(54,'TVLLXA98P03G337R',63,_binary ''),(55,'TVLLXA98P03G337R',64,_binary ''),(56,'TVLLXA98P03G337R',65,_binary ''),(57,'TVLLXA98P03G337R',66,_binary ''),(58,'TVLLXA98P03G337R',67,_binary ''),(59,'TVLLXA98P03G337R',68,_binary ''),(60,'TVLLXA98P03G337R',69,_binary ''),(61,'TVLLXA98P03G337R',70,_binary ''),(62,'TVLLXA98P03G337R',71,_binary ''),(63,'BRTMTT99C28H223X',72,_binary ''),(64,'BRTMTT99C28H223X',73,_binary ''),(65,'BRTMTT99C28H223X',74,_binary ''),(66,'BRTMTT99C28H223X',75,_binary ''),(67,'BRTMTT99C28H223X',76,_binary ''),(68,'BRTMTT99C28H223X',77,_binary ''),(69,'BRTMTT99C28H223X',78,_binary ''),(70,'BRTMTT99C28H223X',79,_binary ''),(71,'BRTMTT99C28H223X',80,_binary ''),(72,'BRTMTT99C28H223X',81,_binary ''),(73,'BRTMTT99C28H223X',82,_binary ''),(74,'BRTMTT99C28H223X',83,_binary ''),(75,'BRTMTT99C28H223X',84,_binary ''),(76,'TVLLXA98P03G337R',85,_binary ''),(77,'BRTMTT99C28H223X',86,_binary ''),(78,'TVLLXA98P03G337R',87,_binary ''),(79,'TVLLXA98P03G337R',88,_binary ''),(80,'TVLLXA98P03G337R',89,_binary ''),(81,'BRTMTT99C28H223X',90,_binary ''),(82,'TVLLXA98P03G337R',91,_binary ''),(83,'TVLLXA98P03G337R',92,_binary ''),(84,'TVLLXA98P03G337R',93,_binary ''),(85,'FRRPRI99H16H223X',94,_binary ''),(86,'TVLLXA98P03G337R',95,_binary ''),(87,'TVLLXA98P03G337R',96,_binary ''),(88,'TVLLXA98P03G337R',97,_binary ''),(89,'TVLLXA98P03G337R',98,_binary ''),(90,'TVLLXA98P03G337R',99,_binary ''),(91,'TVLLXA98P03G337R',100,_binary ''),(92,'TVLLXA98P03G337R',101,_binary ''),(93,'TVLLXA98P03G337R',102,_binary ''),(94,'TVLLXA98P03G337R',103,_binary ''),(95,'TVLLXA98P03G337R',104,_binary ''),(96,'TVLLXA98P03G337R',105,_binary ''),(97,'TVLLXA98P03G337R',106,_binary ''),(98,'TVLLXA98P03G337R',107,_binary ''),(99,'TVLLXA98P03G337R',108,_binary ''),(100,'TVLLXA98P03G337R',109,_binary ''),(101,'TVLLXA98P03G337R',110,_binary ''),(102,'TVLLXA98P03G337R',111,_binary ''),(103,'TVLLXA98P03G337R',112,_binary ''),(104,'TVLLXA98P03G337R',130,_binary ''),(105,'TVLLXA98P03G337R',131,_binary ''),(106,'TVLLXA98P03G337R',134,_binary ''),(107,'BRTMTT99C28H223X',135,_binary ''),(108,'TVLLXA98P03G337R',137,_binary ''),(109,'BRTMTT99C28H223X',138,_binary ''),(110,'BRTMTT99C28H223X',139,_binary ''),(111,'TVLLXA98P03G337R',140,_binary ''),(112,'TVLLXA98P03G337R',141,_binary ''),(113,'TVLLXA98P03G337R',142,_binary ''),(114,'TVLLXA98P03G337R',143,_binary ''),(115,'TVLLXA98P03G337R',144,_binary ''),(116,'TVLLXA98P03G337R',145,_binary ''),(117,'TVLLXA98P03G337R',146,_binary ''),(118,'TVLLXA98P03G337R',147,_binary ''),(119,'TVLLXA98P03G337R',148,_binary ''),(120,'BRTMTT99C28H223X',149,_binary ''),(121,'TVLLXA98P03G337R',150,_binary ''),(122,'TVLLXA98P03G337R',151,_binary ''),(123,'TVLLXA98P03G337R',152,_binary ''),(124,'TVLLXA98P03G337R',153,_binary ''),(125,'TVLLXA98P03G337R',154,_binary ''),(126,'BRTMTT99C28H223X',155,_binary ''),(127,'TVLLXA98P03G337R',156,_binary ''),(128,'BRTMTT99C28H223X',158,_binary ''),(129,'TVLLXA98P03G337R',159,_binary ''),(130,'BRTMTT99C28H223X',160,_binary ''),(131,'TVLLXA98P03G337R',161,_binary ''),(132,'BRTMTT99C28H223X',162,_binary ''),(133,'TVLLXA98P03G337R',163,_binary ''),(134,'BRTMTT99C28H223X',164,_binary ''),(135,'TVLLXA98P03G337R',165,_binary ''),(136,'BRTMTT99C28H223X',166,_binary ''),(137,'TVLLXA98P03G337R',199,_binary ''),(138,'TVLLXA98P03G337R',200,_binary ''),(139,'TVLLXA98P03G337R',202,_binary ''),(140,'TVLLXA98P03G337R',204,_binary ''),(141,'TVLLXA98P03G337R',205,_binary ''),(142,'TVLLXA98P03G337R',206,_binary ''),(143,'TVLLXA98P03G337R',207,_binary ''),(144,'BRTMTT99C28H223X',208,_binary ''),(145,'TVLLXA98P03G337R',209,_binary ''),(146,'TVLLXA98P03G337R',210,_binary ''),(147,'TVLLXA98P03G337R',211,_binary ''),(148,'BRTMTT99C28H223X',212,_binary ''),(149,'BRTMTT99C28H223X',213,_binary ''),(150,'TVLLXA98P03G337R',214,_binary ''),(151,'TVLLXA98P03G337R',215,_binary ''),(152,'TVLLXA98P03G337R',216,_binary ''),(153,'TVLLXA98P03G337R',217,_binary ''),(154,'TVLLXA98P03G337R',218,_binary ''),(155,'TVLLXA98P03G337R',219,_binary ''),(156,'VNTLSN98H19G337S',220,_binary ''),(157,'VNTLSN98H19G337S',221,_binary ''),(158,'BRTMTT99C28H223Y',222,_binary ''),(159,'TVLLXA98P03G337R',224,_binary ''),(160,'TVLLXA98P03G337R',225,_binary ''),(161,'TVLLXA98P03G337R',226,_binary ''),(162,'FNLMTT99P03G337S',227,_binary ''),(163,'TVLLXE34K05G443T',228,_binary ''),(164,'TVLLXE34K05G443T',229,_binary ''),(165,'BRTMTT99C28H223X',230,_binary ''),(166,'TVLLXA98P03G334H',231,_binary ''),(167,'TVLLXA98P03G334H',232,_binary ''),(168,'PSNNDR99M09L452V',233,_binary '');
/*!40000 ALTER TABLE `payment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sparepart`
--

DROP TABLE IF EXISTS `sparepart`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sparepart` (
  `IDpart` int NOT NULL AUTO_INCREMENT,
  `namePart` varchar(20) NOT NULL,
  `costPart` float(8,2) NOT NULL,
  `quantity` int NOT NULL,
  `note` text,
  `isbn` varchar(15) NOT NULL,
  PRIMARY KEY (`IDpart`),
  UNIQUE KEY `isbn` (`isbn`),
  CONSTRAINT `sparepart_chk_1` CHECK ((`costPart` >= 0)),
  CONSTRAINT `sparepart_chk_2` CHECK ((`quantity` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sparepart`
--

LOCK TABLES `sparepart` WRITE;
/*!40000 ALTER TABLE `sparepart` DISABLE KEYS */;
INSERT INTO `sparepart` VALUES (1,'gomme',30.00,5,'Maxxis Rexon','886394057483034'),(5,'manubrio',15.00,11,'blu','AAS45GB3'),(6,'manubrio',15.00,12,'blu','ASD45GD');
/*!40000 ALTER TABLE `sparepart` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `specsbook`
--

DROP TABLE IF EXISTS `specsbook`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `specsbook` (
  `IDspecBook` int NOT NULL AUTO_INCREMENT,
  `dateBegin` date NOT NULL,
  `dateFinish` date NOT NULL,
  `bikeBooked` int NOT NULL,
  `idBook` int DEFAULT NULL,
  PRIMARY KEY (`IDspecBook`),
  KEY `bikeBooked` (`bikeBooked`),
  KEY `specsbook_ibfk_2` (`idBook`),
  CONSTRAINT `specsbook_ibfk_1` FOREIGN KEY (`bikeBooked`) REFERENCES `bike` (`IDbike`),
  CONSTRAINT `specsbook_ibfk_2` FOREIGN KEY (`idBook`) REFERENCES `booking` (`IDbooking`)
) ENGINE=InnoDB AUTO_INCREMENT=284 DEFAULT CHARSET=utf8mb3 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `specsbook`
--

LOCK TABLES `specsbook` WRITE;
/*!40000 ALTER TABLE `specsbook` DISABLE KEYS */;
INSERT INTO `specsbook` VALUES (27,'2021-04-29','2021-04-29',1,30),(29,'2021-05-05','2021-05-05',1,35),(30,'2021-05-06','2021-05-06',1,37),(31,'2021-05-06','2021-05-06',2,38),(32,'2021-05-05','2021-05-05',2,39),(33,'2021-05-06','2021-05-06',3,40),(34,'2021-05-06','2021-05-06',4,41),(35,'2021-05-16','2021-05-16',2,42),(36,'2021-06-05','2021-06-05',1,43),(37,'2021-05-23','2021-05-23',2,44),(38,'2021-05-06','2021-05-06',5,45),(39,'2021-05-11','2021-05-11',1,46),(40,'2021-05-11','2021-05-11',2,46),(41,'2021-05-14','2021-05-14',1,57),(42,'2021-05-14','2021-05-14',2,57),(43,'2021-05-15','2021-05-15',1,58),(44,'2021-05-15','2021-05-15',2,59),(45,'2021-05-15','2021-05-15',3,59),(46,'2021-05-15','2021-05-15',4,59),(48,'2021-05-17','2021-05-17',2,NULL),(49,'2021-05-17','2021-05-17',1,NULL),(50,'2021-05-17','2021-05-17',3,60),(51,'2021-05-17','2021-05-17',4,60),(52,'2021-05-17','2021-05-17',5,60),(53,'2021-05-18','2021-05-18',2,61),(54,'2021-05-18','2021-05-18',3,61),(55,'2021-05-21','2021-05-22',1,62),(56,'2021-05-21','2021-05-22',2,62),(57,'2021-05-21','2021-05-22',3,62),(58,'2021-05-23','2021-05-24',1,63),(59,'2021-05-23','2021-05-24',3,63),(60,'2021-05-23','2021-05-24',4,63),(61,'2021-05-23','2021-05-25',5,64),(62,'2021-05-23','2021-05-25',6,64),(63,'2021-05-23','2021-05-25',8,64),(64,'2021-05-24','2021-05-26',2,65),(65,'2021-05-24','2021-05-26',9,65),(68,'2021-05-25','2021-05-25',1,NULL),(69,'2021-05-25','2021-05-25',3,NULL),(70,'2021-05-25','2021-05-25',4,NULL),(71,'2021-05-25','2021-05-25',10,NULL),(72,'2021-05-25','2021-05-25',11,NULL),(73,'2021-05-25','2021-05-25',12,NULL),(74,'2021-05-25','2021-05-26',15,66),(75,'2021-05-26','2021-05-27',1,67),(76,'2021-05-26','2021-05-27',3,67),(77,'2021-05-28','2021-05-30',1,68),(78,'2021-05-28','2021-05-30',2,68),(79,'2021-05-29','2021-05-31',3,69),(80,'2021-05-29','2021-05-31',4,69),(81,'2021-06-09','2021-06-09',1,70),(82,'2021-06-09','2021-06-09',2,70),(83,'2021-06-10','2021-06-10',1,71),(84,'2021-06-09','2021-06-09',3,72),(85,'2021-06-09','2021-06-09',4,72),(86,'2021-06-09','2021-06-09',5,73),(87,'2021-06-09','2021-06-09',6,73),(88,'2021-06-09','2021-06-09',8,74),(89,'2021-06-09','2021-06-09',9,74),(90,'2021-06-09','2021-06-09',10,75),(91,'2021-06-09','2021-06-09',11,75),(92,'2021-06-09','2021-06-09',12,76),(93,'2021-06-09','2021-06-09',13,76),(94,'2021-06-09','2021-06-09',14,77),(95,'2021-06-09','2021-06-09',15,77),(96,'2021-06-09','2021-06-09',16,78),(97,'2021-06-09','2021-06-09',17,78),(98,'2021-06-10','2021-06-10',2,79),(99,'2021-06-10','2021-06-10',3,79),(100,'2021-06-10','2021-06-10',4,80),(101,'2021-06-10','2021-06-10',5,80),(102,'2021-06-10','2021-06-10',6,81),(103,'2021-06-10','2021-06-10',8,81),(104,'2021-06-09','2021-06-09',18,82),(105,'2021-06-09','2021-06-09',19,82),(106,'2021-06-10','2021-06-10',9,83),(107,'2021-06-10','2021-06-10',10,84),(108,'2021-06-10','2021-06-10',11,84),(109,'2021-06-10','2021-06-10',12,84),(110,'2021-06-10','2021-06-10',13,84),(111,'2021-06-10','2021-06-10',16,84),(112,'2021-06-10','2021-06-10',17,84),(113,'2021-06-10','2021-06-10',18,84),(114,'2021-06-10','2021-06-10',19,84),(115,'2021-06-10','2021-06-10',20,84),(116,'2021-06-10','2021-06-10',15,84),(117,'2021-06-10','2021-06-10',14,84),(118,'2021-06-11','2021-06-11',1,85),(119,'2021-06-09','2021-06-09',20,NULL),(123,'2021-06-13','2021-06-13',1,86),(124,'2021-06-11','2021-06-11',2,87),(125,'2021-06-11','2021-06-11',3,87),(126,'2021-06-12','2021-06-12',1,88),(127,'2021-06-12','2021-06-12',2,88),(128,'2021-06-13','2021-06-14',2,89),(129,'2021-06-13','2021-06-14',3,89),(130,'2021-06-13','2021-06-13',4,90),(131,'2021-06-13','2021-06-13',5,NULL),(132,'2021-06-14','2021-06-14',1,NULL),(133,'2021-06-14','2021-06-14',4,91),(134,'2021-06-14','2021-06-14',5,NULL),(135,'2021-06-14','2021-06-14',6,NULL),(136,'2021-06-14','2021-06-14',8,NULL),(137,'2021-06-14','2021-06-14',9,NULL),(138,'2021-06-15','2021-06-16',1,92),(139,'2021-06-15','2021-06-16',2,92),(140,'2021-06-15','2021-06-16',3,92),(141,'2021-06-15','2021-06-16',4,92),(142,'2021-06-15','2021-06-15',5,NULL),(143,'2021-06-15','2021-06-15',6,NULL),(144,'2021-06-15','2021-06-15',8,NULL),(145,'2021-06-15','2021-06-15',9,NULL),(146,'2021-06-15','2021-06-15',10,NULL),(147,'2021-06-17','2021-06-18',1,93),(148,'2021-06-17','2021-06-18',2,93),(149,'2021-06-20','2021-06-20',15,94),(150,'2021-06-19','2021-06-19',1,95),(151,'2021-06-19','2021-06-19',2,95),(152,'2021-06-19','2021-06-19',3,96),(153,'2021-06-19','2021-06-19',4,96),(154,'2021-06-21','2021-06-22',1,97),(155,'2021-06-21','2021-06-22',2,97),(156,'2021-06-21','2021-06-22',3,97),(157,'2021-06-22','2021-06-23',4,98),(158,'2021-06-22','2021-06-23',5,98),(159,'2021-06-23','2021-06-24',1,99),(160,'2021-06-23','2021-06-24',2,99),(161,'2021-06-26','2021-06-29',1,100),(162,'2021-06-26','2021-06-29',2,100),(163,'2021-06-25','2021-06-28',3,101),(164,'2021-06-25','2021-06-28',4,101),(165,'2021-06-25','2021-06-25',1,NULL),(166,'2021-07-01','2021-07-02',1,102),(167,'2021-07-01','2021-07-02',2,102),(168,'2021-07-01','2021-07-01',3,NULL),(169,'2021-07-02','2021-07-02',3,NULL),(170,'2021-07-02','2021-07-02',4,103),(171,'2021-07-02','2021-07-02',5,103),(172,'2021-07-02','2021-07-02',6,103),(173,'2021-07-02','2021-07-03',8,104),(174,'2021-07-10','2021-07-11',1,104),(175,'2021-07-02','2021-07-02',9,105),(176,'2021-07-10','2021-07-10',2,105),(177,'2021-07-10','2021-07-10',3,106),(178,'2021-07-23','2021-07-23',1,106),(179,'2021-07-14','2021-07-14',1,107),(180,'2021-07-14','2021-07-14',2,107),(181,'2021-07-02','2021-07-02',10,NULL),(182,'2021-07-09','2021-07-09',1,108),(183,'2021-07-23','2021-07-23',2,108),(184,'2021-07-02','2021-07-02',11,109),(185,'2021-07-04','2021-07-05',1,110),(186,'2021-07-04','2021-07-05',2,110),(187,'2021-07-05','2021-07-05',3,111),(188,'2021-07-05','2021-07-05',4,111),(189,'2021-07-05','2021-07-05',5,111),(190,'2021-07-05','2021-07-05',6,112),(191,'2021-07-05','2021-07-05',8,130),(192,'2021-07-05','2021-07-05',9,131),(193,'2021-07-05','2021-07-05',10,134),(194,'2021-07-06','2021-07-06',2,135),(195,'2021-07-31','2021-07-31',2,137),(196,'2021-07-31','2021-07-31',2,138),(197,'2021-07-14','2021-07-14',4,139),(198,'2021-07-05','2021-07-05',11,140),(199,'2021-07-06','2021-07-06',1,141),(200,'2021-07-05','2021-07-05',12,142),(201,'2021-07-06','2021-07-06',3,143),(202,'2021-07-05','2021-07-05',13,144),(203,'2021-07-05','2021-07-05',14,145),(204,'2021-07-05','2021-07-05',15,146),(205,'2021-07-05','2021-07-05',16,147),(206,'2021-07-05','2021-07-05',17,148),(207,'2021-08-05','2021-08-05',20,149),(208,'2021-07-05','2021-07-05',18,150),(209,'2021-07-05','2021-07-05',19,151),(210,'2021-07-05','2021-07-05',20,152),(211,'2021-07-06','2021-07-06',4,153),(212,'2021-07-06','2021-07-06',5,154),(213,'2021-07-06','2021-07-06',6,155),(214,'2021-07-06','2021-07-06',6,156),(215,'2021-07-06','2021-07-06',8,158),(216,'2021-07-06','2021-07-06',8,159),(217,'2021-07-06','2021-07-06',9,160),(218,'2021-07-06','2021-07-06',9,161),(219,'2021-07-06','2021-07-06',10,162),(220,'2021-07-06','2021-07-06',10,163),(221,'2021-07-06','2021-07-06',11,164),(222,'2021-07-06','2021-07-06',11,165),(223,'2021-07-06','2021-07-06',12,166),(224,'2021-07-06','2021-07-06',13,168),(225,'2021-07-06','2021-07-06',13,169),(226,'2021-07-19','2021-07-19',20,170),(227,'2021-07-06','2021-07-06',14,171),(228,'2021-07-06','2021-07-06',14,172),(229,'2021-07-06','2021-07-06',15,173),(230,'2021-07-06','2021-07-06',16,175),(231,'2021-07-06','2021-07-06',17,176),(232,'2021-07-06','2021-07-06',18,178),(233,'2021-07-06','2021-07-06',19,180),(234,'2021-07-07','2021-07-07',1,182),(235,'2021-07-07','2021-07-07',2,184),(236,'2021-07-07','2021-07-07',3,185),(237,'2021-07-07','2021-07-07',4,187),(238,'2021-07-07','2021-07-07',5,188),(239,'2021-07-07','2021-07-07',6,190),(240,'2021-07-07','2021-07-07',8,193),(241,'2021-07-07','2021-07-07',9,194),(242,'2021-07-07','2021-07-07',10,196),(243,'2021-07-07','2021-07-07',11,199),(244,'2021-07-07','2021-07-07',12,200),(245,'2021-07-07','2021-07-07',13,202),(246,'2021-07-07','2021-07-07',14,204),(247,'2021-07-08','2021-07-08',1,205),(248,'2021-07-07','2021-07-07',15,206),(249,'2021-07-07','2021-07-07',16,207),(250,'2021-07-06','2021-07-06',20,208),(251,'2021-07-07','2021-07-07',17,209),(252,'2021-07-07','2021-07-07',18,210),(253,'2021-07-08','2021-07-08',2,211),(254,'2021-07-07','2021-07-29',19,212),(255,'2021-07-31','2021-07-31',10,213),(256,'2021-07-08','2021-07-08',3,214),(257,'2021-07-08','2021-07-08',4,215),(258,'2021-07-08','2021-07-08',5,216),(259,'2021-07-08','2021-07-08',6,217),(260,'2021-07-08','2021-07-08',8,218),(263,'2021-07-07','2021-07-07',20,NULL),(264,'2021-07-08','2021-07-08',9,NULL),(265,'2021-07-08','2021-07-08',10,219),(266,'2021-07-12','2021-07-12',9,220),(267,'2021-07-09','2021-07-09',3,221),(268,'2021-07-09','2021-07-09',2,NULL),(269,'2021-07-10','2021-07-10',12,222),(270,'2021-07-11','2021-07-11',3,223),(271,'2021-07-11','2021-07-11',3,223),(272,'2021-07-11','2021-07-11',2,224),(273,'2021-07-11','2021-07-11',4,225),(274,'2021-07-11','2021-07-11',5,NULL),(275,'2021-07-12','2021-07-12',1,NULL),(276,'2021-07-12','2021-07-12',2,226),(277,'2021-07-12','2021-07-12',3,227),(278,'2021-07-12','2021-07-12',4,228),(279,'2021-07-12','2021-07-12',5,229),(280,'2021-07-13','2021-07-13',1,230),(281,'2021-07-13','2021-07-13',2,231),(282,'2021-07-13','2021-07-13',3,232),(283,'2021-07-13','2021-07-13',4,233);
/*!40000 ALTER TABLE `specsbook` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usedpart`
--

DROP TABLE IF EXISTS `usedpart`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usedpart` (
  `IDused` int NOT NULL AUTO_INCREMENT,
  `idPart` int NOT NULL,
  `idMaint` int NOT NULL,
  `qUsed` int NOT NULL,
  PRIMARY KEY (`IDused`),
  KEY `usedpart_ibfk_1` (`idPart`),
  KEY `usedpart_ibfk_2` (`idMaint`),
  CONSTRAINT `usedpart_ibfk_1` FOREIGN KEY (`idPart`) REFERENCES `sparepart` (`IDpart`),
  CONSTRAINT `usedpart_ibfk_2` FOREIGN KEY (`idMaint`) REFERENCES `maintenance` (`IDrepair`),
  CONSTRAINT `usedpart_chk_1` CHECK ((`qUsed` > 0))
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usedpart`
--

LOCK TABLES `usedpart` WRITE;
/*!40000 ALTER TABLE `usedpart` DISABLE KEYS */;
INSERT INTO `usedpart` VALUES (17,5,11,1);
/*!40000 ALTER TABLE `usedpart` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-07-13 23:42:15
