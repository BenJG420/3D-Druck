// ========================================
// Modulares 3D-Lagersystem - Unterteilungssystem
// Optimiert für Bambu Lab P1S
// ========================================

include <../base/base_module.scad>

// Unterteilungs-Parameter
divider_thickness = 1.5;                  // Standarddicke der Trennwände
divider_base_height = 5;                   // Höhe der Basis für Stabilität
divider_standard_height = 30;              // Standard-Höhe der Unterteilungen
divider_tolerance = 0.2;                   // Toleranz für Passform

// Klicksystem Parameter
clip_width = 6;                            // Breite der Klick-Verbindungen
clip_height = 3;                           // Höhe der Klick-Verbindungen
clip_depth = 2;                            // Tiefe der Klick-Verbindungen
clip_tolerance = 0.15;                     // Toleranz für Klick-Passform

// Modular-Raster Parameter
grid_size = 20;                            // Grundraster für modulare Aufteilung
min_compartment_size = 40;                 // Minimale Fachgröße

// ========================================
// Basis-Unterteilungselemente
// ========================================

// Universeller Teiler (anpassbare Länge)
module universal_divider(length, height = divider_standard_height, with_clips = true) {
    difference() {
        union() {
            // Hauptkörper
            cube([length, divider_thickness, height]);
            
            // Stabilisierende Basis
            cube([length, divider_thickness + 2, divider_base_height]);
            
            // Klick-Verbindungen
            if(with_clips) {
                divider_clips(length, height);
            }
        }
        
        // Gewichtsreduzierung bei größeren Teilern
        if(length > 60) {
            weight_reduction_cutouts(length, height);
        }
    }
}

// X-Richtung Teiler (passend für Basismodule)
module x_divider(position_fraction = 0.5, height = divider_standard_height) {
    length = base_width - 2*wall_thickness - 2*divider_tolerance;
    
    translate([
        (base_length - 2*wall_thickness) * position_fraction - divider_thickness/2,
        wall_thickness + divider_tolerance,
        wall_thickness
    ]) {
        universal_divider(length, height);
    }
}

// Y-Richtung Teiler (passend für Basismodule)  
module y_divider(position_fraction = 0.5, height = divider_standard_height) {
    length = base_length - 2*wall_thickness - 2*divider_tolerance;
    
    translate([
        wall_thickness + divider_tolerance,
        (base_width - 2*wall_thickness) * position_fraction - divider_thickness/2,
        wall_thickness
    ]) {
        rotate([0, 0, 90]) {
            universal_divider(length, height);
        }
    }
}

// ========================================
// Klick-Verbindungssystem
// ========================================

// Klick-Verbindungen für Teiler
module divider_clips(length, height) {
    clip_spacing = length/4;
    
    // Obere Klips
    for(x = [clip_spacing : clip_spacing : length - clip_spacing]) {
        translate([x - clip_width/2, divider_thickness, height - clip_height]) {
            clip_male();
        }
    }
    
    // Seitliche Klips
    translate([0, divider_thickness, height/2 - clip_height/2]) {
        rotate([0, 0, -90]) {
            clip_male();
        }
    }
    translate([length, divider_thickness, height/2 - clip_height/2]) {
        rotate([0, 0, 90]) {
            clip_male();
        }
    }
}

// Männlicher Klick-Verbinder
module clip_male() {
    clip_taper = 0.5;
    
    hull() {
        cube([clip_width, clip_depth, clip_height]);
        translate([clip_taper, 0, clip_taper]) {
            cube([clip_width - 2*clip_taper, clip_depth, clip_height - 2*clip_taper]);
        }
    }
}

// Weiblicher Klick-Verbinder (Aussparung)
module clip_female() {
    translate([-clip_tolerance, -clip_tolerance, -clip_tolerance]) {
        cube([
            clip_width + 2*clip_tolerance, 
            clip_depth + clip_tolerance, 
            clip_height + 2*clip_tolerance
        ]);
    }
}

// ========================================
// Spezielle Unterteilungssysteme
// ========================================

// Kleinteilemagazin (viele kleine Fächer)
module small_parts_divider() {
    compartment_size = min_compartment_size;
    x_divisions = floor((base_length - 2*wall_thickness) / compartment_size);
    y_divisions = floor((base_width - 2*wall_thickness) / compartment_size);
    
    // X-Teiler
    for(i = [1 : x_divisions-1]) {
        x_divider(i/x_divisions);
    }
    
    // Y-Teiler
    for(i = [1 : y_divisions-1]) {
        y_divider(i/y_divisions);
    }
}

// Werkzeugorganizer mit verschiedenen Fachgrößen
module tool_organizer() {
    // Große Fächer für größere Werkzeuge
    x_divider(0.3);
    x_divider(0.7);
    
    // Unterteilungen im linken Bereich für kleine Werkzeuge
    translate([0, 0, 0]) {
        for(i = [1:3]) {
            y_divider(0.3 * i/3);
        }
    }
    
    // Mittlerer Bereich bleibt frei für längere Werkzeuge
    
    // Rechter Bereich mit mittleren Fächern
    translate([0, 0, 0]) {
        for(i = [1:2]) {
            translate([
                (base_length - 2*wall_thickness) * 0.7,
                (base_width - 2*wall_thickness) * i/3,
                wall_thickness
            ]) {
                rotate([0, 0, 90]) {
                    universal_divider(
                        (base_width - 2*wall_thickness) * 0.3,
                        divider_standard_height
                    );
                }
            }
        }
    }
}

// Elektronik-Organizer 
module electronics_organizer() {
    // Kabelfach (schmal und lang)
    y_divider(0.15);
    
    // Hauptbereich unterteilt
    x_divider(0.4);
    x_divider(0.75);
    
