
DROP TABLE IF EXISTS hist_facturacion_mensual;
DROP TABLE IF EXISTS hist_facturacion_diaria;
DROP TABLE IF EXISTS reg_audit;
DROP TABLE IF EXISTS tab_requisicion;
DROP TABLE IF EXISTS tab_det_fac;
DROP TABLE IF EXISTS tab_enc_fac;
DROP TABLE IF EXISTS tab_prod_costeado;
DROP TABLE IF EXISTS tab_prod;
DROP TABLE IF EXISTS tab_clientes;
DROP TABLE IF EXISTS tab_ciudades;
DROP TABLE IF EXISTS tab_pmtros;

CREATE TABLE tab_pmtros
(
    id_empresa          DECIMAL(10,0)   NOT NULL,
    nom_empresa         VARCHAR         NOT NULL    CHECK(LENGTH(nom_empresa) BETWEEN 10 AND 20),
    dir_empresa         VARCHAR         NOT NULL,
    tel_empresa         DECIMAL(10,0)   NOT NULL,
    num_ini_fac         DECIMAL(5,0)    NOT NULL,
    num_fin_fac         DECIMAL(5,0)    NOT NULL,
    num_actual_fac      DECIMAL(5,0)    NOT NULL,
    val_puntos_peso     SMALLINT        NOT NULL    DEFAULT 10,
    val_porc_iva        DECIMAL(2,0)    NOT NULL    DEFAULT 19,
    val_porc_desc_fidel DECIMAL(2,0)    NOT NULL    DEFAULT 5,
    val_puntos_fidel    INTEGER         NOT NULL    DEFAULT 500,
    num_dia_desc_gral   DECIMAL(1,0)    NOT NULL    DEFAULT 4,
    val_porc_desc_gral  DECIMAL(2,0)    NOT NULL    DEFAULT 0,
    PRIMARY KEY(id_empresa)
);

CREATE TABLE tab_ciudades
(
    id_ciudad           VARCHAR(5)      NOT NULL,
    nom_ciudad          VARCHAR         NOT NULL,
    usr_insert          VARCHAR         NOT NULL,
    fec_insert          TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    usr_update          VARCHAR,
    fec_update          TIMESTAMP WITHOUT TIME ZONE,
    PRIMARY KEY(id_ciudad)
);

CREATE TABLE reg_audit
(
    id_reg              DECIMAL(10,0)               NOT NULL,
    nom_tabla           VARCHAR(20)                 NOT NULL,
    transaccion         VARCHAR                     NOT NULL,
	registro			TEXT						NOT NULL,
    user_delete         VARCHAR,
    fec_delete          TIMESTAMP WITHOUT TIME ZONE ,
	PRIMARY KEY(id_reg)
);

CREATE TABLE tab_clientes
(
    id_cliente          DECIMAL(10,0)   NOT NULL,
    nom_cliente         VARCHAR(150)    NOT NULL,
    ind_fac_electro     BOOLEAN         NOT NULL,
    val_correo          VARCHAR(100)    NOT NULL CHECK (val_correo ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'),
    tel_cliente         DECIMAL(10,0)   NOT NULL,
    dir_cliente         VARCHAR(255)    NOT NULL,
    id_ciudad           VARCHAR(5)      NOT NULL,
    val_puntos          INTEGER         NOT NULL DEFAULT 0,
    val_ptos_redimidos  INTEGER         NOT NULL DEFAULT 0,
    ind_estado          BOOLEAN         NOT NULL DEFAULT TRUE,
    usr_insert          VARCHAR         NOT NULL,
    fec_insert          TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    usr_update          VARCHAR,
    fec_update          TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    PRIMARY KEY(id_cliente),
    FOREIGN KEY(id_ciudad) REFERENCES tab_ciudades(id_ciudad)
);

CREATE TABLE tab_prod
(
    id_prod             SMALLINT        NOT NULL,
    nom_prod            VARCHAR         NOT NULL,
    val_unidad          DECIMAL(8,0)    NOT NULL,
    ind_iva             BOOLEAN         NOT NULL DEFAULT TRUE,
    ind_aplica_promo2x1 BOOLEAN         NOT NULL DEFAULT FALSE,
    val_existencia      SMALLINT        NOT NULL,
    PRIMARY KEY(id_prod)
);

CREATE TABLE tab_prod_costeado(
	id_prod				SMALLINT		NOT NULL,
	val_utilidad		INTEGER			NOT NULL,
	val_unitario		DECIMAL(10,0)	NOT NULL,
	val_costo			DECIMAL(10,0)	NOT NULL,
	PRIMARY KEY (id_prod),
	FOREIGN KEY ( id_prod) REFERENCES tab_prod(id_prod)
);

CREATE TABLE tab_enc_fac
(
    id_factura          DECIMAL(5,0)    NOT NULL,
    fec_factura         DATE            NOT NULL,
    id_ciudad           VARCHAR(5)      NOT NULL,
    id_cliente          DECIMAL(10,0)   NOT NULL,
	val_total			INTEGER			NOT NULL,
    PRIMARY KEY(id_factura),
    FOREIGN KEY(id_ciudad)  REFERENCES tab_ciudades(id_ciudad),
    FOREIGN KEY(id_cliente) REFERENCES tab_clientes(id_cliente)
);

CREATE TABLE tab_det_fac
(
    id_factura          DECIMAL(5,0)    NOT NULL,
    id_prod             SMALLINT        NOT NULL,
    val_cant            SMALLINT        NOT NULL,
    val_desc            DECIMAL(8,0)    NOT NULL,
    val_iva             DECIMAL(8,0)    NOT NULL,
    val_bruto           DECIMAL(8,0)    NOT NULL,
    val_neto            DECIMAL(8,0)    NOT NULL,
    PRIMARY KEY(id_factura,id_prod),
    FOREIGN KEY(id_factura) REFERENCES tab_enc_fac(id_factura),
    FOREIGN KEY(id_prod)    REFERENCES tab_prod(id_prod)
);

CREATE TABLE tab_requisicion(
	num_requisicion		DECIMAL(5,0)	NOT NULL,
	id_prod				SMALLINT		NOT NULL,
	val_cant			SMALLINT		NOT NULL,
	fec_requisicio		TIMESTAMP WITHOUT TIME ZONE NOT NULL,
	PRIMARY KEY(num_requisicion),
	FOREIGN KEY(id_prod) REFERENCES tab_prod(id_prod)
);


CREATE TABLE hist_facturacion_diaria (
    id_hist_diario          SMALLINT        NOT NULL,
    dia                     DATE,
    total_facturas          INT             NOT NULL DEFAULT 0,  
    total_dia               DECIMAL(10,0)   NOT NULL DEFAULT 0,
    PRIMARY KEY(id_hist_diario)
);

CREATE TABLE hist_facturacion_mensual (
    id_hist_mensual         SMALLINT        NOT NULL,
    mes                     DATE	        NOT NULL,
    total_facturas          INT             NOT NULL DEFAULT 0,
    total_mes               DECIMAL(10,0)   NOT NULL DEFAULT 0,
    PRIMARY KEY(id_hist_mensual)
);