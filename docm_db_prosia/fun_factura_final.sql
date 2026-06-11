
-- ============================================================================
-- SCRIPT DE FACTURACIÓN BLINDADA (fun_factura)
-- ============================================================================
--SELECT id_prod,val_existencia FROM tab_prod;
--SELECT fun_factura('73001',1098765432,ARRAY[1,2,3,4,5],ARRAY[10,35,3,2,5]);
CREATE OR REPLACE FUNCTION fun_factura(wid_ciudad tab_ciudades.id_ciudad%TYPE,wid_cliente tab_clientes.id_cliente%TYPE,
                                       wprod INTEGER[], wcant INTEGER[]) RETURNS BOOLEAN AS
$$
    DECLARE wreg_pmtros         RECORD;
            wreg_ciudad         RECORD;
			wreg_cliente        RECORD;
			wreg_prod           RECORD;
            windice             SMALLINT;
            windice2            SMALLINT;
            wcant_array_prod    SMALLINT;
            wcant_array_cant    SMALLINT;
            wval_bruto          INTEGER;
            wval_iva            INTEGER;
            wval_neto           INTEGER;
			wval_desc			INTEGER;
            wval_desc_fidel     INTEGER;
			wdesc_dia			INTEGER;
			wval_inicial 		INTEGER DEFAULT 0;
            wid_factura     tab_enc_fac.id_factura%TYPE;
            wtotal_bruto_factura INTEGER DEFAULT 0;
            wtotal_desc_factura  INTEGER DEFAULT 0;
            wtotal_iva_factura   INTEGER DEFAULT 0;
            wtotal_neto_factura  INTEGER DEFAULT 0;
            wpuntos_ganados      INTEGER DEFAULT 0;
            wtotal_cantidades_validas INTEGER DEFAULT 0;
    BEGIN
        -- 1. Validaciones básicas de arreglo de entrada evitar arreglos vacíos o nulos
        IF wprod IS NULL OR wcant IS NULL OR ARRAY_LENGTH(wprod, 1) IS NULL OR ARRAY_LENGTH(wcant, 1) IS NULL OR ARRAY_LENGTH(wprod, 1) = 0 THEN
            RAISE NOTICE 'Los arreglos de productos y cantidades no pueden estar vacíos o ser nulos';
            RETURN FALSE;
        END IF;

        wcant_array_prod = ARRAY_LENGTH(wprod,1);
        wcant_array_cant = ARRAY_LENGTH(wcant,1);
        IF wcant_array_prod <> wcant_array_cant THEN
            RAISE NOTICE 'Sea serio... La cant. de productos (%) es diferente que la cantidad de cantidades (%).. No JODÁAAAAS',wcant_array_prod,wcant_array_cant;
            RETURN FALSE; 
        END IF;

        -- Validar productos duplicados en la lista
        FOR windice IN 1..ARRAY_LENGTH(wprod,1) LOOP
            FOR windice2 IN (windice+1)..ARRAY_LENGTH(wprod,1) LOOP
                IF wprod[windice] = wprod[windice2] THEN
                    RAISE NOTICE 'Producto % está duplicado en la lista', wprod[windice];
                    RETURN FALSE;
                END IF;
            END LOOP;
        END LOOP;

        -- 2. Cargar en la RAM el registro de parámetros y validar
        SELECT a.id_empresa,a.nom_empresa,a.dir_empresa,a.tel_empresa,a.num_ini_fac,a.num_fin_fac,a.num_actual_fac,a.val_puntos_peso,a.val_porc_iva,
               a.val_porc_desc_fidel,a.val_puntos_fidel,a.num_dia_desc_gral,a.val_porc_desc_gral INTO wreg_pmtros FROM tab_pmtros a;
		IF NOT FOUND THEN
            RAISE NOTICE 'No hay parámetros papacho, que tamos haciendo loco';
            RETURN FALSE;
        END IF;

        -- 3. Cargar cliente y validar
		SELECT a.id_cliente,a.nom_cliente,a.val_puntos,a.val_ptos_redimidos,a.ind_estado
        INTO wreg_cliente
        FROM tab_clientes a
        WHERE a.id_cliente = wid_cliente;

        IF NOT fun_valida_cliente(wid_cliente) THEN
        	RAISE NOTICE 'Ojo con el cliente, no ve que lo puede insertar dos veces o le va a facturar a un fantasma';
			RETURN FALSE;
        END IF;

        -- Validar estado del cliente        
        IF NOT wreg_cliente.ind_estado THEN
            RAISE NOTICE 'El cliente % está inactivo', wid_cliente;
            RETURN FALSE;
        END IF;

        -- 4. Validar existencia de la ciudad 
        SELECT a.id_ciudad,a.nom_ciudad INTO wreg_ciudad FROM tab_ciudades a
        WHERE id_ciudad = wid_ciudad;
        IF NOT FOUND THEN
            RAISE NOTICE 'La ciudad % no existe, créela primero', wid_ciudad;
            RETURN FALSE;
        END IF;

