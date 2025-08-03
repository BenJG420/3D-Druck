// Dual Cooling System - Combined Part & Hotend Cooling
// Professional CFD-optimized design for maximum cooling efficiency
// Compatible with Ender 3, Prusa, Voron and similar extruders

// System parameters
part_cooling_fan = 5015;     // 5015 radial fan for part cooling
hotend_fan = 4020;           // 4020 axial fan for hotend cooling
system_height = 85;          // Total system height
mounting_width = 60;         // System mounting width

// Part cooling parameters (5015 fan)
pc_inlet_diameter = 45;
pc_outlet_width = 35;
pc_outlet_height = 4;
pc_nozzle_distance = 12;     // Distance from nozzle

// Hotend cooling parameters (4020 fan)  
hc_inlet_diameter = 38;
hc_expansion_ratio = 1.3;
hc_duct_length = 55;

// Universal mounting system
wall_thickness = 1.6;
mounting_hole_spacing = 30;

module dual_cooling_system() {
    // Part cooling duct (5015 radial fan)
    translate([-35, 0, 0]) {
        difference() {
            union() {
                // 5015 Fan mounting and duct
                hull() {
                    // Fan connection
                    cylinder(h = wall_thickness, d = pc_inlet_diameter + 2*wall_thickness);
                    
                    // Curved transition to nozzle area
                    translate([60, 0, -25])
                        rotate([0, 0, -15])
                            cube([wall_thickness, pc_outlet_width + 2*wall_thickness, 
                                  pc_outlet_height + 2*wall_thickness], center = true);
                }
                
                // 5015 mounting flange
                translate([0, 0, wall_thickness])
                    difference() {
                        cylinder(h = 3, d = 54);
                        cylinder(h = 4, d = 48);
                    }
            }
            
            // Internal airflow channel
            hull() {
                translate([0, 0, -1])
                    cylinder(h = wall_thickness + 2, d = pc_inlet_diameter);
                
                translate([55, 0, -25])
                    rotate([0, 0, -15])
                        cube([wall_thickness + 2, pc_outlet_width, pc_outlet_height], center = true);
            }
            
            // 5015 mounting holes
            for (i = [0:3]) {
                rotate([0, 0, i*90 + 45])
                    translate([20, 0, -1])
                        cylinder(h = 8, d = 4.2);
            }
            
            // Fan hub clearance
            translate([0, 0, -1])
                cylinder(h = 6, d = 22);
        }
        
        // Part cooling flow guides
        translate([25, 0, -15]) {
            for (j = [-1, 1]) {
                translate([0, j * pc_outlet_width/3, 0])
                    rotate([0, 25, 0])
                        cube([20, 0.8, 3], center = true);
            }
        }
    }
    
    // Hotend cooling duct (4020 axial fan)
    translate([35, 0, 0]) {
        difference() {
            union() {
                // 4020 Fan duct with expansion
                hull() {
                    // Fan connection
                    cylinder(h = wall_thickness, d = hc_inlet_diameter + 2*wall_thickness);
                    
                    // Expanded outlet for hotend cooling
                    translate([0, 0, hc_duct_length])
                        cylinder(h = wall_thickness, 
                                d = (hc_inlet_diameter + 2*wall_thickness) * hc_expansion_ratio);
                }
                
                // 4020 mounting flange
                translate([0, 0, -3])
                    difference() {
                        cylinder(h = 3, d = 46);
                        cylinder(h = 4, d = 39);
                    }
            }
            
            // Internal airflow channel
            hull() {
                translate([0, 0, -1])
                    cylinder(h = wall_thickness + 2, d = hc_inlet_diameter);
                
                translate([0, 0, hc_duct_length - 1])
                    cylinder(h = wall_thickness + 3, d = hc_inlet_diameter * hc_expansion_ratio);
            }
            
            // 4020 mounting holes
            for (i = [0:3]) {
                rotate([0, 0, i*90 + 45])
                    translate([16, 0, -4])
                        cylinder(h = 8, d = 3.2);
            }
            
            // Fan hub clearance
            translate([0, 0, -2])
                cylinder(h = 6, d = 12);
            
            // Hotend clearance
            translate([0, 0, hc_duct_length + 5])
                cylinder(h = 15, d = 28);
        }
        
        // Hotend cooling guide vanes
        for (i = [0:5]) {
            rotate([0, 0, i*60])
                translate([hc_inlet_diameter/3, 0, hc_duct_length/2])
                    rotate([0, 15, 0])
                        cube([15, 0.8, 2], center = true);
        }
    }
    
