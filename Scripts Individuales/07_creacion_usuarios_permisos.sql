/*
ESTE SCRIPT CREA USUARIOS DEL SISTEMA
*/

-- CAMBIA AL ESQUEMA POR DEFECTO DE MYSQL WORKBENCH PARA CREAR USERS
        USE mysql;

-- DESCOMENTAR Y EJECUTAR LA SIGUIENTE LÍNEA PARA CONSULTAR LISTA DE USUARIOS
-- SELECT * FROM user;


-- SI LOS USUARIOS 'auditor@localhost', 'administrativo@localhost', 'medico@localhost'
-- EXISTEN LOS ELIMINO PARA CREARLOS NUEVAMENTE CON LOS PERMISOS ADECUADOS
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




