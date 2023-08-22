-- ESTE SCRIPT CREA Y PONE EN USO LA BASE DE DATOS 'GestionSaludDB'
CREATE DATABASE GestionSaludDB;
USE GestionSaludDB;


/* ESTE SCRIPT CREA 18 TABLAS VACÍAS:
  - TABLAS TRANSACCIONALES: 
    01. pacientes
    02. administrativos
    03. medicos
    04. auditores
    05. usuarios_sistema
    06. obras_sociales
    07. pacientes_telefonos
    08. administrativos_telefonos
    09. medicos_telefonos
    10. auditores_telefonos
    11. datos_obras_sociales
    12. citas_medicas
    13. historiales_medicos
    14. tarifas
    15. facturas
    16. recetas
    
  - TABLAS DE HECHO:
    17. rendimiento_medico
    18. ingresos_facturacion_mensual
*/

-- TABLAS PRINCIPALES (SIN FOREING KEY)

-- 1. pacientes
CREATE TABLE pacientes (
    id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    dni VARCHAR(10) UNIQUE NOT NULL,
    apellido VARCHAR(150) NOT NULL,
    nombre VARCHAR(150) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    domicilio VARCHAR(500),
    correo_electronico VARCHAR(100) NOT NULL,
    obra_social VARCHAR(100) DEFAULT 'PARTICULAR',
    rol VARCHAR(50) DEFAULT 'PACIENTE'
);

-- 2. administrativos
CREATE TABLE administrativos (
    id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    dni VARCHAR(10) UNIQUE NOT NULL,
    apellido VARCHAR(150) NOT NULL,
    nombre VARCHAR(150) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    domicilio VARCHAR(500),
    correo_electronico VARCHAR(100) NOT NULL,
    rol VARCHAR(50) DEFAULT 'ADMINISTRATIVO'
);

-- 3. medicos
CREATE TABLE medicos (
    id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    dni VARCHAR(10) UNIQUE NOT NULL,
    apellido VARCHAR(150) NOT NULL,
    nombre VARCHAR(150) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    domicilio VARCHAR(500),
    correo_electronico VARCHAR(100) NOT NULL,
    especialidad VARCHAR(100) NOT NULL,
    matricula VARCHAR(50) UNIQUE NOT NULL,
    rol VARCHAR(50) DEFAULT 'MEDICO'
);

-- 4. auditores
CREATE TABLE auditores (
    id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    dni VARCHAR(10) UNIQUE NOT NULL,
    apellido VARCHAR(150) NOT NULL,
    nombre VARCHAR(150) NOT NULL,
    correo_electronico VARCHAR(100) NOT NULL,
    puesto VARCHAR(150) NOT NULL,
    rol VARCHAR(50) DEFAULT 'AUDITOR'
);

-- 5. usuarios_sistema
CREATE TABLE usuarios_sistema (
    id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    username VARCHAR(100) NOT NULL UNIQUE,
    pass VARCHAR(12) NOT NULL,
    rol VARCHAR(50) NOT NULL
);

-- 6. obras_sociales
CREATE TABLE obras_sociales (
    id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    domicilio VARCHAR(500)
);

-- TABLAS SECUNDARIAS (CON FOREING KEY)

-- 7. pacientes_telefonos
CREATE TABLE pacientes_telefonos (
    id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    id_paciente INT,
    descripcion ENUM('CELULAR', 'FIJO') NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    notas_adicionales VARCHAR(100),
    FOREIGN KEY (id_paciente) REFERENCES pacientes(id)
);

-- 8. administrativos_telefonos
CREATE TABLE administrativos_telefonos (
    id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    id_administrativo INT,
    descripcion ENUM('CELULAR', 'FIJO') NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    notas_adicionales VARCHAR(100),
    FOREIGN KEY (id_administrativo) REFERENCES administrativos(id)
);

-- 9. medicos_telefonos
CREATE TABLE medicos_telefonos (
    id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    id_medico INT,
    descripcion ENUM('CELULAR', 'FIJO') NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    notas_adicionales VARCHAR(100),
    FOREIGN KEY (id_medico) REFERENCES medicos(id)
);

-- 10. auditores_telefonos
CREATE TABLE auditores_telefonos (
    id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    id_auditor INT,
    descripcion ENUM('CELULAR', 'FIJO') NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    notas_adicionales VARCHAR(100),
    FOREIGN KEY (id_auditor) REFERENCES auditores(id)
);

-- 11. datos_obras_sociales
CREATE TABLE datos_obras_sociales (
    id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    id_obra_social INT,
    telefono VARCHAR(20) NOT NULL,
    descripcion_telefono VARCHAR(20) NOT NULL,
    correo_electronico VARCHAR(100) NOT NULL,
    descripcion_correo_electronico VARCHAR(100) NOT NULL,
    notas_adicionales VARCHAR(100),
    FOREIGN KEY (id_obra_social) REFERENCES obras_sociales(id)
);


-- 12. citas_medicas
CREATE TABLE citas_medicas (
    id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    fecha_creacion_cita DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha DATE NOT NULL,
    hora TIME NOT NULL,
    estado ENUM('PENDIENTE', 'REALIZADA', 'CANCELADA') DEFAULT 'PENDIENTE',
    id_administrativo INT,
    id_medico INT,
    id_paciente INT,
    notas_adicionales VARCHAR(100),
    FOREIGN KEY (id_administrativo) REFERENCES administrativos(id),
    FOREIGN KEY (id_paciente) REFERENCES pacientes(id),
    FOREIGN KEY (id_medico) REFERENCES medicos(id)
);


-- 13. historiales_medicos
CREATE TABLE historiales_medicos (
    id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    id_paciente INT,
    id_medico INT NOT NULL,
    fecha_registro DATE NOT NULL,
    nota_medica VARCHAR(1000),
    FOREIGN KEY (id_paciente) REFERENCES pacientes(id),
    FOREIGN KEY (id_medico) REFERENCES medicos(id)
);


-- 14. tarifas
CREATE TABLE tarifas (
    id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    id_obra_social INT,
    tarifa_normal DECIMAL(10, 2) NOT NULL,
    tarifa_obra_social DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (id_obra_social) REFERENCES obras_sociales(id)
);


-- 15. facturas
CREATE TABLE facturas (
    id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    numero_factura VARCHAR(20) UNIQUE NOT NULL,
    fecha_emision DATE,
    id_paciente INT,
    id_medico INT,
    id_obra_social INT,
    total_factura DECIMAL(10, 2) NOT NULL,
    descripcion VARCHAR(255),
    estado ENUM('PENDIENTE', 'PAGADA', 'VENCIDA') NOT NULL,
    fecha_vencimiento DATE,
    metodo_pago VARCHAR(50),
    FOREIGN KEY (id_paciente) REFERENCES pacientes(id),
    FOREIGN KEY (id_medico) REFERENCES medicos(id),
    FOREIGN KEY (id_obra_social) REFERENCES obras_sociales(id)
);


-- 16. recetas
CREATE TABLE recetas (
    id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    id_obra_social INT,
    id_paciente INT,
    id_medico INT,
    fecha_emision DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    medicamento_recetado VARCHAR(100),
    notas_adicionales VARCHAR(100),
    FOREIGN KEY (id_obra_social) REFERENCES obras_sociales(id),
    FOREIGN KEY (id_paciente) REFERENCES pacientes(id),
    FOREIGN KEY (id_medico) REFERENCES medicos(id)
);


-- 17. rendimiento_medico
CREATE TABLE rendimiento_medico (
    id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    id_medico INT,
    medico_fullname VARCHAR(300),
    total_ingreso_generado DECIMAL(10, 2),
    FOREIGN KEY (id_medico) REFERENCES medicos(id)    
);


-- 18.  ingresos_facturacion_mensual
CREATE TABLE ingresos_facturacion_mensual (
    id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    mes_facturado VARCHAR(12),
    total_ingreso DECIMAL(10, 2)
);


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



/*
ESTE SCRIPT CREA 8 STORED PROCEDURES:
        01. sp_grant_administrativo_permissions
        02. sp_grant_auditor_permissions
        03. sp_grant_medico_permissions
        04. sp_insertar_paciente
        05. sp_insertar_citas
        06. sp_citas_pendientes_paciente_dni
        07. sp_recetas_por_paciente_dni
        08. sp_facturas_por_paciente_dni
        09. sp_rendimiento_medico
        10. sp_ingresos_facturacion_mensual
*/


