ARC42

# **Förderantragsverwaltung**

## **Vereinfachte Architekturdokumentation nach arc42**

### **1. Einführung und Ziele**

#### **1.1 Aufgabenstellung**

Die Anwendung unterstützt die vereinfachte Verwaltung und Berechnung von
Förderanträgen landwirtschaftlicher Betriebe.

Ein Betrieb kann für ein bestimmtes Jahr einen Förderantrag erfassen.
Ein Antrag enthält eine oder mehrere landwirtschaftliche Flächen. Für
jede Fläche werden eine Kultur sowie die Größe in Hektar angegeben.

Auf Basis der hinterlegten Fördersätze wird der Förderbetrag automatisch
berechnet.

Die fachlichen Regeln und Fördersätze des Prototyps sind bewusst
vereinfacht und dienen zur Demonstration der technischen Umsetzung.

#### **1.2 Wesentliche Funktionen**

-   Verwaltung von Betrieben

-   Verwaltung von Kulturen und Fördersätzen

-   Erfassung von Förderanträgen

-   Erfassung mehrerer Flächen pro Antrag

-   Berechnung des Förderbetrags

-   Speicherung des Berechnungsergebnisses

-   Verwaltung des Status eines Antrags

#### **1.3 Qualitätsziele**

**Wartbarkeit
**Die Geschäftslogik soll zentral umgesetzt und leicht änderbar sein.

**Datenkonsistenz
**Ungültige oder widersprüchliche Daten sollen durch Regeln in der
Datenbank verhindert werden.

**Benutzbarkeit
**Die Oberfläche soll einfach verständlich sein und technische
Datenbank-IDs vor dem Benutzer verbergen.

### **2. Randbedingungen**

#### **2.1 Technische Randbedingungen**

Die Anwendung verwendet folgende Technologien:

-   Oracle Database

-   SQL

-   PL/SQL

-   Oracle APEX

-   HTML für kleinere Anpassungen der Benutzeroberfläche

-   browserbasierte Benutzeroberfläche

#### **2.2 Projektumfang**

Es handelt sich um einen kleinen Prototyp und nicht um ein produktives
Fördersystem.

Komplexe fachliche Förderregeln, umfangreiche Rollen- und
Berechtigungskonzepte, externe Schnittstellen und automatisierte Tests
sind nicht Bestandteil der aktuellen Version.

### **3. Kontextabgrenzung**

Der Benutzer arbeitet über eine Oracle-APEX-Weboberfläche mit der
Anwendung.

Oracle APEX stellt die Benutzeroberfläche mit Reports, Formularen und
Master-Detail-Ansichten bereit.

Die Daten werden in einer Oracle-Datenbank gespeichert.

Die zentrale Berechnungslogik für den Förderbetrag wird mit PL/SQL
umgesetzt.

**Vereinfachter Systemkontext:**

Benutzer
↓
Oracle APEX
↓
SQL / PL/SQL
↓
Oracle Database

### **4. Lösungsstrategie**

Die Benutzeroberfläche wird mit Oracle APEX umgesetzt.

Die fachlichen Daten werden in einem relationalen Datenmodell in der
Oracle-Datenbank gespeichert.

Beziehungen zwischen den Tabellen werden über Primär- und Fremdschlüssel
abgebildet.

Constraints sichern wichtige Regeln zusätzlich direkt auf Datenbankebene
ab.

Die Berechnung des Förderbetrags wird zentral mit PL/SQL umgesetzt und
nicht direkt in der APEX-Oberfläche.

Dadurch ist die Geschäftslogik von der Benutzeroberfläche getrennt,
wiederverwendbar und leichter wartbar.

### **5. Bausteinsicht**

#### **5.1 Datenmodell**

Die Anwendung verwendet vier zentrale Tabellen.

**BETRIEB**

Enthält die Stammdaten eines landwirtschaftlichen Betriebs.

Wichtige Attribute:

-   BETRIEB_ID

