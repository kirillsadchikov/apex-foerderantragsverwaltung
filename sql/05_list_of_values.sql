-- 05_list_of_values.sql
-- Technical foreign keys are never shown directly in the UI. APEX List of
-- Values queries translate them into readable names for the user while the
-- database keeps storing the numeric ID.

-- Betrieb LOV — user sees e.g. "Biohof Steiner", BETRIEB_ID is stored internally.
SELECT
    NAME,
    BETRIEB_ID
FROM BETRIEB
ORDER BY NAME;

-- Kultur LOV — user sees e.g. "Weizen", "Mais" or "Gruenland", KULTUR_ID is stored internally.
SELECT
    NAME,
    KULTUR_ID
FROM KULTUR
ORDER BY NAME;
