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
 
use <../libraries/MCAD/involute_gears.scad>

PI = 3.141592651;

retainer_ht = 1.5;	// height of retainer flange over pulley, standard = 1.5
idler_ht = 1.5;		// height of idler flange over pulley, standard = 1.5
pulley_t_ht = 10;	// length of toothed part of pulley, standard = 12
pulley_teeth = 24;
gear_teeth = 56;
gear_thickness = 5;
gear_distance = 4;
inner_d = 8;
balls = 13;
quality = 78; //The number of segments
pulley_full_height = pulley_t_ht + idler_ht + retainer_ht;
pulley_OD = (2*((pulley_teeth*2)/(3.14159265*2)-0.254));
gear_diameter = pulley_OD/2 + 8;
// The following calls the pulley creation part, and passes the pulley diameter and tooth width to that module
union(){
    translate([0,0,gear_distance+pulley_full_height]){
      ball_bearing_inside_half(
        balls = balls, 
        height = 10,
        additional_balls_space = 0.2, 
        shaft_diameter = 6,
        additional_space = 0.5
      );
    }
    translate([0,0,pulley_full_height]){
        difference(){
            cylinder(d=pulley_OD + idler_ht*2, h=gear_distance);
            cylinder(d=inner_d, h=gear_distance);
        }
    }
    pulley (pulley_teeth, pulley_OD); 
    translate([0,0,-gear_distance]){
        difference(){
            cylinder(d= pulley_OD + idler_ht*2, h=gear_distance);
            cylinder(d=inner_d, h=gear_distance);
        }
    }
    translate([0,0,-gear_thickness - gear_distance]){
        gear (
            number_of_teeth = gear_teeth,
            circular_pitch = 360 * gear_diameter/gear_teeth,
            gear_thickness = gear_thickness,
            rim_thickness = 5,
            rim_width = 0,
            hub_diameter = 0,
            bore_diameter = inner_d
        );
    }
    translate([0,0,-gear_thickness-gear_distance-5]){

        ball_bearing_inside_half_top(
            balls = balls, 
            height = 10,
            additional_balls_space = 0.2, 
            shaft_diameter = 6,
            additional_space = 0.5
        );
    }
    
}

// Functions

// Main Module

    module pulley(p_teeth, pulley_OD)
	{
        motor_shaft = inner_d;
        additional_tooth_width = 0.2; //mm
        additional_tooth_depth = 0.6; //mm
        
        tooth_depth = 0.764;
        tooth_width = 1.494;
        echo (str("Number of teeth = ",p_teeth,"; Pulley Outside Diameter = ",pulley_OD,"mm "));
        tooth_distance_from_centre = sqrt( pow(pulley_OD/2,2) - pow((tooth_width+additional_tooth_width)/2,2));
        tooth_width_scale = (tooth_width + additional_tooth_width ) / tooth_width;
        tooth_depth_scale = ((tooth_depth + additional_tooth_depth ) / tooth_depth) ;


//	************************************************************************
//	*** uncomment the following line if pulley is wider than puller base ***
//	************************************************************************

//	translate ([0,0, pulley_b_ht + pulley_t_ht + retainer_ht ]) rotate ([0,180,0])

	difference()
	 {	 
		union()
		{
			//base
	
				
		difference()
		{
			//shaft - diameter is outside diameter of pulley
			
			translate([0,0,idler_ht]) 
			rotate ([0,0,360/(p_teeth*4)]) 
			cylinder(r=pulley_OD/2,h=pulley_t_ht, $fn=p_teeth*4);
	
			//teeth - cut out of shaft
		
			for(i=[1:p_teeth]) 
			rotate([0,0,i*(360/p_teeth)])
			translate([0,-tooth_distance_from_centre,idler_ht]) 
			scale ([ tooth_width_scale , tooth_depth_scale , 1]) 
			{
			 linear_extrude(height = pulley_t_ht+2) polygon([[0.747183,-0.5],[0.747183,0],[0.647876,0.037218],[0.598311,0.130528],[0.578556,0.238423],[0.547158,0.343077],[0.504649,0.443762],[0.451556,0.53975],[0.358229,0.636924],[0.2484,0.707276],[0.127259,0.750044],[0,0.76447],[-0.127259,0.750044],[-0.2484,0.707276],[-0.358229,0.636924],[-0.451556,0.53975],[-0.504797,0.443762],[-0.547291,0.343077],[-0.578605,0.238423],[-0.598311,0.130528],[-0.648009,0.037218],[-0.747183,0],[-0.747183,-0.5]]);
			}

		}
			
		//belt retainer / idler
		if ( retainer_ht > 0 ) {
            translate ([0,0, idler_ht+pulley_t_ht ]) 
            rotate_extrude($fn=p_teeth*4)  
            polygon([[0,0],[pulley_OD/2,0],[pulley_OD/2 + retainer_ht , retainer_ht],[0 , retainer_ht],[0,0]]);
        }
		
		if ( idler_ht > 0 ) {
            rotate_extrude($fn=p_teeth*4)  
            polygon([[0,0],[pulley_OD/2 + idler_ht,0],[pulley_OD/2 , idler_ht],[0 , idler_ht],[0,0]]);}	
		}
	   
		//hole for motor shaft
		cylinder(r=motor_shaft/2,h= pulley_t_ht + retainer_ht + 2,$fn=motor_shaft*4);
	 }
}

