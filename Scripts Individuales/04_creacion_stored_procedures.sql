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


