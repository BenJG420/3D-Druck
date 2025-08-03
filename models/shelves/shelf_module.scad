// ========================================
// Modulares 3D-Lagersystem - Regalmodul
// Optimiert für Bambu Lab P1S
// ========================================

include <../base/base_module.scad>

// Regal Parameter
shelf_length = base_length - 2*wall_thickness - 2;
shelf_width = base_width - 2*wall_thickness - 2;
shelf_module_height = 120;                     // Höhere Module für mehr Ebenen
shelf_thickness = 3;                           // Dicke der Regalböden
shelf_support_width = 8;                       // Breite der Stützen
shelf_support_thickness = 3;                   // Dicke der Stützen

// Verstellsystem Parameter
adjustment_slot_width = 4;                     // Breite der Verstellschlitze
adjustment_slot_height = 2;                    // Höhe der Verstellschlitze
adjustment_spacing = 10;                       // Abstand zwischen Verstellpunkten
min_shelf_height = 25;                         // Minimale Höhe zwischen Böden
max_shelf_height = 60;                         // Maximale Höhe zwischen Böden

// Befestigungsystem
shelf_pin_diameter = 3.8;                     // Durchmesser der Regalböden-Stifte
shelf_pin_length = 12;                        // Länge der Regalböden-Stifte
pin_hole_diameter = 4;                        // Durchmesser der Löcher für Stifte

// ========================================
// Regalgehäuse (erweitert die Basis)
// ========================================
module shelf_housing() {
    difference() {
        // Erweiterte Basis mit größerer Höhe
        scale([1, 1, shelf_module_height/base_height]) {
            base_module();
        }
        
        // Hauptfach aussparung
        translate([wall_thickness + 1, wall_thickness + 1, wall_thickness]) {
            cube([
                shelf_length, 
                shelf_width, 
                shelf_module_height - wall_thickness
            ]);
        }
        
        // Verstellschlitze für Regalböden
        adjustment_slots();
    }
    
    // Seitenstützen für Regale
    shelf_supports();
}

// ========================================
// Verstellbare Regalböden
// ========================================
module adjustable_shelf() {
    difference() {
        // Hauptregalboard
        rounded_box(shelf_length - 4, shelf_width - 4, shelf_thickness, 2);
        
        // Gewichtsreduzierung (optional)
        weight_reduction_holes();
    }
    
    // Befestigungsstifte
    shelf_mounting_pins();
}

// Regalboard mit festen Unterteilungen
module divided_shelf(x_dividers = 1, y_dividers = 1) {
    adjustable_shelf();
    
    // X-Unterteilungen
    for(i = [1:x_dividers]) {
        x_pos = (shelf_length - 4) * i / (x_dividers + 1);
        translate([x_pos - 0.75, 0, shelf_thickness]) {
            cube([1.5, shelf_width - 4, 15]);
        }
    }
    
    // Y-Unterteilungen  
    for(i = [1:y_dividers]) {
        y_pos = (shelf_width - 4) * i / (y_dividers + 1);
        translate([0, y_pos - 0.75, shelf_thickness]) {
            cube([shelf_length - 4, 1.5, 15]);
        }
    }
}

// ========================================
// Hilfsfunktionen Regalgehäuse
// ========================================

// Verstellschlitze an den Seitenwänden
module adjustment_slots() {
    slot_start_height = wall_thickness + min_shelf_height;
    slot_end_height = shelf_module_height - min_shelf_height;
    
    // Linke Seite
    for(z = [slot_start_height : adjustment_spacing : slot_end_height]) {
        for(y = [shelf_width/4 : shelf_width/4 : 3*shelf_width/4]) {
            translate([wall_thickness - 1, wall_thickness + 1 + y, z]) {
                rotate([0, 90, 0]) {
                    cylinder(h=adjustment_slot_width, d=pin_hole_diameter, $fn=16);
                }
            }
        }
    }
    
