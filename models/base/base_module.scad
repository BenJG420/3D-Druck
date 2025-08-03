// ========================================
// Modulares 3D-Lagersystem - Basis Modul
// Optimiert für Bambu Lab P1S (256x256x256mm)
// ========================================

// Globale Parameter
base_length = 240;          // Länge des Basismoduls
base_width = 240;           // Breite des Basismoduls  
base_height = 50;           // Höhe des Basismoduls
wall_thickness = 2.5;       // Wandstärke
corner_radius = 4;          // Abrundung der Ecken

// Verbindungssystem Parameter
connector_hole_diameter = 3.2;  // M3 Schraube + Toleranz
connector_hole_depth = 12;      // Tiefe der Verbindungslöcher
connector_spacing = 20;          // Abstand zwischen Verbindungspunkten
edge_margin = 15;               // Rand zu den Kanten

// Magnetische Verbindungen
magnet_diameter = 6.2;      // 6mm Magnet + Toleranz
magnet_depth = 2.5;         // Tiefe der Magnetaussparungen

// ========================================
// Hauptmodul
// ========================================
module base_module() {
    difference() {
        // Hauptkörper
        rounded_box(base_length, base_width, base_height, corner_radius);
        
        // Innenraum aushöhlen
        translate([wall_thickness, wall_thickness, wall_thickness]) {
            rounded_box(
                base_length - 2*wall_thickness, 
                base_width - 2*wall_thickness, 
                base_height, 
                corner_radius/2
            );
        }
        
        // Verbindungslöcher oben
        connector_holes_top();
        
        // Verbindungslöcher unten  
        connector_holes_bottom();
        
        // Magnetische Verbindungen
        magnetic_connectors();
    }
    
    // Verstärkungsrippen
    reinforcement_ribs();
    
    // Stapelhilfen
    stacking_guides();
}

// ========================================
// Hilfsfunktionen
// ========================================

// Abgerundete Box
module rounded_box(length, width, height, radius) {
    hull() {
        for(x = [radius, length-radius]) {
            for(y = [radius, width-radius]) {
                translate([x, y, 0]) {
                    cylinder(h=height, r=radius, $fn=32);
                }
            }
        }
    }
}

// Verbindungslöcher Oberseite
module connector_holes_top() {
    for(x = [edge_margin : connector_spacing : base_length-edge_margin]) {
        for(y = [edge_margin : connector_spacing : base_width-edge_margin]) {
            translate([x, y, base_height-connector_hole_depth]) {
                cylinder(h=connector_hole_depth+1, d=connector_hole_diameter, $fn=16);
                // Senkung für Schraubenkopf
                translate([0, 0, connector_hole_depth-3]) {
                    cylinder(h=4, d=6.5, $fn=16);
                }
            }
        }
    }
}

// Verbindungslöcher Unterseite
module connector_holes_bottom() {
    for(x = [edge_margin : connector_spacing : base_length-edge_margin]) {
        for(y = [edge_margin : connector_spacing : base_width-edge_margin]) {
            translate([x, y, -1]) {
                cylinder(h=connector_hole_depth+1, d=connector_hole_diameter, $fn=16);
            }
        }
    }
}

// Magnetische Verbindungen an den Seiten
module magnetic_connectors() {
    magnet_positions = [
        [base_length/4, 0, base_height/2],
        [3*base_length/4, 0, base_height/2],
        [base_length/4, base_width, base_height/2],
        [3*base_length/4, base_width, base_height/2],
        [0, base_width/4, base_height/2],
        [0, 3*base_width/4, base_height/2],
        [base_length, base_width/4, base_height/2],
        [base_length, 3*base_width/4, base_height/2]
    ];
    
    for(pos = magnet_positions) {
        translate(pos) {
            if(pos[0] == 0 || pos[0] == base_length) {
                rotate([0, 90, 0]) {
                    translate([0, 0, -magnet_depth/2]) {
                        cylinder(h=magnet_depth, d=magnet_diameter, $fn=24);
                    }
                }
            } else {
                rotate([90, 0, 0]) {
                    translate([0, 0, -magnet_depth/2]) {
                        cylinder(h=magnet_depth, d=magnet_diameter, $fn=24);
                    }
                }
            }
        }
    }
}

// Verstärkungsrippen
module reinforcement_ribs() {
    rib_thickness = 1.5;
    rib_height = base_height - wall_thickness - 2;
    
    // Längsrippen
    for(y = [base_width/4, base_width/2, 3*base_width/4]) {
        translate([wall_thickness, y - rib_thickness/2, wall_thickness]) {
            cube([base_length - 2*wall_thickness, rib_thickness, rib_height]);
        }
    }
    
    // Querrippen
    for(x = [base_length/4, base_length/2, 3*base_length/4]) {
        translate([x - rib_thickness/2, wall_thickness, wall_thickness]) {
            cube([rib_thickness, base_width - 2*wall_thickness, rib_height]);
        }
    }
}

// Stapelhilfen für präzise Ausrichtung
module stacking_guides() {
    guide_height = 3;
    guide_diameter = 8;
    
    positions = [
        [20, 20, base_height],
        [base_length-20, 20, base_height], 
        [20, base_width-20, base_height],
        [base_length-20, base_width-20, base_height]
    ];
    
    for(pos = positions) {
        translate(pos) {
            cylinder(h=guide_height, d=guide_diameter, $fn=24);
        }
    }
}

// ========================================
// Render
// ========================================
base_module();