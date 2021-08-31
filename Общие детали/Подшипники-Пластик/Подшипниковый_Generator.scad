balls = 9;
quality = 78; //The number of segments
height = 10;

/*
difference() {
  ball_bearing_pad(balls=16,height=5);
  cylinder(r=15/2, h=5);
}*/
/*
ball_bearing_outside(
    balls = balls, 
    height = height,
    additional_balls_space = 0.2, 
    additional_radius = 3
  );
*/
ball_bearing_inside_half(
    balls = balls, 
    height = height,
    additional_balls_space = 0.2, 
    shaft_diameter = 8,
    additional_space = 0.5
  );

/*  
union(){
  difference() {
      difference() {
        cylinder(r=outside_radius, h=belt_width,$fn=balls);
        cylinder(r=inside_radius, h=belt_width,$fn=balls);
      };
      ball_bearing(inside_radius+(outside_radius-inside_radius)/2);
  }
}
*/

module ball_bearing_inside_half(balls, height, additional_balls_space = 0.1,inner_shift_radius = 0, shaft_diameter = 0, additional_space = 0) {
    ball_radius = 3;
    inner_shift_radius = inner_shift_radius == 0 ?  ball_radius/4 : inner_shift_radius;
    echo(str("inner_shift_radius:", inner_shift_radius));
    base_radius = (2*((balls*ball_radius)/(3.14159265*2)+additional_balls_space)) ;
    inside_radius = base_radius - inner_shift_radius;
    echo(str("Inside radius:", inside_radius));
    difference(){
        translate([0, 0, additional_space])
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
    echo(str("inner_shift_radius:", inner_shift_radius));
    base_radius = (2*((balls*ball_radius)/(3.14159265*2)+additional_balls_space)) ;
    inside_radius = base_radius - inner_shift_radius;
    echo(str("Inside radius:", inside_radius));
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
    echo(str("Outside radius:", outside_radius));
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
    echo(str("Inside radius:", inside_radius));
    echo(str("Outside radius:", outside_radius));
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