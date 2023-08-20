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