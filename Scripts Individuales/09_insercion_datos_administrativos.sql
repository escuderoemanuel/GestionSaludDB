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
  
  
  