    // Kleinteile-Bereich
    translate([0, 0, 0]) {
        for(i = [1:4]) {
            translate([
                wall_thickness + divider_tolerance,
                (base_width - 2*wall_thickness) * 0.15 + (base_width - 2*wall_thickness) * 0.85 * i/5,
                wall_thickness
            ]) {
                universal_divider(
                    (base_length - 2*wall_thickness) * 0.4 - 2*divider_tolerance,
                    divider_standard_height * 0.7
                );
            }
        }
    }
}

// ========================================
// Verstellbare und modulare Systeme
// ========================================

// Verstellbarer Teiler mit Führungsschiene
module adjustable_divider() {
    guide_length = base_length - 2*wall_thickness - 4;
    guide_width = 4;
    guide_height = 2;
    
    difference() {
        universal_divider(guide_length, divider_standard_height, false);
        
        // Führungsschlitz
        translate([5, -guide_width/2, divider_base_height]) {
            cube([guide_length - 10, guide_width, guide_height]);
        }
    }
    
    // Führungsschiene (wird an Basis befestigt)
    translate([5, divider_thickness + 2, wall_thickness]) {
        cube([guide_length - 10, guide_width - divider_tolerance, guide_height - divider_tolerance]);
    }
}

// Modulare Steckteiler
module modular_divider_piece(length_units = 2, height_units = 1) {
    length = length_units * grid_size;
    height = height_units * grid_size;
    
    difference() {
        universal_divider(length, height);
        
        // Steckverbindungen (weiblich)
        for(side = [[0, 0, 0], [length, 0, 180]]) {
            translate([side[0], divider_thickness/2, height/2]) {
                rotate([0, 0, side[2]]) {
                    translate([0, divider_thickness/2, 0]) {
                        modular_connector_female();
                    }
                }
            }
        }
    }
    
    // Steckverbindungen (männlich)
    for(side = [[0, -divider_thickness, 0], [length, -divider_thickness, 180]]) {
        translate([side[0], divider_thickness/2, height/2]) {
            rotate([0, 0, side[2]]) {
                translate([0, -divider_thickness/2, 0]) {
                    modular_connector_male();
                }
            }
        }
    }
}

// Steckverbinder männlich
module modular_connector_male() {
    connector_width = 8;
    connector_height = 6;
    connector_depth = 3;
    
    translate([-connector_width/2, 0, -connector_height/2]) {
        hull() {
            cube([connector_width, connector_depth, connector_height]);
            translate([1, 0, 1]) {
                cube([connector_width-2, connector_depth, connector_height-2]);
            }
        }
    }
}

// Steckverbinder weiblich
module modular_connector_female() {
    connector_width = 8.5;  // Etwas größer für Toleranz
    connector_height = 6.5;
    connector_depth = 3.5;
    
    translate([-connector_width/2, -connector_depth, -connector_height/2]) {
        cube([connector_width, connector_depth, connector_height]);
    }
}

// ========================================
// Hilfsfunktionen
// ========================================

// Gewichtsreduzierung bei großen Teilern
module weight_reduction_cutouts(length, height) {
    cutout_width = 8;
    cutout_height = 12;
    cutout_spacing = 20;
    
    start_x = cutout_spacing;
    end_x = length - cutout_spacing;
    
    for(x = [start_x : cutout_spacing : end_x]) {
        translate([x - cutout_width/2, -1, height/2 - cutout_height/2]) {
            cube([cutout_width, divider_thickness + 2, cutout_height]);
        }
    }
}

// ========================================
// Anpassbare Unterteilungssets
// ========================================

// Basisset für allgemeine Nutzung
module basic_divider_set() {
    x_divider(0.33);
    x_divider(0.66);
    y_divider(0.5);
}

// Erweiterte Unterteilung
module advanced_divider_set() {
    x_divider(0.25);
    x_divider(0.5);
    x_divider(0.75);
    y_divider(0.33);
    y_divider(0.66);
}

// Büro-Organizer
module office_organizer() {
    // Stifthalter-Bereich
    x_divider(0.2);
    
    // Dokumentenfächer
    for(i = [1:3]) {
        y_divider(0.2 + 0.8 * i/4);
    }
    
    // Kleinteile-Bereich
    translate([
        (base_length - 2*wall_thickness) * 0.2 + divider_thickness,
        wall_thickness + divider_tolerance,
        wall_thickness
    ]) {
        for(i = [1:2]) {
            translate([
                (base_length - 2*wall_thickness) * 0.8 * i/3,
                0,
                0
            ]) {
                rotate([0, 0, 90]) {
                    universal_divider(
                        base_width - 2*wall_thickness - 2*divider_tolerance,
                        divider_standard_height * 0.6
                    );
                }
            }
        }
    }
}

// ========================================
// Beispiel-Konfigurationen
// ========================================

// Verschiedene Organisationssysteme zeigen
module divider_showcase() {
    translate([0, 0, 0]) {
        color("red", 0.7) basic_divider_set();
    }
    
    translate([280, 0, 0]) {
        color("blue", 0.7) tool_organizer();
    }
    
    translate([0, 280, 0]) {
        color("green", 0.7) electronics_organizer();
    }
    
    translate([280, 280, 0]) {
        color("orange", 0.7) office_organizer();
    }
}

// ========================================
// Render (uncomment desired part)
// ========================================

// universal_divider(200);           // Universeller Teiler
// basic_divider_set();              // Basis-Set
// small_parts_divider();            // Kleinteilemagazin
// tool_organizer();                 // Werkzeug-Organizer
// electronics_organizer();          // Elektronik-Organizer
// office_organizer();               // Büro-Organizer
// adjustable_divider();             // Verstellbarer Teiler
// modular_divider_piece(3, 2);      // Modularer Teiler
divider_showcase();               // Übersicht aller Systeme