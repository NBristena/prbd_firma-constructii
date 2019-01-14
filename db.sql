---------------------------
---- Crearea tabelelor ----
---------------------------
CREATE TABLE clienti( 
id_client NUMBER(4,0) not null, 
nume_client VARCHAR2(20) not null, 
prenume_client VARCHAR2(20) not null, 
data_nastere DATE not null, 
numar_telefon CHAR(10) not null, 
email VARCHAR2(30),

CONSTRAINT clienti_pk PRIMARY KEY (id_client)
); 

CREATE TABLE cereri( 
id_cerere NUMBER(4,0) not null,
nr_camere NUMBER(1,0) not null,
suprafata_locuibila NUMBER(3,0) not null,
amprenta_la_sol NUMBER(3,0) not null, 
id_client NUMBER(4,0) not null,

CONSTRAINT cereri_pk PRIMARY KEY (id_cerere),
CONSTRAINT cereri_fk_id_clienti  FOREIGN KEY (id_client) REFERENCES clienti(id_client)
);

CREATE TABLE locuinte ( 
id_locuinta NUMBER(4,0) not null,
data_incepere date not null,
id_cerere NUMBER(4,0) not null,
id_teren NUMBER(4,0) not null,
nr_etapa NUMBER(1,0) not null,
id_pret NUMBER(4,0),

CONSTRAINT locuinte_pk PRIMARY KEY (id_locuinta), 
CONSTRAINT locuinte_fk_id_cerere 
	FOREIGN KEY (id_cerere) 
	REFERENCES cereri(id_cerere)
);

CREATE TABLE preturi( 
id_pret NUMBER(4,0) not null, 
pret_total NUMBER(6,0), 
id_locuinta NUMBER(4,0),

CONSTRAINT preturi_pk PRIMARY KEY (id_pret),
CONSTRAINT preturi_fk_id_locuinta  
	FOREIGN KEY (id_locuinta)   
	REFERENCES locuinte(id_locuinta)
);

CREATE TABLE terenuri( 
id_teren NUMBER(4,0) not null, 
suprafata_teren NUMBER(3,0) not null, 
pret_teren NUMBER(6,0) not null, 
id_locuinta NUMBER(4,0),

CONSTRAINT terenuri_pk PRIMARY KEY (id_teren),
CONSTRAINT terenuri_fk_id_locuinta 
	FOREIGN KEY (id_locuinta) 
	REFERENCES locuinte(id_locuinta)
);

CREATE TABLE materiale( 
id_material NUMBER(4,0) not null, 
pachet_materiale VARCHAR2(40) not null, 
pret_materiale NUMBER(6,0) not null, 
nr_camere NUMBER(1,0) NOT NULL,
id_locuinta NUMBER(4,0),

CONSTRAINT materiale_pk PRIMARY KEY (id_material),
CONSTRAINT materiale_fk_id_locuinta 
	FOREIGN KEY (id_locuinta) 
	REFERENCES locuinte(id_locuinta)
);

CREATE TABLE etape_constr(
nr_etapa NUMBER(1,0) not null, 
nume_etapa VARCHAR2(25) not null,
pret_etapa NUMBER(6,0) not null,
durata_etapa NUMBER(2,1) not null,
id_angajat NUMBER(4,0) not null,
id_utilaj NUMBER(4,0),

CONSTRAINT etape_pk PRIMARY KEY (nr_etapa)
); 

CREATE TABLE angajati( 
id_angajat NUMBER(4,0) not null, 
nume_angajat VARCHAR2(20) not null, 
prenume_angajat VARCHAR2(20) not null, 
profesie VARCHAR2(25) not null , 
pret_consultatie NUMBER(4,0) not null,
data_angajare DATE not null,
numar_telefon CHAR(10) not null, 
email VARCHAR2(30),

CONSTRAINT angajati_pk PRIMARY KEY (id_angajat),
CONSTRAINT angajati_profesie_check 
	CHECK (profesie IN ('Manager', 'Arhitect', 'Designer interior', 'Inginer constructor', 'Inginer instalator'))
); 
	
