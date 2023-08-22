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



