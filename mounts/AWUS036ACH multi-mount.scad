// raise for higher detail
$fn = 64;

// Number of radio modules, must be a number greater than one!
$NUMBEROFMODULES = 3;

$FLATTEN = false;

module board_cutout() {
    cube([1.05 + 0.5, 70 + 0.05, 3.5 + 1]);
    translate([-2.5, -2, 0])
        cube([11 + 2.5, 7 + 0.5, 3.5 + 1]);
    translate([0, 53, 0])
        cube([2.5, 7, 3.5 + 1]);
    translate([0, 65, 0])
        cube([1.05 + 0.5, 5, 5 + 1]);
    translate([(1.05 + 0.5) + 6.5, -(2) + (7 + 0.5 + 2 + 1) / 2 - 2 - 1, (3.5 + 1) / 2])
        cube([3.5 + 2.5, (7 + 0.5) + 2 + 1, 3.5 + 1], center = true);
}

module usb_support() {
    translate([((1.05 + 0.5) / 2) + 1.75, 0, 0]) {
        difference() {
            union() {
                translate([0, (-4 + 99) - 17 / 2, -2 + ((20.5) + 14.75 / 2 - 0.25) / 2]) {
                    translate([0, 0, 0])
                        cube([6.5 + (2 * 2), 17, (20.5) + 14.75 / 2 - 0.25], center = true);
                    translate([32, 0, 0])
                        cube([6.5 + (2 * 2), 17, (20.5) + 14.75 / 2 - 0.25], center = true);
                    // cable support buttress
                    translate([-((6.5 + (2 * 2)) / 2) + 45.725 / 2, 0, 0])
                        cube([45.725, 5, (20.5) + 14.75 / 2 - 0.25], center = true);
                }
            }

            union() {
                translate([0, -(4 - 99) - 19 / 2 + 1, (-2 + 20.5)]) {
                    translate([0, 0, (14.75 / 2)]) {
                        translate([0, 0, 0])
                            cube([6.5, 19, 14.75 - 6.65], center = true);
                        translate([32, 0, 0])
                            cube([6.5, 19, 14.75 - 6.65], center = true);
                    }

                    rotate([90, 0, 0]) {
                            translate([0, 6.65 / 2, 0]) {
                                translate([0, 0, 0])
                                   cylinder(d = 6.65, h = 19, center = true);
                                translate([0, 14.75 - 6.65, 0])
                                   cylinder(d = 6.65, h = 19, center = true);
                            }

                            translate([32, 6.65 / 2, 0]) {
                                translate([0, 0, 0])
                                   cylinder(d = 6.65, h = 19, center = true);
                                translate([0, 14.75 - 6.65, 0])
                                   cylinder(d = 6.65, h = 19, center = true);
                            }
                    }
                }                            
            }
        }
    }
}

module zip_cutout() {
    translate([(4.7 + 0.5) / 2, 0, -0.5]) {
        cube([4.7 + 0.5, 4 + 0.9, 4 + 1.9], center = true);
        translate([0, ((1.2 + 0.9) - (4 + 0.9)) / 2, -(4 + 1.9) / 2 + (67 + 1) / 2])
            cube([2.6 + 0.9, 1.2 + 0.9, 67 + 1], center = true);
    }
}

