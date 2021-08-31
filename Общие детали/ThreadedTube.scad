include <C:\_WM\3D\Threads.scad>;
/* [main] */

// The length of the auger
height=100;

// How big the outside of the auger will be
outer_dia=60;

// How big the inside of the auger will be
inner_dia=48;

// How thick the auger paddles will be (useful for creating ACME threaded rods!)
thread_thickness=10;

// How thick the auger paddles will be (useful for creating ACME threaded rods!)
thread_step=10;

// How thick the auger paddles will be (useful for creating ACME threaded rods!)
thread_count=4;

// How thick the auger paddles will be (useful for creating ACME threaded rods!)
thread_form = "circle";


/* [hidden] */
pi=3.14159265358979323846264338327950288;

module thread(diameter){
	minimalStep = thread_step/360;
    union() {
        for(n=[0:thread_step:height]){
            translate([0,0,n]) intersection() for(angle=[0:2:360]){
                rotate([0,0,angle]) {
                     translate([diameter/2,0,angle*minimalStep]){
                        sphere(d = thread_thickness);
                        // cube(size = [thread_thickness, thread_thickness, thread_thickness]);
                     }
                }
            }
        }
    }
}

module tubeThreaded(){

            thread(inner_dia);
    }
    
module tubeThreadedModule(){
	difference() {
        cylinder(r=outer_dia/2,h=height);
        cylinder(r=inner_dia/2,h=height);
        metric_thread(
            diameter = inner_dia + (outer_dia - inner_dia)/2,
            pitch = thread_step,
            thread_size = thread_thickness,
            length = height,
            groove = true,
            internal = true
        );
    }
}

/*
linear_extrude(height = 10, center = false, convexity = 10, twist = 360, slices = 100)
translate([inner_dia/2, 0, 0])
circle(r = thread_thickness/2, $fn=25);
*/

tubeThreadedModule();