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
-- DESCOMENTAR Y EJECUTAR LA SIGUIENTE LÍNEA PARA OBTENER RESULTADOS DE LA FUNCION 'fn_cantidad_citas_pendientes_por_medico' (DEBE PASAR ENTRE PARÉNTESIS EL ID DEL MÉDICO)
-- SELECT fn_cantidad_citas_pendientes_por_medico(30);
