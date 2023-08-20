/*
ESTE SCRIPT CREA 3 TRIGGERS:
            01. tr_auditores_after_insert
            02. tr_administrativos_after_insert
            03. tr_medicos_after_insert
            

NOTA: CADA VEZ QUE SE INSERTE UN REGISTRO EN LA TABLA 'administrativos' O 'medicos' O 'auditores',
      SE CREARÁ AUTOMÁTICAMENTE UN NUEVO REGISTRO PARA LA TABLA 'usuarios_sistema' Y
      SE GENERARÁ AUTOMATICAMENTE UNA CLAVE DE INGRESO PARA CADA UNO DE ELLOS.
      CON ESTOS PARÁMETROS SE ESPERA PODER CONTROLAR EL NIVEL DE PERMISOS Y ACCESOS
      DENTRO DE LA BASE DE DATOS EN EL FUTURO.
*/


-- 01. Trigger para crear usuario  auditor
DELIMITER //
CREATE TRIGGER tr_auditores_after_insert
AFTER INSERT ON auditores
FOR EACH ROW
BEGIN
    INSERT INTO usuarios_sistema (username, pass, rol)
    VALUES (CONCAT(SUBSTRING_INDEX(NEW.correo_electronico, '@', 1),'@localhost'), SUBSTRING(MD5(RAND()), 1, 8), 'AUDITOR');
END;
//
DELIMITER ;



-- 02. Trigger para crear usuario administrativo
DELIMITER //
CREATE TRIGGER tr_administrativos_after_insert
AFTER INSERT ON administrativos
FOR EACH ROW
BEGIN
    INSERT INTO usuarios_sistema (username, pass, rol)
    VALUES (CONCAT(SUBSTRING_INDEX(NEW.correo_electronico, '@', 1),'@localhost'), SUBSTRING(MD5(RAND()), 1, 8), 'ADMINISTRATIVO');
END;



-- 03. Trigger para crear usuario médico
DELIMITER //
CREATE TRIGGER tr_medicos_after_insert
AFTER INSERT ON medicos
FOR EACH ROW
BEGIN
    INSERT INTO usuarios_sistema (username, pass, rol)
    VALUES (CONCAT(SUBSTRING_INDEX(NEW.correo_electronico, '@', 1),'@localhost'), SUBSTRING(MD5(RAND()), 1, 8), 'MEDICO');
END;
//
DELIMITER ;