module ball_bearing_inside_half_top(balls, height, additional_balls_space = 0.1,inner_shift_radius = 0, shaft_diameter = 0, additional_space = 0) {
    ball_radius = 3;
    inner_shift_radius = inner_shift_radius == 0 ?  ball_radius/4 : inner_shift_radius;
    base_radius = (2*((balls*ball_radius)/(3.14159265*2)+additional_balls_space)) ;
    inside_radius = base_radius - inner_shift_radius;
    echo(str("Ball Bearing Inside diameter: ", inside_radius*2));
    difference(){
        translate([0, 0, additional_space])
        difference(){
            cylinder(r=inside_radius, h=height/2 - additional_space, $fn=quality);
            cylinder(d=shaft_diameter, h=height/2 - additional_space, $fn=16);
        }
        bearing_inner(balls, additional_balls_space);  
    } 
}

module ball_bearing_inside_half(balls, height, additional_balls_space = 0.1,inner_shift_radius = 0, shaft_diameter = 0, additional_space = 0) {
    ball_radius = 3;
    inner_shift_radius = inner_shift_radius == 0 ?  ball_radius/4 : inner_shift_radius;
    base_radius = (2*((balls*ball_radius)/(3.14159265*2)+additional_balls_space)) ;
    inside_radius = base_radius - inner_shift_radius;
    echo(str("Ball Bearing Inside diameter: ", inside_radius*2));
    translate([0, 0, height/2])
    difference(){
        translate([0, 0, -height/2])
        difference(){
            cylinder(r=inside_radius, h=height/2 - additional_space, $fn=quality);
            cylinder(d=shaft_diameter, h=height/2 - additional_space, $fn=16);
        }
        bearing_inner(balls, additional_balls_space);  
    } 
}

module ball_bearing_inside(balls, height, additional_balls_space = 0.1,inner_shift_radius = 0, shaft_diameter = 0) {
    ball_radius = 3;
    inner_shift_radius = inner_shift_radius == 0 ?  ball_radius/4 : inner_shift_radius;
    base_radius = (2*((balls*ball_radius)/(3.14159265*2)+additional_balls_space)) ;
    inside_radius = base_radius - inner_shift_radius;
    echo(str("Ball Bearing Inside diameter: ", inside_radius*2));
    difference(){
        translate([0, 0, -height/2]) 
        difference(){
            cylinder(r=inside_radius, h=height, $fn=quality);
            cylinder(d=shaft_diameter, h=height, $fn=16);
        }
        bearing_inner(balls, additional_balls_space);  
    } 
}

module ball_bearing_outside(balls, height, additional_balls_space = 0.1, additional_radius = 2, inner_shift_radius = 0) {
    ball_radius = 3;
    inner_shift_radius = inner_shift_radius == 0 ?  ball_radius/4 : inner_shift_radius;
    base_radius = (2*((balls*ball_radius)/(3.14159265*2)+additional_balls_space)) ;
    outside_radius = base_radius + ball_radius + additional_radius;
    echo(str("Ball Bearing Outside diameter: ", outside_radius*2));
    difference(){
        difference(){
            translate([0, 0, -height/2]) 
            cylinder(r=outside_radius, h=height, $fn=quality);
            bearing_inner(balls, additional_balls_space);  
        } 
        translate([0, 0, -height/2])   
        cylinder(r=base_radius+inner_shift_radius, h=height, $fn=quality);
    }
}

module ball_bearing_pad(balls, height, additional_balls_space = 0.1, additional_radius = 2) {
    ball_radius = 3;
    balls_spacing = (2*((balls*ball_radius)/(3.14159265*2)+additional_balls_space)) ;
    inside_radius = balls_spacing - ball_radius - additional_radius;
    outside_radius = balls_spacing + ball_radius + additional_radius;
    echo(str("Inside radius: ", inside_radius));
    echo(str("Outside radius: ", outside_radius));
    difference(){
        cylinder(r=outside_radius, h=height, $fn=quality);
        bearing_inner(balls, additional_balls_space);  
    }    
}

module balls_in_bearing(balls, additional_space=0.1) {   
  ball_radius = 3;
  balls_spacing = (2*((balls*ball_radius)/(3.14159265*2)+additional_space)) ;
  base_radius = balls_spacing;
  pi = 3.14159265;
  dTheta = 2*pi/balls;
  for (theta = [0:dTheta:pi*2]) {
    translate([base_radius*cos(theta*180/pi), base_radius*sin(theta*180/pi),0]) sphere(r=ball_radius, h=belt_width, $fn=24);
  }
}

module bearing_inner(balls, additional_space = 0.1) {   
  ball_radius = 3;
  balls_spacing = (2*((balls*ball_radius)/(3.14159265*2)+additional_space)) ;
  inside_radius = balls_spacing - ball_radius;
  outside_radius = balls_spacing + ball_radius;
  Torus(ball_radius, balls_spacing);
}

module Torus(r_inner, r_outer){
    RA=r_inner;           // Radius   of  Torus
    RB=r_outer;     // Radius   of  Torus overall     
    rotate_extrude(convexity = 10, $fn = quality) // the value is the sides the finer
    translate([RB, 0, 0])
    circle(r = RA, $fn = quality); // the value is the sides
}