module bottom() {
    translate([0, 0, 2]) {
        difference() {
            union() {
                translate([-2.725, 0, -2]) {
                    // base
                    translate([0, -4, 0])
                        cube([45.725, 99, 3.5 + 2]);
                    // zip tie bolsters
                    translate([2.725 + (5 + (1.05 + 0.9) + ((32 - (4.7 + 0.9) - 5) - (5 + (1.05 + 0.9))) / 2 + (4.7 + 0.5) / 2) - 25 / 2, 6, 0])
                        cube([25, 7.9, 5 + 2]);
                    translate([0, 70 - 0.4 - (5 + 2) / 2, 0])
                        cube([45.725, 5 + 2, 5 + 2]);
                    translate([0, (99) - 11, 0])
                        cube([45.725, 5 + 2, 5 + 2]);
                 }

                // USB 3.0 cable supports
                translate([0, 0, 0])
                    mirror([0, 0, 0])
                        usb_support();
            }

            translate([0, 0, 0]) {
                translate([0, 0, 0])
                    board_cutout();
                translate([32, 0, 0])
                    board_cutout();
            }

            translate([0, 0, 0.9]) {
                translate([5 + (1.05 + 0.9), 0, 0]) {
                    translate([0, 10, 0])
                        zip_cutout();
                    translate([0, 70 - 0.4, 0])
                        zip_cutout();
                    translate([0, (99 - 6) - 0.4, 0])
                        zip_cutout();
                }

                translate([32 - (4.7 + 0.9) - 5, 0, 0]) {
                    translate([0, 10, 0])
                        zip_cutout();
                    translate([0, 70 - 0.4, 0])
                        zip_cutout();
                    translate([0, (99 - 6) - 0.4, 0])
                        #zip_cutout();
                }
            }
        }
    }
}

module top() {
    translate([0, 0, 50.25]) {
        difference() {
            union() {
                translate([-2.725, 0, 1.5]) {
                    // base
                    translate([0, -4, 0])
                        cube([45.725, 99, 2 + 2]);
                    // board guide
                    translate([0, 50, (-1.5) - 1.5])
                        cube([45.725, 10, 2+ 5]);
                }

                // USB 3.0 cable supports
                translate([0, 0, 1.5 + 2])
                    mirror([0, 0, 1])
                        usb_support();
            }

            translate([0, 0, -1.5]) {
                translate([0, 0, 0])
                    board_cutout();
                translate([32, 0, 0])
                    board_cutout();
            }

            translate([0, 0, -50.25]) {
                translate([5 + (1.05 + 0.9), 0, 0]) {
                    translate([0, 10, 0])
                        zip_cutout();
                    translate([0, 70 - 0.4, 0])
                        zip_cutout();
                    translate([0, (99 - 6) - 0.4, 0])
                        zip_cutout();
                }

                translate([32 - (4.7 + 0.9) - 5, 0, 3]) {
                    translate([0, (99 - 6) - 0.4, 0])
                        zip_cutout();
                    translate([0, 70 - 0.4, 0])
                        zip_cutout();
                    translate([0, 10, 0])
                        #zip_cutout();
                }
            }
        }
    }
}

difference() {
    union() {
        $offset = 0;
        for(i = [0 : ($NUMBEROFMODULES - 2)]) {
            translate([32 * i, 0, 0])
                bottom();

            if ($FLATTEN) {
                translate([32 * i, -(2.725 * 2) - 5, (3 + 50.25) + 5.5])
                    rotate([0, 180, 180])
                        top();
            } else {
                translate([32 * i, 0, 0])
                    rotate([0, 0, 0])
                        top();
            }
        }
    }
    
    union() {
        for(i = [0 : ($NUMBEROFMODULES - 2)]) {
            translate([32 * i, 0, 2 + 0.9]) {
                translate([5 + (1.05 + 0.9), 0, 0]) {
                    translate([0, 10, 0])
                        #zip_cutout();
                    translate([0, 70 - 0.4, 0])
                        #zip_cutout();
                    translate([0, (99 - 6) - 0.4, 0])
                        #zip_cutout();
                }
            }

            if ($FLATTEN) {
                translate([0, -(2.725 * 2) - 5, (50.25) + 10.1])
                    rotate([0, 180, 180])
                        translate([32 * i, 0, 2 + 0.9]) {
                            translate([5 + (1.05 + 0.9), 0, 0]) {
                                translate([0, 10, 0])
                                    #zip_cutout();
                                translate([0, 70 - 0.4, 0])
                                    #zip_cutout();
                                translate([0, (99 - 6) - 0.4, 0])
                                    #zip_cutout();
                            }
                        }
            }
        }
    }
}
