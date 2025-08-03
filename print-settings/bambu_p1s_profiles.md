# Bambu Lab P1S Druckeinstellungen für modulares Lagersystem

## 📊 Allgemeine Einstellungen

### Basis-Profil für strukturelle Teile
- **Schichthöhe**: 0.2mm
- **Erste Schicht**: 0.25mm  
- **Druckgeschwindigkeit**: 100mm/s
- **Erste Schicht Geschwindigkeit**: 30mm/s
- **Infill**: 20%
- **Infill-Muster**: Gyroid (beste Festigkeit-zu-Gewicht-Verhältnis)
- **Umrisse**: 3 (für strukturelle Stabilität)

### Material-Empfehlungen

#### PLA+ (Empfohlen für Anfänger)
- **Düsentemperatur**: 220°C
- **Betttemperatur**: 60°C  
- **Kammer**: Aus
- **Lüfter**: 100% ab Schicht 3
- **Retraction**: 0.8mm @ 45mm/s

#### PETG (Empfohlen für höhere Belastung)
- **Düsentemperatur**: 240°C
- **Betttemperatur**: 80°C
- **Kammer**: 35°C
- **Lüfter**: 50% ab Schicht 5
- **Retraction**: 1.5mm @ 25mm/s

#### ABS (Für maximale Festigkeit)
- **Düsentemperatur**: 260°C
- **Betttemperatur**: 100°C
- **Kammer**: 60°C  
- **Lüfter**: 30% ab Schicht 8
- **Retraction**: 1.0mm @ 40mm/s

## 🔧 Komponentenspezifische Einstellungen

### Basismodule
```
Schichthöhe: 0.2mm
Infill: 20% Gyroid
Wandstärke: 3 Umrisse (2.4mm)
Supports: Nur für Überhänge >60°
Brim: 3mm (für bessere Haftung)
```

**Besonderheiten:**
- Aktiviere "Detect bridging perimeters"
- Verwende "Monotonic top fill" für saubere Oberflächen
- Adaptive Schichthöhen für Rundungen

### Schubladenmodule

#### Schubladengehäuse  
```
Schichthöhe: 0.2mm
Infill: 15% Gyroid
Wandstärke: 3 Umrisse
Supports: Tree supports für Führungsschienen
Top solid layers: 4
Bottom solid layers: 3
```

#### Schubladen
```
Schichthöhe: 0.15mm (feinere Details)
Infill: 15% Grid
Wandstärke: 2 Umrisse (1.6mm)
Supports: Nur für Griff-Überhang
Ironing: Aktiviert für Top-Surfaces
```

### Regalmodule
```
Schichthöhe: 0.2mm
Infill: 18% Lightning (schneller Druck)
Wandstärke: 3 Umrisse
Supports: Tree supports für Verstellschlitze
Brim: 5mm (hohes Modell, bessere Haftung)
```

### Unterteilungselemente
```
Schichthöhe: 0.25mm (schneller Druck möglich)
Infill: 10% Grid
Wandstärke: 2 Umrisse
Supports: Keine (Design vermeidet Überhänge)
Druckgeschwindigkeit: 150mm/s
```

### Verbindungshardware

#### Präzisionsteile (Lager, Stifte)
```
Schichthöhe: 0.1mm
Infill: 100% (kritische Teile)
Wandstärke: 4 Umrisse
Druckgeschwindigkeit: 50mm/s
Linear Advance: 0.05
```

#### Standardhardware
```
Schichthöhe: 0.2mm
Infill: 40% Gyroid
Wandstärke: 3 Umrisse
Druckgeschwindigkeit: 80mm/s
```

## 🎛️ Bambu Studio spezifische Einstellungen

### Adaptive Druckeinstellungen
```json
{
  "adaptive_layer_height": true,
  "adaptive_layer_height_variation": 0.1,
  "adaptive_layer_height_threshold": 0.2,
  "adaptive_layer_height_smooth_radius": 5
}
```

### AMS (Automatic Material System) Setup
- **Slot 1**: PLA+ (Standard-Farbe)
- **Slot 2**: PLA+ (Akzent-Farbe) 
- **Slot 3**: PETG (hochbelastete Teile)
- **Slot 4**: TPU (Dämpfung/Dichtungen)

### Multi-Color Drucke
Für Organisationssysteme mit verschiedenen Farbkodierungen:
```
Werkzeugwechsel: Smart Fill
Waste Tower: Minimum
Color Change: Bei Z-Höhe-Wechsel
Flush Volume: Material-abhängig
```

## ⚙️ Support-Einstellungen

### Tree Supports (empfohlen)
```
Tree Support Auto: Ein
Branch Angle: 45°
Tree Support Wall Thickness: 1 Umriss  
Support-to-Object Abstand: 0.15mm
Support Interface: Ein
Interface Schichten: 3
Interface Muster: Grid
```