-- 01. sp_grant_administrativo_permissions: OTORGA PERMISOS A ADMINISTRATIVOS
DELIMITER //
CREATE PROCEDURE sp_grant_administrativo_permissions(username VARCHAR(100))
BEGIN
    SET @sql = CONCAT('GRANT SELECT, INSERT, UPDATE ON GestionSaludDB.* TO ''', username, '''');
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END;


-- 02. sp_grant_auditor_permissions: OTORGA PERMISOS A AUDITORES
CREATE PROCEDURE sp_grant_auditor_permissions(username VARCHAR(100))
BEGIN
    SET @sql = CONCAT('GRANT ALL PRIVILEGES ON GestionSaludDB.* TO ''', username, '''');
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END;


-- 03. sp_grant_medico_permissions: OTORGA PERMISOS A MÉDICOS
CREATE PROCEDURE sp_grant_medico_permissions(username VARCHAR(100))
BEGIN
    SET @sql = CONCAT(
        'GRANT SELECT, INSERT ON GestionSaludDB.historiales_medicos TO ''', username, '''; ',
        'GRANT SELECT, INSERT ON GestionSaludDB.recetas TO ''', username, '''; ',
        'GRANT SELECT ON GestionSaludDB.pacientes TO ''', username, '''; ',
        'GRANT SELECT ON GestionSaludDB.obras_sociales TO ''', username, '''; ',
        'GRANT SELECT ON GestionSaludDB.tarifas TO ''', username, '''; ',
        'GRANT SELECT ON GestionSaludDB.citas_medicas TO ''', username, '''; ',
        'GRANT SELECT ON GestionSaludDB.horarios_medicos TO ''', username, ''''
    );
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END;
//
DELIMITER ;




-- 04. sp_insertar_paciente: INSERTA UN NUEVO PACIENTE, OBTENIENDO LOS PARÁMETROS NECESARIOS
-- NOTA: VALIDA SI LOS PARÁMETROS INGRESADOS SON CORRECTOS
DELIMITER $$
CREATE PROCEDURE sp_insertar_paciente (
    in p_dni VARCHAR(10), 
    in p_apellido VARCHAR(150), 
    in p_nombre VARCHAR(150), 
    in p_fecha_nacimiento DATE, 
    in p_domicilio VARCHAR(500), 
    in p_correo_electronico VARCHAR(100),
    in p_obra_social VARCHAR(100),
    in p_rol VARCHAR(50)
)
BEGIN
    IF p_dni <> '' AND p_nombre <> '' AND p_apellido <> '' AND p_fecha_nacimiento IS NOT NULL AND p_domicilio <> '' AND p_correo_electronico <> '' THEN
        INSERT INTO pacientes (dni, nombre, apellido, fecha_nacimiento, domicilio, correo_electronico, obra_social, rol) 
        VALUES (p_dni, p_nombre, p_apellido, p_fecha_nacimiento, p_domicilio, p_correo_electronico, p_obra_social, p_rol);
        SELECT * FROM pacientes WHERE dni = p_dni;
    ELSE
        SELECT 'ERROR: Ningún campo puede estar vacío';
    END IF;
END
$$
DELIMITER ;
-- DESCOMENTAR Y EJECUTAR LA SIGUIENTE LÍNEA PARA PROBAR
-- CALL sp_insertar_paciente(32156000, 'BERNABEU', 'SANTIAGO', '2018-12-09', 'Av. de Concha Espina, 1, 28036 Madrid, España', 'santibernabeu@final.com', 'PARTICULAR', 'paciente');




-- 05. sp_insertar_citas: Inserta una nueva cita, obteniendo los parámetros necesarios
-- NOTA: valida si los parámetros ingresados son correctos
DELIMITER $$
CREATE PROCEDURE sp_insertar_citas (
    in p_fecha DATE, 
    in p_hora TIME,
    in p_id_administrativo INT, 
    in p_id_medico INT, 
    in p_id_paciente INT
)
BEGIN
    DECLARE paciente_existente INT;
    
    SELECT COUNT(id) INTO paciente_existente FROM pacientes WHERE id = p_id_paciente;
    
    IF paciente_existente > 0 THEN
        INSERT INTO citas_medicas (fecha, hora, id_administrativo, id_medico, id_paciente)
        VALUES (p_fecha, p_hora, p_id_administrativo, p_id_medico, p_id_paciente);
        
        SELECT id, fecha, estado, id_administrativo, id_medico, id_paciente 
        FROM citas_medicas 
        WHERE id_paciente = p_id_paciente 
        ORDER BY fecha DESC;
    ELSE
        SELECT 'ERROR: El paciente no existe, debe crearlo primero';
    END IF;
END
$$
DELIMITER ;
-- DESCOMENTAR Y EJECUTAR LA SIGUIENTE LÍNEA PARA PROBAR (REEMPLAZAR LOS CAMPOS CON LOS DATOS CORRESPONDIENTES)
-- CALL sp_insertar_citas('2023-09-12','10:30', 7, 30, 90);




-- 06. sp_citas_pendientes_paciente_dni: BUSCA CITAS PENDIENTES PARA EL PACIENTE ESPECIFICADO (RECIBE DNI DEL PACIENTE POR PARÁMETRO)
-- SI NO ENCUENTRA CITA, REGRESA EL MENSAJE CORRESPONDIENTE
DELIMITER //
CREATE PROCEDURE sp_citas_pendientes_paciente_dni(IN dni_paciente VARCHAR(10))
BEGIN
    DECLARE citas_count INT;
    
    SELECT COUNT(*) INTO citas_count
    FROM citas_medicas cm
    JOIN pacientes p ON cm.id_paciente = p.id
    WHERE p.dni = dni_paciente AND cm.estado = 'pendiente';

    IF citas_count > 0 THEN
        SELECT cm.id, cm.fecha, cm.hora, cm.estado,
               CONCAT(p.apellido, ' ', p.nombre) AS paciente,
               CONCAT(m.apellido, ' ', m.nombre) AS medico
        FROM citas_medicas cm
        JOIN pacientes p ON cm.id_paciente = p.id
        JOIN medicos m ON cm.id_medico = m.id
        WHERE p.dni = dni_paciente AND cm.estado = 'pendiente';
    ELSE
        SELECT 'NINGUNA CITA ENCONTRADA' AS mensaje;
    END IF;
END;
//
DELIMITER ;
-- DESCOMENTAR Y EJECUTAR LA SIGUIENTE LÍNEA PARA OBTENER 'sp_citas_pendientes_paciente_dni' (INTRODUCIR UN DNI)
-- CALL sp_citas_pendientes_paciente_dni('15678901');




-- 07. sp_recetas_por_paciente_dni: BUSCA RECETAS VINCULADAS CON EL PACIENTE ESPECIFICADO (RECIBE DNI DEL PACIENTE POR PARÁMETRO)
-- SI NO ENCUENTRA NINGUNA RECETA, REGRESA EL MENSAJE CORRESPONDIENTE
DELIMITER //
CREATE PROCEDURE sp_recetas_por_paciente_dni(IN dni_paciente VARCHAR(10))
BEGIN
    DECLARE recetas_count INT;
    
    SELECT COUNT(*) INTO recetas_count
    FROM recetas r
    JOIN pacientes p ON r.id_paciente = p.id
    WHERE p.dni = dni_paciente;

    IF recetas_count > 0 THEN
        SELECT r.id, r.fecha_emision, r.medicamento_recetado, r.notas_adicionales,
               CONCAT(p.apellido, ' ', p.nombre) AS paciente,
               CONCAT(m.apellido, ' ', m.nombre) AS medico
        FROM recetas r
        JOIN pacientes p ON r.id_paciente = p.id
        JOIN medicos m ON r.id_medico = m.id
        WHERE p.dni = dni_paciente;
    ELSE
        SELECT 'NINGUNA RECETA ENCONTRADA' AS mensaje;
    END IF;
END;
//
DELIMITER ;
-- DESCOMENTAR Y EJECUTAR LA SIGUIENTE LÍNEA PARA OBTENER 'sp_recetas_por_paciente_dni' (INTRODUCIR UN DNI)
-- CALL sp_recetas_por_paciente_dni('15678901');





-- 08. sp_facturas_por_paciente_dni: BUSCA FACTURAS VINCULADAS CON EL PACIENTE ESPECIFICADO (RECIBE DNI DEL PACIENTE POR PARÁMETRO)
-- SI NO ENCUENTRA NINGUNA FACTURA, REGRESA EL MENSAJE CORRESPONDIENTE
DELIMITER //
CREATE PROCEDURE sp_facturas_por_paciente_dni(IN dni_paciente VARCHAR(10))
BEGIN
    DECLARE facturas_count INT;
    
    SELECT COUNT(*) INTO facturas_count
    FROM facturas f
    JOIN pacientes p ON f.id_paciente = p.id
    WHERE p.dni = dni_paciente;

    IF facturas_count > 0 THEN
        SELECT f.id, f.numero_factura, f.fecha_emision, f.total_factura, f.estado,
               CONCAT(p.apellido, ' ', p.nombre) AS paciente,
               CONCAT(m.apellido, ' ', m.nombre) AS medico,
               os.nombre AS obra_social
        FROM facturas f
        JOIN pacientes p ON f.id_paciente = p.id
        JOIN medicos m ON f.id_medico = m.id
        LEFT JOIN obras_sociales os ON f.id_obra_social = os.id
        WHERE p.dni = dni_paciente;
    ELSE
        SELECT 'NINGUNA FACTURA ENCONTRADA' AS mensaje;
    END IF;
END;
//
DELIMITER ;
-- DESCOMENTAR Y EJECUTAR LA SIGUIENTE LÍNEA PARA OBTENER 'sp_facturas_por_paciente_dni' (INTRODUCIR UN DNI)
-- CALL sp_facturas_por_paciente_dni('11678901');


/*
	ESTE SCRIPT:
    - CREA UN STORED PROCEDURE QUE CALCULA EL TOTAL DE INGRESOS GENERADOS, DE CADA MEDICO
      Y LO ORDENA DESDE EL QUE MÁS INGRESOS GENERÓ AL QUE MENOS GENERÓ, INSERTANDO DATOS EN LA TABLA 'rendimiento_medico'
	*/
DELIMITER //
CREATE PROCEDURE sp_rendimiento_medico()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE cursor_medico INT;
    DECLARE fullname VARCHAR(300);
    DECLARE cur CURSOR FOR
        SELECT id, CONCAT(apellido, ' ', nombre) AS medico_fullname
        FROM medicos;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO cursor_medico, fullname;
        IF done THEN
            LEAVE read_loop;
        END IF;

        SET @total = (
            SELECT COALESCE(SUM(total_factura), 0)
            FROM facturas
            WHERE id_medico = cursor_medico
        );

        INSERT INTO rendimiento_medico (id_medico, medico_fullname, total_ingreso_generado)
        VALUES (cursor_medico, fullname, @total)
        ON DUPLICATE KEY UPDATE total_ingreso_generado = @total;

    END LOOP;

    CLOSE cur;
END;
//
DELIMITER ;
CALL sp_rendimiento_medico();
-- SELECT * FROM rendimiento_medico ORDER BY total_ingreso_generado DESC;




/*
ESTE SCRIPT GENERA UN STORED PROCEDURE PARA CALCULAR UTILIZANDO LA TABLA 'facturas',
EL TOTAL DE INGRESOS GENERADOS MENSUALMENTE Y LOS INTRODUCE EN LA TABLA 'ingresos_facturacion_mensual'
*/ 
DELIMITER //
CREATE PROCEDURE sp_ingresos_facturacion_mensual()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE total DECIMAL(10, 2);
    DECLARE cursor_month DATE;
    DECLARE cur CURSOR FOR
        SELECT DISTINCT DATE_FORMAT(fecha_emision, '%Y-%m-01') AS cursor_month
        FROM facturas;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO cursor_month;
        IF done THEN
            LEAVE read_loop;
        END IF;

        SET total = (
            SELECT COALESCE(SUM(total_factura), 0)
            FROM facturas
            WHERE fecha_emision BETWEEN cursor_month AND LAST_DAY(cursor_month)
        );

        INSERT INTO ingresos_facturacion_mensual (mes_facturado, total_ingreso)
        VALUES (DATE_FORMAT(cursor_month, '%Y-%m'), total)
        ON DUPLICATE KEY UPDATE total_ingreso = total;

    END LOOP;
    CLOSE cur;
END;
//
DELIMITER ;
CALL sp_ingresos_facturacion_mensual();
-- SELECT * FROM ingresos_facturacion_mensual ORDER BY mes_facturado;



/* ESTE SCRIPT CREA 13 VISTAS:
                01. vw_citas_pendientes
                02. vw_facturas_paciente_obra_social
                03. vw_recetas
                04. vw_historial_medico
                05. vw_facturas_pendientes
                06. vw_ingreso_mensual_obras_sociales
                07. vw_ingreso_total_obras_sociales
                08. vw_pacientes_con_cobertura
                09. vw_pacientes_sin_cobertura
                10. vw_info_pacientes
                11. vw_info_administrativos
                12. vw_info_medicos
*/


-- 01. 'vw_citas_pendientes': MUESTRA LAS CITAS PENDIENTES PARA CADA MÉDICO, INLUYENDO DETALLES DEL PACIENTE Y ADMINISTRATIVO
CREATE VIEW vw_citas_pendientes AS
SELECT c.id AS cita_id, c.fecha, c.hora, CONCAT(m.apellido,' ', m.nombre) AS medico, CONCAT(p.apellido,' ',p.nombre) AS paciente, CONCAT(a.apellido,' ', a.nombre) AS administrativo
FROM citas_medicas c
JOIN medicos m ON c.id_medico = m.id
JOIN pacientes p ON c.id_paciente = p.id
JOIN administrativos a ON c.id_administrativo = a.id
WHERE c.estado = 'PENDIENTE'
ORDER BY fecha;
-- DESCOMENTAR Y EJECUTAR LA SIGUIENTE LÍNEA PARA VISUALIZAR LA VIEW 'vw_citas_pendientes'
-- SELECT * FROM vw_citas_pendientes;
 

-- 02. 'vw_facturas_paciente_obra_social': MUESTRA LAS FACTURAS PENDIENTES DE PAGO PARA LOS PACIENTES
 CREATE VIEW vw_facturas_paciente_obra_social AS
SELECT f.numero_factura, f.fecha_emision, f.total_factura,
      CONCAT(p.apellido,' ',p.nombre) AS paciente,
       os.nombre AS nombre_obra_social
FROM facturas f
JOIN pacientes p ON f.id_paciente = p.id
LEFT JOIN obras_sociales os ON f.id_obra_social = os.id;
-- DESCOMENTAR Y EJECUTAR LA SIGUIENTE LÍNEA PARA VISUALIZAR LA VIEW 'vw_facturas_paciente_obra_social'
-- SELECT * FROM vw_facturas_paciente_obra_social;
 

-- 03. 'vw_recetas': MUESTRA RESUMEN DE LAS RECETAS (FECHA DE EMISIÓN, MEDICAMENTO RECETADO, PACIENTE, MÉDICO)
CREATE VIEW vw_recetas AS
SELECT r.fecha_emision, r.medicamento_recetado,
        CONCAT(p.apellido, ' ', p.nombre) AS paciente,
       CONCAT(m.apellido, ' ', m.nombre) AS medico
FROM recetas r
JOIN pacientes p ON r.id_paciente = p.id
JOIN medicos m ON r.id_medico = m.id;
-- DESCOMENTAR Y EJECUTAR LA SIGUIENTE LÍNEA PARA VISUALIZAR LA VIEW 'vw_recetas'
-- SELECT * FROM vw_recetas; 

 
-- 04. 'vw_historial_medico': 
CREATE VIEW vw_historial_medico AS
SELECT hm.fecha_registro, hm.nota_medica,
       CONCAT(p.apellido, ' ', p.nombre) AS paciente,
       CONCAT(m.apellido, ' ', m.nombre) AS medico
FROM historiales_medicos hm
JOIN pacientes p ON hm.id_paciente = p.id
JOIN medicos m ON hm.id_medico = m.id
ORDER BY paciente;
-- DESCOMENTAR Y EJECUTAR LA SIGUIENTE LÍNEA PARA VISUALIZAR LA VIEW 'vw_historial_medico'
-- SELECT * FROM vw_historial_medico;


-- 05. 'vw_facturas_pendientes': MUESTRA
CREATE VIEW vw_facturas_pendientes AS
SELECT f.id AS factura_id, f.numero_factura, f.fecha_emision,
      CONCAT(p.apellido,'', p.nombre) AS paciente, f.total_factura, f.fecha_vencimiento
FROM facturas f
JOIN pacientes p ON f.id_paciente = p.id
WHERE f.estado = 'PENDIENTE'
ORDER BY fecha_vencimiento;
-- DESCOMENTAR Y EJECUTAR LA SIGUIENTE LÍNEA PARA VISUALIZAR LA VIEW 'vw_facturas_pendientes'
-- SELECT * FROM vw_facturas_pendientes;


-- 06. 'vw_ingreso_mensual_obras_sociales': MUESTRA EL INGRESO GENERADO POR CADA OBRA SOCIAL MES A MES
CREATE VIEW vw_ingreso_mensual_obras_sociales AS
SELECT os.nombre AS obra_social,
       DATE_FORMAT(fecha_emision, '%Y-%m') AS mes_facturado,
       SUM(total_factura) AS total_facturado
FROM facturas f
JOIN obras_sociales os ON f.id_obra_social = os.id
GROUP BY os.nombre, mes_facturado
ORDER BY os.nombre;
-- DESCOMENTAR Y EJECUTAR LA SIGUIENTE LÍNEA PARA VISUALIZAR LA VIEW 'vw_ingreso_mensual_obras_sociales'
-- SELECT * FROM vw_ingreso_mensual_obras_sociales;


-- 07. 'vw_ingreso_total_obras_sociales': MUESTRA EL INGRESO GENERADO POR CADA OBRA SOCIAL EN TOTAL
CREATE VIEW vw_ingreso_total_obras_sociales AS
SELECT os.nombre AS obra_social,
       SUM(f.total_factura) AS total_facturado
FROM facturas f
JOIN obras_sociales os ON f.id_obra_social = os.id
GROUP BY os.nombre
ORDER BY os.nombre;
-- DESCOMENTAR Y EJECUTAR LA SIGUIENTE LÍNEA PARA VISUALIZAR LA VIEW 'vw_ingreso_total_obras_sociales
-- SELECT * FROM vw_ingreso_total_obras_sociales;



-- 08. 'vw_pacientes_con_cobertura': 
CREATE VIEW vw_pacientes_con_cobertura AS
SELECT CONCAT(p.apellido,' ', p.nombre) AS paciente, p.dni, obra_social
FROM pacientes p
WHERE p.obra_social <> 'PARTICULAR'
ORDER BY paciente;
-- DESCOMENTAR Y EJECUTAR LA SIGUIENTE LÍNEA PARA VISUALIZAR LA VIEW 'vw_pacientes_con_cobertura'
-- SELECT * FROM vw_pacientes_con_cobertura;


-- 09. 'vw_pacientes_sin_cobertura': 
CREATE VIEW vw_pacientes_sin_cobertura AS
SELECT CONCAT(p.apellido,' ', p.nombre) AS paciente, p.dni ,obra_social
FROM pacientes p
WHERE p.obra_social = 'PARTICULAR';
-- DESCOMENTAR Y EJECUTAR LA SIGUIENTE LÍNEA PARA VISUALIZAR LA VIEW 'vw_pacientes_con_cobertura'
-- SELECT * FROM vw_pacientes_sin_cobertura;


-- 10. 'vw_info_pacientes': MUESTRA RÁPIDAMENTE LA LISTA DE PACIENTES Y SUS DATOS
CREATE VIEW vw_info_pacientes AS
SELECT CONCAT(p.apellido,' ', p.nombre) AS paciente,
      p.obra_social,
      pt.descripcion AS tipo_telefono,
      pt.telefono,                    
      p.correo_electronico,
      p.domicilio
FROM pacientes p
JOIN pacientes_telefonos pt ON p.id = pt.id_paciente;
-- DESCOMENTAR Y EJECUTAR LA SIGUIENTE LÍNEA PARA VISUALIZAR LA VIEW 'vw_info_pacientes'
-- SELECT * FROM vw_info_pacientes;


-- 11. 'vw_info_administrativos': MUESTRA RÁPIDAMENTE LA LISTA DE ADMINSITRATIVOS Y SUS DATOS
CREATE VIEW vw_info_administrativos AS
SELECT CONCAT(a.apellido,' ', a.nombre) AS administrativo,
      t.descripcion AS tipo_telefono,
      t.telefono,
      correo_electronico,
      domicilio
      FROM administrativos a
      JOIN administrativos_telefonos t ON a.id = t.id_administrativo;
-- DESCOMENTAR Y EJECUTAR LA SIGUIENTE LÍNEA PARA VISUALIZAR LA VIEW 'vw_info_administrativos'
-- SELECT * FROM vw_info_administrativos;

-- 12. 'vw_info_medicos': MUESTRA RÁPIDAMENTE LA LISTA DE MÉDICOS Y SUS DATOS
CREATE VIEW vw_info_medicos AS
SELECT CONCAT(m.apellido,' ', m.nombre) AS medico,
      mt.descripcion AS tipo_telefono,
      mt.telefono,
      m.correo_electronico,
      m.domicilio,
      m.especialidad,
      m.matricula
FROM medicos m
JOIN medicos_telefonos mt ON m.id = mt.id_medico;
-- DESCOMENTAR Y EJECUTAR LA SIGUIENTE LÍNEA PARA VISUALIZAR LA VIEW 'vw_info_medicos'
-- SELECT * FROM vw_info_medicos;


/*
ESTE SCRIPT CREA 3 FUNCIONES:
            01. fn_cantidad_citas_realizadas_por_medico
            02. fn_cantidad_citas_canceladas_por_medico
            03. fn_cantidad_citas_pendientes_por_medico
 */

-- fn_cantidad_citas_realizadas_por_medico: CUENTA EL TOTAL DE CITAS QUE TIENE REALIZADAS CADA MÉDICO, RECIBIENDO COMO PARÁMETRO SU ID
DELIMITER $$
CREATE FUNCTION `fn_cantidad_citas_realizadas_por_medico`(id_medico INT)
RETURNS INT
NO SQL
BEGIN
      DECLARE resultado INT;
    	SET resultado =
        (SELECT count(*)
        FROM citas_medicas c
        WHERE c.id_medico = id_medico AND c.estado = 'REALIZADA');
      RETURN resultado;
END
$$
DELIMITER ;
-- DESCOMENTAR Y EJECUTAR LA SIGUIENTE LÍNEA PARA OBTENER RESULTADOS DE LA FUNCION 'fn_cantidad_citas_realizadas_por_medico' (DEBE PASAR ENTRE PARÉNTESIS EL ID DEL MÉDICO)
-- SELECT fn_cantidad_citas_realizadas_por_medico(16);



-- fn_cantidad_citas_canceladas_por_medico: CUENTA EL TOTAL DE CITAS CANCELADAS QUE TUVE/TIENE CADA MÉDICO, RECIBIENDO COMO PARÁMETRO EL ID DEL MÉDICO
DELIMITER $$
CREATE FUNCTION `fn_cantidad_citas_canceladas_por_medico`(id_medico INT)
RETURNS INT
NO SQL
BEGIN
      DECLARE resultado INT;
    	SET resultado =
        (SELECT count(*)
        FROM citas_medicas c
        WHERE c.id_medico = id_medico AND c.estado = 'CANCELADA');
      RETURN resultado;
END
$$
DELIMITER ;
-- DESCOMENTAR Y EJECUTAR LA SIGUIENTE LÍNEA PARA OBTENER RESULTADOS DE LA FUNCION 'fn_cantidad_citas_canceladas_por_medico' (DEBE PASAR ENTRE PARÉNTESIS EL ID DEL MÉDICO)
-- SELECT fn_cantidad_citas_canceladas_por_medico(5);


-- fn_cantidad_citas_pendientes_por_medico: CUENTA EL TOTAL DE CITAS QUE TIENE PENDIENTE CADA MÉDICO, RECIBIENDO POR PARÁMETRO EL ID DEL MÉDICO
DELIMITER $$
CREATE FUNCTION `fn_cantidad_citas_pendientes_por_medico`(id_medico INT)
RETURNS INT
NO SQL
BEGIN
      DECLARE resultado INT;
    	SET resultado =
        (SELECT count(*)
        FROM citas_medicas c
        WHERE c.id_medico = id_medico AND c.estado = 'PENDIENTE');
      RETURN resultado;
END
$$
DELIMITER ;
-- DESCOMENTAR Y EJECUTAR LA SIGUIENTE LÍNEA PARA OBTENER RESULTADOS DE LA FUNCION 'fn_cantidad_citas_pendientes_por_medico' (DEBE PASAR ENTRE PARÉNTESIS EL ID DEL MÉDICO)
-- SELECT fn_cantidad_citas_pendientes_por_medico(30);


/*
ESTE SCRIPT CREA USUARIOS DEL SISTEMA
*/

-- CAMBIA AL ESQUEMA POR DEFECTO DE MYSQL WORKBENCH PARA CREAR USERS
        USE mysql;

-- DESCOMENTAR Y EJECUTAR LA SIGUIENTE LÍNEA PARA CONSULTAR LISTA DE USUARIOS
-- SELECT * FROM user;


-- SI LOS USUARIOS 'auditor@localhost', 'administrativo@localhost', 'medico@localhost'
--  EXISTEN LOS ELIMINO PARA CREARLOS NUEVAMENTE CON LOS PERMISOS ADECUADOS
         DROP USER IF EXISTS 'auditor@localhost';
		 DROP USER IF EXISTS 'administrativo@localhost';
		 DROP USER IF EXISTS 'medico@localhost';

-- CREACIÓN DE 3 USUARIOS ''auditor', 'administrativo' y 'medico' CON LA CONTRASEÑA 'admin' PARA CADA UNO DE ELLOS
        CREATE USER 'auditor@localhost' IDENTIFIED BY 'admin';
        CREATE USER 'administrativo@localhost' IDENTIFIED BY 'admin';
        CREATE USER 'medico@localhost' IDENTIFIED BY 'admin';


-- PERMISOS PARA EL USUARIO 'auditor' (TODOS LOS PERMISOS)
        GRANT ALL PRIVILEGES ON GestionSaludDB.* TO 'auditor@localhost';


-- PERMISOS PARA EL USUARIO 'administrativo' (LECTURA, INSERCIÓN, MODIFICACIÓN SOBRE TODAS TABLA. ELIMINACION PARA NINGUNA)
        GRANT SELECT, INSERT, UPDATE ON GestionSaludDB.* TO 'administrativo@localhost';


-- PERMISOS PARA EL USUARIO 'medico' (LECTURA PARA ALGUNAS, LECTURA Y ESCRITURA PARA OTRAS, ELIMINACION PARA NINGUNA)
        GRANT SELECT, INSERT ON GestionSaludDB.historiales_medicos TO 'medico@localhost';
        GRANT SELECT, INSERT ON GestionSaludDB.recetas TO 'medico@localhost';
        GRANT SELECT ON GestionSaludDB.pacientes TO 'medico@localhost';
        GRANT SELECT ON GestionSaludDB.obras_sociales TO 'medico@localhost';
        GRANT SELECT ON GestionSaludDB.tarifas TO 'medico@localhost';
        GRANT SELECT ON GestionSaludDB.citas_medicas TO 'medico@localhost';
        

-- RETORNA AL USO DE LA BASE DE DATOS 'GestionSaludDB'
        USE GestionSaludDB;



/*
 ESTE SCRIPT CREA UNA TRANSACCIÓN CON DOS SAVEPOINT PARA
 INSERTAR DATOS EN LA TABLA 'pacientes' Y EN LA TABLA 'pacientes_telefonos':
 */
-- ES NECESARIO SETEAR EL AUTOCOMMIT EN 0 PARA PODER REALIZAR INSERCIONES/ELIMINACIONES
-- SELECT @@AUTOCOMMIT;
SET AUTOCOMMIT = 0;
-- INICIA LA TRANSACCIÓN
START TRANSACTION;
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (44769256, 'O'' Liddy', 'Gareth', '2009-09-01', '4454 Steensland Plaza', 'goliddy0@loc.gov', 'OSPEDYC (Obra Social de Entidades Deportivas y Civiles)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (54900113, 'Filipczak', 'Morissa', '1980-03-19', '78 Fieldstone Lane', 'mfilipczak1@comsenz.com', 'AMFFA (Asociación Mutual de los Ferroviarios Argentinos)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (22262837, 'Strephan', 'Norbert', '2001-09-06', '4638 Northridge Court', 'nstrephan2@google.co.uk', 'Galeno');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (36108368, 'Robson', 'Jessamyn', '2013-02-20', '0697 Southridge Park', 'jrobson3@theguardian.com', 'Obras Sociales Provinciales (varias según cada provincia)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (46932199, 'Frankham', 'Edyth', '1989-04-09', '2 Lotheville Road', 'efrankham4@skype.com', 'OSPJN (Obra Social del Poder Judicial de la Nación)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (13815315, 'Nesby', 'Averell', '1985-05-27', '4047 Dwight Alley', 'anesby5@google.es', 'Swiss Medical');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (34329957, 'McClelland', 'Jandy', '1994-08-23', '258 Spohn Pass', 'jmcclelland6@globo.com', 'UOM (Unión Obrera Metalúrgica)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (43629998, 'Spadotto', 'Eustace', '1996-01-14', '113 Independence Terrace', 'espadotto7@pbs.org', 'Obras Sociales Provinciales (varias según cada provincia)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (17604869, 'Trever', 'Randal', '1966-12-22', '626 Mifflin Place', 'rtrever8@marriott.com', 'IAPOS (Instituto Autárquico Provincial de Obra Social)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (16315838, 'Giovanardi', 'Abba', '2001-04-30', '2914 Boyd Drive', 'agiovanardi9@ted.com', 'OSECAC (Obra Social de Empleados de Comercio y Actividades Civiles)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (39527472, 'Caillou', 'Barbaraanne', '1978-12-27', '5 Mayfield Place', 'bcailloua@merriam-webster.com', 'AMP (Asociación Mutual del Personal de la Universidad Nacional de Tucumán)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (56731084, 'Wilding', 'Lorinda', '2002-11-11', '22210 Porter Parkway', 'lwildingb@delicious.com', 'OSPAT (Obra Social del Personal de la Actividad del Turf)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (38077059, 'Ivanovic', 'Averell', '1980-10-30', '80486 Cottonwood Place', 'aivanovicc@uol.com.br', 'OSPA (Obra Social del Personal de la Actividad Aseguradora)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (38045312, 'Conrad', 'Babara', '1978-02-24', '9436 Anderson Pass', 'bconradd@meetup.com', 'OSPAT (Obra Social del Personal de la Actividad del Turf)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (23468259, 'Caudrelier', 'Auberon', '1973-06-25', '43879 Vidon Point', 'acaudreliere@etsy.com', 'OSPAT (Obra Social del Personal de la Actividad del Turf)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (55991885, 'Westphal', 'Augustin', '1994-07-03', '40 Lunder Street', 'awestphalf@tripod.com', 'OSECAC (Obra Social de Empleados de Comercio y Actividades Civiles)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (28362954, 'Jacobovitz', 'Marcelle', '2012-12-07', '418 Melody Way', 'mjacobovitzg@acquirethisname.com', 'Obras Sociales Provinciales (varias según cada provincia)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (17766885, 'Castlake', 'Early', '2009-05-26', '6083 Menomonie Avenue', 'ecastlakeh@surveymonkey.com', 'OSMATA (Obra Social del Personal de la Industria Azucarera)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (40658197, 'McNeill', 'Dorise', '2006-04-01', '87 Lerdahl Lane', 'dmcneilli@webmd.com', 'OSPRERA (Obra Social de los Empleados de la República Argentina)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (42097553, 'Nagle', 'Kiersten', '1989-10-02', '6538 Reindahl Crossing', 'knaglej@kickstarter.com', 'OSFFENTOS (Obra Social Ferroviaria de Fomento)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (12053185, 'Kelloway', 'Betta', '2005-07-18', '6764 Eggendart Park', 'bkellowayk@nsw.gov.au', 'SADAIC (Sociedad Argentina de Autores y Compositores de Música)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (44601418, 'Rait', 'Bartlett', '1984-08-16', '82576 Manley Place', 'braitl@paypal.com', 'OSPATCA (Obra Social del Personal Auxiliar de Casas Particulares)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (26186630, 'Scard', 'Lutero', '1985-01-07', '4063 Canary Court', 'lscardm@pinterest.com', 'PARTICULAR');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (16353985, 'Jones', 'Gerik', '2009-09-02', '0476 Ohio Pass', 'gjonesn@globo.com', 'OSPRERA (Obra Social de los Empleados de la República Argentina)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (49174717, 'Vigar', 'Jenda', '1972-12-30', '278 Schurz Place', 'jvigaro@gnu.org', 'OSDE');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (38702849, 'Hrus', 'Merrili', '1966-08-01', '1 Esker Circle', 'mhrusp@weebly.com', 'OSPATCA (Obra Social del Personal Auxiliar de Casas Particulares)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (55129657, 'Crawley', 'Oswald', '1975-10-03', '59977 Hooker Court', 'ocrawleyq@slashdot.org', 'Sancor Salud');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (25472099, 'Ivetts', 'Zondra', '2007-04-25', '7 Mcbride Road', 'zivettsr@w3.org', 'IAPS (Instituto de Asistencia Social del Neuquén)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (23705804, 'Dohmer', 'Barney', '2009-11-27', '1443 Oakridge Lane', 'bdohmers@google.cn', 'OSPA (Obra Social del Personal de la Actividad Aseguradora)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (29613896, 'Kalker', 'Ranna', '1979-11-06', '53813 Shopko Road', 'rkalkert@cdc.gov', 'Swiss Medical');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (37855479, 'Sedger', 'Andrej', '1969-08-24', '460 Del Sol Hill', 'asedgeru@aboutads.info', 'Obra Social Bancaria Argentina');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (47566519, 'Dargavel', 'Waylan', '1998-05-15', '231 Crowley Court', 'wdargavelv@indiatimes.com', 'IAPS (Instituto de Asistencia Social del Neuquén)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (24564019, 'Seifert', 'Huey', '1968-10-31', '040 Carberry Junction', 'hseifertw@goo.ne.jp', 'OSEF (Obra Social del Estado Fueguino)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (37846605, 'Hards', 'Jared', '1964-06-02', '4486 Westridge Way', 'jhardsx@google.es', 'OSMATA (Obra Social del Personal de la Actividad del Turf)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (26861763, 'Haggett', 'Anabella', '2007-02-06', '4678 Lawn Hill', 'ahaggetty@salon.com', 'PARTICULAR');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (23960440, 'Crippill', 'Bertrand', '1983-02-26', '639 Rigney Park', 'bcrippillz@twitpic.com', 'OSPA (Obra Social del Personal de la Actividad Aseguradora)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (20279900, 'Thomson', 'Tyrone', '1977-09-02', '4285 Spohn Avenue', 'tthomson10@nba.com', 'DASPU (Dirección de Asistencia Social del Personal Universitario)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (25401313, 'Fossey', 'Nerta', '1977-12-14', '651 Redwing Trail', 'nfossey11@prnewswire.com', 'AMEPA (Asociación Mutual de Empleados del Poder Judicial)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (14599923, 'Bengtsson', 'Griselda', '1981-10-09', '68856 Thierer Point', 'gbengtsson12@howstuffworks.com', 'OSPJN (Obra Social del Poder Judicial de la Nación)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (52338872, 'Reis', 'Selene', '2011-07-24', '39369 Riverside Trail', 'sreis13@dailymotion.com', 'Caja de Servicios Sociales de la Universidad Nacional del Sur');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (48296919, 'Rickman', 'Herculie', '2000-03-16', '20 Clove Junction', 'hrickman14@oaic.gov.au', 'PAMI (Programa de Atención Médica Integral)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (18019866, 'Broker', 'Olivette', '2001-10-05', '384 Graceland Point', 'obroker15@cyberchimps.com', 'OSFFENTOS (Obra Social Ferroviaria de Fomento)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (44686064, 'Woodington', 'Normand', '1983-05-27', '744 Scofield Plaza', 'nwoodington16@home.pl', 'Caja de Servicios Sociales de la Universidad Nacional del Sur');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (28540169, 'Vertey', 'Carlos', '1969-10-04', '11 Towne Avenue', 'cvertey17@google.es', 'Obras Sociales Provinciales (varias según cada provincia)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (20058468, 'Vedenyakin', 'Karim', '1992-06-10', '4 Anhalt Terrace', 'kvedenyakin18@dailymotion.com', 'Caja de Servicios Sociales de la Universidad Nacional del Sur');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (44039429, 'Duffree', 'Aggie', '1981-05-27', '72 Sauthoff Place', 'aduffree19@intel.com', 'OSMATA (Obra Social del Personal de la Industria Azucarera)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (18067225, 'Konert', 'Brandtr', '2009-04-28', '9 Porter Point', 'bkonert1a@pbs.org', 'OSPEDYC (Obra Social de Entidades Deportivas y Civiles)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (32945781, 'Burnyeat', 'Vania', '1974-06-12', '178 Transport Alley', 'vburnyeat1b@live.com', 'IOMA (Instituto de Obra Médico Asistencial)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (49801418, 'Trumble', 'Lela', '1960-03-05', '8448 Lakewood Gardens Avenue', 'ltrumble1c@sciencedirect.com', 'AMEPA (Asociación Mutual de Empleados del Poder Judicial)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (37982781, 'Dougan', 'Jarred', '2003-01-14', '3417 Springs Hill', 'jdougan1d@cisco.com', 'IAPS (Instituto de Asistencia Social del Neuquén)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (45557392, 'Whitear', 'Erick', '2015-03-31', '55 Village Green Alley', 'ewhitear1e@aol.com', 'OSFFENTOS (Obra Social Ferroviaria de Fomento)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (14883599, 'Pilsworth', 'Rockie', '1982-07-12', '63377 Starling Alley', 'rpilsworth1f@amazonaws.com', 'Obra Social Bancaria Argentina');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (13974325, 'Priter', 'Had', '1962-10-23', '0187 Gina Drive', 'hpriter1g@w3.org', 'PAMI (Programa de Atención Médica Integral)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (54298760, 'Deaconson', 'Constance', '1961-07-26', '3 Esch Way', 'cdeaconson1h@census.gov', 'OSPEDYC (Obra Social de Entidades Deportivas y Civiles)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (42412540, 'Castanaga', 'Ax', '1998-10-07', '3 Graceland Pass', 'acastanaga1i@shareasale.com', 'OSPA (Obra Social del Personal de la Actividad Aseguradora)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (24008103, 'Dancey', 'Aluin', '1980-10-20', '60982 Cardinal Terrace', 'adancey1j@theglobeandmail.com', 'UOCRA (Unión Obrera de la Construcción de la República Argentina)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (45355913, 'Kobpac', 'Jay', '2002-04-12', '16 Stoughton Lane', 'jkobpac1k@si.edu', 'OSMATA (Obra Social del Personal de la Industria Azucarera)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (53995776, 'Giovanni', 'Niccolo', '1973-02-12', '5 Mccormick Terrace', 'ngiovanni1l@google.ca', 'IAPOS (Instituto Autárquico Provincial de Obra Social)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (18853246, 'Greaterex', 'Edyth', '1975-03-14', '77681 Upham Way', 'egreaterex1m@adobe.com', 'Sancor Salud');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (26460831, 'Rusted', 'Faulkner', '2011-03-25', '12 Ramsey Parkway', 'frusted1n@geocities.jp', 'Medicus');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (14815123, 'Jan', 'Kirstyn', '1982-11-20', '1558 Lunder Court', 'kjan1o@wikispaces.com', 'OSPATCA (Obra Social del Personal Auxiliar de Casas Particulares)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (38071144, 'Filippello', 'John', '1990-05-06', '406 Amoth Point', 'jfilippello1p@disqus.com', 'Caja de Servicios Sociales de la Universidad Nacional del Sur');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (39272104, 'Cranmere', 'Gabriel', '1991-12-11', '7 1st Terrace', 'gcranmere1q@usa.gov', 'Sancor Salud');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (40139447, 'Gronou', 'Chauncey', '1998-10-19', '53 Crownhardt Point', 'cgronou1r@github.io', 'OSMATA (Obra Social del Personal de la Actividad del Turf)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (56403036, 'Tolussi', 'Worden', '1976-03-19', '84 Thackeray Center', 'wtolussi1s@about.com', 'PARTICULAR');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (20000424, 'Taill', 'Olga', '1972-04-06', '487 Sherman Junction', 'otaill1t@booking.com', 'Medicus');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (34190665, 'Penketh', 'Adelice', '1970-10-13', '3814 Schiller Plaza', 'apenketh1u@answers.com', 'OSPV (Obra Social de Petroleros y Gas Privado de la Patagonia Austral)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (41942886, 'Prys', 'Saxe', '1980-02-04', '81 Towne Lane', 'sprys1v@ifeng.com', 'OSPAT (Obra Social del Personal de la Actividad del Turf)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (25739404, 'Corran', 'Amandi', '1968-08-09', '31 Acker Court', 'acorran1w@youtu.be', 'Obras Sociales Provinciales (varias según cada provincia)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (29842859, 'Gilgryst', 'Nisse', '1986-06-19', '6 Bluejay Hill', 'ngilgryst1x@weather.com', 'IAPOS (Instituto Autárquico Provincial de Obra Social)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (32984941, 'Bortoloni', 'Karalee', '1970-08-07', '3891 Loomis Hill', 'kbortoloni1y@go.com', 'OSPATCA (Obra Social del Personal Auxiliar de Casas Particulares)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (22254182, 'Chomicki', 'Shirlee', '1987-09-02', '431 Dawn Parkway', 'schomicki1z@plala.or.jp', 'OSPAT (Obra Social del Personal de la Actividad del Turf)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (15653994, 'Rennels', 'Ross', '1999-11-17', '763 Esch Junction', 'rrennels20@live.com', 'Obra Social Bancaria Argentina');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (50604715, 'Swyn', 'Michel', '1979-09-18', '43 Sloan Alley', 'mswyn21@hibu.com', 'AMP (Asociación Mutual del Personal de la Universidad Nacional de Tucumán)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (26487835, 'Figin', 'Clay', '1969-03-24', '5357 Spenser Road', 'cfigin22@slate.com', 'UOM (Unión Obrera Metalúrgica)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (51663994, 'Kenrick', 'Wendye', '1966-07-05', '8502 Bayside Crossing', 'wkenrick23@aboutads.info', 'Sancor Salud');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (23389370, 'Storrock', 'Deerdre', '2012-06-27', '3832 Sutteridge Place', 'dstorrock24@exblog.jp', 'Medicus');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (17931042, 'Witchard', 'Kore', '1963-09-19', '2 Bunker Hill Place', 'kwitchard25@howstuffworks.com', 'OSPATCA (Obra Social del Personal Auxiliar de Casas Particulares)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (55989961, 'Pavy', 'Dana', '1966-03-20', '51489 Lake View Street', 'dpavy26@imageshack.us', 'Medicus');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (43968764, 'Robbey', 'Asher', '1983-03-11', '246 Stone Corner Junction', 'arobbey27@cornell.edu', 'IAPS (Instituto de Asistencia Social del Neuquén)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (36796119, 'Kiff', 'Dorian', '1995-12-03', '77 Golf View Place', 'dkiff28@storify.com', 'AMEPA (Asociación Mutual de Empleados del Poder Judicial)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (46647824, 'Housbey', 'Hendrick', '1997-11-06', '6 Redwing Avenue', 'hhousbey29@github.io', 'Obra Social de la Universidad Nacional de Córdoba');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (42689413, 'Errigo', 'Vin', '2003-03-30', '8931 Straubel Terrace', 'verrigo2a@ning.com', 'Caja de Servicios Sociales de la Universidad Nacional del Sur');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (33704770, 'Tuffley', 'Nicola', '1996-01-23', '7 Hollow Ridge Junction', 'ntuffley2b@rediff.com', 'UPCN (Unión del Personal Civil de la Nación)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (37014801, 'Colman', 'Karleen', '1972-11-28', '506 Oneill Place', 'kcolman2c@reference.com', 'Accord Salud');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (19928102, 'Dalli', 'Anthony', '1987-02-01', '9030 Barby Pass', 'adalli2d@cbc.ca', 'Medicus');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (14010176, 'Rowcliffe', 'Antoni', '1965-11-01', '6048 Logan Lane', 'arowcliffe2e@nationalgeographic.com', 'OSPA (Obra Social del Personal de la Actividad Aseguradora)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (38325160, 'Gokes', 'Fae', '1966-06-01', '3 Shelley Point', 'fgokes2f@ning.com', 'OSMATA (Obra Social del Personal de la Actividad del Turf)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (31205338, 'Dedman', 'Zackariah', '2002-12-26', '34116 Sherman Pass', 'zdedman2g@sina.com.cn', 'OSPAT (Obra Social del Personal de la Actividad del Turf)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (41897996, 'Kares', 'Chick', '2000-12-06', '261 Eagle Crest Junction', 'ckares2h@artisteer.com', 'PARTICULAR');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (22819360, 'Spurrett', 'Lonnie', '1986-07-26', '3 Ryan Terrace', 'lspurrett2i@github.io', 'UOM (Unión Obrera Metalúrgica)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (37061752, 'Bigland', 'Valry', '1996-07-12', '629 Lerdahl Terrace', 'vbigland2j@biblegateway.com', 'OSPV (Obra Social de Petroleros y Gas Privado de la Patagonia Austral)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (23112911, 'Brastead', 'Lindsey', '1979-06-24', '980 Paget Drive', 'lbrastead2k@wisc.edu', 'UOM (Unión Obrera Metalúrgica)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (12478741, 'Gergus', 'Marwin', '1999-01-03', '98888 Truax Trail', 'mgergus2l@squidoo.com', 'AMEPA (Asociación Mutual de Empleados del Poder Judicial)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (26037202, 'Bartunek', 'Gav', '1993-10-07', '10 Sutherland Pass', 'gbartunek2m@yahoo.com', 'AMFFA (Asociación Mutual de los Ferroviarios Argentinos)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (14065661, 'Thom', 'Kiel', '1991-10-04', '0614 Bunting Place', 'kthom2n@people.com.cn', 'Obra Social de la Universidad Nacional de Córdoba');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (35958017, 'Pele', 'Madella', '1983-10-05', '66 Forest Pass', 'mpele2o@baidu.com', 'Sancor Salud');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (14077095, 'Lombard', 'Tansy', '1986-02-16', '029 Lighthouse Bay Drive', 'tlombard2p@netvibes.com', 'IOMA (Instituto de Obra Médico Asistencial)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (49477220, 'Eagland', 'Charo', '1973-01-13', '9 Westerfield Place', 'ceagland2q@ibm.com', 'IPAUSS (Instituto Provincial Autárquico Unificado de Seguridad Social)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (50765251, 'Asher', 'Frayda', '2009-06-26', '509 6th Trail', 'fasher2r@wisc.edu', 'PARTICULAR');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (33043507, 'Searchwell', 'Shayla', '2000-08-01', '9081 Norway Maple Drive', 'ssearchwell2s@gmpg.org', 'OSPAT (Obra Social del Personal de la Actividad del Turf)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (54809849, 'Ivery', 'Kameko', '2000-09-01', '81 7th Center', 'kivery2t@clickbank.net', 'OSFFENTOS (Obra Social Ferroviaria de Fomento)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (20673541, 'Bett', 'Sallyann', '1974-10-12', '35 Fieldstone Place', 'sbett2u@fda.gov', 'AMP (Asociación Mutual del Personal de la Universidad Nacional de Tucumán)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (27067766, 'Baughn', 'Timmi', '1996-12-02', '6375 Dixon Circle', 'tbaughn2v@imdb.com', 'Medicus');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (42494126, 'Kingsly', 'Peggi', '1990-04-28', '779 Cordelia Drive', 'pkingsly2w@aboutads.info', 'OSPATCA (Obra Social del Personal Auxiliar de Casas Particulares)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (14422108, 'Barge', 'Peadar', '1971-02-11', '3 Susan Park', 'pbarge2x@ow.ly', 'OSPA (Obra Social del Personal de la Actividad Aseguradora)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (41824177, 'Rising', 'Niccolo', '1969-01-28', '0 West Road', 'nrising2y@walmart.com', 'OSDE');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (55391019, 'Pickavant', 'Pat', '1969-12-09', '05 Eggendart Crossing', 'ppickavant2z@jimdo.com', 'PARTICULAR');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (43752812, 'Bambrick', 'Doe', '1970-11-14', '73 High Crossing Parkway', 'dbambrick30@flickr.com', 'OSPAT (Obra Social del Personal de la Actividad del Turf)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (28083943, 'Gorham', 'Cob', '1963-09-10', '51960 Magdeline Junction', 'cgorham31@livejournal.com', 'IAPS (Instituto de Asistencia Social del Neuquén)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (12467221, 'Willman', 'Eba', '1999-04-07', '63614 Anniversary Crossing', 'ewillman32@opera.com', 'OSPV (Obra Social de Petroleros y Gas Privado de la Patagonia Austral)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (22916672, 'Cassam', 'Caroline', '1968-05-30', '07 Basil Hill', 'ccassam33@godaddy.com', 'OSDE');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (44077068, 'Keddey', 'Pincas', '1972-11-15', '801 Monterey Point', 'pkeddey34@1688.com', 'UOM (Unión Obrera Metalúrgica)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (17237798, 'Rea', 'Ali', '2009-07-05', '89368 Shoshone Place', 'area35@tripadvisor.com', 'OSEF (Obra Social del Estado Fueguino)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (26465871, 'Holleworth', 'Tedda', '1990-01-02', '39115 Banding Hill', 'tholleworth36@house.gov', 'IOMA (Instituto de Obra Médico Asistencial)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (53240292, 'Kanzler', 'Theodosia', '2006-02-02', '83670 Porter Crossing', 'tkanzler37@mit.edu', 'OSMATA (Obra Social del Personal de la Industria Azucarera)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (14954467, 'Jepperson', 'Duffie', '2005-08-02', '61 Crownhardt Plaza', 'djepperson38@cargocollective.com', 'OSMATA (Obra Social del Personal de la Industria Azucarera)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (14678545, 'Schusterl', 'Stinky', '1963-07-21', '9025 Farragut Hill', 'sschusterl39@psu.edu', 'PAMI (Programa de Atención Médica Integral)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (34477243, 'Stevenson', 'Major', '1984-05-14', '73 Prairieview Parkway', 'mstevenson3a@multiply.com', 'UOM (Unión Obrera Metalúrgica)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (13278350, 'Valasek', 'Vinni', '1973-08-11', '67 Clyde Gallagher Junction', 'vvalasek3b@issuu.com', 'IAPOS (Instituto Autárquico Provincial de Obra Social)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (32434714, 'Tackley', 'Kingsley', '1962-01-08', '50 Helena Drive', 'ktackley3c@shutterfly.com', 'Swiss Medical');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (42577254, 'Danforth', 'Kacie', '2008-10-31', '069 Cottonwood Road', 'kdanforth3d@imageshack.us', 'OSMATA (Obra Social del Personal de la Industria Azucarera)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (19853691, 'Fawkes', 'Beckie', '1967-10-04', '37467 Pearson Trail', 'bfawkes3e@google.com', 'OSPV (Obra Social de Petroleros y Gas Privado de la Patagonia Austral)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (31192631, 'Sleite', 'Toinette', '1969-12-03', '3870 Anderson Center', 'tsleite3f@dot.gov', 'OSMATA (Obra Social del Personal de la Industria Azucarera)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (52086269, 'Godart', 'Orrin', '1997-02-22', '13 Arrowood Court', 'ogodart3g@pen.io', 'AMEPA (Asociación Mutual de Empleados del Poder Judicial)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (50231654, 'Rittmeyer', 'Sarette', '2015-08-18', '63 Susan Point', 'srittmeyer3h@wix.com', 'Obra Social de la Universidad Nacional de Córdoba');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (13498061, 'Petworth', 'Eadmund', '1987-03-25', '2228 Hudson Terrace', 'epetworth3i@businessinsider.com', 'Medicus');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (26734093, 'Seekings', 'Palmer', '1989-11-02', '763 Memorial Way', 'pseekings3j@github.com', 'IPAUSS (Instituto Provincial Autárquico Unificado de Seguridad Social)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (28492402, 'Frill', 'Brianna', '1970-12-31', '140 Truax Junction', 'bfrill3k@chron.com', 'Accord Salud');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (27139833, 'Titman', 'Corie', '2001-09-21', '0 8th Trail', 'ctitman3l@privacy.gov.au', 'OSECAC (Obra Social de Empleados de Comercio y Actividades Civiles)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (50035084, 'Malden', 'Amby', '1989-08-24', '04 Gale Alley', 'amalden3m@furl.net', 'OSEF (Obra Social del Estado Fueguino)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (14015974, 'Saffle', 'Jocko', '2004-11-17', '61914 Iowa Way', 'jsaffle3n@engadget.com', 'IAPS (Instituto de Asistencia Social del Neuquén)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (36292084, 'Shipway', 'Nicolle', '2009-05-29', '56 Dennis Street', 'nshipway3o@etsy.com', 'Obra Social Bancaria Argentina');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (37766551, 'Stratten', 'Sawyer', '1971-07-28', '6547 Blue Bill Park Crossing', 'sstratten3p@foxnews.com', 'Accord Salud');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (31881425, 'Bunnell', 'Mead', '1995-06-22', '269 Burrows Place', 'mbunnell3q@etsy.com', 'Obra Social de la Universidad Nacional de Córdoba');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (23230922, 'Flacknell', 'Werner', '2015-10-16', '7586 Nevada Drive', 'wflacknell3r@reverbnation.com', 'Obras Sociales Provinciales (varias según cada provincia)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (41322208, 'Licciardiello', 'Felecia', '1967-01-23', '4052 Swallow Hill', 'flicciardiello3s@bigcartel.com', 'OSFFENTOS (Obra Social Ferroviaria de Fomento)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (26752226, 'Block', 'Cyndy', '1982-11-30', '6 Bobwhite Street', 'cblock3t@java.com', 'OSPV (Obra Social de Petroleros y Gas Privado de la Patagonia Austral)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (50022992, 'Rotter', 'Marjory', '2013-05-14', '7394 Fallview Center', 'mrotter3u@fotki.com', 'IAPS (Instituto de Asistencia Social del Neuquén)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (46783996, 'Gothrup', 'Reagan', '2006-05-17', '29 Trailsway Circle', 'rgothrup3v@google.cn', 'OSMATA (Obra Social del Personal de la Actividad del Turf)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (24262784, 'Skates', 'Emiline', '2002-01-16', '3 Glendale Crossing', 'eskates3w@cnn.com', 'OSEF (Obra Social del Estado Fueguino)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (54851166, 'Sindle', 'Venita', '2007-05-12', '8 Michigan Terrace', 'vsindle3x@edublogs.org', 'OSPA (Obra Social del Personal de la Actividad Aseguradora)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (36829967, 'Strute', 'Donella', '2014-09-17', '015 Anzinger Point', 'dstrute3y@bbb.org', 'AMFFA (Asociación Mutual de los Ferroviarios Argentinos)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (46675055, 'Slack', 'Bill', '1970-02-04', '9071 North Terrace', 'bslack3z@ehow.com', 'OSEF (Obra Social del Estado Fueguino)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (42313718, 'Shiel', 'Arman', '1980-03-15', '68845 Mosinee Circle', 'ashiel40@xrea.com', 'Obras Sociales Provinciales (varias según cada provincia)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (26131545, 'Taw', 'Chaunce', '1960-07-17', '52583 Ilene Circle', 'ctaw41@homestead.com', 'Medicus');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (45271575, 'Tessier', 'Jimmy', '1997-05-08', '16163 Darwin Drive', 'jtessier42@woothemes.com', 'UOM (Unión Obrera Metalúrgica)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (36170272, 'Bridson', 'Yolane', '1961-08-09', '91673 Northport Junction', 'ybridson43@cdbaby.com', 'OSPJN (Obra Social del Poder Judicial de la Nación)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (55876664, 'Goulthorp', 'Alexine', '1976-03-27', '700 Jackson Point', 'agoulthorp44@cmu.edu', 'DASPU (Dirección de Asistencia Social del Personal Universitario)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (45197754, 'Amerighi', 'Hana', '2006-07-22', '582 Montana Trail', 'hamerighi45@uiuc.edu', 'Accord Salud');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (50978342, 'Stodd', 'Kennie', '1971-08-15', '7 Monterey Court', 'kstodd46@ning.com', 'OSMATA (Obra Social del Personal de la Industria Azucarera)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (29645507, 'Cubitt', 'Rosemary', '2006-02-24', '98 Mallard Terrace', 'rcubitt47@amazon.co.uk', 'OSPAT (Obra Social del Personal de la Actividad del Turf)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (41297582, 'Checci', 'Daniella', '1979-02-01', '82099 Sage Junction', 'dchecci48@discuz.net', 'IAPS (Instituto de Asistencia Social del Neuquén)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (33137714, 'Kinnoch', 'Brandise', '1963-04-10', '317 Scofield Point', 'bkinnoch49@icq.com', 'OSPRERA (Obra Social de los Empleados de la República Argentina)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (33727670, 'Cristoforetti', 'Sheila-kathryn', '2007-06-10', '81 Bobwhite Way', 'scristoforetti4a@nsw.gov.au', 'Galeno');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (49605213, 'Haine', 'Berni', '1971-08-21', '56977 Daystar Drive', 'bhaine4b@ft.com', 'IPAUSS (Instituto Provincial Autárquico Unificado de Seguridad Social)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (55916076, 'Oakland', 'Ginni', '1996-08-31', '68230 Autumn Leaf Court', 'goakland4c@nasa.gov', 'UOM (Unión Obrera Metalúrgica)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (47526774, 'Lukock', 'Rhianon', '1990-07-03', '48 Marcy Place', 'rlukock4d@indiegogo.com', 'OSMATA (Obra Social del Personal de la Actividad del Turf)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (52673450, 'Meak', 'Alejoa', '1982-12-12', '698 Moulton Lane', 'ameak4e@sitemeter.com', 'AMEPA (Asociación Mutual de Empleados del Poder Judicial)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (41982467, 'Dagger', 'Xylina', '2010-04-11', '76494 Monument Avenue', 'xdagger4f@wisc.edu', 'OSPRERA (Obra Social de los Empleados de la República Argentina)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (48070936, 'Maydway', 'Roberto', '2000-10-31', '0 Victoria Lane', 'rmaydway4g@washington.edu', 'Accord Salud');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (23783913, 'Lill', 'Alphonse', '1991-06-18', '838 Sherman Street', 'alill4h@bluehost.com', 'OSEF (Obra Social del Estado Fueguino)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (14501958, 'Galbraeth', 'Flss', '1999-03-01', '83847 Eastwood Parkway', 'fgalbraeth4i@salon.com', 'IOMA (Instituto de Obra Médico Asistencial)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (19392790, 'Willingam', 'Edlin', '1976-06-12', '89 Shoshone Crossing', 'ewillingam4j@army.mil', 'OSFFENTOS (Obra Social Ferroviaria de Fomento)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (26831952, 'Madden', 'Elliot', '2004-11-29', '838 Killdeer Terrace', 'emadden4k@google.ru', 'OSPA (Obra Social del Personal de la Actividad Aseguradora)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (44473882, 'McCreath', 'Vinson', '2009-11-08', '0 John Wall Crossing', 'vmccreath4l@blog.com', 'OSPA (Obra Social del Personal de la Actividad Aseguradora)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (50776376, 'Cosyns', 'Tony', '1967-03-17', '5872 Di Loreto Center', 'tcosyns4m@tuttocitta.it', 'OSEF (Obra Social del Estado Fueguino)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (18170313, 'McClenan', 'Sandye', '1974-05-22', '8621 Sommers Parkway', 'smcclenan4n@indiatimes.com', 'UPCN (Unión del Personal Civil de la Nación)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (33729020, 'Sedgeworth', 'Freeman', '1973-10-29', '261 Transport Point', 'fsedgeworth4o@chronoengine.com', 'SADAIC (Sociedad Argentina de Autores y Compositores de Música)');
          insert into pacientes (dni, apellido, nombre, fecha_nacimiento, domicilio, correo_electronico, obra_social) values (41355788, 'Walkley', 'Park', '1993-07-08', '848 Roth Street', 'pwalkley4p@fda.gov', 'AMP (Asociación Mutual del Personal de la Universidad Nacional de Tucumán)');
-- SE CREA UN PRIMER SAVEPOINT
SAVEPOINT save_pacientes;
-- SE SIGUE INSERTANDO DATOS, AHORA EN LA TABLA 'pacientes_telefonos'
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (1, 'FIJO', '9593934882');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (2, 'CELULAR', '3581931312');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (3, 'CELULAR', '1433654774');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (4, 'CELULAR', '3353772627');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (5, 'FIJO', '2818184252');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (6, 'FIJO', '8959755380');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (7, 'CELULAR', '5258246631');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (8, 'CELULAR', '6408398377');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (9, 'FIJO', '2123486052');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (10, 'CELULAR', '6934516821');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (11, 'CELULAR', '6799420849');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (12, 'FIJO', '6938558138');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (13, 'CELULAR', '5688917849');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (14, 'CELULAR', '7662891221');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (15, 'FIJO', '8153486161');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (16, 'FIJO', '4681034675');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (17, 'FIJO', '8019819377');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (18, 'CELULAR', '5301031224');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (19, 'FIJO', '9721514893');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (20, 'FIJO', '9699754684');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (21, 'FIJO', '7616818659');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (22, 'FIJO', '3007144412');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (23, 'FIJO', '5998756000');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (24, 'CELULAR', '7437948788');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (25, 'FIJO', '5089014942');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (26, 'FIJO', '4041094371');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (27, 'FIJO', '9522878161');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (28, 'FIJO', '2582453609');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (29, 'FIJO', '3006818170');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (30, 'CELULAR', '8216999036');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (31, 'CELULAR', '4763056397');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (32, 'CELULAR', '3633301262');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (33, 'CELULAR', '9193383179');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (34, 'FIJO', '1508495313');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (35, 'CELULAR', '5081921669');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (36, 'CELULAR', '3083119696');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (37, 'CELULAR', '4953198105');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (38, 'CELULAR', '8609679884');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (39, 'CELULAR', '9174335541');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (40, 'CELULAR', '5756889424');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (41, 'FIJO', '7167714015');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (42, 'FIJO', '1791655539');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (43, 'CELULAR', '2025111906');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (44, 'FIJO', '1059282333');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (45, 'FIJO', '9385503289');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (46, 'CELULAR', '6971622924');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (47, 'CELULAR', '5913641139');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (48, 'FIJO', '5441449845');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (49, 'CELULAR', '9063137709');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (50, 'FIJO', '5562517755');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (51, 'CELULAR', '6345174155');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (52, 'CELULAR', '3144898825');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (53, 'CELULAR', '4885192211');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (54, 'CELULAR', '8434888091');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (55, 'FIJO', '6165414705');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (56, 'CELULAR', '3155644064');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (57, 'CELULAR', '9169696581');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (58, 'FIJO', '2731623258');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (59, 'CELULAR', '9005971890');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (60, 'FIJO', '8641483883');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (61, 'FIJO', '1119262296');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (62, 'FIJO', '2476358065');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (63, 'FIJO', '5873388944');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (64, 'CELULAR', '4269898524');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (65, 'CELULAR', '6542376026');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (66, 'FIJO', '5139223259');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (67, 'FIJO', '7934460547');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (68, 'FIJO', '1276989703');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (69, 'CELULAR', '1022520536');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (70, 'FIJO', '8643091431');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (71, 'FIJO', '9099475885');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (72, 'CELULAR', '5663601133');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (73, 'CELULAR', '2055610984');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (74, 'FIJO', '2825545299');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (75, 'CELULAR', '4895254728');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (76, 'CELULAR', '1498028851');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (77, 'FIJO', '6781061484');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (78, 'CELULAR', '6987556845');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (79, 'CELULAR', '3921075160');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (80, 'CELULAR', '6261947516');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (81, 'FIJO', '6123817940');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (82, 'CELULAR', '4054828469');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (83, 'FIJO', '7429066909');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (84, 'CELULAR', '5091085136');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (85, 'FIJO', '2535293970');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (86, 'CELULAR', '9494665154');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (87, 'CELULAR', '3738250362');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (88, 'FIJO', '5443879508');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (89, 'CELULAR', '8926045021');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (90, 'CELULAR', '5596059266');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (91, 'FIJO', '1356726364');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (92, 'CELULAR', '3058580068');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (93, 'FIJO', '5972091665');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (94, 'CELULAR', '3157650116');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (95, 'CELULAR', '9077018717');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (96, 'FIJO', '3126658354');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (97, 'FIJO', '5381881290');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (98, 'CELULAR', '3729313110');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (99, 'FIJO', '3903405899');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (100, 'FIJO', '3351365352');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (101, 'FIJO', '5884833941');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (102, 'FIJO', '1103842733');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (103, 'CELULAR', '8328616591');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (104, 'CELULAR', '2286536670');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (105, 'FIJO', '6827214654');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (106, 'FIJO', '1877397047');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (107, 'FIJO', '9077593684');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (108, 'CELULAR', '4839449812');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (109, 'CELULAR', '9026928320');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (110, 'FIJO', '2697062633');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (111, 'FIJO', '7721851038');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (112, 'FIJO', '3378390266');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (113, 'CELULAR', '6808928165');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (114, 'CELULAR', '2993776570');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (115, 'CELULAR', '9518542900');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (116, 'CELULAR', '2818123269');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (117, 'FIJO', '6896179310');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (118, 'CELULAR', '1943097168');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (119, 'CELULAR', '6976227337');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (120, 'FIJO', '6441509498');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (121, 'FIJO', '8374212418');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (122, 'CELULAR', '5125666011');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (123, 'CELULAR', '3248620374');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (124, 'CELULAR', '4951866937');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (125, 'CELULAR', '9132091951');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (126, 'FIJO', '9245929778');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (127, 'CELULAR', '1132561100');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (128, 'CELULAR', '5627799205');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (129, 'FIJO', '2125189897');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (130, 'CELULAR', '1179127417');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (131, 'CELULAR', '5853483899');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (132, 'FIJO', '8936919697');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (133, 'CELULAR', '1681185731');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (134, 'FIJO', '3716266698');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (135, 'CELULAR', '1697035054');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (136, 'FIJO', '7061828995');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (137, 'CELULAR', '2925329342');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (138, 'FIJO', '2784125571');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (139, 'CELULAR', '7468537757');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (140, 'CELULAR', '1507233972');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (141, 'FIJO', '3826183800');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (142, 'FIJO', '5018213324');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (143, 'FIJO', '4395580728');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (144, 'FIJO', '4046415932');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (145, 'FIJO', '1379977279');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (146, 'FIJO', '5122914710');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (147, 'CELULAR', '7164928521');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (148, 'FIJO', '7073619509');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (149, 'CELULAR', '3633773329');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (150, 'FIJO', '8117882179');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (151, 'CELULAR', '2444085204');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (152, 'FIJO', '9021511486');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (153, 'FIJO', '2631016138');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (154, 'FIJO', '1753767966');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (155, 'CELULAR', '4621744597');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (156, 'CELULAR', '7166344665');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (157, 'FIJO', '3495063727');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (158, 'FIJO', '4382484444');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (159, 'CELULAR', '9314924055');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (160, 'CELULAR', '1101890912');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (161, 'CELULAR', '7905393502');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (162, 'FIJO', '1375704371');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (163, 'CELULAR', '6444508200');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (164, 'FIJO', '6301147076');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (165, 'CELULAR', '8036201698');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (166, 'CELULAR', '2477738340');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (167, 'FIJO', '6047883537');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (168, 'CELULAR', '3331289600');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (169, 'CELULAR', '9432880481');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (170, 'CELULAR', '8316873763');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (11, 'FIJO', '7853728740');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (12, 'FIJO', '7939524906');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (13, 'CELULAR', '8422702244');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (54, 'FIJO', '8438369365');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (55, 'FIJO', '1836479002');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (56, 'CELULAR', '1491174952');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (17, 'CELULAR', '2059411817');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (18, 'FIJO', '4499768667');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (89, 'CELULAR', '1229357681');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (80, 'FIJO', '5937287811');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (81, 'CELULAR', '1269094420');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (12, 'FIJO', '6137203250');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (13, 'FIJO', '9974431993');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (94, 'CELULAR', '1294705735');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (95, 'CELULAR', '1445873258');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (96, 'CELULAR', '5882525696');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (17, 'FIJO', '2085303087');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (18, 'FIJO', '5305101819');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (19, 'FIJO', '5844427015');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (110, 'FIJO', '3735009915');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (111, 'CELULAR', '4152463534');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (112, 'CELULAR', '5676154907');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (13, 'CELULAR', '9899460795');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (14, 'CELULAR', '6212408144');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (151, 'CELULAR', '4567571007');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (161, 'CELULAR', '1159706971');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (170, 'CELULAR', '3955071703');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (18, 'CELULAR', '1185618624');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (19, 'CELULAR', '5368917181');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (20, 'FIJO', '5928213779');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (71, 'FIJO', '3363643182');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (72, 'FIJO', '6795777881');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (73, 'FIJO', '4587169771');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (24, 'FIJO', '4006211973');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (25, 'FIJO', '2635268741');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (86, 'CELULAR', '8349851236');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (87, 'FIJO', '4677766961');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (88, 'FIJO', '5215604760');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (29, 'FIJO', '2472122825');
          insert into pacientes_telefonos (id_paciente, descripcion, telefono) values (20, 'CELULAR', '2138600242');
-- SE CREA UN SEGUNDO SAVEPOINT
SAVEPOINT save_pacientes_telefonos;
-- SE REALIZA UN COMMIT PARA CONFIRMAR LOS CAMBIOS
  COMMIT;
-- PARA CHEQUEAR QUE LOS DATOS SE CARGARON CORRECTAMENTE, PUEDE DESCOMENTAR Y EJECUTAR LAS SIGUIENTES LINEAS
-- SELECT * FROM pacientes;
-- SELECT * FROM pacientes_telefonos;
  


/*
 ESTE SCRIPT INSERTA DATOS EN LA TABLA 'administrativos' Y EN LA TABLA 'administrativos_telefonos':
 
 */

-- Inserción de datos en la tabla 'administrativos'
INSERT INTO administrativos (dni, nombre, apellido, fecha_nacimiento, domicilio, correo_electronico, rol)
VALUES
  ('26354867', 'María', 'Rojas', '1980-05-12', 'Calle 123', 'mariarojas@example.com', 'ADMINISTRATIVO'),
  ('21472362', 'Luis', 'Gómez', '1975-09-25', 'Avenida 456', 'luisgomez@example.com', 'ADMINISTRATIVO'),
  ('36423008', 'Ana', 'Hernández', '1990-07-18', 'Carrera 789', 'anahernandez@example.com', 'ADMINISTRATIVO'),
  ('21354867', 'Martha', 'Ramires', '1978-02-15', 'Calle 123', 'martharamires@example.com', 'ADMINISTRATIVO'),
  ('25472362', 'Gabriela', 'Martínez', '1977-10-21', 'Avenida 125', 'gabimartinez@example.com', 'ADMINISTRATIVO'),
  ('37423008', 'Anabella', 'Gallardo', '1991-01-10', 'Carrera 563', 'anagallardo@example.com', 'ADMINISTRATIVO'),
  ('36354867', 'Fabricio', 'Sánchez', '1981-05-11', 'Calle 166', 'fabriciosanchez@example.com', 'ADMINISTRATIVO'),
  ('31472362', 'Luisina', 'Marz', '1985-03-05', 'Avenida 421', 'luisinamarz@example.com', 'ADMINISTRATIVO'),
  ('26423008', 'Franco', 'Guillén', '1979-11-08', 'Carrera 7121', 'franguillen@example.com', 'ADMINISTRATIVO');  
-- PARA CHEQUEAR QUE LOS DATOS SE CARGARON CORRECTAMENTE, PUEDE DESCOMENTAR Y EJECUTAR LA SIGUIENTE LINEA
-- SELECT * FROM administrativos;


-- Inserción de datos en la tabla 'telefono_administrativo'
INSERT INTO administrativos_telefonos (id_administrativo, descripcion, telefono)
VALUES
  (1, 'FIJO', 2613484788),
  (1, 'CELULAR', 2612344700),
  (2, 'CELULAR', 261223402),
  (3, 'CELULAR', 26233453),
  (4, 'FIJO', 2613400788),
  (4, 'CELULAR', 2612300700),
  (5, 'CELULAR', 261220002),
  (6, 'CELULAR', 26130322453),
  (7, 'CELULAR', 2612342200),
  (8, 'CELULAR', 261223222),
  (9, 'CELULAR', 261303333);
  -- PARA CHEQUEAR QUE LOS DATOS SE CARGARON CORRECTAMENTE, PUEDE DESCOMENTAR Y EJECUTAR LA SIGUIENTE LINEA
  -- SELECT * FROM administrativos_telefonos;
  
  
  /*
 ESTE SCRIPT INSERTA DATOS EN LA TABLA 'auditores' Y EN LA TABLA 'auditores_telefonos':
 */
-- Inserción de datos en la tabla 'auditores'
INSERT INTO auditores (dni, apellido, nombre, correo_electronico, puesto)
VALUES
  ('32169340','Escudero','Emanuel','emadba@example.com','Administrador Base de Datos'),
  ('29050867', 'Mariana', 'Ledesma', 'marianaledesma@example.com', 'Propietaria Consultorio Médico'),
  ('24040699', 'Carlos', 'García', 'carlosgarcia@example.com', 'Propietario Consultorio Médico'),
  ('26040690', 'Ana María', 'Ortiz', 'anamariaortis@example.com', 'Gerente General Consultorio Médico'),
  ('23047727', 'Sebastián', 'Bach', 'sebastianbach@example.com', 'Gerente Adjunto Consultorio Médico');
-- PARA CHEQUEAR QUE LOS DATOS SE CARGARON CORRECTAMENTE, PUEDE DESCOMENTAR Y EJECUTAR LA SIGUIENTE LINEA  
-- SELECT * FROM auditores;

-- Inserción de datos en la tabla 'administrativo_telefonos'
INSERT INTO auditores_telefonos (id_auditor, descripcion, telefono)
VALUES
  (1, 'FIJO', 2614483332),
  (1, 'CELULAR', 26120661160),
  (2, 'CELULAR', 011223402),
  (3, 'CELULAR', 06333453),
  (4, 'FIJO', 2613400788),
  (4, 'CELULAR', 2612000700),
  (5, 'CELULAR', 261226662);
-- PARA CHEQUEAR QUE LOS DATOS SE CARGARON CORRECTAMENTE, PUEDE DESCOMENTAR Y EJECUTAR LA SIGUIENTE LINEA  
-- SELECT * FROM auditores_telefonos;

-- use GestionSaludDB;
-- SELECT * FROM auditores;
-- SELECT * FROM usuarios_sistema;

-- use mysql;
-- select * from user;


/*
 ESTE SCRIPT INSERTA DATOS EN LA TABLA 'medicos' Y EN LA TABLA 'medicos_telefonos':
 */

-- Inserción de datos en la tabla 'medicos'
                insert into medicos (dni, apellido, nombre, fecha_nacimiento, correo_electronico, especialidad, matricula) values (608062, 'Braunston', 'Boot', '1961-03-03', 'bbraunston0@nationalgeographic.com', 'Clínica', 2260);
                insert into medicos (dni, apellido, nombre, fecha_nacimiento, correo_electronico, especialidad, matricula) values (36380334, 'Paur', 'Montague', '1969-12-11', 'mpaur1@wsj.com', 'Pediatría', 8156);
                insert into medicos (dni, apellido, nombre, fecha_nacimiento, correo_electronico, especialidad, matricula) values (3057710, 'Bootell', 'Franz', '1967-08-10', 'fbootell2@bbc.co.uk', 'Traumatología', 6539);
                insert into medicos (dni, apellido, nombre, fecha_nacimiento, correo_electronico, especialidad, matricula) values (2657062, 'Heasman', 'Kinny', '1963-06-24', 'kheasman3@imdb.com', 'Dermatología', 3662);
                insert into medicos (dni, apellido, nombre, fecha_nacimiento, correo_electronico, especialidad, matricula) values (19626438, 'Liepina', 'Baxy', '1981-02-21', 'bliepina4@storify.com', 'Clínica', 5198);
                insert into medicos (dni, apellido, nombre, fecha_nacimiento, correo_electronico, especialidad, matricula) values (21323069, 'Westerman', 'Emlyn', '1989-04-18', 'ewesterman5@angelfire.com', 'Cardiología', 7115);
                insert into medicos (dni, apellido, nombre, fecha_nacimiento, correo_electronico, especialidad, matricula) values (20462115, 'Allen', 'Arleen', '1988-12-30', 'aallen6@nyu.edu', 'Clínica', 3142);
                insert into medicos (dni, apellido, nombre, fecha_nacimiento, correo_electronico, especialidad, matricula) values (2945556, 'Hindrick', 'Euell', '1963-12-03', 'ehindrick7@dion.ne.jp', 'Psicología', 7293);
                insert into medicos (dni, apellido, nombre, fecha_nacimiento, correo_electronico, especialidad, matricula) values (36957604, 'Creasy', 'Lothario', '1965-11-01', 'lcreasy8@bigcartel.com', 'Psiquiatría', 4189);
                insert into medicos (dni, apellido, nombre, fecha_nacimiento, correo_electronico, especialidad, matricula) values (9858225, 'Yakovich', 'Llywellyn', '1985-02-10', 'lyakovich9@ifeng.com', 'Traumatología', 3779);
                insert into medicos (dni, apellido, nombre, fecha_nacimiento, correo_electronico, especialidad, matricula) values (36258079, 'Henderson', 'Baily', '1972-02-25', 'bhendersona@feedburner.com', 'Psicología', 7403);
                insert into medicos (dni, apellido, nombre, fecha_nacimiento, correo_electronico, especialidad, matricula) values (37804289, 'Pietri', 'Rodrick', '1987-09-20', 'rpietrib@buzzfeed.com', 'Psicología', 1837);
                insert into medicos (dni, apellido, nombre, fecha_nacimiento, correo_electronico, especialidad, matricula) values (29228930, 'Shaxby', 'Britte', '1970-12-25', 'bshaxbyc@wix.com', 'Traumatología', 6409);
                insert into medicos (dni, apellido, nombre, fecha_nacimiento, correo_electronico, especialidad, matricula) values (1172389, 'Fortnam', 'Wylie', '1986-10-14', 'wfortnamd@goodreads.com', 'Ginecología', 3468);
                insert into medicos (dni, apellido, nombre, fecha_nacimiento, correo_electronico, especialidad, matricula) values (20965475, 'Le Port', 'Allis', '1986-12-02', 'aleporte@chron.com', 'Pediatría', 6201);
                insert into medicos (dni, apellido, nombre, fecha_nacimiento, correo_electronico, especialidad, matricula) values (16664297, 'Treffrey', 'Gregoire', '1966-11-12', 'gtreffreyf@unesco.org', 'Psicología', 3906);
                insert into medicos (dni, apellido, nombre, fecha_nacimiento, correo_electronico, especialidad, matricula) values (6810396, 'Chitham', 'Ynez', '1963-04-17', 'ychithamg@1688.com', 'Dermatología', 3943);
                insert into medicos (dni, apellido, nombre, fecha_nacimiento, correo_electronico, especialidad, matricula) values (16564186, 'Sex', 'Virgina', '1989-10-25', 'vsexh@aol.com', 'Cardiología', 3597);
                insert into medicos (dni, apellido, nombre, fecha_nacimiento, correo_electronico, especialidad, matricula) values (21399451, 'Cisson', 'Eugen', '1984-12-16', 'ecissoni@wordpress.org', 'Cardiología', 5146);
                insert into medicos (dni, apellido, nombre, fecha_nacimiento, correo_electronico, especialidad, matricula) values (17430697, 'Berr', 'Lillian', '1965-09-08', 'lberrj@newyorker.com', 'Odontología', 6895);
                insert into medicos (dni, apellido, nombre, fecha_nacimiento, correo_electronico, especialidad, matricula) values (5932102, 'Lockitt', 'Nilson', '1967-05-10', 'nlockittk@360.cn', 'Oftalmología', 3703);
                insert into medicos (dni, apellido, nombre, fecha_nacimiento, correo_electronico, especialidad, matricula) values (34667606, 'Tillyer', 'Ulrike', '1988-09-20', 'utillyerl@dagondesign.com', 'Psicología', 2987);
                insert into medicos (dni, apellido, nombre, fecha_nacimiento, correo_electronico, especialidad, matricula) values (28016452, 'Seavers', 'Bay', '1970-06-02', 'bseaversm@washingtonpost.com', 'Oftalmología', 4466);
                insert into medicos (dni, apellido, nombre, fecha_nacimiento, correo_electronico, especialidad, matricula) values (20664636, 'Yegorovnin', 'Celestina', '1968-02-02', 'cyegorovninn@bravesites.com', 'Traumatología', 4534);
                insert into medicos (dni, apellido, nombre, fecha_nacimiento, correo_electronico, especialidad, matricula) values (34186737, 'Kupis', 'Myrilla', '1963-10-03', 'mkupiso@jigsy.com', 'Psicología', 2692);
                insert into medicos (dni, apellido, nombre, fecha_nacimiento, correo_electronico, especialidad, matricula) values (24083353, 'Josovitz', 'Randolph', '1978-04-09', 'rjosovitzp@vinaora.com', 'Cardiología', 6297);
                insert into medicos (dni, apellido, nombre, fecha_nacimiento, correo_electronico, especialidad, matricula) values (30330478, 'Arrington', 'Greta', '1989-06-11', 'garringtonq@drupal.org', 'Psicología', 7353);
                insert into medicos (dni, apellido, nombre, fecha_nacimiento, correo_electronico, especialidad, matricula) values (39052855, 'Cordes', 'Alvis', '1962-12-19', 'acordesr@blog.com', 'Psiquiatría', 7158);
                insert into medicos (dni, apellido, nombre, fecha_nacimiento, correo_electronico, especialidad, matricula) values (17181164, 'Gateman', 'Ingeborg', '1963-11-25', 'igatemans@homestead.com', 'Ginecología', 3969);
                insert into medicos (dni, apellido, nombre, fecha_nacimiento, correo_electronico, especialidad, matricula) values (26526441, 'Ciobotaru', 'Leola', '1970-06-12', 'lciobotarut@stanford.edu', 'Psiquiatría', 7542);
                insert into medicos (dni, apellido, nombre, fecha_nacimiento, correo_electronico, especialidad, matricula) values (34817720, 'Flinn', 'Konstanze', '1969-06-25', 'kflinnu@chron.com', 'Ginecología', 7624);
                insert into medicos (dni, apellido, nombre, fecha_nacimiento, correo_electronico, especialidad, matricula) values (38947935, 'Baggallay', 'Alonso', '1961-10-28', 'abaggallayv@theglobeandmail.com', 'Cardiología', 7186);
                insert into medicos (dni, apellido, nombre, fecha_nacimiento, correo_electronico, especialidad, matricula) values (31249716, 'Huc', 'Filippa', '1979-07-23', 'fhucw@wired.com', 'Pediatría', 3179);
                insert into medicos (dni, apellido, nombre, fecha_nacimiento, correo_electronico, especialidad, matricula) values (10550272, 'Robb', 'Claire', '1981-11-15', 'crobbx@bbb.org', 'Pediatría', 4613);
                insert into medicos (dni, apellido, nombre, fecha_nacimiento, correo_electronico, especialidad, matricula) values (37629393, 'Rennox', 'Emma', '1964-01-19', 'erennoxy@nymag.com', 'Psiquiatría', 2096);
                insert into medicos (dni, apellido, nombre, fecha_nacimiento, correo_electronico, especialidad, matricula) values (24937561, 'Crolla', 'Darby', '1977-10-23', 'dcrollaz@mapy.cz', 'Cardiología', 4533);
                insert into medicos (dni, apellido, nombre, fecha_nacimiento, correo_electronico, especialidad, matricula) values (12067631, 'Jenks', 'Carleton', '1979-12-05', 'cjenks10@cnbc.com', 'Cardiología', 2601);
                insert into medicos (dni, apellido, nombre, fecha_nacimiento, correo_electronico, especialidad, matricula) values (6323908, 'Lendrem', 'Claire', '1985-12-20', 'clendrem11@bloglovin.com', 'Psicología', 6122);
                insert into medicos (dni, apellido, nombre, fecha_nacimiento, correo_electronico, especialidad, matricula) values (28449409, 'Redbourn', 'Grier', '1973-06-10', 'gredbourn12@blogtalkradio.com', 'Clínica', 7320);
                insert into medicos (dni, apellido, nombre, fecha_nacimiento, correo_electronico, especialidad, matricula) values (16400925, 'Leaman', 'Florentia', '1988-01-09', 'fleaman13@webs.com', 'Oftalmología', 2839);
                insert into medicos (dni, apellido, nombre, fecha_nacimiento, correo_electronico, especialidad, matricula) values (3884149, 'Brigdale', 'Rosemonde', '1988-12-27', 'rbrigdale14@behance.net', 'Dermatología', 7679);
                insert into medicos (dni, apellido, nombre, fecha_nacimiento, correo_electronico, especialidad, matricula) values (32803094, 'Entreis', 'Lulita', '1986-06-18', 'lentreis15@lycos.com', 'Clínica', 3657);
                insert into medicos (dni, apellido, nombre, fecha_nacimiento, correo_electronico, especialidad, matricula) values (1461459, 'Hindmoor', 'Tyne', '1970-10-14', 'thindmoor16@elpais.com', 'Clínica', 2547);
                insert into medicos (dni, apellido, nombre, fecha_nacimiento, correo_electronico, especialidad, matricula) values (8524104, 'Reaney', 'Demott', '1974-09-01', 'dreaney17@dagondesign.com', 'Traumatología', 3092);
                insert into medicos (dni, apellido, nombre, fecha_nacimiento, correo_electronico, especialidad, matricula) values (1768279, 'Marron', 'Jessamine', '1977-04-27', 'jmarron18@jugem.jp', 'Traumatología', 2033);
                insert into medicos (dni, apellido, nombre, fecha_nacimiento, correo_electronico, especialidad, matricula) values (17003696, 'Hug', 'Hakeem', '1978-07-01', 'hhug19@columbia.edu', 'Clínica', 5884);
                insert into medicos (dni, apellido, nombre, fecha_nacimiento, correo_electronico, especialidad, matricula) values (2409919, 'Kirkland', 'Niles', '1982-11-10', 'nkirkland1a@hud.gov', 'Psiquiatría', 7090);
                insert into medicos (dni, apellido, nombre, fecha_nacimiento, correo_electronico, especialidad, matricula) values (26656566, 'Petren', 'Ceil', '1975-11-28', 'cpetren1b@tripadvisor.com', 'Psicología', 5951);
                insert into medicos (dni, apellido, nombre, fecha_nacimiento, correo_electronico, especialidad, matricula) values (16435990, 'Donovan', 'Lucho', '1982-04-18', 'ldonovan1c@microsoft.com', 'Pediatría', 7224);
                insert into medicos (dni, apellido, nombre, fecha_nacimiento, correo_electronico, especialidad, matricula) values (14917882, 'O''Connell', 'Mikol', '1986-08-10', 'moconnell1d@wufoo.com', 'Clínica', 7412);
                insert into medicos (dni, apellido, nombre, fecha_nacimiento, correo_electronico, especialidad, matricula) values (29927299, 'Musso', 'Constantine', '1988-06-30', 'cmusso1e@cmu.edu', 'Oftalmología', 4545);
                insert into medicos (dni, apellido, nombre, fecha_nacimiento, correo_electronico, especialidad, matricula) values (19192355, 'Grassin', 'Olivier', '1987-11-10', 'ograssin1f@studiopress.com', 'Psiquiatría', 7632);
                insert into medicos (dni, apellido, nombre, fecha_nacimiento, correo_electronico, especialidad, matricula) values (5754010, 'Thatcher', 'Casey', '1971-11-26', 'cthatcher1g@drupal.org', 'Odontología', 2520);
                insert into medicos (dni, apellido, nombre, fecha_nacimiento, correo_electronico, especialidad, matricula) values (17736934, 'Chotty', 'Symon', '1977-09-02', 'schotty1h@tripod.com', 'Ginecología', 4334);
                insert into medicos (dni, apellido, nombre, fecha_nacimiento, correo_electronico, especialidad, matricula) values (27519046, 'Gallifont', 'Leontyne', '1987-08-19', 'lgallifont1i@alibaba.com', 'Psiquiatría', 2085);
                insert into medicos (dni, apellido, nombre, fecha_nacimiento, correo_electronico, especialidad, matricula) values (30420772, 'Rushbrooke', 'Odo', '1980-03-22', 'orushbrooke1j@people.com.cn', 'Psicología', 8071);
                insert into medicos (dni, apellido, nombre, fecha_nacimiento, correo_electronico, especialidad, matricula) values (34805943, 'Coger', 'Westbrooke', '1978-12-20', 'wcoger1k@hc360.com', 'Ginecología', 5702);
                insert into medicos (dni, apellido, nombre, fecha_nacimiento, correo_electronico, especialidad, matricula) values (32905546, 'Lyptrade', 'Elke', '1977-08-18', 'elyptrade1l@unc.edu', 'Ginecología', 3149);
                insert into medicos (dni, apellido, nombre, fecha_nacimiento, correo_electronico, especialidad, matricula) values (27246288, 'Gudgin', 'Royce', '1969-08-28', 'rgudgin1m@arstechnica.com', 'Dermatología', 6168);
                insert into medicos (dni, apellido, nombre, fecha_nacimiento, correo_electronico, especialidad, matricula) values (7423934, 'Poker', 'Roanne', '1988-04-16', 'rpoker1n@oakley.com', 'Clínica', 6874);
-- PARA CHEQUEAR QUE LOS DATOS SE CARGARON CORRECTAMENTE, PUEDE DESCOMENTAR Y EJECUTAR LA SIGUIENTE LINEA  
-- SELECT * FROM medicos;


-- Inserción de datos en la tabla 'telefono_medico' con los 'id' consultados
              insert into medicos_telefonos (id_medico, descripcion, telefono) values (1, 'CELULAR', '7135103403');
              insert into medicos_telefonos (id_medico, descripcion, telefono) values (2, 'FIJO', '8177229776');
              insert into medicos_telefonos (id_medico, descripcion, telefono) values (3, 'CELULAR', '8111466994');
              insert into medicos_telefonos (id_medico, descripcion, telefono) values (4, 'FIJO', '4317675511');
              insert into medicos_telefonos (id_medico, descripcion, telefono) values (5, 'FIJO', '3826661990');
              insert into medicos_telefonos (id_medico, descripcion, telefono) values (6, 'FIJO', '3331940463');
              insert into medicos_telefonos (id_medico, descripcion, telefono) values (7, 'FIJO', '2404051654');
              insert into medicos_telefonos (id_medico, descripcion, telefono) values (8, 'CELULAR', '4475285935');
              insert into medicos_telefonos (id_medico, descripcion, telefono) values (9, 'FIJO', '6328350976');
              insert into medicos_telefonos (id_medico, descripcion, telefono) values (10, 'CELULAR', '9329478840');
              insert into medicos_telefonos (id_medico, descripcion, telefono) values (11, 'CELULAR', '7307585835');
              insert into medicos_telefonos (id_medico, descripcion, telefono) values (12, 'CELULAR', '5183008945');
              insert into medicos_telefonos (id_medico, descripcion, telefono) values (13, 'FIJO', '9993835687');
              insert into medicos_telefonos (id_medico, descripcion, telefono) values (14, 'CELULAR', '1258859771');
              insert into medicos_telefonos (id_medico, descripcion, telefono) values (15, 'CELULAR', '6862115601');
              insert into medicos_telefonos (id_medico, descripcion, telefono) values (16, 'CELULAR', '9979857588');
              insert into medicos_telefonos (id_medico, descripcion, telefono) values (17, 'FIJO', '1942753354');
              insert into medicos_telefonos (id_medico, descripcion, telefono) values (18, 'CELULAR', '7061917675');
              insert into medicos_telefonos (id_medico, descripcion, telefono) values (19, 'FIJO', '1379517288');
              insert into medicos_telefonos (id_medico, descripcion, telefono) values (20, 'CELULAR', '2992961401');
              insert into medicos_telefonos (id_medico, descripcion, telefono) values (21, 'FIJO', '3136545640');
              insert into medicos_telefonos (id_medico, descripcion, telefono) values (22, 'FIJO', '5544156156');
              insert into medicos_telefonos (id_medico, descripcion, telefono) values (23, 'FIJO', '2678836742');
              insert into medicos_telefonos (id_medico, descripcion, telefono) values (24, 'CELULAR', '4102408024');
              insert into medicos_telefonos (id_medico, descripcion, telefono) values (25, 'CELULAR', '4984817031');
              insert into medicos_telefonos (id_medico, descripcion, telefono) values (26, 'FIJO', '6842369287');
              insert into medicos_telefonos (id_medico, descripcion, telefono) values (27, 'CELULAR', '9314237277');
              insert into medicos_telefonos (id_medico, descripcion, telefono) values (28, 'CELULAR', '5126980020');
              insert into medicos_telefonos (id_medico, descripcion, telefono) values (29, 'CELULAR', '5894449365');
              insert into medicos_telefonos (id_medico, descripcion, telefono) values (30, 'FIJO', '8551230703');
              insert into medicos_telefonos (id_medico, descripcion, telefono) values (31, 'FIJO', '3936927781');
              insert into medicos_telefonos (id_medico, descripcion, telefono) values (32, 'CELULAR', '6365964612');
              insert into medicos_telefonos (id_medico, descripcion, telefono) values (33, 'FIJO', '4955611024');
              insert into medicos_telefonos (id_medico, descripcion, telefono) values (34, 'CELULAR', '8808749410');
              insert into medicos_telefonos (id_medico, descripcion, telefono) values (35, 'CELULAR', '8239956609');
              insert into medicos_telefonos (id_medico, descripcion, telefono) values (36, 'FIJO', '9957385671');
              insert into medicos_telefonos (id_medico, descripcion, telefono) values (37, 'CELULAR', '4196195623');
              insert into medicos_telefonos (id_medico, descripcion, telefono) values (38, 'FIJO', '6631489085');
              insert into medicos_telefonos (id_medico, descripcion, telefono) values (39, 'FIJO', '6005817090');
              insert into medicos_telefonos (id_medico, descripcion, telefono) values (40, 'CELULAR', '7982640409');
              insert into medicos_telefonos (id_medico, descripcion, telefono) values (41, 'CELULAR', '1243203539');
              insert into medicos_telefonos (id_medico, descripcion, telefono) values (42, 'FIJO', '4345172246');
              insert into medicos_telefonos (id_medico, descripcion, telefono) values (43, 'FIJO', '3279629094');
              insert into medicos_telefonos (id_medico, descripcion, telefono) values (44, 'FIJO', '8109419550');
              insert into medicos_telefonos (id_medico, descripcion, telefono) values (45, 'FIJO', '3847773978');
              insert into medicos_telefonos (id_medico, descripcion, telefono) values (46, 'FIJO', '8175700236');
              insert into medicos_telefonos (id_medico, descripcion, telefono) values (47, 'CELULAR', '9499760222');
              insert into medicos_telefonos (id_medico, descripcion, telefono) values (48, 'FIJO', '5346000709');
              insert into medicos_telefonos (id_medico, descripcion, telefono) values (49, 'FIJO', '3132354063');
              insert into medicos_telefonos (id_medico, descripcion, telefono) values (50, 'FIJO', '6342787476');
              insert into medicos_telefonos (id_medico, descripcion, telefono) values (51, 'FIJO', '3807058712');
              insert into medicos_telefonos (id_medico, descripcion, telefono) values (52, 'CELULAR', '1613709370');
              insert into medicos_telefonos (id_medico, descripcion, telefono) values (53, 'CELULAR', '7228028357');
              insert into medicos_telefonos (id_medico, descripcion, telefono) values (54, 'FIJO', '8295640089');
              insert into medicos_telefonos (id_medico, descripcion, telefono) values (55, 'FIJO', '8595852668');
              insert into medicos_telefonos (id_medico, descripcion, telefono) values (56, 'FIJO', '7858303245');
              insert into medicos_telefonos (id_medico, descripcion, telefono) values (57, 'CELULAR', '1431070102');
              insert into medicos_telefonos (id_medico, descripcion, telefono) values (58, 'CELULAR', '4235061126');
              insert into medicos_telefonos (id_medico, descripcion, telefono) values (59, 'FIJO', '8536964913');
              insert into medicos_telefonos (id_medico, descripcion, telefono) values (60, 'FIJO', '6257868393');
              insert into medicos_telefonos (id_medico, descripcion, telefono) values (1, 'CELULAR', '3205201158');
              insert into medicos_telefonos (id_medico, descripcion, telefono) values (32, 'CELULAR', '2143088343');
              insert into medicos_telefonos (id_medico, descripcion, telefono) values (3, 'CELULAR', '5229362894');
              insert into medicos_telefonos (id_medico, descripcion, telefono) values (45, 'FIJO', '6657546629');
              insert into medicos_telefonos (id_medico, descripcion, telefono) values (5, 'CELULAR', '1328381403');
              insert into medicos_telefonos (id_medico, descripcion, telefono) values (60, 'CELULAR', '5561819373');
              insert into medicos_telefonos (id_medico, descripcion, telefono) values (7, 'FIJO', '8278366262');
              insert into medicos_telefonos (id_medico, descripcion, telefono) values (18, 'CELULAR', '1132633850');
              insert into medicos_telefonos (id_medico, descripcion, telefono) values (9, 'FIJO', '6085872577');
              insert into medicos_telefonos (id_medico, descripcion, telefono) values (10, 'FIJO', '6998362634');
              insert into medicos_telefonos (id_medico, descripcion, telefono) values (51, 'CELULAR', '5159611703');
              insert into medicos_telefonos (id_medico, descripcion, telefono) values (22, 'FIJO', '1878707655');
              insert into medicos_telefonos (id_medico, descripcion, telefono) values (3, 'FIJO', '7808712690');
              insert into medicos_telefonos (id_medico, descripcion, telefono) values (24, 'CELULAR', '6323467812');
              insert into medicos_telefonos (id_medico, descripcion, telefono) values (25, 'CELULAR', '3805526109');
              insert into medicos_telefonos (id_medico, descripcion, telefono) values (26, 'CELULAR', '1975366970');
              insert into medicos_telefonos (id_medico, descripcion, telefono) values (47, 'FIJO', '5734667060');
              insert into medicos_telefonos (id_medico, descripcion, telefono) values (48, 'CELULAR', '9896857658');
              insert into medicos_telefonos (id_medico, descripcion, telefono) values (49, 'CELULAR', '8642340066');
              insert into medicos_telefonos (id_medico, descripcion, telefono) values (12, 'CELULAR', '2067034457');
-- PARA CHEQUEAR QUE LOS DATOS SE CARGARON CORRECTAMENTE, PUEDE DESCOMENTAR Y EJECUTAR LA SIGUIENTE LINEA  
-- SELECT * FROM medicos_telefonos;



/*
ESTE SCRIPT INSERTA DATOS EN LA TABLA 'citas_medicas'
*/

-- EN PRIMERA INSTANCIA, INSERTA CITAS EN EL PASADO
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-08-06', '12:21', 'REALIZADA', 7, 15, 42);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-03-22', '15:38', 'CANCELADA', 9, 39, 55);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-02-17', '16:31', 'REALIZADA', 6, 31, 35);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-05-06', '13:10', 'CANCELADA', 7, 11, 59);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-07-05', '15:59', 'REALIZADA', 6, 30, 154);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-08-05', '14:44', 'CANCELADA', 9, 44, 65);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-02-04', '17:22', 'REALIZADA', 7, 11, 98);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-05-27', '12:00', 'REALIZADA', 9, 5, 123);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-05-17', '17:07', 'CANCELADA', 1, 41, 139);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-05-21', '17:00', 'CANCELADA', 9, 38, 126);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-03-22', '16:14', 'CANCELADA', 2, 43, 112);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-01-31', '9:00', 'REALIZADA', 8, 58, 83);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-04-26', '15:34', 'REALIZADA', 9, 18, 138);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-08-16', '14:43', 'REALIZADA', 5, 36, 76);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-07-06', '13:47', 'REALIZADA', 1, 47, 59);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-03-23', '8:36', 'REALIZADA', 1, 58, 15);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-04-09', '15:44', 'REALIZADA', 8, 10, 149);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-03-18', '12:53', 'REALIZADA', 9, 9, 151);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-03-11', '9:36', 'REALIZADA', 7, 54, 79);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-04-05', '13:06', 'REALIZADA', 1, 51, 154);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-02-08', '17:08', 'REALIZADA', 8, 50, 85);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-02-04', '15:24', 'REALIZADA', 5, 39, 52);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-02-18', '16:37', 'CANCELADA', 9, 41, 78);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-05-04', '10:17', 'CANCELADA', 1, 57, 55);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-02-19', '9:57', 'CANCELADA', 2, 11, 79);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-05-03', '8:59', 'REALIZADA', 9, 10, 68);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-02-21', '14:03', 'REALIZADA', 7, 29, 23);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-04-26', '11:49', 'CANCELADA', 8, 55, 2);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-06-28', '13:26', 'CANCELADA', 9, 1, 162);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-06-19', '10:30', 'REALIZADA', 5, 40, 94);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-02-28', '16:11', 'CANCELADA', 3, 32, 12);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-06-24', '17:31', 'CANCELADA', 3, 36, 142);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-01-22', '16:35', 'CANCELADA', 3, 22, 74);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-04-01', '9:21', 'CANCELADA', 6, 32, 31);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-05-22', '13:56', 'REALIZADA', 6, 45, 164);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-01-26', '14:36', 'REALIZADA', 1, 54, 57);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-08-13', '10:49', 'CANCELADA', 5, 44, 4);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-01-18', '16:09', 'CANCELADA', 2, 17, 168);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-04-15', '9:20', 'REALIZADA', 7, 34, 4);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-05-26', '10:22', 'REALIZADA', 3, 27, 75);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-05-12', '17:01', 'CANCELADA', 4, 46, 87);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-02-02', '15:59', 'REALIZADA', 4, 20, 165);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-05-15', '9:12', 'CANCELADA', 5, 23, 89);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-05-02', '10:42', 'CANCELADA', 1, 49, 128);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-04-06', '12:49', 'REALIZADA', 9, 3, 115);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-06-06', '8:46', 'CANCELADA', 1, 46, 73);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-03-12', '10:51', 'REALIZADA', 6, 31, 78);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-06-10', '16:17', 'CANCELADA', 9, 47, 50);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-03-09', '13:55', 'REALIZADA', 7, 51, 10);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-04-03', '14:44', 'CANCELADA', 4, 8, 6);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-02-25', '13:04', 'REALIZADA', 1, 29, 76);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-04-29', '8:55', 'CANCELADA', 9, 45, 3);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-07-17', '9:55', 'CANCELADA', 2, 10, 35);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-08-14', '10:28', 'CANCELADA', 2, 28, 98);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-04-22', '15:53', 'CANCELADA', 1, 54, 139);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-01-17', '16:59', 'REALIZADA', 9, 23, 126);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-07-25', '13:04', 'CANCELADA', 5, 34, 113);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-04-20', '9:54', 'CANCELADA', 9, 55, 85);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-05-10', '17:23', 'REALIZADA', 1, 44, 110);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-04-16', '8:57', 'REALIZADA', 2, 19, 140);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-08-02', '14:46', 'REALIZADA', 7, 32, 53);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-08-03', '10:03', 'CANCELADA', 4, 32, 132);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-02-11', '13:49', 'CANCELADA', 6, 39, 92);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-04-17', '9:21', 'CANCELADA', 3, 48, 8);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-01-22', '17:05', 'REALIZADA', 5, 33, 137);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-04-19', '17:14', 'CANCELADA', 4, 38, 20);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-03-03', '10:42', 'CANCELADA', 7, 1, 150);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-03-05', '17:03', 'REALIZADA', 8, 45, 47);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-02-13', '12:46', 'REALIZADA', 3, 23, 45);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-06-27', '8:33', 'REALIZADA', 8, 42, 137);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-01-11', '9:21', 'REALIZADA', 1, 60, 64);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-07-01', '13:27', 'REALIZADA', 5, 56, 18);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-03-19', '10:20', 'REALIZADA', 3, 43, 132);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-03-12', '8:41', 'REALIZADA', 4, 51, 25);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-07-19', '17:44', 'REALIZADA', 5, 27, 9);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-07-05', '8:41', 'CANCELADA', 3, 36, 15);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-06-02', '10:22', 'CANCELADA', 3, 25, 79);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-04-04', '11:58', 'CANCELADA', 4, 30, 81);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-01-08', '17:08', 'REALIZADA', 7, 16, 140);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-07-30', '14:20', 'CANCELADA', 6, 43, 55);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-03-27', '14:17', 'CANCELADA', 7, 20, 161);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-08-08', '15:13', 'REALIZADA', 6, 35, 84);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-05-26', '12:42', 'REALIZADA', 5, 25, 79);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-06-25', '13:42', 'REALIZADA', 4, 21, 101);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-02-16', '17:45', 'CANCELADA', 5, 33, 47);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-01-10', '16:29', 'REALIZADA', 7, 15, 66);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-02-06', '11:22', 'CANCELADA', 8, 40, 82);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-03-08', '11:39', 'CANCELADA', 1, 47, 88);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-05-12', '13:46', 'REALIZADA', 6, 17, 120);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-02-25', '15:44', 'CANCELADA', 6, 53, 42);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-06-24', '17:45', 'REALIZADA', 2, 22, 56);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-01-30', '16:59', 'REALIZADA', 2, 13, 119);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-01-09', '14:21', 'REALIZADA', 8, 21, 71);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-01-10', '12:46', 'REALIZADA', 2, 6, 6);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-01-31', '15:14', 'REALIZADA', 5, 26, 38);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-01-18', '17:52', 'REALIZADA', 2, 46, 99);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-04-30', '12:32', 'REALIZADA', 6, 52, 149);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-07-23', '13:44', 'CANCELADA', 6, 42, 166);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-01-14', '11:41', 'REALIZADA', 7, 46, 92);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-08-01', '8:38', 'REALIZADA', 4, 24, 92);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-03-05', '15:59', 'REALIZADA', 8, 30, 29);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-02-26', '12:38', 'REALIZADA', 3, 40, 142);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-03-18', '10:04', 'CANCELADA', 2, 32, 170);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-03-12', '15:20', 'CANCELADA', 7, 19, 32);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-03-06', '8:41', 'CANCELADA', 2, 34, 157);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-06-29', '9:16', 'REALIZADA', 5, 3, 42);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-05-14', '12:14', 'REALIZADA', 2, 11, 121);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-05-18', '13:53', 'CANCELADA', 4, 20, 124);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-07-01', '11:40', 'REALIZADA', 4, 21, 8);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-08-04', '9:36', 'CANCELADA', 8, 38, 142);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-06-27', '8:42', 'REALIZADA', 6, 44, 106);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-07-31', '12:23', 'CANCELADA', 2, 20, 77);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-02-08', '9:19', 'CANCELADA', 8, 3, 67);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-04-14', '10:19', 'CANCELADA', 2, 8, 109);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-04-01', '14:09', 'CANCELADA', 9, 34, 117);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-06-22', '9:00', 'CANCELADA', 6, 29, 66);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-05-19', '14:04', 'REALIZADA', 2, 2, 62);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-07-19', '14:22', 'CANCELADA', 2, 9, 101);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-07-11', '9:26', 'CANCELADA', 4, 28, 120);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-07-05', '16:48', 'REALIZADA', 4, 52, 43);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-08-08', '10:01', 'CANCELADA', 9, 20, 81);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-06-19', '9:01', 'CANCELADA', 5, 45, 89);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-05-17', '10:40', 'CANCELADA', 5, 1, 155);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-07-23', '11:09', 'REALIZADA', 3, 23, 107);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-03-20', '11:58', 'CANCELADA', 3, 41, 125);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-05-13', '13:19', 'REALIZADA', 8, 20, 17);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-08-08', '10:56', 'CANCELADA', 5, 24, 159);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-03-01', '16:18', 'REALIZADA', 4, 2, 17);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-02-16', '16:23', 'CANCELADA', 8, 16, 166);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-03-01', '17:33', 'CANCELADA', 8, 24, 67);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-04-20', '12:59', 'REALIZADA', 2, 56, 26);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-06-11', '11:23', 'CANCELADA', 1, 22, 35);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-05-07', '14:55', 'REALIZADA', 3, 20, 38);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-06-15', '9:20', 'REALIZADA', 2, 18, 163);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-08-15', '10:37', 'REALIZADA', 5, 59, 39);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-08-02', '8:44', 'CANCELADA', 9, 46, 109);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-05-08', '13:11', 'CANCELADA', 4, 59, 26);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-07-15', '14:16', 'REALIZADA', 5, 13, 10);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-08-17', '11:15', 'CANCELADA', 1, 30, 99);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-07-30', '9:28', 'CANCELADA', 6, 49, 50);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-03-18', '15:12', 'REALIZADA', 7, 14, 90);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-04-14', '17:40', 'REALIZADA', 9, 4, 137);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-03-28', '17:59', 'REALIZADA', 6, 18, 18);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-04-12', '9:46', 'CANCELADA', 5, 42, 170);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-02-17', '9:29', 'CANCELADA', 9, 19, 59);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-05-22', '14:09', 'CANCELADA', 5, 41, 92);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-06-23', '12:56', 'REALIZADA', 6, 23, 143);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-06-26', '12:29', 'CANCELADA', 5, 13, 159);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-06-02', '17:36', 'REALIZADA', 3, 7, 157);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-03-28', '17:28', 'CANCELADA', 4, 42, 169);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-06-06', '12:21', 'CANCELADA', 5, 29, 155);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-03-01', '13:01', 'REALIZADA', 4, 31, 76);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-02-01', '8:35', 'REALIZADA', 4, 57, 131);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-01-16', '13:41', 'REALIZADA', 7, 24, 168);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-01-10', '11:42', 'REALIZADA', 8, 33, 111);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-02-19', '9:58', 'REALIZADA', 9, 17, 44);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-01-16', '15:35', 'REALIZADA', 2, 55, 159);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-08-09', '8:39', 'REALIZADA', 2, 30, 144);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-06-19', '9:28', 'CANCELADA', 7, 22, 55);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-06-10', '12:29', 'REALIZADA', 2, 39, 162);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-01-25', '16:19', 'REALIZADA', 5, 45, 67);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-01-11', '13:16', 'CANCELADA', 2, 16, 52);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-01-28', '16:15', 'REALIZADA', 4, 22, 27);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-03-19', '9:09', 'REALIZADA', 9, 18, 166);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-03-01', '8:46', 'REALIZADA', 6, 9, 42);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-01-14', '11:12', 'REALIZADA', 9, 26, 161);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-01-16', '15:24', 'CANCELADA', 1, 21, 70);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-04-08', '10:16', 'CANCELADA', 5, 34, 137);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-05-13', '14:29', 'REALIZADA', 4, 59, 55);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-07-09', '16:22', 'REALIZADA', 3, 11, 91);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-03-15', '10:09', 'REALIZADA', 3, 18, 141);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-07-10', '16:09', 'REALIZADA', 4, 36, 101);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-04-12', '14:32', 'REALIZADA', 7, 11, 105);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-05-31', '15:01', 'CANCELADA', 1, 2, 122);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-03-30', '12:17', 'REALIZADA', 1, 29, 77);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-02-01', '9:32', 'REALIZADA', 9, 22, 133);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-06-16', '15:27', 'CANCELADA', 8, 24, 84);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-07-28', '14:16', 'CANCELADA', 3, 45, 118);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-07-17', '9:04', 'REALIZADA', 9, 38, 19);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-07-06', '14:57', 'CANCELADA', 1, 10, 52);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-08-06', '14:13', 'REALIZADA', 5, 25, 116);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-07-18', '17:23', 'REALIZADA', 7, 30, 96);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-02-22', '10:42', 'CANCELADA', 8, 11, 120);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-06-19', '15:42', 'CANCELADA', 6, 15, 66);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-05-02', '9:07', 'REALIZADA', 1, 47, 115);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-03-29', '17:53', 'CANCELADA', 1, 26, 56);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-06-27', '13:35', 'CANCELADA', 6, 15, 106);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-07-09', '9:25', 'REALIZADA', 5, 51, 157);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-05-31', '16:23', 'REALIZADA', 7, 50, 79);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-07-03', '8:54', 'CANCELADA', 7, 24, 45);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-01-27', '10:42', 'CANCELADA', 1, 59, 107);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-03-27', '10:19', 'CANCELADA', 3, 29, 14);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-07-08', '17:43', 'CANCELADA', 6, 40, 41);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-05-08', '16:15', 'REALIZADA', 3, 15, 18);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-06-14', '9:37', 'REALIZADA', 9, 42, 143);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-01-13', '9:45', 'REALIZADA', 3, 54, 61);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-01-24', '15:20', 'REALIZADA', 8, 7, 74);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-06-28', '16:43', 'REALIZADA', 9, 53, 62);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-03-06', '15:35', 'REALIZADA', 4, 55, 50);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-07-25', '11:29', 'REALIZADA', 8, 28, 25);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-02-18', '16:11', 'CANCELADA', 3, 45, 142);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-03-16', '10:50', 'REALIZADA', 6, 16, 84);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-02-05', '10:50', 'CANCELADA', 3, 29, 167);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-01-13', '14:41', 'CANCELADA', 8, 41, 49);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-05-30', '10:32', 'REALIZADA', 5, 29, 76);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-03-26', '14:45', 'REALIZADA', 8, 54, 136);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-06-15', '15:53', 'CANCELADA', 1, 41, 68);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-06-15', '11:27', 'REALIZADA', 9, 50, 139);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-02-05', '17:21', 'CANCELADA', 1, 23, 70);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-02-22', '9:12', 'CANCELADA', 6, 40, 6);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-05-11', '10:47', 'REALIZADA', 5, 36, 135);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-06-21', '10:16', 'CANCELADA', 8, 34, 102);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-05-04', '9:35', 'CANCELADA', 2, 16, 48);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-03-16', '10:24', 'REALIZADA', 6, 26, 114);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-03-28', '10:37', 'REALIZADA', 4, 26, 1);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-08-07', '8:54', 'CANCELADA', 7, 47, 129);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-08-11', '13:32', 'REALIZADA', 2, 17, 10);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-06-01', '17:41', 'REALIZADA', 5, 5, 47);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-05-11', '8:34', 'REALIZADA', 8, 7, 61);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-01-27', '14:27', 'CANCELADA', 8, 54, 71);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-01-08', '16:50', 'REALIZADA', 4, 28, 81);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-04-17', '16:24', 'REALIZADA', 5, 24, 90);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-02-05', '10:50', 'CANCELADA', 2, 46, 119);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-03-04', '17:30', 'REALIZADA', 6, 2, 81);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-04-02', '11:42', 'CANCELADA', 3, 21, 160);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-03-24', '13:05', 'REALIZADA', 3, 20, 132);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-08-06', '9:08', 'REALIZADA', 8, 16, 134);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-06-04', '11:29', 'REALIZADA', 7, 15, 122);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-06-08', '14:32', 'REALIZADA', 4, 47, 41);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-07-11', '16:15', 'CANCELADA', 4, 32, 102);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-07-03', '11:25', 'CANCELADA', 3, 15, 12);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-01-23', '14:52', 'CANCELADA', 6, 8, 77);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-01-29', '10:26', 'CANCELADA', 4, 5, 156);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-03-30', '11:16', 'CANCELADA', 3, 59, 5);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-03-01', '10:00', 'CANCELADA', 1, 10, 107);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-05-21', '12:36', 'REALIZADA', 3, 5, 3);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-06-30', '13:30', 'REALIZADA', 6, 44, 170);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-02-28', '10:07', 'REALIZADA', 3, 31, 146);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-08-06', '13:23', 'CANCELADA', 5, 23, 31);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-04-09', '14:43', 'CANCELADA', 7, 57, 43);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-03-09', '12:30', 'REALIZADA', 7, 23, 68);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-01-23', '13:45', 'CANCELADA', 8, 7, 73);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-06-22', '14:37', 'REALIZADA', 7, 51, 97);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-07-20', '12:53', 'REALIZADA', 2, 23, 166);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-05-26', '11:22', 'CANCELADA', 7, 25, 101);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-01-08', '16:32', 'CANCELADA', 5, 26, 83);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-01-19', '13:11', 'CANCELADA', 3, 30, 105);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-06-03', '13:55', 'CANCELADA', 1, 17, 138);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-05-27', '14:45', 'CANCELADA', 7, 39, 53);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-03-04', '12:15', 'REALIZADA', 1, 40, 26);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-02-11', '17:59', 'CANCELADA', 4, 26, 131);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-07-19', '10:33', 'CANCELADA', 7, 21, 135);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-06-18', '13:19', 'CANCELADA', 9, 10, 15);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-03-01', '13:26', 'REALIZADA', 5, 60, 152);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-03-20', '17:45', 'CANCELADA', 2, 32, 159);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-05-11', '15:59', 'CANCELADA', 6, 53, 148);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-02-10', '10:34', 'CANCELADA', 9, 3, 121);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-02-13', '9:02', 'REALIZADA', 9, 17, 45);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-07-07', '17:44', 'CANCELADA', 2, 8, 133);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-02-25', '12:00', 'CANCELADA', 7, 16, 142);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-08-01', '10:59', 'REALIZADA', 3, 31, 133);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-06-23', '14:11', 'CANCELADA', 1, 32, 67);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-05-05', '13:43', 'CANCELADA', 4, 12, 70);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-01-30', '17:02', 'CANCELADA', 6, 51, 137);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-07-01', '16:35', 'REALIZADA', 6, 17, 72);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-07-03', '11:58', 'CANCELADA', 7, 9, 111);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-03-20', '9:18', 'CANCELADA', 4, 33, 114);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-08-12', '10:02', 'CANCELADA', 6, 30, 25);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-07-06', '9:48', 'CANCELADA', 1, 36, 111);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-04-09', '10:01', 'CANCELADA', 8, 45, 158);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-04-23', '9:58', 'REALIZADA', 8, 19, 162);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-01-27', '17:08', 'CANCELADA', 7, 34, 46);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-06-13', '10:39', 'REALIZADA', 4, 27, 47);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-05-20', '12:51', 'CANCELADA', 4, 31, 141);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-04-25', '14:42', 'REALIZADA', 1, 13, 30);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-02-28', '12:26', 'REALIZADA', 5, 17, 71);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-07-22', '15:34', 'CANCELADA', 1, 8, 27);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-01-09', '8:46', 'REALIZADA', 7, 4, 34);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-02-27', '10:40', 'CANCELADA', 3, 53, 137);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-02-02', '16:13', 'CANCELADA', 6, 33, 78);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-02-11', '10:49', 'REALIZADA', 3, 31, 137);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-05-13', '15:15', 'CANCELADA', 4, 57, 133);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-01-25', '11:51', 'REALIZADA', 3, 42, 48);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-05-15', '11:36', 'CANCELADA', 6, 25, 101);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-06-16', '12:25', 'CANCELADA', 4, 5, 167);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-05-08', '13:18', 'CANCELADA', 7, 40, 166);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-03-13', '13:37', 'CANCELADA', 7, 35, 49);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-02-24', '12:32', 'REALIZADA', 8, 21, 110);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-06-27', '9:09', 'REALIZADA', 8, 21, 124);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-01-29', '13:21', 'CANCELADA', 9, 24, 99);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-03-31', '11:46', 'REALIZADA', 4, 29, 25);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-08-14', '8:47', 'REALIZADA', 8, 40, 19);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-08-16', '11:35', 'CANCELADA', 2, 7, 77);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-08-07', '15:15', 'CANCELADA', 7, 34, 157);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-03-18', '17:41', 'REALIZADA', 4, 7, 51);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-06-08', '17:24', 'CANCELADA', 3, 30, 44);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-07-28', '16:50', 'REALIZADA', 4, 23, 19);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-07-22', '15:25', 'REALIZADA', 9, 20, 53);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-03-17', '14:52', 'CANCELADA', 5, 16, 159);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-01-21', '11:35', 'CANCELADA', 9, 35, 166);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-03-08', '16:05', 'CANCELADA', 7, 43, 17);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-01-21', '15:52', 'REALIZADA', 7, 48, 157);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-07-26', '11:40', 'REALIZADA', 4, 56, 121);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-03-11', '14:57', 'CANCELADA', 9, 28, 35);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-01-21', '10:43', 'CANCELADA', 7, 58, 146);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-07-19', '9:07', 'REALIZADA', 4, 52, 158);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-07-31', '13:49', 'CANCELADA', 6, 23, 46);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-03-29', '15:06', 'REALIZADA', 8, 52, 46);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-05-28', '17:45', 'REALIZADA', 3, 58, 102);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-07-03', '9:43', 'REALIZADA', 5, 39, 147);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-01-22', '14:55', 'CANCELADA', 1, 41, 16);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-06-16', '13:48', 'REALIZADA', 8, 25, 152);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-02-24', '14:54', 'CANCELADA', 4, 39, 52);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-04-10', '10:49', 'CANCELADA', 8, 21, 124);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-04-12', '16:04', 'REALIZADA', 3, 29, 16);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-05-24', '13:13', 'CANCELADA', 4, 32, 32);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-02-19', '14:57', 'CANCELADA', 9, 43, 76);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-08-15', '10:00', 'CANCELADA', 8, 12, 30);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-07-15', '17:54', 'REALIZADA', 3, 57, 129);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-04-09', '9:38', 'CANCELADA', 4, 43, 158);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-07-23', '14:37', 'REALIZADA', 9, 13, 133);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-03-12', '15:01', 'REALIZADA', 9, 13, 50);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-07-11', '14:52', 'REALIZADA', 6, 21, 162);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-06-19', '9:16', 'CANCELADA', 6, 5, 127);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-08-02', '13:36', 'REALIZADA', 6, 37, 50);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-08-01', '15:53', 'REALIZADA', 4, 12, 88);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-04-17', '13:43', 'CANCELADA', 8, 47, 63);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-06-28', '17:48', 'CANCELADA', 5, 2, 54);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-06-15', '12:08', 'CANCELADA', 9, 4, 81);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-05-21', '13:58', 'REALIZADA', 8, 30, 24);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-08-15', '17:21', 'CANCELADA', 8, 25, 49);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-06-25', '15:39', 'CANCELADA', 2, 59, 129);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-06-11', '9:06', 'CANCELADA', 8, 26, 144);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-08-16', '14:52', 'REALIZADA', 2, 39, 90);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-03-13', '13:21', 'CANCELADA', 4, 4, 149);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-07-12', '13:26', 'CANCELADA', 4, 41, 128);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-04-19', '15:51', 'REALIZADA', 4, 5, 166);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-02-09', '9:44', 'CANCELADA', 5, 47, 164);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-01-13', '9:03', 'REALIZADA', 1, 7, 93);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-07-15', '15:17', 'CANCELADA', 5, 18, 66);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-07-24', '10:57', 'CANCELADA', 4, 4, 128);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-07-12', '12:13', 'CANCELADA', 8, 47, 56);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-03-09', '10:08', 'REALIZADA', 6, 55, 146);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-05-28', '13:26', 'CANCELADA', 5, 35, 82);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-06-23', '15:19', 'REALIZADA', 8, 40, 166);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-03-26', '17:45', 'CANCELADA', 9, 33, 7);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-01-23', '14:00', 'REALIZADA', 2, 9, 99);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-03-13', '13:20', 'REALIZADA', 6, 44, 54);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-02-21', '9:23', 'CANCELADA', 1, 32, 39);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-01-27', '10:45', 'REALIZADA', 2, 2, 103);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-01-25', '17:59', 'REALIZADA', 9, 37, 94);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-02-23', '9:43', 'REALIZADA', 5, 42, 101);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-04-16', '15:47', 'CANCELADA', 1, 54, 162);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-01-18', '9:35', 'REALIZADA', 9, 33, 112);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-04-06', '12:24', 'CANCELADA', 1, 9, 48);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-04-09', '10:14', 'CANCELADA', 1, 8, 105);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-06-08', '9:13', 'CANCELADA', 3, 43, 90);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-01-21', '16:22', 'CANCELADA', 9, 22, 50);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-01-24', '12:00', 'REALIZADA', 2, 10, 111);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-03-14', '8:41', 'REALIZADA', 3, 26, 117);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-05-05', '15:26', 'CANCELADA', 8, 34, 59);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-03-23', '15:14', 'CANCELADA', 1, 18, 54);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-08-10', '15:19', 'REALIZADA', 3, 31, 79);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-05-25', '17:33', 'CANCELADA', 5, 3, 16);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-07-19', '12:18', 'REALIZADA', 3, 57, 94);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-06-18', '9:06', 'CANCELADA', 7, 26, 101);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-06-04', '16:04', 'CANCELADA', 8, 35, 147);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-07-30', '11:58', 'REALIZADA', 8, 17, 73);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-05-23', '12:00', 'CANCELADA', 3, 46, 63);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-07-21', '9:36', 'REALIZADA', 3, 49, 72);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-03-17', '11:31', 'CANCELADA', 5, 4, 164);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-06-13', '9:34', 'REALIZADA', 2, 35, 146);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-03-03', '17:53', 'CANCELADA', 5, 47, 75);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-04-22', '10:46', 'CANCELADA', 5, 20, 26);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-01-14', '16:06', 'CANCELADA', 8, 37, 120);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-07-01', '8:59', 'REALIZADA', 4, 9, 16);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-07-21', '16:49', 'CANCELADA', 9, 9, 152);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-05-24', '17:35', 'CANCELADA', 2, 47, 117);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-07-12', '15:00', 'REALIZADA', 2, 50, 133);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-01-29', '8:30', 'CANCELADA', 3, 13, 81);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-04-20', '16:43', 'CANCELADA', 4, 13, 154);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-08-05', '15:07', 'REALIZADA', 7, 5, 110);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-04-06', '12:14', 'REALIZADA', 9, 13, 5);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-07-23', '11:55', 'CANCELADA', 6, 12, 29);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-03-31', '11:38', 'REALIZADA', 5, 45, 4);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-08-11', '15:47', 'REALIZADA', 3, 10, 38);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-05-14', '16:56', 'REALIZADA', 4, 18, 37);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-05-09', '14:00', 'REALIZADA', 9, 39, 38);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-07-19', '14:59', 'CANCELADA', 9, 28, 137);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-02-27', '15:22', 'REALIZADA', 2, 24, 100);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-08-06', '10:32', 'CANCELADA', 3, 45, 167);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-02-27', '17:02', 'REALIZADA', 3, 54, 108);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-08-16', '9:09', 'CANCELADA', 3, 8, 60);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-03-07', '14:55', 'CANCELADA', 7, 39, 68);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-05-11', '17:59', 'REALIZADA', 9, 35, 21);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-01-13', '8:59', 'REALIZADA', 2, 20, 83);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-06-10', '11:34', 'CANCELADA', 3, 54, 157);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-08-01', '11:45', 'REALIZADA', 1, 57, 57);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-04-17', '16:05', 'CANCELADA', 7, 51, 38);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-03-11', '16:11', 'CANCELADA', 3, 47, 105);

-- INSERTA CITAS EN EL FUTURO
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-11-04', '12:49', 'PENDIENTE', 5, 13, 10);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-11-07', '13:18', 'PENDIENTE', 8, 29, 5);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-11-18', '10:05', 'PENDIENTE', 1, 30, 20);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-09-09', '14:32', 'PENDIENTE', 8, 19, 138);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-11-03', '10:26', 'PENDIENTE', 3, 16, 164);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-12-05', '10:23', 'PENDIENTE', 2, 30, 2);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-10-21', '9:38', 'PENDIENTE', 1, 37, 117);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-09-05', '15:05', 'PENDIENTE', 7, 16, 12);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-11-05', '8:46', 'PENDIENTE', 5, 21, 19);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-09-22', '15:52', 'PENDIENTE', 5, 12, 151);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-10-22', '10:23', 'PENDIENTE', 1, 55, 76);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-10-18', '13:49', 'PENDIENTE', 1, 53, 59);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-09-17', '15:51', 'PENDIENTE', 9, 29, 162);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-10-15', '9:28', 'PENDIENTE', 2, 42, 38);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-11-29', '10:43', 'PENDIENTE', 1, 58, 154);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-12-16', '12:37', 'PENDIENTE', 7, 48, 68);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-09-11', '12:43', 'PENDIENTE', 7, 37, 18);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-08-31', '16:29', 'PENDIENTE', 6, 32, 149);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-09-29', '10:47', 'PENDIENTE', 4, 58, 77);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-12-10', '17:10', 'PENDIENTE', 7, 43, 141);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-12-14', '16:03', 'PENDIENTE', 4, 57, 140);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-10-31', '16:11', 'PENDIENTE', 8, 45, 32);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-09-02', '15:01', 'PENDIENTE', 6, 14, 58);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-12-10', '16:32', 'PENDIENTE', 5, 11, 16);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-09-20', '13:44', 'PENDIENTE', 5, 22, 95);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-10-21', '12:10', 'PENDIENTE', 9, 56, 109);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-10-02', '11:58', 'PENDIENTE', 5, 6, 37);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-09-19', '12:55', 'PENDIENTE', 9, 50, 92);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-09-17', '11:39', 'PENDIENTE', 9, 33, 113);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-09-25', '8:36', 'PENDIENTE', 5, 42, 22);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-10-31', '12:05', 'PENDIENTE', 6, 37, 121);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-11-12', '13:06', 'PENDIENTE', 2, 5, 103);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-10-10', '11:33', 'PENDIENTE', 3, 48, 9);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-10-16', '11:10', 'PENDIENTE', 7, 32, 42);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-09-28', '11:35', 'PENDIENTE', 4, 59, 152);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-09-22', '9:55', 'PENDIENTE', 7, 42, 36);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-11-30', '9:26', 'PENDIENTE', 9, 32, 57);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-11-04', '17:18', 'PENDIENTE', 5, 34, 150);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-10-15', '15:35', 'PENDIENTE', 6, 54, 2);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-10-20', '17:12', 'PENDIENTE', 5, 44, 20);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-09-19', '10:36', 'PENDIENTE', 3, 39, 125);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-09-19', '10:22', 'PENDIENTE', 7, 12, 53);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-09-21', '14:37', 'PENDIENTE', 2, 17, 140);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-11-06', '16:15', 'PENDIENTE', 4, 47, 115);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-09-12', '17:20', 'PENDIENTE', 7, 58, 23);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-09-13', '15:34', 'PENDIENTE', 7, 45, 157);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-08-31', '11:27', 'PENDIENTE', 1, 40, 42);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-09-23', '15:48', 'PENDIENTE', 6, 34, 142);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-12-08', '11:36', 'PENDIENTE', 4, 37, 88);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-10-12', '13:53', 'PENDIENTE', 8, 40, 151);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-11-25', '10:24', 'PENDIENTE', 9, 47, 63);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-10-06', '10:00', 'PENDIENTE', 9, 30, 118);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-11-16', '10:26', 'PENDIENTE', 9, 2, 98);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-12-13', '13:48', 'PENDIENTE', 9, 46, 79);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-11-06', '13:35', 'PENDIENTE', 2, 43, 48);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-11-01', '15:00', 'PENDIENTE', 3, 4, 9);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-09-16', '12:27', 'PENDIENTE', 3, 22, 142);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-10-20', '10:15', 'PENDIENTE', 9, 39, 111);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-11-25', '10:11', 'PENDIENTE', 9, 9, 116);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-12-14', '16:48', 'PENDIENTE', 8, 35, 104);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-08-28', '13:13', 'PENDIENTE', 6, 5, 28);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-09-26', '14:32', 'PENDIENTE', 6, 11, 3);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-08-31', '12:37', 'PENDIENTE', 7, 2, 81);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-11-26', '15:55', 'PENDIENTE', 2, 47, 67);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-12-09', '11:45', 'PENDIENTE', 5, 33, 125);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-10-08', '11:33', 'PENDIENTE', 5, 29, 62);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-11-14', '10:31', 'PENDIENTE', 3, 23, 160);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-10-12', '13:33', 'PENDIENTE', 7, 13, 120);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-11-01', '14:02', 'PENDIENTE', 9, 41, 25);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-10-25', '17:47', 'PENDIENTE', 1, 23, 135);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-11-11', '17:38', 'PENDIENTE', 8, 19, 168);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-11-28', '15:45', 'PENDIENTE', 2, 11, 124);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-09-18', '16:38', 'PENDIENTE', 5, 58, 92);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-09-24', '9:13', 'PENDIENTE', 4, 32, 134);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-12-08', '9:36', 'PENDIENTE', 1, 6, 137);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-12-15', '9:03', 'PENDIENTE', 8, 35, 105);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-10-01', '14:32', 'PENDIENTE', 2, 44, 120);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-11-03', '8:55', 'PENDIENTE', 4, 15, 130);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-11-10', '14:00', 'PENDIENTE', 5, 37, 79);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-10-10', '11:13', 'PENDIENTE', 1, 53, 4);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-09-08', '17:22', 'PENDIENTE', 4, 50, 49);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-10-23', '17:09', 'PENDIENTE', 1, 50, 154);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-09-13', '17:04', 'PENDIENTE', 7, 49, 134);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-09-28', '9:42', 'PENDIENTE', 9, 39, 52);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-12-07', '11:49', 'PENDIENTE', 8, 20, 5);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-10-01', '9:26', 'PENDIENTE', 3, 44, 124);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-12-07', '14:58', 'PENDIENTE', 3, 53, 110);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-12-10', '17:12', 'PENDIENTE', 1, 40, 162);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-11-16', '10:33', 'PENDIENTE', 3, 13, 117);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-10-30', '12:41', 'PENDIENTE', 4, 6, 168);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-11-04', '10:45', 'PENDIENTE', 6, 60, 164);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-10-11', '11:12', 'PENDIENTE', 9, 20, 10);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-11-24', '17:11', 'PENDIENTE', 7, 22, 130);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-12-18', '16:31', 'PENDIENTE', 2, 16, 92);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-11-23', '17:47', 'PENDIENTE', 4, 26, 95);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-12-05', '15:47', 'PENDIENTE', 6, 14, 44);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-09-03', '9:25', 'PENDIENTE', 8, 51, 148);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-11-04', '15:52', 'PENDIENTE', 6, 28, 15);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-11-21', '12:49', 'PENDIENTE', 5, 1, 105);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-12-11', '9:27', 'PENDIENTE', 3, 53, 149);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-09-23', '13:41', 'PENDIENTE', 8, 40, 25);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-11-20', '9:20', 'PENDIENTE', 4, 38, 154);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-10-07', '15:49', 'PENDIENTE', 4, 43, 67);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-12-13', '10:38', 'PENDIENTE', 8, 45, 36);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-10-13', '9:48', 'PENDIENTE', 5, 22, 144);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-10-12', '9:59', 'PENDIENTE', 9, 52, 168);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-09-09', '10:16', 'PENDIENTE', 9, 25, 1);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-10-07', '14:38', 'PENDIENTE', 1, 51, 19);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-10-15', '16:19', 'PENDIENTE', 4, 17, 126);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-08-31', '9:02', 'PENDIENTE', 9, 45, 158);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-09-24', '16:05', 'PENDIENTE', 9, 22, 154);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-12-07', '11:23', 'PENDIENTE', 1, 11, 133);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-12-15', '12:44', 'PENDIENTE', 8, 14, 74);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-11-14', '15:18', 'PENDIENTE', 5, 52, 140);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-10-09', '9:11', 'PENDIENTE', 5, 40, 40);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-12-06', '11:57', 'PENDIENTE', 8, 49, 7);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-11-30', '8:56', 'PENDIENTE', 7, 55, 125);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-10-10', '13:41', 'PENDIENTE', 2, 16, 13);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-10-29', '12:19', 'PENDIENTE', 2, 26, 153);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-12-18', '9:00', 'PENDIENTE', 4, 20, 47);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-10-12', '8:40', 'PENDIENTE', 2, 22, 8);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-11-23', '15:41', 'PENDIENTE', 3, 4, 119);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-10-24', '16:04', 'PENDIENTE', 7, 37, 58);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-09-14', '14:33', 'PENDIENTE', 3, 38, 102);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-10-05', '9:28', 'PENDIENTE', 5, 52, 85);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-11-12', '10:32', 'PENDIENTE', 2, 35, 64);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-12-07', '14:32', 'PENDIENTE', 2, 46, 119);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-11-09', '14:05', 'PENDIENTE', 8, 50, 19);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-11-04', '10:51', 'PENDIENTE', 9, 1, 161);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-12-14', '13:06', 'PENDIENTE', 9, 27, 127);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-10-20', '16:28', 'PENDIENTE', 5, 58, 50);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-11-23', '17:33', 'PENDIENTE', 4, 9, 67);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-09-14', '17:43', 'PENDIENTE', 9, 55, 27);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-09-27', '9:56', 'PENDIENTE', 7, 60, 151);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-10-12', '16:09', 'PENDIENTE', 2, 41, 134);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-10-21', '10:57', 'PENDIENTE', 1, 57, 19);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-09-11', '12:51', 'PENDIENTE', 7, 38, 51);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-08-29', '13:49', 'PENDIENTE', 2, 24, 159);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-11-27', '15:35', 'PENDIENTE', 6, 53, 121);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-11-01', '10:37', 'PENDIENTE', 6, 18, 50);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-10-27', '17:48', 'PENDIENTE', 6, 45, 137);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-11-16', '12:41', 'PENDIENTE', 6, 49, 22);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-10-31', '15:34', 'PENDIENTE', 2, 2, 33);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-11-13', '13:45', 'PENDIENTE', 3, 57, 92);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-10-17', '10:14', 'PENDIENTE', 9, 59, 16);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-11-15', '17:46', 'PENDIENTE', 5, 29, 41);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-10-19', '16:01', 'PENDIENTE', 6, 19, 57);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-09-07', '14:07', 'PENDIENTE', 4, 19, 44);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-09-26', '17:35', 'PENDIENTE', 9, 21, 32);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-10-13', '16:27', 'PENDIENTE', 2, 41, 80);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-11-19', '15:22', 'PENDIENTE', 8, 24, 96);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-10-20', '16:29', 'PENDIENTE', 1, 37, 47);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-11-22', '17:29', 'PENDIENTE', 7, 43, 61);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-10-08', '15:43', 'PENDIENTE', 2, 6, 39);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-10-29', '11:55', 'PENDIENTE', 3, 32, 80);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-11-04', '13:06', 'PENDIENTE', 6, 25, 39);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-09-14', '13:18', 'PENDIENTE', 2, 13, 133);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-10-31', '14:52', 'PENDIENTE', 6, 29, 152);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-12-12', '8:45', 'PENDIENTE', 8, 31, 36);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-09-17', '17:04', 'PENDIENTE', 9, 12, 45);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-11-29', '9:04', 'PENDIENTE', 5, 28, 133);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-09-04', '13:27', 'PENDIENTE', 5, 2, 71);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-12-15', '12:32', 'PENDIENTE', 8, 12, 110);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-10-28', '13:38', 'PENDIENTE', 7, 9, 108);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-10-21', '12:13', 'PENDIENTE', 7, 13, 116);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-10-02', '12:37', 'PENDIENTE', 1, 50, 111);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-11-27', '13:06', 'PENDIENTE', 5, 9, 30);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-12-10', '11:05', 'PENDIENTE', 7, 27, 151);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-09-24', '17:10', 'PENDIENTE', 3, 21, 1);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-09-11', '10:03', 'PENDIENTE', 5, 50, 86);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-12-06', '13:37', 'PENDIENTE', 6, 47, 127);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-11-07', '8:56', 'PENDIENTE', 7, 58, 149);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-09-15', '11:49', 'PENDIENTE', 1, 17, 170);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-11-12', '11:39', 'PENDIENTE', 8, 30, 51);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-12-12', '15:31', 'PENDIENTE', 7, 7, 124);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-11-28', '8:31', 'PENDIENTE', 3, 49, 129);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-11-22', '16:34', 'PENDIENTE', 7, 58, 69);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-12-10', '17:19', 'PENDIENTE', 2, 19, 94);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-12-02', '11:10', 'PENDIENTE', 5, 25, 167);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-11-02', '12:22', 'PENDIENTE', 8, 43, 65);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-10-13', '12:36', 'PENDIENTE', 4, 60, 69);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-12-15', '13:14', 'PENDIENTE', 3, 15, 86);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-10-27', '11:13', 'PENDIENTE', 2, 2, 126);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-11-04', '11:46', 'PENDIENTE', 2, 37, 114);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-11-30', '11:35', 'PENDIENTE', 5, 41, 167);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-11-11', '14:56', 'PENDIENTE', 5, 44, 22);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-11-04', '9:48', 'PENDIENTE', 7, 48, 142);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-10-24', '10:02', 'PENDIENTE', 8, 36, 92);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-11-03', '9:29', 'PENDIENTE', 6, 13, 145);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-09-12', '13:45', 'PENDIENTE', 5, 29, 121);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-12-14', '8:31', 'PENDIENTE', 8, 33, 52);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-11-18', '14:00', 'PENDIENTE', 5, 38, 143);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-12-19', '17:45', 'PENDIENTE', 2, 59, 69);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-11-03', '9:01', 'PENDIENTE', 3, 13, 89);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-11-13', '17:23', 'PENDIENTE', 7, 5, 157);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-12-10', '9:23', 'PENDIENTE', 1, 4, 137);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-09-24', '11:28', 'PENDIENTE', 3, 35, 48);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-12-07', '9:55', 'PENDIENTE', 1, 34, 54);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-08-30', '17:30', 'PENDIENTE', 1, 1, 151);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-10-19', '14:57', 'PENDIENTE', 9, 60, 137);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-10-20', '10:30', 'PENDIENTE', 8, 60, 92);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-09-27', '16:10', 'PENDIENTE', 9, 33, 68);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-10-15', '17:23', 'PENDIENTE', 1, 32, 83);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-09-20', '9:19', 'PENDIENTE', 2, 54, 106);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-12-19', '10:00', 'PENDIENTE', 4, 31, 143);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-09-22', '13:25', 'PENDIENTE', 6, 39, 9);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-09-13', '14:11', 'PENDIENTE', 2, 14, 99);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-12-02', '13:07', 'PENDIENTE', 4, 22, 158);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-09-25', '12:24', 'PENDIENTE', 6, 22, 89);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-08-29', '12:29', 'PENDIENTE', 7, 22, 5);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-11-21', '11:59', 'PENDIENTE', 8, 35, 65);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-12-11', '9:41', 'PENDIENTE', 7, 12, 61);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-09-23', '13:09', 'PENDIENTE', 8, 48, 120);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-12-17', '12:21', 'PENDIENTE', 5, 27, 28);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-11-22', '11:03', 'PENDIENTE', 8, 23, 120);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-09-25', '8:42', 'PENDIENTE', 3, 3, 123);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-12-03', '10:20', 'PENDIENTE', 6, 4, 138);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-09-20', '15:33', 'PENDIENTE', 8, 38, 123);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-10-26', '10:54', 'PENDIENTE', 3, 42, 116);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-09-03', '11:05', 'PENDIENTE', 8, 24, 160);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-11-13', '12:13', 'PENDIENTE', 3, 48, 161);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-10-23', '9:08', 'PENDIENTE', 2, 7, 32);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-09-19', '10:57', 'PENDIENTE', 5, 49, 42);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-12-18', '15:19', 'PENDIENTE', 1, 55, 108);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-12-12', '14:42', 'PENDIENTE', 9, 30, 96);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-12-06', '11:14', 'PENDIENTE', 1, 10, 20);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-12-08', '15:51', 'PENDIENTE', 2, 42, 83);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-10-01', '14:17', 'PENDIENTE', 9, 9, 23);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-12-09', '11:06', 'PENDIENTE', 5, 56, 68);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-12-03', '17:55', 'PENDIENTE', 1, 53, 95);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-12-16', '13:36', 'PENDIENTE', 1, 43, 71);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-09-28', '11:45', 'PENDIENTE', 6, 11, 81);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-10-31', '15:12', 'PENDIENTE', 9, 4, 22);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-09-13', '11:23', 'PENDIENTE', 3, 30, 132);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-11-07', '15:14', 'PENDIENTE', 2, 26, 18);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-09-04', '10:15', 'PENDIENTE', 8, 59, 141);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-09-22', '8:30', 'PENDIENTE', 5, 40, 33);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-12-08', '11:00', 'PENDIENTE', 1, 30, 135);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-09-07', '16:27', 'PENDIENTE', 7, 5, 57);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-11-21', '11:17', 'PENDIENTE', 9, 32, 74);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-10-18', '17:31', 'PENDIENTE', 5, 3, 5);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-11-08', '10:31', 'PENDIENTE', 4, 53, 44);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-08-30', '10:34', 'PENDIENTE', 1, 21, 58);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-12-13', '10:07', 'PENDIENTE', 8, 9, 66);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-10-28', '16:19', 'PENDIENTE', 2, 3, 161);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-10-23', '12:03', 'PENDIENTE', 6, 55, 42);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-11-06', '10:54', 'PENDIENTE', 7, 18, 8);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-10-27', '8:58', 'PENDIENTE', 1, 3, 18);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-11-09', '17:02', 'PENDIENTE', 9, 37, 63);
              insert into citas_medicas (fecha, hora, estado, id_administrativo, id_medico, id_paciente) values ('2023-10-04', '12:43', 'PENDIENTE', 8, 17, 120);
-- PARA CHEQUEAR QUE LOS DATOS HAYAN SIDO CARGADOS CORRECTAMENTE, DESCOMENTAR Y EJECUTAR LA SIGUIENTE LÍNEA
-- SELECT * FROM citas_medicas



--  ESTE SCRIPT CARGA DATOS A LA TABLA 'obras_sociales' Y LA TABLA 'datos_obras_sociales'

-- INSERCIÓN DE DATOS EN LA TABLA 'obras_sociales'
              insert into obras_sociales (nombre, domicilio) values ('OSDE', '0577 Randy Alley');
              insert into obras_sociales (nombre, domicilio) values ('Swiss Medical', '5328 Old Shore Way');
              insert into obras_sociales (nombre, domicilio) values ('Galeno', '97685 Spenser Way');
              insert into obras_sociales (nombre, domicilio) values ('Medicus', '2 Dunning Parkway');
              insert into obras_sociales (nombre, domicilio) values ('IOMA (Instituto de Obra Médico Asistencial)', '02565 Forest Dale Parkway');
              insert into obras_sociales (nombre, domicilio) values ('OSECAC (Obra Social de Empleados de Comercio y Actividades Civiles)', '27 Dixon Junction');
              insert into obras_sociales (nombre, domicilio) values ('PAMI (Programa de Atención Médica Integral)', '80082 Eastlawn Parkway');
              insert into obras_sociales (nombre, domicilio) values ('IAPOS (Instituto Autárquico Provincial de Obra Social)', '520 Corscot Road');
              insert into obras_sociales (nombre, domicilio) values ('Sancor Salud', '65 Cordelia Terrace');
              insert into obras_sociales (nombre, domicilio) values ('Accord Salud', '8 1st Plaza');
              insert into obras_sociales (nombre, domicilio) values ('AMEPA (Asociación Mutual de Empleados del Poder Judicial)', '26 Division Crossing');
              insert into obras_sociales (nombre, domicilio) values ('OSPAT (Obra Social del Personal de la Actividad del Turf)', '42 Shasta Court');
              insert into obras_sociales (nombre, domicilio) values ('SADAIC (Sociedad Argentina de Autores y Compositores de Música)', '288 Carpenter Point');
              insert into obras_sociales (nombre, domicilio) values ('DASPU (Dirección de Asistencia Social del Personal Universitario)', '38040 Cardinal Hill');
              insert into obras_sociales (nombre, domicilio) values ('Obra Social de la Universidad Nacional de Córdoba', '1359 Myrtle Hill');
              insert into obras_sociales (nombre, domicilio) values ('UOM (Unión Obrera Metalúrgica)', '981 Del Sol Junction');
              insert into obras_sociales (nombre, domicilio) values ('UOCRA (Unión Obrera de la Construcción de la República Argentina)', '45800 Talisman Plaza');
              insert into obras_sociales (nombre, domicilio) values ('Obras Sociales Provinciales (varias según cada provincia)', '17762 Grim Parkway');
              insert into obras_sociales (nombre, domicilio) values ('AMFFA (Asociación Mutual de los Ferroviarios Argentinos)', '944 Mccormick Circle');
              insert into obras_sociales (nombre, domicilio) values ('OSPA (Obra Social del Personal de la Actividad Aseguradora)', '80004 Russell Lane');
              insert into obras_sociales (nombre, domicilio) values ('OSPRERA (Obra Social de los Empleados de la República Argentina)', '183 Marcy Crossing');
              insert into obras_sociales (nombre, domicilio) values ('OSFFENTOS (Obra Social Ferroviaria de Fomento)', '994 Bartillon Lane');
              insert into obras_sociales (nombre, domicilio) values ('IPAUSS (Instituto Provincial Autárquico Unificado de Seguridad Social)', '84940 Lake View Hill');
              insert into obras_sociales (nombre, domicilio) values ('OSPJN (Obra Social del Poder Judicial de la Nación)', '2866 Ryan Plaza');
              insert into obras_sociales (nombre, domicilio) values ('Caja de Servicios Sociales de la Universidad Nacional del Sur', '8 Fuller Terrace');
              insert into obras_sociales (nombre, domicilio) values ('IAPS (Instituto de Asistencia Social del Neuquén)', '63 Dunning Circle');
              insert into obras_sociales (nombre, domicilio) values ('OSEF (Obra Social del Estado Fueguino)', '470 Westport Crossing');
              insert into obras_sociales (nombre, domicilio) values ('AMP (Asociación Mutual del Personal de la Universidad Nacional de Tucumán)', '562 Reindahl Lane');
              insert into obras_sociales (nombre, domicilio) values ('OSMATA (Obra Social del Personal de la Industria Azucarera)', '2164 Fulton Court');
              insert into obras_sociales (nombre, domicilio) values ('OSPEDYC (Obra Social de Entidades Deportivas y Civiles)', '593 Hintze Crossing');
              insert into obras_sociales (nombre, domicilio) values ('UPCN (Unión del Personal Civil de la Nación)', '97 Center Hill');
              insert into obras_sociales (nombre, domicilio) values ('OSMATA (Obra Social del Personal de la Actividad del Turf)', '47354 Doe Crossing Junction');
              insert into obras_sociales (nombre, domicilio) values ('OSPATCA (Obra Social del Personal Auxiliar de Casas Particulares)', '968 Holy Cross Park');
              insert into obras_sociales (nombre, domicilio) values ('OSPV (Obra Social de Petroleros y Gas Privado de la Patagonia Austral)', '9908 Elmside Pass');
              insert into obras_sociales (nombre, domicilio) values ('Obra Social Bancaria Argentina', '602 Service Parkway');
-- PARA CHEQUEAR QUE LOS DATOS HAYAN SIDO CARGADOS CORRECTAMENTE, DESCOMENTAR Y EJECUTAR LA SIGUIENTE LÍNEA
-- SELECT * FROM obras_sociales;

-- INSERCIÓN DE DATOS A TABLA 'datos_obras_sociales'

            insert into datos_obras_sociales (id_obra_social, telefono, descripcion_telefono, correo_electronico, descripcion_correo_electronico, notas_adicionales) values (1, '3939433492', 'MESA DE ENTRADA', 'whaymes0@drupal.org', 'ADMINISTRACION', null);
            insert into datos_obras_sociales (id_obra_social, telefono, descripcion_telefono, correo_electronico, descripcion_correo_electronico, notas_adicionales) values (2, '7055632574', 'ADMINISTRACION', 'bquilty1@hugedomains.com', 'MESA DE ENTRADA', null);
            insert into datos_obras_sociales (id_obra_social, telefono, descripcion_telefono, correo_electronico, descripcion_correo_electronico, notas_adicionales) values (3, '2487411907', 'TURNOS', 'gkeattch2@1688.com', 'ADMINISTRACION', null);
            insert into datos_obras_sociales (id_obra_social, telefono, descripcion_telefono, correo_electronico, descripcion_correo_electronico, notas_adicionales) values (4, '4281820565', 'ADMINISTRACION', 'dhartle3@booking.com', 'ADMINISTRACION', null);
            insert into datos_obras_sociales (id_obra_social, telefono, descripcion_telefono, correo_electronico, descripcion_correo_electronico, notas_adicionales) values (5, '2031251575', 'TURNOS', 'eselkirk4@about.me', 'GERENCIA', null);
            insert into datos_obras_sociales (id_obra_social, telefono, descripcion_telefono, correo_electronico, descripcion_correo_electronico, notas_adicionales) values (6, '7423644441', 'ADMINISTRACION', 'kbrownsey5@edublogs.org', 'GERENCIA', null);
            insert into datos_obras_sociales (id_obra_social, telefono, descripcion_telefono, correo_electronico, descripcion_correo_electronico, notas_adicionales) values (7, '8879999844', 'ADMINISTRACION', 'tivanshintsev6@discuz.net', 'TURNOS', null);
            insert into datos_obras_sociales (id_obra_social, telefono, descripcion_telefono, correo_electronico, descripcion_correo_electronico, notas_adicionales) values (8, '4149607934', 'GERENCIA', 'jbrooksbank7@uol.com.br', 'ADMINISTRACION', null);
            insert into datos_obras_sociales (id_obra_social, telefono, descripcion_telefono, correo_electronico, descripcion_correo_electronico, notas_adicionales) values (9, '4464986860', 'TURNOS', 'akahn8@issuu.com', 'ADMINISTRACION', null);
            insert into datos_obras_sociales (id_obra_social, telefono, descripcion_telefono, correo_electronico, descripcion_correo_electronico, notas_adicionales) values (10, '8239344221', 'ADMINISTRACION', 'tscriver9@geocities.com', 'TURNOS', null);
            insert into datos_obras_sociales (id_obra_social, telefono, descripcion_telefono, correo_electronico, descripcion_correo_electronico, notas_adicionales) values (11, '4686278362', 'TURNOS', 'rpescoda@aboutads.info', 'ADMINISTRACION', 'ADJUNTAR FACTURAS MENSUALES POR CORREO');
            insert into datos_obras_sociales (id_obra_social, telefono, descripcion_telefono, correo_electronico, descripcion_correo_electronico, notas_adicionales) values (12, '2459730684', 'ADMINISTRACION', 'dtumultyb@soup.io', 'ADMINISTRACION', 'SIEMPRE CONSULTAR SI EL SOCIO ESTA ACTIVO');
            insert into datos_obras_sociales (id_obra_social, telefono, descripcion_telefono, correo_electronico, descripcion_correo_electronico, notas_adicionales) values (13, '7605976702', 'GERENCIA', 'pkesleyc@alibaba.com', 'TURNOS', 'SIEMPRE CONSULTAR SI EL SOCIO ESTA ACTIVO');
            insert into datos_obras_sociales (id_obra_social, telefono, descripcion_telefono, correo_electronico, descripcion_correo_electronico, notas_adicionales) values (14, '9759702862', 'ADMINISTRACION', 'ajackwaysd@comsenz.com', 'GERENCIA', 'ADJUNTAR FACTURAS MENSUALES POR CORREO');
            insert into datos_obras_sociales (id_obra_social, telefono, descripcion_telefono, correo_electronico, descripcion_correo_electronico, notas_adicionales) values (15, '2261894781', 'ADMINISTRACION', 'lpykee@imageshack.us', 'GERENCIA', 'SIEMPRE CONSULTAR SI EL SOCIO ESTA ACTIVO');
            insert into datos_obras_sociales (id_obra_social, telefono, descripcion_telefono, correo_electronico, descripcion_correo_electronico, notas_adicionales) values (16, '4438145884', 'TURNOS', 'fkersleyf@tinypic.com', 'MESA DE ENTRADA', null);
            insert into datos_obras_sociales (id_obra_social, telefono, descripcion_telefono, correo_electronico, descripcion_correo_electronico, notas_adicionales) values (17, '2027572184', 'GERENCIA', 'nsolong@google.fr', 'ADMINISTRACION', null);
            insert into datos_obras_sociales (id_obra_social, telefono, descripcion_telefono, correo_electronico, descripcion_correo_electronico, notas_adicionales) values (18, '2818431254', 'ADMINISTRACION', 'shurryh@patch.com', 'ADMINISTRACION', null);
            insert into datos_obras_sociales (id_obra_social, telefono, descripcion_telefono, correo_electronico, descripcion_correo_electronico, notas_adicionales) values (19, '4007088148', 'GERENCIA', 'battridgei@archive.org', 'GERENCIA', null);
            insert into datos_obras_sociales (id_obra_social, telefono, descripcion_telefono, correo_electronico, descripcion_correo_electronico, notas_adicionales) values (20, '9642534759', 'TURNOS', 'ihaughj@netscape.com', 'ADMINISTRACION', null);
            insert into datos_obras_sociales (id_obra_social, telefono, descripcion_telefono, correo_electronico, descripcion_correo_electronico, notas_adicionales) values (21, '2134191818', 'ADMINISTRACION', 'kvatcherk@merriam-webster.com', 'TURNOS', null);
            insert into datos_obras_sociales (id_obra_social, telefono, descripcion_telefono, correo_electronico, descripcion_correo_electronico, notas_adicionales) values (22, '9952459480', 'ADMINISTRACION', 'wmichelottil@themeforest.net', 'MESA DE ENTRADA', null);
            insert into datos_obras_sociales (id_obra_social, telefono, descripcion_telefono, correo_electronico, descripcion_correo_electronico, notas_adicionales) values (23, '1835309748', 'GERENCIA', 'rbaptistem@g.co', 'ADMINISTRACION', null);
            insert into datos_obras_sociales (id_obra_social, telefono, descripcion_telefono, correo_electronico, descripcion_correo_electronico, notas_adicionales) values (24, '8861625868', 'ADMINISTRACION', 'cmcconneln@webeden.co.uk', 'ADMINISTRACION', 'SIEMPRE CONSULTAR SI EL SOCIO ESTA ACTIVO');
            insert into datos_obras_sociales (id_obra_social, telefono, descripcion_telefono, correo_electronico, descripcion_correo_electronico, notas_adicionales) values (25, '8339453307', 'MESA DE ENTRADA', 'lhammondo@jiathis.com', 'GERENCIA', null);
            insert into datos_obras_sociales (id_obra_social, telefono, descripcion_telefono, correo_electronico, descripcion_correo_electronico, notas_adicionales) values (26, '1748918162', 'MESA DE ENTRADA', 'sbilneyp@reverbnation.com', 'ADMINISTRACION', null);
            insert into datos_obras_sociales (id_obra_social, telefono, descripcion_telefono, correo_electronico, descripcion_correo_electronico, notas_adicionales) values (27, '1235072713', 'ADMINISTRACION', 'pbalesq@photobucket.com', 'MESA DE ENTRADA', null);
            insert into datos_obras_sociales (id_obra_social, telefono, descripcion_telefono, correo_electronico, descripcion_correo_electronico, notas_adicionales) values (28, '2984169687', 'MESA DE ENTRADA', 'dpagninr@last.fm', 'ADMINISTRACION', null);
            insert into datos_obras_sociales (id_obra_social, telefono, descripcion_telefono, correo_electronico, descripcion_correo_electronico, notas_adicionales) values (29, '7594213509', 'GERENCIA', 'ameatess@4shared.com', 'MESA DE ENTRADA', null);
            insert into datos_obras_sociales (id_obra_social, telefono, descripcion_telefono, correo_electronico, descripcion_correo_electronico, notas_adicionales) values (30, '8424350056', 'TURNOS', 'cbausert@fc2.com', 'GERENCIA', null);
            insert into datos_obras_sociales (id_obra_social, telefono, descripcion_telefono, correo_electronico, descripcion_correo_electronico, notas_adicionales) values (31, '3244972883', 'GERENCIA', 'gniesegenu@networksolutions.com', 'TURNOS', 'ADJUNTAR FACTURAS MENSUALES POR CORREO');
            insert into datos_obras_sociales (id_obra_social, telefono, descripcion_telefono, correo_electronico, descripcion_correo_electronico, notas_adicionales) values (32, '2859990124', 'GERENCIA', 'rohartnettv@engadget.com', 'ADMINISTRACION', null);
            insert into datos_obras_sociales (id_obra_social, telefono, descripcion_telefono, correo_electronico, descripcion_correo_electronico, notas_adicionales) values (33, '2739770925', 'TURNOS', 'bpielew@aol.com', 'TURNOS', 'ADJUNTAR FACTURAS MENSUALES POR CORREO');
            insert into datos_obras_sociales (id_obra_social, telefono, descripcion_telefono, correo_electronico, descripcion_correo_electronico, notas_adicionales) values (34, '6991497919', 'ADMINISTRACION', 'ibearnex@addtoany.com', 'TURNOS', null);
            insert into datos_obras_sociales (id_obra_social, telefono, descripcion_telefono, correo_electronico, descripcion_correo_electronico, notas_adicionales) values (35, '2161465464', 'ADMINISTRACION', 'dbleibaumy@hostgator.com', 'GERENCIA', null);
-- PARA CHEQUEAR QUE LOS DATOS HAYAN SIDO CARGADOS CORRECTAMENTE, DESCOMENTAR Y EJECUTAR LA SIGUIENTE LÍNEA
-- SELECT * FROM datos_obras_sociales;



--  ESTE SCRIPT CARGA DATOS A LA TABLA 'historiales_medicos'
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (159, 59, '2023-03-24', 'Alergia estacional');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (135, 13, '2023-07-05', 'Otitis externa');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (166, 41, '2023-04-06', 'Lumbalgia');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (54, 46, '2023-03-15', 'Esguince de tobillo');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (39, 35, '2023-02-15', 'Bronquitis');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (67, 15, '2023-07-22', 'Lumbalgia');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (165, 49, '2023-07-18', 'Hipertensión');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (66, 47, '2023-07-18', 'Bronquitis');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (123, 48, '2023-07-16', 'Dermatitis leve');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (170, 40, '2023-05-19', 'Lumbalgia');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (66, 60, '2023-02-28', 'Tendinitis');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (15, 18, '2023-02-18', 'Contractura muscular');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (33, 11, '2023-06-26', 'Sinusitis aguda');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (77, 52, '2023-07-16', 'Contractura muscular');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (113, 12, '2023-05-02', 'Bronquitis');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (13, 16, '2023-03-10', 'Cálculos renales');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (78, 23, '2023-03-24', 'Lumbalgia');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (123, 10, '2023-03-31', 'Urticaria');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (114, 48, '2023-07-13', 'Hipertensión');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (29, 16, '2023-01-30', 'Sinusitis aguda');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (46, 30, '2023-01-19', 'Diabetes tipo 2');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (163, 43, '2023-03-20', 'Reflujo gastroesofágico');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (52, 26, '2023-04-15', 'Lumbalgia');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (1, 17, '2023-03-15', 'Conjuntivitis');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (111, 38, '2023-05-08', 'Contractura muscular');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (24, 16, '2023-05-22', 'Infección de garganta');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (161, 8, '2023-05-15', 'Gripe común');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (40, 30, '2023-07-15', 'Alergia estacional');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (112, 46, '2023-02-10', 'Fatiga crónica');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (102, 45, '2023-01-29', 'Insomnio ocasional');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (93, 38, '2023-08-05', 'Infección de garganta');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (40, 37, '2023-03-13', 'Fatiga crónica');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (48, 47, '2023-03-27', 'Depresión leve');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (146, 36, '2023-03-05', 'Urticaria');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (78, 42, '2023-05-13', 'Cálculos renales');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (165, 54, '2023-04-22', 'Otitis externa');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (25, 12, '2023-06-28', 'Neumonía leve');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (42, 28, '2023-02-18', 'Síndrome del túnel carpiano');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (61, 4, '2023-07-25', 'Migraña');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (81, 48, '2023-05-27', 'Alergia estacional');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (6, 26, '2023-05-15', 'Bronquitis');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (152, 25, '2023-02-19', 'Reflujo gastroesofágico');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (68, 9, '2023-01-25', 'Dermatitis leve');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (90, 8, '2023-06-24', 'Escoliosis');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (100, 21, '2023-02-02', 'Contractura muscular');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (137, 30, '2023-06-26', 'Bronquitis');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (98, 60, '2023-07-07', 'Rinitis alérgica');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (165, 41, '2023-02-21', 'Gastritis');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (7, 59, '2023-05-15', 'Migraña');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (160, 9, '2023-07-04', 'Rinitis alérgica');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (7, 43, '2023-02-20', 'Síndrome del túnel carpiano');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (68, 22, '2023-05-19', 'Tendinitis');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (56, 48, '2023-07-23', 'Sinusitis aguda');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (115, 19, '2023-02-17', 'Lumbalgia');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (169, 9, '2023-06-06', 'Neumonía leve');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (10, 1, '2023-05-06', 'Reflujo gastroesofágico');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (127, 60, '2023-04-04', 'Gripe común');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (45, 40, '2023-03-08', 'Dermatitis leve');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (31, 11, '2023-06-29', 'Urticaria');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (13, 21, '2023-02-14', 'Hernia discal lumbar');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (106, 15, '2023-03-19', 'Tendinitis');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (19, 39, '2023-02-07', 'Infección de garganta');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (81, 51, '2023-02-19', 'Insomnio ocasional');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (60, 54, '2023-06-30', 'Otitis externa');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (87, 56, '2023-02-07', 'Síndrome del túnel carpiano');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (5, 30, '2023-06-21', 'Fatiga crónica');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (170, 43, '2023-06-26', 'Cálculos renales');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (93, 15, '2023-02-02', 'Gastritis');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (160, 13, '2023-02-03', 'Neumonía leve');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (47, 35, '2023-04-13', 'Infección de garganta');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (19, 23, '2023-01-09', 'Anemia leve');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (112, 7, '2023-06-21', 'Alergia estacional');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (122, 49, '2023-02-14', 'Fatiga crónica');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (38, 53, '2023-04-14', 'Migraña');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (76, 13, '2023-03-04', 'Otitis externa');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (142, 7, '2023-01-22', 'Cálculos renales');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (128, 60, '2023-02-15', 'Migraña');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (105, 32, '2023-04-30', 'Urticaria');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (30, 30, '2023-06-16', 'Síndrome del túnel carpiano');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (140, 2, '2023-07-11', 'Diabetes tipo 2');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (106, 50, '2023-05-11', 'Reflujo gastroesofágico');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (28, 21, '2023-03-20', 'Escoliosis');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (155, 32, '2023-03-27', 'Migraña');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (68, 58, '2023-03-27', 'Bronquitis');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (87, 27, '2023-04-19', 'Diabetes tipo 2');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (30, 48, '2023-03-19', 'Conjuntivitis');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (12, 9, '2023-02-08', 'Diabetes tipo 2');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (78, 48, '2023-01-31', 'Tendinitis');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (125, 3, '2023-02-18', 'Dermatitis leve');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (41, 43, '2023-05-07', 'Esguince de tobillo');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (138, 20, '2023-06-08', 'Insomnio ocasional');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (7, 38, '2023-03-18', 'Hipertensión');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (39, 44, '2023-05-02', 'Tendinitis');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (140, 9, '2023-04-25', 'Anemia leve');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (66, 18, '2023-02-03', 'Neumonía leve');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (102, 17, '2023-06-14', 'Depresión leve');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (6, 11, '2023-04-27', 'Gastritis');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (74, 13, '2023-08-12', 'Neumonía leve');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (6, 10, '2023-05-08', 'Hernia discal lumbar');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (84, 18, '2023-01-27', 'Neumonía leve');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (88, 51, '2023-06-24', 'Reflujo gastroesofágico');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (119, 53, '2023-06-20', 'Síndrome del túnel carpiano');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (144, 2, '2023-03-16', 'Depresión leve');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (83, 8, '2023-01-30', 'Diabetes tipo 2');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (15, 51, '2023-02-10', 'Síndrome del túnel carpiano');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (11, 53, '2023-03-01', 'Neumonía leve');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (14, 29, '2023-03-12', 'Alergia estacional');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (68, 9, '2023-02-16', 'Sinusitis aguda');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (25, 60, '2023-07-27', 'Varicela');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (89, 18, '2023-07-13', 'Otitis externa');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (57, 40, '2023-01-30', 'Urticaria');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (32, 56, '2023-07-12', 'Cistitis');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (18, 31, '2023-02-22', 'Dermatitis leve');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (170, 29, '2023-06-26', 'Reflujo gastroesofágico');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (126, 38, '2023-05-08', 'Diabetes tipo 2');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (60, 52, '2023-02-18', 'Conjuntivitis');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (148, 15, '2023-05-13', 'Fatiga crónica');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (25, 55, '2023-06-15', 'Infección de garganta');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (75, 28, '2023-06-13', 'Contractura muscular');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (77, 38, '2023-04-15', 'Diabetes tipo 2');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (85, 46, '2023-03-24', 'Gripe común');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (19, 41, '2023-07-21', 'Varicela');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (55, 37, '2023-07-17', 'Depresión leve');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (138, 15, '2023-07-09', 'Insomnio ocasional');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (36, 45, '2023-07-22', 'Insomnio ocasional');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (124, 12, '2023-07-05', 'Tendinitis');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (127, 20, '2023-06-30', 'Lumbalgia');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (147, 25, '2023-04-08', 'Escoliosis');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (128, 6, '2023-05-23', 'Urticaria');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (115, 41, '2023-06-27', 'Cistitis');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (115, 4, '2023-06-16', 'Gastritis');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (55, 15, '2023-01-15', 'Sinusitis aguda');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (136, 12, '2023-06-14', 'Tendinitis');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (53, 49, '2023-08-10', 'Gripe común');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (23, 45, '2023-06-23', 'Anemia leve');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (84, 25, '2023-01-29', 'Sinusitis aguda');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (123, 38, '2023-07-24', 'Lumbalgia');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (77, 57, '2023-02-11', 'Síndrome del túnel carpiano');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (29, 7, '2023-06-27', 'Alergia estacional');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (20, 17, '2023-08-08', 'Gastritis');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (146, 4, '2023-06-06', 'Rinitis alérgica');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (7, 52, '2023-07-27', 'Escoliosis');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (100, 43, '2023-05-25', 'Contractura muscular');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (89, 6, '2023-08-11', 'Sinusitis aguda');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (161, 35, '2023-03-08', 'Cálculos renales');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (143, 34, '2023-04-19', 'Depresión leve');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (53, 13, '2023-07-06', 'Neumonía leve');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (89, 9, '2023-07-10', 'Alergia estacional');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (49, 45, '2023-03-31', 'Otitis externa');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (169, 14, '2023-02-21', 'Conjuntivitis');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (121, 1, '2023-01-23', 'Insomnio ocasional');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (118, 59, '2023-03-23', 'Esguince de tobillo');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (103, 43, '2023-08-08', 'Esguince de tobillo');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (1, 45, '2023-02-03', 'Insomnio ocasional');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (61, 26, '2023-08-03', 'Conjuntivitis');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (44, 54, '2023-03-19', 'Anemia leve');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (36, 32, '2023-01-09', 'Dermatitis leve');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (52, 10, '2023-06-16', 'Anemia leve');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (162, 58, '2023-01-16', 'Sinusitis aguda');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (125, 27, '2023-04-01', 'Síndrome del túnel carpiano');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (26, 34, '2023-02-01', 'Reflujo gastroesofágico');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (72, 45, '2023-07-21', 'Neumonía leve');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (1, 56, '2023-02-28', 'Lumbalgia');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (42, 8, '2023-01-25', 'Cálculos renales');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (164, 40, '2023-02-06', 'Cálculos renales');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (55, 55, '2023-02-14', 'Varicela');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (8, 50, '2023-08-14', 'Conjuntivitis');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (39, 38, '2023-04-28', 'Migraña');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (29, 57, '2023-05-02', 'Esguince de tobillo');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (38, 5, '2023-04-09', 'Neumonía leve');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (90, 51, '2023-01-08', 'Tendinitis');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (167, 15, '2023-04-23', 'Cálculos renales');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (19, 58, '2023-05-06', 'Otitis externa');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (130, 45, '2023-05-13', 'Bronquitis');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (119, 55, '2023-05-20', 'Migraña');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (107, 38, '2023-06-24', 'Otitis externa');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (159, 40, '2023-06-15', 'Esguince de tobillo');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (103, 51, '2023-07-11', 'Bronquitis');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (30, 27, '2023-05-03', 'Migraña');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (76, 48, '2023-01-12', 'Otitis externa');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (108, 24, '2023-02-17', 'Varicela');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (93, 59, '2023-04-13', 'Reflujo gastroesofágico');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (92, 36, '2023-06-14', 'Reflujo gastroesofágico');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (41, 20, '2023-07-31', 'Cistitis');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (41, 12, '2023-03-08', 'Dermatitis leve');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (155, 31, '2023-07-06', 'Gastritis');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (50, 44, '2023-05-09', 'Hipertensión');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (2, 53, '2023-07-17', 'Varicela');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (44, 58, '2023-06-30', 'Urticaria');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (161, 2, '2023-06-07', 'Alergia estacional');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (90, 13, '2023-05-08', 'Tendinitis');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (145, 9, '2023-04-28', 'Varicela');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (146, 47, '2023-04-07', 'Otitis externa');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (99, 28, '2023-02-17', 'Lumbalgia');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (88, 7, '2023-05-21', 'Lumbalgia');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (151, 31, '2023-08-01', 'Rinitis alérgica');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (20, 9, '2023-05-31', 'Varicela');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (33, 53, '2023-01-23', 'Neumonía leve');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (91, 19, '2023-06-29', 'Escoliosis');
                insert into historiales_medicos (id_paciente, id_medico, fecha_registro, nota_medica) values (122, 18, '2023-05-18', 'Gripe común');
-- PARA CHEQUEAR QUE LOS DATOS HAYAN SIDO CARGADOS CORRECTAMENTE, DESCOMENTAR Y EJECUTAR LA SIGUIENTE LÍNEA
-- SELECT * FROM historiales_medicos;



-- ESTE SCRIPT INSERTA DATOS EN LA TABLA 'tarifas'
                insert into tarifas (id_obra_social, tarifa_normal, tarifa_obra_social) values (1, 5000.0, 1453.02);
                insert into tarifas (id_obra_social, tarifa_normal, tarifa_obra_social) values (2, 5000.0, 1378.78);
                insert into tarifas (id_obra_social, tarifa_normal, tarifa_obra_social) values (3, 5000.0, 2503.19);
                insert into tarifas (id_obra_social, tarifa_normal, tarifa_obra_social) values (4, 5000.0, 2265.56);
                insert into tarifas (id_obra_social, tarifa_normal, tarifa_obra_social) values (5, 5000.0, 2542.0);
                insert into tarifas (id_obra_social, tarifa_normal, tarifa_obra_social) values (6, 5000.0, 1224.98);
                insert into tarifas (id_obra_social, tarifa_normal, tarifa_obra_social) values (7, 5000.0, 2946.14);
                insert into tarifas (id_obra_social, tarifa_normal, tarifa_obra_social) values (8, 5000.0, 2254.46);
                insert into tarifas (id_obra_social, tarifa_normal, tarifa_obra_social) values (9, 5000.0, 2751.12);
                insert into tarifas (id_obra_social, tarifa_normal, tarifa_obra_social) values (10, 5000.0, 1917.99);
                insert into tarifas (id_obra_social, tarifa_normal, tarifa_obra_social) values (11, 5000.0, 1204.81);
                insert into tarifas (id_obra_social, tarifa_normal, tarifa_obra_social) values (12, 5000.0, 1024.76);
                insert into tarifas (id_obra_social, tarifa_normal, tarifa_obra_social) values (13, 5000.0, 2023.67);
                insert into tarifas (id_obra_social, tarifa_normal, tarifa_obra_social) values (14, 5000.0, 1219.39);
                insert into tarifas (id_obra_social, tarifa_normal, tarifa_obra_social) values (15, 5000.0, 2305.09);
                insert into tarifas (id_obra_social, tarifa_normal, tarifa_obra_social) values (16, 5000.0, 3264.57);
                insert into tarifas (id_obra_social, tarifa_normal, tarifa_obra_social) values (17, 5000.0, 1738.89);
                insert into tarifas (id_obra_social, tarifa_normal, tarifa_obra_social) values (18, 5000.0, 1373.79);
                insert into tarifas (id_obra_social, tarifa_normal, tarifa_obra_social) values (19, 5000.0, 2351.59);
                insert into tarifas (id_obra_social, tarifa_normal, tarifa_obra_social) values (20, 5000.0, 1254.77);
                insert into tarifas (id_obra_social, tarifa_normal, tarifa_obra_social) values (21, 5000.0, 1119.93);
                insert into tarifas (id_obra_social, tarifa_normal, tarifa_obra_social) values (22, 5000.0, 1665.44);
                insert into tarifas (id_obra_social, tarifa_normal, tarifa_obra_social) values (23, 5000.0, 3334.3);
                insert into tarifas (id_obra_social, tarifa_normal, tarifa_obra_social) values (24, 5000.0, 2283.64);
                insert into tarifas (id_obra_social, tarifa_normal, tarifa_obra_social) values (25, 5000.0, 1377.82);
                insert into tarifas (id_obra_social, tarifa_normal, tarifa_obra_social) values (26, 5000.0, 3214.6);
                insert into tarifas (id_obra_social, tarifa_normal, tarifa_obra_social) values (27, 5000.0, 2221.97);
                insert into tarifas (id_obra_social, tarifa_normal, tarifa_obra_social) values (28, 5000.0, 2135.36);
                insert into tarifas (id_obra_social, tarifa_normal, tarifa_obra_social) values (29, 5000.0, 1833.75);
                insert into tarifas (id_obra_social, tarifa_normal, tarifa_obra_social) values (30, 5000.0, 3005.47);
                insert into tarifas (id_obra_social, tarifa_normal, tarifa_obra_social) values (31, 5000.0, 1911.93);
                insert into tarifas (id_obra_social, tarifa_normal, tarifa_obra_social) values (32, 5000.0, 1564.1);
                insert into tarifas (id_obra_social, tarifa_normal, tarifa_obra_social) values (33, 5000.0, 3419.46);
                insert into tarifas (id_obra_social, tarifa_normal, tarifa_obra_social) values (34, 5000.0, 1222.03);
                insert into tarifas (id_obra_social, tarifa_normal, tarifa_obra_social) values (35, 5000.0, 1850.59);
-- PARA CHEQUEAR QUE LOS DATOS HAYAN SIDO CARGADOS CORRECTAMENTE, DESCOMENTAR Y EJECUTAR LA SIGUIENTE LÍNEA
-- SELECT * FROM tarifas;



-- ESTE SCRIPT INSERTA DATOS EN LA TABLA 'facturas'
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (1, '2023-01-31', 136, 46, 33, 2357.41, 'Emergencia', 'PAGADA', '2023-11-22', 'MERCADO PAGO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (2, '2023-03-10', 46, 47, 7, 2546.33, 'Consulta Regular', 'PAGADA', '2023-11-10', 'TRANSFERENCIA BANCARIA');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (3, '2023-01-11', 61, 36, 29, 2156.47, 'Consulta Regular', 'PAGADA', '2023-12-08', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (4, '2023-06-22', 154, 52, 4, 1005.04, 'Emergencia', 'PAGADA', '2023-11-15', 'TARJETA DÉBITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (5, '2023-08-11', 71, 42, 29, 1308.47, 'Consulta Regular', 'PAGADA', '2023-11-17', 'MERCADO PAGO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (6, '2023-07-31', 86, 48, 18, 1901.29, 'Consulta Regular', 'PAGADA', '2023-12-05', 'MERCADO PAGO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (7, '2023-05-01', 64, 18, 14, 1396.77, 'Consulta Espontánea', 'PAGADA', '2023-11-13', 'TARJETA DÉBITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (8, '2023-02-26', 52, 14, 18, 3556.49, 'Consulta Espontánea', 'PAGADA', '2023-12-05', 'TARJETA CRÉDITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (9, '2023-02-23', 3, 40, 20, 1519.02, 'Consulta Regular', 'PAGADA', '2023-11-03', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (10, '2023-03-17', 110, 55, 25, 3153.74, 'Consulta Espontánea', 'PAGADA', '2023-11-26', 'MERCADO PAGO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (11, '2023-04-06', 88, 32, 13, 3759.58, 'Consulta Regular', 'PAGADA', '2023-12-10', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (12, '2023-03-04', 139, 15, 8, 3409.65, 'Emergencia', 'PAGADA', '2023-10-31', 'MERCADO PAGO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (13, '2023-03-17', 29, 3, 10, 3754.89, 'Consulta Espontánea', 'PAGADA', '2023-10-11', 'TARJETA CRÉDITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (14, '2023-04-04', 163, 42, 1, 1966.71, 'Consulta Espontánea', 'PAGADA', '2023-12-11', 'TARJETA CRÉDITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (15, '2023-06-02', 79, 5, 2, 1606.74, 'Consulta Regular', 'PENDIENTE', '2023-10-28', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (16, '2023-01-09', 59, 52, 31, 3229.03, 'Emergencia', 'PAGADA', '2023-10-19', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (17, '2023-07-20', 76, 54, 26, 4891.8, 'Consulta Espontánea', 'PAGADA', '2023-10-27', 'MERCADO PAGO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (18, '2023-04-27', 143, 43, 18, 4748.36, 'Emergencia', 'PENDIENTE', '2023-12-06', 'MERCADO PAGO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (19, '2023-05-05', 23, 60, 18, 4546.24, 'Consulta Regular', 'PAGADA', '2023-12-01', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (20, '2023-06-25', 145, 33, 31, 2324.22, 'Emergencia', 'PAGADA', '2023-10-24', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (21, '2023-01-12', 108, 20, 34, 3206.39, 'Consulta Espontánea', 'PENDIENTE', '2023-11-25', 'MERCADO PAGO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (22, '2023-03-31', 47, 10, 16, 1781.55, 'Consulta Espontánea', 'PAGADA', '2023-12-07', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (23, '2023-03-25', 36, 32, 35, 3692.53, 'Emergencia', 'PAGADA', '2023-12-12', 'TARJETA DÉBITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (24, '2023-04-16', 142, 27, 6, 2096.27, 'Consulta Regular', 'PAGADA', '2023-11-15', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (25, '2023-01-27', 161, 9, 24, 4495.77, 'Emergencia', 'PAGADA', '2023-11-30', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (26, '2023-06-22', 110, 55, 4, 1467.72, 'Emergencia', 'PAGADA', '2023-12-11', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (27, '2023-07-31', 120, 51, 30, 3947.14, 'Consulta Regular', 'PENDIENTE', '2023-11-06', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (28, '2023-03-28', 79, 12, 31, 3795.24, 'Consulta Regular', 'PAGADA', '2023-10-09', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (29, '2023-02-06', 148, 42, 15, 1418.76, 'Emergencia', 'PAGADA', '2023-11-19', 'TARJETA CRÉDITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (30, '2023-01-13', 47, 23, 18, 2199.22, 'Consulta Regular', 'PAGADA', '2023-12-04', 'TARJETA CRÉDITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (31, '2023-02-18', 118, 49, 28, 1098.02, 'Emergencia', 'PAGADA', '2023-12-08', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (32, '2023-03-14', 17, 5, 18, 3377.51, 'Consulta Regular', 'PAGADA', '2023-11-10', 'TARJETA CRÉDITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (33, '2023-04-03', 43, 23, 4, 2385.04, 'Consulta Espontánea', 'PENDIENTE', '2023-12-04', 'TARJETA DÉBITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (34, '2023-04-23', 78, 27, 21, 1601.35, 'Emergencia', 'PAGADA', '2023-11-26', 'MERCADO PAGO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (35, '2023-07-14', 149, 34, 26, 1655.78, 'Consulta Regular', 'PAGADA', '2023-12-02', 'TARJETA DÉBITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (36, '2023-02-05', 102, 5, 27, 1002.43, 'Consulta Espontánea', 'PAGADA', '2023-11-03', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (37, '2023-05-29', 53, 7, 7, 4545.06, 'Consulta Espontánea', 'PAGADA', '2023-11-23', 'MERCADO PAGO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (38, '2023-06-07', 45, 10, 19, 4144.91, 'Consulta Espontánea', 'PAGADA', '2023-10-09', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (39, '2023-02-20', 36, 58, 9, 4942.61, 'Consulta Espontánea', 'PAGADA', '2023-10-11', 'MERCADO PAGO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (40, '2023-02-26', 129, 54, 11, 3157.06, 'Consulta Regular', 'PAGADA', '2023-10-10', 'MERCADO PAGO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (41, '2023-05-28', 22, 44, 26, 1230.57, 'Emergencia', 'PENDIENTE', '2023-11-03', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (42, '2023-06-14', 87, 10, 7, 2780.85, 'Consulta Regular', 'PAGADA', '2023-10-27', 'MERCADO PAGO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (43, '2023-06-28', 12, 18, 10, 3819.03, 'Consulta Regular', 'PAGADA', '2023-11-28', 'TARJETA DÉBITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (44, '2023-05-09', 94, 16, 31, 4249.69, 'Emergencia', 'PAGADA', '2023-10-26', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (45, '2023-02-05', 32, 30, 19, 1528.97, 'Emergencia', 'PAGADA', '2023-10-13', 'TARJETA CRÉDITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (46, '2023-02-27', 42, 5, 31, 1223.83, 'Consulta Regular', 'PAGADA', '2023-10-17', 'TRANSFERENCIA BANCARIA');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (47, '2023-07-29', 160, 24, 29, 1076.91, 'Emergencia', 'PAGADA', '2023-11-17', 'TARJETA DÉBITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (48, '2023-07-29', 76, 22, 33, 1011.73, 'Consulta Espontánea', 'PENDIENTE', '2023-11-17', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (49, '2023-04-05', 168, 4, 5, 4823.94, 'Consulta Espontánea', 'PAGADA', '2023-11-12', 'TARJETA DÉBITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (50, '2023-04-07', 110, 13, 32, 2289.68, 'Emergencia', 'PAGADA', '2023-11-13', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (51, '2023-06-20', 140, 59, 35, 3609.64, 'Consulta Regular', 'PAGADA', '2023-11-29', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (52, '2023-05-13', 79, 26, 28, 3667.96, 'Emergencia', 'PAGADA', '2023-10-29', 'TARJETA CRÉDITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (53, '2023-06-05', 163, 20, 23, 3847.22, 'Consulta Espontánea', 'PAGADA', '2023-12-09', 'TARJETA DÉBITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (54, '2023-05-14', 80, 36, 23, 1162.31, 'Consulta Espontánea', 'PAGADA', '2023-12-04', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (55, '2023-05-23', 139, 33, 16, 3955.53, 'Consulta Regular', 'PAGADA', '2023-11-29', 'TARJETA DÉBITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (56, '2023-02-10', 165, 50, 27, 2561.39, 'Consulta Espontánea', 'PAGADA', '2023-11-02', 'MERCADO PAGO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (57, '2023-03-19', 157, 46, 8, 2969.2, 'Consulta Regular', 'PAGADA', '2023-10-13', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (58, '2023-03-06', 70, 55, 33, 4159.41, 'Consulta Espontánea', 'PAGADA', '2023-11-18', 'TARJETA CRÉDITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (59, '2023-05-21', 64, 34, 34, 2399.08, 'Consulta Espontánea', 'PAGADA', '2023-10-06', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (60, '2023-04-16', 95, 14, 22, 2678.01, 'Consulta Regular', 'PAGADA', '2023-11-30', 'TARJETA CRÉDITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (61, '2023-02-19', 48, 42, 31, 4762.68, 'Emergencia', 'PAGADA', '2023-11-10', 'TARJETA CRÉDITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (62, '2023-04-09', 21, 49, 22, 4221.42, 'Emergencia', 'PAGADA', '2023-10-11', 'TARJETA DÉBITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (63, '2023-04-06', 113, 25, 2, 4840.77, 'Consulta Regular', 'PENDIENTE', '2023-12-08', 'TARJETA CRÉDITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (64, '2023-02-24', 118, 33, 6, 4459.52, 'Consulta Espontánea', 'PENDIENTE', '2023-10-14', 'TARJETA CRÉDITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (65, '2023-04-21', 38, 14, 8, 4756.2, 'Consulta Regular', 'PAGADA', '2023-10-17', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (66, '2023-07-06', 53, 25, 29, 1218.8, 'Consulta Espontánea', 'PENDIENTE', '2023-11-21', 'TRANSFERENCIA BANCARIA');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (67, '2023-08-10', 136, 52, 16, 4441.92, 'Emergencia', 'PAGADA', '2023-11-10', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (68, '2023-07-12', 146, 29, 12, 1860.46, 'Emergencia', 'PAGADA', '2023-11-19', 'MERCADO PAGO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (69, '2023-01-28', 10, 33, 22, 1746.38, 'Consulta Regular', 'PAGADA', '2023-11-07', 'MERCADO PAGO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (70, '2023-05-17', 141, 2, 1, 1372.99, 'Consulta Espontánea', 'PAGADA', '2023-11-29', 'MERCADO PAGO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (71, '2023-06-01', 117, 22, 9, 1471.71, 'Consulta Regular', 'PAGADA', '2023-11-20', 'TARJETA CRÉDITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (72, '2023-04-03', 161, 53, 12, 2157.46, 'Emergencia', 'PAGADA', '2023-11-13', 'MERCADO PAGO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (73, '2023-07-08', 93, 17, 2, 1092.32, 'Consulta Regular', 'PAGADA', '2023-12-03', 'TARJETA DÉBITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (74, '2023-05-22', 33, 27, 28, 3739.58, 'Emergencia', 'PAGADA', '2023-11-18', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (75, '2023-07-31', 86, 47, 25, 2901.61, 'Emergencia', 'PAGADA', '2023-10-17', 'MERCADO PAGO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (76, '2023-08-07', 59, 18, 15, 2224.49, 'Emergencia', 'PAGADA', '2023-10-13', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (77, '2023-02-04', 168, 10, 20, 3016.86, 'Consulta Regular', 'PENDIENTE', '2023-10-24', 'TARJETA DÉBITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (78, '2023-08-14', 115, 6, 9, 2554.34, 'Consulta Espontánea', 'PAGADA', '2023-11-19', 'TARJETA CRÉDITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (79, '2023-02-06', 134, 18, 5, 2845.37, 'Consulta Regular', 'PAGADA', '2023-10-23', 'TARJETA DÉBITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (80, '2023-01-27', 78, 34, 10, 3278.78, 'Emergencia', 'PAGADA', '2023-11-01', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (81, '2023-04-21', 66, 52, 16, 3773.85, 'Consulta Regular', 'PENDIENTE', '2023-10-15', 'MERCADO PAGO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (82, '2023-01-15', 29, 9, 35, 1245.68, 'Consulta Espontánea', 'PAGADA', '2023-11-11', 'TRANSFERENCIA BANCARIA');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (83, '2023-08-04', 51, 53, 33, 3784.26, 'Consulta Regular', 'PAGADA', '2023-11-16', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (84, '2023-06-26', 96, 50, 23, 2395.81, 'Consulta Regular', 'PENDIENTE', '2023-12-04', 'TARJETA CRÉDITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (85, '2023-02-16', 55, 24, 11, 1864.17, 'Consulta Regular', 'PAGADA', '2023-11-05', 'MERCADO PAGO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (86, '2023-06-17', 170, 35, 7, 4563.47, 'Consulta Regular', 'PAGADA', '2023-11-01', 'TARJETA DÉBITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (87, '2023-03-14', 95, 40, 29, 2247.56, 'Emergencia', 'PAGADA', '2023-10-23', 'TARJETA CRÉDITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (88, '2023-02-04', 156, 15, 35, 4034.63, 'Emergencia', 'PENDIENTE', '2023-12-04', 'TRANSFERENCIA BANCARIA');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (89, '2023-07-03', 67, 57, 28, 2938.95, 'Emergencia', 'PENDIENTE', '2023-10-24', 'MERCADO PAGO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (90, '2023-02-03', 143, 50, 19, 3909.93, 'Consulta Espontánea', 'PENDIENTE', '2023-11-13', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (91, '2023-08-03', 60, 8, 11, 1719.12, 'Consulta Regular', 'PENDIENTE', '2023-10-16', 'TARJETA DÉBITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (92, '2023-04-29', 9, 51, 8, 2161.67, 'Consulta Regular', 'PAGADA', '2023-10-26', 'TARJETA DÉBITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (93, '2023-02-18', 136, 30, 16, 1401.22, 'Consulta Regular', 'PAGADA', '2023-11-13', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (94, '2023-07-20', 26, 42, 7, 3172.92, 'Emergencia', 'PAGADA', '2023-11-27', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (95, '2023-03-23', 16, 49, 2, 4585.15, 'Consulta Espontánea', 'PAGADA', '2023-11-06', 'MERCADO PAGO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (96, '2023-03-29', 156, 32, 30, 3265.44, 'Consulta Regular', 'PENDIENTE', '2023-10-28', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (97, '2023-01-10', 7, 50, 19, 3235.09, 'Emergencia', 'PAGADA', '2023-11-12', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (98, '2023-07-29', 87, 50, 26, 3046.04, 'Emergencia', 'PAGADA', '2023-11-10', 'MERCADO PAGO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (99, '2023-02-14', 95, 49, 26, 1026.13, 'Consulta Regular', 'PAGADA', '2023-12-10', 'TRANSFERENCIA BANCARIA');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (100, '2023-05-30', 170, 20, 20, 2117.26, 'Consulta Espontánea', 'PAGADA', '2023-10-25', 'TARJETA DÉBITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (101, '2023-03-11', 124, 11, 16, 1149.16, 'Emergencia', 'PAGADA', '2023-10-25', 'TARJETA CRÉDITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (102, '2023-06-18', 100, 5, 2, 4629.95, 'Emergencia', 'PAGADA', '2023-10-27', 'TARJETA DÉBITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (103, '2023-05-14', 162, 6, 11, 3683.55, 'Emergencia', 'PENDIENTE', '2023-12-10', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (104, '2023-08-10', 120, 20, 12, 2792.11, 'Emergencia', 'PAGADA', '2023-11-13', 'TRANSFERENCIA BANCARIA');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (105, '2023-02-08', 125, 38, 19, 4647.35, 'Consulta Regular', 'PAGADA', '2023-11-11', 'TARJETA DÉBITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (106, '2023-06-06', 20, 19, 23, 1464.91, 'Consulta Regular', 'PAGADA', '2023-11-16', 'MERCADO PAGO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (107, '2023-06-11', 62, 58, 17, 2302.27, 'Consulta Espontánea', 'PENDIENTE', '2023-10-16', 'TARJETA DÉBITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (108, '2023-08-08', 143, 2, 16, 3578.38, 'Consulta Regular', 'PAGADA', '2023-11-12', 'MERCADO PAGO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (109, '2023-03-22', 1, 55, 7, 2456.65, 'Consulta Espontánea', 'PENDIENTE', '2023-10-20', 'TRANSFERENCIA BANCARIA');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (110, '2023-03-19', 37, 16, 29, 4176.16, 'Consulta Regular', 'PAGADA', '2023-10-14', 'MERCADO PAGO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (111, '2023-07-27', 52, 19, 17, 2402.69, 'Consulta Regular', 'PAGADA', '2023-10-12', 'TRANSFERENCIA BANCARIA');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (112, '2023-06-16', 122, 8, 3, 2535.26, 'Emergencia', 'PAGADA', '2023-12-08', 'TRANSFERENCIA BANCARIA');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (113, '2023-05-06', 58, 56, 10, 4656.88, 'Emergencia', 'PAGADA', '2023-10-18', 'TRANSFERENCIA BANCARIA');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (114, '2023-06-04', 106, 10, 35, 4959.78, 'Consulta Espontánea', 'PAGADA', '2023-12-13', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (115, '2023-06-12', 15, 8, 22, 1125.8, 'Consulta Espontánea', 'PAGADA', '2023-10-28', 'MERCADO PAGO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (116, '2023-04-23', 41, 12, 31, 4250.21, 'Emergencia', 'PENDIENTE', '2023-11-08', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (117, '2023-07-07', 59, 58, 7, 1724.9, 'Emergencia', 'PAGADA', '2023-12-05', 'MERCADO PAGO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (118, '2023-05-10', 134, 30, 32, 2332.71, 'Consulta Espontánea', 'PENDIENTE', '2023-12-02', 'TARJETA DÉBITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (119, '2023-01-26', 11, 7, 32, 4210.74, 'Consulta Regular', 'PAGADA', '2023-11-02', 'TARJETA CRÉDITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (120, '2023-01-28', 148, 57, 4, 1486.73, 'Emergencia', 'PAGADA', '2023-12-08', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (121, '2023-04-10', 83, 58, 7, 2429.58, 'Emergencia', 'PAGADA', '2023-11-14', 'MERCADO PAGO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (122, '2023-07-05', 154, 29, 11, 1822.71, 'Consulta Espontánea', 'PAGADA', '2023-10-23', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (123, '2023-05-04', 75, 55, 33, 2237.13, 'Consulta Espontánea', 'PENDIENTE', '2023-10-14', 'TARJETA CRÉDITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (124, '2023-04-09', 118, 29, 20, 4657.41, 'Emergencia', 'PAGADA', '2023-12-01', 'MERCADO PAGO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (125, '2023-02-14', 137, 38, 31, 1009.97, 'Consulta Regular', 'PAGADA', '2023-12-02', 'TARJETA DÉBITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (126, '2023-05-25', 66, 13, 4, 1997.07, 'Emergencia', 'PENDIENTE', '2023-11-16', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (127, '2023-06-06', 127, 3, 7, 3339.75, 'Consulta Regular', 'PENDIENTE', '2023-10-23', 'TARJETA CRÉDITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (128, '2023-01-14', 65, 52, 15, 3344.21, 'Consulta Espontánea', 'PAGADA', '2023-11-21', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (129, '2023-05-17', 13, 4, 9, 2071.35, 'Emergencia', 'PAGADA', '2023-10-12', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (130, '2023-06-15', 152, 28, 15, 1686.26, 'Consulta Regular', 'PENDIENTE', '2023-10-06', 'TARJETA CRÉDITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (131, '2023-04-18', 139, 60, 1, 1090.04, 'Consulta Espontánea', 'PAGADA', '2023-10-20', 'TARJETA DÉBITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (132, '2023-06-18', 159, 34, 6, 3071.69, 'Consulta Regular', 'PAGADA', '2023-10-06', 'MERCADO PAGO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (133, '2023-07-20', 168, 56, 11, 4996.66, 'Emergencia', 'PENDIENTE', '2023-10-07', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (134, '2023-05-12', 80, 30, 21, 4966.87, 'Consulta Espontánea', 'PAGADA', '2023-11-15', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (135, '2023-04-19', 83, 20, 9, 1219.88, 'Consulta Espontánea', 'PAGADA', '2023-11-23', 'TRANSFERENCIA BANCARIA');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (136, '2023-05-12', 79, 21, 3, 3072.59, 'Consulta Regular', 'PAGADA', '2023-11-07', 'MERCADO PAGO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (137, '2023-07-01', 79, 20, 7, 3761.98, 'Emergencia', 'PAGADA', '2023-12-03', 'TARJETA DÉBITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (138, '2023-02-18', 106, 36, 15, 2354.83, 'Consulta Espontánea', 'PENDIENTE', '2023-11-03', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (139, '2023-06-14', 170, 11, 5, 1871.16, 'Emergencia', 'PAGADA', '2023-11-06', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (140, '2023-02-19', 148, 23, 30, 2325.69, 'Consulta Regular', 'PAGADA', '2023-12-02', 'MERCADO PAGO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (141, '2023-06-28', 99, 22, 12, 3127.01, 'Consulta Espontánea', 'PAGADA', '2023-10-16', 'TRANSFERENCIA BANCARIA');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (142, '2023-03-25', 110, 57, 6, 1419.56, 'Emergencia', 'PAGADA', '2023-12-13', 'TARJETA DÉBITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (143, '2023-08-05', 143, 1, 4, 3822.54, 'Emergencia', 'PENDIENTE', '2023-12-02', 'TARJETA CRÉDITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (144, '2023-06-10', 94, 12, 16, 2987.87, 'Consulta Regular', 'PAGADA', '2023-11-26', 'TRANSFERENCIA BANCARIA');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (145, '2023-05-05', 148, 24, 13, 4296.62, 'Consulta Regular', 'PAGADA', '2023-10-22', 'TRANSFERENCIA BANCARIA');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (146, '2023-03-26', 50, 29, 17, 2741.29, 'Consulta Regular', 'PENDIENTE', '2023-10-18', 'TRANSFERENCIA BANCARIA');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (147, '2023-07-22', 169, 6, 26, 2949.58, 'Consulta Espontánea', 'PENDIENTE', '2023-10-27', 'TARJETA CRÉDITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (148, '2023-01-17', 136, 52, 15, 3237.26, 'Consulta Espontánea', 'PAGADA', '2023-10-27', 'MERCADO PAGO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (149, '2023-05-20', 130, 29, 24, 1524.13, 'Emergencia', 'PAGADA', '2023-11-08', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (150, '2023-05-23', 104, 50, 17, 1150.1, 'Emergencia', 'PAGADA', '2023-10-10', 'MERCADO PAGO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (151, '2023-08-07', 85, 33, 25, 4961.89, 'Consulta Espontánea', 'PAGADA', '2023-11-17', 'TARJETA DÉBITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (152, '2023-07-29', 57, 29, 1, 1007.9, 'Consulta Regular', 'PENDIENTE', '2023-11-09', 'TRANSFERENCIA BANCARIA');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (153, '2023-07-01', 133, 59, 2, 2231.71, 'Consulta Espontánea', 'PAGADA', '2023-12-03', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (154, '2023-03-01', 105, 37, 10, 3882.52, 'Consulta Espontánea', 'PAGADA', '2023-11-28', 'MERCADO PAGO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (155, '2023-08-05', 89, 57, 20, 3035.04, 'Consulta Regular', 'PENDIENTE', '2023-12-02', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (156, '2023-07-25', 153, 11, 35, 3079.21, 'Consulta Regular', 'PAGADA', '2023-12-03', 'TARJETA DÉBITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (157, '2023-03-04', 166, 52, 4, 3405.3, 'Emergencia', 'PAGADA', '2023-11-08', 'TRANSFERENCIA BANCARIA');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (158, '2023-05-07', 32, 30, 24, 3862.87, 'Emergencia', 'PAGADA', '2023-10-27', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (159, '2023-05-21', 71, 17, 11, 2537.93, 'Emergencia', 'PAGADA', '2023-11-20', 'TARJETA CRÉDITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (160, '2023-01-18', 127, 47, 1, 3111.07, 'Consulta Regular', 'PAGADA', '2023-12-03', 'MERCADO PAGO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (161, '2023-02-21', 36, 33, 2, 2845.61, 'Emergencia', 'PAGADA', '2023-12-04', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (162, '2023-03-26', 45, 21, 27, 3589.58, 'Consulta Regular', 'PAGADA', '2023-11-01', 'TRANSFERENCIA BANCARIA');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (163, '2023-03-02', 61, 56, 34, 1810.11, 'Consulta Regular', 'PENDIENTE', '2023-12-06', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (164, '2023-04-04', 34, 7, 22, 4105.66, 'Emergencia', 'PAGADA', '2023-11-18', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (165, '2023-06-15', 14, 42, 32, 2886.24, 'Consulta Regular', 'PAGADA', '2023-11-04', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (166, '2023-02-27', 74, 45, 35, 1073.03, 'Consulta Regular', 'PAGADA', '2023-11-14', 'MERCADO PAGO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (167, '2023-01-31', 76, 59, 23, 1273.67, 'Consulta Espontánea', 'PAGADA', '2023-11-20', 'TARJETA CRÉDITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (168, '2023-02-27', 43, 19, 12, 1752.12, 'Emergencia', 'PAGADA', '2023-11-22', 'TARJETA CRÉDITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (169, '2023-01-12', 18, 3, 27, 3256.93, 'Consulta Regular', 'PAGADA', '2023-11-20', 'MERCADO PAGO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (170, '2023-07-21', 87, 18, 10, 1253.26, 'Emergencia', 'PENDIENTE', '2023-12-12', 'TARJETA CRÉDITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (171, '2023-05-26', 132, 14, 22, 1129.62, 'Consulta Regular', 'PENDIENTE', '2023-11-10', 'TRANSFERENCIA BANCARIA');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (172, '2023-02-20', 23, 21, 23, 4720.22, 'Emergencia', 'PENDIENTE', '2023-12-03', 'MERCADO PAGO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (173, '2023-07-08', 10, 44, 14, 1231.17, 'Consulta Espontánea', 'PAGADA', '2023-11-03', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (174, '2023-06-04', 124, 40, 23, 3863.35, 'Emergencia', 'PAGADA', '2023-10-25', 'MERCADO PAGO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (175, '2023-03-10', 23, 16, 7, 1822.8, 'Consulta Regular', 'PAGADA', '2023-11-28', 'TRANSFERENCIA BANCARIA');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (176, '2023-05-15', 32, 37, 8, 1884.76, 'Consulta Regular', 'PAGADA', '2023-10-10', 'TRANSFERENCIA BANCARIA');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (177, '2023-02-22', 36, 20, 25, 2182.77, 'Emergencia', 'PAGADA', '2023-11-12', 'TARJETA CRÉDITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (178, '2023-04-03', 113, 59, 3, 1878.22, 'Consulta Regular', 'PAGADA', '2023-10-26', 'MERCADO PAGO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (179, '2023-04-23', 70, 55, 6, 3648.67, 'Consulta Espontánea', 'PENDIENTE', '2023-11-24', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (180, '2023-03-01', 160, 20, 18, 4705.31, 'Consulta Regular', 'PAGADA', '2023-10-14', 'TARJETA DÉBITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (181, '2023-03-13', 116, 47, 27, 4394.07, 'Consulta Regular', 'PENDIENTE', '2023-12-13', 'MERCADO PAGO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (182, '2023-02-27', 44, 12, 34, 4838.97, 'Emergencia', 'PAGADA', '2023-11-19', 'TARJETA DÉBITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (183, '2023-03-13', 109, 57, 27, 1463.29, 'Consulta Regular', 'PAGADA', '2023-11-23', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (184, '2023-06-13', 24, 52, 31, 2909.88, 'Consulta Espontánea', 'PAGADA', '2023-10-09', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (185, '2023-03-23', 13, 10, 6, 3302.92, 'Emergencia', 'PAGADA', '2023-10-12', 'MERCADO PAGO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (186, '2023-06-08', 43, 14, 29, 3930.61, 'Consulta Espontánea', 'PAGADA', '2023-11-17', 'TRANSFERENCIA BANCARIA');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (187, '2023-07-07', 112, 22, 15, 2559.09, 'Consulta Regular', 'PAGADA', '2023-10-07', 'TARJETA CRÉDITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (188, '2023-07-24', 147, 26, 21, 4940.13, 'Consulta Espontánea', 'PAGADA', '2023-10-22', 'TRANSFERENCIA BANCARIA');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (189, '2023-06-23', 76, 35, 29, 2186.63, 'Consulta Espontánea', 'PENDIENTE', '2023-11-02', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (190, '2023-06-28', 68, 53, 10, 1749.03, 'Consulta Espontánea', 'PAGADA', '2023-12-05', 'TARJETA CRÉDITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (191, '2023-01-15', 153, 52, 22, 2486.27, 'Consulta Regular', 'PAGADA', '2023-11-29', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (192, '2023-05-25', 42, 27, 16, 3967.4, 'Emergencia', 'PAGADA', '2023-11-26', 'TRANSFERENCIA BANCARIA');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (193, '2023-06-30', 38, 56, 35, 3226.03, 'Consulta Regular', 'PAGADA', '2023-10-10', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (194, '2023-03-08', 19, 54, 19, 3033.91, 'Emergencia', 'PAGADA', '2023-11-02', 'TARJETA DÉBITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (195, '2023-06-10', 49, 2, 8, 2446.4, 'Consulta Regular', 'PAGADA', '2023-10-23', 'TARJETA CRÉDITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (196, '2023-08-02', 166, 42, 26, 1762.09, 'Emergencia', 'PAGADA', '2023-12-02', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (197, '2023-07-06', 42, 32, 8, 4734.2, 'Emergencia', 'PAGADA', '2023-11-30', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (198, '2023-01-12', 82, 7, 30, 1662.16, 'Consulta Regular', 'PAGADA', '2023-10-15', 'MERCADO PAGO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (199, '2023-05-16', 41, 33, 6, 3536.17, 'Emergencia', 'PAGADA', '2023-11-30', 'MERCADO PAGO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (200, '2023-07-20', 40, 11, 25, 3698.72, 'Consulta Regular', 'PAGADA', '2023-11-04', 'TARJETA CRÉDITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (201, '2023-04-18', 140, 16, 6, 2247.33, 'Emergencia', 'PAGADA', '2023-11-29', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (202, '2023-05-01', 133, 53, 21, 1128.53, 'Consulta Regular', 'PAGADA', '2023-11-10', 'MERCADO PAGO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (203, '2023-07-13', 34, 25, 17, 2105.25, 'Consulta Espontánea', 'PENDIENTE', '2023-11-16', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (204, '2023-05-30', 141, 38, 14, 3562.45, 'Consulta Espontánea', 'PAGADA', '2023-10-27', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (205, '2023-05-07', 133, 60, 8, 1169.06, 'Consulta Espontánea', 'PAGADA', '2023-11-06', 'TRANSFERENCIA BANCARIA');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (206, '2023-06-25', 13, 40, 7, 2481.82, 'Consulta Regular', 'PAGADA', '2023-12-09', 'TARJETA CRÉDITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (207, '2023-01-12', 143, 13, 12, 3379.6, 'Consulta Espontánea', 'PAGADA', '2023-11-30', 'TARJETA CRÉDITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (208, '2023-06-29', 79, 18, 18, 1548.16, 'Consulta Espontánea', 'PENDIENTE', '2023-10-14', 'TRANSFERENCIA BANCARIA');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (209, '2023-06-16', 11, 42, 18, 2937.15, 'Emergencia', 'PAGADA', '2023-10-06', 'TARJETA DÉBITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (210, '2023-02-20', 104, 60, 1, 3417.38, 'Consulta Regular', 'PAGADA', '2023-11-19', 'MERCADO PAGO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (211, '2023-02-15', 20, 50, 19, 2034.45, 'Consulta Regular', 'PAGADA', '2023-12-11', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (212, '2023-07-03', 46, 4, 16, 2078.22, 'Emergencia', 'PAGADA', '2023-10-14', 'TARJETA CRÉDITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (213, '2023-02-19', 27, 37, 26, 3509.91, 'Consulta Regular', 'PENDIENTE', '2023-11-17', 'TARJETA CRÉDITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (214, '2023-04-03', 163, 5, 29, 3240.48, 'Consulta Espontánea', 'PENDIENTE', '2023-11-29', 'MERCADO PAGO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (215, '2023-06-17', 11, 1, 34, 4196.16, 'Consulta Regular', 'PAGADA', '2023-12-01', 'TARJETA CRÉDITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (216, '2023-06-06', 93, 51, 26, 3449.15, 'Emergencia', 'PENDIENTE', '2023-11-15', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (217, '2023-03-22', 6, 16, 8, 2165.9, 'Consulta Espontánea', 'PAGADA', '2023-10-20', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (218, '2023-06-08', 144, 21, 23, 3598.56, 'Consulta Espontánea', 'PAGADA', '2023-11-27', 'TARJETA DÉBITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (219, '2023-06-26', 47, 43, 32, 2028.9, 'Emergencia', 'PAGADA', '2023-10-22', 'TARJETA CRÉDITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (220, '2023-04-20', 92, 15, 11, 1324.84, 'Emergencia', 'PAGADA', '2023-11-04', 'TARJETA CRÉDITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (221, '2023-01-29', 164, 32, 19, 4364.77, 'Emergencia', 'PAGADA', '2023-11-22', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (222, '2023-01-14', 42, 4, 24, 4162.38, 'Consulta Regular', 'PENDIENTE', '2023-11-15', 'TARJETA CRÉDITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (223, '2023-01-09', 80, 3, 25, 2655.0, 'Consulta Espontánea', 'PAGADA', '2023-12-08', 'TRANSFERENCIA BANCARIA');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (224, '2023-01-29', 148, 34, 34, 3199.64, 'Emergencia', 'PENDIENTE', '2023-11-02', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (225, '2023-05-26', 56, 51, 2, 4231.46, 'Consulta Regular', 'PAGADA', '2023-10-25', 'TRANSFERENCIA BANCARIA');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (226, '2023-07-19', 91, 31, 13, 2870.71, 'Emergencia', 'PENDIENTE', '2023-12-03', 'MERCADO PAGO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (227, '2023-07-26', 40, 8, 5, 1000.04, 'Consulta Espontánea', 'PENDIENTE', '2023-10-29', 'MERCADO PAGO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (228, '2023-02-09', 20, 5, 1, 3919.28, 'Emergencia', 'PENDIENTE', '2023-10-31', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (229, '2023-04-06', 42, 50, 8, 1907.03, 'Emergencia', 'PENDIENTE', '2023-11-02', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (230, '2023-06-23', 148, 59, 5, 1285.88, 'Consulta Espontánea', 'PAGADA', '2023-10-13', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (231, '2023-01-31', 52, 26, 20, 3545.43, 'Consulta Espontánea', 'PAGADA', '2023-10-07', 'TARJETA CRÉDITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (232, '2023-07-09', 106, 35, 3, 2492.11, 'Emergencia', 'PAGADA', '2023-11-24', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (233, '2023-06-19', 6, 2, 29, 4732.81, 'Consulta Espontánea', 'PAGADA', '2023-12-06', 'TARJETA DÉBITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (234, '2023-08-05', 31, 3, 35, 2949.18, 'Consulta Regular', 'PAGADA', '2023-11-29', 'TARJETA DÉBITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (235, '2023-07-15', 22, 20, 29, 3026.29, 'Consulta Espontánea', 'PAGADA', '2023-11-06', 'TARJETA DÉBITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (236, '2023-01-14', 19, 44, 30, 3397.3, 'Consulta Regular', 'PAGADA', '2023-10-12', 'TARJETA DÉBITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (237, '2023-08-08', 5, 53, 9, 2913.16, 'Consulta Regular', 'PENDIENTE', '2023-10-08', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (238, '2023-07-16', 57, 10, 22, 1206.8, 'Consulta Regular', 'PAGADA', '2023-11-27', 'TARJETA CRÉDITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (239, '2023-06-14', 7, 57, 29, 3548.61, 'Emergencia', 'PAGADA', '2023-11-16', 'MERCADO PAGO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (240, '2023-03-18', 159, 4, 31, 1862.77, 'Consulta Espontánea', 'PAGADA', '2023-10-23', 'TARJETA CRÉDITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (241, '2023-01-19', 112, 19, 14, 3945.49, 'Consulta Espontánea', 'PAGADA', '2023-11-30', 'TARJETA CRÉDITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (242, '2023-01-30', 3, 35, 7, 4248.19, 'Emergencia', 'PENDIENTE', '2023-11-07', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (243, '2023-08-07', 48, 3, 12, 2785.48, 'Emergencia', 'PAGADA', '2023-10-20', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (244, '2023-05-15', 19, 24, 11, 2087.52, 'Consulta Regular', 'PAGADA', '2023-10-09', 'TARJETA CRÉDITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (245, '2023-07-15', 157, 50, 1, 3448.53, 'Consulta Espontánea', 'PAGADA', '2023-10-25', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (246, '2023-05-13', 84, 20, 5, 1419.88, 'Emergencia', 'PAGADA', '2023-10-22', 'TARJETA DÉBITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (247, '2023-06-12', 120, 54, 12, 1257.78, 'Consulta Espontánea', 'PAGADA', '2023-11-15', 'TARJETA CRÉDITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (248, '2023-06-10', 155, 32, 3, 4934.68, 'Consulta Espontánea', 'PAGADA', '2023-11-19', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (249, '2023-07-31', 126, 8, 21, 3856.54, 'Consulta Regular', 'PENDIENTE', '2023-11-29', 'TARJETA CRÉDITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (250, '2023-05-18', 105, 28, 17, 4075.53, 'Consulta Regular', 'PAGADA', '2023-12-12', 'MERCADO PAGO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (251, '2023-02-19', 7, 23, 35, 2939.62, 'Consulta Espontánea', 'PAGADA', '2023-11-25', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (252, '2023-06-22', 33, 4, 24, 4286.33, 'Consulta Espontánea', 'PAGADA', '2023-11-03', 'MERCADO PAGO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (253, '2023-01-31', 78, 46, 26, 1402.27, 'Emergencia', 'PENDIENTE', '2023-11-23', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (254, '2023-02-02', 156, 1, 8, 4948.24, 'Consulta Espontánea', 'PAGADA', '2023-10-28', 'MERCADO PAGO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (255, '2023-07-30', 151, 18, 30, 3184.87, 'Emergencia', 'PAGADA', '2023-10-07', 'TARJETA CRÉDITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (256, '2023-07-28', 169, 12, 31, 4541.92, 'Consulta Regular', 'PAGADA', '2023-11-10', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (257, '2023-06-20', 159, 15, 21, 3945.38, 'Consulta Espontánea', 'PAGADA', '2023-11-18', 'TRANSFERENCIA BANCARIA');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (258, '2023-05-18', 167, 49, 19, 3674.42, 'Consulta Regular', 'PENDIENTE', '2023-10-11', 'TARJETA DÉBITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (259, '2023-02-10', 114, 1, 26, 3615.42, 'Consulta Espontánea', 'PAGADA', '2023-11-17', 'TARJETA DÉBITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (260, '2023-02-28', 40, 56, 22, 4016.19, 'Consulta Regular', 'PAGADA', '2023-10-17', 'TARJETA DÉBITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (261, '2023-02-12', 15, 2, 16, 2889.85, 'Emergencia', 'PENDIENTE', '2023-12-04', 'MERCADO PAGO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (262, '2023-07-25', 20, 30, 23, 4110.72, 'Emergencia', 'PAGADA', '2023-11-29', 'TARJETA CRÉDITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (263, '2023-01-16', 9, 35, 3, 4207.56, 'Consulta Espontánea', 'PENDIENTE', '2023-11-15', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (264, '2023-06-28', 152, 57, 12, 4313.51, 'Consulta Regular', 'PAGADA', '2023-10-15', 'TRANSFERENCIA BANCARIA');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (265, '2023-01-12', 56, 50, 12, 1574.5, 'Consulta Regular', 'PAGADA', '2023-12-04', 'TRANSFERENCIA BANCARIA');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (266, '2023-05-09', 127, 14, 26, 2407.28, 'Consulta Regular', 'PAGADA', '2023-10-23', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (267, '2023-01-14', 163, 34, 31, 4426.88, 'Consulta Regular', 'PENDIENTE', '2023-10-29', 'TRANSFERENCIA BANCARIA');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (268, '2023-05-28', 127, 13, 6, 3571.96, 'Consulta Espontánea', 'PAGADA', '2023-12-07', 'TARJETA CRÉDITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (269, '2023-03-05', 168, 34, 16, 1926.08, 'Emergencia', 'PAGADA', '2023-10-23', 'TARJETA DÉBITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (270, '2023-06-21', 131, 34, 28, 4900.62, 'Consulta Espontánea', 'PAGADA', '2023-11-14', 'TRANSFERENCIA BANCARIA');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (271, '2023-03-21', 62, 23, 26, 3528.94, 'Consulta Regular', 'PAGADA', '2023-11-16', 'TRANSFERENCIA BANCARIA');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (272, '2023-05-30', 125, 10, 20, 3152.71, 'Emergencia', 'PENDIENTE', '2023-11-18', 'TARJETA CRÉDITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (273, '2023-03-10', 94, 51, 11, 4127.89, 'Consulta Regular', 'PENDIENTE', '2023-11-16', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (274, '2023-05-02', 141, 18, 11, 3926.95, 'Consulta Regular', 'PAGADA', '2023-10-19', 'TRANSFERENCIA BANCARIA');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (275, '2023-05-05', 31, 53, 19, 3339.64, 'Consulta Regular', 'PAGADA', '2023-12-04', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (276, '2023-05-13', 66, 41, 9, 2175.53, 'Consulta Espontánea', 'PAGADA', '2023-11-05', 'MERCADO PAGO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (277, '2023-06-29', 52, 10, 9, 1117.7, 'Emergencia', 'PAGADA', '2023-12-03', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (278, '2023-03-03', 108, 33, 1, 1610.8, 'Consulta Espontánea', 'PAGADA', '2023-10-10', 'MERCADO PAGO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (279, '2023-02-12', 10, 40, 14, 1199.66, 'Consulta Regular', 'PAGADA', '2023-11-14', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (280, '2023-05-30', 151, 5, 26, 1888.41, 'Consulta Espontánea', 'PAGADA', '2023-10-22', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (281, '2023-07-15', 82, 58, 17, 2826.98, 'Emergencia', 'PAGADA', '2023-11-17', 'TRANSFERENCIA BANCARIA');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (282, '2023-01-21', 94, 49, 27, 3161.89, 'Emergencia', 'PAGADA', '2023-10-25', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (283, '2023-04-15', 98, 38, 18, 1838.06, 'Consulta Espontánea', 'PAGADA', '2023-11-21', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (284, '2023-03-08', 115, 13, 29, 3147.66, 'Consulta Regular', 'PENDIENTE', '2023-11-20', 'MERCADO PAGO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (285, '2023-05-14', 22, 17, 3, 2530.92, 'Consulta Espontánea', 'PENDIENTE', '2023-10-28', 'MERCADO PAGO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (286, '2023-07-01', 76, 31, 34, 3628.34, 'Emergencia', 'PAGADA', '2023-11-02', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (287, '2023-04-23', 141, 41, 30, 1718.18, 'Consulta Regular', 'PAGADA', '2023-11-18', 'TARJETA CRÉDITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (288, '2023-05-06', 128, 1, 5, 4832.56, 'Emergencia', 'PAGADA', '2023-11-10', 'TARJETA DÉBITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (289, '2023-01-16', 97, 24, 31, 2150.47, 'Emergencia', 'PAGADA', '2023-10-07', 'TRANSFERENCIA BANCARIA');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (290, '2023-01-12', 136, 60, 7, 1383.38, 'Consulta Espontánea', 'PAGADA', '2023-11-11', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (291, '2023-03-16', 63, 48, 24, 1876.79, 'Consulta Espontánea', 'PAGADA', '2023-11-10', 'TARJETA CRÉDITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (292, '2023-04-23', 75, 13, 29, 1761.39, 'Consulta Regular', 'PAGADA', '2023-10-09', 'TRANSFERENCIA BANCARIA');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (293, '2023-05-14', 122, 31, 29, 2460.9, 'Emergencia', 'PAGADA', '2023-12-02', 'MERCADO PAGO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (294, '2023-02-04', 13, 25, 11, 2482.49, 'Consulta Regular', 'PENDIENTE', '2023-12-02', 'MERCADO PAGO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (295, '2023-02-19', 167, 57, 30, 4419.42, 'Emergencia', 'PAGADA', '2023-11-09', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (296, '2023-05-27', 49, 35, 3, 1754.89, 'Consulta Regular', 'PAGADA', '2023-12-07', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (297, '2023-04-23', 84, 21, 4, 4243.81, 'Consulta Espontánea', 'PAGADA', '2023-10-19', 'TRANSFERENCIA BANCARIA');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (298, '2023-05-07', 48, 52, 13, 3737.56, 'Consulta Regular', 'PAGADA', '2023-10-11', 'TRANSFERENCIA BANCARIA');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (299, '2023-07-23', 100, 44, 3, 4485.22, 'Consulta Regular', 'PAGADA', '2023-12-09', 'MERCADO PAGO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (300, '2023-01-26', 25, 25, 23, 2756.96, 'Consulta Espontánea', 'PAGADA', '2023-10-25', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (301, '2023-02-01', 135, 54, 22, 1123.73, 'Consulta Espontánea', 'PENDIENTE', '2023-11-22', 'TRANSFERENCIA BANCARIA');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (302, '2023-07-16', 3, 26, 29, 4647.18, 'Consulta Regular', 'PAGADA', '2023-10-07', 'MERCADO PAGO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (303, '2023-02-20', 110, 45, 15, 4638.42, 'Emergencia', 'PENDIENTE', '2023-11-27', 'MERCADO PAGO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (304, '2023-08-08', 108, 31, 22, 4862.73, 'Consulta Espontánea', 'PAGADA', '2023-11-11', 'TARJETA CRÉDITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (305, '2023-06-19', 128, 20, 16, 3711.79, 'Emergencia', 'PAGADA', '2023-10-16', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (306, '2023-07-01', 39, 15, 30, 4197.03, 'Consulta Espontánea', 'PAGADA', '2023-10-12', 'TARJETA DÉBITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (307, '2023-07-10', 58, 12, 3, 2770.47, 'Consulta Regular', 'PAGADA', '2023-10-26', 'TRANSFERENCIA BANCARIA');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (308, '2023-06-24', 95, 40, 34, 1012.67, 'Consulta Espontánea', 'PAGADA', '2023-11-07', 'TRANSFERENCIA BANCARIA');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (309, '2023-07-23', 146, 21, 15, 2067.78, 'Emergencia', 'PAGADA', '2023-12-03', 'TARJETA CRÉDITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (310, '2023-02-07', 40, 12, 15, 1615.46, 'Consulta Regular', 'PAGADA', '2023-10-31', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (311, '2023-04-10', 106, 57, 3, 3784.7, 'Consulta Regular', 'PAGADA', '2023-10-12', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (312, '2023-02-17', 5, 55, 8, 2786.91, 'Consulta Regular', 'PAGADA', '2023-10-25', 'MERCADO PAGO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (313, '2023-01-30', 77, 59, 29, 1813.61, 'Consulta Espontánea', 'PAGADA', '2023-10-26', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (314, '2023-04-02', 118, 20, 9, 4529.55, 'Consulta Espontánea', 'PAGADA', '2023-11-30', 'TARJETA CRÉDITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (315, '2023-05-13', 39, 29, 18, 1516.79, 'Emergencia', 'PAGADA', '2023-12-07', 'TRANSFERENCIA BANCARIA');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (316, '2023-06-04', 162, 41, 4, 3222.71, 'Emergencia', 'PAGADA', '2023-12-06', 'TARJETA CRÉDITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (317, '2023-06-05', 154, 39, 21, 4629.92, 'Emergencia', 'PAGADA', '2023-10-10', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (318, '2023-06-04', 63, 1, 7, 2188.8, 'Emergencia', 'PAGADA', '2023-11-15', 'TARJETA CRÉDITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (319, '2023-05-22', 114, 12, 13, 2030.29, 'Consulta Regular', 'PAGADA', '2023-11-20', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (320, '2023-07-03', 81, 27, 6, 4947.64, 'Consulta Espontánea', 'PAGADA', '2023-10-20', 'TARJETA CRÉDITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (321, '2023-01-31', 22, 33, 14, 3500.33, 'Emergencia', 'PAGADA', '2023-12-05', 'MERCADO PAGO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (322, '2023-03-19', 66, 32, 29, 4936.48, 'Consulta Espontánea', 'PENDIENTE', '2023-11-30', 'TARJETA DÉBITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (323, '2023-03-07', 150, 57, 21, 4841.39, 'Consulta Espontánea', 'PAGADA', '2023-11-24', 'TARJETA DÉBITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (324, '2023-02-24', 48, 21, 1, 3548.2, 'Consulta Espontánea', 'PENDIENTE', '2023-12-11', 'TARJETA DÉBITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (325, '2023-07-17', 127, 48, 1, 1001.62, 'Emergencia', 'PAGADA', '2023-11-20', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (326, '2023-06-01', 92, 4, 13, 2369.46, 'Consulta Espontánea', 'PAGADA', '2023-11-24', 'TRANSFERENCIA BANCARIA');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (327, '2023-07-03', 25, 10, 35, 4320.59, 'Consulta Regular', 'PAGADA', '2023-11-26', 'MERCADO PAGO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (328, '2023-07-31', 68, 41, 13, 4558.09, 'Consulta Regular', 'PENDIENTE', '2023-12-13', 'TARJETA CRÉDITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (329, '2023-07-20', 67, 37, 15, 3293.46, 'Consulta Regular', 'PAGADA', '2023-11-06', 'TRANSFERENCIA BANCARIA');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (330, '2023-04-12', 139, 52, 28, 3494.49, 'Consulta Espontánea', 'PAGADA', '2023-12-08', 'MERCADO PAGO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (331, '2023-07-20', 74, 57, 20, 2542.35, 'Consulta Regular', 'PAGADA', '2023-11-25', 'MERCADO PAGO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (332, '2023-07-16', 145, 56, 20, 2548.37, 'Consulta Espontánea', 'PENDIENTE', '2023-12-06', 'MERCADO PAGO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (333, '2023-07-14', 59, 53, 13, 1882.79, 'Consulta Espontánea', 'PENDIENTE', '2023-12-01', 'TARJETA DÉBITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (334, '2023-05-03', 45, 6, 33, 3674.87, 'Consulta Espontánea', 'PAGADA', '2023-10-28', 'TARJETA DÉBITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (335, '2023-05-17', 161, 47, 4, 4330.54, 'Consulta Espontánea', 'PAGADA', '2023-11-06', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (336, '2023-02-24', 34, 15, 16, 2801.08, 'Consulta Espontánea', 'PAGADA', '2023-12-10', 'MERCADO PAGO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (337, '2023-08-09', 4, 3, 32, 4649.88, 'Consulta Espontánea', 'PAGADA', '2023-11-06', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (338, '2023-05-11', 107, 14, 18, 2557.95, 'Consulta Regular', 'PENDIENTE', '2023-10-22', 'TARJETA DÉBITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (339, '2023-05-15', 95, 49, 4, 1040.58, 'Emergencia', 'PAGADA', '2023-11-05', 'TARJETA CRÉDITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (340, '2023-03-23', 97, 33, 19, 4849.41, 'Emergencia', 'PENDIENTE', '2023-10-09', 'TARJETA DÉBITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (341, '2023-05-03', 83, 8, 22, 2253.07, 'Consulta Regular', 'PAGADA', '2023-12-08', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (342, '2023-06-22', 152, 26, 17, 3767.53, 'Consulta Espontánea', 'PENDIENTE', '2023-12-04', 'TARJETA DÉBITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (343, '2023-06-19', 68, 41, 33, 2404.62, 'Consulta Regular', 'PAGADA', '2023-11-13', 'TARJETA DÉBITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (344, '2023-06-23', 33, 39, 14, 2714.81, 'Consulta Espontánea', 'PAGADA', '2023-11-16', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (345, '2023-01-16', 27, 59, 23, 1844.32, 'Emergencia', 'PENDIENTE', '2023-12-03', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (346, '2023-04-03', 156, 19, 3, 1501.74, 'Consulta Regular', 'PAGADA', '2023-12-13', 'TARJETA DÉBITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (347, '2023-03-02', 139, 15, 29, 2235.68, 'Consulta Espontánea', 'PAGADA', '2023-11-03', 'TRANSFERENCIA BANCARIA');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (348, '2023-05-10', 167, 17, 14, 3279.54, 'Consulta Espontánea', 'PAGADA', '2023-11-14', 'TRANSFERENCIA BANCARIA');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (349, '2023-08-06', 110, 12, 5, 4936.9, 'Consulta Regular', 'PAGADA', '2023-10-13', 'TARJETA CRÉDITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (350, '2023-01-22', 8, 46, 33, 2898.72, 'Consulta Regular', 'PAGADA', '2023-10-14', 'TRANSFERENCIA BANCARIA');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (351, '2023-07-30', 139, 29, 8, 2235.71, 'Consulta Espontánea', 'PENDIENTE', '2023-12-06', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (352, '2023-05-28', 24, 7, 14, 4499.13, 'Emergencia', 'PAGADA', '2023-11-18', 'TARJETA DÉBITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (353, '2023-06-11', 65, 20, 30, 3089.38, 'Consulta Regular', 'PENDIENTE', '2023-11-07', 'TRANSFERENCIA BANCARIA');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (354, '2023-05-31', 170, 16, 14, 1876.46, 'Consulta Espontánea', 'PAGADA', '2023-12-07', 'TARJETA DÉBITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (355, '2023-01-28', 99, 41, 28, 4672.9, 'Emergencia', 'PAGADA', '2023-10-08', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (356, '2023-08-01', 162, 25, 7, 3154.96, 'Consulta Espontánea', 'PAGADA', '2023-12-06', 'MERCADO PAGO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (357, '2023-08-10', 136, 2, 18, 4812.33, 'Emergencia', 'PAGADA', '2023-10-09', 'TARJETA CRÉDITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (358, '2023-08-06', 32, 45, 18, 4266.71, 'Consulta Regular', 'PAGADA', '2023-10-22', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (359, '2023-04-07', 54, 3, 30, 1653.93, 'Consulta Regular', 'PENDIENTE', '2023-11-07', 'TARJETA DÉBITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (360, '2023-01-12', 76, 59, 26, 4602.37, 'Consulta Espontánea', 'PAGADA', '2023-10-29', 'TARJETA DÉBITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (361, '2023-07-12', 165, 22, 34, 1945.8, 'Consulta Espontánea', 'PAGADA', '2023-10-23', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (362, '2023-07-27', 169, 6, 4, 2722.22, 'Consulta Regular', 'PAGADA', '2023-12-05', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (363, '2023-04-07', 84, 7, 33, 3074.37, 'Consulta Espontánea', 'PAGADA', '2023-10-28', 'TRANSFERENCIA BANCARIA');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (364, '2023-01-21', 92, 8, 9, 2944.55, 'Emergencia', 'PAGADA', '2023-10-25', 'MERCADO PAGO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (365, '2023-06-17', 155, 51, 8, 2077.41, 'Consulta Regular', 'PAGADA', '2023-12-13', 'TARJETA DÉBITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (366, '2023-02-17', 66, 4, 9, 2895.18, 'Consulta Espontánea', 'PAGADA', '2023-10-08', 'TARJETA DÉBITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (367, '2023-06-19', 5, 29, 13, 1964.83, 'Consulta Regular', 'PENDIENTE', '2023-10-13', 'TRANSFERENCIA BANCARIA');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (368, '2023-02-23', 73, 26, 22, 1057.85, 'Emergencia', 'PENDIENTE', '2023-10-27', 'TARJETA DÉBITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (369, '2023-02-10', 141, 52, 17, 2977.46, 'Consulta Regular', 'PAGADA', '2023-10-10', 'MERCADO PAGO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (370, '2023-03-03', 63, 12, 19, 1312.27, 'Emergencia', 'PAGADA', '2023-12-06', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (371, '2023-02-04', 69, 30, 24, 3454.23, 'Emergencia', 'PAGADA', '2023-11-29', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (372, '2023-08-07', 115, 42, 23, 4349.67, 'Consulta Regular', 'PENDIENTE', '2023-11-23', 'TARJETA CRÉDITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (373, '2023-07-09', 20, 3, 15, 4000.29, 'Consulta Espontánea', 'PAGADA', '2023-10-12', 'TARJETA DÉBITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (374, '2023-08-07', 9, 20, 20, 1479.01, 'Consulta Regular', 'PAGADA', '2023-12-05', 'TARJETA CRÉDITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (375, '2023-01-24', 134, 10, 2, 1464.43, 'Consulta Regular', 'PAGADA', '2023-11-09', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (376, '2023-04-26', 27, 48, 25, 4599.77, 'Consulta Espontánea', 'PAGADA', '2023-10-10', 'TRANSFERENCIA BANCARIA');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (377, '2023-08-09', 83, 7, 16, 1646.43, 'Consulta Espontánea', 'PAGADA', '2023-10-30', 'TRANSFERENCIA BANCARIA');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (378, '2023-04-09', 169, 50, 25, 2438.67, 'Consulta Espontánea', 'PAGADA', '2023-12-09', 'TRANSFERENCIA BANCARIA');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (379, '2023-03-25', 150, 12, 33, 1766.66, 'Consulta Espontánea', 'PAGADA', '2023-11-04', 'MERCADO PAGO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (380, '2023-03-28', 61, 9, 10, 1850.88, 'Emergencia', 'PAGADA', '2023-11-26', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (381, '2023-04-11', 6, 30, 34, 4240.45, 'Consulta Regular', 'PAGADA', '2023-11-29', 'TRANSFERENCIA BANCARIA');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (382, '2023-07-09', 170, 53, 28, 3517.34, 'Consulta Espontánea', 'PAGADA', '2023-10-11', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (383, '2023-06-27', 5, 2, 2, 3749.21, 'Emergencia', 'PAGADA', '2023-11-21', 'TARJETA CRÉDITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (384, '2023-02-08', 108, 26, 15, 4535.5, 'Emergencia', 'PAGADA', '2023-11-25', 'MERCADO PAGO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (385, '2023-07-17', 26, 17, 19, 1557.7, 'Consulta Espontánea', 'PENDIENTE', '2023-12-09', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (386, '2023-01-27', 131, 50, 19, 2872.28, 'Emergencia', 'PAGADA', '2023-10-22', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (387, '2023-06-03', 71, 38, 8, 1185.75, 'Emergencia', 'PAGADA', '2023-11-02', 'TARJETA CRÉDITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (388, '2023-02-07', 47, 3, 28, 3939.82, 'Emergencia', 'PENDIENTE', '2023-11-09', 'TRANSFERENCIA BANCARIA');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (389, '2023-06-17', 136, 50, 26, 3502.27, 'Consulta Espontánea', 'PENDIENTE', '2023-12-03', 'TRANSFERENCIA BANCARIA');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (390, '2023-04-15', 105, 14, 17, 4638.83, 'Emergencia', 'PAGADA', '2023-12-02', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (391, '2023-03-21', 143, 47, 13, 1715.42, 'Consulta Regular', 'PAGADA', '2023-11-22', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (392, '2023-08-09', 94, 37, 1, 3991.34, 'Emergencia', 'PAGADA', '2023-12-13', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (393, '2023-03-20', 27, 37, 30, 1346.8, 'Consulta Regular', 'PENDIENTE', '2023-12-09', 'TARJETA CRÉDITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (394, '2023-02-20', 100, 48, 5, 3459.27, 'Consulta Regular', 'PAGADA', '2023-11-05', 'MERCADO PAGO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (395, '2023-03-18', 115, 6, 5, 2314.76, 'Consulta Espontánea', 'PAGADA', '2023-11-18', 'TARJETA CRÉDITO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (396, '2023-06-27', 94, 26, 21, 3246.22, 'Emergencia', 'PAGADA', '2023-11-06', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (397, '2023-04-14', 68, 7, 2, 2866.72, 'Consulta Espontánea', 'PAGADA', '2023-10-24', 'EFECTIVO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (398, '2023-07-27', 161, 27, 1, 2495.01, 'Consulta Regular', 'PAGADA', '2023-10-25', 'MERCADO PAGO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (399, '2023-05-15', 22, 51, 21, 1094.33, 'Consulta Espontánea', 'PAGADA', '2023-11-17', 'MERCADO PAGO');
                insert into facturas (numero_factura, fecha_emision, id_paciente, id_medico, id_obra_social, total_factura, descripcion, estado, fecha_vencimiento, metodo_pago) values (400, '2023-02-07', 94, 1, 30, 1069.85, 'Consulta Regular', 'PAGADA', '2023-11-19', 'EFECTIVO');
-- PARA CHEQUEAR QUE LOS DATOS HAYAN SIDO CARGADOS CORRECTAMENTE, DESCOMENTAR Y EJECUTAR LA SIGUIENTE LÍNEA
-- SELECT * FROM facturas;



-- ESTE SCRIPT INSERTA DATOS EN LA TABLA 'recetas'
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (18, 64, 27, 'Colonoscopia virtual', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (4, 6, 2, 'Aspirina', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (16, 161, 38, 'Ecocardiograma', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (22, 97, 16, 'Losartán', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (29, 11, 54, 'Fluoxetina', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (5, 153, 13, 'Resonancia magnética (RM)', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (6, 90, 7, 'Tomografía de cráneo', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (5, 51, 35, 'Audiometría', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (31, 105, 27, 'Audiometría', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (2, 63, 41, 'Prueba de glucosa en ayunas', 'URGENTE');
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (8, 165, 57, 'Ecocardiograma', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (23, 17, 15, 'Ibuprofeno', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (9, 82, 13, 'Ecografía abdominal', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (2, 55, 32, 'Omeprazol', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (6, 128, 38, 'Prueba de tolerancia a la glucosa', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (2, 108, 40, 'Prueba de función pulmonar', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (31, 150, 55, 'Insulina glargina', 'NORMAL');
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (4, 15, 2, 'Metoclopramida', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (23, 103, 57, 'Mamografía', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (22, 146, 39, 'Tomografía computarizada (TC)', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (13, 116, 56, 'Prueba de esfuerzo', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (13, 23, 39, 'Análisis de sangre completo', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (11, 43, 26, 'Audiometría', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (3, 127, 50, 'Holter de ritmo cardíaco', 'NORMAL');
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (5, 71, 57, 'Audiometría', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (22, 134, 54, 'Mamografía', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (9, 94, 26, 'Hidroclorotiazida', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (11, 54, 38, 'Loratadina', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (20, 15, 58, 'Fluoxetina', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (1, 23, 18, 'Insulina glargina', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (27, 145, 24, 'Metformina', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (16, 51, 49, 'Metformina', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (20, 132, 49, 'Dipirona', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (24, 151, 10, 'Furosemida', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (20, 13, 12, 'Colonoscopia', 'NORMAL');
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (9, 13, 26, 'Mamografía', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (25, 117, 53, 'Ergometría', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (20, 23, 31, 'Tomografía de cráneo', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (19, 24, 6, 'Prueba de glucosa en ayunas', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (4, 165, 19, 'Alprazolam', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (17, 93, 42, 'Endoscopia digestiva', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (29, 130, 21, 'Electrocardiograma (ECG)', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (6, 64, 17, 'Prednisona', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (33, 152, 54, 'Ecografía abdominal', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (21, 101, 42, 'Metoclopramida', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (19, 57, 52, 'Warfarina', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (33, 65, 6, 'Colonoscopia', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (30, 24, 58, 'Insulina glargina', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (12, 166, 2, 'Atorvastatina', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (30, 43, 40, 'Atorvastatina', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (17, 149, 14, 'Escitalopram', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (8, 156, 33, 'Holter de ritmo cardíaco', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (8, 91, 28, 'Endoscopia digestiva', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (8, 99, 51, 'Ergometría', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (10, 83, 10, 'Mamografía', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (29, 122, 60, 'Paracetamol', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (2, 116, 41, 'Ergometría', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (8, 149, 38, 'Colonoscopia', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (25, 166, 43, 'Aspirina', 'URGENTE');
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (3, 108, 21, 'Furosemida', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (22, 13, 29, 'Biopsia de piel', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (19, 46, 19, 'Dipirona', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (27, 18, 22, 'Fundoscopía', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (4, 84, 40, 'Ibuprofeno', 'URGENTE');
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (31, 32, 32, 'Dipirona', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (21, 24, 48, 'Fluoxetina', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (4, 35, 39, 'Prednisona', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (3, 42, 35, 'Amoxicilina', 'NORMAL');
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (3, 153, 17, 'Omeprazol', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (15, 120, 20, 'Loratadina', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (11, 36, 40, 'Amoxicilina', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (32, 110, 53, 'Análisis de sangre completo', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (7, 148, 22, 'Pantoprazol', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (20, 92, 4, 'Insulina glargina', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (1, 143, 31, 'Omeprazol', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (11, 81, 55, 'Alprazolam', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (7, 162, 52, 'Salbutamol', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (22, 21, 3, 'Esofagogastroduodenoscopia (EGD)', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (31, 63, 7, 'Prueba de función pulmonar', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (1, 30, 39, 'Cetirizina', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (31, 125, 19, 'Hidroclorotiazida', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (33, 96, 35, 'Prueba de función pulmonar', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (9, 7, 30, 'Prueba de función pulmonar', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (2, 43, 23, 'Metoclopramida', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (23, 13, 49, 'Fundoscopía', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (3, 130, 27, 'Insulina glargina', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (20, 34, 46, 'Prednisona', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (33, 148, 48, 'Prueba de Papanicolaou', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (34, 164, 48, 'Metformina', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (2, 1, 59, 'Audiometría', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (16, 77, 59, 'Prueba de función pulmonar', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (13, 79, 27, 'Montelukast', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (26, 29, 33, 'Metformina', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (26, 77, 6, 'Furosemida', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (24, 44, 10, 'Ibuprofeno', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (29, 110, 50, 'Amoxicilina', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (2, 87, 43, 'Naproxeno', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (26, 145, 37, 'Loratadina', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (13, 49, 37, 'Omeprazol', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (28, 165, 28, 'Metformina', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (16, 119, 4, 'Endoscopia digestiva', 'NORMAL');
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (30, 45, 6, 'Alprazolam', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (27, 110, 49, 'Audiometría', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (8, 10, 37, 'Naproxeno', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (33, 107, 56, 'Tomografía de cráneo', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (14, 54, 28, 'Amlodipino', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (24, 110, 15, 'Ibuprofeno', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (20, 89, 55, 'Salbutamol', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (18, 120, 43, 'Holter de ritmo cardíaco', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (23, 11, 3, 'Escitalopram', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (35, 155, 52, 'Enalapril', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (18, 141, 47, 'Prueba de función pulmonar', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (18, 81, 33, 'Prednisona', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (12, 36, 18, 'Densitometría ósea', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (21, 21, 30, 'Naproxeno', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (9, 130, 57, 'Prueba de función pulmonar', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (23, 71, 42, 'Electrocardiograma (ECG)', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (31, 138, 5, 'Ecocardiograma', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (14, 124, 4, 'Amoxicilina', 'URGENTE');
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (1, 113, 56, 'Levotiroxina', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (16, 48, 24, 'Dipirona', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (4, 88, 8, 'Omeprazol', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (26, 141, 37, 'Examen de orina', 'NORMAL');
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (28, 118, 4, 'Prueba de Papanicolaou', 'URGENTE');
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (12, 97, 46, 'Mamografía', 'URGENTE');
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (18, 51, 53, 'Prueba de tolerancia a la glucosa', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (15, 38, 55, 'Fluoxetina', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (6, 71, 12, 'Levotiroxina', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (13, 129, 17, 'Cetirizina', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (5, 121, 17, 'Prednisona', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (24, 109, 7, 'Fundoscopía', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (3, 20, 55, 'Losartán', 'NORMAL');
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (2, 17, 46, 'Fundoscopía', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (20, 1, 15, 'Tomografía computarizada (TC)', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (15, 111, 47, 'Electrocardiograma (ECG)', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (14, 79, 52, 'Escitalopram', 'NORMAL');
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (9, 149, 57, 'Prueba de función pulmonar', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (21, 151, 24, 'Biopsia de piel', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (23, 77, 46, 'Ergometría', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (3, 43, 19, 'Fluoxetina', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (31, 123, 19, 'Hemocultivo', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (33, 66, 37, 'Amoxicilina', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (10, 121, 17, 'Prueba de tolerancia a la glucosa', 'NORMAL');
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (18, 54, 46, 'Losartán', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (5, 135, 17, 'Metoclopramida', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (30, 41, 2, 'Examen de orina', 'NORMAL');
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (1, 5, 56, 'Furosemida', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (34, 136, 9, 'Atorvastatina', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (26, 152, 26, 'Endoscopia digestiva', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (1, 122, 27, 'Ibuprofeno', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (3, 91, 55, 'Audiometría', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (30, 67, 17, 'Warfarina', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (31, 69, 11, 'Colonoscopia', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (14, 76, 29, 'Losartán', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (24, 153, 25, 'Paracetamol', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (14, 42, 16, 'Salbutamol', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (26, 56, 6, 'Examen de orina', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (30, 106, 11, 'Alprazolam', 'URGENTE');
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (15, 68, 27, 'Mamografía', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (4, 7, 39, 'Cetirizina', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (27, 140, 25, 'Examen de orina', 'NORMAL');
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (22, 142, 3, 'Prueba de esfuerzo', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (16, 142, 38, 'Levotiroxina', 'NORMAL');
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (23, 11, 33, 'Holter de ritmo cardíaco', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (35, 73, 12, 'Codeína', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (33, 159, 1, 'Fundoscopía', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (12, 116, 19, 'Resonancia magnética (RM)', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (35, 127, 28, 'Codeína', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (22, 157, 32, 'Colonoscopia', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (5, 31, 9, 'Holter de ritmo cardíaco', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (20, 84, 2, 'Prueba de embarazo en sangre', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (15, 111, 49, 'Enalapril', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (23, 78, 9, 'Cetirizina', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (15, 131, 37, 'Audiometría', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (2, 38, 33, 'Examen de orina', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (16, 1, 8, 'Codeína', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (10, 66, 19, 'Ibuprofeno', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (15, 103, 27, 'Ciprofloxacina', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (24, 63, 53, 'Electrocardiograma (ECG)', 'NORMAL');
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (27, 126, 54, 'Biopsia de piel', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (30, 110, 22, 'Esofagogastroduodenoscopia (EGD)', 'NORMAL');
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (26, 83, 4, 'Prueba de esfuerzo', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (6, 10, 14, 'Aspirina', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (21, 107, 52, 'Densitometría ósea', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (11, 34, 7, 'Metoclopramida', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (16, 92, 3, 'Audiometría', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (16, 86, 32, 'Audiometría', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (35, 161, 5, 'Audiometría', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (33, 140, 28, 'Mamografía', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (6, 170, 6, 'Radiografía de tórax', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (7, 65, 58, 'Furosemida', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (11, 153, 13, 'Pantoprazol', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (26, 164, 47, 'Insulina glargina', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (16, 167, 9, 'Esofagogastroduodenoscopia (EGD)', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (17, 58, 18, 'Ergometría', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (33, 33, 6, 'Fluoxetina', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (18, 104, 34, 'Endoscopia digestiva', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (8, 33, 53, 'Prueba de embarazo en sangre', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (9, 21, 18, 'Resonancia magnética (RM)', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (27, 112, 14, 'Loratadina', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (17, 23, 27, 'Naproxeno', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (31, 142, 33, 'Ecocardiograma', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (16, 138, 29, 'Loratadina', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (14, 83, 34, 'Biopsia de piel', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (26, 60, 31, 'Fundoscopía', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (12, 12, 1, 'Biopsia de piel', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (13, 7, 41, 'Prueba de Papanicolaou', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (8, 4, 12, 'Resonancia magnética (RM)', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (34, 100, 55, 'Mamografía', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (11, 62, 29, 'Endoscopia digestiva', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (14, 125, 17, 'Fluoxetina', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (31, 83, 14, 'Audiometría', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (2, 37, 56, 'Ergometría', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (10, 158, 56, 'Cetirizina', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (25, 42, 35, 'Examen de orina', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (17, 63, 58, 'Tomografía de cráneo', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (32, 13, 53, 'Tomografía de cráneo', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (23, 51, 22, 'Pantoprazol', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (27, 154, 9, 'Ranitidina', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (10, 110, 6, 'Dipirona', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (21, 14, 37, 'Hidroclorotiazida', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (29, 9, 14, 'Furosemida', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (34, 58, 44, 'Losartán', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (9, 129, 50, 'Omeprazol', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (27, 168, 10, 'Mamografía', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (20, 120, 14, 'Warfarina', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (13, 58, 37, 'Biopsia de piel', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (10, 84, 52, 'Colonoscopia', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (23, 7, 32, 'Tomografía de cráneo', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (13, 91, 7, 'Fluoxetina', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (34, 10, 29, 'Tomografía de cráneo', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (23, 30, 53, 'Pantoprazol', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (22, 133, 43, 'Prueba de función pulmonar', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (24, 166, 13, 'Ecografía abdominal', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (18, 29, 9, 'Examen de orina', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (16, 143, 30, 'Ecocardiograma', 'NORMAL');
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (35, 41, 50, 'Furosemida', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (22, 167, 44, 'Omeprazol', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (1, 113, 18, 'Amlodipino', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (20, 18, 52, 'Audiometría', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (4, 51, 3, 'Tomografía computarizada (TC)', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (33, 82, 30, 'Loratadina', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (16, 127, 1, 'Salbutamol', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (31, 145, 37, 'Ciprofloxacina', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (31, 84, 1, 'Mamografía', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (13, 119, 56, 'Colonoscopia', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (32, 58, 51, 'Fluoxetina', 'NORMAL');
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (5, 88, 51, 'Loratadina', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (7, 89, 26, 'Pantoprazol', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (32, 59, 49, 'Análisis de sangre completo', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (2, 95, 29, 'Atorvastatina', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (24, 22, 41, 'Atorvastatina', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (1, 33, 42, 'Dipirona', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (3, 81, 19, 'Enalapril', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (15, 111, 24, 'Loratadina', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (29, 61, 15, 'Hemocultivo', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (33, 168, 60, 'Audiometría', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (1, 40, 36, 'Radiografía de tórax', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (6, 112, 56, 'Naproxeno', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (11, 121, 4, 'Prueba de función pulmonar', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (26, 84, 22, 'Codeína', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (22, 74, 50, 'Cetirizina', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (15, 138, 60, 'Tomografía computarizada (TC)', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (12, 169, 48, 'Atorvastatina', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (6, 131, 51, 'Audiometría', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (25, 74, 21, 'Salbutamol', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (14, 48, 17, 'Metoclopramida', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (17, 2, 36, 'Colonoscopia', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (19, 66, 33, 'Omeprazol', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (6, 74, 45, 'Prueba de embarazo en sangre', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (7, 112, 37, 'Biopsia de piel', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (2, 21, 53, 'Prueba de embarazo en sangre', 'NORMAL');
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (26, 84, 59, 'Mamografía', 'NORMAL');
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (15, 136, 4, 'Audiometría', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (13, 33, 36, 'Levotiroxina', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (34, 69, 16, 'Prueba de Papanicolaou', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (28, 46, 55, 'Colonoscopia', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (1, 103, 59, 'Codeína', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (34, 58, 27, 'Ergometría', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (35, 24, 50, 'Ibuprofeno', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (8, 93, 40, 'Levotiroxina', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (33, 11, 39, 'Codeína', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (18, 158, 10, 'Fluoxetina', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (33, 5, 25, 'Levotiroxina', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (12, 98, 39, 'Ibuprofeno', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (32, 19, 28, 'Prueba de Papanicolaou', 'NORMAL');
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (10, 150, 12, 'Warfarina', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (19, 124, 42, 'Ergometría', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (24, 165, 55, 'Hidroclorotiazida', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (3, 162, 60, 'Hidroclorotiazida', 'NORMAL');
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (21, 134, 59, 'Omeprazol', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (34, 7, 8, 'Prueba de función pulmonar', 'NORMAL');
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (1, 83, 8, 'Prednisona', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (33, 87, 45, 'Enalapril', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (22, 143, 8, 'Audiometría', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (31, 136, 36, 'Prednisona', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (6, 38, 22, 'Examen de orina', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (21, 155, 50, 'Ergometría', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (9, 45, 17, 'Levotiroxina', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (31, 159, 23, 'Aspirina', 'NORMAL');
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (5, 106, 54, 'Escitalopram', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (30, 29, 32, 'Holter de ritmo cardíaco', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (1, 105, 18, 'Amlodipino', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (30, 55, 21, 'Metformina', 'NORMAL');
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (24, 70, 23, 'Ranitidina', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (16, 165, 8, 'Atorvastatina', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (24, 141, 35, 'Densitometría ósea', 'URGENTE');
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (21, 125, 10, 'Colonoscopia', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (10, 122, 18, 'Alprazolam', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (2, 78, 26, 'Audiometría', 'URGENTE');
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (13, 20, 1, 'Alprazolam', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (31, 100, 53, 'Ciprofloxacina', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (11, 113, 17, 'Alprazolam', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (14, 68, 9, 'Hidroclorotiazida', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (13, 88, 53, 'Prueba de función pulmonar', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (34, 131, 4, 'Losartán', 'URGENTE');
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (4, 157, 12, 'Atorvastatina', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (15, 48, 21, 'Audiometría', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (11, 112, 53, 'Furosemida', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (4, 144, 42, 'Prueba de función pulmonar', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (32, 65, 54, 'Metoclopramida', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (2, 65, 45, 'Mamografía', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (32, 153, 8, 'Ciprofloxacina', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (19, 102, 2, 'Amlodipino', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (4, 150, 36, 'Furosemida', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (5, 75, 21, 'Colonoscopia', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (23, 52, 27, 'Colonoscopia virtual', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (25, 41, 34, 'Ciprofloxacina', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (8, 101, 11, 'Tomografía computarizada (TC)', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (5, 52, 32, 'Densitometría ósea', 'URGENTE');
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (34, 127, 32, 'Prednisona', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (4, 119, 23, 'Montelukast', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (31, 152, 23, 'Examen de orina', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (8, 105, 15, 'Escitalopram', 'NORMAL');
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (16, 22, 44, 'Mamografía', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (30, 90, 15, 'Audiometría', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (16, 82, 39, 'Salbutamol', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (19, 119, 45, 'Prueba de glucosa en ayunas', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (4, 28, 60, 'Furosemida', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (23, 131, 29, 'Tomografía computarizada (TC)', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (27, 12, 24, 'Ergometría', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (3, 164, 27, 'Metformina', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (10, 135, 7, 'Tomografía de cráneo', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (24, 82, 5, 'Loratadina', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (30, 23, 57, 'Pantoprazol', 'URGENTE');
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (12, 101, 44, 'Fundoscopía', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (29, 137, 19, 'Levotiroxina', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (20, 14, 2, 'Ibuprofeno', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (19, 119, 41, 'Cetirizina', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (8, 147, 1, 'Esofagogastroduodenoscopia (EGD)', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (15, 30, 10, 'Metformina', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (30, 102, 23, 'Metoclopramida', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (17, 111, 21, 'Fundoscopía', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (9, 70, 11, 'Biopsia de piel', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (34, 60, 8, 'Mamografía', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (8, 6, 53, 'Biopsia de piel', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (24, 44, 17, 'Colonoscopia', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (8, 151, 6, 'Ergometría', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (26, 49, 28, 'Warfarina', 'URGENTE');
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (13, 110, 4, 'Furosemida', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (4, 82, 40, 'Furosemida', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (7, 150, 14, 'Colonoscopia', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (10, 99, 41, 'Prueba de glucosa en ayunas', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (16, 39, 21, 'Amlodipino', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (31, 63, 26, 'Prueba de tolerancia a la glucosa', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (8, 10, 45, 'Prueba de embarazo en sangre', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (31, 71, 53, 'Insulina glargina', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (30, 115, 60, 'Ecocardiograma', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (33, 75, 58, 'Electrocardiograma (ECG)', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (27, 45, 17, 'Metformina', 'URGENTE');
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (33, 155, 28, 'Naproxeno', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (1, 137, 17, 'Audiometría', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (14, 13, 13, 'Amoxicilina', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (12, 56, 57, 'Amlodipino', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (28, 82, 3, 'Alprazolam', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (19, 49, 50, 'Colonoscopia', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (31, 165, 55, 'Montelukast', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (22, 153, 14, 'Tomografía computarizada (TC)', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (3, 133, 12, 'Examen de orina', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (4, 29, 19, 'Análisis de sangre completo', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (12, 23, 60, 'Resonancia magnética (RM)', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (29, 43, 53, 'Prueba de embarazo en sangre', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (34, 30, 32, 'Cetirizina', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (29, 162, 26, 'Colonoscopia', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (2, 14, 45, 'Hemocultivo', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (31, 50, 30, 'Alprazolam', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (21, 144, 6, 'Esofagogastroduodenoscopia (EGD)', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (23, 84, 19, 'Alprazolam', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (34, 95, 7, 'Ergometría', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (3, 151, 58, 'Prueba de tolerancia a la glucosa', 'NORMAL');
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (26, 110, 35, 'Resonancia magnética (RM)', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (24, 40, 48, 'Fundoscopía', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (21, 77, 1, 'Examen de orina', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (10, 50, 6, 'Furosemida', 'URGENTE');
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (22, 15, 37, 'Tomografía computarizada (TC)', 'URGENTE');
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (13, 78, 1, 'Ciprofloxacina', 'URGENTE');
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (28, 136, 15, 'Ecografía abdominal', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (7, 140, 46, 'Losartán', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (31, 101, 38, 'Naproxeno', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (16, 102, 46, 'Audiometría', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (24, 125, 58, 'Warfarina', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (22, 20, 42, 'Colonoscopia virtual', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (23, 106, 49, 'Alprazolam', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (7, 128, 52, 'Aspirina', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (14, 44, 12, 'Ibuprofeno', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (24, 18, 58, 'Insulina glargina', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (11, 93, 28, 'Ibuprofeno', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (7, 131, 46, 'Warfarina', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (16, 52, 46, 'Fundoscopía', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (29, 86, 33, 'Prueba de esfuerzo', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (23, 124, 1, 'Amlodipino', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (2, 37, 13, 'Prueba de embarazo en sangre', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (7, 51, 29, 'Endoscopia digestiva', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (10, 62, 35, 'Hemocultivo', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (14, 95, 53, 'Paracetamol', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (29, 72, 18, 'Tomografía de cráneo', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (32, 9, 3, 'Biopsia de piel', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (14, 57, 5, 'Colonoscopia virtual', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (21, 5, 26, 'Losartán', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (24, 118, 5, 'Prednisona', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (29, 44, 14, 'Resonancia magnética (RM)', 'URGENTE');
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (22, 11, 51, 'Prueba de glucosa en ayunas', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (18, 156, 27, 'Ecocardiograma', 'URGENTE');
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (3, 9, 32, 'Ibuprofeno', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (6, 161, 7, 'Análisis de sangre completo', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (16, 7, 13, 'Warfarina', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (20, 44, 34, 'Electrocardiograma (ECG)', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (15, 165, 40, 'Ranitidina', 'NORMAL');
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (3, 108, 16, 'Prueba de esfuerzo', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (20, 28, 51, 'Biopsia de piel', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (30, 126, 59, 'Paracetamol', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (28, 72, 1, 'Esofagogastroduodenoscopia (EGD)', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (29, 164, 19, 'Ecografía abdominal', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (14, 46, 11, 'Ecocardiograma', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (32, 151, 31, 'Mamografía', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (35, 61, 28, 'Amoxicilina', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (14, 166, 53, 'Fundoscopía', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (25, 33, 42, 'Endoscopia digestiva', 'NORMAL');
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (34, 79, 1, 'Paracetamol', 'URGENTE');
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (7, 116, 11, 'Alprazolam', 'NORMAL');
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (35, 98, 25, 'Densitometría ósea', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (6, 76, 30, 'Dipirona', 'NORMAL');
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (14, 81, 9, 'Omeprazol', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (30, 122, 46, 'Cetirizina', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (1, 69, 7, 'Amoxicilina', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (7, 8, 52, 'Ranitidina', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (17, 120, 10, 'Radiografía de tórax', 'NORMAL');
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (26, 82, 41, 'Metformina', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (10, 70, 12, 'Pantoprazol', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (3, 123, 38, 'Enalapril', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (24, 83, 48, 'Endoscopia digestiva', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (5, 13, 59, 'Amoxicilina', 'NORMAL');
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (24, 52, 7, 'Atorvastatina', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (6, 2, 49, 'Cetirizina', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (7, 17, 30, 'Ecografía abdominal', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (21, 112, 3, 'Levotiroxina', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (31, 104, 8, 'Warfarina', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (6, 46, 17, 'Montelukast', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (24, 3, 50, 'Resonancia magnética (RM)', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (5, 99, 38, 'Naproxeno', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (35, 83, 37, 'Prueba de glucosa en ayunas', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (4, 124, 29, 'Radiografía de tórax', 'NORMAL');
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (17, 35, 52, 'Losartán', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (19, 14, 21, 'Hemocultivo', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (3, 124, 46, 'Paracetamol', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (28, 150, 46, 'Ranitidina', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (16, 73, 49, 'Ecografía abdominal', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (23, 99, 49, 'Radiografía de tórax', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (16, 147, 30, 'Tomografía computarizada (TC)', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (31, 70, 42, 'Montelukast', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (17, 113, 19, 'Ibuprofeno', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (23, 45, 44, 'Examen de orina', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (31, 99, 28, 'Levotiroxina', 'NORMAL');
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (15, 4, 4, 'Mamografía', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (33, 145, 28, 'Prueba de glucosa en ayunas', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (31, 46, 34, 'Ecocardiograma', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (33, 115, 31, 'Densitometría ósea', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (5, 31, 49, 'Levotiroxina', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (18, 55, 24, 'Metformina', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (31, 63, 4, 'Prednisona', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (33, 104, 15, 'Codeína', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (15, 124, 44, 'Loratadina', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (35, 146, 50, 'Mamografía', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (17, 108, 5, 'Ecografía abdominal', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (14, 68, 23, 'Resonancia magnética (RM)', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (22, 106, 36, 'Ergometría', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (5, 158, 12, 'Amlodipino', 'URGENTE');
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (14, 72, 58, 'Examen de orina', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (15, 139, 33, 'Pantoprazol', null);
                insert into recetas (id_obra_social, id_paciente, id_medico, medicamento_recetado, notas_adicionales) values (3, 98, 52, 'Dipirona', null);
-- PARA CHEQUEAR QUE LOS DATOS HAYAN SIDO CARGADOS CORRECTAMENTE, DESCOMENTAR Y EJECUTAR LA SIGUIENTE LÍNEA
-- SELECT * FROM recetas;


-- SE EJECUTAN LOS SIGUIENTES STORED PROCEDURES, PARA ACTUALIZAR EL CONTENIDO DE LAS TABLAS CORRESPONDIENTES
CALL sp_ingresos_facturacion_mensual();
CALL sp_rendimiento_medico();


/* ================ SCRIPT DE CONSULTAS ================ */

-- 1. RANGO ETARIO DE LOS PACIENTES
SELECT 
    CASE
        WHEN TIMESTAMPDIFF(YEAR, fecha_nacimiento, CURDATE()) < 18 THEN 'Menor de 18 años'
        WHEN TIMESTAMPDIFF(YEAR, fecha_nacimiento, CURDATE()) BETWEEN 18 AND 30 THEN '18-30 años'
        WHEN TIMESTAMPDIFF(YEAR, fecha_nacimiento, CURDATE()) BETWEEN 31 AND 50 THEN '31-50 años'
        WHEN TIMESTAMPDIFF(YEAR, fecha_nacimiento, CURDATE()) > 50 THEN 'Mayor de 50 años'
    END AS rango_etario,
    COUNT(*) AS cantidad_pacientes
FROM 
    pacientes
GROUP BY 
    rango_etario
ORDER BY 
    MIN(TIMESTAMPDIFF(YEAR, fecha_nacimiento, CURDATE()));


-- 2. CANTIDAD DE PACIENTES POR OBRA SOCIAL
SELECT 
    obra_social,
    COUNT(*) AS cantidad_pacientes
FROM 
    pacientes
GROUP BY 
    obra_social
ORDER BY obra_social;


-- 3. CANTIDAD DE PACIENTES ATENDIDOS (CON CITA CONCRETADA)POR CADA MÉDICO 
SELECT
    id_medico,
    COUNT(*) AS cantidad_pacientes_atendidos
FROM
    citas_medicas
WHERE estado = 'REALIZADA'
GROUP BY
    id_medico
ORDER BY cantidad_pacientes_atendidos DESC;

-- 4. CANTIDAD PACIENTES CON COBERTURA MÉDICA Y SIN COBERTURA MÉDICA
SELECT
    (SELECT COUNT(*) FROM pacientes WHERE obra_social <> 'PARTICULAR') AS pacientes_con_cobertura,
    (SELECT COUNT(*) FROM pacientes WHERE obra_social = 'PARTICULAR') AS pacientes_sin_cobertura;

-- 5. PROMEDIO DEL INGRESO GENERADO POR UN PACIENTE CON COBERTURA EN RELACIÓN A UNO SIN COBERTURA
SELECT
    AVG(CASE WHEN p.obra_social <> 'PARTICULAR' THEN f.total_factura ELSE NULL END) AS promedio_con_cobertura,
    AVG(CASE WHEN p.obra_social = 'PARTICULAR' THEN f.total_factura ELSE NULL END) AS promedio_sin_cobertura
FROM pacientes p
LEFT JOIN facturas f ON p.id = f.id_paciente;

-- 6. CANTIDAD DE FACTURAS PAGADAS CADA MÉTODO DE PAGO 
SELECT
    SUM(CASE WHEN metodo_pago = 'EFECTIVO' THEN 1 ELSE 0 END) AS cantidad_efectivo,
    SUM(CASE WHEN metodo_pago = 'TARJETA DÉBITO' THEN 1 ELSE 0 END) AS cantidad_tarjeta_debito,
    SUM(CASE WHEN metodo_pago = 'TARJETA CRÉDITO' THEN 1 ELSE 0 END) AS cantidad_tarjeta_credito,
    SUM(CASE WHEN metodo_pago = 'TRANSFERENCIA BANCARIA' THEN 1 ELSE 0 END) AS cantidad_transferencia,
    SUM(CASE WHEN metodo_pago = 'MERCADO PAGO' THEN 1 ELSE 0 END) AS cantidad_mercado_pago
FROM facturas;


-- 7. LISTAR LOS PACIENTES CON SU CANTIDAD DE CITAS MÉDICAS PENDIENTES.:
SELECT p.nombre, p.apellido, COUNT(cm.id) AS num_citas_pendientes
FROM pacientes p
LEFT JOIN citas_medicas cm ON p.id = cm.id_paciente AND cm.estado = 'PENDIENTE'
GROUP BY p.id;


-- 8. CALCULAR EL TOTAL DE INGRESOS GENERADO POR CADA MÉDICO EN UN MES ESPECÍFICO:
SELECT m.nombre, m.apellido, SUM(f.total_factura) AS ingreso_total
FROM medicos m
LEFT JOIN facturas f ON m.id = f.id_medico AND MONTH(f.fecha_emision) = 5
GROUP BY m.id;


/*PARA VISUALIZAR LAS TABLAS Y VISTAS PUEDES DESCOMENTAR Y EJECUTAR LAS SIGUIENTES LÍNEAS*/

-- SELECT * FROM pacientes;
-- SELECT * FROM pacientes_telefonos;
-- SELECT * FROM administrativos;
-- SELECT * FROM administrativos_telefonos;
-- SELECT * FROM auditores;
-- SELECT * FROM auditores_telefonos;
-- SELECT * FROM usuarios_sistema;
-- SELECT * FROM citas_medicas;
-- SELECT * FROM obras_sociales;
-- SELECT * FROM datos_obras_sociales;
-- SELECT * FROM facturas;
-- SELECT * FROM historiales_medicos;
-- SELECT * FROM ingresos_facturacion_mensual; 
-- SELECT * FROM medicos;
-- SELECT * FROM medicos_telefonos;
-- SELECT * FROM datos_obras_sociales;
-- SELECT * FROM rendimiento_medico;
-- SELECT * FROM tarifas;
-- 
-- SELECT * FROM vw_citas_pendientes;
-- SELECT * FROM vw_facturas_paciente_obra_social;
-- SELECT * FROM vw_recetas;
-- SELECT * FROM vw_historial_medico;
-- SELECT * FROM vw_facturas_pendientes;
-- SELECT * FROM vw_ingreso_mensual_obras_sociales;
-- SELECT * FROM vw_ingreso_total_obras_sociales;
-- SELECT * FROM vw_pacientes_con_cobertura;
-- SELECT * FROM vw_pacientes_sin_cobertura;
-- SELECT * FROM vw_info_pacientes;
-- SELECT * FROM vw_info_administrativos;
-- SELECT * FROM vw_info_medicos;