--Validar que el numero de la factura este dentro del rango estableciodo
        IF wreg_pmtros.num_actual_fac > wreg_pmtros.num_fin_fac THEN
            RAISE NOTICE 'El # actual de la factura % es mayor que el que dio la DIAN %. Pida otro rango o seg gana su CANAZO',wreg_pmtros.num_actual_fac,wreg_pmtros.num_fin_fac;
            RETURN FALSE;
        END IF;

		IF LENGTH(wreg_pmtros.nom_empresa) <= 10 THEN
            RAISE NOTICE 'Cuándo ha visto usted un nombre de enpresa < de 10 caracteres? Be Serious...';
            RETURN FALSE;
        END IF;
--Validar que puntos por peso en parametros sea positivo o cero
        IF NOT fun_valida_puntos(wreg_pmtros.val_puntos_peso) THEN
            RAISE NOTICE 'Arregle sus pinches puntos de fidelización porque esta vaina no funciona...';
            RETURN FALSE;
        END IF;
--Validar que el porcentaje de IVA en parametros sea entre 0 y 100
        IF NOT fun_valida_cero(wreg_pmtros.val_porc_iva) THEN
            RAISE NOTICE 'Arregle sus pinches porcentajes.. El IVA no puede ser menor que 0 o mayor que 100...';
            RETURN FALSE;
        END IF;
--Validar que el porcentaje de descuento por fidelización en parametros sea entre 0 y 100
        IF NOT fun_valida_cero(wreg_pmtros.val_porc_desc_fidel) THEN
            RAISE NOTICE 'El descuento debe ser positivo o cero, animal';
            RETURN FALSE;
        END IF;
--Validar que los puntos necesarios para redimir descuento por fidelización en parametros sea positivo o cero
        IF NOT fun_valida_puntos(wreg_pmtros.val_puntos_fidel) THEN
            RAISE NOTICE 'El valor de los puntos no puede ser menor que 0, animal';
            RETURN FALSE;
        END IF;
--Validar que el numero del dia de la semana sea valido (entre 0 y 6)
        IF NOT fun_valida_dia(wreg_pmtros.num_dia_desc_gral) THEN
            RAISE NOTICE 'Coloque un dia de la semana válido de por Diosssss';
            RETURN FALSE;
        END IF;
--Validar que el porcentaje de descuento general por dia de la semana en parametros sea entre 0 y 100
        IF NOT fun_valida_cero(wreg_pmtros.val_porc_desc_gral) THEN
            RAISE NOTICE 'Arregle sus pinches porcentajes.. El Valor del descuento no puede ser negativo';
            RETURN FALSE;
        END IF;
