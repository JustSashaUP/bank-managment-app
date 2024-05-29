-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 30, 2024 at 01:52 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `bank`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `getAccountDataByClientId` (IN `id` INT)   BEGIN 
	SELECT *
    FROM account
    WHERE client_id = id;
    END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getClient` (IN `id` INT)   BEGIN
	SELECT *
    FROM client
    WHERE client_id = id;
    END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getClientData` (IN `id` INT)   BEGIN
	SELECT * 
    FROM client
    WHERE client_id = id;
    END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getClientIdByEmail` (IN `client_email` VARCHAR(100))   BEGIN
	SELECT client_id
    FROM client
    WHERE email = client_email;
    END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getCreditDataByAccountId` (IN `id` INT)   BEGIN
	SELECT *
    FROM credit
    WHERE account_id = id;
    END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getDepositDataByAccountId` (IN `id` INT)   BEGIN
	SELECT *
    FROM deposit
    WHERE account_id = id;
    END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getTransactionDataByAccountId` (IN `id` INT)   BEGIN
	SELECT *
	FROM transaction
    WHERE sender_id = id OR resipient_id = id;
    END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `topUp` (IN `recipient_account_id` INT, IN `amount` DECIMAL(10,2))   BEGIN
    DECLARE recipient_balance DECIMAL(10,2);

    SELECT account_balance 
    INTO recipient_balance 
    FROM account 
    WHERE account_id = recipient_account_id;

    START TRANSACTION;

    INSERT INTO transaction(sender_id, resipient_id, transaction_size, transaction_status, transaction_type)
    VALUES (NULL, recipient_account_id, amount, 'successfully', 'account top-up');

    UPDATE account
    SET account_balance = CASE 
                            WHEN account_id = recipient_account_id THEN account_balance + amount
                          END
    WHERE account_id IN (recipient_account_id);

    COMMIT;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `transfer` (IN `amount` DECIMAL(10,2), IN `sending_account_id` INT, IN `recipient_card_number` VARCHAR(16))   this_proc:BEGIN
    DECLARE sending_balance DECIMAL(10,2);
    DECLARE recipient_account_id INT;

    SELECT account_balance 
    INTO sending_balance 
    FROM account 
    WHERE account_id = sending_account_id;

    SELECT account_id
    INTO recipient_account_id
    FROM account 
    WHERE account_number = recipient_card_number;

    START TRANSACTION;

    -- Check if sender has enough balance
    IF sending_balance < amount THEN
        INSERT INTO transaction(sender_id, resipient_id, transaction_size, transaction_status, transaction_type)
        VALUES (sending_account_id, recipient_account_id, amount, 'unsuccessfully', 'funds transfer');
        COMMIT;
        LEAVE this_proc;
    END IF;

    INSERT INTO transaction(sender_id, resipient_id, transaction_size, transaction_status, transaction_type)
    VALUES (sending_account_id, recipient_account_id, amount, 'successfully', 'funds transfer');

    UPDATE account
    SET account_balance = CASE 
                            WHEN account_id = sending_account_id THEN account_balance - amount
                            WHEN account_id = recipient_account_id THEN account_balance + amount
                          END
    WHERE account_id IN (sending_account_id, recipient_account_id);

    COMMIT;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `updateClientData` (IN `id` INT, IN `newEmail` VARCHAR(100), IN `newPassword` VARCHAR(100))   BEGIN
	UPDATE client
    SET email = newEmail, password = newPassword
    WHERE client_id = id;
    END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `account_counter` (`id` INT) RETURNS TINYINT(1) DETERMINISTIC BEGIN
	DECLARE counter INT;
    DECLARE is_access BOOLEAN;
    SET counter = 0;
    SET is_access = TRUE;
	SELECT COUNT(*) INTO counter
    FROM account
    WHERE client_id = id;
    
    IF counter >= 3 THEN
    	SET is_access = FALSE;
        END IF;
        
        RETURN is_access;
    END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `generateCardNumber` () RETURNS VARCHAR(16) CHARSET utf8mb4 COLLATE utf8mb4_general_ci  BEGIN
    DECLARE card_number VARCHAR(16);
    DECLARE exists_count INT;
    
    REPEAT
        SET card_number = '';
        
        SET card_number = CONCAT(card_number, FLOOR(RAND() * 10));
        SET card_number = CONCAT(card_number, FLOOR(RAND() * 10));
        SET card_number = CONCAT(card_number, FLOOR(RAND() * 10));
        SET card_number = CONCAT(card_number, FLOOR(RAND() * 10));
        SET card_number = CONCAT(card_number, FLOOR(RAND() * 10));
        SET card_number = CONCAT(card_number, FLOOR(RAND() * 10));
        SET card_number = CONCAT(card_number, FLOOR(RAND() * 10));
        SET card_number = CONCAT(card_number, FLOOR(RAND() * 10));
        SET card_number = CONCAT(card_number, FLOOR(RAND() * 10));
        SET card_number = CONCAT(card_number, FLOOR(RAND() * 10));
        SET card_number = CONCAT(card_number, FLOOR(RAND() * 10));
        SET card_number = CONCAT(card_number, FLOOR(RAND() * 10));
        SET card_number = CONCAT(card_number, FLOOR(RAND() * 10));
        SET card_number = CONCAT(card_number, FLOOR(RAND() * 10));
        SET card_number = CONCAT(card_number, FLOOR(RAND() * 10));
        SET card_number = CONCAT(card_number, FLOOR(RAND() * 10));
        
        SELECT COUNT(*) INTO exists_count FROM account WHERE account_number = card_number;
    UNTIL exists_count = 0 END REPEAT;
    RETURN card_number;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `is_credit_exist` (`id` INT) RETURNS TINYINT(1)  BEGIN
	DECLARE is_exist BOOLEAN;
	DECLARE counter INT;
	SET is_exist = FALSE;
	SELECT COUNT(*) INTO counter
	FROM credit
	WHERE account_id = id AND credit_status = 'open';
	IF counter > 0 THEN
	SET is_exist = TRUE;
	END IF;
	RETURN is_exist;
	END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `is_currency_exist` (`id` INT, `title` ENUM('UAH','USD','EUR')) RETURNS TINYINT(1)  BEGIN
    DECLARE number_ofexist INT;
    DECLARE is_exist BOOLEAN;
    
    SET is_exist = FALSE;
    
    SELECT COUNT(*) INTO number_ofexist FROM account
    WHERE client_id = id AND account_title = title;
    
    IF number_ofexist > 0 THEN
        SET is_exist = TRUE;
    END IF;
    
    RETURN is_exist;
    
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `is_deposit_exist` (`id` INT) RETURNS TINYINT(1)  BEGIN
	DECLARE is_exist BOOLEAN;
	DECLARE counter INT;
	SET is_exist = FALSE;
	SELECT COUNT(*) INTO counter
	FROM deposit
	WHERE account_id = id;
	IF counter > 0 THEN
	SET is_exist = TRUE;
	END IF;
	RETURN is_exist;
	END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `account`
