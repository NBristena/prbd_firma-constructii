---------------------------
--       Interogari      --
---------------------------


--  1. Sa se afiseze numele, prenumele si data nasterii clientilor
--  nascuti in luna februarie.

SELECT nume_client, prenume_client, data_nastere
FROM clienti
WHERE TO_CHAR(data_nastere) LIKE '%FEB%';


--  2. Sa se afiseze numele, prenumele, profesia si telefonul 
-- 	arhitectilor si ale designerilor de interior angajati.

SELECT nume_angajat, prenume_angajat, profesie, numar_telefon
FROM angajati
WHERE profesie IN ('Arhitect', 'Designer interior');


--  3. Sa se afiseze numele fiecarui client si ultimele 3 cifre din
--  numarul sau de telefon.

SELECT UNIQUE(nume_client), '*******'||(MOD(numar_telefon,1000))"NUMAR_DE_TELEFON"
FROM clienti


--  4. Sa se afiseze intr-un mod sugestiv locuintele care se afla 
--  in etapa finala sau in cea incipiala.

SELECT id_locuinta, DECODE(nr_etapa, 1, 'incipiala',7,'finala') AS "Faza"
FROM locuinte
where nr_etapa NOT BETWEEN 2 AND 6;


--  5. Sa se determine data finalizarii ultimei case incepute.

SELECT ADD_MONTHS(
(SELECT MAX(data_incepere) FROM locuinte),(SELECT SUM(durata_etapa) FROM etape_constr))||' '
AS "Data finalizare ultima casa"
FROM locuinte
WHERE data_incepere = (SELECT MAX(data_incepere) FROM locuinte)


--  6. Sa se afiseze numarul de cereri depuse de fiecare client.

SELECT cl.nume_client, COUNT(id_cerere) "Numar de cereri"
FROM cereri ce, clienti cl
WHERE cl.id_client = ce.id_client
GROUP BY cl.nume_client


--  7. Sa se determine valoarea medie a consultatiilor.

SELECT AVG(pret_consultatie)||' (EURO) ' AS "Valoarea medie a consultarilor"
FROM angajati


--  8. Sa se afiseze numele clientilor si pretul total platit de
--  clientii a caror casa / case a / au costat mai mult de 370000 EURO.

SELECT cl.nume_client, cl.prenume_client, SUM(p.pret_total)||' (EURO)' AS "PRET_TOTAL"
FROM preturi p
INNER JOIN locuinte l ON p.id_locuinta = l.id_locuinta 
INNER JOIN cereri ce ON l.id_cerere = ce.id_cerere
INNER JOIN clienti cl ON ce.id_client = cl.id_client
GROUP BY cl.nume_client, cl.prenume_client
HAVING sum(p.pret_total) > 370000


--  9. Sa se afiseze suma salariilor obtinute in urma construirii
--  unei case, exceptand salariul managerului de 100 de euro.

SELECT SUM(a.pret_consultatie*COUNT(e.id_angajat))||' EURO'
        AS "Salarii adunate dupa o casa"
FROM angajati a
INNER JOIN etape_constr e ON a.id_angajat = e.id_angajat
GROUP BY a.nume_angajat, a.pret_consultatie
	HAVING a.pret_consultatie NOT LIKE '100'


-- 10. Sa se afiseze materialele folosite pentru casa care are data
-- de incepere cea mai veche.

SELECT pachet_materiale AS "Materiale pentru prima casa"
FROM materiale m, locuinte l
WHERE m.id_locuinta = l.id_locuinta 
AND l.data_incepere = (SELECT MIN(data_incepere) FROM locuinte)


-- 11. Sa se afiseze o lista cu utilajele folosite pentru fiecare etapa.

SELECT DISTINCT nume_etapa, NVL2( e.id_utilaj, nume_utilaj, ' - ') 
							AS UTILAJ_FOLOSIT
FROM etape_constr e, utilaje u
WHERE  e.id_utilaj = u.id_utilaj OR e.id_utilaj IS NULL


-- 12. Sa se afiseze toate materiale si terenurire oferite de firma.
-- Cele care nu au fost inca alese sa fie etichetate corespunzator.

SELECT NVL(TO_CHAR(m.pachet_materiale),'- material neales -'), 
		NVL(TO_CHAR(t.id_teren),'- teren neales -')
FROM materiale m
FULL OUTER JOIN terenuri t ON m.id_locuinta = t.id_locuinta;


-- 13. Sa se afiseze profesia fiecarui angajat. Daca acesta este 
-- manager sa se afiseze si email-ul, daca este inginer sa se afiseze 
-- numele, iar in rest sa se afiseze numarul de telefon.

SELECT profesie,  (
CASE WHEN UPPER(profesie) like 'MANAGER' THEN email
     WHEN UPPER(profesie) like 'INGINER%' THEN nume_angajat
     ELSE numar_telefon END ) AS "Info"
FROM angajati


-- 14. Sa se afiseze data inceperii locuintei pentru fiecare client.

SELECT cl.nume_client, l.data_incepere
FROM clienti cl
INNER JOIN cereri ce ON cl.id_client = ce.id_client
INNER JOIN locuinte l ON ce.id_cerere = l.id_cerere


-- 15. Sa se afiseze toate terenurile si id-urile locuintelor sau
-- 'Liber' daca inca nu au fost cumparate.

SELECT id_teren, NVL(TO_CHAR(id_locuinta), 'Liber')"id_locuinta"
FROM terenuri;