    // Rechte Seite
    for(z = [slot_start_height : adjustment_spacing : slot_end_height]) {
        for(y = [shelf_width/4 : shelf_width/4 : 3*shelf_width/4]) {
            translate([base_length - wall_thickness - adjustment_slot_width + 1, wall_thickness + 1 + y, z]) {
                rotate([0, 90, 0]) {
                    cylinder(h=adjustment_slot_width, d=pin_hole_diameter, $fn=16);
                }
            }
        }
    }
    
    // Vordere Seite
    for(z = [slot_start_height : adjustment_spacing : slot_end_height]) {
        for(x = [shelf_length/4 : shelf_length/4 : 3*shelf_length/4]) {
            translate([wall_thickness + 1 + x, wall_thickness - 1, z]) {
                rotate([90, 0, 0]) {
                    cylinder(h=adjustment_slot_width, d=pin_hole_diameter, $fn=16);
                }
            }
        }
    }
    
    // Hintere Seite
    for(z = [slot_start_height : adjustment_spacing : slot_end_height]) {
        for(x = [shelf_length/4 : shelf_length/4 : 3*shelf_length/4]) {
            translate([wall_thickness + 1 + x, base_width - wall_thickness - adjustment_slot_width + 1, z]) {
                rotate([90, 0, 0]) {
                    cylinder(h=adjustment_slot_width, d=pin_hole_diameter, $fn=16);
                }
            }
        }
    }
}

// Verstärkende Seitenstützen
module shelf_supports() {
    support_height = shelf_module_height - 2*wall_thickness;
    
    // Vertikale Eckstützen
    corner_positions = [
        [wall_thickness + 1, wall_thickness + 1],
        [base_length - wall_thickness - shelf_support_width - 1, wall_thickness + 1],
        [wall_thickness + 1, base_width - wall_thickness - shelf_support_width - 1],
        [base_length - wall_thickness - shelf_support_width - 1, base_width - wall_thickness - shelf_support_width - 1]
    ];
    
    for(pos = corner_positions) {
        translate([pos[0], pos[1], wall_thickness]) {
            cube([shelf_support_width, shelf_support_width, support_height]);
        }
    }
    
    // Mittlere Stützen bei längeren Regalen
    if(shelf_length > 180) {
        middle_x = base_length/2 - shelf_support_width/2;
        translate([middle_x, wall_thickness + 1, wall_thickness]) {
            cube([shelf_support_width, shelf_support_width, support_height]);
        }
        translate([middle_x, base_width - wall_thickness - shelf_support_width - 1, wall_thickness]) {
            cube([shelf_support_width, shelf_support_width, support_height]);
        }
    }
}

// ========================================
// Hilfsfunktionen Regalböden
// ========================================

// Befestigungsstifte für Regalböden
module shelf_mounting_pins() {
    pin_positions = [
        // Vordere Ecken
        [5, 5, 0],
        [shelf_length - 9, 5, 0],
        // Hintere Ecken
        [5, shelf_width - 9, 0],
        [shelf_length - 9, shelf_width - 9, 0],
        // Mittlere Punkte bei größeren Böden
        [shelf_length/2, 5, 0],
        [shelf_length/2, shelf_width - 9, 0]
    ];
    
    for(pos = pin_positions) {
        translate(pos) {
            cylinder(h=shelf_pin_length, d=shelf_pin_diameter, $fn=16);
        }
    }
}

// Gewichtsreduzierung durch Löcher
module weight_reduction_holes() {
    hole_diameter = 8;
    hole_spacing = 20;
    
    for(x = [hole_spacing : hole_spacing : shelf_length - hole_spacing - 4]) {
        for(y = [hole_spacing : hole_spacing : shelf_width - hole_spacing - 4]) {
            translate([x, y, -1]) {
                cylinder(h=shelf_thickness + 2, d=hole_diameter, $fn=16);
            }
        }
    }
}

// ========================================
// Spezielle Regalmodule
// ========================================

// Bücherregal mit Buchstützen
module bookshelf_module() {
    adjustable_shelf();
    
