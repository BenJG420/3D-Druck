// Airflow Fan Shroud for 3D Printing
// Optimized design for maximum airflow with minimal turbulence

// Fan parameters
fan_diameter = 40; // 40mm fan
fan_thickness = 10;
shroud_extension = 20;

// Airflow optimization parameters
inlet_taper_length = 15;
outlet_taper_length = 25;
wall_thickness = 1.5;
mounting_hole_diameter = 3;
airflow_guide_thickness = 0.8;

module fan_shroud() {
    difference() {
        union() {
            // Main shroud body with inlet taper
            hull() {
                // Fan mounting end
                translate([0, 0, 0])
                    cylinder(h = 2, d = fan_diameter + 2*wall_thickness);
                
                // Inlet end (larger for better airflow)
                translate([0, 0, -inlet_taper_length])
                    cylinder(h = 2, d = fan_diameter + 8);
            }
            
            // Outlet section with gradual expansion
            hull() {
                // Fan mounting end
                translate([0, 0, fan_thickness])
                    cylinder(h = 2, d = fan_diameter + 2*wall_thickness);
                
                // Outlet end (expanded for reduced back pressure)
                translate([0, 0, fan_thickness + outlet_taper_length])
                    cylinder(h = 2, d = fan_diameter + 6);
            }
        }
        
        // Main airflow channel
        hull() {
            // Fan area
            translate([0, 0, -1])
                cylinder(h = fan_thickness + 2, d = fan_diameter);
            
            // Inlet opening (larger)
            translate([0, 0, -inlet_taper_length - 1])
                cylinder(h = 2, d = fan_diameter + 6);
            
            // Outlet opening (expanded)
            translate([0, 0, fan_thickness + outlet_taper_length - 1])
                cylinder(h = 3, d = fan_diameter + 4);
        }
        
        // Fan mounting holes
        for (i = [0:3]) {
            rotate([0, 0, i*90 + 45])
                translate([fan_diameter/2 * 0.7, 0, -1])
                    cylinder(h = fan_thickness + 2, d = mounting_hole_diameter);
        }
        
        // Wire management slot
        translate([fan_diameter/2 - 3, -1, -1])
            cube([6, 2, fan_thickness + 2]);
    }
    
    // Airflow guide vanes (reduce turbulence)
    for (i = [0:5]) {
        rotate([0, 0, i*60])
            translate([fan_diameter/4, 0, fan_thickness/2])
                rotate([0, 45, 0])
                    cube([8, airflow_guide_thickness, 1], center = true);
    }
    
    // Mounting tabs
    for (i = [0:3]) {
        rotate([0, 0, i*90])
            translate([fan_diameter/2 + wall_thickness + 2, 0, fan_thickness/2])
                difference() {
                    cube([6, 8, fan_thickness], center = true);
                    translate([2, 0, 0])
                        cylinder(h = fan_thickness + 1, d = 3, center = true);
                }
    }
}

// Air filter mount (optional)
module air_filter_mount() {
    translate([0, 0, -inlet_taper_length - 3]) {
        difference() {
            cylinder(h = 3, d = fan_diameter + 12);
            cylinder(h = 4, d = fan_diameter + 6);
            
            // Filter holding slots
            for (i = [0:7]) {
                rotate([0, 0, i*45])
                    translate([fan_diameter/2 + 6, 0, 0])
                        cube([3, 1, 4], center = true);
            }
        }
    }
}

// Generate the fan shroud
fan_shroud();

// Uncomment the next line to add air filter mount
// air_filter_mount();