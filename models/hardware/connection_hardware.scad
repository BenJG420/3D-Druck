// ========================================
// Modulares 3D-Lagersystem - Verbindungshardware
// Optimiert für Bambu Lab P1S
// ========================================

include <../base/base_module.scad>

// Hardware Parameter
screw_m3_diameter = 3.2;              // M3 Schraube + Toleranz
screw_m3_head_diameter = 6.5;         // M3 Schraubenkopf
nut_m3_diameter = 6.4;                // M3 Sechskantmutter + Toleranz
nut_m3_height = 2.5;                  // Höhe M3 Mutter

// Magnet Parameter  
magnet_6x2_diameter = 6.2;            // 6mm Magnet + Toleranz
magnet_6x2_height = 2.5;              // 2mm Magnet + Toleranz

// Kugellager Parameter
bearing_608_outer_diameter = 22.2;     // 608ZZ Außendurchmesser + Toleranz
bearing_608_inner_diameter = 8.2;      // 608ZZ Innendurchmesser + Toleranz
bearing_608_height = 7.2;              // 608ZZ Höhe + Toleranz

// ========================================
// Stapel- und Verbindungshelfer
// ========================================

// Stapelstift für präzise Ausrichtung
module stacking_pin() {
    pin_diameter = 7.8;        // Passt zu den Stapelhilfen im Basismodul
    pin_height = 6;            // Höhe für sicheren Halt
    pin_head_diameter = 10;    // Kopf für besseren Halt
    pin_head_height = 2;       // Höhe des Kopfes
    
    // Hauptstift
    cylinder(h=pin_height, d=pin_diameter, $fn=24);
    
    // Kopf
    translate([0, 0, pin_height]) {
        cylinder(h=pin_head_height, d=pin_head_diameter, $fn=24);
    }
    
    // Führungsspitze
    translate([0, 0, -1]) {
        cylinder(h=1, d1=pin_diameter-1, d2=pin_diameter, $fn=24);
    }
}

// Verbindungsschraube (3D-druckbar)
module connection_screw() {
    screw_length = 20;
    screw_shaft_diameter = 2.8;
    screw_head_diameter = 6;
    screw_head_height = 3;
    thread_pitch = 0.5;
    
    // Schraubenkopf
    cylinder(h=screw_head_height, d=screw_head_diameter, $fn=24);
    
    // Schaft
    translate([0, 0, screw_head_height]) {
        cylinder(h=screw_length, d=screw_shaft_diameter, $fn=16);
    }
    
    // Gewinde-Simulation (optisch)
    for(i = [0:thread_pitch*4:screw_length]) {
        translate([0, 0, screw_head_height + i]) {
            rotate([0, 0, i*360/thread_pitch]) {
                translate([screw_shaft_diameter/2, 0, 0]) {
                    cube([0.2, 0.5, thread_pitch], center=true);
                }
            }
        }
    }
}

// Verbindungsmutter (3D-druckbar)
module connection_nut() {
    nut_outer_diameter = 6;
    nut_inner_diameter = 3;
    nut_height = 3;
    
    difference() {
        // Sechskant-Außenform
        cylinder(h=nut_height, d=nut_outer_diameter, $fn=6);
        
        // Innenloch
        translate([0, 0, -1]) {
            cylinder(h=nut_height + 2, d=nut_inner_diameter, $fn=16);
        }
    }
}

// ========================================
// Magnetische Verbindungselemente
// ========================================

// Magnethalter für Seitenverbindungen
module magnetic_connector() {
    holder_diameter = 8;
    holder_height = 4;
    
    difference() {
        // Halter-Körper
        cylinder(h=holder_height, d=holder_diameter, $fn=24);
        
        // Magnet-Aussparung
        translate([0, 0, holder_height - magnet_6x2_height]) {
            cylinder(h=magnet_6x2_height + 1, d=magnet_6x2_diameter, $fn=24);
        }
    }
    
