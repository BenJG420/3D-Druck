// 4020 Axial Fan Hotend Cooling Duct
// Optimized for hotend cooling and heat break cooling
// CFD-optimized airflow design

// Fan specifications
fan_size = 40;              // 4020 fan outer dimension
fan_thickness = 20;         // Fan depth
fan_hole_spacing = 32;      // Mounting hole distance
fan_hole_diameter = 3.2;    // M3 screw holes

// Duct parameters
inlet_diameter = 38;        // Optimized for 4020 fan
duct_total_length = 60;     // Total duct length
hotend_clearance = 25;      // Clearance around hotend
wall_thickness = 1.5;       // Wall thickness

// Airflow optimization
expansion_ratio = 1.4;      // Outlet expansion for pressure recovery
guide_vane_count = 6;       // Number of airflow guide vanes
diffuser_angle = 12;        // Diffuser half-angle (optimal: 7-12°)

module 4020_hotend_duct() {
    difference() {
        union() {
            // Main duct body with smooth expansion
            hull() {
                // Fan connection flange
                translate([0, 0, 0])
                    cylinder(h = wall_thickness, d = inlet_diameter + 2*wall_thickness);
                
                // Intermediate expansion
                translate([0, 0, duct_total_length/2])
                    cylinder(h = wall_thickness, d = (inlet_diameter + 2*wall_thickness) * 1.2);
                
                // Final outlet with optimized expansion
                translate([0, 0, duct_total_length])
                    cylinder(h = wall_thickness, d = (inlet_diameter + 2*wall_thickness) * expansion_ratio);
            }
            
            // Mounting flange for 4020 fan
            translate([0, 0, -3])
                difference() {
                    cylinder(h = 3, d = fan_size + 6);
                    cylinder(h = 4, d = fan_size - 1);
                }
        }
        
        // Internal airflow channel
        hull() {
            // Fan inlet
            translate([0, 0, -1])
                cylinder(h = wall_thickness + 2, d = inlet_diameter);
            
            // Gradual expansion for optimal pressure recovery
            translate([0, 0, duct_total_length/2])
                cylinder(h = wall_thickness + 2, d = inlet_diameter * 1.15);
            
            // Final outlet
            translate([0, 0, duct_total_length - 1])
                cylinder(h = wall_thickness + 3, d = inlet_diameter * expansion_ratio);
        }
        
        // Fan mounting holes
        for (i = [0:3]) {
            rotate([0, 0, i*90 + 45])
                translate([fan_hole_spacing/2, 0, -4])
                    cylinder(h = 8, d = fan_hole_diameter);
        }
        
        // Central hub clearance
        translate([0, 0, -2])
            cylinder(h = 6, d = 12);
        
        // Hotend clearance cutout
        translate([0, 0, duct_total_length + 5])
            cylinder(h = 15, d = hotend_clearance);
        
        // Wire management slot
        translate([fan_size/2 - 1.5, -2, -4])
            cube([3, 4, 8]);
    }
    
    // Airflow guide vanes for reduced turbulence
    for (i = [0:guide_vane_count-1]) {
        rotate([0, 0, i * (360/guide_vane_count)])
            translate([inlet_diameter/3, 0, duct_total_length/3])
                rotate([0, diffuser_angle, 0])
                    cube([duct_total_length/4, 0.8, 2], center = true);
    }
}

// Modular hotend mount adapter
module hotend_mount_adapter() {
    difference() {
        // Main adapter ring
        translate([0, 0, duct_total_length + wall_thickness])
            cylinder(h = 8, d = inlet_diameter * expansion_ratio + 4);
        
        // Central hotend clearance
        translate([0, 0, duct_total_length])
            cylinder(h = 12, d = hotend_clearance);
        
        // Mounting tabs cutouts
        for (i = [0:2]) {
            rotate([0, 0, i*120])
                translate([inlet_diameter * expansion_ratio/2 + 1, 0, duct_total_length + 4])
                    cylinder(h = 6, d = 3.2);
        }
        
        // Airflow channels around hotend
        for (i = [0:7]) {
            rotate([0, 0, i*45])
                translate([hotend_clearance/2 + 2, 0, duct_total_length])
                    cube([3, 2, 12], center = true);
        }
    }
}

// Universal extruder mounting bracket
module extruder_bracket() {
    translate([0, fan_size/2 + 10, -3]) {
        difference() {
            // Main bracket
            cube([40, 8, 30], center = true);
            
            // Mounting holes for various extruders
            // E3D V6/Volcano pattern
            translate([15, 0, 10])
                rotate([90, 0, 0])
                    cylinder(h = 10, d = 3.2);
            translate([-15, 0, 10])
                rotate([90, 0, 0])
                    cylinder(h = 10, d = 3.2);
            
            // Alternative mounting pattern
            translate([12, 0, -5])
                rotate([90, 0, 0])
                    cylinder(h = 10, d = 3.2);
            translate([-12, 0, -5])
                rotate([90, 0, 0])
                    cylinder(h = 10, d = 3.2);
            
            // Weight reduction
            translate([0, 0, 0])
                cube([25, 10, 15], center = true);
        }
    }
}

// Adjustable airflow deflector
module airflow_deflector() {
    translate([0, 0, duct_total_length + wall_thickness + 8]) {
        difference() {
            // Deflector ring
            cylinder(h = 3, d = inlet_diameter * expansion_ratio);
            cylinder(h = 4, d = inlet_diameter * expansion_ratio - 6);
            
            // Adjustment slots
            for (i = [0:5]) {
                rotate([0, 0, i*60])
                    translate([inlet_diameter * expansion_ratio/2 - 2, 0, 0])
                        cube([2, 1, 4], center = true);
            }
        }
        
        // Directional vanes
        for (i = [0:3]) {
            rotate([0, 0, i*90 + 22.5])
                translate([inlet_diameter * expansion_ratio/2 - 4, 0, 1.5])
                    rotate([30, 0, 0])
                        cube([6, 0.8, 4], center = true);
        }
    }
}

// Generate main duct
4020_hotend_duct();

// Add hotend mount adapter
hotend_mount_adapter();

// Add extruder bracket
extruder_bracket();

// Add adjustable deflector (comment out if not needed)
// airflow_deflector();