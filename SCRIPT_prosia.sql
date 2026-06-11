/*
======================================================================
      RESUMEN Y ESTRUCTURA DE TABLAS - BASE DE DATOS PROSIA
======================================================================

1. TABLAS CATÁLOGOS:
   - tab_turno: Catálogo de turnos de trabajo.
   - tab_descanso: Tiempos de descanso/almuerzo dentro de un turno.
   - tab_estado_maquina: Catálogo de estados operacionales de máquinas.
   - tab_tipo_doc: Catálogo de tipos de documento de identidad.
   - tab_persona: Información básica de personas (nombre, contacto, etc.).
   - tab_tercero: Clientes, proveedores y mixtos.
   - tab_rol: Roles de usuario y jerarquía en el sistema.
   - tab_menu: Opciones del menú de navegación.
   - tab_categoria_item: Categorías de clasificación de los ítems.
   - tab_unidad_medida: Unidades de medida para el control de inventario.
   - tab_tipo_item: Clasificación de ítems (materia prima, producto final, etc.).
   - tab_item: Catálogo maestro de productos y materiales.
   - tab_usuario: Cuentas de acceso e identificación de usuarios.
   - tab_permiso_menu_rol: Permisos asignados a cada rol sobre los menús.

2. TABLAS TRANSACCIONALES (PRODUCCIÓN):
   - tab_estructura_BOM: Lista de materiales (relación padre-hijo).
   - tab_area_trabajo: Áreas físicas de manufactura y costos asociados.
   - tab_maquina: Registro de maquinaria asociada a áreas de trabajo.
   - tab_parada_maquina: Registro de tiempos de inactividad de maquinaria.
   - tab_operacion: Operaciones estándar de producción.
   - tab_ruta_operacion: Secuencia y tiempos de operaciones de cada ítem.
   - tab_estado_orden_produccion: Catálogo de estados de órdenes de producción.
   - tab_orden_produccion: Cabecera de órdenes de producción.
   - tab_detalle_orden_produccion: Ítems y cantidades planificadas en la orden.
   - tab_registro_tiempo: Registro de tiempos de operarios y cantidades producidas.
   - tab_horario_empleado: Horarios específicos y turnos vigentes de los usuarios.
   - tab_historial_estado_orden: Registro histórico de cambios de estado de órdenes.

3. TABLAS DE INVENTARIO Y BODEGAS:
   - tab_bodega: Bodegas principales de almacenamiento.
   - tab_ubicacion: Ubicaciones específicas dentro de cada bodega.
   - tab_stock_ubicacion: Cantidades de stock por ítem en cada ubicación.
   - tab_tipo_movimiento: Catálogo de tipos de movimiento de inventario.
   - tab_movimiento_inventario: Historial de transacciones de inventario.
   - tab_lote: Control de lotes de inventario por ítem.
   - tab_version_bom: Control de versiones de la lista de materiales (BOM).

4. TABLAS DE CALIDAD E INSPECCIÓN:
   - tab_estandar_calidad: Parámetros a medir en los controles de calidad.
   - tab_plan_inspeccion: Configuración de controles obligatorios por ítem/operación.
   - tab_inspeccion: Cabecera de los reportes de inspección de calidad realizados.
   - tab_detalle_inspeccion: Valores registrados para cada parámetro en una inspección.
   - tab_no_conformidad: Reportes de no conformidad por calidad o producción.

5. TABLAS DE ANALÍTICA Y AUDITORÍA:
   - tab_tipo_evento: Catálogo de tipos de eventos de producción.
   - tab_evento_produccion: Log central de eventos de producción.
   - tab_tipo_kpi: Catálogo de tipos de indicadores (KPIs).
   - tab_kpi_snapshot: Fotografías periódicas de indicadores.
   - tab_tipo_alerta: Catálogo de tipos de alertas del sistema.
   - tab_alerta: Alertas generadas por el sistema o la IA.
   - tab_auditoria_usuario: Registro de acciones de usuarios sobre el sistema.
   - tab_estado_sesion: Catálogo de estados de sesión.
   - tab_sesion_usuario: Control de sesiones activas de usuarios.
======================================================================
*/

DROP TABLE IF EXISTS tab_sesion_usuario CASCADE;
DROP TABLE IF EXISTS tab_estado_sesion CASCADE;
DROP TABLE IF EXISTS tab_auditoria_usuario CASCADE;
DROP TABLE IF EXISTS tab_alerta CASCADE;
DROP TABLE IF EXISTS tab_tipo_alerta CASCADE;
DROP TABLE IF EXISTS tab_kpi_snapshot CASCADE;
DROP TABLE IF EXISTS tab_tipo_kpi CASCADE;
DROP TABLE IF EXISTS tab_evento_produccion CASCADE;
DROP TABLE IF EXISTS tab_tipo_evento CASCADE;
DROP TABLE IF EXISTS tab_no_conformidad CASCADE;
DROP TABLE IF EXISTS tab_detalle_inspeccion CASCADE;
DROP TABLE IF EXISTS tab_inspeccion CASCADE;
DROP TABLE IF EXISTS tab_plan_inspeccion CASCADE;
DROP TABLE IF EXISTS tab_estandar_calidad CASCADE;
DROP TABLE IF EXISTS tab_registro_tiempo CASCADE;
DROP TABLE IF EXISTS tab_historial_estado_orden CASCADE;
DROP TABLE IF EXISTS tab_detalle_orden_produccion CASCADE;
DROP TABLE IF EXISTS tab_orden_produccion CASCADE;
DROP TABLE IF EXISTS tab_estado_orden_produccion CASCADE;
DROP TABLE IF EXISTS tab_ruta_operacion CASCADE;
DROP TABLE IF EXISTS tab_operacion CASCADE;
DROP TABLE IF EXISTS tab_parada_maquina CASCADE;
DROP TABLE IF EXISTS tab_maquina CASCADE;
DROP TABLE IF EXISTS tab_area_trabajo CASCADE;
DROP TABLE IF EXISTS tab_estructura_BOM CASCADE;
DROP TABLE IF EXISTS tab_lote CASCADE;
DROP TABLE IF EXISTS tab_movimiento_inventario CASCADE;
DROP TABLE IF EXISTS tab_tipo_movimiento CASCADE;
DROP TABLE IF EXISTS tab_stock_ubicacion CASCADE;
DROP TABLE IF EXISTS tab_ubicacion CASCADE;
DROP TABLE IF EXISTS tab_bodega CASCADE;
DROP TABLE IF EXISTS tab_horario_empleado CASCADE;
DROP TABLE IF EXISTS tab_permiso_menu_rol CASCADE;
DROP TABLE IF EXISTS tab_usuario CASCADE;
DROP TABLE IF EXISTS tab_version_bom CASCADE;
DROP TABLE IF EXISTS tab_item CASCADE;
DROP TABLE IF EXISTS tab_tipo_item CASCADE;
DROP TABLE IF EXISTS tab_unidad_medida CASCADE;
DROP TABLE IF EXISTS tab_categoria_item CASCADE;
DROP TABLE IF EXISTS tab_menu CASCADE;
DROP TABLE IF EXISTS tab_rol CASCADE;
DROP TABLE IF EXISTS tab_tercero CASCADE;
DROP TABLE IF EXISTS tab_persona CASCADE;
DROP TABLE IF EXISTS tab_tipo_doc CASCADE;
DROP TABLE IF EXISTS tab_descanso CASCADE;
DROP TABLE IF EXISTS tab_turno CASCADE;
DROP TABLE IF EXISTS tab_estado_maquina CASCADE;
DROP TABLE IF EXISTS tab_parametros_sistema CASCADE;
DROP FUNCTION IF EXISTS f_anio_actual CASCADE;
DROP TYPE IF EXISTS enum_estado_item CASCADE;
DROP TYPE IF EXISTS enum_permisos_menu CASCADE;
DROP TYPE IF EXISTS enum_estado_registro_tiempo CASCADE;
DROP TYPE IF EXISTS enum_tipo_tercero CASCADE;
DROP TYPE IF EXISTS enum_tipo_dato_calidad CASCADE;
DROP TYPE IF EXISTS enum_estado_inspeccion CASCADE;
DROP TYPE IF EXISTS enum_estado_no_conformidad CASCADE;
DROP TYPE IF EXISTS enum_severidad CASCADE;
DROP TYPE IF EXISTS enum_estado_alerta CASCADE;
DROP TYPE IF EXISTS enum_tipo_accion_auditoria CASCADE;




