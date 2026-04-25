-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1:3306
-- Généré le : sam. 25 avr. 2026 à 17:50
-- Version du serveur : 9.1.0
-- Version de PHP : 7.4.33

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `littlelemondb`
--

DELIMITER $$
--
-- Procédures
--
DROP PROCEDURE IF EXISTS `AddBooking`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `AddBooking` (IN `id` INT, IN `customer_id` INT, IN `tabNO` INT, IN `dat` DATETIME)   BEGIN
	START TRANSACTION;
    SET @r = NULL;
	SELECT BookingID INTO @r FROM bookings WHERE BookingID = id;
    IF ISNULL(@r) THEN
    	INSERT INTO bookings (BookingID, CustomerID, TableNo, BookingDate)
        VALUES (id, customer_id, tabNo, dat);
        COMMIT;
        SELECT "New booking added" AS "Confirmation";
	ELSE
    	SELECT CONCAT("Booking  ", id, " already exist - booking cancelled") AS "Booking Status";
    END IF;
END$$

DROP PROCEDURE IF EXISTS `AddValidBooking`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `AddValidBooking` (IN `tabNo` INT, IN `dat` DATETIME)   BEGIN
	START TRANSACTION;
    SET @r = NULL;
	SELECT BookingID INTO @r FROM bookings WHERE DATE(BookingDate) = DATE(dat) AND TableNo = tabNo LIMIT 1;
    IF ISNULL(@r) THEN
    	INSERT INTO bookings (TableNo, BookingDate)
        VALUES (tabNo, dat);
        COMMIT;
        SELECT CONCAT("Booked saved on table No ", tabNo) AS "Booking Status";
	ELSE
    	SELECT CONCAT("Table ", tabNo, " is already booked - booking cancelled") AS "Booking Status";
    END IF;
END$$

DROP PROCEDURE IF EXISTS `CancelBooking`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `CancelBooking` (IN `id` INT)   BEGIN
	START TRANSACTION;
    SET @r = NULL;
	SELECT BookingID INTO @r FROM bookings WHERE BookingID = id;
    IF ISNULL(@r) THEN
    	SELECT CONCAT("Booking  ", id, " does not exist") AS "Result";
	ELSE
    	DELETE FROM bookings
        WHERE BookingID = id;
        COMMIT;
        SELECT CONCAT("Booking ", id, " calcelled") AS "Confirmation";
    END IF;
END$$

DROP PROCEDURE IF EXISTS `CancelOrder`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `CancelOrder` (IN `id` INT)   BEGIN
DELETE FROM orders WHERE OrderID = id;
SELECT CONCAT("Order ", id, " is cancelled") AS Confirmation;
END$$

DROP PROCEDURE IF EXISTS `CheckBooking`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `CheckBooking` (IN `dat` DATETIME, IN `tabNo` INT)   BEGIN
	SET @r = NULL;
	SELECT BookingID INTO @r FROM bookings WHERE DATE(BookingDate) = DATE(dat) AND TableNo = tabNo LIMIT 1;
	SELECT 
    IF(ISNULL(@r), CONCAT("Table ", tabNo, " is free"), CONCAT("Table ", tabNo, " is already booked")) AS "Booking Status";
END$$

DROP PROCEDURE IF EXISTS `GetMaxQuantity`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetMaxQuantity` ()   SELECT MAX(Quantity) AS "MAX Quantity in Order" FROM orders$$

DROP PROCEDURE IF EXISTS `ManageBooking`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ManageBooking` (IN `tabNo` INT, IN `dat` DATETIME)   BEGIN
	START TRANSACTION;
    SET @r = NULL;
	SELECT BookingID INTO @r FROM bookings WHERE DATE(BookingDate) = DATE(dat) AND TableNo = tabNo LIMIT 1;
    IF ISNULL(@r) THEN
    	INSERT INTO bookings (TableNo, BookingDate)
        VALUES (tabNo, dat);
        COMMIT;
        SELECT CONCAT("Booked saved on table No ", tabNo) AS "Booking Status";
	ELSE
    	SELECT CONCAT("Table ", tabNo, " is already booked - booking cancelled") AS "Booking Status";
    END IF;
