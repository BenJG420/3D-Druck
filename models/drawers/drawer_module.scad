// ========================================
// Modulares 3D-Lagersystem - Schubladenmodul
// Optimiert für Bambu Lab P1S
// ========================================

include <../base/base_module.scad>

// Schubladen Parameter
drawer_length = base_length - 2*wall_thickness - 4;  // Platz für Führung
drawer_width = base_width - 2*wall_thickness - 4;    // Platz für Führung
drawer_height = 35;                                   // Höhe der Schublade
drawer_wall_thickness = 2;                            // Wandstärke Schublade

// Führungsschienen Parameter
rail_width = 8;                    // Breite der Führungsschiene
rail_height = 6;                   // Höhe der Führungsschiene
rail_clearance = 0.3;              // Spiel zwischen Schiene und Führung
bearing_slot_width = 2;            // Breite für Kugellager-Führung
bearing_slot_depth = 1;            // Tiefe für Kugellager-Führung

// Griff Parameter
handle_width = 80;                 // Breite des Griffs
handle_height = 15;                // Höhe des Griffs
handle_depth = 8;                  // Tiefe des Griffs
handle_thickness = 2;              // Wandstärke des Griffs

// ========================================
// Schubladengehäuse (erweitert die Basis)
// ========================================
module drawer_housing() {
    difference() {
        // Basis Modul
        base_module();
        
        // Schubladenöffnung
        translate([wall_thickness + 2, wall_thickness + 2, wall_thickness]) {
            cube([
                drawer_length + 2, 
                drawer_width + 2, 
                drawer_height + 5
            ]);
        }
        
        // Führungsschlitze
        drawer_rail_slots();
    }
    
    // Führungsschienen
    drawer_rails();
    
    // Endanschläge
    drawer_stops();
}

// ========================================
// Schublade
// ========================================
module drawer() {
    difference() {
        union() {
            // Schubladenkörper
            drawer_body();
            
            // Griff
            drawer_handle();
            
            // Führungsnocken
            drawer_guides();
        }
        
        // Innenraum
        translate([drawer_wall_thickness, drawer_wall_thickness, drawer_wall_thickness]) {
            cube([
                drawer_length - 2*drawer_wall_thickness,
                drawer_width - 2*drawer_wall_thickness, 
                drawer_height
            ]);
        }
        
        // Grifföffnung
        handle_cutout();
    }
}

// ========================================
// Hilfsfunktionen Schubladengehäuse
// ========================================

// Führungsschienen
module drawer_rails() {
    rail_y_positions = [
        wall_thickness + 2 + rail_width/2,
        base_width - wall_thickness - 2 - rail_width/2
    ];
    
    for(y = rail_y_positions) {
        translate([wall_thickness + 2, y - rail_width/2, wall_thickness + drawer_height/2]) {
            rail_with_bearing_track();
        }
    }
}

// Führungsschiene mit Kugellager-Spur
module rail_with_bearing_track() {
    difference() {
        // Grundschiene
        cube([drawer_length, rail_width, rail_height]);
        
        // Kugellager-Spur
        translate([5, rail_width/2 - bearing_slot_width/2, rail_height - bearing_slot_depth]) {
            cube([drawer_length - 10, bearing_slot_width, bearing_slot_depth + 1]);
        }
        
        // Seitliche Führungsschlitze
        translate([5, -1, rail_height/2 - 0.5]) {
            cube([drawer_length - 10, 1.5, 1]);
        }
        translate([5, rail_width - 0.5, rail_height/2 - 0.5]) {
            cube([drawer_length - 10, 1.5, 1]);
        }
    }
}

// Schlitze für die Führungsschienen
module drawer_rail_slots() {
    rail_y_positions = [
        wall_thickness + 2 + rail_width/2,
        base_width - wall_thickness - 2 - rail_width/2
    ];
    
    for(y = rail_y_positions) {
        translate([wall_thickness + 1, y - rail_width/2 - rail_clearance, wall_thickness + drawer_height/2]) {
            cube([drawer_length + 2, rail_width + 2*rail_clearance, rail_height + rail_clearance]);
        }
    }
}

// Endanschläge
module drawer_stops() {
    stop_thickness = 3;
    stop_height = drawer_height/2;
    
