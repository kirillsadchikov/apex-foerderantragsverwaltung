# Manuelle Tests

Zwei Tests decken das Verhalten ab, das fachlich zaehlt: eine normale Berechnung
und das Verhalten, wenn die Vorbedingung nicht erfuellt ist. Ein dritter Test
prueft die Neuberechnung nach einer Datenaenderung.

## Test 1 — Antrag ohne Flaechen

Ein neuer Antrag fuer Landwirtschaft Huber wurde ohne Flaechen erstellt. Beim
Start der Berechnung wurde die Validierung ausgeloest:

```
ORA-20001: Der Antrag enthaelt keine Flaechen.
```

Damit wurde geprueft, dass ein unvollstaendiger Antrag nicht berechnet werden
kann — kein Betrag wird geschrieben, solange die Vorbedingung nicht erfuellt
ist.

## Test 2 — Erfolgreiche Berechnung

Fuer Landwirtschaft Huber wurden folgende Flaechen erfasst:

| Kultur     | Hektar | Satz pro Hektar | Teilbetrag |
|---|---|---|---|
| Weizen     | 8      | 200              | 1.600      |
| Gruenland  | 4      | 120              | 480        |
| **Gesamt** |        |                  | **2.080**  |

Nach Ausfuehrung der Berechnung wurde der Foerderbetrag mit 2080 gespeichert
und der Status auf `BERECHNET` gesetzt.

## Test 3 — Neuberechnung nach Datenaenderung

Beim Antrag von Biohof Steiner wurde die Weizenflaeche von 10 auf 11 Hektar
geaendert. Der Foerderbetrag aenderte sich nach erneuter Berechnung von 2750
auf 2950 — die Berechnung ist deterministisch und wiederholbar, nicht nur beim
ersten Lauf korrekt.
