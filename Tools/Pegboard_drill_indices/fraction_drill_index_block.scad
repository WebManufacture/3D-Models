use <pegboard connector female.scad>;
fractionsIndex = [
    1.59, // 1/16
    1.98, // 5/64
    2.38, // 3/32
    2.78, // 7/64
    3.17, // 1/8
    3.57, // 9/64
    3.97, // 5/32
    4.37, // 11/64
    4.76, // 3/16
    5.16, // 13/64
    5.16, // 13/64
    5.56, // 7/32
    5.56, // 7/32
    5.95, // 15/64
    5.95, // 15/64
    6.35, // 1/4
    6.35, // 1/4
];
labels = [
    [1,16],
    [5,64],
    [3,32],
    [7,64],
    [1,8],
    [9,64],
    [5,32],
    [11,64],
    [3,16],
    [13,64],
    [13,64],
    [7,32],
    [7,32],
    [15,64],
    [15,64],
    [1,4],
    [1,4],
];

function sumv(v,i,s=0) = (i < 0 ? 0 : (i==s ? v[i] : v[i] + sumv(v,i-1,s)));
function indexAt(row, col) = (row > 0 ? sumv(rowCounts, row - 1) + col : col);

function drillD(row, col) = 1 + drillIndex[indexAt(row, col)];
function height(row) = 45 + 4 * indexAt(row, col);
function width(row) = (blockWid - 1) / rowCounts[row];

module sideWall(row, heightMod=0) {
    hull() {
        translate([0,blockThick(row) - 1, 0]) cube([0.1, 1, 26]);
        translate([0,0, 18 - yonderHeight()]) cube([0.1, 1, heightMod + yonderHeight()+5]);

    }
}

module drillHole(row, col) {
    rotate([
        90 - atan2(
            deltaZ(row, col),
            (drillHeight(row, col) - 2)
        ),
        0,
        0
    ]) rotate([0,0,22.5]) cylinder(
        d=drillD(row, col),
        $fn=18,
        h=drillHeight(row, col),
        center=false
    );
}
module txRow(row, col) {
    translate([
        1 + pow((col+0.5) / rowCounts[row], 1.1) * (blockWid - 1),
        0,
        0
    ]) children();
}

function getFont(row, col, ii) = labels[indexAt(row, col)][ii] >= 10 ? "Arial Narrow" : "Arial Narrow:style=Bold";

module doRow(row, heightMod=0) {
    for (col=[0:rowCounts[row] - 1]) {
        if (labels[indexAt(row, col)][0] != labels[indexAt(row, col-1)][0]) {
            // print the label
            txRow(row, col) translate([
                0,
                0,
                26 - yonderHeight(row)
            ]) rotate([90,0,0]) {
                if (labels[indexAt(row, col)][0] == labels[indexAt(row, col+1)][0]) {
                    translate([drillD(row, col)/2 + 1,-6,0]) linear_extrude(height=1.5)
                        text(
                            str(labels[indexAt(row, col)][0], "/", labels[indexAt(row, col)][1]),
                            size=5,
                            font="Arial Narrow:style=Bold",
                            halign="center",
                            valign="bottom"
                        );
                } else {
                    linear_extrude(height=1.5)
                        text(
                            str(labels[indexAt(row, col)][0]),
                            size=5,
                            font=getFont(row, col, 0),
                            halign="center",
                            valign="bottom"
                        );
                    translate([0,-3.3,0]) linear_extrude(height=1.5)
                        text(
                            "–",
                            size=5,
                            font="Arial Narrow:style=Bold",
                            halign="center",
                            valign="bottom"
                        );
                    translate([0,-3,0]) linear_extrude(height=1.5)
                        text(
                            str(labels[indexAt(row, col)][1]),
                            size=5,
                            font=getFont(row, col, 1),
                            halign="center",
                            valign="top"
                        );

                }
                }
        }
    }

    difference() {
        hull() {
            sideWall(row, 0);
            translate([blockWid-0.1, 0, 0]) sideWall(row, heightMod);
        }
        for (col=[0:rowCounts[row] - 1]) {
            txRow(row, col) {
                // make the hole for the drill
                translate([
                    0,
                    blockThick(row) - drillD(row, col) * 0.33,
                    0
                ]) drillHole(row, col);
                translate([
                    0,
                    blockThick(row) - drillD(row, col) * 0.33,
                    3 + drillD(row, col)
                ]) drillHole(row, col);
                translate([
                    0,
                    blockThick(row) - drillD(row, col) * 0.33,
                    6 + drillD(row, col) * 2
                ]) drillHole(row, col);
            }
        }
    }
}

blockWid = 25.4 * 3 - 7;

// number drills
drillIndex = fractionsIndex;
rowCounts = [
    9,
    8
];
function drillLabel(row, col) = labels[indexAt(row, col)];
function drillHeight(row, col) = 40 + indexAt(row, col);
function yonderHeight(rw) = 25 - row * 6;
row = 1;
function blockThick(rr) = 30 + 5 * rr;
function deltaZ(rr, cc) = drillHeight(rr, cc) * 0.33;

translate([-blockWid/2,-blockThick(row),-20]) {
    doRow(row, 7);
    // translate([0,0,20]) doRow(row+1, -10);
    translate([0,blockThick(row),26]) rotate([90,90,90]) {
        translate([0,0,-3]) connectorPegs(5.5, 24.9);
        translate([0,0,blockWid + 3]) connectorPegs(5.5, 24.9);
    }
}