-   BETRIEBSNUMMER

-   NAME

**KULTUR**

Enthält die verfügbaren Kulturen und den jeweiligen Fördersatz pro
Hektar.

Wichtige Attribute:

-   KULTUR_ID

-   NAME

-   SATZ_PRO_HEKTAR

**ANTRAG**

Enthält einen Förderantrag eines Betriebs für ein bestimmtes Jahr.

Wichtige Attribute:

-   ANTRAG_ID

-   BETRIEB_ID

-   JAHR

-   EINREICHDATUM

-   STATUS

-   FOERDERBETRAG

**ANTRAG_FLAECHE**

Enthält die einzelnen Flächen eines Förderantrags.

Wichtige Attribute:

-   FLAECHE_ID

-   ANTRAG_ID

-   KULTUR_ID

-   HEKTAR

#### **5.2 Beziehungen**

Ein Betrieb kann mehrere Anträge haben.

Ein Antrag gehört genau zu einem Betrieb.

Ein Antrag kann mehrere Flächen enthalten.

Eine Kultur kann in vielen verschiedenen Anträgen verwendet werden.

Die Tabelle ANTRAG_FLAECHE verbindet einen Antrag mit einer Kultur und
speichert zusätzlich die jeweilige Anzahl der Hektar.

#### **5.3 Datenbankregeln**

Zur Sicherstellung der Datenqualität werden unter anderem folgende
Constraints verwendet:

-   Primary Keys zur eindeutigen Identifikation von Datensätzen

-   Foreign Keys zur Sicherung der Beziehungen zwischen Tabellen

-   NOT NULL für Pflichtfelder

-   UNIQUE für eindeutige Werte und Kombinationen

-   CHECK zur fachlichen Validierung von Werten

Beispiel:

UNIQUE (BETRIEB_ID, JAHR)

stellt sicher, dass ein Betrieb pro Jahr nur einen Förderantrag besitzen
kann.

CHECK (HEKTAR > 0)

stellt sicher, dass nur positive Flächenwerte gespeichert werden können.

### **6. Laufzeitsicht**

#### **6.1 Berechnung eines Förderbetrags**

Der Benutzer öffnet einen Förderantrag in der APEX-Anwendung.

Zu dem Antrag sind eine oder mehrere Flächen gespeichert. Jede Fläche
besitzt eine Kultur und eine Anzahl von Hektar.

> **Der Benutzer klickt auf „Förderbetrag berechnen". APEX übergibt die
> aktuelle Antrag-ID an die Prozedur BERECHNE_FOERDERBETRAG. Die
> Prozedur prüft zunächst, ob Flächen vorhanden sind. Falls nicht, wird
> ein fachlicher Fehler zurückgegeben. Anschließend ruft die Prozedur
> die Funktion F_ERMITTLE_FOERDERBETRAG auf. Die Funktion verbindet
> Flächen und Kulturen über einen JOIN und berechnet mit SUM den
> Gesamtbetrag. Die Prozedur speichert anschließend den zurückgegebenen
> Betrag im Antrag und setzt den Status auf BERECHNET.**

### **7. Verteilungssicht**

Die Anwendung läuft browserbasiert über Oracle APEX.

Die Benutzeroberfläche wird von APEX bereitgestellt.

Die Datenhaltung sowie die SQL- und PL/SQL-Logik befinden sich in der
Oracle-Datenbank.

Eine separate externe Anwendung oder ein zusätzlicher Application Server
wird für diesen Prototyp nicht verwendet.

### **8. Querschnittliche Konzepte**

#### **8.1 Datenkonsistenz**

Datenbank-Constraints verhindern ungültige Beziehungen und bestimmte
fachlich ungültige Werte.

#### **8.2 Trennung von Darstellung und Geschäftslogik**

APEX wird hauptsächlich für die Benutzeroberfläche verwendet.

Die Berechnung des Förderbetrags wird zentral mit PL/SQL umgesetzt.

