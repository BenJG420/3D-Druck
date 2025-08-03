// ========================================
// Modulares 3D-Lagersystem - Beispielkonfigurationen  
// Optimiert für Bambu Lab P1S
// ========================================

include <../models/base/base_module.scad>
include <../models/drawers/drawer_module.scad>
include <../models/shelves/shelf_module.scad>
include <../models/dividers/divider_system.scad>
include <../models/hardware/connection_hardware.scad>

// ========================================
// Konfiguration 1: Kleiner Werkstatt-Organizer
// ========================================
module workshop_organizer_small() {
    echo("=== Kleiner Werkstatt-Organizer ===");
    echo("- 1x Basismodul mit Unterteilungen");
    echo("- 1x Schubladenmodul");
    echo("- Werkzeug-spezifische Unterteilungen");
    
    // Basis mit Werkzeug-Unterteilungen
    translate([0, 0, 0]) {
        color("lightgray") base_module();
        color("red", 0.7) tool_organizer();
    }
    
    // Schubladenmodul darüber
    translate([0, 0, 50]) {
        color("lightblue", 0.8) drawer_housing();
        color("blue", 0.6) {
            translate([20, 0, 0]) drawer_with_dividers();
        }
    }
    
    // Verbindungshardware
    translate([20, 20, 50]) stacking_pin();
    translate([220, 20, 50]) stacking_pin();
    translate([20, 220, 50]) stacking_pin();
    translate([220, 220, 50]) stacking_pin();
}

// ========================================
// Konfiguration 2: Büro-Arbeitsplatz
// ========================================
module office_desktop_organizer() {
    echo("=== Büro-Arbeitsplatz Organizer ===");
    echo("- 2x Basismodule nebeneinander");
    echo("- 1x Regalmodul oben");
    echo("- Büro-spezifische Unterteilungen");
    
    // Linkes Basismodul mit Büro-Organizer
    translate([0, 0, 0]) {
        color("white") base_module();
        color("blue", 0.7) office_organizer();
    }
    
    // Rechtes Basismodul mit Elektronik-Organizer  
    translate([260, 0, 0]) {
        color("white") base_module();
        color("green", 0.7) electronics_organizer();
    }
    
    // Regalmodul über beiden (erfordert zusätzliche Stützen)
    translate([130, 0, 50]) {
        color("lightgray", 0.8) shelf_housing();
        // Drei Regalebenen
        translate([wall_thickness + 3, wall_thickness + 3, 40]) {
            color("brown", 0.7) adjustable_shelf();
        }
        translate([wall_thickness + 3, wall_thickness + 3, 70]) {
            color("brown", 0.7) divided_shelf(3, 1);
        }
        translate([wall_thickness + 3, wall_thickness + 3, 100]) {
            color("brown", 0.7) bookshelf_module();
        }
    }
    
    // Zusätzliche Verbindungselemente für Stabilität
    translate([240, 120, 25]) l_bracket();
    translate([280, 120, 25]) l_bracket();
}

// ========================================
// Konfiguration 3: Maximaler Turmaufbau
// ========================================
module maximum_tower_system() {
    echo("=== Maximaler Turmaufbau ===");
    echo("- 4 Module vertikal gestapelt");
    echo("- Verschiedene Modultypen");
    echo("- Maximaler Stauraum");
    
    // Basis: Basismodul mit Kleinteilemagazin
    translate([0, 0, 0]) {
        color("darkgray") base_module();
        color("red", 0.5) small_parts_divider();
    }
    
    // Zweite Ebene: Schubladenmodul
    translate([0, 0, 50]) {
        color("lightblue") drawer_housing();
        color("blue", 0.6) {
            translate([15, 0, 0]) drawer();
        }
    }
    
    // Dritte Ebene: Regalmodul
    translate([0, 0, 130]) {
        color("lightgreen") shelf_housing();
        translate([wall_thickness + 3, wall_thickness + 3, 30]) {
            color("green", 0.7) adjustable_shelf();
        }
        translate([wall_thickness + 3, wall_thickness + 3, 60]) {
            color("green", 0.7) bottle_rack();
        }
        translate([wall_thickness + 3, wall_thickness + 3, 90]) {
            color("green", 0.7) divided_shelf(2, 2);
        }
    }
    