/*
========================================
       CREACION DE ENUMS
========================================
*/

CREATE TYPE enum_estado_item AS ENUM (
    'Activo', -- 1
    'Inactivo', -- 2
    'Descontinuado', -- 3
    'Mantenimiento' -- 4
);

CREATE TYPE enum_permisos_menu AS ENUM (
    'Crear',
    'Consultar',
    'Modificar',
    'Eliminar'
);

CREATE TYPE enum_estado_registro_tiempo AS ENUM(
    'Iniciado',
    'Finalizado',
    'Suspendido'
);

CREATE TYPE enum_tipo_tercero AS ENUM (
    'Cliente',
    'Proveedor',
    'Mixto'
);

CREATE TYPE enum_tipo_dato_calidad AS ENUM (
    'Numerico',
    'Texto',
    'Booleano'
);

CREATE TYPE enum_estado_inspeccion AS ENUM (---
    'Aprobado',
    'Rechazado',
    'Aprobado con Observacion',
    'Pendiente'
);

CREATE TYPE enum_estado_no_conformidad AS ENUM (
    'Abierta',
    'En Analisis',
    'Cerrada',
    'Rechazada'
);

CREATE TYPE enum_severidad AS ENUM (
    'Baja',
    'Media',
    'Alta',
    'Critica'
);

CREATE TYPE enum_estado_alerta AS ENUM (
    'Nueva',
    'Reconocida',
    'Resuelta',
    'Descartada'
);

CREATE TYPE enum_tipo_accion_auditoria AS ENUM (
    'Login',
    'Logout',
    'Crear',
    'Modificar',
    'Eliminar',
    'Consultar'
);

CREATE OR REPLACE FUNCTION f_anio_actual() RETURNS integer AS $$
SELECT EXTRACT(YEAR FROM CURRENT_DATE)::integer;
$$ LANGUAGE sql IMMUTABLE;

/*
========================================================
       CREACION DE TABLAS CATALOGOS
========================================================
*/


CREATE TABLE IF NOT EXISTS tab_turno(
    id_turno                    DECIMAL(3,0)        NOT NULL, 
    nombre                      VARCHAR(50)         UNIQUE NOT NULL,
    hora_inicio                 TIME                NOT NULL,
    hora_fin                    TIME                NOT NULL,
    estado                      BOOLEAN             DEFAULT TRUE,
    fecha_creacion              TIMESTAMP           DEFAULT NOW(),
    PRIMARY KEY (id_turno),
    CONSTRAINT chk_horas_turno CHECK (hora_inicio <> hora_fin),
    CONSTRAINT chk_horas_validas CHECK (EXTRACT(HOUR FROM hora_inicio) >= 0 AND EXTRACT(HOUR FROM hora_inicio) <= 23)
);

CREATE TABLE IF NOT EXISTS tab_descanso(
    id_descanso                 DECIMAL(5,0)        NOT NULL,
    id_turno                    DECIMAL(3,0)        NOT NULL,
    nombre                      VARCHAR(50)         NOT NULL,
    hora_inicio                 TIME                NOT NULL,
    hora_fin                    TIME                NOT NULL,
    PRIMARY KEY (id_descanso),
    FOREIGN KEY (id_turno) REFERENCES tab_turno(id_turno) ON DELETE CASCADE,
    CONSTRAINT chk_horas_descanso CHECK (hora_fin > hora_inicio),
    CONSTRAINT chk_duracion_descanso CHECK (EXTRACT(HOUR FROM hora_fin) - EXTRACT(HOUR FROM hora_inicio) BETWEEN 0 AND 3)
);

CREATE TABLE IF NOT EXISTS tab_estado_maquina(
    id_estado_maquina           DECIMAL(1,0)        NOT NULL,
    nombre                      VARCHAR(50)         UNIQUE NOT NULL,
    descripcion                 VARCHAR(200)        NOT NULL,
    PRIMARY KEY (id_estado_maquina)
);

CREATE TABLE IF NOT EXISTS tab_tipo_doc(
    id_tipo_doc                 DECIMAL(1,0)        NOT NULL,
    nombre                      VARCHAR(20)         UNIQUE NOT NULL,
    descripcion                 VARCHAR(200)        NOT NULL,
    PRIMARY KEY (id_tipo_doc)
);

CREATE TABLE IF NOT EXISTS tab_persona (
    id_persona                  DECIMAL(10,0)       NOT NULL,
    id_tipo_doc                 DECIMAL(1,0)        NOT NULL,
    nombre                      VARCHAR(50)         NOT NULL,
    apellido1                   VARCHAR(50)         NOT NULL,
    apellido2                   VARCHAR(50)         NOT NULL,
    datos_contacto              JSONB               DEFAULT '{}'::jsonb NOT NULL,
    estado                      BOOLEAN             DEFAULT TRUE,
    PRIMARY KEY (id_persona),
    FOREIGN KEY (id_tipo_doc) REFERENCES tab_tipo_doc(id_tipo_doc) ON DELETE RESTRICT,
    CONSTRAINT chk_nombre_format CHECK (nombre ~ '^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$'),
    CONSTRAINT chk_apellido1_format CHECK (apellido1 ~ '^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$'),
    CONSTRAINT chk_apellido2_format CHECK (apellido2 ~ '^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$'),
    CONSTRAINT chk_nombre_length CHECK (LENGTH(nombre) >= 2)
);

CREATE TABLE IF NOT EXISTS tab_tercero(
    id_tercero                  DECIMAL(10,0)       NOT NULL,
    razon_social                VARCHAR(100)        NOT NULL,
    nombre_comercial            VARCHAR(100)        NOT NULL,
    contacto                    JSONB               DEFAULT '{}'::jsonb NOT NULL,
    tipo                        enum_tipo_tercero   NOT NULL,
    estado                      BOOLEAN             DEFAULT TRUE,
    PRIMARY KEY (id_tercero)
);