#### **8.3 Benutzerfreundliche Darstellung von Fremdschlüsseln**

Die Datenbank speichert technische IDs als Fremdschlüssel.

In der Benutzeroberfläche werden stattdessen verständliche Werte
angezeigt.

Beispielsweise wird intern BETRIEB_ID = 1 gespeichert, während der
Benutzer „Biohof Steiner" sieht.

Dafür werden in APEX List-of-Values-Abfragen verwendet.

### **9. Architekturentscheidungen**

#### **ADR-01: Berechnungslogik in PL/SQL**

**Entscheidung:** Die reine Berechnung wird in einer PL/SQL-Funktion
umgesetzt. Die Validierung und Aktualisierung des Antrags erfolgt in
einer separaten PL/SQL-Prozedur.

**Begründung:** Dadurch sind Berechnung und Prozesssteuerung voneinander
getrennt. Die Berechnungsfunktion kann wiederverwendet werden, während
die Prozedur den fachlichen Ablauf steuert.

**Alternative**

Die Berechnung könnte direkt innerhalb einer APEX-Seite implementiert
werden.

Diese Lösung wurde nicht gewählt, da die Geschäftslogik dadurch stärker
an die Benutzeroberfläche gekoppelt wäre.

#### **ADR-02: Relationen über technische IDs**

**Entscheidung**

Die Tabellen werden über technische numerische Primärschlüssel
miteinander verbunden.

Beispiel:

ANTRAG.BETRIEB_ID → BETRIEB.BETRIEB_ID

**Begründung**

Technische IDs sind stabil und unabhängig von fachlichen Bezeichnungen.

Die Benutzeroberfläche kann weiterhin verständliche Namen anzeigen,
während intern eindeutige Schlüssel verwendet werden.

### **10. Qualitätsanforderungen**

#### **10.1 Wartbarkeit**

Die Berechnungslogik ist zentral in einer PL/SQL-Funktion umgesetzt. Die
Prozedur übernimmt die Validierung und Prozesssteuerung. Dadurch sind
die Verantwortlichkeiten klar getrennt und Änderungen leichter wartbar.

#### **10.2 Datenkonsistenz**

Primary Keys, Foreign Keys, Unique Constraints, NOT NULL und Check
Constraints verhindern verschiedene Arten ungültiger Daten.

#### **10.3 Benutzbarkeit**

Der Benutzer sieht verständliche Namen statt technischer IDs.

Die APEX-Oberfläche stellt Stammdaten, Förderanträge und die zugehörigen
Flächen übersichtlich dar.

#### **10.4 Nachvollziehbarkeit**

Der berechnete Förderbetrag und der Status werden direkt im Antrag
gespeichert und können anschließend in der Anwendung angezeigt werden.

### **11. Risiken und technische Schulden**

Der aktuelle Prototyp verwendet vereinfachte fachliche Regeln.

Die Fördersätze werden aktuell direkt in der Tabelle KULTUR gespeichert.
In einer produktiven Anwendung müssten Fördersätze möglicherweise nach
Jahr oder Förderprogramm historisiert werden.

Das Rollen- und Berechtigungskonzept ist noch nicht vollständig
umgesetzt.

Automatisierte Tests sind noch nicht implementiert.

Die aktuelle Fehlerbehandlung deckt grundlegende fachliche Validierungen
ab und könnte für eine produktive Anwendung erweitert werden.

Externe Systeme oder Schnittstellen sind bisher nicht angebunden.

### **12. Mögliche Erweiterungen**

-   Historisierung der Fördersätze nach Jahr

-   eigene Tabelle für Förderjahre

-   Rollen und Benutzerberechtigungen

-   zusätzliche fachliche Validierungen

-   ausführlichere Fehlerbehandlung

-   automatisierte Tests

-   Dashboard mit Statistiken

-   Geodaten und Kartendarstellung

-   externe Schnittstellen über REST APIs

-   detailliertere Statuslogik

-   Audit-Logging von Änderungen
