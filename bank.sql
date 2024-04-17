-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
<<<<<<< HEAD
-- Host: 127.0.0.1
-- Generation Time: Apr 17, 2024 at 04:28 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12
=======
-- Хост: 127.0.0.1
-- Час створення: Квт 08 2024 р., 12:40
-- Версія сервера: 10.4.32-MariaDB
-- Версія PHP: 8.2.12
>>>>>>> b92465529f4c3577c99fe5918b2092e5cfffd764

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База даних: `bank`
--

DELIMITER $$
--
-- Функції
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
-- Структура таблиці `account`
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
-- Дамп даних таблиці `account`
--

INSERT INTO `account` (`account_id`, `client_id`, `account_title`, `account_number`, `account_balance`, `account_status`, `account_startdate`) VALUES
(1, 1, 'UAH', '1234567890124567', 1100.27, 'online', '2020-03-04 19:03:29'),
(2, 1, 'USD', '4321654785903778', 100.57, 'online', '2023-07-13 12:13:37'),
(3, 1, 'EUR', '4444555566667777', 0.00, 'offline', '2024-03-24 13:13:13'),
(4, 2, 'UAH', '1111222233334444', 11275.00, 'online', '2022-10-04 15:34:01'),
(5, 3, 'UAH', '5445123442216789', 0.57, 'online', '2023-03-01 10:04:49'),
(6, 4, 'UAH', '6666757544227890', 250.00, 'online', '2022-12-12 15:15:04'),
(7, 4, 'USD', '7456345782901259', 1347.27, 'online', '2024-03-14 19:05:32'),
(8, 5, 'USD', '3458982458972387', 0.00, 'offline', '2024-01-01 12:05:12'),
(9, 2, 'USD', '1101222233384444', 0.00, 'online', '2024-08-04 12:00:00');

--
-- Тригери `account`
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
-- Дублююча структура для представлення `account_credit_info`
-- (Див. нижче для фактичного подання)
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
-- Дублююча структура для представлення `account_deposit_info`
-- (Див. нижче для фактичного подання)
--
CREATE TABLE `account_deposit_info` (
`deposit_id` int(11)
,`account_id` int(11)
,`deposit_size` decimal(19,2)
,`deposit_startdate` datetime
,`deposit_enddate` datetime
,`deposit_percent` decimal(19,2)
,`client_id` int(11)
,`account_title` enum('UAH','USD','EUR','')
,`account_number` varchar(16)
);

-- --------------------------------------------------------

--
-- Структура таблиці `client`
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
-- Дамп даних таблиці `client`
--

INSERT INTO `client` (`client_id`, `first_name`, `last_name`, `phone_number`, `email`, `birth_date`, `password`) VALUES
(1, 'John', 'Smith', '1234567890', 'john@example.com', '1985-07-15', 'password1'),
(2, 'Alice', 'Johnson', '9876543210', 'alice@example.com', '1990-02-28', 'password2'),
(3, 'Michael', 'Brown', '5555555555', 'michael@example.com', '1988-11-03', 'password3'),
(4, 'Emily', 'Davis', '1112223333', 'emily@example.com', '1995-09-20', 'password4'),
(5, 'David', 'Wilson', '4444444444', 'david@example.com', '1980-04-10', 'password5');

-- --------------------------------------------------------

--
-- Дублююча структура для представлення `client_accounts_info`
-- (Див. нижче для фактичного подання)
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
-- Структура таблиці `credit`
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
-- Дамп даних таблиці `credit`
--

INSERT INTO `credit` (`credit_id`, `account_id`, `credit_size`, `credit_startdate`, `credit_enddate`, `credit_status`, `credit_percent`, `credit_limit`) VALUES
(1, 1, 25000.00, '2024-01-01 12:00:00', '2026-01-01 11:59:59', 'open', 2.50, 1000000.00),
(2, 5, 100000.00, '2024-03-10 15:14:26', '2024-03-10 15:14:25', 'paid', 1.50, 1000000.00),
(3, 2, 20000.00, '2022-04-04 12:00:00', '2024-04-04 12:00:00', 'open', 0.00, 50000.00);

