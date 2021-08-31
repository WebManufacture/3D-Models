use <pegboard connector female.scad>;
numberIndex = [
    1.02, // 60
    1.04, // 59
    1.07, // 58
    1.09, // 57
    1.18, // 56
    1.32, // 55
    1.40, // 54
    1.51, // 53
    1.61, // 52
    1.70, // 51
    1.78, // 50
    1.85, // 49
    1.93, // 48
    1.99, // 47
    2.06, // 46
    2.08, // 45
    2.18, // 44
    2.26, // 43
    2.38, // 42
    2.44, // 41
    2.49, // 40
    2.53, // 39
    2.58, // 38
    2.64, // 37
    2.71, // 36
    2.79, // 35
    2.82, // 34
    2.87, // 33
    2.95, // 32
    3.05, // 31
    3.26, // 30
    3.45, // 29
    3.57, // 28
    3.66, // 27
    3.73, // 26
    3.80, // 25
    3.86, // 24
    3.91, // 23
    3.99, // 22
    4.04, // 21
    4.09, // 20
    4.22, // 19
    4.31, // 18
    4.39, // 17
    4.50, // 16
    4.57, // 15
    4.62, // 14
    4.70, // 13
    4.80, // 12
    4.85, // 11
    4.92, // 10
    4.98, // 9
    5.06, // 8
    5.11, // 7
    5.18, // 6
    5.22, // 5
    5.31, // 4
    5.41, // 3
    5.61, // 2
    5.79 // 1
];
letterIndex = [
    5.94, // A
    6.05, // B
    6.15, // C
    6.25, // D
    6.35, // E
    6.53, // F
    6.63, // G
    6.76, // H
    6.91, // I
    7.04, // J
    7.14, // K
    7.37, // L
    7.49, // M
    7.67, // N
    8.03, // O
    8.20, // P
    8.43, // Q
    8.61, // R
    8.84, // S
    9.09, // T
    9.35, // U
    9.58, // V
    9.80, // W
    10.08, // X
    10.26, // Y
    10.49 // Z
];

function sumv(v,i,s=0) = (i < 0 ? 0 : (i==s ? v[i] : v[i] + sumv(v,i-1,s)));
function indexAt(row, col) = (row > 0 ? sumv(rowCounts, row - 1) + col : col);

function drillD(row, col) = 1 + drillIndex[indexAt(row, col)];
function height(row) = 20 + row * 10;
function width(row) = (blockWid - 1) / rowCounts[row];
function rowOffsetY(row) =  -blockThick(row) * (row - 1);
function _dz(row, offY = 0) = deltaZ(row, lastCol(row)) * (offY + blockThick(row)) / drillHeight(row, lastCol(row));
function _dd(row) = drillD(row, lastCol(row));
function lastCol(row) = rowCounts[row] - 1;
module sideWall(row) {
    _drillD = _dd(row);
    farHeight = _drillD + 9;
    hull() {
        translate([0,0,3]) cube([0.1, 1, 1 + _drillD]);
        translate([
            0,
            blockThick(row) - 1,
            -farHeight/2 + _drillD/2 + _dz(row)
        ]) cube([0.1, 1, farHeight]);

    }
}
module getBlock(row) {
    difference() {
        hull() {
            sideWall(row);
            translate([blockWid-0.1, 0, 0]) sideWall(row);
        }
        translate([
            0.5,
            blockThick(row)-0.5,
            _dz(row) - _dd(row)/2 - 2
        ]) cube([blockWid-1, 1, 6.5]);
}
}
module getDrills(row) {
    for (col=[0:rowCounts[row] - 1]) {
        translate([
            (col + 0.5) * width(row) + (col > 0 ? 1 * ((col - rowCounts[row])/rowCounts[row]) : 0),
            0,
            0
        ]) {
            // make the hole for the drill
            translate([
                0,
                2.5,
                6
            ]) rotate([
                -90 + atan2(
                    deltaZ(row, col),
                    (drillHeight(row, col) - 2)
                ),
                0,
                0
            ]) rotate([0,0,22.5]) cylinder(
                d=drillD(row, col),
                $fn=12,
                h=drillHeight(row, col),
                center=false
            );
        }
    }
}

blockWid = 25.4 * 4 - 7;

// number drills
drillIndex = numberIndex;
rowCounts = [
    20,
    16,
    13,
    11
];
function drillHeight(row, col) = 40 + indexAt(row, col);
row = 0;
function blockThick(rr) = max( 15, drillHeight(rr, 0) * 0.285 );
function deltaZ(rr, cc) = drillHeight(rr, cc) * 0.4;

// letter drills
/*drillIndex = letterIndex;
function drillHeight(row, col) = 100 + 1.2 * indexAt(row, col);
rowCounts = [
    10,
    9,
    7
];
deltaZ = 50;
row = 2;*/

// 1-24, T-Z
rotate([0,0,180]) translate([-blockWid/2,0,-20]) {
    difference() {
        union() {
            getBlock(row);
            translate([0,0,_dz(row, 20)]) getBlock(row+1);
            translate([0,0,6]) cube([blockWid, blockThick(row) * 0.8, 19]);
        }
        getDrills(row);
        translate([0,0,_dz(row, 20)]) getDrills(row + 1);
    }
    translate([0,5.5,28]) rotate([90,90,90]) {
        translate([0,0,-3]) connectorPegs(5.5, 24.9);
        translate([0,0,blockWid + 3]) connectorPegs(5.5, 24.9);
    }
}