CREATE TABLE utilaje( 
id_utilaj NUMBER(4,0) not null,
nume_utilaj VARCHAR2(20) not null, 
pret_utilaj NUMBER(6,0) not null,

CONSTRAINT utilaje_pk PRIMARY KEY (id_utilaj) 
);


--------------------------------------------------------------
--  Modificarea tabelelor pentru a le aduce la forma dorita -- 
--------------------------------------------------------------
ALTER TABLE locuinte
ADD CONSTRAINT locuinte_fk_id_teren  
	FOREIGN KEY (id_teren)
	REFERENCES terenuri(id_teren);
ALTER TABLE locuinte
ADD CONSTRAINT locuinte_fk_numar_etapa 
	FOREIGN KEY (nr_etapa) 
	REFERENCES etape_constrstr (numar_etapa);
ALTER TABLE locuinte
ADD CONSTRAINT locuinte_fk_id_pret 
	FOREIGN KEY (id_pret) 
	REFERENCES preturi (id_pret);
ALTER TABLE locuinte
ADD CONSTRAINT etapa_check 
	CHECK (nr_etapa BETWEEN 1 AND 7);
	
ALTER TABLE etape_constrstr
ADD CONSTRAINT etape_fk_id_angajat  
	FOREIGN KEY (id_angajat) 
	REFERENCES angajati (id_angajat);
ALTER TABLE etape_constrstr
ADD CONSTRAINT etape_fk_id_utilaj  
	FOREIGN KEY (id_utilaj) 
	REFERENCES  utilaje (id_utilaj);

ALTER TABLE angajati
MODIFY (data_angajare default (to_date('07-01-2217', 'dd-mm-yyyy')));


-----------------------------------
---- Adaugarea inregistrarilor ---- 
-----------------------------------

INSERT INTO terenuri
VALUES (301, 165, 66000, NULL);
INSERT INTO terenuri
VALUES (302, 160, 64000, NULL);
INSERT INTO terenuri
VALUES (303, 110, 44000, NULL);
INSERT INTO terenuri
VALUES (304, 200, 80000, NULL);
INSERT INTO terenuri
VALUES (305, 210, 84000, NULL);
INSERT INTO terenuri
VALUES (306, 150, 60000, NULL);
INSERT INTO terenuri
VALUES (307, 250, 100000, NULL);
INSERT INTO terenuri
VALUES (308, 210, 85000, NULL);

INSERT INTO materiale
VALUES (1, 'beton armat, caramida, gresie, tigla', 2000, 4, NULL);
INSERT INTO materiale
VALUES (2, 'beton armat, clt, faianta, tigla', 3000, 2, NULL);
INSERT INTO materiale
VALUES (3, 'beton armat, BCA, parchet, tigla', 4000, 5, NULL);
INSERT INTO materiale
VALUES (4, 'beton armat, BCA, parchet, tigla', 3500, 4, NULL);
INSERT INTO materiale
VALUES (5, 'beton armat, clt, faianta, tigla', 5000, 5, NULL);
INSERT INTO materiale
VALUES (6, 'beton armat, BCA, parchet, tigla', 3000, 6, NULL);
INSERT INTO materiale
VALUES (7, 'beton armat, caramida, gresie, tigla', 1500, 3, NULL);
INSERT INTO materiale
VALUES (8, 'beton armat, caramida, gresie, tigla', 2500, 6, NULL);

INSERT INTO utilaje
VALUES (1, 'buldozer', 32000);
INSERT INTO utilaje
VALUES (2, 'excavator',	15000);
INSERT INTO utilaje
VALUES (3, 'macara', 100000);
INSERT INTO utilaje
VALUES (4, 'greder', 23000);
INSERT INTO utilaje
VALUES (5, 'camion', 40000);

INSERT INTO etape_constrstr
VALUES (1, 'consultare', 100, 0.5, 1, NULL);
INSERT INTO etape_constrstr
VALUES (2, 'proiectare', 2000, 1, 2, NULL);
INSERT INTO etape_constrstr
VALUES (3, 'structura', 101087, 1.0 , 4, 3);
INSERT INTO etape_constrstr
VALUES (4, 'hvac', 33080, 2.0, 5, 1);
INSERT INTO etape_constrstr
VALUES (5, 'sanitare', 16080, 1.5, 5, 2);
INSERT INTO etape_constrstr
VALUES (6, 'acoperire', 101087, 1, 4, 3);
INSERT INTO etape_constrstr
VALUES (7, 'mobilare', 41090, 1, 3, 5);

