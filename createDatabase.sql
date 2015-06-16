-- MySQL Script generated by MySQL Workbench
-- Sat Jun  6 16:47:51 2015
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema PongHacks
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `PongHacks` ;

-- -----------------------------------------------------
-- Schema PongHacks
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `PongHacks` ;
USE `PongHacks` ;

-- -----------------------------------------------------
-- Table `PongHacks`.`User`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `PongHacks`.`User` ;

CREATE TABLE IF NOT EXISTS `PongHacks`.`User` (
  `userId` INT(11) NOT NULL,
  `email` VARCHAR(100) NOT NULL,
  `name` VARCHAR(150) NOT NULL,
  `mentionName` VARCHAR(45) NOT NULL,
  `avatarUrl` VARCHAR(150) NULL DEFAULT NULL,
  `eloRanking` INT NOT NULL DEFAULT 2000,
  PRIMARY KEY (`userId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `PongHacks`.`Game`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `PongHacks`.`Game` ;

CREATE TABLE IF NOT EXISTS `PongHacks`.`Game` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `winnerUserId` INT(11) NOT NULL,
  `winnerScore` INT(11) NOT NULL,
  `loserUserId` INT(11) NOT NULL,
  `loserScore` INT(11) NOT NULL,
  `date` DATETIME NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `winnerUserId` (`winnerUserId` ASC),
  INDEX `loserUserId` (`loserUserId` ASC),
  CONSTRAINT `loserUserId`
    FOREIGN KEY (`loserUserId`)
    REFERENCES `PongHacks`.`User` (`userId`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `winnerUserId`
    FOREIGN KEY (`winnerUserId`)
    REFERENCES `PongHacks`.`User` (`userId`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 51
DEFAULT CHARACTER SET = utf8;


-- CREATE PROCEDURE FOR PLAYER's LONGEST WINNING STREAK
DROP PROCEDURE IF EXISTS userLongestWinningStreak;
DROP PROCEDURE IF EXISTS userLongestLosingStreak;


DELIMITER //
 
CREATE PROCEDURE `userLongestWinningStreak` (IN userId INT, OUT streak INT)
BEGIN

    DECLARE maxStreak INT DEFAULT 0;
    DECLARE b, streakCounter, winnerId INT;
    DECLARE curWinnerIds CURSOR FOR SELECT winnerUserID FROM Game WHERE winnerUserId = userId or loserUserId = userId ORDER BY date ASC;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET b = 1;
    OPEN curWinnerIds;
    
    SET b = 0;
    SET streakCounter = 0;
    
    WHILE b = 0 DO
        FETCH curWinnerIds INTO winnerId;
        IF b = 0 THEN
            IF winnerId = userId THEN
              SET streakCounter = streakCounter + 1;
            ELSE
              IF streakCounter > maxStreak THEN
                SET maxStreak = streakCounter;
                SET streakCounter = 0;
          END IF;
        END IF;  
      END IF;  
    END WHILE;
 
    CLOSE curWinnerIds;
    
    IF streakCounter > maxStreak THEN
      SET maxStreak = streakCounter;
      SET streakCounter = 0;
  END IF;

    SET streak = maxStreak;
 
END //

-- CREATE PROCEDURE FOR PLAYER's LONGEST WINNING STREAK

CREATE PROCEDURE `userLongestLosingStreak` (IN userId INT, OUT streak INT)
BEGIN

    DECLARE maxStreak INT DEFAULT 0;
    DECLARE b, streakCounter, loserId INT;
    DECLARE curLoserIds CURSOR FOR SELECT loserUserId FROM Game WHERE winnerUserId = userId or loserUserId = userId ORDER BY date ASC;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET b = 1;
    OPEN curLoserIds;
    
    SET b = 0;
    SET streakCounter = 0;
    
    WHILE b = 0 DO
        FETCH curLoserIds INTO loserId;
        IF b = 0 THEN
            IF loserId = userId THEN
              SET streakCounter = streakCounter + 1;
            ELSE
              IF streakCounter > maxStreak THEN
                SET maxStreak = streakCounter;
                SET streakCounter = 0;
          END IF;
        END IF;  
      END IF;  
    END WHILE;
 
    CLOSE curLoserIds;
    
    IF streakCounter > maxStreak THEN
      SET maxStreak = streakCounter;
      SET streakCounter = 0;
  END IF;

    SET streak = maxStreak;
 
END //

DELIMITER ;

-- CREATE TABLE VIEW FOR USERS THAT HAVE PLAYED AT LEAST ONE GAME
CREATE OR REPLACE VIEW activeUsers AS 
SELECT * FROM User
WHERE userId IN (
        SELECT DISTINCT winnerUserID FROM Game
        UNION
        SELECT DISTINCT loserUserId FROM Game
        );


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
