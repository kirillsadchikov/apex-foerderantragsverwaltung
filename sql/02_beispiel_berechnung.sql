-- 02_beispiel_berechnung.sql
-- First version of the calculation, written in plain SQL before it was
-- moved into a reusable PL/SQL function (see 03_function_procedure.sql).

SELECT
    af.ANTRAG_ID,
    SUM(af.HEKTAR * k.SATZ_PRO_HEKTAR) AS FOERDERBETRAG
FROM ANTRAG_FLAECHE af
JOIN KULTUR k
    ON af.KULTUR_ID = k.KULTUR_ID
WHERE af.ANTRAG_ID = 1
GROUP BY af.ANTRAG_ID;
