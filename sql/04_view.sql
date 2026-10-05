-- 04_view.sql
-- Reporting view used directly as the data source for an APEX Interactive
-- Report. LEFT JOINs ANTRAG_FLAECHE so an application still shows up even
-- before any area has been added to it.

CREATE OR REPLACE VIEW V_ANTRAG_UEBERSICHT AS
SELECT
    a.ANTRAG_ID,
    b.NAME AS BETRIEB,
    a.JAHR,
    a.EINREICHDATUM,
    a.STATUS,
    a.FOERDERBETRAG,
    COUNT(af.FLAECHE_ID) AS ANZAHL_FLAECHEN,
    NVL(SUM(af.HEKTAR), 0) AS GESAMT_HEKTAR
FROM ANTRAG a
JOIN BETRIEB b
    ON a.BETRIEB_ID = b.BETRIEB_ID
LEFT JOIN ANTRAG_FLAECHE af
    ON a.ANTRAG_ID = af.ANTRAG_ID
GROUP BY
    a.ANTRAG_ID,
    b.NAME,
    a.JAHR,
    a.EINREICHDATUM,
    a.STATUS,
    a.FOERDERBETRAG;