--

CREATE TABLE `account` (
  `account_id` int(11) NOT NULL,
  `client_id` int(11) NOT NULL,
  `account_title` enum('UAH','USD','EUR','') NOT NULL,
  `account_number` varchar(16) NOT NULL,
  `account_balance` decimal(19,2) NOT NULL,
  `account_status` enum('online','offline') NOT NULL,
  `account_startdate` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `account`
--

INSERT INTO `account` (`account_id`, `client_id`, `account_title`, `account_number`, `account_balance`, `account_status`, `account_startdate`) VALUES
(1, 1, 'UAH', '2701299863153979', 12070.00, 'online', '2024-05-26 18:44:58'),
(2, 2, 'UAH', '4340148903807752', 135.75, 'online', '2024-05-26 18:44:58'),
(3, 3, 'UAH', '5259175453141201', 897234.50, 'online', '2024-05-26 18:44:58'),
(4, 4, 'UAH', '8663943396193097', 37.15, 'online', '2024-05-26 18:44:58'),
(5, 5, 'UAH', '7546977496172919', 12500.00, 'online', '2024-05-26 18:44:58');

--
-- Triggers `account`
--
DELIMITER $$
CREATE TRIGGER `check_account_currency` BEFORE INSERT ON `account` FOR EACH ROW BEGIN
    DECLARE is_accountExist BOOLEAN;
    SET is_accountExist = is_currency_exist(NEW.client_id, NEW.account_title);
    IF is_accountExist = TRUE THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Client already has an account with the same currency!';
    END IF;
    
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `check_numberof_account` BEFORE INSERT ON `account` FOR EACH ROW BEGIN
	DECLARE has_access BOOLEAN;
    SET has_access = account_counter(NEW.client_id);
    
	IF has_access = FALSE THEN
    	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'client already has three accounts!';
        END IF;
        END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Stand-in structure for view `account_credit_info`
-- (See below for the actual view)
--
CREATE TABLE `account_credit_info` (
`credit_id` int(11)
,`account_id` int(11)
,`credit_size` decimal(19,2)
,`credit_startdate` datetime
,`credit_enddate` datetime
,`credit_status` enum('open','closed','overdue','paid')
,`credit_percent` decimal(19,2)
,`credit_limit` decimal(19,2)
,`client_id` int(11)
,`account_title` enum('UAH','USD','EUR','')
,`account_number` varchar(16)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `account_deposit_info`
-- (See below for the actual view)
--
CREATE TABLE `account_deposit_info` (
`deposit_id` int(11)
,`account_id` int(11)
,`deposit_size` decimal(19,2)
,`deposit_startdate` date
,`deposit_enddate` date
,`deposit_percent` decimal(19,2)
,`client_id` int(11)
,`account_title` enum('UAH','USD','EUR','')
,`account_number` varchar(16)
);

-- --------------------------------------------------------

--
-- Table structure for table `client`
--

CREATE TABLE `client` (
  `client_id` int(11) NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `phone_number` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `birth_date` date NOT NULL,
  `password` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `client`
--

INSERT INTO `client` (`client_id`, `first_name`, `last_name`, `phone_number`, `email`, `birth_date`, `password`) VALUES
(1, 'John', 'Doe', '1234567890', 'john.doe@gmail.com', '1980-01-01', 'password123'),
(2, 'Jane', 'Smith', '2345678901', 'jane.smith@gmail.com', '1990-02-02', 'password456'),
(3, 'Mike', 'Johnson', '3456789012', 'mike.johnson@gmail.com', '1985-03-03', 'password789'),
(4, 'Emily', 'Davis', '4567890123', 'emily.davis@gmail.com', '1992-04-04', 'password101'),
(5, 'Chris', 'Brown', '5678901234', 'chris.brown@gmail.com', '1988-05-05', 'password202');

--
-- Triggers `client`
--
DELIMITER $$
CREATE TRIGGER `create_default_account_upon_register` AFTER INSERT ON `client` FOR EACH ROW BEGIN
    INSERT INTO account(client_id, account_title, account_number, account_balance, account_status, account_startdate)
    VALUES
    (NEW.client_id, 'UAH', generateCardNumber(), 0.00, 'online', NOW());
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Stand-in structure for view `client_accounts_info`
-- (See below for the actual view)
--
CREATE TABLE `client_accounts_info` (
`client_id` int(11)
,`first_name` varchar(50)
,`last_name` varchar(50)
,`phone_number` varchar(50)
,`email` varchar(100)
,`account_id` int(11)
,`account_title` enum('UAH','USD','EUR','')
,`account_balance` decimal(19,2)
,`account_number` varchar(16)
,`account_status` enum('online','offline')
);

-- --------------------------------------------------------

--
-- Table structure for table `credit`
--

CREATE TABLE `credit` (
  `credit_id` int(11) NOT NULL,
  `account_id` int(11) NOT NULL,
  `credit_size` decimal(19,2) NOT NULL,
  `credit_startdate` datetime NOT NULL,
  `credit_enddate` datetime NOT NULL,
  `credit_status` enum('open','closed','overdue','paid') NOT NULL,
  `credit_percent` decimal(19,2) NOT NULL,
  `credit_limit` decimal(19,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `credit`
--

INSERT INTO `credit` (`credit_id`, `account_id`, `credit_size`, `credit_startdate`, `credit_enddate`, `credit_status`, `credit_percent`, `credit_limit`) VALUES
(1, 1, 50000.00, '2024-05-26 19:52:52', '2025-05-01 00:00:00', 'paid', 2.50, 1000000.00),
(2, 2, 100000.00, '2024-05-26 19:52:52', '2025-05-02 00:00:00', 'paid', 2.50, 1000000.00),
(3, 3, 250000.00, '2024-05-26 19:52:52', '2025-05-03 00:00:00', 'open', 2.50, 1000000.00),
(4, 4, 750000.00, '2024-05-26 19:52:52', '2025-05-04 00:00:00', 'paid', 2.50, 1000000.00),
(5, 5, 500000.00, '2024-05-26 19:52:52', '2025-05-05 00:00:00', 'open', 2.50, 1000000.00);

--
-- Triggers `credit`
--
DELIMITER $$
CREATE TRIGGER `auto_insert_credit_startdate_status_percent_limit` BEFORE INSERT ON `credit` FOR EACH ROW BEGIN
	SET NEW.credit_startdate = NOW();
    SET NEW.credit_status = 'open';
    SET NEW.credit_percent = 2.50;
    SET NEW.credit_limit = 1000000.00;
    END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `check_credit_limit` AFTER INSERT ON `credit` FOR EACH ROW BEGIN
	IF NEW.credit_size > NEW.credit_limit THEN
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Credit size can't be more than credit limit!";
	END IF;
	END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `check_credit_size` BEFORE INSERT ON `credit` FOR EACH ROW BEGIN
	IF NEW.credit_size <= 0 THEN
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Credit amount cannot be negative and equal to zero!';
    END IF;
    END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `check_numberof_credit` BEFORE INSERT ON `credit` FOR EACH ROW BEGIN
	DECLARE is_exist BOOLEAN;
	SET is_exist = is_credit_exist(NEW.account_id);
	IF is_exist = TRUE THEN
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'There is already one OPEN credit on the account!';
	END IF;
	END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `deposit`
--

CREATE TABLE `deposit` (
  `deposit_id` int(11) NOT NULL,
  `account_id` int(11) NOT NULL,
  `deposit_size` decimal(19,2) NOT NULL,
  `deposit_startdate` date NOT NULL,
  `deposit_enddate` date NOT NULL,
  `deposit_percent` decimal(19,2) NOT NULL,
  `deposit_status` enum('open','closed') DEFAULT 'open'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `deposit`
--

INSERT INTO `deposit` (`deposit_id`, `account_id`, `deposit_size`, `deposit_startdate`, `deposit_enddate`, `deposit_percent`, `deposit_status`) VALUES
(1, 1, 15000.00, '2024-05-26', '2026-04-01', 1.50, 'closed'),
(2, 2, 30000.00, '2024-05-26', '2024-07-05', 1.50, 'closed'),
(3, 3, 5000.00, '2024-05-26', '2025-10-01', 1.50, 'open');

--
-- Triggers `deposit`
--
DELIMITER $$
CREATE TRIGGER `auto_insert_deposit_startdate_status_percent` BEFORE INSERT ON `deposit` FOR EACH ROW BEGIN
	SET NEW.deposit_startdate = NOW();
    SET NEW.deposit_status = 'open';
    SET NEW.deposit_percent = 1.50;
    END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `check_deposit_size` BEFORE INSERT ON `deposit` FOR EACH ROW BEGIN
IF NEW.deposit_size <= 0 THEN
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Deposit amount cannot be negative and equal to zero!';
    END IF;
    END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `check_numberof_deposit` BEFORE INSERT ON `deposit` FOR EACH ROW BEGIN
DECLARE is_depositExist BOOLEAN;
SET is_depositExist = is_deposit_exist(NEW.account_id);
	IF is_depositExist = TRUE THEN
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'There is already one deposit on the account!';
	END IF;
	END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `transaction`
--

CREATE TABLE `transaction` (
  `transaction_id` int(11) NOT NULL,
  `sender_id` int(11) DEFAULT NULL,
  `resipient_id` int(11) DEFAULT NULL,
  `transaction_size` decimal(19,2) NOT NULL,
  `transaction_date` datetime NOT NULL,
  `transaction_status` enum('successfully','unsuccessfully','cancelled','pending') NOT NULL,
  `transaction_type` enum('account top-up','funds withdrawal','funds transfer','funds return') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `transaction`
--

INSERT INTO `transaction` (`transaction_id`, `sender_id`, `resipient_id`, `transaction_size`, `transaction_date`, `transaction_status`, `transaction_type`) VALUES
(1, 1, 2, 500.00, '2024-05-26 20:05:09', 'unsuccessfully', 'funds transfer'),
(2, 2, 3, 1000.00, '2024-05-26 20:05:09', 'successfully', 'funds transfer'),
(3, NULL, 3, 1500.00, '2024-05-26 20:05:09', 'unsuccessfully', 'account top-up'),
(4, 4, 1, 750.00, '2024-05-26 20:05:09', 'successfully', 'funds transfer'),
(5, NULL, 5, 2000.00, '2024-05-26 20:05:09', 'successfully', 'account top-up'),
(6, NULL, 1, 5.00, '2024-05-27 10:25:34', 'successfully', 'account top-up'),
(7, NULL, 1, 10.00, '2024-05-27 11:07:15', 'successfully', 'account top-up'),
(8, NULL, 1, 5.00, '2024-05-29 00:36:30', 'successfully', 'account top-up'),
(9, NULL, 1, 5.00, '2024-05-29 00:38:05', 'successfully', 'account top-up'),
(10, NULL, 1, 5.00, '2024-05-29 00:51:16', 'successfully', 'account top-up'),
(11, NULL, 1, 5.00, '2024-05-29 00:51:38', 'successfully', 'account top-up'),
(12, NULL, 1, 5.00, '2024-05-29 00:53:01', 'successfully', 'account top-up'),
(13, NULL, 1, 1.00, '2024-05-29 00:58:41', 'successfully', 'account top-up'),
(14, NULL, 1, 5.00, '2024-05-29 01:03:01', 'successfully', 'account top-up'),
(15, 1, NULL, 1.00, '2024-05-29 01:06:40', 'successfully', 'funds transfer');

--
-- Triggers `transaction`
--
DELIMITER $$
CREATE TRIGGER `check_transaction_size` BEFORE INSERT ON `transaction` FOR EACH ROW BEGIN
	IF NEW.transaction_size <= 0 THEN
    	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Transaction amount cannot be negative and equal to zero!';
    END IF;
    END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `inser_transaction_datetime` BEFORE INSERT ON `transaction` FOR EACH ROW BEGIN
	SET NEW.transaction_date = NOW();
    END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Stand-in structure for view `transaction_info`
-- (See below for the actual view)
--
CREATE TABLE `transaction_info` (
`transaction_id` int(11)
,`sender_id` int(11)
,`resipient_id` int(11)
,`transaction_size` decimal(19,2)
,`transaction_date` datetime
,`transaction_status` enum('successfully','unsuccessfully','cancelled','pending')
,`transaction_type` enum('account top-up','funds withdrawal','funds transfer','funds return')
);

-- --------------------------------------------------------

--
-- Structure for view `account_credit_info`
--
DROP TABLE IF EXISTS `account_credit_info`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `account_credit_info`  AS SELECT `credit`.`credit_id` AS `credit_id`, `credit`.`account_id` AS `account_id`, `credit`.`credit_size` AS `credit_size`, `credit`.`credit_startdate` AS `credit_startdate`, `credit`.`credit_enddate` AS `credit_enddate`, `credit`.`credit_status` AS `credit_status`, `credit`.`credit_percent` AS `credit_percent`, `credit`.`credit_limit` AS `credit_limit`, `account`.`client_id` AS `client_id`, `account`.`account_title` AS `account_title`, `account`.`account_number` AS `account_number` FROM (`credit` join `account` on(`credit`.`account_id` = `account`.`account_id`)) ;

-- --------------------------------------------------------

--
-- Structure for view `account_deposit_info`
--
DROP TABLE IF EXISTS `account_deposit_info`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `account_deposit_info`  AS SELECT `deposit`.`deposit_id` AS `deposit_id`, `deposit`.`account_id` AS `account_id`, `deposit`.`deposit_size` AS `deposit_size`, `deposit`.`deposit_startdate` AS `deposit_startdate`, `deposit`.`deposit_enddate` AS `deposit_enddate`, `deposit`.`deposit_percent` AS `deposit_percent`, `account`.`client_id` AS `client_id`, `account`.`account_title` AS `account_title`, `account`.`account_number` AS `account_number` FROM (`deposit` join `account` on(`deposit`.`account_id` = `account`.`account_id`)) ;

-- --------------------------------------------------------

--
-- Structure for view `client_accounts_info`
--
DROP TABLE IF EXISTS `client_accounts_info`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `client_accounts_info`  AS SELECT `client`.`client_id` AS `client_id`, `client`.`first_name` AS `first_name`, `client`.`last_name` AS `last_name`, `client`.`phone_number` AS `phone_number`, `client`.`email` AS `email`, `account`.`account_id` AS `account_id`, `account`.`account_title` AS `account_title`, `account`.`account_balance` AS `account_balance`, `account`.`account_number` AS `account_number`, `account`.`account_status` AS `account_status` FROM (`client` join `account` on(`client`.`client_id` = `account`.`client_id`)) ;

-- --------------------------------------------------------

--
-- Structure for view `transaction_info`
--
DROP TABLE IF EXISTS `transaction_info`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `transaction_info`  AS SELECT `t`.`transaction_id` AS `transaction_id`, `t`.`sender_id` AS `sender_id`, `t`.`resipient_id` AS `resipient_id`, `t`.`transaction_size` AS `transaction_size`, `t`.`transaction_date` AS `transaction_date`, `t`.`transaction_status` AS `transaction_status`, `t`.`transaction_type` AS `transaction_type` FROM `transaction` AS `t` ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `account`
--
ALTER TABLE `account`
  ADD PRIMARY KEY (`account_id`),
  ADD UNIQUE KEY `account_number` (`account_number`),
  ADD KEY `client_id` (`client_id`);

--
-- Indexes for table `client`
--
ALTER TABLE `client`
  ADD PRIMARY KEY (`client_id`),
  ADD UNIQUE KEY `phone_number` (`phone_number`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `credit`
--
ALTER TABLE `credit`
  ADD PRIMARY KEY (`credit_id`),
  ADD KEY `account_id` (`account_id`);

--
-- Indexes for table `deposit`
--
ALTER TABLE `deposit`
  ADD PRIMARY KEY (`deposit_id`),
  ADD KEY `account_id` (`account_id`);

--
-- Indexes for table `transaction`
--
ALTER TABLE `transaction`
  ADD PRIMARY KEY (`transaction_id`),
  ADD KEY `sender_id` (`sender_id`),
  ADD KEY `resipient_id` (`resipient_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `account`
--
ALTER TABLE `account`
  MODIFY `account_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `client`
--
ALTER TABLE `client`
  MODIFY `client_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `credit`
--
ALTER TABLE `credit`
  MODIFY `credit_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `deposit`
--
ALTER TABLE `deposit`
  MODIFY `deposit_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `transaction`
--
ALTER TABLE `transaction`
  MODIFY `transaction_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `account`
--
ALTER TABLE `account`
  ADD CONSTRAINT `account_ibfk_1` FOREIGN KEY (`client_id`) REFERENCES `client` (`client_id`);

--
-- Constraints for table `credit`
--
ALTER TABLE `credit`
  ADD CONSTRAINT `credit_ibfk_1` FOREIGN KEY (`account_id`) REFERENCES `account` (`account_id`);

--
-- Constraints for table `deposit`
--
ALTER TABLE `deposit`
  ADD CONSTRAINT `deposit_ibfk_1` FOREIGN KEY (`account_id`) REFERENCES `account` (`account_id`);

--
-- Constraints for table `transaction`
--
ALTER TABLE `transaction`
  ADD CONSTRAINT `transaction_ibfk_1` FOREIGN KEY (`sender_id`) REFERENCES `account` (`account_id`),
  ADD CONSTRAINT `transaction_ibfk_2` FOREIGN KEY (`resipient_id`) REFERENCES `account` (`account_id`);

DELIMITER $$
--
-- Events
--
CREATE DEFINER=`root`@`localhost` EVENT `calculate_credit_month` ON SCHEDULE EVERY 1 MONTH STARTS '2024-05-06 18:39:35' ON COMPLETION NOT PRESERVE ENABLE DO BEGIN
    UPDATE credit
    SET credit_size = credit_size + ((credit_size * credit_percent)/100)
    WHERE DATEDIFF(NOW(), credit_startdate) > 0 AND credit_status = 'open';
END$$

CREATE DEFINER=`root`@`localhost` EVENT `calculate_deposit_month` ON SCHEDULE EVERY 1 MONTH STARTS '2024-05-06 18:39:35' ON COMPLETION NOT PRESERVE ENABLE DO BEGIN
    UPDATE deposit
    SET deposit_size = deposit_size + ((deposit_size * deposit_percent)/100)
    WHERE DATEDIFF(NOW(), deposit_startdate) > 0 AND deposit_status = 'open';
END$$

CREATE DEFINER=`root`@`localhost` EVENT `update_deposit_status_event` ON SCHEDULE EVERY 1 SECOND STARTS '2024-01-01 00:00:00' ON COMPLETION NOT PRESERVE ENABLE DO BEGIN
    UPDATE deposit
    SET deposit_status = 'closed'
    WHERE deposit_enddate < NOW() AND deposit_status != 'closed';
END$$

DELIMITER ;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