INSERT INTO angajati
VALUES (1, 'Nicolescu', 'Tudor', 'Manager', 100, TO_DATE('7-1-2018', 'dd-mm-yyyy'), '072747823', 'n.tudor@efden.org');
INSERT INTO angajati
VALUES (2, 'Anghel', 'Olimpia', 'Arhitect', 2000, TO_DATE('7-1-2018', 'dd-mm-yyyy'), '072266848', 'a.olimpia@efden.org');
INSERT INTO angajati
VALUES (3, 'Anton', 'Cristina', 'Designer interior', 1090, TO_DATE('10-1-2018', 'dd-mm-yyyy'), '072121355', 'a.cristina@efden.org');
INSERT INTO angajati
VALUES (4, 'Culea', 'Razvan', 'Inginer constructor', 1087, TO_DATE('12-1-2018', 'dd-mm-yyyy'), '074458216', 'c.razvan@efden.org');
INSERT INTO angajati
VALUES (5, 'Oprea', 'Alexandru', 'Inginer instalator', 1080, TO_DATE('20-1-2018', 'dd-mm-yyyy'), '072583694', 'o.alex@efden.org');

INSERT INTO clienti
VALUES (1, 'Chirculescu', 'Cristina', TO_DATE('27-12-1995', 'dd-mm-yyyy'), '0756324895', 'ccris@gmail.com');
INSERT INTO clienti
VALUES (2, 'Dragomir ', 'Ana', TO_DATE('2-6-1988', 'dd-mm-yyyy'), '0756984236', 'ana.dr@gmail.com');
INSERT INTO clienti
VALUES (3, 'Lazar', 'Alexandru', TO_DATE('18-2-1987', 'dd-mm-yyyy'), '0725487715', NULL);
INSERT INTO clienti
VALUES (4, 'Nita', 'Alina', TO_DATE('21-4-1975', 'dd-mm-yyyy'), '0733658524', 'nita.e.alina@gmail.com');
INSERT INTO clienti
VALUES (5, 'Dumitrescu', 'Claudiu', TO_DATE('10-2-1990', 'dd-mm-yyyy'), '0723568955', NULL);
INSERT INTO clienti
VALUES (6, 'Chirculescu', 'Cristina', TO_DATE('27-12-1972', 'dd-mm-yyyy'), '0756324895', 'ccris@gmail.com');

INSERT INTO cereri
VALUES (101, 4, 115, 137, 1);
INSERT INTO cereri
VALUES (102, 3, 90, 110, 2);
INSERT INTO cereri
VALUES (103, 5, 150, 182, 3);
INSERT INTO cereri
VALUES (104, 4, 120, 148, 4);
INSERT INTO cereri
VALUES (105, 5, 155, 179, 5);
INSERT INTO cereri
VALUES (106, 5, 160, 180, 6);

INSERT INTO locuinte
VALUES (201, TO_DATE('10-5-2018', 'dd-mm-yyyy'), 101, 302, 1, 1);
INSERT INTO locuinte
VALUES (202, TO_DATE('20-6-2018', 'dd-mm-yyyy'), 102, 306, 1, 2);
INSERT INTO locuinte
VALUES (203, TO_DATE('29-09-2018', 'dd-mm-yyyy'), 103, 304, 1, 3);
INSERT INTO locuinte
VALUES (204, TO_DATE('3-10-2018', 'dd-mm-yyyy'), 104, 301, 1, 4);
INSERT INTO locuinte
VALUES (205, TO_DATE('1-1-2019', 'dd-mm-yyyy'), 105, 305, 1, 5);
INSERT INTO locuinte
VALUES (206, TO_DATE('5-1-2019', 'dd-mm-yyyy'), 106, 308, 1, 6);