--Validar que el nommbre de la ciudad tenga mas de tres caracteres 
        IF NOT LENGTH(wreg_ciudad.nom_ciudad) > 3 THEN
            RAISE NOTICE 'El nombre de la ciudad % no es válido. Revise ome que monda esta mandando', wid_ciudad;
            RETURN FALSE;
        END IF;

        -- 6. Validar y preparar productos (stock, existencia y precios) ANTES de insertar cabeceras
        wtotal_cantidades_validas = 0;
        FOR windice IN 1..ARRAY_LENGTH(wprod,1) LOOP
            IF wcant[windice] <= 0 THEN
                RAISE NOTICE 'La cantidad del producto % debe ser mayor que 0', wprod[windice];
                RETURN FALSE;
            END IF;

            -- Validar existencia en catálogo
            SELECT a.id_prod,a.nom_prod,a.val_unidad,a.ind_iva,a.ind_aplica_promo2x1,a.val_existencia INTO wreg_prod FROM tab_prod a
            WHERE a.id_prod = wprod[windice];
            IF NOT FOUND THEN
                RAISE NOTICE 'El producto % no existe... No sea rata, no venda cosas que no hay',wprod[windice];
                RETURN FALSE;
            END IF;

            -- Validar precio del producto
            IF wreg_prod.val_unidad <= 0 THEN
                RAISE NOTICE 'El precio del producto % es inválido', wprod[windice];
                RETURN FALSE;
            END IF;

            -- Validar y ajustar existencias / registrar requisición si falta stock
            IF wreg_prod.val_existencia < wcant[windice] THEN
                RAISE NOTICE 'El producto % no tiene suficiente existencia. Se enviará a requisición.', wprod[windice];
                CALL PROCEDURE_ACTUALIZA_EXISTENCIA(wprod[windice], wcant[windice], wreg_prod.val_existencia);
                wcant[windice] = wreg_prod.val_existencia;
            END IF;

            wtotal_cantidades_validas = wtotal_cantidades_validas + wcant[windice];
        END LOOP;

        -- Si después de ajustes no quedó ningún producto con stock para facturar
        IF wtotal_cantidades_validas <= 0 THEN
            RAISE NOTICE 'No hay existencias disponibles de ninguno de los productos solicitados para facturar.';
            RETURN FALSE;
        END IF;

        -- 7. Insertar la cabecera de la factura (todo está validado)
        INSERT INTO tab_enc_fac VALUES(wreg_pmtros.num_actual_fac, CURRENT_DATE, wreg_ciudad.id_ciudad, wid_cliente, wtotal_neto_factura);
        IF NOT FOUND THEN
            RAISE NOTICE 'La factura % tiene serios problemas al guardarse en el encabezado...', wreg_pmtros.num_actual_fac;
            RETURN FALSE;
        END IF;

        -- Actualizar consecutivo de factura
        wid_factura = (wreg_pmtros.num_actual_fac + 1);
        UPDATE tab_pmtros SET num_actual_fac = wid_factura
        WHERE id_empresa = wreg_pmtros.id_empresa;
        IF NOT FOUND THEN
            RAISE NOTICE 'La factura % no pudo actualizar el parámetro de número actual...', wreg_pmtros.num_actual_fac;
            RETURN FALSE;
        END IF;

        -- 8. Crear los detalles de la factura y acumular totales
        FOR windice IN 1..ARRAY_LENGTH(wprod,1) LOOP
            -- Si quedó en 0 por ajuste de stock, lo saltamos
            IF wcant[windice] <= 0 THEN
                CONTINUE;
            END IF;

            -- Cargar producto
            SELECT a.id_prod,a.nom_prod,a.val_unidad,a.ind_iva,a.ind_aplica_promo2x1,a.val_existencia INTO wreg_prod FROM tab_prod a
            WHERE a.id_prod = wprod[windice];

            -- EVALUACIÓN DE 2X1 EN CADA PRODUCTO
            IF wreg_prod.ind_aplica_promo2x1 THEN
                IF wcant[windice]%2 = 0 THEN
                    wval_inicial = (wreg_prod.val_unidad * wcant[windice]) / 2;
                ELSE
                    wval_inicial = ((wreg_prod.val_unidad * (wcant[windice]-1)) / 2) + wreg_prod.val_unidad;
                END IF;
            ELSE
                wval_inicial = (wreg_prod.val_unidad * wcant[windice]);				
            END IF;

            -- VALIDAR PUNTOS CLIENTES Y APLICAR DESCUENTOS
            IF wreg_cliente.val_puntos >= wreg_pmtros.val_puntos_fidel THEN
                wval_desc_fidel = (wval_inicial * wreg_pmtros.val_porc_desc_fidel)/100;
            ELSE
                wval_desc_fidel = 0;
            END IF;
            wval_bruto = wval_inicial - wval_desc_fidel;

            -- VALIDAR DESCUENTO GENERAL POR DIA DE LA SEMANA
            IF wreg_pmtros.num_dia_desc_gral = EXTRACT (DOW FROM CURRENT_DATE ) THEN 
                wdesc_dia = (wval_bruto * wreg_pmtros.val_porc_desc_gral) / 100;
            ELSE 
                wdesc_dia = 0;
            END IF;
            wval_bruto = wval_bruto - wdesc_dia;

            -- EVALUACIÓN DE IVA
            IF wreg_prod.ind_iva THEN
                wval_iva = (wval_bruto * wreg_pmtros.val_porc_iva)/100;
            ELSE
                wval_iva = 0;
            END IF;
            wval_neto = wval_bruto + wval_iva;
			wval_desc = (wval_desc_fidel + wdesc_dia); 

            -- Insertar detalle
            INSERT INTO tab_det_fac VALUES (wreg_pmtros.num_actual_fac, wprod[windice], wcant[windice], wval_desc, wval_iva, wval_bruto, wval_neto);
            
            -- Actualizar stock
            UPDATE tab_prod SET val_existencia = val_existencia - wcant[windice] WHERE id_prod = wprod[windice];

            -- Acumular totales
            wtotal_bruto_factura = wtotal_bruto_factura + wval_bruto;
            wtotal_desc_factura  = wtotal_desc_factura  + wval_desc;
            wtotal_iva_factura   = wtotal_iva_factura   + wval_iva;
            wtotal_neto_factura  = wtotal_neto_factura  + wval_neto;
        END LOOP;

        -- Actualizar val_total con el total real calculado (dispara fun_hist)
        UPDATE tab_enc_fac SET val_total = wtotal_neto_factura WHERE id_factura = wreg_pmtros.num_actual_fac; 

        -- 9. Puntos de fidelización (Redimir y Acumular por la compra)
        -- Calcular puntos ganados (10 puntos por cada $1000 de compra total neta)
        wpuntos_ganados = (wtotal_neto_factura / 1000) * wreg_pmtros.val_puntos_peso;

        IF wreg_cliente.val_puntos >= wreg_pmtros.val_puntos_fidel THEN
            UPDATE tab_clientes 
            SET val_puntos = val_puntos - wreg_pmtros.val_puntos_fidel + wpuntos_ganados,
                val_ptos_redimidos = val_ptos_redimidos + wreg_pmtros.val_puntos_fidel
            WHERE id_cliente = wid_cliente;
        ELSE
            UPDATE tab_clientes 
            SET val_puntos = val_puntos + wpuntos_ganados
            WHERE id_cliente = wid_cliente;
        END IF;