CREATE TABLE IF NOT EXISTS tab_rol(
    id_rol                      DECIMAL(1,0)        NOT NULL,
    nombre                      VARCHAR(50)         UNIQUE NOT NULL,
    descripcion                 VARCHAR(200)        NOT NULL,
    jerarquia                   SMALLINT            NOT NULL,
    estado                      BOOLEAN             DEFAULT TRUE,
    PRIMARY KEY (id_rol),
    CONSTRAINT chk_jerarquia_valida CHECK (jerarquia > 0 AND jerarquia <= 10),
    CONSTRAINT chk_nombre_rol CHECK (LENGTH(nombre) >= 2)
);

CREATE TABLE IF NOT EXISTS tab_menu(
    id_menu                     DECIMAL(2,0)        NOT NULL,
    nombre                      VARCHAR(50)         UNIQUE NOT NULL,
    modulo                      VARCHAR(50)         NOT NULL,   
    estado                      BOOLEAN             DEFAULT TRUE,
    url                         VARCHAR(200)        NOT NULL,
    id_menu_padre               DECIMAL(2,0)        NULL,
    PRIMARY KEY (id_menu),
    FOREIGN KEY (id_menu_padre) REFERENCES tab_menu(id_menu)
);

CREATE TABLE IF NOT EXISTS tab_categoria_item (
    id_categoria_item           DECIMAL(2,0)        NOT NULL,
    nombre                      VARCHAR(50)         UNIQUE NOT NULL,
    descripcion                 VARCHAR(200)        NOT NULL,
    estado                      BOOLEAN             DEFAULT TRUE,
    PRIMARY KEY (id_categoria_item)
);

CREATE TABLE IF NOT EXISTS tab_unidad_medida(
    id_unidad_medida            DECIMAL(2,0)        NOT NULL,
    nombre                      VARCHAR(30)         UNIQUE NOT NULL,
    abreviatura                 VARCHAR(3)          UNIQUE NOT NULL,
    PRIMARY KEY (id_unidad_medida),
    CONSTRAINT chk_abreviatura_length CHECK (LENGTH(abreviatura) >= 1),
    CONSTRAINT chk_nombre_unidad CHECK (LENGTH(nombre) >= 2)
);

CREATE TABLE IF NOT EXISTS tab_tipo_item(
    id_tipo_item                DECIMAL(1,0)        NOT NULL,
    nombre                      VARCHAR(50)         UNIQUE NOT NULL,
    descripcion                 VARCHAR(200)        NOT NULL,
    PRIMARY KEY (id_tipo_item)
);

CREATE TABLE IF NOT EXISTS tab_item (
    id_item                     DECIMAL(6,0)        NOT NULL,
    codigo                      VARCHAR(10)         UNIQUE NOT NULL,
    nombre                      VARCHAR(50)         UNIQUE NOT NULL,
    descripcion                 VARCHAR(200)        NOT NULL,
    stock_actual                DECIMAL(10,2)       DEFAULT 0 NOT NULL,
    stock_minimo                DECIMAL(10,2)       DEFAULT 0 NOT NULL,
    stock_maximo                DECIMAL(10,2)       DEFAULT 0 NOT NULL,
    tiempo_reabastecimiento     INTEGER             NOT NULL,
    maneja_lote                 BOOLEAN             DEFAULT FALSE,
    especificaciones_extra      JSONB               DEFAULT '{}'::jsonb NOT NULL,
    id_categoria_item           DECIMAL(2,0)        NOT NULL,
    id_unidad_medida            DECIMAL(2,0)        NOT NULL,
    id_tipo_item                DECIMAL(1,0)        NOT NULL,
    estado                      enum_estado_item    DEFAULT 'Activo' NOT NULL,
    fecha_creacion              TIMESTAMP           DEFAULT NOW(),
    PRIMARY KEY (id_item),
    FOREIGN KEY (id_categoria_item) REFERENCES tab_categoria_item(id_categoria_item) ON DELETE RESTRICT,
    FOREIGN KEY (id_unidad_medida) REFERENCES tab_unidad_medida(id_unidad_medida) ON DELETE RESTRICT,
    FOREIGN KEY (id_tipo_item) REFERENCES tab_tipo_item(id_tipo_item) ON DELETE RESTRICT,
    CONSTRAINT chk_stock CHECK (stock_actual >= 0 AND stock_minimo >= 0 AND stock_maximo >= 0 AND tiempo_reabastecimiento >= 0 AND (stock_maximo = 0 OR stock_maximo >= stock_minimo)),
    CONSTRAINT chk_tiempo_reabastecimiento CHECK (tiempo_reabastecimiento >= 1 AND tiempo_reabastecimiento <= 365),
    CONSTRAINT chk_codigo_item CHECK (LENGTH(codigo) >= 2)
);


CREATE TABLE IF NOT EXISTS tab_usuario(
    id_usuario                  DECIMAL(5,0)        NOT NULL,
    id_persona                  DECIMAL(10,0)       NOT NULL,
    id_rol                      DECIMAL(1,0)        NOT NULL,
    nombre_usuario              VARCHAR(30)         UNIQUE NOT NULL,
    correo                      VARCHAR(100)        UNIQUE NOT NULL CHECK (correo ~* '^[A-Za-z0-9._+%-]+@[A-Za-z0-9.-]+[.][A-Za-z]+$'),
    contrasenna_hash            VARCHAR(255)        NOT NULL,
    estado                      BOOLEAN             DEFAULT TRUE,
    PRIMARY KEY (id_usuario),
    FOREIGN KEY (id_persona) REFERENCES tab_persona(id_persona) ON DELETE RESTRICT,
    FOREIGN KEY (id_rol) REFERENCES tab_rol(id_rol) ON DELETE RESTRICT,
    CONSTRAINT chk_nombre_usuario CHECK (LENGTH(nombre_usuario) >= 3)
);

