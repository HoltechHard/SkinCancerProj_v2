-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema db_skin_cancer
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema db_skin_cancer
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `db_skin_cancer` DEFAULT CHARACTER SET utf8 ;
USE `db_skin_cancer` ;

-- -----------------------------------------------------
-- Table `db_skin_cancer`.`Type_image`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `db_skin_cancer`.`Type_image` (
  `id_type_image` INT NOT NULL AUTO_INCREMENT,
  `description` VARCHAR(45) NULL,
  PRIMARY KEY (`id_type_image`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `db_skin_cancer`.`Patient`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `db_skin_cancer`.`Patient` (
  `id_patient` INT NOT NULL AUTO_INCREMENT,
  `full_name` VARCHAR(200) NULL,
  `age` INT NULL,
  `anatomy` VARCHAR(45) NULL,
  `sex` CHAR(1) NULL,
  `class_pred` VARCHAR(45) NULL,
  `prob_pred` DECIMAL(7,5) NULL,
  `url_image` VARCHAR(400) NULL,
  `fk_id_type_image` INT NOT NULL,
  PRIMARY KEY (`id_patient`),
  INDEX `fk_Patient_Type_image_idx` (`fk_id_type_image` ASC) VISIBLE,
  CONSTRAINT `fk_Patient_Type_image`
    FOREIGN KEY (`fk_id_type_image`)
    REFERENCES `db_skin_cancer`.`Type_image` (`id_type_image`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `db_skin_cancer`.`Type_cancer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `db_skin_cancer`.`Type_cancer` (
  `id_cancer` INT NOT NULL AUTO_INCREMENT,
  `description` VARCHAR(100) NULL,
  PRIMARY KEY (`id_cancer`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `db_skin_cancer`.`Scores`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `db_skin_cancer`.`Scores` (
  `fk_id_cancer` INT NOT NULL,
  `fk_id_patient` INT NOT NULL,
  `prob_score` DECIMAL(7,5) NULL,
  PRIMARY KEY (`fk_id_cancer`, `fk_id_patient`),
  INDEX `fk_Scores_Patient1_idx` (`fk_id_patient` ASC) VISIBLE,
  CONSTRAINT `fk_Scores_Type_cancer1`
    FOREIGN KEY (`fk_id_cancer`)
    REFERENCES `db_skin_cancer`.`Type_cancer` (`id_cancer`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Scores_Patient1`
    FOREIGN KEY (`fk_id_patient`)
    REFERENCES `db_skin_cancer`.`Patient` (`id_patient`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `db_skin_cancer`.`Model`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `db_skin_cancer`.`Model` (
  `id_model` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(80) NULL,
  `type` VARCHAR(45) NULL,
  PRIMARY KEY (`id_model`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `db_skin_cancer`.`Experiment`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `db_skin_cancer`.`Experiment` (
  `id_experiment` INT NOT NULL AUTO_INCREMENT,
  `description` VARCHAR(300) NULL,
  `path_exp` VARCHAR(500) NULL,
  `fk_id_model` INT NOT NULL,
  PRIMARY KEY (`id_experiment`),
  INDEX `fk_Experiment_Model1_idx` (`fk_id_model` ASC) VISIBLE,
  CONSTRAINT `fk_Experiment_Model1`
    FOREIGN KEY (`fk_id_model`)
    REFERENCES `db_skin_cancer`.`Model` (`id_model`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