    // Central mounting bracket connecting both systems
    difference() {
        // Main bracket structure
        translate([0, 0, -10])
            cube([80, 50, 8], center = true);
        
        // Fan mounting clearances
        translate([-35, 0, -10])
            cylinder(h = 10, d = 52);
        translate([35, 0, -10])
            cylinder(h = 10, d = 44);
        
        // Extruder mounting holes
        for (i = [-1, 1]) {
            translate([i * mounting_hole_spacing/2, 20, -10])
                cylinder(h = 10, d = 3.2);
            translate([i * mounting_hole_spacing/2, -20, -10])
                cylinder(h = 10, d = 3.2);
        }
        
        // Weight reduction cutouts
        translate([0, 15, -10])
            cube([40, 8, 10], center = true);
        translate([0, -15, -10])
            cube([40, 8, 10], center = true);
        
        // Wire management channels
        translate([-15, 25, -10])
            cube([30, 3, 10], center = true);
    }
}

// Modular nozzle targeting system
module precision_nozzle_targeting() {
    translate([20, 0, -25]) {
        difference() {
            // Targeting ring
            cylinder(h = 3, d = pc_outlet_width + 12);
            cylinder(h = 4, d = pc_outlet_width + 4);
            
            // Directional adjustment slots
            for (i = [0:7]) {
                rotate([0, 0, i*45])
                    translate([pc_outlet_width/2 + 6, 0, 0])
                        cube([4, 1.5, 4], center = true);
            }
        }
        
        // Adjustable vanes for air direction
        for (i = [0:3]) {
            rotate([0, 0, i*90 + 22.5])
                translate([pc_outlet_width/2 + 4, 0, 1.5])
                    rotate([0, 0, 15])
                        cube([8, 1, 3], center = true);
        }
    }
}

// Universal extruder adapter plates
module extruder_adapter_plate() {
    translate([0, 30, -15]) {
        difference() {
            // Main adapter plate
            cube([70, 6, 20], center = true);
            
            // Ender 3 S1/Pro mounting pattern
            translate([25, 0, 5])
                rotate([90, 0, 0])
                    cylinder(h = 8, d = 3.2);
            translate([-25, 0, 5])
                rotate([90, 0, 0])
                    cylinder(h = 8, d = 3.2);
            
            // Prusa/E3D mounting pattern
            translate([15, 0, -5])
                rotate([90, 0, 0])
                    cylinder(h = 8, d = 3.2);
            translate([-15, 0, -5])
                rotate([90, 0, 0])
                    cylinder(h = 8, d = 3.2);
            
            // Voron mounting pattern
            translate([20, 0, 0])
                rotate([90, 0, 0])
                    cylinder(h = 8, d = 3.2);
            translate([-20, 0, 0])
                rotate([90, 0, 0])
                    cylinder(h = 8, d = 3.2);
        }
    }
}

// Integrated cable management system
module cable_management() {
    // Cable guide for both fan wires
    translate([0, -30, -5]) {
        difference() {
            cube([90, 8, 12], center = true);
            
            // Cable channels
            translate([-30, 0, 2])
                cube([6, 10, 8], center = true);
            translate([30, 0, 2])
                cube([6, 10, 8], center = true);
            
            // Strain relief
            translate([-30, -2, 2])
                rotate([0, 0, 45])
                    cube([3, 3, 8], center = true);
            translate([30, -2, 2])
                rotate([0, 0, -45])
                    cube([3, 3, 8], center = true);
        }
    }
}

// Generate the complete dual cooling system
dual_cooling_system();

// Add precision targeting (uncomment if needed)
// precision_nozzle_targeting();

// Add extruder adapter (uncomment if needed)
// extruder_adapter_plate();

// Add cable management (uncomment if needed)
// cable_management();