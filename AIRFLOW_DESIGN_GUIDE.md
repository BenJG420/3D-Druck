# 3D Druck Luftstrom Design Guide

## Problem gelöst: Geschlossene STL-Dateien ohne Luftdurchgang

Die ursprünglichen STL-Dateien hatten das Problem, dass sie vollständig geschlossen waren und keine Luft durchströmen konnte. Diese neuen Designs lösen dieses Problem durch strategisch platzierte Belüftungsöffnungen und Luftkanäle.

## Enthaltene Dateien

### 1. Ventilated Housing (`ventilated_housing.stl/.scad`)

**Luftstrom-Features:**
- **Frontbelüftung**: Mehrere 8mm Durchmesser Löcher in einem 15mm Raster
- **Rückbelüftung**: Identisches Lochmuster für Durchzug
- **Seitenschlitze**: Horizontale Luftkanäle (5mm breit, 3mm hoch)
- **Obere Belüftung**: Gittermuster für Wärmeabfuhr
- **Interne Luftkanäle**: Führen Luft durch das Gehäuseinnere
- **Drainagelöcher**: In den Montagefüßen gegen Wasseransammlung

**Anpassbare Parameter:**
```scad
housing_width = 100;          // Gehäusebreite
housing_depth = 80;           // Gehäusetiefe  
housing_height = 60;          // Gehäusehöhe
vent_hole_diameter = 8;       // Belüftungsloch-Durchmesser
vent_hole_spacing = 15;       // Abstand zwischen Löchern
air_channel_width = 5;        // Breite der Luftkanäle
air_channel_height = 3;       // Höhe der Luftkanäle
```

### 2. Airflow Fan Shroud (`airflow_fan_shroud.stl/.scad`)

**Luftstrom-Optimierungen:**
- **Einlass-Trichter**: Erweitert sich von 40mm auf 48mm für besseren Lufteinzug
- **Auslass-Expansion**: Reduziert Rückstau durch graduelle Erweiterung
- **Leitschaufeln**: 6 Schaufeln reduzieren Turbulenzen
- **Montage-Tabs**: 4 Befestigungspunkte mit integrierten Schraubenlöchern
- **Kabelführung**: Schlitz für Lüfterkabel
- **Optionaler Filthalter**: Kann zugeschaltet werden

**Anpassbare Parameter:**
```scad
fan_diameter = 40;            // Lüfterdurchmesser (Standard 40mm)
inlet_taper_length = 15;      // Länge des Einlass-Trichters
outlet_taper_length = 25;     // Länge der Auslass-Erweiterung
wall_thickness = 1.5;         // Wandstärke für optimale Festigkeit
```

## Luftstrom-Prinzipien

### 1. Durchzugslüftung
- Lufteinlass auf einer Seite, Auslass auf der gegenüberliegenden Seite
- Vermeidet Luftstagnation und Hotspots
- Kontinuierlicher Luftaustausch

### 2. Druckausgleich
- Mehrere Öffnungsgrößen verhindern Überdruck/Unterdruck
- Natürliche Konvektion wird unterstützt
- Reduzierte Belastung für Lüfter

### 3. Turbulenzreduktion
- Abgerundete Kanten an Lufteinlässen
- Leitschaufeln für gerichteten Luftstrom
- Graduelle Querschnittsänderungen

## Druckeinstellungen für optimale Belüftung

### Empfohlene Slicer-Einstellungen:
- **Layer-Höhe**: 0.2mm (gute Balance zwischen Qualität und Druckzeit)
- **Infill**: 15-20% (ausreichend für Stabilität, nicht zu dicht)
- **Perimeter**: 2-3 (für saubere Löcher)
- **Support**: Nur für Überhänge >45°
- **Bridging**: Aktiviert für kleine Löcher

### Wichtige Punkte:
- **Löcher nicht zu klein drucken**: Mindestens 5mm Durchmesser für zuverlässigen Druck
- **Orientierung beachten**: Luftkanäle sollten möglichst horizontal liegen
- **Nachbearbeitung**: Löcher ggf. nachbohren für perfekte Rundung

## Anpassung für spezielle Anwendungen

### Für höhere Luftströme:
- `vent_hole_diameter` auf 10-12mm erhöhen
- `vent_hole_spacing` auf 12mm reduzieren
- Mehr Löcher = mehr Luftdurchsatz

### Für leiseren Betrieb:
- Mehr kleine Löcher statt weniger große
- `air_channel_height` erhöhen für weniger Strömungswiderstand
- Leitschaufeln im Fan Shroud optimieren

### Für Staubschutz:
- Filter-Mount im Fan Shroud aktivieren: `air_filter_mount();`
- Kleinere Löcher verwenden (6mm statt 8mm)
- Zusätzliche Filtereinsätze vorsehen

## Druckanleitung

1. **Vorbereitung:**
   - OpenSCAD-Dateien öffnen und Parameter anpassen
   - STL-Dateien mit F6 regenerieren
   - In Slicer importieren

2. **Orientierung:**
   - Ventilated Housing: Öffnung nach oben
   - Fan Shroud: Lüfterseite nach unten

3. **Support:**
   - Minimal Support für Überhänge
   - Tree Support für weniger Materialverbrauch

4. **Nachbearbeitung:**
   - Löcher auf Durchgängigkeit prüfen
   - Bei Bedarf mit Bohrer nacharbeiten
   - Kanten entgraten

## Wartung und Reinigung

- **Regelmäßige Reinigung**: Alle 3-6 Monate je nach Umgebung
- **Druckluft**: Zum Ausblasen von Staub aus den Kanälen
- **Filterwechsel**: Bei Filter-Mounts alle 1-3 Monate
- **Inspektion**: Auf Verstopfungen und Beschädigungen prüfen

## Weitere Optimierungen

Die OpenSCAD-Dateien sind vollständig parametrisch - alle Werte können einfach angepasst werden:

1. Datei in OpenSCAD öffnen
2. Parameter am Dateianfang ändern
3. F5 für Vorschau, F6 für finales Rendering
4. STL exportieren mit File > Export > Export as STL

So können Sie die Designs perfekt an Ihre spezifischen Anforderungen anpassen!