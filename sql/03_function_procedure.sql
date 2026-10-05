-- 03_function_procedure.sql
-- The calculation lives in a pure PL/SQL function; a separate procedure
-- validates the application and controls the process (calculate, then
-- persist). The APEX page only ever calls the procedure.

CREATE OR REPLACE FUNCTION F_ERMITTLE_FOERDERBETRAG (
    p_antrag_id IN NUMBER
)
RETURN NUMBER
AS
    v_betrag NUMBER;
BEGIN
    SELECT NVL(
        SUM(af.HEKTAR * k.SATZ_PRO_HEKTAR),
        0
    )
    INTO v_betrag
    FROM ANTRAG_FLAECHE af
    JOIN KULTUR k
        ON af.KULTUR_ID = k.KULTUR_ID
    WHERE af.ANTRAG_ID = p_antrag_id;

    RETURN v_betrag;
END;
/

CREATE OR REPLACE PROCEDURE BERECHNE_FOERDERBETRAG (
    p_antrag_id IN NUMBER
)
AS
    v_betrag            NUMBER;
    v_anzahl_flaechen   NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_anzahl_flaechen
    FROM ANTRAG_FLAECHE
    WHERE ANTRAG_ID = p_antrag_id;

    IF v_anzahl_flaechen = 0 THEN
        RAISE_APPLICATION_ERROR(
            -20001,
            'Der Antrag enthaelt keine Flaechen.'
        );
    END IF;

    v_betrag := F_ERMITTLE_FOERDERBETRAG(p_antrag_id);

    UPDATE ANTRAG
    SET FOERDERBETRAG = v_betrag,
        STATUS = 'BERECHNET'
    WHERE ANTRAG_ID = p_antrag_id;
END;
/

-- Called from the APEX "Foerderbetrag berechnen" button as a Page Process:
--
-- BEGIN
--     BERECHNE_FOERDERBETRAG(:P8_ANTRAG_ID);
-- END;
--
-- Flow: APEX -> application ID -> procedure -> validation -> function
--       -> SQL calculation -> return value -> UPDATE -> updated amount and status.