-- 10. visualizar totales
        RAISE NOTICE '==================================================';
        RAISE NOTICE 'FACTURA PROCESADA CON ÉXITO: #%', wreg_pmtros.num_actual_fac;
        RAISE NOTICE '==================================================';
        RAISE NOTICE 'Total Bruto:      $%', wtotal_bruto_factura;
        RAISE NOTICE 'Total Descuentos: $%', wtotal_desc_factura;
        RAISE NOTICE 'Total IVA:        $%', wtotal_iva_factura;
        RAISE NOTICE 'Total Neto:       $%', wtotal_neto_factura;
        RAISE NOTICE 'Puntos Obtenidos: % ptos', wpuntos_ganados;
        RAISE NOTICE '==================================================';

        RETURN TRUE;

    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE 'Error inesperado al procesar la factura: %', SQLERRM;
            RETURN FALSE;
    END;
$$
LANGUAGE plpgsql;


-- ============================================================================
-- PROCEDIMIENTOS Y FUNCIONES AUXILIARES REQUERIDAS
-- ============================================================================

CREATE OR REPLACE PROCEDURE PROCEDURE_ACTUALIZA_EXISTENCIA(wid_producto INTEGER, wcantidad INTEGER, wcant_prod INTEGER) AS
$$
    DECLARE wmax INTEGER;
    BEGIN
        IF wid_producto IS NULL OR wcantidad IS NULL THEN
            RAISE NOTICE 'El producto o la cantidad no pueden ser nulos';
            RETURN;
        END IF;
        SELECT MAX(num_requisicion) INTO wmax FROM tab_requisicion;
        IF FOUND THEN
            wmax = wmax + 1;
        ELSE
            wmax = 1;
        END IF;
        wcantidad = wcantidad - wcant_prod;
		
        INSERT INTO tab_requisicion SELECT COALESCE(MAX(num_requisicion), 0) + 1, wid_producto, wcantidad, CURRENT_TIMESTAMP FROM tab_requisicion;
        IF FOUND THEN
            RAISE NOTICE 'Ya quedó consignada la requisición para que el indio respectivo compre el producto %',wid_producto;
        END IF;
    END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION fun_valida_cliente(wid_cliente tab_clientes.id_cliente%TYPE) RETURNS BOOLEAN AS
