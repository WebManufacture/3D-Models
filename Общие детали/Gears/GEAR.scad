use <../libraries/MCAD/involute_gears.scad>

//test_gears();
//Gear();

pressure_angle = 25; //Normal - 28
hub_diameter = 0;
rim_width=0;
circles=0;
teeth=20;
pitch_diameter=25;
twist=0;
height=5;
bore_diameter = 6;

gear (number_of_teeth=teeth,
    diametral_pitch=teeth/pitch_diameter,
    pressure_angle=pressure_angle,
    clearance = 0.2,
    gear_thickness = height,
    rim_thickness = height,
    rim_width = rim_width,
    hub_thickness = height*2,
    hub_diameter = hub_diameter,
    bore_diameter = bore_diameter,
    circles=circles,
    twist = twist/teeth);

module SmoothHole() {
    translate([6.5,0,-1]) cylinder(r=1.5, h=10, $fn=6);
}

module WadeL_double_helix(){
	//Large WADE's Gear - Double Helix

	pressure_angle=30;
    hub_diameter = 0;
    rim_width = 0;
	circles=0;
	teeth=30;
	pitch=200;
	twist=250;
	height=40;
    bore_diameter = 4;

	difference(){
		union(){
		// половина шевронной шестерни
		gear (number_of_teeth=teeth,
			circular_pitch=pitch,
			pressure_angle=pressure_angle,
			clearance = 0.2,
			gear_thickness = height/2,
			rim_thickness = height/2,
			rim_width = rim_width,
			hub_thickness = height/2*1.5-2-1.5,
			hub_diameter = hub_diameter,
			bore_diameter = bore_diameter,
			circles=circles,
			twist = twist/teeth);
		// вторая половина шевронной шестерни
		mirror([0,0,50])
		gear (number_of_teeth=teeth,
			circular_pitch=pitch,
			pressure_angle=pressure_angle,
			clearance = 0.2,
			gear_thickness = height/2,
			rim_thickness = height/2,
			rim_width = rim_width,
			hub_thickness = height/2,
			hub_diameter=hub_diameter,
			bore_diameter=bore_diameter,
            circles=circles,
			twist=twist/teeth);
		}
	}
}

module Gear(){
	//Large WADE's Gear - Double Helix

	pressure_angle=30;
    hub_diameter = 0;
    rim_width = 0;
	circles=0;
	teeth=16;
	pitch=200;
	twist=0;
	height=5;
    bore_diameter = 4.1;

    gear (number_of_teeth=teeth,
        circular_pitch=pitch,
        pressure_angle=pressure_angle,
        clearance = 0.2,
        gear_thickness = height,
        rim_thickness = height,
        rim_width = rim_width,
        hub_thickness = height,
        hub_diameter = hub_diameter,
        bore_diameter = bore_diameter,
        circles=circles,
        twist = twist/teeth);
}