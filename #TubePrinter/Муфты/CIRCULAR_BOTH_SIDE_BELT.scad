// Belt parameters
belt_width = 6;                    // width of the belt, typically 6 (mm)     
tooth_radius = 0.8;                // belt tooth radius, 0.8 for GT2 (mm)

$fn = 40;

teeth_inner = 60;
teeth_outer = 63;
inside_radius = tooth_spacing(teeth_inner)/2;
outside_radius = tooth_spacing(teeth_outer)/2;

dTheta_inside = 2/inside_radius;
dTheta_outside = 2/outside_radius;
pi = 3.14159;

echo (str("INNER teeth = ",teeth_inner,"; Inside Diameter = ", inside_radius*2,"mm "));
echo (str("OUTER teeth = ",teeth_outer,"; Outside Diameter = ", outside_radius*2,"mm "));
  
union(){
  difference() {
    cylinder(r=outside_radius, h=belt_width, $fn=pi*2/dTheta_outside);
    cylinder(r=inside_radius, h=belt_width, $fn=pi*2/dTheta_inside);
  };
  belt_outset(teeth_outer, 0.2);
  belt_inset(teeth_inner, 0);
}



function tooth_spacing(teeth)
	= (2*((teeth*2)/(3.14159265*2)-0.254)) ;

module belt_inset(teeth, additional_tooth_depth = 0) {
  // Belt paths
    pulley_OD = tooth_spacing(teeth);
    tooth_depth = 0.764;
    tooth_width = 1.494;
    additional_tooth_width = 0;
	tooth_distance_from_centre = sqrt( pow(pulley_OD/2,2) - pow((tooth_width+additional_tooth_width)/2,2));
	tooth_width_scale = (tooth_width + additional_tooth_width ) / tooth_width;
	tooth_depth_scale = ((tooth_depth + additional_tooth_depth ) / tooth_depth) ;
    
  for(i=[1:teeth]) 
			rotate([0,0,i*(360/teeth)])
			translate([0,-tooth_distance_from_centre,0]) 
			scale ([ tooth_width_scale , tooth_depth_scale , 1 ]) 
			{
        linear_extrude(height=belt_width) polygon([[0.747183,-0.5],[0.747183,0],[0.647876,0.037218],[0.598311,0.130528],[0.578556,0.238423],[0.547158,0.343077],[0.504649,0.443762],[0.451556,0.53975],[0.358229,0.636924],[0.2484,0.707276],[0.127259,0.750044],[0,0.76447],[-0.127259,0.750044],[-0.2484,0.707276],[-0.358229,0.636924],[-0.451556,0.53975],[-0.504797,0.443762],[-0.547291,0.343077],[-0.578605,0.238423],[-0.598311,0.130528],[-0.648009,0.037218],[-0.747183,0],[-0.747183,-0.5]]);
    }
}


module belt_outset(teeth, additional_tooth_depth = 0) {
  // Belt paths
    pulley_OD = tooth_spacing(teeth);
    tooth_depth = 0.764;
    tooth_width = 1.494;
    additional_tooth_width = 0;
	tooth_distance_from_centre = sqrt( pow(pulley_OD/2,2) - pow((tooth_width+additional_tooth_width)/2,2));
	tooth_width_scale = (tooth_width + additional_tooth_width ) / tooth_width;
	tooth_depth_scale = ((tooth_depth + additional_tooth_depth ) / tooth_depth) ;
    
  for(i=[1:teeth]) 
			rotate([0,0,i*(360/teeth)])
			translate([0,-tooth_distance_from_centre,0]) 
			scale ([ tooth_width_scale , tooth_depth_scale , 1 ]) 
			{
        linear_extrude(height=belt_width) {
            rotate([0,0,180])
            polygon([[0.747183,-0.5],[0.747183,0],[0.647876,0.037218],[0.598311,0.130528],[0.578556,0.238423],[0.547158,0.343077],[0.504649,0.443762],[0.451556,0.53975],[0.358229,0.636924],[0.2484,0.707276],[0.127259,0.750044],[0,0.76447],[-0.127259,0.750044],[-0.2484,0.707276],[-0.358229,0.636924],[-0.451556,0.53975],[-0.504797,0.443762],[-0.547291,0.343077],[-0.578605,0.238423],[-0.598311,0.130528],[-0.648009,0.037218],[-0.747183,0],[-0.747183,-0.5]]);
        }
    }
}