$$
	BEGIN
		IF NOT EXISTS (SELECT 1 FROM tab_clientes WHERE id_cliente = wid_cliente) THEN
    		RAISE NOTICE 'El cliente % no existe.. Eso dice Davi, yo no sé', wid_cliente;
	    	RETURN FALSE;
		ELSE
    		RAISE NOTICE 'El cliente %  existe, casi que no rey', wid_cliente;
    		RETURN TRUE;
		END IF;
	END;
$$
LANGUAGE PLPGSQL;

CREATE OR REPLACE FUNCTION fun_valida_cero(wvariable ANYELEMENT) RETURNS BOOLEAN AS
$$
    BEGIN
        IF wvariable < 0 OR wvariable > 100 THEN
            RAISE NOTICE 'La está C$&#&... No mande valores negativos ni mayores que 100, vea %',wvariable;
            RETURN FALSE;
        ELSE
            RAISE NOTICE 'El valor que manda a validar está bien.. Siga así que va a triunfar';
            RETURN TRUE;
        END IF;
    END;
$$
LANGUAGE PLPGSQL;

CREATE OR REPLACE FUNCTION fun_valida_puntos (wpuntos ANYELEMENT) RETURNS BOOLEAN AS
$$
BEGIN 
    IF wpuntos < 0 THEN 
        RAISE NOTICE 'Los puntos no pueden ser menores que 0';
        RETURN FALSE; 
    ELSE
        RAISE NOTICE 'Todo melo caramelo como mi abuelo';
        RETURN TRUE;
    END IF; 
END; 
$$
LANGUAGE PLPGSQL;

CREATE OR REPLACE FUNCTION fun_valida_dia(wdia_sem ANYELEMENT) RETURNS BOOLEAN AS
$$
BEGIN
    IF wdia_sem < 0 OR wdia_sem > 6 THEN
        RAISE NOTICE 'Por favor ingrese un dia de la semana valido de 0 a 6';
        RETURN FALSE;
    ELSE    
        RAISE NOTICE 'Listo pelao, todo good';
        RETURN TRUE;
    END IF;
END;
$$
LANGUAGE PLPGSQL;

CREATE OR REPLACE FUNCTION fun_valida_ciudad(wid_ciudad tab_ciudades.id_ciudad%TYPE) RETURNS BOOLEAN AS
$$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM tab_ciudades WHERE id_ciudad = wid_ciudad) THEN
        RAISE NOTICE 'Ciudad no encontrada';
        RETURN FALSE;
    ELSE
        RETURN TRUE;
    END IF;
END;
$$
LANGUAGE PLPGSQL;
