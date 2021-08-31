use <pegboard simple hook.scad>;

module connector() {
    offset = 2.5;
    difference() {
        union() {
            hookBody();
            hull() {
                hookVert();
                translate([0,-offset,0]) hookVert();
            }
        }
        connectorPegs();
    }
}

module connectorPegs(d=6, peglen=25.4) {
    hull() {
        translate([6, -d/2, 0]) rotate([0,0,22.5]) cylinder(d=d/cos(180/8), h=6, center=true, $fn=8);
        translate([peglen - 6, -d/2, 0]) rotate([0,0,22.5]) cylinder(d=d/cos(180/8), h=6, center=true, $fn=8);
    }
}
!union() {
    connector();
   rotate([180,0,0]) translate([0, 25, 0]) connector();
}

module cutoutCyl(d, offset, len, $fn=12) {
    rotate([-90,0,-45]) translate([0,offset,5])
        rotate([0,0,30]) cylinder(d=d/cos(180/$fn), h=len, center=false, $fn=$fn);
}
module cutouts(count, wid, d=5, len=50, stop=0) {
    spacing = wid/(count);
    for (ii=[0.5:1:count+stop]) {
        cutoutCyl(d, -ii*spacing, len, 12);
    }

}
rotate([90,0,0]) {
len = 25.4 * 3 - 1;
cutoutD = 10.4;
translate([2,5.5,-3]) {
    connectorPegs(5.5, 24.9);
    translate([0,0,len]) connectorPegs(5.5, 24.9);
}

difference() {
    intersection() {
        translate([-10,0,0]) cube(size=[35, 32, len - 6], center=false);

        translate([-5,0,0]) hull() {
            translate([3,9,0]) {
                cutoutCyl(cutoutD + 2, -(cutoutD + 2)/2, 23);
                translate([0,0,len-6]) cutoutCyl(cutoutD + 2, (cutoutD + 2)/2, 23);
            }
            translate([6,0,0]) rotate([0,0,-45]) {
                cutoutCyl(cutoutD + 3, -(cutoutD + 3)/2, 25);
                translate([0,0,len-6]) cutoutCyl(cutoutD + 3, (cutoutD + 3)/2, 25);
            }
        }
    }
    translate([0,11,46]) cutouts(3, 20, 4);

    translate([0,11,21]) cutouts(3, 25, 5.7);

    translate([0,11,1]) cutouts(2, 20, 7.3);


    translate([0,5,1]) rotate([0,0,-25]) cutouts(2, 25, 8.9);

    translate([0,5,26]) rotate([0,0,-25]) cutouts(3, 41, 12);


    translate([-10,-1.5,0]) rotate([0,0,-45]) cutouts(8, len-6, 4);
    *cube([50,100,45], center=true);
}
}
