# Subsidy Application Management (Oracle APEX)

A small Oracle APEX prototype for managing agricultural subsidy applications:
a farm submits an application for a given year, adds one or more land areas
with a crop and a size, and the subsidy amount is calculated from reusable
PL/SQL instead of being duplicated in the UI.

Portfolio case study with screenshots: [kirillsadchikov.github.io/projects/apex-foerderantrag.html](https://kirillsadchikov.github.io/projects/apex-foerderantrag.html)

## Data model

Four tables carry the process: a farm (`BETRIEB`) has many applications
(`ANTRAG`) across years; each application has many areas
(`ANTRAG_FLAECHE`); each area references a crop (`KULTUR`) that carries the
per-hectare subsidy rate.

```
BETRIEB 1:n ANTRAG 1:n ANTRAG_FLAECHE n:1 KULTUR
```

`UNIQUE (BETRIEB_ID, JAHR)` ensures a farm can only submit one application
per year. `CHECK (HEKTAR > 0)` ensures only positive area sizes can be
stored. See [`sql/01_tabellen.sql`](sql/01_tabellen.sql).

## Business logic in PL/SQL, not in the UI

The calculation is split into a pure function and a procedure that controls
the process, so the APEX page never duplicates the business rule itself —
it just calls into the database:

- **`F_ERMITTLE_FOERDERBETRAG`** — pure calculation. Joins `ANTRAG_FLAECHE`
  to `KULTUR`, sums hectares times rate per hectare, returns a `NUMBER`.
- **`BERECHNE_FOERDERBETRAG`** — validates first (raises `ORA-20001` if the
  application has no areas), calls the function, then updates the
  application with the calculated amount and sets its status to
  `BERECHNET`.

See [`sql/03_function_procedure.sql`](sql/03_function_procedure.sql). The
"Foerderbetrag berechnen" button on the APEX page passes the current
application ID to the procedure — nothing else.

## Reporting

[`sql/04_view.sql`](sql/04_view.sql) defines `V_ANTRAG_UEBERSICHT`, a
reporting view that joins application and farm data with a `LEFT JOIN` (so
an application stays visible even before any area is added) and aggregates
the area count and total hectares per application. It's used directly as
the data source for an APEX Interactive Report.

Technical foreign keys are never shown directly in the UI —
[`sql/05_list_of_values.sql`](sql/05_list_of_values.sql) has the APEX List
of Values queries that translate them into readable names (e.g. "Biohof
Steiner" instead of `BETRIEB_ID = 1`).

## Testing

Two manual end-to-end tests plus a re-calculation test — see
[`docs/manuelle_tests.md`](docs/manuelle_tests.md):

- **Negative:** an application with zero areas is rejected with
  `ORA-20001` before any amount is written.
- **Positive:** Landwirtschaft Huber — 8 ha Weizen × 200 + 4 ha Grünland ×
  120 = 2,080, status `BERECHNET`.
- **Re-calculation:** changing an area's hectares and re-running the
  calculation produces a different, correct amount — not just correct on
  the first run.

## Architecture documentation

[`arc42/Foerderantragsverwaltung_arc42.md`](arc42/Foerderantragsverwaltung_arc42.md)
is a simplified arc42-style architecture document (German): goals and
quality attributes, context, solution strategy, the building-block and
runtime views, architecture decisions (ADRs) for putting the calculation in
PL/SQL and linking tables by technical IDs, and known risks/technical debt
for a production version.

## Scope

This is intentionally a small prototype, not a production subsidy system —
built as a personal portfolio project. The business rules and subsidy rates
are simplified demo assumptions. Complex eligibility rules, a full
roles/permissions concept, external interfaces, and automated tests are out
of scope for this version (see the arc42 document's "Risiken und technische
Schulden" and "Mögliche Erweiterungen" sections for what a production
version would need).

## Stack

Oracle Database, SQL, PL/SQL, Oracle APEX.