    // Befestigungslasche
    translate([-holder_diameter/2, -1, 0]) {
        cube([holder_diameter, 2, holder_height]);
    }
}

// Magnetischer Schnellverschluss
module magnetic_quick_release() {
    base_length = 20;
    base_width = 10;
    base_height = 3;
    lever_length = 15;
    lever_width = 4;
    lever_height = 8;
    
    // Basis
    cube([base_length, base_width, base_height]);
    
    // Hebel
    translate([base_length - 5, base_width/2 - lever_width/2, base_height]) {
        cube([5, lever_width, lever_height]);
        
        // Hebelarm
        translate([5, lever_width/2, lever_height/2]) {
            rotate([0, -20, 0]) {
                cube([lever_length, lever_width, 2], center=true);
            }
        }
    }
    
    // Magnet-Aussparungen
    for(x = [5, 15]) {
        translate([x, base_width/2, base_height - magnet_6x2_height]) {
            cylinder(h=magnet_6x2_height + 1, d=magnet_6x2_diameter, $fn=16);
        }
    }
}

// ========================================
// Schienen und Führungen
// ========================================

// Universalschiene für verschiedene Anwendungen
module universal_rail(length = 200) {
    rail_width = 8;
    rail_height = 6;
    rail_wall_thickness = 1.5;
    
    difference() {
        // Hauptkörper
        cube([length, rail_width, rail_height]);
        
        // Führungsnut
        translate([2, rail_wall_thickness, rail_wall_thickness]) {
            cube([length - 4, rail_width - 2*rail_wall_thickness, rail_height]);
        }
        
        // Befestigungslöcher
        for(x = [10 : 20 : length-10]) {
            translate([x, rail_width/2, -1]) {
                cylinder(h=rail_height + 2, d=screw_m3_diameter, $fn=12);
            }
        }
    }
}

// Führungsblock für Schienen
module rail_guide_block() {
    block_width = 12;
    block_height = 10;
    block_length = 15;
    guide_width = 8.3;      // Etwas größer als Schiene für Gleiten
    guide_height = 6.3;
    
    difference() {
        // Hauptblock
        cube([block_length, block_width, block_height]);
        
        // Führungsnut
        translate([-1, (block_width - guide_width)/2, (block_height - guide_height)/2]) {
            cube([block_length + 2, guide_width, guide_height]);
        }
        
        // Befestigungsloch
        translate([block_length/2, block_width/2, -1]) {
            cylinder(h=block_height + 2, d=screw_m3_diameter, $fn=12);
        }
    }
}

// ========================================
// Kugellager-Implementierungen
// ========================================

// Kugellager-Halter für Schubladen
module bearing_holder() {
    holder_outer_diameter = bearing_608_outer_diameter + 4;
    holder_height = bearing_608_height + 2;
    
    difference() {
        // Außengehäuse
        cylinder(h=holder_height, d=holder_outer_diameter, $fn=32);
        
        // Lager-Aussparung
        translate([0, 0, 1]) {
            cylinder(h=bearing_608_height, d=bearing_608_outer_diameter, $fn=32);
        }
        
        // Durchgangsloch
        translate([0, 0, -1]) {
            cylinder(h=holder_height + 2, d=bearing_608_inner_diameter, $fn=24);
        }
    }
    
    // Befestigungsohren
    for(angle = [0, 120, 240]) {
        rotate([0, 0, angle]) {
            translate([holder_outer_diameter/2, 0, 0]) {
                difference() {
                    cube([8, 6, holder_height], center=true);
                    cylinder(h=holder_height + 1, d=screw_m3_diameter, $fn=12);
                }
            }
        }
    }
}

// Einfache Gleitlager-Alternative
module slide_bearing() {
    bearing_length = 20;
    bearing_outer_diameter = 12;
    bearing_inner_diameter = 8.5;
    
