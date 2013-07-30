-- phpMyAdmin SQL Dump
-- version 3.5.2.2
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: Jul 31, 2013 at 12:41 AM
-- Server version: 5.5.27
-- PHP Version: 5.4.7

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `game`
--

DELIMITER $$
--
-- Procedures
--
DROP PROCEDURE IF EXISTS `check_q_num`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `check_q_num`(IN cid int)
BEGIN
  DECLARE num int default 0;
  select count(*) into num
  from questions 
  where category_id=cid;
  if num<10 then
  update categories set display=0 where id=cid;
  else 
  update categories set display=1 where id=cid;
  end if;
END$$

DROP PROCEDURE IF EXISTS `update_scoreboard`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_scoreboard`(IN cid int,IN username varchar(50),IN win decimal(18,2))
BEGIN
declare num int default 0;
select count(*) into num
from scoreboard
where category_id=cid and player_name=username;
if num>0 then 
update scoreboard set score=score+win where category_id=cid and player_name=username;
else insert into scoreboard values(username,cid,win);
end if;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `answers`
--

DROP TABLE IF EXISTS `answers`;
CREATE TABLE IF NOT EXISTS `answers` (
  `id` int(255) NOT NULL AUTO_INCREMENT,
  `question_id` int(255) NOT NULL,
  `text` text NOT NULL,
  `correct` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `question_id` (`question_id`),
  KEY `id` (`id`),
  KEY `question_id_2` (`question_id`),
  KEY `id_2` (`id`),
  KEY `question_id_3` (`question_id`),
  KEY `question_id_4` (`question_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=313 ;

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
CREATE TABLE IF NOT EXISTS `categories` (
  `id` int(100) NOT NULL AUTO_INCREMENT,
  `category` varchar(100) NOT NULL,
  `display` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

-- --------------------------------------------------------

--
-- Table structure for table `game_player`
--

DROP TABLE IF EXISTS `game_player`;
CREATE TABLE IF NOT EXISTS `game_player` (
  `game_id` varchar(255) NOT NULL,
  `player_name` varchar(100) NOT NULL,
  `win` int(10) NOT NULL DEFAULT '0',
  `lose` int(10) NOT NULL DEFAULT '0',
  `score` int(10) NOT NULL DEFAULT '0',
  `end_time` varchar(100) NOT NULL,
  `time` varchar(50) NOT NULL,
  `category_id` int(100) NOT NULL,
  KEY `game_id` (`game_id`),
  KEY `player_name` (`player_name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `game_question`
--

DROP TABLE IF EXISTS `game_question`;
CREATE TABLE IF NOT EXISTS `game_question` (
  `game_id` varchar(100) NOT NULL,
  `question_id` int(255) NOT NULL,
  `text` text NOT NULL,
  KEY `game_id` (`game_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `leader_board`
--

DROP TABLE IF EXISTS `leader_board`;
CREATE TABLE IF NOT EXISTS `leader_board` (
  `player_name` varchar(100) NOT NULL,
  `category_id` int(100) NOT NULL,
  `score` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `managers`
--

DROP TABLE IF EXISTS `managers`;
CREATE TABLE IF NOT EXISTS `managers` (
  `id` int(255) NOT NULL AUTO_INCREMENT,
  `username` varchar(100) NOT NULL,
  `password` varchar(100) NOT NULL,
  `authority_id` int(20) NOT NULL,
  `category_id` int(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `category_id` (`category_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `players`
--

DROP TABLE IF EXISTS `players`;
CREATE TABLE IF NOT EXISTS `players` (
  `id` int(255) NOT NULL AUTO_INCREMENT,
  `username` varchar(100) NOT NULL,
  `password` varchar(100) NOT NULL,
  `motto` varchar(200) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username_2` (`username`),
  KEY `username` (`username`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=11 ;

-- --------------------------------------------------------

--
-- Table structure for table `player_list`
--

DROP TABLE IF EXISTS `player_list`;
CREATE TABLE IF NOT EXISTS `player_list` (
  `category_id` int(100) NOT NULL,
  `username` varchar(100) NOT NULL,
  `status` int(10) NOT NULL DEFAULT '0',
  `time` varchar(50) NOT NULL,
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `questions`
--

DROP TABLE IF EXISTS `questions`;
CREATE TABLE IF NOT EXISTS `questions` (
  `id` int(255) NOT NULL AUTO_INCREMENT,
  `category_id` int(100) NOT NULL,
  `title` varchar(1000) NOT NULL,
  `text` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `category_id` (`category_id`),
  KEY `id` (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=78 ;

--
-- Triggers `questions`
--
DROP TRIGGER IF EXISTS `delete_q_num`;
DELIMITER //
CREATE TRIGGER `delete_q_num` AFTER DELETE ON `questions`
 FOR EACH ROW BEGIN 
call check_q_num(OLD.category_id);
END
//
DELIMITER ;
DROP TRIGGER IF EXISTS `insert_q_num`;
DELIMITER //
CREATE TRIGGER `insert_q_num` AFTER INSERT ON `questions`
 FOR EACH ROW BEGIN 
call check_q_num(NEW.category_id);
END
//
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `score`
--

DROP TABLE IF EXISTS `score`;
CREATE TABLE IF NOT EXISTS `score` (
  `id` int(255) NOT NULL AUTO_INCREMENT,
  `player_name` varchar(100) NOT NULL,
  `category_id` int(100) NOT NULL,
  `win` int(11) NOT NULL DEFAULT '0',
  `usedtime` varchar(10) NOT NULL,
  `correct_num` int(10) NOT NULL,
  `opponent` varchar(100) NOT NULL,
  `time` varchar(34) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `player_name` (`player_name`),
  KEY `category_id` (`category_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=77 ;

--
-- Triggers `score`
--
DROP TRIGGER IF EXISTS `update_score`;
DELIMITER //
CREATE TRIGGER `update_score` AFTER INSERT ON `score`
 FOR EACH ROW BEGIN 
call update_scoreboard(new.category_id,new.player_name,new.win);
END
//
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `scoreboard`
--

DROP TABLE IF EXISTS `scoreboard`;
CREATE TABLE IF NOT EXISTS `scoreboard` (
  `player_name` varchar(50) NOT NULL,
  `category_id` int(50) NOT NULL,
  `score` decimal(18,2) NOT NULL,
  PRIMARY KEY (`player_name`,`category_id`),
  KEY `score` (`score`),
  KEY `player_name` (`player_name`),
  KEY `score_2` (`score`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `answers`
--
ALTER TABLE `answers`
  ADD CONSTRAINT `answers_ibfk_1` FOREIGN KEY (`question_id`) REFERENCES `questions` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `managers`
--
ALTER TABLE `managers`
  ADD CONSTRAINT `managers_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `questions`
--
ALTER TABLE `questions`
  ADD CONSTRAINT `questions_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