END$$

DROP PROCEDURE IF EXISTS `UpdateBooking`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateBooking` (IN `id` INT, IN `dat` DATETIME)   BEGIN
	START TRANSACTION;
    SET @r = NULL;
	SELECT BookingID INTO @r FROM bookings WHERE BookingID = id;
    IF ISNULL(@r) THEN
    	SELECT CONCAT("Booking  ", id, " does not exist") AS "Result";
	ELSE
    	UPDATE bookings
        SET BookingDate = dat
        WHERE BookingID = id;
        COMMIT;
        SELECT "Booking updated" AS "Confirmation";
    END IF;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `address`
--

DROP TABLE IF EXISTS `address`;
CREATE TABLE IF NOT EXISTS `address` (
  `AddresID` int NOT NULL AUTO_INCREMENT,
  `City` varchar(45) NOT NULL,
  `State` varchar(45) NOT NULL,
  `Country` varchar(45) NOT NULL,
  `PostalCode` varchar(45) NOT NULL,
  PRIMARY KEY (`AddresID`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb3;

--
-- Déchargement des données de la table `address`
--

INSERT INTO `address` (`AddresID`, `City`, `State`, `Country`, `PostalCode`) VALUES
(1, 'Douala', 'Littoral', 'Cameroon', 'BP1001'),
(2, 'Yaoundé', 'Centre', 'Cameroon', 'BP2002'),
(3, 'Bafoussam', 'Ouest', 'Cameroon', 'BP3003'),
(4, 'Paris', 'Île-de-France', 'France', '75001'),
(5, 'Berlin', 'Berlin', 'Germany', '10115'),
(6, 'New York', 'NY', 'USA', '10001'),
(7, 'Toronto', 'Ontario', 'Canada', 'M5H1P9'),
(8, 'Maroua', 'Extrême-Nord', 'Cameroon', 'BP4004'),
(9, 'Marseille', 'Provence-Alpes-Côte d\'Azur', 'France', '13001'),
(10, 'Chicago', 'IL', 'USA', '60601');

-- --------------------------------------------------------

--
-- Structure de la table `bookings`
--

DROP TABLE IF EXISTS `bookings`;
CREATE TABLE IF NOT EXISTS `bookings` (
  `BookingID` int NOT NULL AUTO_INCREMENT,
  `TableNo` int NOT NULL,
  `BookingDate` datetime NOT NULL,
  `EmployeeID` int DEFAULT NULL,
  `CustomerID` int DEFAULT NULL,
  PRIMARY KEY (`BookingID`),
  KEY `fk_Bookings_Employees1_idx` (`EmployeeID`),
  KEY `fk_Bookings_Customers1_idx` (`CustomerID`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb3;

--
-- Déchargement des données de la table `bookings`
--

INSERT INTO `bookings` (`BookingID`, `TableNo`, `BookingDate`, `EmployeeID`, `CustomerID`) VALUES
(1, 5, '2025-03-15 19:00:00', 1, 1),
(2, 2, '2025-03-16 20:30:00', 2, 2),
(3, 8, '2025-03-17 18:45:00', 3, 3),
(4, 4, '2025-03-18 19:15:00', 4, 4),
(5, 6, '2025-03-19 20:00:00', 5, 5),
(6, 2025, '0000-00-00 00:00:00', NULL, NULL);

-- --------------------------------------------------------

--
-- Doublure de structure pour la vue `costomersordersview`
-- (Voir ci-dessous la vue réelle)
--
DROP VIEW IF EXISTS `costomersordersview`;
CREATE TABLE IF NOT EXISTS `costomersordersview` (
`CustomerID` int
,`FullName` varchar(511)
,`OrderID` int
,`TotalCost` decimal(10,0)
,`MenuName` varchar(255)
,`CourseName` varchar(255)
);

-- --------------------------------------------------------

--
-- Structure de la table `customers`
--

DROP TABLE IF EXISTS `customers`;
CREATE TABLE IF NOT EXISTS `customers` (
  `CustomerID` int NOT NULL AUTO_INCREMENT,
  `FirstName` varchar(255) NOT NULL,
  `LastName` varchar(255) NOT NULL,
  `ContactNumber` varchar(255) DEFAULT NULL,
  `Email` varchar(255) DEFAULT NULL,
  `AddresID` int NOT NULL,
  PRIMARY KEY (`CustomerID`),
  KEY `fk_Customers_Address1_idx` (`AddresID`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb3;

--
-- Déchargement des données de la table `customers`
--

INSERT INTO `customers` (`CustomerID`, `FirstName`, `LastName`, `ContactNumber`, `Email`, `AddresID`) VALUES
(1, 'Marc', 'Tchoua', '+237655443322', 'marc.tchoua@example.com', 1),
(2, 'Laura', 'Nkem', '+237699887766', 'laura.nkem@example.com', 2),
(3, 'Pierre', 'Durand', '+33123456789', 'pierre.durand@example.com', 4),
(4, 'Sarah', 'Ngono', '+237677112233', 'sarah.ngono@example.com', 3),
(5, 'David', 'Smith', '+12125551234', 'david.smith@example.com', 6),
(6, 'Emily', 'Johnson', '+14165559876', 'emily.johnson@example.com', 7),
(7, 'Hans', 'Müller', '+4930123456', 'hans.mueller@example.com', 5),
(8, 'Anna', 'Schmidt', '+4989123456', 'anna.schmidt@example.com', 9),
(9, 'Paul', 'Ewane', '+237655667788', 'paul.ewane@example.com', 8),
(10, 'Marie', 'Talla', '+237699778899', 'marie.talla@example.com', 10);

-- --------------------------------------------------------

--
-- Structure de la table `employees`
--

DROP TABLE IF EXISTS `employees`;
CREATE TABLE IF NOT EXISTS `employees` (
  `EmployeeID` int NOT NULL AUTO_INCREMENT,
  `FirstName` varchar(255) NOT NULL,
  `LastName` varchar(255) NOT NULL,
  `Role` varchar(45) NOT NULL,
  `ContactNumber` varchar(45) DEFAULT NULL,
  `Email` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`EmployeeID`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb3;

--
-- Déchargement des données de la table `employees`
--

INSERT INTO `employees` (`EmployeeID`, `FirstName`, `LastName`, `Role`, `ContactNumber`, `Email`) VALUES
(1, 'Alice', 'Dupont', 'Serveuse', '+237612345678', 'alice.dupont@littlelemon.com'),
(2, 'Jean', 'Mbappe', 'Manager', '+237698765432', 'jean.mbappe@littlelemon.com'),
(3, 'Sophie', 'Ngono', 'Chef', '+237677889900', 'sophie.ngono@littlelemon.com'),
(4, 'Paul', 'Ewane', 'Serveur', '+237655112233', 'paul.ewane@littlelemon.com'),
(5, 'Marie', 'Talla', 'Caissière', '+237699223344', 'marie.talla@littlelemon.com'),
(6, 'David', 'Njoya', 'Chef', '+237677334455', 'david.njoya@littlelemon.com'),
(7, 'Laura', 'Nkem', 'Serveuse', '+237688445566', 'laura.nkem@littlelemon.com'),
(8, 'Pierre', 'Durand', 'Manager', '+33123456789', 'pierre.durand@littlelemon.com'),
(9, 'Clara', 'Manga', 'Serveuse', '+237699556677', 'clara.manga@littlelemon.com'),
(10, 'Joseph', 'Essomba', 'Chef', '+237677889911', 'joseph.essomba@littlelemon.com');

-- --------------------------------------------------------

--
-- Structure de la table `menuitems`
--

DROP TABLE IF EXISTS `menuitems`;
CREATE TABLE IF NOT EXISTS `menuitems` (
  `MenuItemID` int NOT NULL AUTO_INCREMENT,
  `CourseName` varchar(255) NOT NULL,
  `StarterName` varchar(255) NOT NULL,
  `DessertName` varchar(255) NOT NULL,
  PRIMARY KEY (`MenuItemID`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3;

--
-- Déchargement des données de la table `menuitems`
--

INSERT INTO `menuitems` (`MenuItemID`, `CourseName`, `StarterName`, `DessertName`) VALUES
(1, 'Poulet DG', 'Salade verte', 'Tiramisu'),
(2, 'Poisson braisé', 'Accras de morue', 'Crème brûlée'),
(3, 'Pizza Margherita', 'Bruschetta', 'Panna cotta'),
(4, 'Ndolé', 'Beignets de banane', 'Gateau au chocolat'),
(5, 'Burger', 'Frites', 'Cheesecake');

-- --------------------------------------------------------

--
-- Structure de la table `menus`
--

DROP TABLE IF EXISTS `menus`;
CREATE TABLE IF NOT EXISTS `menus` (
  `MenuID` int NOT NULL,
  `Cuisine` varchar(45) NOT NULL,
  `Name` varchar(255) NOT NULL,
  `MenuItemID` int NOT NULL,
  PRIMARY KEY (`MenuID`),
  KEY `fk_Menus_MenuItems1_idx` (`MenuItemID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Déchargement des données de la table `menus`
