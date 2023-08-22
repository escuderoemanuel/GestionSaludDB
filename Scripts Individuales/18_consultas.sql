/*
SCRIPT DE CONSULTAS
*/

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