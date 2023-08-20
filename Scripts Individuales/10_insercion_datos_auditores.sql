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