--

INSERT INTO `menus` (`MenuID`, `Cuisine`, `Name`, `MenuItemID`) VALUES
(1, 'Cameroonian', 'Menu Traditionnel', 1),
(2, 'French', 'Menu Gourmet', 2),
(3, 'Italian', 'Menu Classico', 3),
(4, 'Cameroonian', 'Menu Ndolé', 4),
(5, 'American', 'Menu FastFood', 5);

-- --------------------------------------------------------

--
-- Structure de la table `orders`
--

DROP TABLE IF EXISTS `orders`;
CREATE TABLE IF NOT EXISTS `orders` (
  `OrderID` int NOT NULL AUTO_INCREMENT,
  `OrderDate` datetime NOT NULL,
  `Quantity` int NOT NULL,
  `TotalCost` decimal(10,0) NOT NULL,
  `BookingID` int DEFAULT NULL,
  `ShippingID` int DEFAULT NULL,
  `CustomerID` int NOT NULL,
  `MenuID` int NOT NULL,
  PRIMARY KEY (`OrderID`),
  KEY `fk_Orders_Bookings_idx` (`BookingID`),
  KEY `fk_Orders_Shippings1_idx` (`ShippingID`),
  KEY `fk_Orders_Customers1_idx` (`CustomerID`),
  KEY `fk_Orders_Menus1_idx` (`MenuID`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3;

--
-- Déchargement des données de la table `orders`
--

INSERT INTO `orders` (`OrderID`, `OrderDate`, `Quantity`, `TotalCost`, `BookingID`, `ShippingID`, `CustomerID`, `MenuID`) VALUES
(1, '2025-03-15 19:30:00', 2, 15000, 1, 1, 1, 1),
(2, '2025-03-16 21:00:00', 3, 25000, 2, 2, 2, 2),
(3, '2025-03-17 19:00:00', 1, 12000, 3, 3, 3, 3),
(4, '2025-03-18 20:00:00', 4, 30000, 4, 4, 4, 4),
(5, '2025-03-19 20:30:00', 2, 18000, 5, 5, 5, 5);

-- --------------------------------------------------------

--
-- Doublure de structure pour la vue `ordersview`
-- (Voir ci-dessous la vue réelle)
--
DROP VIEW IF EXISTS `ordersview`;
CREATE TABLE IF NOT EXISTS `ordersview` (
`OrderID` int
,`Quantity` int
,`TotalCost` decimal(10,0)
);

-- --------------------------------------------------------

--
-- Structure de la table `shippings`
--

DROP TABLE IF EXISTS `shippings`;
CREATE TABLE IF NOT EXISTS `shippings` (
  `ShippingID` int NOT NULL AUTO_INCREMENT,
  `Status` varchar(45) NOT NULL,
  `DeliveryDate` datetime NOT NULL,
  `AddresID` int NOT NULL,
  PRIMARY KEY (`ShippingID`),
  KEY `fk_Shippings_Address1_idx` (`AddresID`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3;

--
-- Déchargement des données de la table `shippings`
--

INSERT INTO `shippings` (`ShippingID`, `Status`, `DeliveryDate`, `AddresID`) VALUES
(1, 'En cours', '2025-03-18 14:00:00', 1),
(2, 'Livré', '2025-03-19 16:30:00', 2),
(3, 'Préparé', '2025-03-20 11:15:00', 4),
(4, 'En cours', '2025-03-21 15:45:00', 5),
(5, 'Livré', '2025-03-22 17:00:00', 6);

-- --------------------------------------------------------

--
-- Structure de la vue `costomersordersview`
--
DROP TABLE IF EXISTS `costomersordersview`;

DROP VIEW IF EXISTS `costomersordersview`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `costomersordersview`  AS SELECT `c`.`CustomerID` AS `CustomerID`, concat(`c`.`FirstName`,' ',`c`.`LastName`) AS `FullName`, `o`.`OrderID` AS `OrderID`, `o`.`TotalCost` AS `TotalCost`, `m`.`Name` AS `MenuName`, `mi`.`CourseName` AS `CourseName` FROM (((`orders` `o` join `customers` `c` on((`c`.`CustomerID` = `o`.`CustomerID`))) join `menus` `m` on((`m`.`MenuID` = `o`.`MenuID`))) join `menuitems` `mi` on((`mi`.`MenuItemID` = `m`.`MenuItemID`))) WHERE (`o`.`TotalCost` > 150) ;

-- --------------------------------------------------------

--
-- Structure de la vue `ordersview`
--
DROP TABLE IF EXISTS `ordersview`;

DROP VIEW IF EXISTS `ordersview`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `ordersview`  AS SELECT `orders`.`OrderID` AS `OrderID`, `orders`.`Quantity` AS `Quantity`, `orders`.`TotalCost` AS `TotalCost` FROM `orders` WHERE (`orders`.`Quantity` > 2) ;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `bookings`
--
ALTER TABLE `bookings`
  ADD CONSTRAINT `fk_Bookings_Customers1` FOREIGN KEY (`CustomerID`) REFERENCES `customers` (`CustomerID`),
  ADD CONSTRAINT `fk_Bookings_Employees1` FOREIGN KEY (`EmployeeID`) REFERENCES `employees` (`EmployeeID`);

--
-- Contraintes pour la table `customers`
--
ALTER TABLE `customers`
  ADD CONSTRAINT `fk_Customers_Address1` FOREIGN KEY (`AddresID`) REFERENCES `address` (`AddresID`);

--
-- Contraintes pour la table `menus`
--
ALTER TABLE `menus`
  ADD CONSTRAINT `fk_Menus_MenuItems1` FOREIGN KEY (`MenuItemID`) REFERENCES `menuitems` (`MenuItemID`);

--
-- Contraintes pour la table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `fk_Orders_Bookings` FOREIGN KEY (`BookingID`) REFERENCES `bookings` (`BookingID`),
  ADD CONSTRAINT `fk_Orders_Customers1` FOREIGN KEY (`CustomerID`) REFERENCES `customers` (`CustomerID`),
  ADD CONSTRAINT `fk_Orders_Menus1` FOREIGN KEY (`MenuID`) REFERENCES `menus` (`MenuID`),
  ADD CONSTRAINT `fk_Orders_Shippings1` FOREIGN KEY (`ShippingID`) REFERENCES `shippings` (`ShippingID`);

--
-- Contraintes pour la table `shippings`
--
ALTER TABLE `shippings`
  ADD CONSTRAINT `fk_Shippings_Address1` FOREIGN KEY (`AddresID`) REFERENCES `address` (`AddresID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
