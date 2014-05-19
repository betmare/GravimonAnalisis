SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

CREATE SCHEMA IF NOT EXISTS `datosdatos` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `datosdatos` ;

-- -----------------------------------------------------
-- Table `datosdatos`.`rol`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `datosdatos`.`rol` (
  `idrol` INT NOT NULL AUTO_INCREMENT ,
  `nombre` VARCHAR(45) NOT NULL ,
  `descripcion` TEXT NULL ,
  PRIMARY KEY (`idrol`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `datosdatos`.`usuario`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `datosdatos`.`usuario` (
  `nombreusuario` VARCHAR(45) NOT NULL ,
  `clave` VARCHAR(45) NOT NULL ,
  `sesion` VARCHAR(45) NULL DEFAULT '1' ,
  `nombre` VARCHAR(45) NOT NULL ,
  `apellido` VARCHAR(45) NOT NULL ,
  `direccion` VARCHAR(45) NOT NULL ,
  `telefonofijo` VARCHAR(45) NOT NULL ,
  `telefonomovil` VARCHAR(45) NOT NULL ,
  `email` VARCHAR(45) NULL ,
  `rol_idrol` INT NOT NULL ,
  PRIMARY KEY (`nombreusuario`) ,
  INDEX `fk_usuario_rol1_idx` (`rol_idrol` ASC) ,
  CONSTRAINT `fk_usuario_rol1`
    FOREIGN KEY (`rol_idrol` )
    REFERENCES `datosdatos`.`rol` (`idrol` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `datosdatos`.`banco`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `datosdatos`.`banco` (
  `codigodelbanco` INT NOT NULL ,
  `nombrebanco` VARCHAR(45) NOT NULL ,
  `descripcion` LONGTEXT NULL ,
  `usuario_nombreusuario` VARCHAR(45) NOT NULL ,
  PRIMARY KEY (`codigodelbanco`) ,
  UNIQUE INDEX `nombrebanco_UNIQUE` (`nombrebanco` ASC) ,
  INDEX `fk_banco_usuario1_idx` (`usuario_nombreusuario` ASC) ,
  CONSTRAINT `fk_banco_usuario1`
    FOREIGN KEY (`usuario_nombreusuario` )
    REFERENCES `datosdatos`.`usuario` (`nombreusuario` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `datosdatos`.`cheque`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `datosdatos`.`cheque` (
  `idcheque` INT NOT NULL AUTO_INCREMENT ,
  `banco_codigodelbanco` INT NOT NULL ,
  `numerodecheque` VARCHAR(60) NOT NULL ,
  `numerodecuenta` VARCHAR(60) NULL ,
  `monto` INT NOT NULL ,
  `montopagointereses` INT NOT NULL ,
  `fecharecibido` DATETIME NOT NULL ,
  `fechacobro` DATETIME NOT NULL ,
  `fotodelante` LONGTEXT NOT NULL ,
  `fotodetras` LONGTEXT NULL ,
  `usuario_nombreusuario` VARCHAR(45) NOT NULL ,
  PRIMARY KEY (`idcheque`) ,
  UNIQUE INDEX `numerodecheque_UNIQUE` (`numerodecheque` ASC) ,
  INDEX `fk_cheque_banco_idx` (`banco_codigodelbanco` ASC) ,
  INDEX `fk_cheque_usuario1_idx` (`usuario_nombreusuario` ASC) ,
  CONSTRAINT `fk_cheque_banco`
    FOREIGN KEY (`banco_codigodelbanco` )
    REFERENCES `datosdatos`.`banco` (`codigodelbanco` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_cheque_usuario1`
    FOREIGN KEY (`usuario_nombreusuario` )
    REFERENCES `datosdatos`.`usuario` (`nombreusuario` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `datosdatos`.`cuentabancaria`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `datosdatos`.`cuentabancaria` (
  `idcuentabancaria` INT NOT NULL AUTO_INCREMENT ,
  `banco_codigodelbanco` INT NOT NULL ,
  `numeriodecuenta` VARCHAR(80) NOT NULL ,
  `descripcion` LONGTEXT NULL ,
  `usuario_nombreusuario` VARCHAR(45) NOT NULL ,
  PRIMARY KEY (`idcuentabancaria`) ,
  INDEX `fk_cuentabancaria_banco1_idx` (`banco_codigodelbanco` ASC) ,
  INDEX `fk_cuentabancaria_usuario1_idx` (`usuario_nombreusuario` ASC) ,
  CONSTRAINT `fk_cuentabancaria_banco1`
    FOREIGN KEY (`banco_codigodelbanco` )
    REFERENCES `datosdatos`.`banco` (`codigodelbanco` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_cuentabancaria_usuario1`
    FOREIGN KEY (`usuario_nombreusuario` )
    REFERENCES `datosdatos`.`usuario` (`nombreusuario` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `datosdatos`.`cliente`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `datosdatos`.`cliente` (
  `cedulacliente` INT NOT NULL ,
  `nombre` VARCHAR(45) NOT NULL ,
  `apellido` VARCHAR(45) NOT NULL ,
  `apodo` VARCHAR(45) NULL ,
  `fechafichacliente` DATETIME NOT NULL ,
  `direccion` VARCHAR(45) NOT NULL ,
  `telefonofijo` VARCHAR(45) NOT NULL ,
  `telefonomovil` VARCHAR(45) NOT NULL ,
  `cuentabancaria_idcuentabancaria` INT NOT NULL ,
  `email` VARCHAR(45) NULL ,
  `usuario_nombreusuario` VARCHAR(45) NOT NULL ,
  PRIMARY KEY (`cedulacliente`) ,
  INDEX `fk_cliente_cuentabancaria1_idx` (`cuentabancaria_idcuentabancaria` ASC) ,
  INDEX `fk_cliente_usuario1_idx` (`usuario_nombreusuario` ASC) ,
  CONSTRAINT `fk_cliente_cuentabancaria1`
    FOREIGN KEY (`cuentabancaria_idcuentabancaria` )
    REFERENCES `datosdatos`.`cuentabancaria` (`idcuentabancaria` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_cliente_usuario1`
    FOREIGN KEY (`usuario_nombreusuario` )
    REFERENCES `datosdatos`.`usuario` (`nombreusuario` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `datosdatos`.`estadocheque`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `datosdatos`.`estadocheque` (
  `idestadocheque` INT NOT NULL AUTO_INCREMENT ,
  `nombre` VARCHAR(45) NOT NULL COMMENT 'por cobrar,  sin fondos, cobrado, cobrado y debemos, ' ,
  `descripcion` LONGTEXT NULL ,
  `usuario_nombreusuario` VARCHAR(45) NOT NULL ,
  PRIMARY KEY (`idestadocheque`) ,
  INDEX `fk_estadocheque_usuario1_idx` (`usuario_nombreusuario` ASC) ,
  CONSTRAINT `fk_estadocheque_usuario1`
    FOREIGN KEY (`usuario_nombreusuario` )
    REFERENCES `datosdatos`.`usuario` (`nombreusuario` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `datosdatos`.`cheque_estadocheque`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `datosdatos`.`cheque_estadocheque` (
  `idcheque_estado` INT NOT NULL AUTO_INCREMENT ,
  `fechadelcheque_estadocheque` DATETIME NOT NULL ,
  `estadocheque_idestadocheque` INT NOT NULL ,
  `cheque_idcheque` INT NOT NULL ,
  `cancelacion` INT NOT NULL COMMENT '1, deuda, 2 cobrado, 3 cobrado y debemos' ,
  `usuario_nombreusuario` VARCHAR(45) NOT NULL ,
  PRIMARY KEY (`idcheque_estado`) ,
  INDEX `fk_cheque_estadocheque_estadocheque1_idx` (`estadocheque_idestadocheque` ASC) ,
  INDEX `fk_cheque_estadocheque_cheque1_idx` (`cheque_idcheque` ASC) ,
  INDEX `fk_cheque_estadocheque_usuario1_idx` (`usuario_nombreusuario` ASC) ,
  CONSTRAINT `fk_cheque_estadocheque_estadocheque1`
    FOREIGN KEY (`estadocheque_idestadocheque` )
    REFERENCES `datosdatos`.`estadocheque` (`idestadocheque` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_cheque_estadocheque_cheque1`
    FOREIGN KEY (`cheque_idcheque` )
    REFERENCES `datosdatos`.`cheque` (`idcheque` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_cheque_estadocheque_usuario1`
    FOREIGN KEY (`usuario_nombreusuario` )
    REFERENCES `datosdatos`.`usuario` (`nombreusuario` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `datosdatos`.`tipodepago`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `datosdatos`.`tipodepago` (
  `idtipodepago` INT NOT NULL AUTO_INCREMENT ,
  `nombre` VARCHAR(45) NOT NULL ,
  `descripcion` LONGTEXT NULL ,
  `usuario_nombreusuario` VARCHAR(45) NOT NULL ,
  PRIMARY KEY (`idtipodepago`) ,
  INDEX `fk_tipodepago_usuario1_idx` (`usuario_nombreusuario` ASC) ,
  CONSTRAINT `fk_tipodepago_usuario1`
    FOREIGN KEY (`usuario_nombreusuario` )
    REFERENCES `datosdatos`.`usuario` (`nombreusuario` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `datosdatos`.`cheque_cliente`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `datosdatos`.`cheque_cliente` (
  `recibodeposito` INT NOT NULL AUTO_INCREMENT ,
  `cliente_cedulacliente` INT NOT NULL ,
  `fechapago` DATETIME NOT NULL ,
  `montodeposito` INT NOT NULL ,
  `cheque_idcheque` INT NOT NULL ,
  `tipodepago_idtipodepago` INT NOT NULL ,
  `usuario_nombreusuario` VARCHAR(45) NOT NULL ,
  PRIMARY KEY (`recibodeposito`) ,
  INDEX `fk_cheque_cliente_cheque1_idx` (`cheque_idcheque` ASC) ,
  INDEX `fk_cheque_cliente_cliente1_idx` (`cliente_cedulacliente` ASC) ,
  INDEX `fk_cheque_cliente_tipodepago1_idx` (`tipodepago_idtipodepago` ASC) ,
  INDEX `fk_cheque_cliente_usuario1_idx` (`usuario_nombreusuario` ASC) ,
  CONSTRAINT `fk_cheque_cliente_cheque1`
    FOREIGN KEY (`cheque_idcheque` )
    REFERENCES `datosdatos`.`cheque` (`idcheque` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_cheque_cliente_cliente1`
    FOREIGN KEY (`cliente_cedulacliente` )
    REFERENCES `datosdatos`.`cliente` (`cedulacliente` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_cheque_cliente_tipodepago1`
    FOREIGN KEY (`tipodepago_idtipodepago` )
    REFERENCES `datosdatos`.`tipodepago` (`idtipodepago` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_cheque_cliente_usuario1`
    FOREIGN KEY (`usuario_nombreusuario` )
    REFERENCES `datosdatos`.`usuario` (`nombreusuario` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

USE `datosdatos` ;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