CREATE TABLE IF NOT EXISTS tab_permiso_menu_rol(
    id_menu                     DECIMAL(2,0)        NOT NULL,
    id_rol                      DECIMAL(1,0)        NOT NULL,
    permiso                     enum_permisos_menu  NOT NULL,
    estado                      BOOLEAN             DEFAULT TRUE,
    PRIMARY KEY (id_menu, id_rol, permiso),
    FOREIGN KEY (id_menu) REFERENCES tab_menu(id_menu) ON DELETE RESTRICT,
    FOREIGN KEY (id_rol) REFERENCES tab_rol(id_rol) ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS tab_horario_empleado(
    id_horario                  DECIMAL(8,0)        NOT NULL,
    id_usuario                  DECIMAL(5,0)        NOT NULL,
    id_turno                    DECIMAL(3,0)        NOT NULL,
    hora_fin_real               TIME                NULL,
    fecha_inicio_vigencia       DATE                NOT NULL,
    fecha_fin_vigencia          DATE                NULL,
    PRIMARY KEY (id_horario),
    FOREIGN KEY (id_usuario) REFERENCES tab_usuario(id_usuario) ON DELETE CASCADE,
    FOREIGN KEY (id_turno) REFERENCES tab_turno(id_turno) ON DELETE RESTRICT,
    CONSTRAINT chk_vigencia_horario CHECK (fecha_fin_vigencia IS NULL OR fecha_fin_vigencia > fecha_inicio_vigencia),
    CONSTRAINT chk_vigencia_futura CHECK (fecha_inicio_vigencia <= CURRENT_DATE + INTERVAL '30 days')
);

CREATE TABLE IF NOT EXISTS tab_version_bom(
    id_version_bom              DECIMAL(5,0)        NOT NULL,
    id_item                     DECIMAL(6,0)        NOT NULL,
    numero_version              DECIMAL(3,0)        NOT NULL,
    descripcion                 VARCHAR(200)        NULL,
    fec_vigencia_inicio         DATE                NOT NULL,
    fec_vigencia_fin            DATE                NULL,
    id_user_creacion            DECIMAL(5,0)        NOT NULL,
    fecha_creacion              TIMESTAMP           DEFAULT NOW(),
    PRIMARY KEY (id_version_bom),
    FOREIGN KEY (id_item) REFERENCES tab_item(id_item) ON DELETE RESTRICT,
    FOREIGN KEY (id_user_creacion) REFERENCES tab_usuario(id_usuario) ON DELETE RESTRICT,
    CONSTRAINT uk_version_bom UNIQUE (id_item, numero_version),
    CONSTRAINT chk_version CHECK (numero_version > 0),
    CONSTRAINT chk_vigencia CHECK (fec_vigencia_fin IS NULL OR fec_vigencia_fin >= fec_vigencia_inicio)
);

/*
==================================================
       CREACION DE TABLAS TRANSACCIONALES
==================================================
*/

CREATE TABLE IF NOT EXISTS tab_estructura_BOM(
    id_estructura_BOM           DECIMAL(5,0)        NOT NULL,
    id_item_padre               DECIMAL(6,0)        NOT NULL,
    id_item_hijo                DECIMAL(6,0)        NOT NULL,
    cantidad_requerida          DECIMAL(6,2)        NOT NULL,
    fecha_creacion              TIMESTAMP           DEFAULT NOW(),
    PRIMARY KEY (id_estructura_BOM),
    FOREIGN KEY (id_item_padre) REFERENCES tab_item(id_item) ON DELETE RESTRICT,
    FOREIGN KEY (id_item_hijo) REFERENCES tab_item(id_item) ON DELETE RESTRICT,
    CONSTRAINT uk_estructura_BOM UNIQUE (id_item_padre, id_item_hijo),
    CONSTRAINT chk_cantidad CHECK (cantidad_requerida > 0),
    CONSTRAINT chk_no_autofabricable CHECK (id_item_padre != id_item_hijo)
);

CREATE TABLE IF NOT EXISTS tab_area_trabajo(
    id_area_trabajo             DECIMAL(2,0)        NOT NULL,
    codigo                      VARCHAR(10)         UNIQUE NOT NULL,
    nombre                      VARCHAR(50)         UNIQUE NOT NULL,
    descripcion                 VARCHAR(200)        NOT NULL,
    costo_hr_operario           DECIMAL(8,2)        NOT NULL,
    costo_hr_maquina            DECIMAL(8,2)        NOT NULL,
    estado                      BOOLEAN             DEFAULT TRUE,
    fecha_creacion              TIMESTAMP           DEFAULT NOW(),
    PRIMARY KEY (id_area_trabajo),
    CONSTRAINT chk_costo CHECK (costo_hr_operario >= 0 AND costo_hr_maquina >= 0),
    CONSTRAINT chk_costo_operario_maximo CHECK (costo_hr_operario <= 1000),
    CONSTRAINT chk_costo_maquina_maximo CHECK (costo_hr_maquina <= 10000),
    CONSTRAINT chk_codigo_area CHECK (LENGTH(codigo) >= 2)
);

CREATE TABLE IF NOT EXISTS tab_maquina(
    id_maquina                  DECIMAL(4,0)        NOT NULL,
    id_area_trabajo             DECIMAL(2,0)        NOT NULL,
    id_estado_maquina           DECIMAL(1,0)        NOT NULL,
    codigo                      VARCHAR(10)         UNIQUE NOT NULL,
    nombre                      VARCHAR(100)        NOT NULL,
    marca                       VARCHAR(50)         NULL,
    modelo                      VARCHAR(50)         NULL,
    anio_fabricacion            SMALLINT            NULL,
    fecha_creacion              TIMESTAMP           DEFAULT NOW(),
    PRIMARY KEY (id_maquina),
    FOREIGN KEY (id_area_trabajo) REFERENCES tab_area_trabajo(id_area_trabajo) ON DELETE RESTRICT,
    FOREIGN KEY (id_estado_maquina) REFERENCES tab_estado_maquina(id_estado_maquina) ON DELETE RESTRICT,
    CONSTRAINT chk_anio_fabricacion CHECK (
        anio_fabricacion IS NULL OR
        (anio_fabricacion >= 1900 AND anio_fabricacion <= f_anio_actual())
    )
);

CREATE TABLE IF NOT EXISTS tab_parada_maquina(
    id_parada                   DECIMAL(5,0)        NOT NULL,
    id_maquina                  DECIMAL(4,0)        NOT NULL,
    id_usuario_reporta          DECIMAL(5,0)        NOT NULL,
    descripcion                 VARCHAR(300)        NOT NULL,
    fecha_inicio                TIMESTAMP           DEFAULT NOW(),
    fecha_fin                   TIMESTAMP           NULL,
    duracion_minutos            DECIMAL(6,2)        NULL,
    PRIMARY KEY (id_parada),
    FOREIGN KEY (id_maquina) REFERENCES tab_maquina(id_maquina) ON DELETE RESTRICT,
    FOREIGN KEY (id_usuario_reporta) REFERENCES tab_usuario(id_usuario) ON DELETE RESTRICT,
    CONSTRAINT chk_logica_fecha CHECK (fecha_inicio < fecha_fin OR fecha_fin IS NULL),
    CONSTRAINT chk_descripcion_parada CHECK (LENGTH(descripcion) >= 5),
    CONSTRAINT chk_duracion_parada CHECK (duracion_minutos IS NULL OR (duracion_minutos > 0 AND duracion_minutos <= 1440))
);


CREATE TABLE IF NOT EXISTS tab_operacion(
    id_operacion                DECIMAL(5,0)        NOT NULL,
    codigo                      VARCHAR(10)         UNIQUE NOT NULL,
    nombre                      VARCHAR(50)         UNIQUE NOT NULL,
    descripcion                 VARCHAR(200)        NOT NULL,
    requiere_inspeccion         BOOLEAN             DEFAULT FALSE,
    tiempo_estandar             DECIMAL(10,2)       NOT NULL,
    fecha_creacion              TIMESTAMP           DEFAULT NOW(),
    PRIMARY KEY (id_operacion),
    CONSTRAINT chk_tiempo CHECK (tiempo_estandar > 0),
    CONSTRAINT chk_tiempo_maximo CHECK (tiempo_estandar <= 1000),
    CONSTRAINT chk_codigo_operacion CHECK (LENGTH(codigo) >= 2)
);

CREATE TABLE IF NOT EXISTS tab_ruta_operacion(
    id_ruta_operacion           DECIMAL(5,0)        NOT NULL,
    id_operacion                DECIMAL(5,0)        NOT NULL,
    id_item                     DECIMAL(6,0)        NOT NULL,
    id_area_trabajo             DECIMAL(2,0)        NOT NULL,
    secuencia                   DECIMAL(2,0)        NOT NULL,
    tiempo_preparacion_min      DECIMAL(4,2)        DEFAULT 0,
    tiempo_fabricacion_min      DECIMAL(6,2)        DEFAULT 0,
    fecha_creacion              TIMESTAMP           DEFAULT NOW(),
    PRIMARY KEY (id_ruta_operacion),
    FOREIGN KEY (id_operacion) REFERENCES tab_operacion(id_operacion) ON DELETE RESTRICT,
    FOREIGN KEY (id_item) REFERENCES tab_item(id_item) ON DELETE RESTRICT,
    FOREIGN KEY (id_area_trabajo) REFERENCES tab_area_trabajo(id_area_trabajo) ON DELETE RESTRICT,
    CONSTRAINT uk_ruta_operacion UNIQUE (id_item, secuencia),
    CONSTRAINT chk_secuencia CHECK (secuencia > 0),
    CONSTRAINT chk_tiempos_ruta CHECK (tiempo_preparacion_min >= 0 AND tiempo_fabricacion_min >= 0),
    CONSTRAINT chk_tiempos_maximos_ruta CHECK (tiempo_preparacion_min <= 500 AND tiempo_fabricacion_min <= 500)
);

CREATE TABLE IF NOT EXISTS tab_estado_orden_produccion(
    id_estado_orden_produccion  DECIMAL(1,0)        NOT NULL,
    nombre                      VARCHAR(50)         UNIQUE NOT NULL,
    descripcion                 VARCHAR(200)        NOT NULL,
    PRIMARY KEY (id_estado_orden_produccion)
);

CREATE TABLE IF NOT EXISTS tab_parametro_sistema(
    id_empresa          DECIMAL(10,0)   NOT NULL    CHECK(id_empresa > 0),
    nom_empresa         VARCHAR(100)    NOT NULL    CHECK(LENGTH(TRIM(nom_empresa)) >= 3),
    dir_empresa         VARCHAR(100)    NOT NULL    CHECK(LENGTH(TRIM(dir_empresa)) >= 5),
    tel_empresa         DECIMAL(10,0)   NOT NULL    CHECK(tel_empresa BETWEEN 3000000000 AND 6099999999),
    email_empresa       VARCHAR(100)    NOT NULL    CHECK(email_empresa ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'),
    prefijo_orden       VARCHAR(5)      NOT NULL    DEFAULT 'OP-' CHECK(LENGTH(TRIM(prefijo_orden)) > 0),
    id_lock             SMALLINT        NOT NULL    DEFAULT 1  CHECK(id_lock = 1)  UNIQUE,
    PRIMARY KEY(id_empresa)
);

CREATE TABLE IF NOT EXISTS tab_orden_produccion(
    id_orden_produccion         INT                 NOT NULL,
    codigo                      VARCHAR(20)         UNIQUE NOT NULL,
    descripcion                 VARCHAR(200)        NOT NULL,
    fecha_inicio_planificada    DATE                NOT NULL,
    fecha_fin_planificada       DATE                NOT NULL,
    id_usuario                  DECIMAL(5,0)        NOT NULL,
    id_tercero                  DECIMAL(10,0)       NULL,
    id_estado_orden_produccion  DECIMAL(1,0)        NOT NULL DEFAULT 1,
    fecha_creacion              TIMESTAMP           DEFAULT NOW(),
    PRIMARY KEY (id_orden_produccion),
    FOREIGN KEY (id_usuario) REFERENCES tab_usuario(id_usuario) ON DELETE RESTRICT,
    FOREIGN KEY (id_tercero) REFERENCES tab_tercero(id_tercero) ON DELETE RESTRICT,
    FOREIGN KEY (id_estado_orden_produccion) REFERENCES tab_estado_orden_produccion(id_estado_orden_produccion) ON DELETE RESTRICT,
    CONSTRAINT chk_fechas_planificadas CHECK (fecha_fin_planificada >= fecha_inicio_planificada),
    CONSTRAINT chk_fecha_inicio_futura CHECK (fecha_inicio_planificada >= CURRENT_DATE)
);

CREATE TABLE IF NOT EXISTS tab_detalle_orden_produccion(
    id_detalle_orden_produccion SERIAL              NOT NULL,
    id_orden_produccion         INT                 NOT NULL,
    id_item                     DECIMAL(6,0)        NOT NULL,
    cantidad_planificada        DECIMAL(10,2)       NOT NULL,
    cantidad_producida          DECIMAL(10,2)       DEFAULT 0,
    lote                        VARCHAR(10)         NULL,
    fecha_creacion              TIMESTAMP           DEFAULT NOW(),
    PRIMARY KEY (id_detalle_orden_produccion),
    FOREIGN KEY (id_orden_produccion) REFERENCES tab_orden_produccion(id_orden_produccion) ON DELETE CASCADE,
    FOREIGN KEY (id_item) REFERENCES tab_item(id_item) ON DELETE RESTRICT,
    CONSTRAINT uk_detalle_orden_produccion UNIQUE (id_orden_produccion, id_item),
    CONSTRAINT chk_cantidad CHECK (cantidad_planificada > 0 AND cantidad_producida >= 0),
    CONSTRAINT chk_cantidad_producida_limite CHECK (cantidad_producida <= cantidad_planificada)
);

CREATE TABLE IF NOT EXISTS tab_registro_tiempo(
    id_registro_tiempo          SERIAL              NOT NULL,
    id_detalle_orden_produccion INT                 NOT NULL,
    id_ruta_operacion           DECIMAL(5,0)        NOT NULL,
    id_usuario                  DECIMAL(5,0)        NOT NULL,
    cantidad_buena              DECIMAL(6,0)        DEFAULT 0,
    cantidad_mala               DECIMAL(6,0)        DEFAULT 0,
    fecha_inicio                TIMESTAMP           DEFAULT NOW(),
    fecha_fin                   TIMESTAMP           DEFAULT NULL,
    tiempo_real                 DECIMAL(6,2)        DEFAULT 0,
    estado                      enum_estado_registro_tiempo NOT NULL,
    tipo_registro               VARCHAR(20)         NOT NULL DEFAULT 'Produccion',
    fecha_creacion              TIMESTAMP           DEFAULT NOW(),
    PRIMARY KEY (id_registro_tiempo),
    FOREIGN KEY (id_detalle_orden_produccion) REFERENCES tab_detalle_orden_produccion(id_detalle_orden_produccion) ON DELETE RESTRICT,
    FOREIGN KEY (id_ruta_operacion) REFERENCES tab_ruta_operacion(id_ruta_operacion) ON DELETE RESTRICT,
    FOREIGN KEY (id_usuario) REFERENCES tab_usuario(id_usuario) ON DELETE RESTRICT,
    CONSTRAINT chk_logica_fecha CHECK (fecha_inicio < fecha_fin OR fecha_fin IS NULL),
    CONSTRAINT chk_cantidad CHECK (cantidad_buena >= 0 AND cantidad_mala >= 0),
    CONSTRAINT chk_tiempo CHECK (tiempo_real >= 0),
    CONSTRAINT chk_cantidad_total_registro CHECK (cantidad_buena + cantidad_mala <= 99999),
    CONSTRAINT chk_tiempo_registro CHECK (tiempo_real <= 1440)
);

CREATE TABLE IF NOT EXISTS tab_historial_estado_orden(
    id_historial                DECIMAL(10,0)       NOT NULL,
    id_orden_produccion         INT                 NOT NULL,
    id_estado_anterior          DECIMAL(1,0)        NULL,
    id_estado_nuevo             DECIMAL(1,0)        NOT NULL,
    id_usuario                  DECIMAL(5,0)        NOT NULL,
    motivo                      VARCHAR(300)        NULL,
    fecha_cambio                TIMESTAMP           DEFAULT NOW(),
    PRIMARY KEY (id_historial),
    FOREIGN KEY (id_orden_produccion) REFERENCES tab_orden_produccion(id_orden_produccion) ON DELETE CASCADE,
    FOREIGN KEY (id_estado_anterior) REFERENCES tab_estado_orden_produccion(id_estado_orden_produccion) ON DELETE RESTRICT,
    FOREIGN KEY (id_estado_nuevo) REFERENCES tab_estado_orden_produccion(id_estado_orden_produccion) ON DELETE RESTRICT,
    FOREIGN KEY (id_usuario) REFERENCES tab_usuario(id_usuario) ON DELETE RESTRICT,
    CONSTRAINT chk_estados_historial CHECK (id_estado_anterior IS NULL OR id_estado_anterior <> id_estado_nuevo)
);

/*
==================================================
       CREACION DE TABLAS DE INVENTARIO Y BODEGAS
==================================================
*/

CREATE TABLE IF NOT EXISTS tab_bodega(
    id_bodega                   SMALLINT            NOT NULL,
    codigo                      VARCHAR(10)         UNIQUE NOT NULL,
    nombre                      VARCHAR(50)         UNIQUE NOT NULL,
    descripcion                 VARCHAR(200)        NOT NULL,
    direccion                   VARCHAR(200)        NOT NULL,
    estado                      BOOLEAN             DEFAULT TRUE,
    fecha_creacion              TIMESTAMP           DEFAULT NOW(),
    PRIMARY KEY (id_bodega)
);

CREATE TABLE IF NOT EXISTS tab_ubicacion(
    id_ubicacion                SMALLINT            NOT NULL,
    id_bodega                   SMALLINT            NOT NULL,
    codigo                      VARCHAR(20)         NOT NULL,
    descripcion                 VARCHAR(200)        NOT NULL,
    fecha_creacion              TIMESTAMP           DEFAULT NOW(),
    PRIMARY KEY (id_ubicacion),
    FOREIGN KEY (id_bodega) REFERENCES tab_bodega(id_bodega) ON DELETE RESTRICT,
    CONSTRAINT uk_ubicacion_bodega UNIQUE (id_bodega, codigo)
);

CREATE TABLE IF NOT EXISTS tab_stock_ubicacion(
    id_item                     DECIMAL(6,0)        NOT NULL,
    id_ubicacion                SMALLINT            NOT NULL,
    cantidad                    DECIMAL(10,2)       DEFAULT 0 NOT NULL,
    fecha_creacion              TIMESTAMP           DEFAULT NOW(),
    PRIMARY KEY (id_item, id_ubicacion),
    FOREIGN KEY (id_item) REFERENCES tab_item(id_item) ON DELETE RESTRICT,
    FOREIGN KEY (id_ubicacion) REFERENCES tab_ubicacion(id_ubicacion) ON DELETE RESTRICT,
    CONSTRAINT chk_cantidad_stock CHECK (cantidad >= 0)
);

CREATE TABLE IF NOT EXISTS tab_tipo_movimiento(
    id_tipo_movimiento          DECIMAL(1,0)        NOT NULL,
    nombre                      VARCHAR(20)         UNIQUE NOT NULL,
    descripcion                 VARCHAR(200)        NOT NULL,
    PRIMARY KEY (id_tipo_movimiento)
);

CREATE TABLE IF NOT EXISTS tab_movimiento_inventario(
    id_movimiento               INT                 NOT NULL,
    id_item                     DECIMAL(6,0)        NOT NULL,
    cantidad                    DECIMAL(10,2)       NOT NULL,
    tipo_movimiento             DECIMAL(1,0)        NOT NULL,
    id_ubicacion_origen         SMALLINT            NULL,
    id_ubicacion_destino        SMALLINT            NULL,
    motivo                      VARCHAR(200)        NULL,
    id_usuario                  DECIMAL(5,0)        NOT NULL,
    fecha_movimiento            TIMESTAMP           DEFAULT NOW(),
    PRIMARY KEY (id_movimiento),
    FOREIGN KEY (id_item) REFERENCES tab_item(id_item) ON DELETE RESTRICT,
    FOREIGN KEY (id_ubicacion_origen) REFERENCES tab_ubicacion(id_ubicacion) ON DELETE RESTRICT,
    FOREIGN KEY (id_ubicacion_destino) REFERENCES tab_ubicacion(id_ubicacion) ON DELETE RESTRICT,
    FOREIGN KEY (id_usuario) REFERENCES tab_usuario(id_usuario) ON DELETE RESTRICT,
    FOREIGN KEY (tipo_movimiento) REFERENCES tab_tipo_movimiento(id_tipo_movimiento) ON DELETE RESTRICT,
    CONSTRAINT chk_cantidad_movimiento CHECK (cantidad > 0),
    CONSTRAINT chk_origen_destino_movimiento CHECK ((id_ubicacion_origen IS NOT NULL) OR (id_ubicacion_destino IS NOT NULL))
);

CREATE TABLE IF NOT EXISTS tab_lote(
    id_lote                     DECIMAL(10,0)       NOT NULL,
    codigo_lote                 VARCHAR(20)         UNIQUE NOT NULL,
    id_item                     DECIMAL(6,0)        NOT NULL,
    id_tipo_item                DECIMAL(1,0)        NOT NULL,
    cantidad_inicial            DECIMAL(10,2)       NOT NULL,
    cantidad_disponible         DECIMAL(10,2)       NOT NULL,
    fecha_vencimiento           DATE                NULL,
    id_tercero                  DECIMAL(10,0)       NULL,
    id_movimiento_origen        INT                 NULL,
    fecha_creacion              TIMESTAMP           DEFAULT NOW(),
    PRIMARY KEY (id_lote),
    FOREIGN KEY (id_item) REFERENCES tab_item(id_item) ON DELETE RESTRICT,
    FOREIGN KEY (id_tipo_item) REFERENCES tab_tipo_item(id_tipo_item) ON DELETE RESTRICT,
    FOREIGN KEY (id_tercero) REFERENCES tab_tercero(id_tercero) ON DELETE RESTRICT,
    FOREIGN KEY (id_movimiento_origen) REFERENCES tab_movimiento_inventario(id_movimiento) ON DELETE SET NULL,
    CONSTRAINT chk_cantidad_lote CHECK (
        cantidad_inicial > 0 AND
        cantidad_disponible >= 0 AND
        cantidad_disponible <= cantidad_inicial
    ),
    CONSTRAINT chk_fecha_vencimiento_lote CHECK (fecha_vencimiento IS NULL OR fecha_vencimiento >= CURRENT_DATE)
);

/*
==================================================
       CREACION DE TABLAS DE CALIDAD E INSPECCION
==================================================
*/

CREATE TABLE IF NOT EXISTS tab_estandar_calidad(
    id_parametro                DECIMAL(5,0)        NOT NULL,
    codigo                      VARCHAR(20)         UNIQUE NOT NULL,
    nombre                      VARCHAR(100)        UNIQUE NOT NULL,
    descripcion                 VARCHAR(200)        NULL,
    tipo_dato                   enum_tipo_dato_calidad NOT NULL,
    id_unidad_medida            DECIMAL(2,0)        NULL,
    estado                      BOOLEAN             DEFAULT TRUE,
    PRIMARY KEY (id_parametro),
    FOREIGN KEY (id_unidad_medida) REFERENCES tab_unidad_medida(id_unidad_medida) ON DELETE RESTRICT,
    CONSTRAINT chk_codigo_parametro CHECK (LENGTH(codigo) >= 2),
    CONSTRAINT chk_nombre_parametro CHECK (LENGTH(nombre) >= 2)
);

CREATE TABLE IF NOT EXISTS tab_plan_inspeccion(
    id_plan_inspeccion          SERIAL              NOT NULL,
    id_item                     DECIMAL(6,0)        NOT NULL,
    id_operacion                DECIMAL(5,0)        NULL,
    id_parametro                DECIMAL(5,0)        NOT NULL,
    valor_esperado_texto        VARCHAR(200)        NULL,
    rango_minimo                DECIMAL(10,4)       NULL,
    rango_maximo                DECIMAL(10,4)       NULL,
    obligatorio                 BOOLEAN             DEFAULT TRUE,
    PRIMARY KEY (id_plan_inspeccion),
    FOREIGN KEY (id_item) REFERENCES tab_item(id_item) ON DELETE RESTRICT,
    FOREIGN KEY (id_operacion) REFERENCES tab_operacion(id_operacion) ON DELETE RESTRICT,
    FOREIGN KEY (id_parametro) REFERENCES tab_estandar_calidad(id_parametro) ON DELETE RESTRICT,
    CONSTRAINT chk_rango_logico CHECK (rango_maximo IS NULL OR rango_minimo IS NULL OR rango_maximo >= rango_minimo)
);

CREATE TABLE IF NOT EXISTS tab_inspeccion(
    id_inspeccion               SERIAL              NOT NULL,
    codigo_inspeccion           VARCHAR(30)         UNIQUE NOT NULL,
    id_usuario                  DECIMAL(5,0)        NOT NULL,
    id_detalle_orden_produccion INT                 NULL,
    id_movimiento_inventario    INT                 NULL,
    lote_inspeccionado          VARCHAR(50)         NULL,
    estado_general              enum_estado_inspeccion NOT NULL,
    observaciones               VARCHAR(500)        NULL,
    fecha_inspeccion            TIMESTAMP           DEFAULT NOW(),
    PRIMARY KEY (id_inspeccion),
    FOREIGN KEY (id_usuario) REFERENCES tab_usuario(id_usuario) ON DELETE RESTRICT,
    FOREIGN KEY (id_detalle_orden_produccion) REFERENCES tab_detalle_orden_produccion(id_detalle_orden_produccion) ON DELETE RESTRICT,
    FOREIGN KEY (id_movimiento_inventario) REFERENCES tab_movimiento_inventario(id_movimiento) ON DELETE RESTRICT,
    CONSTRAINT chk_origen_inspeccion CHECK (
        (id_detalle_orden_produccion IS NOT NULL AND id_movimiento_inventario IS NULL) OR
        (id_detalle_orden_produccion IS NULL AND id_movimiento_inventario IS NOT NULL) OR
        (id_detalle_orden_produccion IS NULL AND id_movimiento_inventario IS NULL)
    )
);

CREATE TABLE IF NOT EXISTS tab_detalle_inspeccion(
    id_detalle_inspeccion       SERIAL              NOT NULL,
    id_inspeccion               INT                 NOT NULL,
    id_parametro                DECIMAL(5,0)        NOT NULL,
    valor_registrado_texto      VARCHAR(200)        NULL,
    valor_registrado_numerico   DECIMAL(10,4)       NULL,
    cumple                      BOOLEAN             NOT NULL,
    PRIMARY KEY (id_detalle_inspeccion),
    FOREIGN KEY (id_inspeccion) REFERENCES tab_inspeccion(id_inspeccion) ON DELETE CASCADE,
    FOREIGN KEY (id_parametro) REFERENCES tab_estandar_calidad(id_parametro) ON DELETE RESTRICT,
    CONSTRAINT uk_detalle_inspeccion UNIQUE (id_inspeccion, id_parametro),
    CONSTRAINT chk_valor_registrado CHECK ((valor_registrado_texto IS NOT NULL) OR (valor_registrado_numerico IS NOT NULL))
);

CREATE TABLE IF NOT EXISTS tab_no_conformidad(
    id_no_conformidad           DECIMAL(10,0)       NOT NULL,
    codigo                      VARCHAR(30)         UNIQUE NOT NULL,
    id_inspeccion               INT                 NULL,
    id_orden_produccion         INT                 NULL,
    id_usuario_reporta          DECIMAL(5,0)        NOT NULL,
    id_usuario_asignado         DECIMAL(5,0)        NULL,
    titulo                      VARCHAR(100)        NOT NULL,
    descripcion                 VARCHAR(500)        NOT NULL,
    estado_nc                   enum_estado_no_conformidad NOT NULL,
    severidad                   enum_severidad      NOT NULL,
    accion_correctiva           VARCHAR(500)        NULL,
    fecha_cierre                DATE                NULL,
    fecha_creacion              TIMESTAMP           DEFAULT NOW(),
    PRIMARY KEY (id_no_conformidad),
    FOREIGN KEY (id_inspeccion) REFERENCES tab_inspeccion(id_inspeccion) ON DELETE SET NULL,
    FOREIGN KEY (id_orden_produccion) REFERENCES tab_orden_produccion(id_orden_produccion) ON DELETE SET NULL,
    FOREIGN KEY (id_usuario_reporta) REFERENCES tab_usuario(id_usuario) ON DELETE RESTRICT,
    FOREIGN KEY (id_usuario_asignado) REFERENCES tab_usuario(id_usuario) ON DELETE SET NULL,
    CONSTRAINT chk_usuarios_nc CHECK (id_usuario_asignado IS NULL OR id_usuario_asignado <> id_usuario_reporta),
    CONSTRAINT chk_titulo_nc CHECK (LENGTH(titulo) >= 3),
    CONSTRAINT chk_descripcion_nc CHECK (LENGTH(descripcion) >= 5),
    CONSTRAINT chk_fecha_cierre_nc CHECK (fecha_cierre IS NULL OR fecha_cierre >= CURRENT_DATE)
);

/*
==================================================
       CREACION DE TABLAS DE ANALITICA Y AUDITORIA
==================================================
*/

CREATE TABLE IF NOT EXISTS tab_tipo_evento(
    id_tipo_evento              DECIMAL(2,0)        NOT NULL,
    nombre                      VARCHAR(50)         UNIQUE NOT NULL,
    descripcion                 VARCHAR(200)        NOT NULL,
    PRIMARY KEY (id_tipo_evento)
);

CREATE TABLE IF NOT EXISTS tab_evento_produccion(
    id_evento                   DECIMAL(10,0)       NOT NULL,
    id_tipo_evento              DECIMAL(2,0)        NOT NULL,
    id_entidad_referencia       INT                 NULL,
    nombre_entidad              VARCHAR(50)         NULL,           --A que tabla pertenece el registro
    id_usuario                  DECIMAL(5,0)        NULL,
    descripcion                 VARCHAR(500)        NULL,
    payload                     JSONB               NULL,           -- Información adicional relevante al evento
    fecha_evento                TIMESTAMP           DEFAULT NOW(),
    PRIMARY KEY (id_evento),
    FOREIGN KEY (id_tipo_evento) REFERENCES tab_tipo_evento(id_tipo_evento) ON DELETE RESTRICT,
    FOREIGN KEY (id_usuario) REFERENCES tab_usuario(id_usuario) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS tab_tipo_kpi(
    id_tipo_kpi                 DECIMAL(2,0)        NOT NULL,
    nombre                      VARCHAR(50)         UNIQUE NOT NULL,
    descripcion                 VARCHAR(200)        NOT NULL,
    PRIMARY KEY (id_tipo_kpi)
);

CREATE TABLE IF NOT EXISTS tab_kpi_snapshot(
    id_snapshot                 DECIMAL(10,0)       NOT NULL,
    id_tipo_kpi                 DECIMAL(2,0)        NOT NULL,
    id_area_trabajo             DECIMAL(2,0)        NULL,
    id_turno                    DECIMAL(3,0)        NULL,
    valor                       DECIMAL(10,4)       NOT NULL,
    periodo_referencia          TIMESTAMP           NOT NULL,
    fecha_creacion              TIMESTAMP           DEFAULT NOW(),
    PRIMARY KEY (id_snapshot),
    FOREIGN KEY (id_tipo_kpi) REFERENCES tab_tipo_kpi(id_tipo_kpi) ON DELETE RESTRICT,
    FOREIGN KEY (id_area_trabajo) REFERENCES tab_area_trabajo(id_area_trabajo) ON DELETE SET NULL,
    FOREIGN KEY (id_turno) REFERENCES tab_turno(id_turno) ON DELETE SET NULL,
    CONSTRAINT chk_valor_kpi CHECK (valor >= 0),
    CONSTRAINT uk_kpi_snapshot UNIQUE (id_tipo_kpi, id_area_trabajo, id_turno, periodo_referencia)
);

CREATE TABLE IF NOT EXISTS tab_tipo_alerta(
    id_tipo_alerta              DECIMAL(2,0)        NOT NULL,
    nombre                      VARCHAR(50)         UNIQUE NOT NULL,
    descripcion                 VARCHAR(200)        NOT NULL,
    PRIMARY KEY (id_tipo_alerta)
);

CREATE TABLE IF NOT EXISTS tab_alerta(
    id_alerta                   DECIMAL(10,0)       NOT NULL,
    id_tipo_alerta              DECIMAL(2,0)        NOT NULL,
    estado_alerta               enum_estado_alerta  NOT NULL,
    severidad                   enum_severidad      NOT NULL,
    titulo                      VARCHAR(100)        NOT NULL,
    descripcion                 VARCHAR(500)        NOT NULL,
    id_entidad_referencia       INT                 NULL,
    nombre_entidad              VARCHAR(50)         NULL,
    id_usuario_reconoce         DECIMAL(5,0)        NULL,
    fecha_reconocimiento        TIMESTAMP           NULL,
    id_usuario_resuelve         DECIMAL(5,0)        NULL,
    fecha_resolucion            TIMESTAMP           NULL,
    fecha_creacion              TIMESTAMP           DEFAULT NOW(),
    PRIMARY KEY (id_alerta),
    FOREIGN KEY (id_tipo_alerta) REFERENCES tab_tipo_alerta(id_tipo_alerta) ON DELETE RESTRICT,
    FOREIGN KEY (id_usuario_reconoce) REFERENCES tab_usuario(id_usuario) ON DELETE SET NULL,
    FOREIGN KEY (id_usuario_resuelve) REFERENCES tab_usuario(id_usuario) ON DELETE SET NULL,
    CONSTRAINT chk_titulo_alerta CHECK (LENGTH(titulo) >= 3),
    CONSTRAINT chk_descripcion_alerta CHECK (LENGTH(descripcion) >= 5),
    CONSTRAINT chk_fecha_reconocimiento_alerta CHECK (fecha_reconocimiento IS NULL OR fecha_reconocimiento >= fecha_creacion),
    CONSTRAINT chk_fecha_resolucion_alerta CHECK (fecha_resolucion IS NULL OR fecha_resolucion >= fecha_creacion)
);

CREATE TABLE IF NOT EXISTS tab_auditoria_usuario(
    id_auditoria                DECIMAL(10,0)       NOT NULL,
    id_usuario                  DECIMAL(5,0)        NULL,
    tipo_accion                 enum_tipo_accion_auditoria NOT NULL,
    nombre_tabla                VARCHAR(50)         NULL,
    id_registro                 INT                 NULL,
    datos_anteriores            JSONB               NULL,
    datos_nuevos                JSONB               NULL,
    ip_origen                   VARCHAR(45)         NULL,
    user_agent                  VARCHAR(300)        NULL,
    fecha_accion                TIMESTAMP           DEFAULT NOW(),
    PRIMARY KEY (id_auditoria),
    FOREIGN KEY (id_usuario) REFERENCES tab_usuario(id_usuario) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS tab_estado_sesion(
    id_estado_sesion            DECIMAL(2,0)        NOT NULL,
    nombre                      VARCHAR(50)         UNIQUE NOT NULL,
    descripcion                 VARCHAR(200)        NOT NULL,
    PRIMARY KEY (id_estado_sesion)
);

CREATE TABLE IF NOT EXISTS tab_sesion_usuario(
    id_sesion                   DECIMAL(10,0)       NOT NULL,
    id_usuario                  DECIMAL(5,0)        NOT NULL,
    token_hash                  VARCHAR(255)        UNIQUE NOT NULL,
    id_estado_sesion            DECIMAL(2,0)        NOT NULL,
    ip_origen                   VARCHAR(45)         NULL,
    user_agent                  VARCHAR(300)        NULL,
    fecha_inicio                TIMESTAMP           DEFAULT NOW(),
    fecha_ultimo_acceso         TIMESTAMP           DEFAULT NOW(),
    fecha_expiracion            TIMESTAMP           NOT NULL,
    fecha_creacion              TIMESTAMP           DEFAULT NOW(),
    PRIMARY KEY (id_sesion),
    FOREIGN KEY (id_usuario) REFERENCES tab_usuario(id_usuario) ON DELETE CASCADE,
    FOREIGN KEY (id_estado_sesion) REFERENCES tab_estado_sesion(id_estado_sesion) ON DELETE RESTRICT,
    CONSTRAINT chk_fechas_sesion CHECK (
        fecha_ultimo_acceso >= fecha_inicio AND
        fecha_expiracion > fecha_inicio
    ),
    CONSTRAINT chk_fecha_expiracion_futura CHECK (fecha_expiracion >= CURRENT_TIMESTAMP),
    CONSTRAINT chk_ip_origen_valida CHECK (LENGTH(ip_origen) >= 7)
);