INSERT INTO preturi
VALUES (1, NULL, NULL);
INSERT INTO preturi
VALUES (2, NULL, NULL);
INSERT INTO preturi
VALUES (3, NULL, NULL);
INSERT INTO preturi
VALUES (4, NULL, NULL);
INSERT INTO preturi
VALUES (5, NULL, NULL);
INSERT INTO preturi
VALUES (6, NULL, NULL);


-----------------------------------------------------------------
-- Modificarea datelor pentru a lega terenurile si materialele --
--     de locuintele lor, cat si pentru a calcula preturi      --
-----------------------------------------------------------------
UPDATE terenuri
SET id_locuinta = 204 WHERE id_teren = 301;
UPDATE terenuri
SET id_locuinta = 201 WHERE id_teren = 302 ;
UPDATE terenuri
SET id_locuinta = 203 WHERE id_teren = 304;
UPDATE terenuri
SET id_locuinta = 205 WHERE id_teren = 305;
UPDATE terenuri
SET id_locuinta = 202 WHERE id_teren = 306;
UPDATE terenuri
SET id_locuinta = 206 WHERE id_teren = 308;

UPDATE materiale
SET id_locuinta = 201 WHERE id_material = 1;
UPDATE materiale
SET id_locuinta = 202 WHERE id_material = 2;
UPDATE materiale
SET id_locuinta = 203 WHERE id_material = 3;
UPDATE materiale
SET id_locuinta = 204 WHERE id_material = 4;
UPDATE materiale
SET id_locuinta = 205 WHERE id_material = 5;
UPDATE materiale
SET id_locuinta = 206 WHERE id_material = 8;

UPDATE preturi
SET id_locuinta = 201 ,
         pret_total = (
(SELECT pret_teren + pret_materiale FROM locuinte l, materiale m, terenuri t
WHERE l.id_locuinta = 201 AND l.id_locuinta = m.id_locuinta And l.id_locuinta = t.id_locuinta) +
(SELECT SUM(pret_etapa) FROM etape_constr))
WHERE id_pret = 1;
 
UPDATE preturi
SET id_locuinta = 202,
         pret_total = (
(SELECT pret_teren + pret_materiale FROM locuinte l, materiale m, terenuri t
WHERE l.id_locuinta = 202 AND l.id_locuinta = m.id_locuinta And l.id_locuinta = t.id_locuinta) +
(SELECT SUM(pret_etapa) FROM etape_constr))
WHERE id_pret = 2;
 
UPDATE preturi
SET id_locuinta = 203,
         pret_total = (
(SELECT pret_teren + pret_materiale FROM locuinte l, materiale m, terenuri t
WHERE l.id_locuinta = 203 AND l.id_locuinta = m.id_locuinta And l.id_locuinta = t.id_locuinta) +
(SELECT SUM(pret_etapa) FROM etape_constr))
WHERE id_pret = 3;

UPDATE preturi
SET id_locuinta = 204,
         pret_total = (
(SELECT pret_teren + pret_materiale FROM locuinte l, materiale m, terenuri t
WHERE l.id_locuinta = 204 AND l.id_locuinta = m.id_locuinta And l.id_locuinta = t.id_locuinta) +
(SELECT SUM(pret_etapa) FROM etape_constr))
WHERE id_pret = 4;
 
UPDATE preturi
SET id_locuinta = 205,
         pret_total = (
(SELECT pret_teren + pret_materiale FROM locuinte l, materiale m, terenuri t
WHERE l.id_locuinta = 205 AND l.id_locuinta = m.id_locuinta And l.id_locuinta = t.id_locuinta) +
(SELECT SUM(pret_etapa) FROM etape_constr))
WHERE id_pret = 5;
 
UPDATE preturi
SET id_locuinta = 206,
         pret_total = (
(SELECT pret_teren + pret_materiale FROM locuinte l, materiale m, terenuri t
WHERE l.id_locuinta = 206 AND l.id_locuinta = m.id_locuinta And l.id_locuinta = t.id_locuinta) +
(SELECT SUM(pret_etapa) FROM etape_constr))
WHERE id_pret = 6;