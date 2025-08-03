// 5015 Radial Fan Part Cooling Duct
// CFD-optimized design for maximum part cooling efficiency
// Compatible with popular 3D printer extruders

// Fan specifications
fan_size = 50;              // 5015 fan outer dimension
fan_thickness = 15;         // Fan depth
fan_hole_spacing = 40;      // Mounting hole distance
fan_hole_diameter = 4.2;    // M4 screw holes

// Duct optimization parameters
inlet_diameter = 45;        // Optimized inlet for 5015 fan
duct_length = 80;           // Total duct length
nozzle_height = 15;         // Height above nozzle
outlet_width = 30;          // Width of cooling air outlet
outlet_height = 3;          // Height of outlet slot
wall_thickness = 1.6;       // Optimized wall thickness

// Aerodynamic parameters
curve_radius = 15;          // Smooth curve radius
taper_angle = 15;           // Gradual taper for smooth flow
diffuser_length = 25;       // Length of diffuser section

module 5015_cooling_duct() {
    difference() {
        union() {
            // Main duct body with smooth transitions
            hull() {
                // Fan connection - circular inlet
                translate([0, 0, 0])
                    cylinder(h = wall_thickness, d = inlet_diameter + 2*wall_thickness);
                
                // Transition point
                translate([duct_length/3, 0, -curve_radius])
                    rotate([0, 45, 0])
                        cylinder(h = wall_thickness, d = inlet_diameter*0.8 + 2*wall_thickness);
                
                // Nozzle area - rectangular outlet
                translate([duct_length*0.8, 0, -nozzle_height])
                    cube([wall_thickness, outlet_width + 2*wall_thickness, outlet_height + 2*wall_thickness], center = true);
            }
            
            // Fan mounting flange
            translate([0, 0, wall_thickness])
                difference() {
                    cylinder(h = 3, d = fan_size + 4);
                    cylinder(h = 4, d = fan_size - 2);
                }
        }
        
        // Internal airflow channel with optimized geometry
        hull() {
            // Fan inlet - matches 5015 outlet
            translate([0, 0, -1])
                cylinder(h = wall_thickness + 2, d = inlet_diameter);
            
            // Smooth transition with expansion
            translate([duct_length/3, 0, -curve_radius])
                rotate([0, 45, 0])
                    cylinder(h = wall_thickness + 2, d = inlet_diameter*0.9);
            
            // Converging section for velocity increase
            translate([duct_length*0.6, 0, -nozzle_height + 2])
                cube([wall_thickness + 2, outlet_width*1.2, outlet_height*2], center = true);
            
            // Final outlet - optimized for part cooling
            translate([duct_length*0.8, 0, -nozzle_height])
                cube([wall_thickness + 2, outlet_width, outlet_height], center = true);
        }
        
        // Fan mounting holes
        for (i = [0:3]) {
            rotate([0, 0, i*90 + 45])
                translate([fan_hole_spacing/2, 0, -1])
                    cylinder(h = 10, d = fan_hole_diameter);
        }
        
        // Central fan hub clearance
        translate([0, 0, -1])
            cylinder(h = wall_thickness + 4, d = 20);
        
        // Wire management cutout
        translate([fan_size/2 - 2, -3, 0])
            cube([4, 6, wall_thickness + 3]);
    }
    
    // Internal flow guides for reduced turbulence
    translate([duct_length/4, 0, -curve_radius/2]) {
        // Upper flow guide
        translate([0, outlet_width/4, 0])
            rotate([0, 30, 0])
                cube([15, 0.8, 2], center = true);
        
        // Lower flow guide  
        translate([0, -outlet_width/4, 0])
            rotate([0, 30, 0])
                cube([15, 0.8, 2], center = true);
    }
}

// Modular mounting bracket for different extruders
module mounting_bracket() {
    difference() {
        // Main bracket body
        translate([duct_length*0.9, 0, -nozzle_height - 5])
            cube([15, 40, 10], center = true);
        
        // Mounting holes for extruder
        translate([duct_length*0.9, 12, -nozzle_height - 5])
            cylinder(h = 12, d = 3.2, center = true);
        translate([duct_length*0.9, -12, -nozzle_height - 5])
            cylinder(h = 12, d = 3.2, center = true);
        
        // Weight reduction
        translate([duct_length*0.9, 0, -nozzle_height - 5])
            cylinder(h = 12, d = 20, center = true);
    }
}

// Adjustable nozzle targeting system
module nozzle_targeting_ring() {
    translate([duct_length*0.8, 0, -nozzle_height]) {
        difference() {
            cylinder(h = 2, d = outlet_width + 8);
            cylinder(h = 3, d = outlet_width);
            
            // Adjustment slots
            for (i = [0:3]) {
                rotate([0, 0, i*90])
                    translate([outlet_width/2 + 2, 0, 0])
                        cube([3, 1, 3], center = true);
            }
        }
    }
}

// Generate the main duct
5015_cooling_duct();

// Add mounting bracket
mounting_bracket();

// Add targeting ring (comment out if not needed)
// nozzle_targeting_ring();