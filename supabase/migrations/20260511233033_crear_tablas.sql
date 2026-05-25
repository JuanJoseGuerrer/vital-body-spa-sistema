CREATE TABLE customers (
    customer_id VARCHAR(15) PRIMARY KEY,
    first_name VARCHAR(20) NOT NULL,
    middle_name VARCHAR(20),
    first_last_name VARCHAR(20) NOT NULL,
    second_last_name VARCHAR(20),
    phone VARCHAR(15) NOT NULL,
    birth_date DATE NOT NULL
);

CREATE TABLE services (
    service_id VARCHAR(3) PRIMARY KEY,
    name VARCHAR(30) NOT NULL,
    description VARCHAR(60),
    cost NUMERIC(10,2) NOT NULL
);

CREATE TABLE employees (
    employee_id VARCHAR(3) PRIMARY KEY,
    first_name VARCHAR(20) NOT NULL,
    middle_name VARCHAR(20),
    first_last_name VARCHAR(20) NOT NULL,
    second_last_name VARCHAR(20),
    phone VARCHAR(15) NOT NULL,
    hiring_date DATE NOT NULL,          
    salary NUMERIC(10,2) NOT NULL,
    status VARCHAR(9) NOT NULL,         
    certification VARCHAR(30) NOT NULL,
    specialty VARCHAR(30),
    user_name VARCHAR(20) UNIQUE, 
    password VARCHAR(60),         
    employee_admin_id VARCHAR(3),   

    CONSTRAINT fk_employee_admin FOREIGN KEY (employee_admin_id) 
        REFERENCES employees(employee_id)
);

CREATE TABLE appointments (
    appointment_id VARCHAR(5) PRIMARY KEY,
    appointment_date TIMESTAMP WITH TIME ZONE NOT NULL,   
    status VARCHAR(20) NOT NULL,        
    customer_id VARCHAR(15) NOT NULL, 
    service_id VARCHAR(3) NOT NULL,
    
    CONSTRAINT fk_appointments_customer FOREIGN KEY (customer_id) 
        REFERENCES customers(customer_id),
    CONSTRAINT fk_appointments_service FOREIGN KEY (service_id) 
        REFERENCES services(service_id)
);

CREATE TABLE appointment_details (
   
    appointment_details_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    cost NUMERIC(10,2) NOT NULL,
    employee_id VARCHAR(3) NOT NULL,
    service_id VARCHAR(3) NOT NULL,
    appointment_id VARCHAR(5) NOT NULL,
    
    CONSTRAINT fk_details_employee FOREIGN KEY (employee_id) 
        REFERENCES employees(employee_id),
    CONSTRAINT fk_details_service FOREIGN KEY (service_id) 
        REFERENCES services(service_id),
    CONSTRAINT fk_details_appointment FOREIGN KEY (appointment_id) 
        REFERENCES appointments(appointment_id)
);

CREATE TABLE payments (
    payment_id VARCHAR(5) PRIMARY KEY,
    payment_method VARCHAR(15) NOT NULL, 
    payment_date TIMESTAMP WITH TIME ZONE NOT NULL,   
    payment_amount NUMERIC(10,2) NOT NULL,
    appointment_id VARCHAR(5) NOT NULL,   
    
    CONSTRAINT fk_payments_appointment FOREIGN KEY (appointment_id) 
        REFERENCES appointments(appointment_id)
);

CREATE TABLE medical_records (
    medical_record_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    registration_date DATE NOT NULL,          
    description VARCHAR(250) NOT NULL,
    customer_id VARCHAR(15) NOT NULL,
    
    CONSTRAINT fk_records_customer FOREIGN KEY (customer_id) 
        REFERENCES customers(customer_id)
);