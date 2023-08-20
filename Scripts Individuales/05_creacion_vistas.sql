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

