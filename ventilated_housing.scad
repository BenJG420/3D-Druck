// Ventilated Housing for 3D Printing
// This design includes proper airflow channels to ensure air circulation

// Parameters
housing_width = 100;
housing_depth = 80;
housing_height = 60;
wall_thickness = 2;

// Ventilation parameters
vent_hole_diameter = 8;
vent_hole_spacing = 15;
air_channel_width = 5;
air_channel_height = 3;

module ventilated_housing() {
    difference() {
        // Main housing body
        cube([housing_width, housing_depth, housing_height]);
        
        // Hollow interior
        translate([wall_thickness, wall_thickness, wall_thickness])
            cube([housing_width - 2*wall_thickness, 
                  housing_depth - 2*wall_thickness, 
                  housing_height - wall_thickness]);
        
        // Front ventilation holes
        for (i = [0:floor((housing_width-20)/vent_hole_spacing)]) {
            for (j = [0:floor((housing_height-20)/vent_hole_spacing)]) {
                translate([10 + i*vent_hole_spacing, -1, 10 + j*vent_hole_spacing])
                    rotate([-90, 0, 0])
                        cylinder(h = wall_thickness + 2, d = vent_hole_diameter);
            }
        }
        
        // Back ventilation holes
        for (i = [0:floor((housing_width-20)/vent_hole_spacing)]) {
            for (j = [0:floor((housing_height-20)/vent_hole_spacing)]) {
                translate([10 + i*vent_hole_spacing, housing_depth-1, 10 + j*vent_hole_spacing])
                    rotate([-90, 0, 0])
                        cylinder(h = wall_thickness + 2, d = vent_hole_diameter);
            }
        }
        
        // Side ventilation slots
        for (i = [0:floor((housing_depth-30)/vent_hole_spacing)]) {
            // Left side
            translate([-1, 15 + i*vent_hole_spacing, housing_height/2])
                cube([wall_thickness + 2, air_channel_width, air_channel_height]);
            
            // Right side
            translate([housing_width - wall_thickness - 1, 15 + i*vent_hole_spacing, housing_height/2])
                cube([wall_thickness + 2, air_channel_width, air_channel_height]);
        }
        
        // Top ventilation grid
        for (i = [0:floor((housing_width-20)/vent_hole_spacing)]) {
            for (j = [0:floor((housing_depth-20)/vent_hole_spacing)]) {
                translate([10 + i*vent_hole_spacing, 10 + j*vent_hole_spacing, housing_height-1])
                    cylinder(h = wall_thickness + 2, d = vent_hole_diameter);
            }
        }
        
        // Air flow channels inside the housing
        translate([wall_thickness + 5, wall_thickness, wall_thickness + 5])
            cube([air_channel_width, housing_depth - 2*wall_thickness, air_channel_height]);
        
        translate([housing_width - wall_thickness - 5 - air_channel_width, wall_thickness, wall_thickness + 5])
            cube([air_channel_width, housing_depth - 2*wall_thickness, air_channel_height]);
    }
}

// Generate the ventilated housing
ventilated_housing();

// Add mounting feet with drain holes
translate([10, 10, -5])
    difference() {
        cylinder(h = 5, d = 15);
        cylinder(h = 7, d = 3); // Drain hole
    }

translate([housing_width-10, 10, -5])
    difference() {
        cylinder(h = 5, d = 15);
        cylinder(h = 7, d = 3); // Drain hole
    }

translate([10, housing_depth-10, -5])
    difference() {
        cylinder(h = 5, d = 15);
        cylinder(h = 7, d = 3); // Drain hole
    }

translate([housing_width-10, housing_depth-10, -5])
    difference() {
        cylinder(h = 5, d = 15);
        cylinder(h = 7, d = 3); // Drain hole
    }