    // Buchstützen
    bookend_height = 40;
    bookend_thickness = 2;
    
    // Linke Buchstütze
    translate([0, 0, shelf_thickness]) {
        cube([bookend_thickness, shelf_width - 4, bookend_height]);
    }
    
    // Rechte Buchstütze
    translate([shelf_length - 4 - bookend_thickness, 0, shelf_thickness]) {
        cube([bookend_thickness, shelf_width - 4, bookend_height]);
    }
    
    // Mittlere Buchstützen (bei Bedarf)
    middle_positions = [shelf_length/3, 2*shelf_length/3];
    for(x = middle_positions) {
        translate([x - bookend_thickness/2, 0, shelf_thickness]) {
            cube([bookend_thickness, shelf_width - 4, bookend_height]);
        }
    }
}

// Flaschenregal
module bottle_rack() {
    adjustable_shelf();
    
    bottle_diameter = 25;
    bottle_spacing = 35;
    
    // Flaschenhalterungen
    for(x = [bottle_spacing/2 : bottle_spacing : shelf_length - bottle_spacing/2 - 4]) {
        for(y = [bottle_spacing/2 : bottle_spacing : shelf_width - bottle_spacing/2 - 4]) {
            translate([x, y, shelf_thickness]) {
                difference() {
                    cylinder(h=15, d=bottle_diameter + 4, $fn=24);
                    translate([0, 0, -1]) {
                        cylinder(h=17, d=bottle_diameter, $fn=24);
                    }
                    translate([0, 0, 8]) {
                        cube([bottle_diameter + 6, bottle_diameter/2, 10], center=true);
                    }
                }
            }
        }
    }
}

// ========================================
// Verbindungselemente
// ========================================

// Regalboden-Träger (separat druckbar)
module shelf_pin() {
    pin_head_diameter = 6;
    pin_head_thickness = 2;
    
    // Stift
    cylinder(h=shelf_pin_length, d=shelf_pin_diameter, $fn=16);
    
    // Kopf für besseren Halt
    translate([0, 0, shelf_pin_length]) {
        cylinder(h=pin_head_thickness, d=pin_head_diameter, $fn=16);
    }
}

// Verstellbare Stütze
module adjustable_support() {
    support_length = 30;
    support_width = 8;
    support_height = 20;
    
    difference() {
        cube([support_length, support_width, support_height]);
        
        // Verstellschlitz
        translate([5, support_width/2, support_height/2]) {
            rotate([0, 90, 0]) {
                cylinder(h=support_length - 10, d=pin_hole_diameter, $fn=16);
            }
        }
    }
}

// ========================================
// Beispiel-Konfigurationen
// ========================================

// Komplett-Regal mit 3 Ebenen
module complete_shelf_system() {
    shelf_housing();
    
    // Regalböden in verschiedenen Höhen
    color("lightgray", 0.8) {
        translate([wall_thickness + 3, wall_thickness + 3, 40]) {
            adjustable_shelf();
        }
        translate([wall_thickness + 3, wall_thickness + 3, 70]) {
            divided_shelf(2, 1);
        }
        translate([wall_thickness + 3, wall_thickness + 3, 100]) {
            bookshelf_module();
        }
    }
}

// Modular aufgebautes System
module modular_shelf_demo() {
    // Basis
    translate([0, 0, 0]) {
        complete_shelf_system();
    }
    
    // Zweite Ebene 
    translate([0, 0, shelf_module_height]) {
        color("lightblue", 0.7) {
            complete_shelf_system();
        }
    }
}

// ========================================
// Render (uncomment desired part)
// ========================================

// shelf_housing();              // Nur Gehäuse
// adjustable_shelf();           // Nur Regalboden
// divided_shelf(2, 2);          // Geteilter Regalboden
// bookshelf_module();           // Bücherregal
// bottle_rack();                // Flaschenregal
// shelf_pin();                  // Regalboden-Stift
// complete_shelf_system();      // Komplett-System
modular_shelf_demo();         // Modulare Demonstration