    difference() {
        // Außenhülse
        cylinder(h=bearing_length, d=bearing_outer_diameter, $fn=24);
        
        // Innenloch
        translate([0, 0, -1]) {
            cylinder(h=bearing_length + 2, d=bearing_inner_diameter, $fn=24);
        }
        
        // Schmiernuten
        for(angle = [0:45:315]) {
            rotate([0, 0, angle]) {
                translate([bearing_inner_diameter/2, 0, -1]) {
                    cube([1, 0.5, bearing_length + 2]);
                }
            }
        }
    }
}

// ========================================
// Spezielle Verbindungselemente
// ========================================

// L-Winkel für rechtwinklige Verbindungen
module l_bracket() {
    bracket_size = 20;
    bracket_thickness = 3;
    
    // Vertikaler Schenkel
    cube([bracket_thickness, bracket_size, bracket_size]);
    
    // Horizontaler Schenkel
    cube([bracket_size, bracket_thickness, bracket_size]);
    
    // Verstärkung
    translate([0, 0, 0]) {
        polyhedron(
            points = [
                [0,0,0], [bracket_thickness,0,0], [0,bracket_thickness,0],
                [0,0,bracket_size], [bracket_thickness,0,bracket_size], [0,bracket_thickness,bracket_size]
            ],
            faces = [
                [0,1,2], [3,5,4], [0,3,1], [1,3,4], [1,4,2], [2,4,5], [2,5,0], [0,5,3]
            ]
        );
    }
    
    // Befestigungslöcher
    for(pos = [[bracket_size/2, -1, bracket_size/2], [-1, bracket_size/2, bracket_size/2]]) {
        translate(pos) {
            rotate([90, 0, 0]) {
                cylinder(h=bracket_thickness + 2, d=screw_m3_diameter, $fn=12);
            }
        }
    }
}

// T-Verbinder für drei Module
module t_connector() {
    connector_size = 15;
    connector_thickness = 4;
    
    // Horizontaler Balken
    translate([-connector_size, -connector_thickness/2, 0]) {
        cube([2*connector_size, connector_thickness, connector_size]);
    }
    
    // Vertikaler Balken  
    translate([-connector_thickness/2, -connector_size, 0]) {
        cube([connector_thickness, 2*connector_size, connector_size]);
    }
    
    // Befestigungslöcher in alle Richtungen
    hole_positions = [
        [connector_size*0.7, 0, connector_size/2],   // Rechts
        [-connector_size*0.7, 0, connector_size/2],  // Links
        [0, connector_size*0.7, connector_size/2],    // Hinten
        [0, -connector_size*0.7, connector_size/2]    // Vorne
    ];
    
    for(pos = hole_positions) {
        translate(pos) {
            cylinder(h=connector_size + 1, d=screw_m3_diameter, $fn=12, center=true);
        }
    }
}

// ========================================
// Befestigungsklammern
// ========================================

// Universalklammer für verschiedene Anwendungen
module universal_clamp() {
    clamp_length = 25;
    clamp_width = 8;
    clamp_thickness = 3;
    clamp_gap = 5;
    
    difference() {
        union() {
            // Unterer Schenkel
            cube([clamp_length, clamp_width, clamp_thickness]);
            
            // Oberer Schenkel
            translate([0, 0, clamp_gap + clamp_thickness]) {
                cube([clamp_length, clamp_width, clamp_thickness]);
            }
            
            // Verbindung hinten
            translate([clamp_length - clamp_thickness, 0, 0]) {
                cube([clamp_thickness, clamp_width, clamp_gap + 2*clamp_thickness]);
            }
        }
        
        // Befestigungsloch
        translate([clamp_length/2, clamp_width/2, -1]) {
            cylinder(h=clamp_thickness + 2, d=screw_m3_diameter, $fn=12);
        }
        
        // Spannschraube
        translate([5, clamp_width/2, clamp_gap/2 + clamp_thickness]) {
            rotate([0, 90, 0]) {
                cylinder(h=clamp_length - 5, d=screw_m3_diameter, $fn=12);
            }
        }
    }
}

