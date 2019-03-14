// raise for higher detail
$fn = 64;

module fillet(r, h) {
    translate([r / 2, r / 2, 0])

        difference() {
            cube([r + 0.01, r + 0.01, h], center = true);

            translate([r / 2, r / 2, 0])
                cylinder(r = r, h = h + 1, center = true);

        }
}

difference() {
    union() {
        translate([65 / 2, 28.85 / 2, 27 / 2])
            cube([65, 28.85, 27], center = true);
    }

    union() {
        translate([35 / 2 - 1, 28.85 / 2, (11 / 2) + 27 - 10])
            cube([35, 17.75, 11], center = true);
        translate([65 - 34 / 2 + 1, 28.85 / 2, ((11 - 2) / 2) + (27 - 10) + 2])
            cube([34, 30.85, 11 - 2], center = true);
 
        // #8 screw holes
        translate([16.25, 30.85 / 2 - 1, 8.5]) {
            rotate([90, 0, 0]) {
                translate([0, 0, 0]) {
                    #cylinder(d = ((0.9927 * 4.064) + 0.3602), h = 30.85, center = true);
                }
                translate([16.25 * 2, 0, 0]) {
                    #cylinder(d = ((0.9927 * 4.064) + 0.3602), h = 30.85, center = true);
                }
            }
        }
    }
}