    // Vorderer Anschlag
    translate([wall_thickness + 2 + drawer_length - stop_thickness, wall_thickness + 2, wall_thickness]) {
        cube([stop_thickness, drawer_width, stop_height]);
    }
    
    // Hinterer Anschlag  
    translate([wall_thickness + 2, wall_thickness + 2, wall_thickness]) {
        cube([stop_thickness, drawer_width, stop_height]);
    }
}

// ========================================
// Hilfsfunktionen Schublade
// ========================================

// Schubladenkörper
module drawer_body() {
    rounded_box(drawer_length, drawer_width, drawer_height, 2);
}

// Schubladengriff
module drawer_handle() {
    translate([drawer_length - handle_depth, drawer_width/2 - handle_width/2, drawer_height]) {
        difference() {
            // Griff-Körper
            rounded_box(handle_depth, handle_width, handle_height, 2);
            
            // Griffmulde
            translate([handle_thickness, handle_thickness, handle_thickness]) {
                rounded_box(
                    handle_depth, 
                    handle_width - 2*handle_thickness, 
                    handle_height, 
                    1
                );
            }
        }
    }
}

// Führungsnocken für die Schiene
module drawer_guides() {
    guide_height = rail_height - rail_clearance;
    guide_length = drawer_length - 20;
    
    rail_y_positions = [
        rail_width/2,
        drawer_width - rail_width/2
    ];
    
    for(y = rail_y_positions) {
        translate([10, y - rail_width/2 + rail_clearance, drawer_height/2]) {
            difference() {
                // Führungsnocken
                cube([guide_length, rail_width - 2*rail_clearance, guide_height]);
                
                // Kleine Kerbe für besseres Gleiten
                translate([guide_length/2 - 10, rail_width/2 - 0.5, -1]) {
                    cube([20, 1, guide_height + 2]);
                }
            }
        }
    }
    
    // Seitliche Führungselemente
    for(y = rail_y_positions) {
        translate([10, y, drawer_height/2 + guide_height/2]) {
            rotate([0, 90, 0]) {
                cylinder(h=guide_length, d=1.5, $fn=12);
            }
        }
    }
}

// Grifföffnung
module handle_cutout() {
    translate([drawer_length - handle_depth + 1, drawer_width/2 - handle_width/2 + handle_thickness, drawer_height + handle_thickness]) {
        cube([
            handle_depth, 
            handle_width - 2*handle_thickness, 
            handle_height - handle_thickness
        ]);
    }
}

// ========================================
// Unterteilungen für die Schublade
// ========================================
module drawer_divider_x(position, height = drawer_height - drawer_wall_thickness - 2) {
    divider_thickness = 1.5;
    
    translate([position - divider_thickness/2, drawer_wall_thickness, drawer_wall_thickness]) {
        cube([
            divider_thickness, 
            drawer_width - 2*drawer_wall_thickness, 
            height
        ]);
    }
}

module drawer_divider_y(position, height = drawer_height - drawer_wall_thickness - 2) {
    divider_thickness = 1.5;
    
    translate([drawer_wall_thickness, position - divider_thickness/2, drawer_wall_thickness]) {
        cube([
            drawer_length - 2*drawer_wall_thickness, 
            divider_thickness, 
            height
        ]);
    }
}

// ========================================
// Beispiel-Konfigurationen
// ========================================

// Komplett-Set: Gehäuse + Schublade
module drawer_complete_set() {
    drawer_housing();
    
    // Schublade leicht herausgezogen für Darstellung
    translate([0, 0, 0]) {
        color("lightblue", 0.8) {
            translate([20, 0, 0]) {
                drawer();
            }
        }
    }
}

// Schublade mit Unterteilungen (Beispiel)
module drawer_with_dividers() {
    drawer();
    
    // Beispiel-Unterteilungen
    drawer_divider_x(drawer_length/3);
    drawer_divider_x(2*drawer_length/3);
    drawer_divider_y(drawer_width/2);
}

// ========================================
// Render (uncomment desired part)
// ========================================

// drawer_housing();          // Nur Gehäuse
// drawer();                  // Nur Schublade
// drawer_complete_set();     // Komplett-Set
drawer_with_dividers();    // Schublade mit Unterteilungen