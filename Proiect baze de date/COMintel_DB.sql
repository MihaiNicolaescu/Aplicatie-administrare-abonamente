/*Baza de date*/

/*Tabele*/
CREATE TABLE ABONATI(
    ID_ABONAT INT PRIMARY KEY,
    NUME VARCHAR2(32) NOT NULL,
    PRENUME VARCHAR2(32) NOT NULL,
    ADRESA VARCHAR2(256) NOT NULL,
    TELEFON NUMBER(10) NOT NULL,
    CNP NUMBER(15) NOT NULL,
    COD_ABONAMENT NUMBER(5) NOT NULL CONSTRAINT COD_ABONAMENT_FK REFERENCES ABONAMENTE(COD_ABONAMENT)
);

CREATE TABLE ABONAMENTE(
    COD_ABONAMENT INT PRIMARY KEY,
    DENUMIRE VARCHAR2(32) NOT NULL,
    TIP VARCHAR(32) NOT NULL,
    TRAFIC NUMBER(6,2) NOT NULL,
    PRET NUMBER(4,2) NOT NULL,
    PRET_EXTRA_TRAFIC NUMBER (4,2) NOT NULL
);

CREATE TABLE CONTRACTE(
    NR_CONTRACT INT PRIMARY KEY,
    ID_ABONAT INT NOT NULL CONSTRAINT ID_ABONAT_FK REFERENCES ABONATI(ID_ABONAT),
    VALABILITATE NUMBER(2) NOT NULL,
    DATA_INCHEIERII DATE NOT NULL,
    COD_ABONAMENT NUMBER(7,0) NOT NULL
);

CREATE TABLE FACTURI(
    NR_FACTURA INT PRIMARY KEY,
    ID_ABONAT INT NOT NULL CONSTRAINT ID_ABONAT_FACTURI_FK REFERENCES ABONATI(ID_ABONAT),
    DATA_EMITERII DATE NOT NULL,
    DATA_SCADENTA DATE NOT NULL,
    TOTAL_PLATA NUMBER(4,2) NOT NULL,
    ABONAMENT number(7,0) NOT NULL
);

CREATE TABLE ADMINS(
    ID_ADMIN INT PRIMARY KEY,
    USERNAME VARCHAR2(32) UNIQUE,
    PASSWORD VARCHAR2(32)
);

/*Secventa folosita in trigger pentru incrementarea automata a cheilor principale*/
CREATE SEQUENCE ADMINS_SQ
    START WITH 1 INCREMENT BY 1;

CREATE SEQUENCE Facturi_increment
    START WITH 1 INCREMENT BY 1;
    
CREATE SEQUENCE abonati_increment
    START WITH 1 INCREMENT BY 1;
    
CREATE SEQUENCE contracte_increment
    START WITH 1 INCREMENT BY 1;
    
/*Triggere pentru incrementarea automata a cheilor principale la insert*/

CREATE OR REPLACE TRIGGER INCREMENT_ABONATI
  BEFORE INSERT ON ABONATI
  FOR EACH ROW

BEGIN
  SELECT abonati_increment.NEXTVAL
    INTO :new.ID_ABONAT
    FROM dual;
END;

CREATE OR REPLACE TRIGGER INCREMENT_FACTURI
  BEFORE INSERT ON FACTURI
  FOR EACH ROW

BEGIN
  SELECT Facturi_increment.NEXTVAL
    INTO :new.NR_FACTURA
    FROM dual;
END;

CREATE OR REPLACE TRIGGER INCREMENT_CONTRACTE
  BEFORE INSERT ON CONTRACTE
  FOR EACH ROW

BEGIN
  SELECT increment_with_1_CONTRACTS.NEXTVAL
    INTO :new.NR_CONTRACT
    FROM dual;
END;

CREATE OR REPLACE TRIGGER INCREMENT_ADMINS
  BEFORE INSERT ON ADMINS
  FOR EACH ROW

BEGIN
  SELECT ADMINS_SQ.NEXTVAL
    INTO :new.ID_ADMIN
    FROM dual;
END;

/*Trigger pentru a actualiza codul abonamentului din tabela contracte atunci cand se actualizeaza tabela abonati*/
CREATE OR REPLACE TRIGGER UPDATE_CONTRACT_BY_ABONAMENT
  BEFORE  UPDATE ON ABONATI
  FOR EACH ROW
DECLARE
    cd_abon number;
    id_abon number;
BEGIN
    cd_abon  := :NEW.COD_ABONAMENT;
    id_abon  := :NEW.ID_ABONAT;
    UPDATE CONTRACTE SET COD_ABONAMENT = cd_abon WHERE ID_ABONAT = id_abon;
END;




    
    