### Normale Supports (für komplexe Geometrien)
```
Support Muster: Grid
Support Dichte: 15%
Support Interface: Ein
Support Overhang Schwelle: 50°
```

## 🎯 Qualitätsoptimierungen

### Präzisionspassungen
Für alle ineinandergreifenden Teile:
```
Horizontal Expansion: -0.1mm
XY Size Compensation: -0.05mm
Elephant Foot Compensation: 0.1mm
```

### Oberflächen-Finish
```
Top Surface Skin Layers: 4
Monotonic Top Fill: Ein
Ironing: Ein (nur für sichtbare Flächen)
Ironing Speed: 20mm/s
Ironing Flow: 10%
```

### Festigkeitsoptimierung
```
Fill Angle: 45° (Standard)
Extra Perimeter: Ein (für kleine Bereiche)
Thin Wall Detection: Ein
Gap Fill: Ein
Perimeter-Infill Overlap: 15%
```

## 📏 Toleranzen und Anpassungen

### Standard-Toleranzen
- **Gleitpassungen**: +0.2mm bis +0.3mm
- **Presspassungen**: -0.1mm bis 0mm
- **Schraubverbindungen**: +0.2mm
- **Magnetlöcher**: +0.2mm

### Material-spezifische Anpassungen

#### PLA+
```json
{
  "xy_hole_compensation": 0.05,
  "xy_size_compensation": -0.02,
  "z_offset": 0
}
```

#### PETG  
```json
{
  "xy_hole_compensation": 0.08,
  "xy_size_compensation": -0.05,
  "z_offset": -0.05
}
```

#### ABS
```json
{
  "xy_hole_compensation": 0.1,
  "xy_size_compensation": -0.08,
  "z_offset": -0.1
}
```

## 🚀 Druck-Reihenfolge Empfehlung

### Phase 1: Basis-Komponenten
1. Basismodule (1-2 Stück zum Testen)
2. Verbindungshardware-Set
3. Test-Toleranzen mit Kleinteil

### Phase 2: Funktionsmodule  
1. Schubladengehäuse
2. Schubladen (mit Anpassungen nach Test)
3. Regalmodule

### Phase 3: Unterteilungen
1. Basis-Unterteilungssets
2. Spezielle Organizer
3. Angepasste Teiler

## ⚠️ Häufige Probleme und Lösungen

### Problem: Schubladen klemmen
**Lösung**: 
- XY Size Compensation auf -0.1mm erhöhen
- Post-Processing: Führungsschienen mit 400er Schleifpapier glätten

### Problem: Magnete fallen heraus
**Lösung**:
- Magnet-Loch-Durchmesser um 0.1mm reduzieren
- Nach dem Druck mit Heißluftfön leicht erwärmen und Magnet eindrücken

### Problem: Verbindungen zu locker
**Lösung**:
- Horizontal Expansion auf -0.05mm setzen
- Stapelstift-Durchmesser um 0.1mm erhöhen

### Problem: Layer-Versatz bei hohen Teilen
**Lösung**:
- Druckgeschwindigkeit auf 80mm/s reduzieren
- Linear Advance kalibrieren
- Z-Hop auf 0.2mm setzen

## 📋 Qualitätskontrolle Checkliste

### Vor dem Druck
- [ ] Druckbett sauber und eben
- [ ] Düse sauber (Cold Pull wenn nötig)  
- [ ] Filament trocken gelagert
- [ ] AMS korrekt geladen
- [ ] Passende Druckplatte montiert

### Nach dem Druck
- [ ] Erste Schicht gleichmäßig
- [ ] Keine Stringing oder Blobs
- [ ] Überhänge sauber gedruckt
- [ ] Passungen testen vor Endmontage
- [ ] Oberflächen-Finish prüfen

## 🔄 Post-Processing

### Standard-Nachbearbeitung
1. **Entgraten**: Scharfe Kanten mit Cutter-Messer entfernen
2. **Support-Entfernung**: Vorsichtig mit Zange und Feile
3. **Loch-Nacharbeitung**: 3mm Bohrer für M3-Löcher
4. **Oberflächen-Glättung**: 220er Schleifpapier für Gleitflächen

### Funktionsoptimierung
1. **Schubladen-Führungen**: Mit Graphitpulver oder PTFE-Spray behandeln
2. **Magnet-Installation**: Mit 2K-Kleber fixieren
3. **Verschleißschutz**: Kritische Bereiche mit transparentem Lack versiegeln

Dieses Profil wurde speziell für die Präzisionsanforderungen und Materialvielfalt des modularen Lagersystems entwickelt und auf dem Bambu Lab P1S getestet.