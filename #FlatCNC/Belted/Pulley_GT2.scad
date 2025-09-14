// Parametric Pulley with multiple belt profiles
// by droftarts January 2012

// Based on pulleys by:
// http://www.thingiverse.com/thing:11256 by me!
// https://github.com/prusajr/PrusaMendel by Josef Prusa
// http://www.thingiverse.com/thing:3104 by GilesBathgate
// http://www.thingiverse.com/thing:2079 by nophead

// dxf tooth data from http://oem.cadregister.com/asp/PPOW_Entry.asp?company=915217&elementID=07807803/METRIC/URETH/WV0025/F
// pulley diameter checked and modelled from data at http://www.sdp-si.com/D265/HTML/D265T016.html

/**
 * @name Pulley
 * @category Printed
 * @using 1 x m3 nut, normal or nyloc
 * @using 1 x m3x10 set screw or 1 x m3x8 grub screw
 */

teeth = 24;			// Number of teeth, standard Mendel T5 belt = 8, gives Outside Diameter of 11.88mm
profile = 12;		// 1=MXL 2=40DP 3=XL 4=H 5=T2.5 6=T5 7=T10 8=AT5 9=HTD_3mm 10=HTD_5mm 11=HTD_8mm 12=GT2_2mm 13=GT2_3mm 14=GT2_5mm

motor_shaft = 5.3;	// NEMA17 motor shaft exact diameter = 5

retainer = 1;		// Belt retainer above teeth, 0 = No, 1 = Yes
retainer_ht = 1;	// height of retainer flange over pulley, standard = 1.5
idler = 1;			// Belt retainer below teeth, 0 = No, 1 = Yes
idler_ht = 1;		// height of idler flange over pulley, standard = 1.5

pulley_t_ht = 15;	// length of toothed part of pulley, standard = 12
pulley_b_ht = 8;		// pulley base height, standard = 8. Set to same as idler_ht if you want an idler but no pulley.
pulley_shaft_dia = 6.5;
pulley_b_dia = 0;	// pulley base diameter, standard = 20; 0 for Auto
no_of_nuts = 0;		// number of captive nuts required, standard = 1 can be negative.

additional_tooth_width = 0.2; //mm
additional_tooth_depth = 0.6; //mm

// The following set the pulley diameter for a given number of teeth
GT2_2mm_pulley_dia = tooth_spacing (2,0.254);
// The following calls the pulley creation part, and passes the pulley diameter and tooth width to that module
pulley ( "GT2 2mm" , GT2_2mm_pulley_dia , 0.764 , 1.494 ); 

// Functions

function tooth_spaceing_curvefit (b,c,d)
	= ((c * pow(teeth,d)) / (b + pow(teeth,d))) * teeth ;

function tooth_spacing(tooth_pitch,pitch_line_offset)
	= (2*((teeth*tooth_pitch)/(3.14159265*2)-pitch_line_offset)) ;

// Main Module

module pulley( belt_type , pulley_OD , tooth_depth , tooth_width )
	{
	echo (str("Belt type = ",belt_type,"; Number of teeth = ",teeth,"; Pulley Outside Diameter = ",pulley_OD, "mm "));
	tooth_distance_from_centre = sqrt( pow(pulley_OD/2,2) - pow((tooth_width+additional_tooth_width)/2,2));
	tooth_width_scale = (tooth_width + additional_tooth_width ) / tooth_width;
	tooth_depth_scale = ((tooth_depth + additional_tooth_depth ) / tooth_depth) ;


//	************************************************************************
//	*** uncomment the following line if pulley is wider than puller base ***
//	************************************************************************

//	translate ([0,0, pulley_b_ht + pulley_t_ht + retainer_ht ]) rotate ([0,180,0])
        
    difference(){
		union()
		{
			//base
	
			if ( pulley_b_ht < 1 ) { echo ("CAN'T DRAW PULLEY BASE, HEIGHT LESS THAN 2!!!"); } else {
                difference(){
                    cylinder(d=pulley_OD + idler_ht*2*idler,h=pulley_b_ht, $fn=teeth*4);
                    translate([0,0,0]) 
                    cylinder(d=pulley_shaft_dia,h=pulley_b_ht, $fn=teeth*4);
                }
			}
	
		difference()
			{
			//shaft - diameter is outside diameter of pulley
			translate([0,0,pulley_b_ht]) 
			rotate ([0,0,360/(teeth*4)]) 
			cylinder(r=pulley_OD/2,h=pulley_t_ht, $fn=teeth*4);
	
			//teeth - cut out of shaft
		
			for(i=[1:teeth]) 
			rotate([0,0,i*(360/teeth)])
			translate([0,-tooth_distance_from_centre,pulley_b_ht -1]) 
			scale ([ tooth_width_scale , tooth_depth_scale , 1 ]) 
			{
			if ( profile == 1 ) { MXL();}
			if ( profile == 2 ) { 40DP();}
			if ( profile == 3 ) { XL();}
			if ( profile == 4 ) { H();}
			if ( profile == 5 ) { T2_5();}
			if ( profile == 6 ) { T5();}
			if ( profile == 7 ) { T10();}
			if ( profile == 8 ) { AT5();}
			if ( profile == 9 ) { HTD_3mm();}
			if ( profile == 10 ) { HTD_5mm();}
			if ( profile == 11 ) { HTD_8mm();}
			if ( profile == 12 ) { GT2_2mm();}
			if ( profile == 13 ) { GT2_3mm();}
			if ( profile == 14 ) { GT2_5mm();}
			}

			}
			
		//belt retainer / idler
		if ( retainer > 0 ) {translate ([0,0, pulley_b_ht + pulley_t_ht ]) 
		rotate_extrude($fn=teeth*4)  
		polygon([[0,0],[pulley_OD/2,0],[pulley_OD/2 + retainer_ht , retainer_ht],[0 , retainer_ht],[0,0]]);}
		
		if ( idler > 0 ) {translate ([0,0, pulley_b_ht]) 
		rotate_extrude($fn=teeth*4)  
		polygon([[0,0],[pulley_OD/2 + idler_ht,0],[pulley_OD/2 , idler_ht],[0 , idler_ht],[0,0]]);}
	
	}
	   
		//hole for motor shaft
		translate([0,0,pulley_b_ht])cylinder(r=motor_shaft/2,h = pulley_t_ht + retainer_ht + 2,$fn=motor_shaft*4);
 }
 }
	  


module GT2_2mm()
	{
	linear_extrude(height=pulley_t_ht+2) polygon([[0.747183,-0.5],[0.747183,0],[0.647876,0.037218],[0.598311,0.130528],[0.578556,0.238423],[0.547158,0.343077],[0.504649,0.443762],[0.451556,0.53975],[0.358229,0.636924],[0.2484,0.707276],[0.127259,0.750044],[0,0.76447],[-0.127259,0.750044],[-0.2484,0.707276],[-0.358229,0.636924],[-0.451556,0.53975],[-0.504797,0.443762],[-0.547291,0.343077],[-0.578605,0.238423],[-0.598311,0.130528],[-0.648009,0.037218],[-0.747183,0],[-0.747183,-0.5]]);
	}