    // Vierte Ebene: Weiteres Basismodul
    translate([0, 0, 250]) {
        color("lightyellow") base_module();
        color("orange", 0.7) advanced_divider_set();
    }
    
    // Stapelverbindungen zwischen allen Ebenen
    stacking_pins_set(50);   // Zwischen 1. und 2. Ebene
    stacking_pins_set(130);  // Zwischen 2. und 3. Ebene  
    stacking_pins_set(250);  // Zwischen 3. und 4. Ebene
}

// ========================================
// Konfiguration 4: Modulares L-System
// ========================================
module modular_l_system() {
    echo("=== Modulares L-System ===");
    echo("- L-förmige Anordnung");
    echo("- Verschiedene Höhen");
    echo("- Seitliche Verbindungen");
    
    // Haupt-Turm (3 Module hoch)
    translate([0, 0, 0]) {
        // Basis
        color("gray") base_module();
        color("red", 0.7) basic_divider_set();
        
        // Schubladen-Ebene
        translate([0, 0, 50]) {
            color("lightblue") drawer_housing();
            color("blue", 0.6) {
                translate([10, 0, 0]) drawer_with_dividers();
            }
        }
        
        // Regal-Ebene
        translate([0, 0, 130]) {
            color("lightgreen") shelf_housing();
            translate([wall_thickness + 3, wall_thickness + 3, 40]) {
                color("green", 0.7) adjustable_shelf();
            }
            translate([wall_thickness + 3, wall_thickness + 3, 80]) {
                color("green", 0.7) bookshelf_module();
            }
        }
    }
    
    // Seitlicher Arm (2 Module hoch)
    translate([260, 0, 0]) {
        // Basis
        color("gray") base_module();
        color("blue", 0.7) electronics_organizer();
        
        // Schubladen-Ebene
        translate([0, 0, 50]) {
            color("lightblue") drawer_housing();
            color("blue", 0.6) {
                translate([15, 0, 0]) drawer();
            }
        }
    }
    
    // Seitlicher Arm rückwärtig (1 Modul)
    translate([0, 260, 0]) {
        color("lightyellow") base_module();
        color("orange", 0.7) office_organizer();
    }
    
    // Verbindungselemente für L-Form
    translate([240, 120, 25]) {
        rotate([0, 0, 90]) t_connector();
    }
    translate([120, 240, 25]) {
        t_connector();
    }
}

// ========================================
// Konfiguration 5: Spezialisierte Arbeitsplätze
// ========================================

// 3D-Druck Workshop Setup
module workshop_3d_printing() {
    echo("=== 3D-Druck Workshop ===");
    echo("- Filament-Regal");
    echo("- Werkzeug-Schubladen");
    echo("- Kleinteile-Organisation");
    
    // Filament-Regal (hoch)
    translate([0, 0, 0]) {
        color("darkblue") shelf_housing();
        // Speziell für Filament-Spulen
        for(z = [30:40:110]) {
            translate([wall_thickness + 3, wall_thickness + 3, z]) {
                color("blue", 0.7) adjustable_shelf();
            }
        }
    }
    
    // Werkzeug-Schubladen
    translate([260, 0, 0]) {
        color("red") drawer_housing();
        color("darkred", 0.8) {
            translate([10, 0, 0]) {
                drawer();
                // Spezielle Werkzeug-Unterteilungen
                drawer_divider_x(drawer_length/4);
                drawer_divider_x(3*drawer_length/4);
                drawer_divider_y(drawer_width/3);
                drawer_divider_y(2*drawer_width/3);
            }
        }
    }
    
    // Kleinteile (Schrauben, Muttern, etc.)
    translate([520, 0, 0]) {
        color("green") base_module();
        color("lightgreen", 0.7) small_parts_divider();
    }
}

