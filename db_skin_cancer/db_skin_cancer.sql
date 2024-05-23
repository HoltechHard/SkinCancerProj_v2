-- MySQL dump 10.13  Distrib 8.0.33, for Win64 (x86_64)
--
-- Host: localhost    Database: db_skin_cancer
-- ------------------------------------------------------
-- Server version	8.0.33

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
-- Table structure for table `patient`
--

DROP TABLE IF EXISTS `patient`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `patient` (
  `id_patient` int NOT NULL AUTO_INCREMENT,
  `full_name` varchar(200) DEFAULT NULL,
  `age` int DEFAULT NULL,
  `anatomy` varchar(45) DEFAULT NULL,
  `sex` char(1) DEFAULT NULL,
  `class_pred` varchar(45) DEFAULT NULL,
  `prob_pred` decimal(7,5) DEFAULT NULL,
  `url_image` varchar(400) DEFAULT NULL,
  `fk_id_type_image` int NOT NULL,
  PRIMARY KEY (`id_patient`),
  KEY `fk_Patient_Type_image_idx` (`fk_id_type_image`),
  CONSTRAINT `fk_Patient_Type_image` FOREIGN KEY (`fk_id_type_image`) REFERENCES `type_image` (`id_type_image`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `patient`
--

LOCK TABLES `patient` WRITE;
/*!40000 ALTER TABLE `patient` DISABLE KEYS */;
INSERT INTO `patient` VALUES (1,'Anastasia Konstantinova',80,'upper extremity','F','nevus',0.99945,'static/storage/ISIC_0000000.JPG',1),(2,'Denis Krushev',85,'chest','M','nevus',0.99962,'static/storage/ISIC_9998937.JPG',2),(3,'Antonina Kovaleva',78,'face','F','melanoma',0.78336,'static/storage/ISIC_0000004.JPG',3),(4,'Dimitry Sobolev',79,'lower extremity','M','melanoma',0.99992,'static/storage/ISIC_9998682.JPG',2),(5,'Andres Perez',80,'face','M','nevus',0.99962,'static/storage/ISIC_9998937.JPG',4),(6,'Jesus Solorzano',90,'lower extremity','M','basal cell carcinoma',0.63270,'static/storage/image_jesus.jpg',2),(7,'Denis Kovalev',90,'upper extremity','M','nevus',0.99898,'static/storage/ISIC_9991967.JPG',4),(8,'Karina Kudriatsev',71,'face','F','nevus',0.99990,'static/storage/ISIC_9995691.JPG',1),(9,'Holger',90,'upper extremity','M','nevus',0.99955,'static/storage/ISIC_9999806.JPG',1),(10,'Fabricio',80,'upper face','M','nevus',0.99903,'static/storage/ISIC_0000075.JPG',1),(11,'Gabriela Perez',91,'upper extremity','F','melanoma',0.99971,'static/storage/ISIC_0063998.JPG',2),(12,'Jorge Garcia',85,'upper face','M','melanoma',0.99544,'static/storage/ISIC_0063349.JPG',2),(13,'Anita Gibs',70,'lower extremity','F','melanoma',0.99949,'static/storage/ISIC_0057518.JPG',2),(14,'anton',70,'face','M','melanoma',0.99657,'static/storage/ISIC_0000043.JPG',2),(15,'Thomas Repka',25,'lower extremity','M','nevus',0.92975,'static/storage/tomas.png',2);
/*!40000 ALTER TABLE `patient` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `scores`
--

DROP TABLE IF EXISTS `scores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `scores` (
  `fk_id_cancer` int NOT NULL,
  `fk_id_patient` int NOT NULL,
  `prob_score` decimal(7,5) DEFAULT NULL,
  PRIMARY KEY (`fk_id_cancer`,`fk_id_patient`),
  KEY `fk_Scores_Patient1_idx` (`fk_id_patient`),
  CONSTRAINT `fk_Scores_Patient1` FOREIGN KEY (`fk_id_patient`) REFERENCES `patient` (`id_patient`),
  CONSTRAINT `fk_Scores_Type_cancer1` FOREIGN KEY (`fk_id_cancer`) REFERENCES `type_cancer` (`id_cancer`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `scores`
--

LOCK TABLES `scores` WRITE;
/*!40000 ALTER TABLE `scores` DISABLE KEYS */;
INSERT INTO `scores` VALUES (1,1,0.99945),(1,2,0.99962),(1,3,0.00190),(1,4,0.00003),(1,5,0.99962),(1,6,0.08738),(1,7,0.99898),(1,8,0.99990),(1,9,0.99955),(1,10,0.99903),(1,11,0.00025),(1,12,0.00435),(1,13,0.00048),(1,14,0.00325),(1,15,0.92975),(2,1,0.00051),(2,2,0.00029),(2,3,0.78336),(2,4,0.99992),(2,5,0.00029),(2,6,0.07776),(2,7,0.00036),(2,8,0.00005),(2,9,0.00035),(2,10,0.00091),(2,11,0.99971),(2,12,0.99544),(2,13,0.99949),(2,14,0.99657),(2,15,0.07009),(3,1,0.00001),(3,2,0.00001),(3,3,0.00017),(3,4,0.00000),(3,5,0.00001),(3,6,0.01175),(3,7,0.00000),(3,8,0.00000),(3,9,0.00000),(3,10,0.00000),(3,11,0.00001),(3,12,0.00002),(3,13,0.00000),(3,14,0.00011),(3,15,0.00003),(4,1,0.00001),(4,2,0.00002),(4,3,0.21394),(4,4,0.00001),(4,5,0.00002),(4,6,0.63270),(4,7,0.00009),(4,8,0.00000),(4,9,0.00002),(4,10,0.00000),(4,11,0.00001),(4,12,0.00007),(4,13,0.00000),(4,14,0.00002),(4,15,0.00003),(5,1,0.00001),(5,2,0.00001),(5,3,0.00012),(5,4,0.00001),(5,5,0.00001),(5,6,0.00122),(5,7,0.00001),(5,8,0.00000),(5,9,0.00001),(5,10,0.00000),(5,11,0.00001),(5,12,0.00002),(5,13,0.00000),(5,14,0.00000),(5,15,0.00001),(6,1,0.00000),(6,2,0.00000),(6,3,0.00037),(6,4,0.00001),(6,5,0.00000),(6,6,0.17660),(6,7,0.00007),(6,8,0.00000),(6,9,0.00000),(6,10,0.00000),(6,11,0.00000),(6,12,0.00001),(6,13,0.00000),(6,14,0.00000),(6,15,0.00002),(7,1,0.00002),(7,2,0.00005),(7,3,0.00014),(7,4,0.00001),(7,5,0.00005),(7,6,0.01259),(7,7,0.00050),(7,8,0.00004),(7,9,0.00006),(7,10,0.00004),(7,11,0.00001),(7,12,0.00009),(7,13,0.00001),(7,14,0.00004),(7,15,0.00007);
/*!40000 ALTER TABLE `scores` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `type_cancer`
--

DROP TABLE IF EXISTS `type_cancer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `type_cancer` (
  `id_cancer` int NOT NULL AUTO_INCREMENT,
  `description` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id_cancer`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `type_cancer`
--

LOCK TABLES `type_cancer` WRITE;
/*!40000 ALTER TABLE `type_cancer` DISABLE KEYS */;
INSERT INTO `type_cancer` VALUES (1,'nevus'),(2,'melanoma'),(3,'seborrheic keratosis'),(4,'basal cell carcinoma'),(5,'actinic keratosis'),(6,'squamous cell carcinoma'),(7,'pigmented benign keratosis');
/*!40000 ALTER TABLE `type_cancer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `type_image`
--

DROP TABLE IF EXISTS `type_image`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `type_image` (
  `id_type_image` int NOT NULL AUTO_INCREMENT,
  `description` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id_type_image`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `type_image`
--

LOCK TABLES `type_image` WRITE;
/*!40000 ALTER TABLE `type_image` DISABLE KEYS */;
INSERT INTO `type_image` VALUES (1,'dermoscopy'),(2,'histopatology'),(3,'confocal microscopy'),(4,'serial imaging');
/*!40000 ALTER TABLE `type_image` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `vw_cancer`
--

DROP TABLE IF EXISTS `vw_cancer`;
/*!50001 DROP VIEW IF EXISTS `vw_cancer`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_cancer` AS SELECT 
 1 AS `id_cancer`,
 1 AS `description`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_patient`
--

DROP TABLE IF EXISTS `vw_patient`;
/*!50001 DROP VIEW IF EXISTS `vw_patient`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_patient` AS SELECT 
 1 AS `id_patient`,
 1 AS `full_name`,
 1 AS `type_image`,
 1 AS `anatomy`,
 1 AS `age`,
 1 AS `sex`,
 1 AS `class_pred`,
 1 AS `prob_pred`*/;
SET character_set_client = @saved_cs_client;

--
-- Dumping events for database 'db_skin_cancer'
--

--
-- Dumping routines for database 'db_skin_cancer'
--
/*!50003 DROP PROCEDURE IF EXISTS `sp_patient_insert` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_patient_insert`(
	in p_full_name varchar(200),
    in p_age int, 
    in p_anatomy varchar(45),
    in p_sex char(1),
    in p_url_image varchar(400),
    in p_id_type_image int
)
begin
	insert into patient(full_name, age, anatomy, sex, url_image, fk_id_type_image)
    values(p_full_name, p_age, p_anatomy, p_sex, p_url_image, p_id_type_image);
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_patient_predict` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_patient_predict`(
	in p_id int, 
    in p_class_pred varchar(45),
    in p_prob_pred decimal(7, 5)
)
begin
	update patient p
		set p.class_pred = p_class_pred, p.prob_pred = p_prob_pred
    where p.id_patient = p_id;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_patient_search_by_id` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_patient_search_by_id`(
	in p_id int
)
begin 
	select p.id_patient, p.class_pred, p.prob_pred, p.url_image 
    from patient p
    inner join type_image t
    on p.fk_id_type_image = t.id_type_image
    where p.id_patient = p_id;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_score_insert` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_score_insert`(
	in p_id_cancer int, 
    in p_id_patient int,
    in p_prob_score decimal(7, 5)
)
begin 
	insert into scores(fk_id_cancer, fk_id_patient, prob_score)
    values(p_id_cancer, p_id_patient, p_prob_score);
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_score_search_by_id` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_score_search_by_id`(
	in p_id_patient int
)
begin
	select t.description, s.prob_score
    from scores s
    inner join type_cancer t
    on s.fk_id_cancer = t.id_cancer
    where s.fk_id_patient = p_id_patient;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Final view structure for view `vw_cancer`
--

/*!50001 DROP VIEW IF EXISTS `vw_cancer`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_cancer` AS select `t`.`id_cancer` AS `id_cancer`,`t`.`description` AS `description` from `type_cancer` `t` order by `t`.`id_cancer` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_patient`
--

/*!50001 DROP VIEW IF EXISTS `vw_patient`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_patient` AS select `p`.`id_patient` AS `id_patient`,`p`.`full_name` AS `full_name`,`ti`.`description` AS `type_image`,`p`.`anatomy` AS `anatomy`,`p`.`age` AS `age`,`p`.`sex` AS `sex`,`p`.`class_pred` AS `class_pred`,`p`.`prob_pred` AS `prob_pred` from (`patient` `p` join `type_image` `ti` on((`p`.`fk_id_type_image` = `ti`.`id_type_image`))) order by `p`.`id_patient` */;
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

-- Dump completed on 2024-02-06 21:14:37