// Federnde Klammer 
module spring_clamp() {
    clamp_length = 30;
    clamp_width = 6;
    clamp_thickness = 2;
    spring_sections = 3;
    
    for(i = [0:spring_sections-1]) {
        z_offset = i * 8;
        curve_direction = (i % 2 == 0) ? 1 : -1;
        
        translate([0, 0, z_offset]) {
            for(step = [0:5:clamp_length-5]) {
                translate([step, curve_direction * sin(step*6) * 2, 0]) {
                    cube([5, clamp_width, clamp_thickness]);
                }
            }
        }
    }
    
    // Befestigungspunkte
    cube([clamp_width, clamp_width, clamp_thickness]);
    translate([clamp_length - clamp_width, 0, spring_sections * 8]) {
        cube([clamp_width, clamp_width, clamp_thickness]);
    }
}

// ========================================
// Hilfswerkzeuge
// ========================================

// Montagehilfe für Magnete
module magnet_insertion_tool() {
    tool_length = 80;
    tool_diameter = 5;
    tip_diameter = magnet_6x2_diameter - 0.2;
    tip_length = 10;
    
    // Griff
    cylinder(h=tool_length - tip_length, d=tool_diameter, $fn=16);
    
    // Spitze
    translate([0, 0, tool_length - tip_length]) {
        cylinder(h=tip_length, d=tip_diameter, $fn=24);
    }
    
    // Griffrippen
    for(z = [10:5:tool_length-tip_length-10]) {
        translate([0, 0, z]) {
            cylinder(h=2, d=tool_diameter + 1, $fn=16);
        }
    }
}

// Schraubenschlüssel für 3D-gedruckte Schrauben
module printed_screwdriver() {
    handle_length = 60;
    handle_diameter = 8;
    tip_length = 15;
    tip_width = 3;
    tip_thickness = 1;
    
    // Griff
    cylinder(h=handle_length, d=handle_diameter, $fn=16);
    
    // Spitze
    translate([0, 0, handle_length]) {
        cube([tip_width, tip_thickness, tip_length], center=true);
    }
    
    // Griffmarkierungen
    for(z = [15:10:handle_length-15]) {
        translate([0, 0, z]) {
            difference() {
                cylinder(h=3, d=handle_diameter + 1, $fn=16);
                translate([0, 0, -1]) {
                    cylinder(h=5, d=handle_diameter - 1, $fn=16);
                }
            }
        }
    }
}

// ========================================
// Hardware-Sets (für einfachen Druck)
// ========================================

// Komplettes Verbindungsset
module connection_hardware_set() {
    translate([0, 0, 0]) stacking_pin();
    translate([15, 0, 0]) connection_screw();
    translate([30, 0, 0]) connection_nut();
    translate([45, 0, 0]) magnetic_connector();
    
    translate([0, 20, 0]) l_bracket();
    translate([30, 20, 0]) t_connector();
    translate([60, 20, 0]) universal_clamp();
    
    translate([0, 50, 0]) rail_guide_block();
    translate([20, 50, 0]) bearing_holder();
    translate([50, 50, 0]) slide_bearing();
}

// Werkzeug-Set
module tool_set() {
    translate([0, 0, 0]) magnet_insertion_tool();
    translate([20, 0, 0]) printed_screwdriver();
}

// ========================================
// Render (uncomment desired part)
// ========================================

// stacking_pin();                   // Stapelstift
// connection_screw();               // Verbindungsschraube
// magnetic_connector();             // Magnetverbinder
// universal_rail(150);              // Universalschiene
// bearing_holder();                 // Lagerhalter
// l_bracket();                      // L-Winkel
// t_connector();                    // T-Verbinder
// universal_clamp();                // Universalklammer
// connection_hardware_set();        // Komplettes Hardware-Set
connection_hardware_set();        // Standard-Darstellung