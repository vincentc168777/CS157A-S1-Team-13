-- MySQL dump 10.13  Distrib 8.0.45, for Win64 (x86_64)
--
-- Host: localhost    Database: carclub
-- ------------------------------------------------------
-- Server version	8.0.45

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
-- Table structure for table `carphotos`
--

DROP TABLE IF EXISTS `carphotos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `carphotos` (
  `Photo_ID` int NOT NULL AUTO_INCREMENT,
  `Car_ID` int NOT NULL,
  `Photo_URL` varchar(255) NOT NULL,
  PRIMARY KEY (`Photo_ID`),
  KEY `Car_ID` (`Car_ID`),
  CONSTRAINT `carphotos_ibfk_1` FOREIGN KEY (`Car_ID`) REFERENCES `cars` (`Car_ID`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `carphotos`
--

LOCK TABLES `carphotos` WRITE;
/*!40000 ALTER TABLE `carphotos` DISABLE KEYS */;
INSERT INTO `carphotos` VALUES (1,1,'https://carclub.com/photos/cars/civic_type_r_1.jpg'),(2,2,'https://carclub.com/photos/cars/370z_2.jpg'),(3,3,'https://carclub.com/photos/cars/mustang_gt_3.jpg'),(4,4,'https://carclub.com/photos/cars/s14_4.jpg'),(5,5,'https://carclub.com/photos/cars/impala_5.jpg'),(6,6,'https://carclub.com/photos/cars/bmw_m3_6.jpg'),(7,7,'https://carclub.com/photos/cars/tacoma_7.jpg'),(8,8,'https://carclub.com/photos/cars/camaro_8.jpg'),(9,9,'https://carclub.com/photos/cars/golf_gti_9.jpg'),(10,10,'https://carclub.com/photos/cars/hellcat_10.jpg');
/*!40000 ALTER TABLE `carphotos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cars`
--

DROP TABLE IF EXISTS `cars`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cars` (
  `Car_ID` int NOT NULL AUTO_INCREMENT,
  `User_ID` int NOT NULL,
  `Make` varchar(50) NOT NULL,
  `Model` varchar(50) NOT NULL,
  `Year` int NOT NULL,
  `Description` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`Car_ID`),
  KEY `User_ID` (`User_ID`),
  CONSTRAINT `cars_ibfk_1` FOREIGN KEY (`User_ID`) REFERENCES `user` (`User_ID`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cars`
--

LOCK TABLES `cars` WRITE;
/*!40000 ALTER TABLE `cars` DISABLE KEYS */;
INSERT INTO `cars` VALUES (1,1,'Honda','Civic Type R',2021,'Full bolt-ons, Mugen wing, Championship White'),(2,2,'Nissan','370Z',2019,'Coilovers, wide body kit, custom wrap'),(3,3,'Ford','Mustang GT',2018,'Supercharged 5.0, Roush exhaust, Kona Blue'),(4,4,'Nissan','S14 240SX',1997,'SR20DET swap, full cage, drift setup'),(5,5,'Chevrolet','Impala',1964,'Hydraulics, custom interior, candy paint'),(6,6,'BMW','M3',2020,'Stage 2 tune, carbon fiber hood, track ready'),(7,7,'Toyota','Tacoma TRD Pro',2022,'Lifted 3 inches, ARB bumper, 35s'),(8,8,'Chevrolet','Camaro',1969,'Frame-off restoration, LS swap, Hugger Orange'),(9,9,'Volkswagen','Golf GTI',2018,'Static drop, Rotiform wheels, APR stage 1'),(10,10,'Dodge','Challenger SRT Hellcat',2020,'Drag radials, line lock, 1/4 mile build'),(11,12,'Toyota','A86',1998,'looks cool'),(12,12,'Space X','Nasa Roacket',2026,'Artemis 2'),(13,12,'Walmart','Shopping cart',2016,'one wheel is broken'),(14,14,'Yamaha','motocycle',2019,'red'),(15,12,'Toyota','A86',2000,'sdaaadsdasads');
/*!40000 ALTER TABLE `cars` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `club_membership`
--

DROP TABLE IF EXISTS `club_membership`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `club_membership` (
  `User_ID` int NOT NULL,
  `Club_ID` int NOT NULL,
  PRIMARY KEY (`User_ID`,`Club_ID`),
  KEY `Club_ID` (`Club_ID`),
  CONSTRAINT `club_membership_ibfk_1` FOREIGN KEY (`User_ID`) REFERENCES `user` (`User_ID`) ON DELETE CASCADE,
  CONSTRAINT `club_membership_ibfk_2` FOREIGN KEY (`Club_ID`) REFERENCES `clubs` (`Club_ID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `club_membership`
--

LOCK TABLES `club_membership` WRITE;
/*!40000 ALTER TABLE `club_membership` DISABLE KEYS */;
INSERT INTO `club_membership` VALUES (2,1),(3,1),(4,2),(5,2),(6,3),(7,4),(8,5),(9,6),(10,7),(1,8);
/*!40000 ALTER TABLE `club_membership` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `clubs`
--

DROP TABLE IF EXISTS `clubs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clubs` (
  `Club_ID` int NOT NULL AUTO_INCREMENT,
  `Manager_ID` int NOT NULL,
  `Club_Name` varchar(100) NOT NULL,
  `Description` varchar(500) NOT NULL,
  `Location` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`Club_ID`),
  UNIQUE KEY `Club_Name` (`Club_Name`),
  KEY `Manager_ID` (`Manager_ID`),
  CONSTRAINT `clubs_ibfk_1` FOREIGN KEY (`Manager_ID`) REFERENCES `user` (`User_ID`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clubs`
--

LOCK TABLES `clubs` WRITE;
/*!40000 ALTER TABLE `clubs` DISABLE KEYS */;
INSERT INTO `clubs` VALUES (1,1,'Bay Area JDM Club','A community for JDM enthusiasts in the Bay Area','San Jose, CA'),(2,2,'SoCal Drift Alliance','Drift events and practice sessions across Southern California','Los Angeles, CA'),(3,3,'Texas Muscle Crew','American muscle car meets and drag events in Texas','Houston, TX'),(4,4,'Pacific Northwest Drift','Drifting community for the PNW region','Seattle, WA'),(5,5,'Lowrider Legacy','Celebrating lowrider culture and craftsmanship','San Diego, CA'),(6,6,'Euro Collective','European car enthusiasts for track days and shows','San Francisco, CA'),(7,7,'Desert Off-Road Crew','Off-road trails and overlanding in the Southwest','Phoenix, AZ'),(8,8,'Classic Iron Club','Dedicated to restoring and showing classic American cars','Chicago, IL'),(9,9,'Stance Society','All things stance, fitment, and static builds','Portland, OR'),(10,10,'Quarter Mile Kings','Drag racing community for all makes and models','Las Vegas, NV');
/*!40000 ALTER TABLE `clubs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `company`
--

DROP TABLE IF EXISTS `company`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `company` (
  `Company_ID` int NOT NULL AUTO_INCREMENT,
  `Company_Name` varchar(100) NOT NULL,
  PRIMARY KEY (`Company_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `company`
--

LOCK TABLES `company` WRITE;
/*!40000 ALTER TABLE `company` DISABLE KEYS */;
INSERT INTO `company` VALUES (1,'NOS Energy Drink'),(2,'Toyo Tires'),(3,'K&N Filters'),(4,'HKS Performance'),(5,'Sparco'),(6,'Enkei Wheels'),(7,'Mishimoto'),(8,'Greddy Performance'),(9,'Bride Seats'),(10,'APR Performance');
/*!40000 ALTER TABLE `company` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `event_registration`
--

DROP TABLE IF EXISTS `event_registration`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `event_registration` (
  `User_ID` int NOT NULL,
  `Event_ID` int NOT NULL,
  PRIMARY KEY (`User_ID`,`Event_ID`),
  KEY `Event_ID` (`Event_ID`),
  CONSTRAINT `event_registration_ibfk_1` FOREIGN KEY (`User_ID`) REFERENCES `user` (`User_ID`) ON DELETE CASCADE,
  CONSTRAINT `event_registration_ibfk_2` FOREIGN KEY (`Event_ID`) REFERENCES `events` (`Event_ID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `event_registration`
--

LOCK TABLES `event_registration` WRITE;
/*!40000 ALTER TABLE `event_registration` DISABLE KEYS */;
INSERT INTO `event_registration` VALUES (1,1),(2,2),(3,3),(4,4),(5,5),(6,6),(7,7),(8,8),(9,9),(10,10);
/*!40000 ALTER TABLE `event_registration` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `eventphotos`
--

DROP TABLE IF EXISTS `eventphotos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eventphotos` (
  `Photo_ID` int NOT NULL AUTO_INCREMENT,
  `Event_ID` int NOT NULL,
  `Photo_URL` varchar(255) NOT NULL,
  PRIMARY KEY (`Photo_ID`),
  KEY `Event_ID` (`Event_ID`),
  CONSTRAINT `eventphotos_ibfk_1` FOREIGN KEY (`Event_ID`) REFERENCES `events` (`Event_ID`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `eventphotos`
--

LOCK TABLES `eventphotos` WRITE;
/*!40000 ALTER TABLE `eventphotos` DISABLE KEYS */;
INSERT INTO `eventphotos` VALUES (1,1,'https://carclub.com/photos/events/jdm_meetup_1.jpg'),(2,2,'https://carclub.com/photos/events/drift_day_2.jpg'),(3,3,'https://carclub.com/photos/events/muscle_showdown_3.jpg'),(4,4,'https://carclub.com/photos/events/pnw_drift_4.jpg'),(5,5,'https://carclub.com/photos/events/lowrider_show_5.jpg'),(6,6,'https://carclub.com/photos/events/euro_track_6.jpg'),(7,7,'https://carclub.com/photos/events/desert_trail_7.jpg'),(8,8,'https://carclub.com/photos/events/cruise_night_8.jpg'),(9,9,'https://carclub.com/photos/events/stance_fest_9.jpg'),(10,10,'https://carclub.com/photos/events/sin_city_drags_10.jpg');
/*!40000 ALTER TABLE `eventphotos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `events`
--

DROP TABLE IF EXISTS `events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `events` (
  `Event_ID` int NOT NULL AUTO_INCREMENT,
  `Club_ID` int NOT NULL,
  `Event_Name` varchar(100) NOT NULL,
  `Event_Date` date NOT NULL,
  `Event_Type` varchar(50) NOT NULL,
  `Location` varchar(100) NOT NULL,
  `Description` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`Event_ID`),
  KEY `Club_ID` (`Club_ID`),
  CONSTRAINT `events_ibfk_1` FOREIGN KEY (`Club_ID`) REFERENCES `clubs` (`Club_ID`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `events`
--

LOCK TABLES `events` WRITE;
/*!40000 ALTER TABLE `events` DISABLE KEYS */;
INSERT INTO `events` VALUES (1,1,'Bay Area JDM Meetup','2025-04-12','Meetup','San Jose, CA','Monthly JDM meet at the Eastridge parking lot'),(2,2,'SoCal Drift Day','2025-04-20','Race','Irwindale Speedway, CA','Open drift practice session for all skill levels'),(3,3,'Texas Muscle Showdown','2025-05-03','Car Show','Houston Fairgrounds, TX','Annual muscle car show and drag competition'),(4,4,'PNW Drift Invitational','2025-05-17','Race','Portland Int. Raceway, OR','Invitational drift competition for licensed drivers'),(5,5,'Lowrider Legacy Show','2025-06-01','Car Show','Balboa Park, San Diego, CA','Annual lowrider show celebrating car culture'),(6,6,'Euro Track Day','2025-06-14','Race','Thunderhill Raceway, CA','Track day for European cars only'),(7,7,'Desert Trail Run','2025-06-28','Meetup','Sedona, AZ','Group off-road trail run through the red rocks'),(8,8,'Classic Car Cruise Night','2025-07-04','Car Show','Millennium Park, Chicago, IL','Fourth of July classic car cruise and show'),(9,9,'Stance Fest 2025','2025-07-19','Car Show','Portland Convention Center, OR','The biggest stance and fitment show in the PNW'),(10,10,'Sin City Drags','2025-08-02','Race','Las Vegas Motor Speedway, NV','Open drag racing event for all classes');
/*!40000 ALTER TABLE `events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sponsors`
--

DROP TABLE IF EXISTS `sponsors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sponsors` (
  `Company_ID` int NOT NULL,
  `Event_ID` int NOT NULL,
  PRIMARY KEY (`Company_ID`,`Event_ID`),
  KEY `Event_ID` (`Event_ID`),
  CONSTRAINT `sponsors_ibfk_1` FOREIGN KEY (`Company_ID`) REFERENCES `company` (`Company_ID`) ON DELETE CASCADE,
  CONSTRAINT `sponsors_ibfk_2` FOREIGN KEY (`Event_ID`) REFERENCES `events` (`Event_ID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sponsors`
--

LOCK TABLES `sponsors` WRITE;
/*!40000 ALTER TABLE `sponsors` DISABLE KEYS */;
INSERT INTO `sponsors` VALUES (1,1),(2,2),(3,3),(4,4),(5,5),(6,6),(7,7),(8,8),(9,9),(10,10);
/*!40000 ALTER TABLE `sponsors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `User_ID` int NOT NULL AUTO_INCREMENT,
  `Username` varchar(50) NOT NULL,
  `Email` varchar(100) NOT NULL,
  `Password` varchar(255) NOT NULL,
  `Display_Name` varchar(100) DEFAULT NULL,
  `Bio` varchar(500) DEFAULT NULL,
  `Location` varchar(100) DEFAULT NULL,
  `Date_Created` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`User_ID`),
  UNIQUE KEY `Username` (`Username`),
  UNIQUE KEY `Email` (`Email`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'jdm_king99','carlos.m@gmail.com','hashed_pw1','Carlos M','Huge JDM fan, love my Civic','San Jose, CA','2024-01-15 10:00:00'),(2,'turbo_tina','tina.nguyen@gmail.com','hashed_pw2','Tina Nguyen','Weekend racer and car show enthusiast','Los Angeles, CA','2024-02-03 11:30:00'),(3,'musclecar_mike','mike.torres@yahoo.com','hashed_pw3','Mike Torres','American muscle all day. Mustang owner since 2018','Houston, TX','2024-02-20 09:15:00'),(4,'driftqueen_amy','amy.park@gmail.com','hashed_pw4','Amy Park','Drifting is life. S14 forever','Seattle, WA','2024-03-05 14:00:00'),(5,'lowrider_luis','luis.garcia@outlook.com','hashed_pw5','Luis Garcia','Lowrider culture runs in the family','San Diego, CA','2024-03-18 08:45:00'),(6,'euro_evan','evan.smith@gmail.com','hashed_pw6','Evan Smith','BMW and Audi guy. Track days every month','San Francisco, CA','2024-04-01 12:00:00'),(7,'offroad_omar','omar.hassan@gmail.com','hashed_pw7','Omar Hassan','Lifted trucks and trail runs on weekends','Phoenix, AZ','2024-04-22 10:30:00'),(8,'classic_carl','carl.johnson@hotmail.com','hashed_pw8','Carl Johnson','Restoring a 1969 Camaro in my garage','Chicago, IL','2024-05-10 16:00:00'),(9,'stance_sara','sara.lee@gmail.com','hashed_pw9','Sara Lee','Stance nation. Static drop on my Golf','Portland, OR','2024-06-01 09:00:00'),(10,'nitro_nick','nick.patel@gmail.com','hashed_pw10','Nick Patel','Quarter mile addict. Always chasing PBs','Las Vegas, NV','2024-06-15 13:00:00'),(11,'sdfg','dsfg','2c242ebed0c8abc604f6d2f62bc73683791ceaa53a406f367cdf7b8de4d6b122','gsfsd','fgdgsds','sfsd','2026-03-17 18:45:13'),(12,'v','v','ef797c8118f02dfb649607dd5d3f8c7623048c9c063d532cc95c5ed7a898a64f','v','yooo wassuupp','anarctica','2026-04-14 14:42:47'),(13,'bob','vin','ef797c8118f02dfb649607dd5d3f8c7623048c9c063d532cc95c5ed7a898a64f','bob','','anarctica','2026-04-14 15:02:40'),(14,'spongebob','spongebob@gmail.com','ef797c8118f02dfb649607dd5d3f8c7623048c9c063d532cc95c5ed7a898a64f','spongebob','sfd','anarctica','2026-04-14 18:34:20');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-05-15 19:13:27