// Elektronik-Labor Setup
module workshop_electronics() {
    echo("=== Elektronik-Labor ===");
    echo("- Bauteil-Organisation");
    echo("- Werkzeug-Management");
    echo("- Kabel-Verwaltung");
    
    // Haupt-Arbeitsbereich
    translate([0, 0, 0]) {
        color("darkgreen") base_module();
        color("green", 0.7) electronics_organizer();
    }
    
    // Bauteil-Regal
    translate([0, 0, 50]) {
        color("lightgreen") shelf_housing();
        // Viele kleine Fächer für Bauteile
        for(z = [25:25:100]) {
            translate([wall_thickness + 3, wall_thickness + 3, z]) {
                color("green", 0.6) divided_shelf(4, 6);
            }
        }
    }
    
    // Werkzeug-Schubladen
    translate([260, 0, 0]) {
        color("blue") drawer_housing();
        color("lightblue", 0.8) {
            translate([8, 0, 0]) {
                drawer();
                // Spezifische Elektronik-Werkzeug-Aufteilung
                for(i = [1:5]) {
                    drawer_divider_x(drawer_length * i/6);
                }
                drawer_divider_y(drawer_width * 0.3);
                drawer_divider_y(drawer_width * 0.7);
            }
        }
    }
}

// ========================================
// Hilfsfunktionen
// ========================================

// Stapelstifte-Set an bestimmter Höhe
module stacking_pins_set(z_height) {
    pin_positions = [
        [20, 20, z_height],
        [220, 20, z_height],
        [20, 220, z_height], 
        [220, 220, z_height]
    ];
    
    for(pos = pin_positions) {
        translate(pos) {
            color("gray") stacking_pin();
        }
    }
}

// Verbindungsschrauben-Set
module connection_screws_set(z_height, screw_type="standard") {
    screw_positions = [
        [30, 30, z_height],
        [210, 30, z_height],
        [30, 210, z_height],
        [210, 210, z_height],
        [120, 30, z_height],
        [120, 210, z_height],
        [30, 120, z_height],
        [210, 120, z_height]
    ];
    
    for(pos = screw_positions) {
        translate(pos) {
            if(screw_type == "standard") {
                color("silver") connection_screw();
            } else if(screw_type == "long") {
                color("silver") {
                    scale([1, 1, 1.5]) connection_screw();
                }
            }
        }
    }
}

// ========================================
// Demonstrations-Layout
// ========================================

// Alle Konfigurationen in einer Übersicht
module all_configurations_demo() {
    echo("=== Alle Konfigurationen Demo ===");
    
    // Konfiguration 1: Klein
    translate([0, 0, 0]) {
        workshop_organizer_small();
    }
    
    // Konfiguration 2: Büro (daneben)
    translate([600, 0, 0]) {
        office_desktop_organizer();
    }
    
    // Konfiguration 3: Turm (dahinter)
    translate([0, 600, 0]) {
        maximum_tower_system();
    }
    
    // Konfiguration 4: L-System (diagonal)
    translate([600, 600, 0]) {
        modular_l_system();
    }
    
    // Konfiguration 5: Workshops (vorne)
    translate([0, -400, 0]) {
        workshop_3d_printing();
    }
    
    translate([800, -400, 0]) {
        workshop_electronics();
    }
}

// Einzelne Konfiguration für Tests
module single_configuration_demo() {
    // Wähle eine Konfiguration zum Testen:
    modular_l_system();
    
    // Alternativ andere Konfigurationen:
    // workshop_organizer_small();
    // office_desktop_organizer();  
    // maximum_tower_system();
    // workshop_3d_printing();
    // workshop_electronics();
}

// ========================================
// Render (uncomment desired demo)
// ========================================

// Einzelne Konfiguration (zum Testen)
single_configuration_demo();

// Alle Konfigurationen (Übersicht)
// all_configurations_demo();

// Spezifische Konfiguration
// workshop_organizer_small();
// office_desktop_organizer();
// maximum_tower_system();
// modular_l_system();
// workshop_3d_printing();
// workshop_electronics();