--
-- Тригери `credit`
--
DELIMITER $$
CREATE TRIGGER `check_credit_limit` BEFORE INSERT ON `credit` FOR EACH ROW BEGIN
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
-- Структура таблиці `deposit`
--

CREATE TABLE `deposit` (
  `deposit_id` int(11) NOT NULL,
  `account_id` int(11) NOT NULL,
  `deposit_size` decimal(19,2) NOT NULL,
  `deposit_startdate` datetime NOT NULL,
  `deposit_enddate` datetime NOT NULL,
  `deposit_percent` decimal(19,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп даних таблиці `deposit`
--

INSERT INTO `deposit` (`deposit_id`, `account_id`, `deposit_size`, `deposit_startdate`, `deposit_enddate`, `deposit_percent`) VALUES
(1, 5, 150000.00, '2021-12-12 15:00:00', '2027-12-12 15:00:00', 2.50),
(2, 7, 25000.00, '2020-09-01 11:22:30', '2024-09-01 11:22:00', 2.50),
(3, 6, 200000.00, '2023-01-01 19:23:23', '2030-01-01 19:23:23', 2.50);

--
-- Тригери `deposit`
--
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
-- Структура таблиці `transaction`
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
-- Дамп даних таблиці `transaction`
--

INSERT INTO `transaction` (`transaction_id`, `sender_id`, `resipient_id`, `transaction_size`, `transaction_date`, `transaction_status`, `transaction_type`) VALUES
(1, 4, 1, 1100.00, '2024-01-01 13:45:53', 'successfully', 'funds transfer'),
(2, 4, 6, 250.00, '2024-01-01 14:00:05', 'successfully', 'funds transfer'),
(3, 8, 7, 347.00, '2023-12-30 18:59:01', 'successfully', 'funds transfer'),
(4, NULL, 4, 1100.00, '2024-02-24 12:12:00', 'successfully', 'account top-up');

--
-- Тригери `transaction`
--
DELIMITER $$
CREATE TRIGGER `check_transaction_size` BEFORE INSERT ON `transaction` FOR EACH ROW BEGIN
	IF NEW.transaction_size <= 0 THEN
    	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Transaction amount cannot be negative and equal to zero!';
    END IF;
    END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Дублююча структура для представлення `transaction_info`
-- (Див. нижче для фактичного подання)
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
-- Структура для представлення `account_credit_info`
--
DROP TABLE IF EXISTS `account_credit_info`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `account_credit_info`  AS SELECT `credit`.`credit_id` AS `credit_id`, `credit`.`account_id` AS `account_id`, `credit`.`credit_size` AS `credit_size`, `credit`.`credit_startdate` AS `credit_startdate`, `credit`.`credit_enddate` AS `credit_enddate`, `credit`.`credit_status` AS `credit_status`, `credit`.`credit_percent` AS `credit_percent`, `credit`.`credit_limit` AS `credit_limit`, `account`.`client_id` AS `client_id`, `account`.`account_title` AS `account_title`, `account`.`account_number` AS `account_number` FROM (`credit` join `account` on(`credit`.`account_id` = `account`.`account_id`)) ;

-- --------------------------------------------------------

--
-- Структура для представлення `account_deposit_info`
--
DROP TABLE IF EXISTS `account_deposit_info`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `account_deposit_info`  AS SELECT `deposit`.`deposit_id` AS `deposit_id`, `deposit`.`account_id` AS `account_id`, `deposit`.`deposit_size` AS `deposit_size`, `deposit`.`deposit_startdate` AS `deposit_startdate`, `deposit`.`deposit_enddate` AS `deposit_enddate`, `deposit`.`deposit_percent` AS `deposit_percent`, `account`.`client_id` AS `client_id`, `account`.`account_title` AS `account_title`, `account`.`account_number` AS `account_number` FROM (`deposit` join `account` on(`deposit`.`account_id` = `account`.`account_id`)) ;

-- --------------------------------------------------------

--
-- Структура для представлення `client_accounts_info`
--
DROP TABLE IF EXISTS `client_accounts_info`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `client_accounts_info`  AS SELECT `client`.`client_id` AS `client_id`, `client`.`first_name` AS `first_name`, `client`.`last_name` AS `last_name`, `client`.`phone_number` AS `phone_number`, `client`.`email` AS `email`, `account`.`account_id` AS `account_id`, `account`.`account_title` AS `account_title`, `account`.`account_balance` AS `account_balance`, `account`.`account_number` AS `account_number`, `account`.`account_status` AS `account_status` FROM (`client` join `account` on(`client`.`client_id` = `account`.`client_id`)) ;

-- --------------------------------------------------------

--
-- Структура для представлення `transaction_info`
--
DROP TABLE IF EXISTS `transaction_info`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `transaction_info`  AS SELECT `t`.`transaction_id` AS `transaction_id`, `t`.`sender_id` AS `sender_id`, `t`.`resipient_id` AS `resipient_id`, `t`.`transaction_size` AS `transaction_size`, `t`.`transaction_date` AS `transaction_date`, `t`.`transaction_status` AS `transaction_status`, `t`.`transaction_type` AS `transaction_type` FROM `transaction` AS `t` ;

--
-- Індекси збережених таблиць
--

--
-- Індекси таблиці `account`
--
ALTER TABLE `account`
  ADD PRIMARY KEY (`account_id`),
  ADD UNIQUE KEY `account_number` (`account_number`),
  ADD KEY `client_id` (`client_id`);

--
-- Індекси таблиці `client`
--
ALTER TABLE `client`
  ADD PRIMARY KEY (`client_id`),
  ADD UNIQUE KEY `phone_number` (`phone_number`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Індекси таблиці `credit`
--
ALTER TABLE `credit`
  ADD PRIMARY KEY (`credit_id`),
  ADD KEY `account_id` (`account_id`);

--
-- Індекси таблиці `deposit`
--
ALTER TABLE `deposit`
  ADD PRIMARY KEY (`deposit_id`),
  ADD KEY `account_id` (`account_id`);

--
-- Індекси таблиці `transaction`
--
ALTER TABLE `transaction`
  ADD PRIMARY KEY (`transaction_id`),
  ADD KEY `sender_id` (`sender_id`),
  ADD KEY `resipient_id` (`resipient_id`);

--
-- AUTO_INCREMENT для збережених таблиць
--

--
-- AUTO_INCREMENT для таблиці `account`
--
ALTER TABLE `account`
  MODIFY `account_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT для таблиці `client`
--
ALTER TABLE `client`
  MODIFY `client_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT для таблиці `credit`
--
ALTER TABLE `credit`
  MODIFY `credit_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT для таблиці `deposit`
--
ALTER TABLE `deposit`
  MODIFY `deposit_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT для таблиці `transaction`
--
ALTER TABLE `transaction`
  MODIFY `transaction_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Обмеження зовнішнього ключа збережених таблиць
--

--
-- Обмеження зовнішнього ключа таблиці `account`
--
ALTER TABLE `account`
  ADD CONSTRAINT `account_ibfk_1` FOREIGN KEY (`client_id`) REFERENCES `client` (`client_id`);

--
-- Обмеження зовнішнього ключа таблиці `credit`
--
ALTER TABLE `credit`
  ADD CONSTRAINT `credit_ibfk_1` FOREIGN KEY (`account_id`) REFERENCES `account` (`account_id`);

--
-- Обмеження зовнішнього ключа таблиці `deposit`
--
ALTER TABLE `deposit`
  ADD CONSTRAINT `deposit_ibfk_1` FOREIGN KEY (`account_id`) REFERENCES `account` (`account_id`);

--
-- Обмеження зовнішнього ключа таблиці `transaction`
--
ALTER TABLE `transaction`
  ADD CONSTRAINT `transaction_ibfk_1` FOREIGN KEY (`sender_id`) REFERENCES `account` (`account_id`),
  ADD CONSTRAINT `transaction_ibfk_2` FOREIGN KEY (`resipient_id`) REFERENCES `account` (`account_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
