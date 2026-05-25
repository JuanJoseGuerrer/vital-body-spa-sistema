
--TABLA DE AUDITORÍA
CREATE TABLE audit_log (
    audit_id          BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    table_name        VARCHAR(50)  NOT NULL,           
    operation         VARCHAR(10)  NOT NULL,           
    performed_by      VARCHAR(20),                     
    performed_at      TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    client_ip         INET,                            
    client_port       INTEGER,                         
    new_data          JSONB,
    old_data          JSONB                          
);

CREATE INDEX idx_audit_table     ON audit_log(table_name);
CREATE INDEX idx_audit_user      ON audit_log(performed_by);
CREATE INDEX idx_audit_date      ON audit_log(performed_at);
CREATE INDEX idx_audit_operation ON audit_log(operation);


--FUNCIÓN DE AUDITORÍA
CREATE OR REPLACE FUNCTION fn_audit()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_user VARCHAR(20);
BEGIN
    -- Leer el usuario logueado en la app; si no existe la variable retorna NULL
    BEGIN
        v_user := current_setting('app.current_user');
    EXCEPTION WHEN OTHERS THEN
        v_user := NULL;
    END;

    IF TG_OP = 'INSERT' THEN
        INSERT INTO audit_log (
            table_name, operation, performed_by,
            client_ip, client_port,
            old_data, new_data
        ) VALUES (
            TG_TABLE_NAME, 'INSERT', v_user,
            inet_client_addr(), inet_client_port(),
            NULL,
            to_jsonb(NEW)
        );
        RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO audit_log (
            table_name, operation, performed_by,
            client_ip, client_port,
            old_data, new_data
        ) VALUES (
            TG_TABLE_NAME, 'UPDATE', v_user,
            inet_client_addr(), inet_client_port(),
            to_jsonb(OLD),
            to_jsonb(NEW)
        );
        RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO audit_log (
            table_name, operation, performed_by,
            client_ip, client_port,
            old_data, new_data
        ) VALUES (
            TG_TABLE_NAME, 'DELETE', v_user,
            inet_client_addr(), inet_client_port(),
            to_jsonb(OLD),
            NULL
        );
        RETURN OLD;
    END IF;

    RETURN NULL;
END;
$$;

--TRIGGERS — uno por tabla

-- CUSTOMERS
CREATE TRIGGER trg_audit_customers
AFTER INSERT OR UPDATE OR DELETE ON customers
FOR EACH ROW EXECUTE FUNCTION fn_audit();

-- SERVICES
CREATE TRIGGER trg_audit_services
AFTER INSERT OR UPDATE OR DELETE ON services
FOR EACH ROW EXECUTE FUNCTION fn_audit();

-- EMPLOYEES
CREATE TRIGGER trg_audit_employees
AFTER INSERT OR UPDATE OR DELETE ON employees
FOR EACH ROW EXECUTE FUNCTION fn_audit();

-- APPOINTMENTS
CREATE TRIGGER trg_audit_appointments
AFTER INSERT OR UPDATE OR DELETE ON appointments
FOR EACH ROW EXECUTE FUNCTION fn_audit();

-- APPOINTMENT_DETAILS
CREATE TRIGGER trg_audit_appointment_details
AFTER INSERT OR UPDATE OR DELETE ON appointment_details
FOR EACH ROW EXECUTE FUNCTION fn_audit();

-- PAYMENTS
CREATE TRIGGER trg_audit_payments
AFTER INSERT OR UPDATE OR DELETE ON payments
FOR EACH ROW EXECUTE FUNCTION fn_audit();

-- MEDICAL_RECORDS
CREATE TRIGGER trg_audit_medical_records
AFTER INSERT OR UPDATE OR DELETE ON medical_records
FOR EACH ROW EXECUTE FUNCTION fn_audit();



