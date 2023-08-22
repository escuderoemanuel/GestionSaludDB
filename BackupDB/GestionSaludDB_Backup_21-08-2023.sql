-- MySQL dump 10.13  Distrib 8.0.32, for Win64 (x86_64)
--
-- Host: localhost    Database: gestionsaluddb
-- ------------------------------------------------------
-- Server version	8.0.32

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `administrativos`
--

DROP TABLE IF EXISTS `administrativos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `administrativos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `dni` varchar(10) NOT NULL,
  `apellido` varchar(150) NOT NULL,
  `nombre` varchar(150) NOT NULL,
  `fecha_nacimiento` date NOT NULL,
  `domicilio` varchar(500) DEFAULT NULL,
  `correo_electronico` varchar(100) NOT NULL,
  `rol` varchar(50) DEFAULT 'ADMINISTRATIVO',
  PRIMARY KEY (`id`),
  UNIQUE KEY `dni` (`dni`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `administrativos`
--

LOCK TABLES `administrativos` WRITE;
/*!40000 ALTER TABLE `administrativos` DISABLE KEYS */;
/*!40000 ALTER TABLE `administrativos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `administrativos_telefonos`
--

DROP TABLE IF EXISTS `administrativos_telefonos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `administrativos_telefonos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_administrativo` int DEFAULT NULL,
  `descripcion` enum('CELULAR','FIJO') NOT NULL,
  `telefono` varchar(20) NOT NULL,
  `notas_adicionales` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_administrativo` (`id_administrativo`),
  CONSTRAINT `administrativos_telefonos_ibfk_1` FOREIGN KEY (`id_administrativo`) REFERENCES `administrativos` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `administrativos_telefonos`
--

LOCK TABLES `administrativos_telefonos` WRITE;
/*!40000 ALTER TABLE `administrativos_telefonos` DISABLE KEYS */;
/*!40000 ALTER TABLE `administrativos_telefonos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auditores`
--

DROP TABLE IF EXISTS `auditores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auditores` (
  `id` int NOT NULL AUTO_INCREMENT,
  `dni` varchar(10) NOT NULL,
  `apellido` varchar(150) NOT NULL,
  `nombre` varchar(150) NOT NULL,
  `correo_electronico` varchar(100) NOT NULL,
  `puesto` varchar(150) NOT NULL,
  `rol` varchar(50) DEFAULT 'AUDITOR',
  PRIMARY KEY (`id`),
  UNIQUE KEY `dni` (`dni`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auditores`
--

LOCK TABLES `auditores` WRITE;
/*!40000 ALTER TABLE `auditores` DISABLE KEYS */;
/*!40000 ALTER TABLE `auditores` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tr_auditores_after_insert` AFTER INSERT ON `auditores` FOR EACH ROW BEGIN
    INSERT INTO usuarios_sistema (username, pass, rol)
    VALUES (CONCAT(SUBSTRING_INDEX(NEW.correo_electronico, '@', 1),'@localhost'), SUBSTRING(MD5(RAND()), 1, 8), 'AUDITOR');
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `auditores_telefonos`
--

DROP TABLE IF EXISTS `auditores_telefonos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auditores_telefonos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_auditor` int DEFAULT NULL,
  `descripcion` enum('CELULAR','FIJO') NOT NULL,
  `telefono` varchar(20) NOT NULL,
  `notas_adicionales` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_auditor` (`id_auditor`),
  CONSTRAINT `auditores_telefonos_ibfk_1` FOREIGN KEY (`id_auditor`) REFERENCES `auditores` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auditores_telefonos`
--

LOCK TABLES `auditores_telefonos` WRITE;
/*!40000 ALTER TABLE `auditores_telefonos` DISABLE KEYS */;
/*!40000 ALTER TABLE `auditores_telefonos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `citas_medicas`
--

DROP TABLE IF EXISTS `citas_medicas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `citas_medicas` (
  `id` int NOT NULL AUTO_INCREMENT,
  `fecha_creacion_cita` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha` date NOT NULL,
  `hora` time NOT NULL,
  `estado` enum('PENDIENTE','REALIZADA','CANCELADA') DEFAULT 'PENDIENTE',
  `id_administrativo` int DEFAULT NULL,
  `id_medico` int DEFAULT NULL,
  `id_paciente` int DEFAULT NULL,
  `notas_adicionales` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_administrativo` (`id_administrativo`),
  KEY `id_paciente` (`id_paciente`),
  KEY `id_medico` (`id_medico`),
  CONSTRAINT `citas_medicas_ibfk_1` FOREIGN KEY (`id_administrativo`) REFERENCES `administrativos` (`id`),
  CONSTRAINT `citas_medicas_ibfk_2` FOREIGN KEY (`id_paciente`) REFERENCES `pacientes` (`id`),
  CONSTRAINT `citas_medicas_ibfk_3` FOREIGN KEY (`id_medico`) REFERENCES `medicos` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=651 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `citas_medicas`
--

LOCK TABLES `citas_medicas` WRITE;
/*!40000 ALTER TABLE `citas_medicas` DISABLE KEYS */;
/*!40000 ALTER TABLE `citas_medicas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `datos_obras_sociales`
--

DROP TABLE IF EXISTS `datos_obras_sociales`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `datos_obras_sociales` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_obra_social` int DEFAULT NULL,
  `telefono` varchar(20) NOT NULL,
  `descripcion_telefono` varchar(20) NOT NULL,
  `correo_electronico` varchar(100) NOT NULL,
  `descripcion_correo_electronico` varchar(100) NOT NULL,
  `notas_adicionales` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_obra_social` (`id_obra_social`),
  CONSTRAINT `datos_obras_sociales_ibfk_1` FOREIGN KEY (`id_obra_social`) REFERENCES `obras_sociales` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `datos_obras_sociales`
--

LOCK TABLES `datos_obras_sociales` WRITE;
/*!40000 ALTER TABLE `datos_obras_sociales` DISABLE KEYS */;
/*!40000 ALTER TABLE `datos_obras_sociales` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `facturas`
--

DROP TABLE IF EXISTS `facturas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `facturas` (
  `id` int NOT NULL AUTO_INCREMENT,
  `numero_factura` varchar(20) NOT NULL,
  `fecha_emision` date DEFAULT NULL,
  `id_paciente` int DEFAULT NULL,
  `id_medico` int DEFAULT NULL,
  `id_obra_social` int DEFAULT NULL,
  `total_factura` decimal(10,2) NOT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  `estado` enum('PENDIENTE','PAGADA','VENCIDA') NOT NULL,
  `fecha_vencimiento` date DEFAULT NULL,
  `metodo_pago` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `numero_factura` (`numero_factura`),
  KEY `id_paciente` (`id_paciente`),
  KEY `id_medico` (`id_medico`),
  KEY `id_obra_social` (`id_obra_social`),
  CONSTRAINT `facturas_ibfk_1` FOREIGN KEY (`id_paciente`) REFERENCES `pacientes` (`id`),
  CONSTRAINT `facturas_ibfk_2` FOREIGN KEY (`id_medico`) REFERENCES `medicos` (`id`),
  CONSTRAINT `facturas_ibfk_3` FOREIGN KEY (`id_obra_social`) REFERENCES `obras_sociales` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=401 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `facturas`
--

LOCK TABLES `facturas` WRITE;
/*!40000 ALTER TABLE `facturas` DISABLE KEYS */;
/*!40000 ALTER TABLE `facturas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `historiales_medicos`
--

DROP TABLE IF EXISTS `historiales_medicos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `historiales_medicos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_paciente` int DEFAULT NULL,
  `id_medico` int NOT NULL,
  `fecha_registro` date NOT NULL,
  `nota_medica` varchar(1000) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_paciente` (`id_paciente`),
  KEY `id_medico` (`id_medico`),
  CONSTRAINT `historiales_medicos_ibfk_1` FOREIGN KEY (`id_paciente`) REFERENCES `pacientes` (`id`),
  CONSTRAINT `historiales_medicos_ibfk_2` FOREIGN KEY (`id_medico`) REFERENCES `medicos` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=201 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `historiales_medicos`
--

LOCK TABLES `historiales_medicos` WRITE;
/*!40000 ALTER TABLE `historiales_medicos` DISABLE KEYS */;
/*!40000 ALTER TABLE `historiales_medicos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ingresos_facturacion_mensual`
--

DROP TABLE IF EXISTS `ingresos_facturacion_mensual`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ingresos_facturacion_mensual` (
  `id` int NOT NULL AUTO_INCREMENT,
  `mes_facturado` varchar(12) DEFAULT NULL,
  `total_ingreso` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ingresos_facturacion_mensual`
--

LOCK TABLES `ingresos_facturacion_mensual` WRITE;
/*!40000 ALTER TABLE `ingresos_facturacion_mensual` DISABLE KEYS */;
/*!40000 ALTER TABLE `ingresos_facturacion_mensual` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `medicos`
--

DROP TABLE IF EXISTS `medicos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `medicos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `dni` varchar(10) NOT NULL,
  `apellido` varchar(150) NOT NULL,
  `nombre` varchar(150) NOT NULL,
  `fecha_nacimiento` date NOT NULL,
  `domicilio` varchar(500) DEFAULT NULL,
  `correo_electronico` varchar(100) NOT NULL,
  `especialidad` varchar(100) NOT NULL,
  `matricula` varchar(50) NOT NULL,
  `rol` varchar(50) DEFAULT 'MEDICO',
  PRIMARY KEY (`id`),
  UNIQUE KEY `dni` (`dni`),
  UNIQUE KEY `matricula` (`matricula`)
) ENGINE=InnoDB AUTO_INCREMENT=61 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `medicos`
--

LOCK TABLES `medicos` WRITE;
/*!40000 ALTER TABLE `medicos` DISABLE KEYS */;
/*!40000 ALTER TABLE `medicos` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tr_medicos_after_insert` AFTER INSERT ON `medicos` FOR EACH ROW BEGIN
    INSERT INTO usuarios_sistema (username, pass, rol)
    VALUES (CONCAT(SUBSTRING_INDEX(NEW.correo_electronico, '@', 1),'@localhost'), SUBSTRING(MD5(RAND()), 1, 8), 'MEDICO');
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `medicos_telefonos`
--

DROP TABLE IF EXISTS `medicos_telefonos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `medicos_telefonos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_medico` int DEFAULT NULL,
  `descripcion` enum('CELULAR','FIJO') NOT NULL,
  `telefono` varchar(20) NOT NULL,
  `notas_adicionales` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_medico` (`id_medico`),
  CONSTRAINT `medicos_telefonos_ibfk_1` FOREIGN KEY (`id_medico`) REFERENCES `medicos` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=81 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `medicos_telefonos`
--

LOCK TABLES `medicos_telefonos` WRITE;
/*!40000 ALTER TABLE `medicos_telefonos` DISABLE KEYS */;
/*!40000 ALTER TABLE `medicos_telefonos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `obras_sociales`
--

DROP TABLE IF EXISTS `obras_sociales`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `obras_sociales` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(255) NOT NULL,
  `domicilio` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `obras_sociales`
--

LOCK TABLES `obras_sociales` WRITE;
/*!40000 ALTER TABLE `obras_sociales` DISABLE KEYS */;
/*!40000 ALTER TABLE `obras_sociales` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pacientes`
--

DROP TABLE IF EXISTS `pacientes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pacientes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `dni` varchar(10) NOT NULL,
  `apellido` varchar(150) NOT NULL,
  `nombre` varchar(150) NOT NULL,
  `fecha_nacimiento` date NOT NULL,
  `domicilio` varchar(500) DEFAULT NULL,
  `correo_electronico` varchar(100) NOT NULL,
  `obra_social` varchar(100) DEFAULT 'PARTICULAR',
  `rol` varchar(50) DEFAULT 'PACIENTE',
  PRIMARY KEY (`id`),
  UNIQUE KEY `dni` (`dni`)
) ENGINE=InnoDB AUTO_INCREMENT=171 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pacientes`
--

LOCK TABLES `pacientes` WRITE;
/*!40000 ALTER TABLE `pacientes` DISABLE KEYS */;
INSERT INTO `pacientes` VALUES (1,'44769256','O\' Liddy','Gareth','2009-09-01','4454 Steensland Plaza','goliddy0@loc.gov','OSPEDYC (Obra Social de Entidades Deportivas y Civiles)','PACIENTE'),(2,'54900113','Filipczak','Morissa','1980-03-19','78 Fieldstone Lane','mfilipczak1@comsenz.com','AMFFA (Asociación Mutual de los Ferroviarios Argentinos)','PACIENTE'),(3,'22262837','Strephan','Norbert','2001-09-06','4638 Northridge Court','nstrephan2@google.co.uk','Galeno','PACIENTE'),(4,'36108368','Robson','Jessamyn','2013-02-20','0697 Southridge Park','jrobson3@theguardian.com','Obras Sociales Provinciales (varias según cada provincia)','PACIENTE'),(5,'46932199','Frankham','Edyth','1989-04-09','2 Lotheville Road','efrankham4@skype.com','OSPJN (Obra Social del Poder Judicial de la Nación)','PACIENTE'),(6,'13815315','Nesby','Averell','1985-05-27','4047 Dwight Alley','anesby5@google.es','Swiss Medical','PACIENTE'),(7,'34329957','McClelland','Jandy','1994-08-23','258 Spohn Pass','jmcclelland6@globo.com','UOM (Unión Obrera Metalúrgica)','PACIENTE'),(8,'43629998','Spadotto','Eustace','1996-01-14','113 Independence Terrace','espadotto7@pbs.org','Obras Sociales Provinciales (varias según cada provincia)','PACIENTE'),(9,'17604869','Trever','Randal','1966-12-22','626 Mifflin Place','rtrever8@marriott.com','IAPOS (Instituto Autárquico Provincial de Obra Social)','PACIENTE'),(10,'16315838','Giovanardi','Abba','2001-04-30','2914 Boyd Drive','agiovanardi9@ted.com','OSECAC (Obra Social de Empleados de Comercio y Actividades Civiles)','PACIENTE'),(11,'39527472','Caillou','Barbaraanne','1978-12-27','5 Mayfield Place','bcailloua@merriam-webster.com','AMP (Asociación Mutual del Personal de la Universidad Nacional de Tucumán)','PACIENTE'),(12,'56731084','Wilding','Lorinda','2002-11-11','22210 Porter Parkway','lwildingb@delicious.com','OSPAT (Obra Social del Personal de la Actividad del Turf)','PACIENTE'),(13,'38077059','Ivanovic','Averell','1980-10-30','80486 Cottonwood Place','aivanovicc@uol.com.br','OSPA (Obra Social del Personal de la Actividad Aseguradora)','PACIENTE'),(14,'38045312','Conrad','Babara','1978-02-24','9436 Anderson Pass','bconradd@meetup.com','OSPAT (Obra Social del Personal de la Actividad del Turf)','PACIENTE'),(15,'23468259','Caudrelier','Auberon','1973-06-25','43879 Vidon Point','acaudreliere@etsy.com','OSPAT (Obra Social del Personal de la Actividad del Turf)','PACIENTE'),(16,'55991885','Westphal','Augustin','1994-07-03','40 Lunder Street','awestphalf@tripod.com','OSECAC (Obra Social de Empleados de Comercio y Actividades Civiles)','PACIENTE'),(17,'28362954','Jacobovitz','Marcelle','2012-12-07','418 Melody Way','mjacobovitzg@acquirethisname.com','Obras Sociales Provinciales (varias según cada provincia)','PACIENTE'),(18,'17766885','Castlake','Early','2009-05-26','6083 Menomonie Avenue','ecastlakeh@surveymonkey.com','OSMATA (Obra Social del Personal de la Industria Azucarera)','PACIENTE'),(19,'40658197','McNeill','Dorise','2006-04-01','87 Lerdahl Lane','dmcneilli@webmd.com','OSPRERA (Obra Social de los Empleados de la República Argentina)','PACIENTE'),(20,'42097553','Nagle','Kiersten','1989-10-02','6538 Reindahl Crossing','knaglej@kickstarter.com','OSFFENTOS (Obra Social Ferroviaria de Fomento)','PACIENTE'),(21,'12053185','Kelloway','Betta','2005-07-18','6764 Eggendart Park','bkellowayk@nsw.gov.au','SADAIC (Sociedad Argentina de Autores y Compositores de Música)','PACIENTE'),(22,'44601418','Rait','Bartlett','1984-08-16','82576 Manley Place','braitl@paypal.com','OSPATCA (Obra Social del Personal Auxiliar de Casas Particulares)','PACIENTE'),(23,'26186630','Scard','Lutero','1985-01-07','4063 Canary Court','lscardm@pinterest.com','PARTICULAR','PACIENTE'),(24,'16353985','Jones','Gerik','2009-09-02','0476 Ohio Pass','gjonesn@globo.com','OSPRERA (Obra Social de los Empleados de la República Argentina)','PACIENTE'),(25,'49174717','Vigar','Jenda','1972-12-30','278 Schurz Place','jvigaro@gnu.org','OSDE','PACIENTE'),(26,'38702849','Hrus','Merrili','1966-08-01','1 Esker Circle','mhrusp@weebly.com','OSPATCA (Obra Social del Personal Auxiliar de Casas Particulares)','PACIENTE'),(27,'55129657','Crawley','Oswald','1975-10-03','59977 Hooker Court','ocrawleyq@slashdot.org','Sancor Salud','PACIENTE'),(28,'25472099','Ivetts','Zondra','2007-04-25','7 Mcbride Road','zivettsr@w3.org','IAPS (Instituto de Asistencia Social del Neuquén)','PACIENTE'),(29,'23705804','Dohmer','Barney','2009-11-27','1443 Oakridge Lane','bdohmers@google.cn','OSPA (Obra Social del Personal de la Actividad Aseguradora)','PACIENTE'),(30,'29613896','Kalker','Ranna','1979-11-06','53813 Shopko Road','rkalkert@cdc.gov','Swiss Medical','PACIENTE'),(31,'37855479','Sedger','Andrej','1969-08-24','460 Del Sol Hill','asedgeru@aboutads.info','Obra Social Bancaria Argentina','PACIENTE'),(32,'47566519','Dargavel','Waylan','1998-05-15','231 Crowley Court','wdargavelv@indiatimes.com','IAPS (Instituto de Asistencia Social del Neuquén)','PACIENTE'),(33,'24564019','Seifert','Huey','1968-10-31','040 Carberry Junction','hseifertw@goo.ne.jp','OSEF (Obra Social del Estado Fueguino)','PACIENTE'),(34,'37846605','Hards','Jared','1964-06-02','4486 Westridge Way','jhardsx@google.es','OSMATA (Obra Social del Personal de la Actividad del Turf)','PACIENTE'),(35,'26861763','Haggett','Anabella','2007-02-06','4678 Lawn Hill','ahaggetty@salon.com','PARTICULAR','PACIENTE'),(36,'23960440','Crippill','Bertrand','1983-02-26','639 Rigney Park','bcrippillz@twitpic.com','OSPA (Obra Social del Personal de la Actividad Aseguradora)','PACIENTE'),(37,'20279900','Thomson','Tyrone','1977-09-02','4285 Spohn Avenue','tthomson10@nba.com','DASPU (Dirección de Asistencia Social del Personal Universitario)','PACIENTE'),(38,'25401313','Fossey','Nerta','1977-12-14','651 Redwing Trail','nfossey11@prnewswire.com','AMEPA (Asociación Mutual de Empleados del Poder Judicial)','PACIENTE'),(39,'14599923','Bengtsson','Griselda','1981-10-09','68856 Thierer Point','gbengtsson12@howstuffworks.com','OSPJN (Obra Social del Poder Judicial de la Nación)','PACIENTE'),(40,'52338872','Reis','Selene','2011-07-24','39369 Riverside Trail','sreis13@dailymotion.com','Caja de Servicios Sociales de la Universidad Nacional del Sur','PACIENTE'),(41,'48296919','Rickman','Herculie','2000-03-16','20 Clove Junction','hrickman14@oaic.gov.au','PAMI (Programa de Atención Médica Integral)','PACIENTE'),(42,'18019866','Broker','Olivette','2001-10-05','384 Graceland Point','obroker15@cyberchimps.com','OSFFENTOS (Obra Social Ferroviaria de Fomento)','PACIENTE'),(43,'44686064','Woodington','Normand','1983-05-27','744 Scofield Plaza','nwoodington16@home.pl','Caja de Servicios Sociales de la Universidad Nacional del Sur','PACIENTE'),(44,'28540169','Vertey','Carlos','1969-10-04','11 Towne Avenue','cvertey17@google.es','Obras Sociales Provinciales (varias según cada provincia)','PACIENTE'),(45,'20058468','Vedenyakin','Karim','1992-06-10','4 Anhalt Terrace','kvedenyakin18@dailymotion.com','Caja de Servicios Sociales de la Universidad Nacional del Sur','PACIENTE'),(46,'44039429','Duffree','Aggie','1981-05-27','72 Sauthoff Place','aduffree19@intel.com','OSMATA (Obra Social del Personal de la Industria Azucarera)','PACIENTE'),(47,'18067225','Konert','Brandtr','2009-04-28','9 Porter Point','bkonert1a@pbs.org','OSPEDYC (Obra Social de Entidades Deportivas y Civiles)','PACIENTE'),(48,'32945781','Burnyeat','Vania','1974-06-12','178 Transport Alley','vburnyeat1b@live.com','IOMA (Instituto de Obra Médico Asistencial)','PACIENTE'),(49,'49801418','Trumble','Lela','1960-03-05','8448 Lakewood Gardens Avenue','ltrumble1c@sciencedirect.com','AMEPA (Asociación Mutual de Empleados del Poder Judicial)','PACIENTE'),(50,'37982781','Dougan','Jarred','2003-01-14','3417 Springs Hill','jdougan1d@cisco.com','IAPS (Instituto de Asistencia Social del Neuquén)','PACIENTE'),(51,'45557392','Whitear','Erick','2015-03-31','55 Village Green Alley','ewhitear1e@aol.com','OSFFENTOS (Obra Social Ferroviaria de Fomento)','PACIENTE'),(52,'14883599','Pilsworth','Rockie','1982-07-12','63377 Starling Alley','rpilsworth1f@amazonaws.com','Obra Social Bancaria Argentina','PACIENTE'),(53,'13974325','Priter','Had','1962-10-23','0187 Gina Drive','hpriter1g@w3.org','PAMI (Programa de Atención Médica Integral)','PACIENTE'),(54,'54298760','Deaconson','Constance','1961-07-26','3 Esch Way','cdeaconson1h@census.gov','OSPEDYC (Obra Social de Entidades Deportivas y Civiles)','PACIENTE'),(55,'42412540','Castanaga','Ax','1998-10-07','3 Graceland Pass','acastanaga1i@shareasale.com','OSPA (Obra Social del Personal de la Actividad Aseguradora)','PACIENTE'),(56,'24008103','Dancey','Aluin','1980-10-20','60982 Cardinal Terrace','adancey1j@theglobeandmail.com','UOCRA (Unión Obrera de la Construcción de la República Argentina)','PACIENTE'),(57,'45355913','Kobpac','Jay','2002-04-12','16 Stoughton Lane','jkobpac1k@si.edu','OSMATA (Obra Social del Personal de la Industria Azucarera)','PACIENTE'),(58,'53995776','Giovanni','Niccolo','1973-02-12','5 Mccormick Terrace','ngiovanni1l@google.ca','IAPOS (Instituto Autárquico Provincial de Obra Social)','PACIENTE'),(59,'18853246','Greaterex','Edyth','1975-03-14','77681 Upham Way','egreaterex1m@adobe.com','Sancor Salud','PACIENTE'),(60,'26460831','Rusted','Faulkner','2011-03-25','12 Ramsey Parkway','frusted1n@geocities.jp','Medicus','PACIENTE'),(61,'14815123','Jan','Kirstyn','1982-11-20','1558 Lunder Court','kjan1o@wikispaces.com','OSPATCA (Obra Social del Personal Auxiliar de Casas Particulares)','PACIENTE'),(62,'38071144','Filippello','John','1990-05-06','406 Amoth Point','jfilippello1p@disqus.com','Caja de Servicios Sociales de la Universidad Nacional del Sur','PACIENTE'),(63,'39272104','Cranmere','Gabriel','1991-12-11','7 1st Terrace','gcranmere1q@usa.gov','Sancor Salud','PACIENTE'),(64,'40139447','Gronou','Chauncey','1998-10-19','53 Crownhardt Point','cgronou1r@github.io','OSMATA (Obra Social del Personal de la Actividad del Turf)','PACIENTE'),(65,'56403036','Tolussi','Worden','1976-03-19','84 Thackeray Center','wtolussi1s@about.com','PARTICULAR','PACIENTE'),(66,'20000424','Taill','Olga','1972-04-06','487 Sherman Junction','otaill1t@booking.com','Medicus','PACIENTE'),(67,'34190665','Penketh','Adelice','1970-10-13','3814 Schiller Plaza','apenketh1u@answers.com','OSPV (Obra Social de Petroleros y Gas Privado de la Patagonia Austral)','PACIENTE'),(68,'41942886','Prys','Saxe','1980-02-04','81 Towne Lane','sprys1v@ifeng.com','OSPAT (Obra Social del Personal de la Actividad del Turf)','PACIENTE'),(69,'25739404','Corran','Amandi','1968-08-09','31 Acker Court','acorran1w@youtu.be','Obras Sociales Provinciales (varias según cada provincia)','PACIENTE'),(70,'29842859','Gilgryst','Nisse','1986-06-19','6 Bluejay Hill','ngilgryst1x@weather.com','IAPOS (Instituto Autárquico Provincial de Obra Social)','PACIENTE'),(71,'32984941','Bortoloni','Karalee','1970-08-07','3891 Loomis Hill','kbortoloni1y@go.com','OSPATCA (Obra Social del Personal Auxiliar de Casas Particulares)','PACIENTE'),(72,'22254182','Chomicki','Shirlee','1987-09-02','431 Dawn Parkway','schomicki1z@plala.or.jp','OSPAT (Obra Social del Personal de la Actividad del Turf)','PACIENTE'),(73,'15653994','Rennels','Ross','1999-11-17','763 Esch Junction','rrennels20@live.com','Obra Social Bancaria Argentina','PACIENTE'),(74,'50604715','Swyn','Michel','1979-09-18','43 Sloan Alley','mswyn21@hibu.com','AMP (Asociación Mutual del Personal de la Universidad Nacional de Tucumán)','PACIENTE'),(75,'26487835','Figin','Clay','1969-03-24','5357 Spenser Road','cfigin22@slate.com','UOM (Unión Obrera Metalúrgica)','PACIENTE'),(76,'51663994','Kenrick','Wendye','1966-07-05','8502 Bayside Crossing','wkenrick23@aboutads.info','Sancor Salud','PACIENTE'),(77,'23389370','Storrock','Deerdre','2012-06-27','3832 Sutteridge Place','dstorrock24@exblog.jp','Medicus','PACIENTE'),(78,'17931042','Witchard','Kore','1963-09-19','2 Bunker Hill Place','kwitchard25@howstuffworks.com','OSPATCA (Obra Social del Personal Auxiliar de Casas Particulares)','PACIENTE'),(79,'55989961','Pavy','Dana','1966-03-20','51489 Lake View Street','dpavy26@imageshack.us','Medicus','PACIENTE'),(80,'43968764','Robbey','Asher','1983-03-11','246 Stone Corner Junction','arobbey27@cornell.edu','IAPS (Instituto de Asistencia Social del Neuquén)','PACIENTE'),(81,'36796119','Kiff','Dorian','1995-12-03','77 Golf View Place','dkiff28@storify.com','AMEPA (Asociación Mutual de Empleados del Poder Judicial)','PACIENTE'),(82,'46647824','Housbey','Hendrick','1997-11-06','6 Redwing Avenue','hhousbey29@github.io','Obra Social de la Universidad Nacional de Córdoba','PACIENTE'),(83,'42689413','Errigo','Vin','2003-03-30','8931 Straubel Terrace','verrigo2a@ning.com','Caja de Servicios Sociales de la Universidad Nacional del Sur','PACIENTE'),(84,'33704770','Tuffley','Nicola','1996-01-23','7 Hollow Ridge Junction','ntuffley2b@rediff.com','UPCN (Unión del Personal Civil de la Nación)','PACIENTE'),(85,'37014801','Colman','Karleen','1972-11-28','506 Oneill Place','kcolman2c@reference.com','Accord Salud','PACIENTE'),(86,'19928102','Dalli','Anthony','1987-02-01','9030 Barby Pass','adalli2d@cbc.ca','Medicus','PACIENTE'),(87,'14010176','Rowcliffe','Antoni','1965-11-01','6048 Logan Lane','arowcliffe2e@nationalgeographic.com','OSPA (Obra Social del Personal de la Actividad Aseguradora)','PACIENTE'),(88,'38325160','Gokes','Fae','1966-06-01','3 Shelley Point','fgokes2f@ning.com','OSMATA (Obra Social del Personal de la Actividad del Turf)','PACIENTE'),(89,'31205338','Dedman','Zackariah','2002-12-26','34116 Sherman Pass','zdedman2g@sina.com.cn','OSPAT (Obra Social del Personal de la Actividad del Turf)','PACIENTE'),(90,'41897996','Kares','Chick','2000-12-06','261 Eagle Crest Junction','ckares2h@artisteer.com','PARTICULAR','PACIENTE'),(91,'22819360','Spurrett','Lonnie','1986-07-26','3 Ryan Terrace','lspurrett2i@github.io','UOM (Unión Obrera Metalúrgica)','PACIENTE'),(92,'37061752','Bigland','Valry','1996-07-12','629 Lerdahl Terrace','vbigland2j@biblegateway.com','OSPV (Obra Social de Petroleros y Gas Privado de la Patagonia Austral)','PACIENTE'),(93,'23112911','Brastead','Lindsey','1979-06-24','980 Paget Drive','lbrastead2k@wisc.edu','UOM (Unión Obrera Metalúrgica)','PACIENTE'),(94,'12478741','Gergus','Marwin','1999-01-03','98888 Truax Trail','mgergus2l@squidoo.com','AMEPA (Asociación Mutual de Empleados del Poder Judicial)','PACIENTE'),(95,'26037202','Bartunek','Gav','1993-10-07','10 Sutherland Pass','gbartunek2m@yahoo.com','AMFFA (Asociación Mutual de los Ferroviarios Argentinos)','PACIENTE'),(96,'14065661','Thom','Kiel','1991-10-04','0614 Bunting Place','kthom2n@people.com.cn','Obra Social de la Universidad Nacional de Córdoba','PACIENTE'),(97,'35958017','Pele','Madella','1983-10-05','66 Forest Pass','mpele2o@baidu.com','Sancor Salud','PACIENTE'),(98,'14077095','Lombard','Tansy','1986-02-16','029 Lighthouse Bay Drive','tlombard2p@netvibes.com','IOMA (Instituto de Obra Médico Asistencial)','PACIENTE'),(99,'49477220','Eagland','Charo','1973-01-13','9 Westerfield Place','ceagland2q@ibm.com','IPAUSS (Instituto Provincial Autárquico Unificado de Seguridad Social)','PACIENTE'),(100,'50765251','Asher','Frayda','2009-06-26','509 6th Trail','fasher2r@wisc.edu','PARTICULAR','PACIENTE'),(101,'33043507','Searchwell','Shayla','2000-08-01','9081 Norway Maple Drive','ssearchwell2s@gmpg.org','OSPAT (Obra Social del Personal de la Actividad del Turf)','PACIENTE'),(102,'54809849','Ivery','Kameko','2000-09-01','81 7th Center','kivery2t@clickbank.net','OSFFENTOS (Obra Social Ferroviaria de Fomento)','PACIENTE'),(103,'20673541','Bett','Sallyann','1974-10-12','35 Fieldstone Place','sbett2u@fda.gov','AMP (Asociación Mutual del Personal de la Universidad Nacional de Tucumán)','PACIENTE'),(104,'27067766','Baughn','Timmi','1996-12-02','6375 Dixon Circle','tbaughn2v@imdb.com','Medicus','PACIENTE'),(105,'42494126','Kingsly','Peggi','1990-04-28','779 Cordelia Drive','pkingsly2w@aboutads.info','OSPATCA (Obra Social del Personal Auxiliar de Casas Particulares)','PACIENTE'),(106,'14422108','Barge','Peadar','1971-02-11','3 Susan Park','pbarge2x@ow.ly','OSPA (Obra Social del Personal de la Actividad Aseguradora)','PACIENTE'),(107,'41824177','Rising','Niccolo','1969-01-28','0 West Road','nrising2y@walmart.com','OSDE','PACIENTE'),(108,'55391019','Pickavant','Pat','1969-12-09','05 Eggendart Crossing','ppickavant2z@jimdo.com','PARTICULAR','PACIENTE'),(109,'43752812','Bambrick','Doe','1970-11-14','73 High Crossing Parkway','dbambrick30@flickr.com','OSPAT (Obra Social del Personal de la Actividad del Turf)','PACIENTE'),(110,'28083943','Gorham','Cob','1963-09-10','51960 Magdeline Junction','cgorham31@livejournal.com','IAPS (Instituto de Asistencia Social del Neuquén)','PACIENTE'),(111,'12467221','Willman','Eba','1999-04-07','63614 Anniversary Crossing','ewillman32@opera.com','OSPV (Obra Social de Petroleros y Gas Privado de la Patagonia Austral)','PACIENTE'),(112,'22916672','Cassam','Caroline','1968-05-30','07 Basil Hill','ccassam33@godaddy.com','OSDE','PACIENTE'),(113,'44077068','Keddey','Pincas','1972-11-15','801 Monterey Point','pkeddey34@1688.com','UOM (Unión Obrera Metalúrgica)','PACIENTE'),(114,'17237798','Rea','Ali','2009-07-05','89368 Shoshone Place','area35@tripadvisor.com','OSEF (Obra Social del Estado Fueguino)','PACIENTE'),(115,'26465871','Holleworth','Tedda','1990-01-02','39115 Banding Hill','tholleworth36@house.gov','IOMA (Instituto de Obra Médico Asistencial)','PACIENTE'),(116,'53240292','Kanzler','Theodosia','2006-02-02','83670 Porter Crossing','tkanzler37@mit.edu','OSMATA (Obra Social del Personal de la Industria Azucarera)','PACIENTE'),(117,'14954467','Jepperson','Duffie','2005-08-02','61 Crownhardt Plaza','djepperson38@cargocollective.com','OSMATA (Obra Social del Personal de la Industria Azucarera)','PACIENTE'),(118,'14678545','Schusterl','Stinky','1963-07-21','9025 Farragut Hill','sschusterl39@psu.edu','PAMI (Programa de Atención Médica Integral)','PACIENTE'),(119,'34477243','Stevenson','Major','1984-05-14','73 Prairieview Parkway','mstevenson3a@multiply.com','UOM (Unión Obrera Metalúrgica)','PACIENTE'),(120,'13278350','Valasek','Vinni','1973-08-11','67 Clyde Gallagher Junction','vvalasek3b@issuu.com','IAPOS (Instituto Autárquico Provincial de Obra Social)','PACIENTE'),(121,'32434714','Tackley','Kingsley','1962-01-08','50 Helena Drive','ktackley3c@shutterfly.com','Swiss Medical','PACIENTE'),(122,'42577254','Danforth','Kacie','2008-10-31','069 Cottonwood Road','kdanforth3d@imageshack.us','OSMATA (Obra Social del Personal de la Industria Azucarera)','PACIENTE'),(123,'19853691','Fawkes','Beckie','1967-10-04','37467 Pearson Trail','bfawkes3e@google.com','OSPV (Obra Social de Petroleros y Gas Privado de la Patagonia Austral)','PACIENTE'),(124,'31192631','Sleite','Toinette','1969-12-03','3870 Anderson Center','tsleite3f@dot.gov','OSMATA (Obra Social del Personal de la Industria Azucarera)','PACIENTE'),(125,'52086269','Godart','Orrin','1997-02-22','13 Arrowood Court','ogodart3g@pen.io','AMEPA (Asociación Mutual de Empleados del Poder Judicial)','PACIENTE'),(126,'50231654','Rittmeyer','Sarette','2015-08-18','63 Susan Point','srittmeyer3h@wix.com','Obra Social de la Universidad Nacional de Córdoba','PACIENTE'),(127,'13498061','Petworth','Eadmund','1987-03-25','2228 Hudson Terrace','epetworth3i@businessinsider.com','Medicus','PACIENTE'),(128,'26734093','Seekings','Palmer','1989-11-02','763 Memorial Way','pseekings3j@github.com','IPAUSS (Instituto Provincial Autárquico Unificado de Seguridad Social)','PACIENTE'),(129,'28492402','Frill','Brianna','1970-12-31','140 Truax Junction','bfrill3k@chron.com','Accord Salud','PACIENTE'),(130,'27139833','Titman','Corie','2001-09-21','0 8th Trail','ctitman3l@privacy.gov.au','OSECAC (Obra Social de Empleados de Comercio y Actividades Civiles)','PACIENTE'),(131,'50035084','Malden','Amby','1989-08-24','04 Gale Alley','amalden3m@furl.net','OSEF (Obra Social del Estado Fueguino)','PACIENTE'),(132,'14015974','Saffle','Jocko','2004-11-17','61914 Iowa Way','jsaffle3n@engadget.com','IAPS (Instituto de Asistencia Social del Neuquén)','PACIENTE'),(133,'36292084','Shipway','Nicolle','2009-05-29','56 Dennis Street','nshipway3o@etsy.com','Obra Social Bancaria Argentina','PACIENTE'),(134,'37766551','Stratten','Sawyer','1971-07-28','6547 Blue Bill Park Crossing','sstratten3p@foxnews.com','Accord Salud','PACIENTE'),(135,'31881425','Bunnell','Mead','1995-06-22','269 Burrows Place','mbunnell3q@etsy.com','Obra Social de la Universidad Nacional de Córdoba','PACIENTE'),(136,'23230922','Flacknell','Werner','2015-10-16','7586 Nevada Drive','wflacknell3r@reverbnation.com','Obras Sociales Provinciales (varias según cada provincia)','PACIENTE'),(137,'41322208','Licciardiello','Felecia','1967-01-23','4052 Swallow Hill','flicciardiello3s@bigcartel.com','OSFFENTOS (Obra Social Ferroviaria de Fomento)','PACIENTE'),(138,'26752226','Block','Cyndy','1982-11-30','6 Bobwhite Street','cblock3t@java.com','OSPV (Obra Social de Petroleros y Gas Privado de la Patagonia Austral)','PACIENTE'),(139,'50022992','Rotter','Marjory','2013-05-14','7394 Fallview Center','mrotter3u@fotki.com','IAPS (Instituto de Asistencia Social del Neuquén)','PACIENTE'),(140,'46783996','Gothrup','Reagan','2006-05-17','29 Trailsway Circle','rgothrup3v@google.cn','OSMATA (Obra Social del Personal de la Actividad del Turf)','PACIENTE'),(141,'24262784','Skates','Emiline','2002-01-16','3 Glendale Crossing','eskates3w@cnn.com','OSEF (Obra Social del Estado Fueguino)','PACIENTE'),(142,'54851166','Sindle','Venita','2007-05-12','8 Michigan Terrace','vsindle3x@edublogs.org','OSPA (Obra Social del Personal de la Actividad Aseguradora)','PACIENTE'),(143,'36829967','Strute','Donella','2014-09-17','015 Anzinger Point','dstrute3y@bbb.org','AMFFA (Asociación Mutual de los Ferroviarios Argentinos)','PACIENTE'),(144,'46675055','Slack','Bill','1970-02-04','9071 North Terrace','bslack3z@ehow.com','OSEF (Obra Social del Estado Fueguino)','PACIENTE'),(145,'42313718','Shiel','Arman','1980-03-15','68845 Mosinee Circle','ashiel40@xrea.com','Obras Sociales Provinciales (varias según cada provincia)','PACIENTE'),(146,'26131545','Taw','Chaunce','1960-07-17','52583 Ilene Circle','ctaw41@homestead.com','Medicus','PACIENTE'),(147,'45271575','Tessier','Jimmy','1997-05-08','16163 Darwin Drive','jtessier42@woothemes.com','UOM (Unión Obrera Metalúrgica)','PACIENTE'),(148,'36170272','Bridson','Yolane','1961-08-09','91673 Northport Junction','ybridson43@cdbaby.com','OSPJN (Obra Social del Poder Judicial de la Nación)','PACIENTE'),(149,'55876664','Goulthorp','Alexine','1976-03-27','700 Jackson Point','agoulthorp44@cmu.edu','DASPU (Dirección de Asistencia Social del Personal Universitario)','PACIENTE'),(150,'45197754','Amerighi','Hana','2006-07-22','582 Montana Trail','hamerighi45@uiuc.edu','Accord Salud','PACIENTE'),(151,'50978342','Stodd','Kennie','1971-08-15','7 Monterey Court','kstodd46@ning.com','OSMATA (Obra Social del Personal de la Industria Azucarera)','PACIENTE'),(152,'29645507','Cubitt','Rosemary','2006-02-24','98 Mallard Terrace','rcubitt47@amazon.co.uk','OSPAT (Obra Social del Personal de la Actividad del Turf)','PACIENTE'),(153,'41297582','Checci','Daniella','1979-02-01','82099 Sage Junction','dchecci48@discuz.net','IAPS (Instituto de Asistencia Social del Neuquén)','PACIENTE'),(154,'33137714','Kinnoch','Brandise','1963-04-10','317 Scofield Point','bkinnoch49@icq.com','OSPRERA (Obra Social de los Empleados de la República Argentina)','PACIENTE'),(155,'33727670','Cristoforetti','Sheila-kathryn','2007-06-10','81 Bobwhite Way','scristoforetti4a@nsw.gov.au','Galeno','PACIENTE'),(156,'49605213','Haine','Berni','1971-08-21','56977 Daystar Drive','bhaine4b@ft.com','IPAUSS (Instituto Provincial Autárquico Unificado de Seguridad Social)','PACIENTE'),(157,'55916076','Oakland','Ginni','1996-08-31','68230 Autumn Leaf Court','goakland4c@nasa.gov','UOM (Unión Obrera Metalúrgica)','PACIENTE'),(158,'47526774','Lukock','Rhianon','1990-07-03','48 Marcy Place','rlukock4d@indiegogo.com','OSMATA (Obra Social del Personal de la Actividad del Turf)','PACIENTE'),(159,'52673450','Meak','Alejoa','1982-12-12','698 Moulton Lane','ameak4e@sitemeter.com','AMEPA (Asociación Mutual de Empleados del Poder Judicial)','PACIENTE'),(160,'41982467','Dagger','Xylina','2010-04-11','76494 Monument Avenue','xdagger4f@wisc.edu','OSPRERA (Obra Social de los Empleados de la República Argentina)','PACIENTE'),(161,'48070936','Maydway','Roberto','2000-10-31','0 Victoria Lane','rmaydway4g@washington.edu','Accord Salud','PACIENTE'),(162,'23783913','Lill','Alphonse','1991-06-18','838 Sherman Street','alill4h@bluehost.com','OSEF (Obra Social del Estado Fueguino)','PACIENTE'),(163,'14501958','Galbraeth','Flss','1999-03-01','83847 Eastwood Parkway','fgalbraeth4i@salon.com','IOMA (Instituto de Obra Médico Asistencial)','PACIENTE'),(164,'19392790','Willingam','Edlin','1976-06-12','89 Shoshone Crossing','ewillingam4j@army.mil','OSFFENTOS (Obra Social Ferroviaria de Fomento)','PACIENTE'),(165,'26831952','Madden','Elliot','2004-11-29','838 Killdeer Terrace','emadden4k@google.ru','OSPA (Obra Social del Personal de la Actividad Aseguradora)','PACIENTE'),(166,'44473882','McCreath','Vinson','2009-11-08','0 John Wall Crossing','vmccreath4l@blog.com','OSPA (Obra Social del Personal de la Actividad Aseguradora)','PACIENTE'),(167,'50776376','Cosyns','Tony','1967-03-17','5872 Di Loreto Center','tcosyns4m@tuttocitta.it','OSEF (Obra Social del Estado Fueguino)','PACIENTE'),(168,'18170313','McClenan','Sandye','1974-05-22','8621 Sommers Parkway','smcclenan4n@indiatimes.com','UPCN (Unión del Personal Civil de la Nación)','PACIENTE'),(169,'33729020','Sedgeworth','Freeman','1973-10-29','261 Transport Point','fsedgeworth4o@chronoengine.com','SADAIC (Sociedad Argentina de Autores y Compositores de Música)','PACIENTE'),(170,'41355788','Walkley','Park','1993-07-08','848 Roth Street','pwalkley4p@fda.gov','AMP (Asociación Mutual del Personal de la Universidad Nacional de Tucumán)','PACIENTE');
/*!40000 ALTER TABLE `pacientes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pacientes_telefonos`
--

DROP TABLE IF EXISTS `pacientes_telefonos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pacientes_telefonos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_paciente` int DEFAULT NULL,
  `descripcion` enum('CELULAR','FIJO') NOT NULL,
  `telefono` varchar(20) NOT NULL,
  `notas_adicionales` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_paciente` (`id_paciente`),
  CONSTRAINT `pacientes_telefonos_ibfk_1` FOREIGN KEY (`id_paciente`) REFERENCES `pacientes` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=211 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pacientes_telefonos`
--

LOCK TABLES `pacientes_telefonos` WRITE;
/*!40000 ALTER TABLE `pacientes_telefonos` DISABLE KEYS */;
INSERT INTO `pacientes_telefonos` VALUES (1,1,'FIJO','9593934882',NULL),(2,2,'CELULAR','3581931312',NULL),(3,3,'CELULAR','1433654774',NULL),(4,4,'CELULAR','3353772627',NULL),(5,5,'FIJO','2818184252',NULL),(6,6,'FIJO','8959755380',NULL),(7,7,'CELULAR','5258246631',NULL),(8,8,'CELULAR','6408398377',NULL),(9,9,'FIJO','2123486052',NULL),(10,10,'CELULAR','6934516821',NULL),(11,11,'CELULAR','6799420849',NULL),(12,12,'FIJO','6938558138',NULL),(13,13,'CELULAR','5688917849',NULL),(14,14,'CELULAR','7662891221',NULL),(15,15,'FIJO','8153486161',NULL),(16,16,'FIJO','4681034675',NULL),(17,17,'FIJO','8019819377',NULL),(18,18,'CELULAR','5301031224',NULL),(19,19,'FIJO','9721514893',NULL),(20,20,'FIJO','9699754684',NULL),(21,21,'FIJO','7616818659',NULL),(22,22,'FIJO','3007144412',NULL),(23,23,'FIJO','5998756000',NULL),(24,24,'CELULAR','7437948788',NULL),(25,25,'FIJO','5089014942',NULL),(26,26,'FIJO','4041094371',NULL),(27,27,'FIJO','9522878161',NULL),(28,28,'FIJO','2582453609',NULL),(29,29,'FIJO','3006818170',NULL),(30,30,'CELULAR','8216999036',NULL),(31,31,'CELULAR','4763056397',NULL),(32,32,'CELULAR','3633301262',NULL),(33,33,'CELULAR','9193383179',NULL),(34,34,'FIJO','1508495313',NULL),(35,35,'CELULAR','5081921669',NULL),(36,36,'CELULAR','3083119696',NULL),(37,37,'CELULAR','4953198105',NULL),(38,38,'CELULAR','8609679884',NULL),(39,39,'CELULAR','9174335541',NULL),(40,40,'CELULAR','5756889424',NULL),(41,41,'FIJO','7167714015',NULL),(42,42,'FIJO','1791655539',NULL),(43,43,'CELULAR','2025111906',NULL),(44,44,'FIJO','1059282333',NULL),(45,45,'FIJO','9385503289',NULL),(46,46,'CELULAR','6971622924',NULL),(47,47,'CELULAR','5913641139',NULL),(48,48,'FIJO','5441449845',NULL),(49,49,'CELULAR','9063137709',NULL),(50,50,'FIJO','5562517755',NULL),(51,51,'CELULAR','6345174155',NULL),(52,52,'CELULAR','3144898825',NULL),(53,53,'CELULAR','4885192211',NULL),(54,54,'CELULAR','8434888091',NULL),(55,55,'FIJO','6165414705',NULL),(56,56,'CELULAR','3155644064',NULL),(57,57,'CELULAR','9169696581',NULL),(58,58,'FIJO','2731623258',NULL),(59,59,'CELULAR','9005971890',NULL),(60,60,'FIJO','8641483883',NULL),(61,61,'FIJO','1119262296',NULL),(62,62,'FIJO','2476358065',NULL),(63,63,'FIJO','5873388944',NULL),(64,64,'CELULAR','4269898524',NULL),(65,65,'CELULAR','6542376026',NULL),(66,66,'FIJO','5139223259',NULL),(67,67,'FIJO','7934460547',NULL),(68,68,'FIJO','1276989703',NULL),(69,69,'CELULAR','1022520536',NULL),(70,70,'FIJO','8643091431',NULL),(71,71,'FIJO','9099475885',NULL),(72,72,'CELULAR','5663601133',NULL),(73,73,'CELULAR','2055610984',NULL),(74,74,'FIJO','2825545299',NULL),(75,75,'CELULAR','4895254728',NULL),(76,76,'CELULAR','1498028851',NULL),(77,77,'FIJO','6781061484',NULL),(78,78,'CELULAR','6987556845',NULL),(79,79,'CELULAR','3921075160',NULL),(80,80,'CELULAR','6261947516',NULL),(81,81,'FIJO','6123817940',NULL),(82,82,'CELULAR','4054828469',NULL),(83,83,'FIJO','7429066909',NULL),(84,84,'CELULAR','5091085136',NULL),(85,85,'FIJO','2535293970',NULL),(86,86,'CELULAR','9494665154',NULL),(87,87,'CELULAR','3738250362',NULL),(88,88,'FIJO','5443879508',NULL),(89,89,'CELULAR','8926045021',NULL),(90,90,'CELULAR','5596059266',NULL),(91,91,'FIJO','1356726364',NULL),(92,92,'CELULAR','3058580068',NULL),(93,93,'FIJO','5972091665',NULL),(94,94,'CELULAR','3157650116',NULL),(95,95,'CELULAR','9077018717',NULL),(96,96,'FIJO','3126658354',NULL),(97,97,'FIJO','5381881290',NULL),(98,98,'CELULAR','3729313110',NULL),(99,99,'FIJO','3903405899',NULL),(100,100,'FIJO','3351365352',NULL),(101,101,'FIJO','5884833941',NULL),(102,102,'FIJO','1103842733',NULL),(103,103,'CELULAR','8328616591',NULL),(104,104,'CELULAR','2286536670',NULL),(105,105,'FIJO','6827214654',NULL),(106,106,'FIJO','1877397047',NULL),(107,107,'FIJO','9077593684',NULL),(108,108,'CELULAR','4839449812',NULL),(109,109,'CELULAR','9026928320',NULL),(110,110,'FIJO','2697062633',NULL),(111,111,'FIJO','7721851038',NULL),(112,112,'FIJO','3378390266',NULL),(113,113,'CELULAR','6808928165',NULL),(114,114,'CELULAR','2993776570',NULL),(115,115,'CELULAR','9518542900',NULL),(116,116,'CELULAR','2818123269',NULL),(117,117,'FIJO','6896179310',NULL),(118,118,'CELULAR','1943097168',NULL),(119,119,'CELULAR','6976227337',NULL),(120,120,'FIJO','6441509498',NULL),(121,121,'FIJO','8374212418',NULL),(122,122,'CELULAR','5125666011',NULL),(123,123,'CELULAR','3248620374',NULL),(124,124,'CELULAR','4951866937',NULL),(125,125,'CELULAR','9132091951',NULL),(126,126,'FIJO','9245929778',NULL),(127,127,'CELULAR','1132561100',NULL),(128,128,'CELULAR','5627799205',NULL),(129,129,'FIJO','2125189897',NULL),(130,130,'CELULAR','1179127417',NULL),(131,131,'CELULAR','5853483899',NULL),(132,132,'FIJO','8936919697',NULL),(133,133,'CELULAR','1681185731',NULL),(134,134,'FIJO','3716266698',NULL),(135,135,'CELULAR','1697035054',NULL),(136,136,'FIJO','7061828995',NULL),(137,137,'CELULAR','2925329342',NULL),(138,138,'FIJO','2784125571',NULL),(139,139,'CELULAR','7468537757',NULL),(140,140,'CELULAR','1507233972',NULL),(141,141,'FIJO','3826183800',NULL),(142,142,'FIJO','5018213324',NULL),(143,143,'FIJO','4395580728',NULL),(144,144,'FIJO','4046415932',NULL),(145,145,'FIJO','1379977279',NULL),(146,146,'FIJO','5122914710',NULL),(147,147,'CELULAR','7164928521',NULL),(148,148,'FIJO','7073619509',NULL),(149,149,'CELULAR','3633773329',NULL),(150,150,'FIJO','8117882179',NULL),(151,151,'CELULAR','2444085204',NULL),(152,152,'FIJO','9021511486',NULL),(153,153,'FIJO','2631016138',NULL),(154,154,'FIJO','1753767966',NULL),(155,155,'CELULAR','4621744597',NULL),(156,156,'CELULAR','7166344665',NULL),(157,157,'FIJO','3495063727',NULL),(158,158,'FIJO','4382484444',NULL),(159,159,'CELULAR','9314924055',NULL),(160,160,'CELULAR','1101890912',NULL),(161,161,'CELULAR','7905393502',NULL),(162,162,'FIJO','1375704371',NULL),(163,163,'CELULAR','6444508200',NULL),(164,164,'FIJO','6301147076',NULL),(165,165,'CELULAR','8036201698',NULL),(166,166,'CELULAR','2477738340',NULL),(167,167,'FIJO','6047883537',NULL),(168,168,'CELULAR','3331289600',NULL),(169,169,'CELULAR','9432880481',NULL),(170,170,'CELULAR','8316873763',NULL),(171,11,'FIJO','7853728740',NULL),(172,12,'FIJO','7939524906',NULL),(173,13,'CELULAR','8422702244',NULL),(174,54,'FIJO','8438369365',NULL),(175,55,'FIJO','1836479002',NULL),(176,56,'CELULAR','1491174952',NULL),(177,17,'CELULAR','2059411817',NULL),(178,18,'FIJO','4499768667',NULL),(179,89,'CELULAR','1229357681',NULL),(180,80,'FIJO','5937287811',NULL),(181,81,'CELULAR','1269094420',NULL),(182,12,'FIJO','6137203250',NULL),(183,13,'FIJO','9974431993',NULL),(184,94,'CELULAR','1294705735',NULL),(185,95,'CELULAR','1445873258',NULL),(186,96,'CELULAR','5882525696',NULL),(187,17,'FIJO','2085303087',NULL),(188,18,'FIJO','5305101819',NULL),(189,19,'FIJO','5844427015',NULL),(190,110,'FIJO','3735009915',NULL),(191,111,'CELULAR','4152463534',NULL),(192,112,'CELULAR','5676154907',NULL),(193,13,'CELULAR','9899460795',NULL),(194,14,'CELULAR','6212408144',NULL),(195,151,'CELULAR','4567571007',NULL),(196,161,'CELULAR','1159706971',NULL),(197,170,'CELULAR','3955071703',NULL),(198,18,'CELULAR','1185618624',NULL),(199,19,'CELULAR','5368917181',NULL),(200,20,'FIJO','5928213779',NULL),(201,71,'FIJO','3363643182',NULL),(202,72,'FIJO','6795777881',NULL),(203,73,'FIJO','4587169771',NULL),(204,24,'FIJO','4006211973',NULL),(205,25,'FIJO','2635268741',NULL),(206,86,'CELULAR','8349851236',NULL),(207,87,'FIJO','4677766961',NULL),(208,88,'FIJO','5215604760',NULL),(209,29,'FIJO','2472122825',NULL),(210,20,'CELULAR','2138600242',NULL);
/*!40000 ALTER TABLE `pacientes_telefonos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `recetas`
--

DROP TABLE IF EXISTS `recetas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `recetas` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_obra_social` int DEFAULT NULL,
  `id_paciente` int DEFAULT NULL,
  `id_medico` int DEFAULT NULL,
  `fecha_emision` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `medicamento_recetado` varchar(100) DEFAULT NULL,
  `notas_adicionales` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_obra_social` (`id_obra_social`),
  KEY `id_paciente` (`id_paciente`),
  KEY `id_medico` (`id_medico`),
  CONSTRAINT `recetas_ibfk_1` FOREIGN KEY (`id_obra_social`) REFERENCES `obras_sociales` (`id`),
  CONSTRAINT `recetas_ibfk_2` FOREIGN KEY (`id_paciente`) REFERENCES `pacientes` (`id`),
  CONSTRAINT `recetas_ibfk_3` FOREIGN KEY (`id_medico`) REFERENCES `medicos` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=491 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recetas`
--

LOCK TABLES `recetas` WRITE;
/*!40000 ALTER TABLE `recetas` DISABLE KEYS */;
/*!40000 ALTER TABLE `recetas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rendimiento_medico`
--

DROP TABLE IF EXISTS `rendimiento_medico`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rendimiento_medico` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_medico` int DEFAULT NULL,
  `medico_fullname` varchar(300) DEFAULT NULL,
  `total_ingreso_generado` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_medico` (`id_medico`),
  CONSTRAINT `rendimiento_medico_ibfk_1` FOREIGN KEY (`id_medico`) REFERENCES `medicos` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=61 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rendimiento_medico`
--

LOCK TABLES `rendimiento_medico` WRITE;
/*!40000 ALTER TABLE `rendimiento_medico` DISABLE KEYS */;
/*!40000 ALTER TABLE `rendimiento_medico` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tarifas`
--

DROP TABLE IF EXISTS `tarifas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tarifas` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_obra_social` int DEFAULT NULL,
  `tarifa_normal` decimal(10,2) NOT NULL,
  `tarifa_obra_social` decimal(10,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `id_obra_social` (`id_obra_social`),
  CONSTRAINT `tarifas_ibfk_1` FOREIGN KEY (`id_obra_social`) REFERENCES `obras_sociales` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tarifas`
--

LOCK TABLES `tarifas` WRITE;
/*!40000 ALTER TABLE `tarifas` DISABLE KEYS */;
/*!40000 ALTER TABLE `tarifas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuarios_sistema`
--

DROP TABLE IF EXISTS `usuarios_sistema`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuarios_sistema` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(100) NOT NULL,
  `pass` varchar(12) NOT NULL,
  `rol` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=66 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuarios_sistema`
--

LOCK TABLES `usuarios_sistema` WRITE;
/*!40000 ALTER TABLE `usuarios_sistema` DISABLE KEYS */;
/*!40000 ALTER TABLE `usuarios_sistema` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `vw_citas_pendientes`
--

DROP TABLE IF EXISTS `vw_citas_pendientes`;
/*!50001 DROP VIEW IF EXISTS `vw_citas_pendientes`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_citas_pendientes` AS SELECT 
 1 AS `cita_id`,
 1 AS `fecha`,
 1 AS `hora`,
 1 AS `medico`,
 1 AS `paciente`,
 1 AS `administrativo`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_facturas_paciente_obra_social`
--

DROP TABLE IF EXISTS `vw_facturas_paciente_obra_social`;
/*!50001 DROP VIEW IF EXISTS `vw_facturas_paciente_obra_social`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_facturas_paciente_obra_social` AS SELECT 
 1 AS `numero_factura`,
 1 AS `fecha_emision`,
 1 AS `total_factura`,
 1 AS `paciente`,
 1 AS `nombre_obra_social`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_facturas_pendientes`
--

DROP TABLE IF EXISTS `vw_facturas_pendientes`;
/*!50001 DROP VIEW IF EXISTS `vw_facturas_pendientes`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_facturas_pendientes` AS SELECT 
 1 AS `factura_id`,
 1 AS `numero_factura`,
 1 AS `fecha_emision`,
 1 AS `paciente`,
 1 AS `total_factura`,
 1 AS `fecha_vencimiento`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_historial_medico`
--

DROP TABLE IF EXISTS `vw_historial_medico`;
/*!50001 DROP VIEW IF EXISTS `vw_historial_medico`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_historial_medico` AS SELECT 
 1 AS `fecha_registro`,
 1 AS `nota_medica`,
 1 AS `paciente`,
 1 AS `medico`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_info_administrativos`
--

DROP TABLE IF EXISTS `vw_info_administrativos`;
/*!50001 DROP VIEW IF EXISTS `vw_info_administrativos`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_info_administrativos` AS SELECT 
 1 AS `administrativo`,
 1 AS `tipo_telefono`,
 1 AS `telefono`,
 1 AS `correo_electronico`,
 1 AS `domicilio`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_info_medicos`
--

DROP TABLE IF EXISTS `vw_info_medicos`;
/*!50001 DROP VIEW IF EXISTS `vw_info_medicos`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_info_medicos` AS SELECT 
 1 AS `medico`,
 1 AS `tipo_telefono`,
 1 AS `telefono`,
 1 AS `correo_electronico`,
 1 AS `domicilio`,
 1 AS `especialidad`,
 1 AS `matricula`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_info_pacientes`
--

DROP TABLE IF EXISTS `vw_info_pacientes`;
/*!50001 DROP VIEW IF EXISTS `vw_info_pacientes`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_info_pacientes` AS SELECT 
 1 AS `paciente`,
 1 AS `obra_social`,
 1 AS `tipo_telefono`,
 1 AS `telefono`,
 1 AS `correo_electronico`,
 1 AS `domicilio`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_ingreso_mensual_obras_sociales`
--

DROP TABLE IF EXISTS `vw_ingreso_mensual_obras_sociales`;
/*!50001 DROP VIEW IF EXISTS `vw_ingreso_mensual_obras_sociales`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_ingreso_mensual_obras_sociales` AS SELECT 
 1 AS `obra_social`,
 1 AS `mes_facturado`,
 1 AS `total_facturado`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_ingreso_total_obras_sociales`
--

DROP TABLE IF EXISTS `vw_ingreso_total_obras_sociales`;
/*!50001 DROP VIEW IF EXISTS `vw_ingreso_total_obras_sociales`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_ingreso_total_obras_sociales` AS SELECT 
 1 AS `obra_social`,
 1 AS `total_facturado`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_pacientes_con_cobertura`
--

DROP TABLE IF EXISTS `vw_pacientes_con_cobertura`;
/*!50001 DROP VIEW IF EXISTS `vw_pacientes_con_cobertura`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_pacientes_con_cobertura` AS SELECT 
 1 AS `paciente`,
 1 AS `dni`,
 1 AS `obra_social`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_pacientes_sin_cobertura`
--

DROP TABLE IF EXISTS `vw_pacientes_sin_cobertura`;
/*!50001 DROP VIEW IF EXISTS `vw_pacientes_sin_cobertura`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_pacientes_sin_cobertura` AS SELECT 
 1 AS `paciente`,
 1 AS `dni`,
 1 AS `obra_social`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_recetas`
--

DROP TABLE IF EXISTS `vw_recetas`;
/*!50001 DROP VIEW IF EXISTS `vw_recetas`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_recetas` AS SELECT 
 1 AS `fecha_emision`,
 1 AS `medicamento_recetado`,
 1 AS `paciente`,
 1 AS `medico`*/;
SET character_set_client = @saved_cs_client;

--
-- Dumping events for database 'gestionsaluddb'
--

--
-- Dumping routines for database 'gestionsaluddb'
--
/*!50003 DROP FUNCTION IF EXISTS `fn_cantidad_citas_canceladas_por_medico` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_cantidad_citas_canceladas_por_medico`(id_medico INT) RETURNS int
    NO SQL
BEGIN
      DECLARE resultado INT;
    	SET resultado =
        (SELECT count(*)
        FROM citas_medicas c
        WHERE c.id_medico = id_medico AND c.estado = 'CANCELADA');
      RETURN resultado;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fn_cantidad_citas_pendientes_por_medico` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_cantidad_citas_pendientes_por_medico`(id_medico INT) RETURNS int
    NO SQL
BEGIN
      DECLARE resultado INT;
    	SET resultado =
        (SELECT count(*)
        FROM citas_medicas c
        WHERE c.id_medico = id_medico AND c.estado = 'PENDIENTE');
      RETURN resultado;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fn_cantidad_citas_realizadas_por_medico` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_cantidad_citas_realizadas_por_medico`(id_medico INT) RETURNS int
    NO SQL
BEGIN
      DECLARE resultado INT;
    	SET resultado =
        (SELECT count(*)
        FROM citas_medicas c
        WHERE c.id_medico = id_medico AND c.estado = 'REALIZADA');
      RETURN resultado;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_citas_pendientes_paciente_dni` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_citas_pendientes_paciente_dni`(IN dni_paciente VARCHAR(10))
BEGIN
    DECLARE citas_count INT;
    
    SELECT COUNT(*) INTO citas_count
    FROM citas_medicas cm
    JOIN pacientes p ON cm.id_paciente = p.id
    WHERE p.dni = dni_paciente AND cm.estado = 'pendiente';

    IF citas_count > 0 THEN
        SELECT cm.id, cm.fecha, cm.hora, cm.estado,
               CONCAT(p.apellido, ' ', p.nombre) AS paciente,
               CONCAT(m.apellido, ' ', m.nombre) AS medico
        FROM citas_medicas cm
        JOIN pacientes p ON cm.id_paciente = p.id
        JOIN medicos m ON cm.id_medico = m.id
        WHERE p.dni = dni_paciente AND cm.estado = 'pendiente';
    ELSE
        SELECT 'NINGUNA CITA ENCONTRADA' AS mensaje;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_facturas_por_paciente_dni` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_facturas_por_paciente_dni`(IN dni_paciente VARCHAR(10))
BEGIN
    DECLARE facturas_count INT;
    
    SELECT COUNT(*) INTO facturas_count
    FROM facturas f
    JOIN pacientes p ON f.id_paciente = p.id
    WHERE p.dni = dni_paciente;

    IF facturas_count > 0 THEN
        SELECT f.id, f.numero_factura, f.fecha_emision, f.total_factura, f.estado,
               CONCAT(p.apellido, ' ', p.nombre) AS paciente,
               CONCAT(m.apellido, ' ', m.nombre) AS medico,
               os.nombre AS obra_social
        FROM facturas f
        JOIN pacientes p ON f.id_paciente = p.id
        JOIN medicos m ON f.id_medico = m.id
        LEFT JOIN obras_sociales os ON f.id_obra_social = os.id
        WHERE p.dni = dni_paciente;
    ELSE
        SELECT 'NINGUNA FACTURA ENCONTRADA' AS mensaje;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_grant_administrativo_permissions` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_grant_administrativo_permissions`(username VARCHAR(100))
BEGIN
    SET @sql = CONCAT('GRANT SELECT, INSERT, UPDATE ON GestionSaludDB.* TO ''', username, '''');
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_grant_auditor_permissions` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_grant_auditor_permissions`(username VARCHAR(100))
BEGIN
    SET @sql = CONCAT('GRANT ALL PRIVILEGES ON GestionSaludDB.* TO ''', username, '''');
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_grant_medico_permissions` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_grant_medico_permissions`(username VARCHAR(100))
BEGIN
    SET @sql = CONCAT(
        'GRANT SELECT, INSERT ON GestionSaludDB.historiales_medicos TO ''', username, '''; ',
        'GRANT SELECT, INSERT ON GestionSaludDB.recetas TO ''', username, '''; ',
        'GRANT SELECT ON GestionSaludDB.pacientes TO ''', username, '''; ',
        'GRANT SELECT ON GestionSaludDB.obras_sociales TO ''', username, '''; ',
        'GRANT SELECT ON GestionSaludDB.tarifas TO ''', username, '''; ',
        'GRANT SELECT ON GestionSaludDB.citas_medicas TO ''', username, '''; ',
        'GRANT SELECT ON GestionSaludDB.horarios_medicos TO ''', username, ''''
    );
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_ingresos_facturacion_mensual` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_ingresos_facturacion_mensual`()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE total DECIMAL(10, 2);
    DECLARE cursor_month DATE;
    DECLARE cur CURSOR FOR
        SELECT DISTINCT DATE_FORMAT(fecha_emision, '%Y-%m-01') AS cursor_month
        FROM facturas;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO cursor_month;
        IF done THEN
            LEAVE read_loop;
        END IF;

        SET total = (
            SELECT COALESCE(SUM(total_factura), 0)
            FROM facturas
            WHERE fecha_emision BETWEEN cursor_month AND LAST_DAY(cursor_month)
        );

        INSERT INTO ingresos_facturacion_mensual (mes_facturado, total_ingreso)
        VALUES (DATE_FORMAT(cursor_month, '%Y-%m'), total)
        ON DUPLICATE KEY UPDATE total_ingreso = total;

    END LOOP;
    CLOSE cur;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_insertar_citas` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_insertar_citas`(
    in p_fecha DATE, 
    in p_hora TIME,
    in p_id_administrativo INT, 
    in p_id_medico INT, 
    in p_id_paciente INT
)
BEGIN
    DECLARE paciente_existente INT;
    
    SELECT COUNT(id) INTO paciente_existente FROM pacientes WHERE id = p_id_paciente;
    
    IF paciente_existente > 0 THEN
        INSERT INTO citas_medicas (fecha, hora, id_administrativo, id_medico, id_paciente)
        VALUES (p_fecha, p_hora, p_id_administrativo, p_id_medico, p_id_paciente);
        
        SELECT id, fecha, estado, id_administrativo, id_medico, id_paciente 
        FROM citas_medicas 
        WHERE id_paciente = p_id_paciente 
        ORDER BY fecha DESC;
    ELSE
        SELECT 'ERROR: El paciente no existe, debe crearlo primero';
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_insertar_paciente` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_insertar_paciente`(
    in p_dni VARCHAR(10), 
    in p_apellido VARCHAR(150), 
    in p_nombre VARCHAR(150), 
    in p_fecha_nacimiento DATE, 
    in p_domicilio VARCHAR(500), 
    in p_correo_electronico VARCHAR(100),
    in p_obra_social VARCHAR(100),
    in p_rol VARCHAR(50)
)
BEGIN
    IF p_dni <> '' AND p_nombre <> '' AND p_apellido <> '' AND p_fecha_nacimiento IS NOT NULL AND p_domicilio <> '' AND p_correo_electronico <> '' THEN
        INSERT INTO pacientes (dni, nombre, apellido, fecha_nacimiento, domicilio, correo_electronico, obra_social, rol) 
        VALUES (p_dni, p_nombre, p_apellido, p_fecha_nacimiento, p_domicilio, p_correo_electronico, p_obra_social, p_rol);
        SELECT * FROM pacientes WHERE dni = p_dni;
    ELSE
        SELECT 'ERROR: Ningún campo puede estar vacío';
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_recetas_por_paciente_dni` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_recetas_por_paciente_dni`(IN dni_paciente VARCHAR(10))
BEGIN
    DECLARE recetas_count INT;
    
    SELECT COUNT(*) INTO recetas_count
    FROM recetas r
    JOIN pacientes p ON r.id_paciente = p.id
    WHERE p.dni = dni_paciente;

    IF recetas_count > 0 THEN
        SELECT r.id, r.fecha_emision, r.medicamento_recetado, r.notas_adicionales,
               CONCAT(p.apellido, ' ', p.nombre) AS paciente,
               CONCAT(m.apellido, ' ', m.nombre) AS medico
        FROM recetas r
        JOIN pacientes p ON r.id_paciente = p.id
        JOIN medicos m ON r.id_medico = m.id
        WHERE p.dni = dni_paciente;
    ELSE
        SELECT 'NINGUNA RECETA ENCONTRADA' AS mensaje;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_rendimiento_medico` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_rendimiento_medico`()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE cursor_medico INT;
    DECLARE fullname VARCHAR(300);
    DECLARE cur CURSOR FOR
        SELECT id, CONCAT(apellido, ' ', nombre) AS medico_fullname
        FROM medicos;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO cursor_medico, fullname;
        IF done THEN
            LEAVE read_loop;
        END IF;

        SET @total = (
            SELECT COALESCE(SUM(total_factura), 0)
            FROM facturas
            WHERE id_medico = cursor_medico
        );

        INSERT INTO rendimiento_medico (id_medico, medico_fullname, total_ingreso_generado)
        VALUES (cursor_medico, fullname, @total)
        ON DUPLICATE KEY UPDATE total_ingreso_generado = @total;

    END LOOP;

    CLOSE cur;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Final view structure for view `vw_citas_pendientes`
--

/*!50001 DROP VIEW IF EXISTS `vw_citas_pendientes`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_citas_pendientes` AS select `c`.`id` AS `cita_id`,`c`.`fecha` AS `fecha`,`c`.`hora` AS `hora`,concat(`m`.`apellido`,' ',`m`.`nombre`) AS `medico`,concat(`p`.`apellido`,' ',`p`.`nombre`) AS `paciente`,concat(`a`.`apellido`,' ',`a`.`nombre`) AS `administrativo` from (((`citas_medicas` `c` join `medicos` `m` on((`c`.`id_medico` = `m`.`id`))) join `pacientes` `p` on((`c`.`id_paciente` = `p`.`id`))) join `administrativos` `a` on((`c`.`id_administrativo` = `a`.`id`))) where (`c`.`estado` = 'PENDIENTE') order by `c`.`fecha` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_facturas_paciente_obra_social`
--

/*!50001 DROP VIEW IF EXISTS `vw_facturas_paciente_obra_social`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_facturas_paciente_obra_social` AS select `f`.`numero_factura` AS `numero_factura`,`f`.`fecha_emision` AS `fecha_emision`,`f`.`total_factura` AS `total_factura`,concat(`p`.`apellido`,' ',`p`.`nombre`) AS `paciente`,`os`.`nombre` AS `nombre_obra_social` from ((`facturas` `f` join `pacientes` `p` on((`f`.`id_paciente` = `p`.`id`))) left join `obras_sociales` `os` on((`f`.`id_obra_social` = `os`.`id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_facturas_pendientes`
--

/*!50001 DROP VIEW IF EXISTS `vw_facturas_pendientes`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_facturas_pendientes` AS select `f`.`id` AS `factura_id`,`f`.`numero_factura` AS `numero_factura`,`f`.`fecha_emision` AS `fecha_emision`,concat(`p`.`apellido`,'',`p`.`nombre`) AS `paciente`,`f`.`total_factura` AS `total_factura`,`f`.`fecha_vencimiento` AS `fecha_vencimiento` from (`facturas` `f` join `pacientes` `p` on((`f`.`id_paciente` = `p`.`id`))) where (`f`.`estado` = 'PENDIENTE') order by `f`.`fecha_vencimiento` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_historial_medico`
--

/*!50001 DROP VIEW IF EXISTS `vw_historial_medico`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_historial_medico` AS select `hm`.`fecha_registro` AS `fecha_registro`,`hm`.`nota_medica` AS `nota_medica`,concat(`p`.`apellido`,' ',`p`.`nombre`) AS `paciente`,concat(`m`.`apellido`,' ',`m`.`nombre`) AS `medico` from ((`historiales_medicos` `hm` join `pacientes` `p` on((`hm`.`id_paciente` = `p`.`id`))) join `medicos` `m` on((`hm`.`id_medico` = `m`.`id`))) order by concat(`p`.`apellido`,' ',`p`.`nombre`) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_info_administrativos`
--

/*!50001 DROP VIEW IF EXISTS `vw_info_administrativos`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_info_administrativos` AS select concat(`a`.`apellido`,' ',`a`.`nombre`) AS `administrativo`,`t`.`descripcion` AS `tipo_telefono`,`t`.`telefono` AS `telefono`,`a`.`correo_electronico` AS `correo_electronico`,`a`.`domicilio` AS `domicilio` from (`administrativos` `a` join `administrativos_telefonos` `t` on((`a`.`id` = `t`.`id_administrativo`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_info_medicos`
--

/*!50001 DROP VIEW IF EXISTS `vw_info_medicos`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_info_medicos` AS select concat(`m`.`apellido`,' ',`m`.`nombre`) AS `medico`,`mt`.`descripcion` AS `tipo_telefono`,`mt`.`telefono` AS `telefono`,`m`.`correo_electronico` AS `correo_electronico`,`m`.`domicilio` AS `domicilio`,`m`.`especialidad` AS `especialidad`,`m`.`matricula` AS `matricula` from (`medicos` `m` join `medicos_telefonos` `mt` on((`m`.`id` = `mt`.`id_medico`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_info_pacientes`
--

/*!50001 DROP VIEW IF EXISTS `vw_info_pacientes`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_info_pacientes` AS select concat(`p`.`apellido`,' ',`p`.`nombre`) AS `paciente`,`p`.`obra_social` AS `obra_social`,`pt`.`descripcion` AS `tipo_telefono`,`pt`.`telefono` AS `telefono`,`p`.`correo_electronico` AS `correo_electronico`,`p`.`domicilio` AS `domicilio` from (`pacientes` `p` join `pacientes_telefonos` `pt` on((`p`.`id` = `pt`.`id_paciente`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_ingreso_mensual_obras_sociales`
--

/*!50001 DROP VIEW IF EXISTS `vw_ingreso_mensual_obras_sociales`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_ingreso_mensual_obras_sociales` AS select `os`.`nombre` AS `obra_social`,date_format(`f`.`fecha_emision`,'%Y-%m') AS `mes_facturado`,sum(`f`.`total_factura`) AS `total_facturado` from (`facturas` `f` join `obras_sociales` `os` on((`f`.`id_obra_social` = `os`.`id`))) group by `os`.`nombre`,`mes_facturado` order by `os`.`nombre` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_ingreso_total_obras_sociales`
--

/*!50001 DROP VIEW IF EXISTS `vw_ingreso_total_obras_sociales`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_ingreso_total_obras_sociales` AS select `os`.`nombre` AS `obra_social`,sum(`f`.`total_factura`) AS `total_facturado` from (`facturas` `f` join `obras_sociales` `os` on((`f`.`id_obra_social` = `os`.`id`))) group by `os`.`nombre` order by `os`.`nombre` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_pacientes_con_cobertura`
--

/*!50001 DROP VIEW IF EXISTS `vw_pacientes_con_cobertura`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_pacientes_con_cobertura` AS select concat(`p`.`apellido`,' ',`p`.`nombre`) AS `paciente`,`p`.`dni` AS `dni`,`p`.`obra_social` AS `obra_social` from `pacientes` `p` where (`p`.`obra_social` <> 'PARTICULAR') order by concat(`p`.`apellido`,' ',`p`.`nombre`) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_pacientes_sin_cobertura`
--

/*!50001 DROP VIEW IF EXISTS `vw_pacientes_sin_cobertura`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_pacientes_sin_cobertura` AS select concat(`p`.`apellido`,' ',`p`.`nombre`) AS `paciente`,`p`.`dni` AS `dni`,`p`.`obra_social` AS `obra_social` from `pacientes` `p` where (`p`.`obra_social` = 'PARTICULAR') */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_recetas`
--

/*!50001 DROP VIEW IF EXISTS `vw_recetas`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_recetas` AS select `r`.`fecha_emision` AS `fecha_emision`,`r`.`medicamento_recetado` AS `medicamento_recetado`,concat(`p`.`apellido`,' ',`p`.`nombre`) AS `paciente`,concat(`m`.`apellido`,' ',`m`.`nombre`) AS `medico` from ((`recetas` `r` join `pacientes` `p` on((`r`.`id_paciente` = `p`.`id`))) join `medicos` `m` on((`r`.`id_medico` = `m`.`id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-08-21 23:56:29
