	//difference ()
	//	intersection ()
		//	union()
			//	rotate (half_thick_angle)
				//translate ([0,0,pitch_apex-apex_to_apex])
				//cylinder ($fn=number_of_teeth*2, r1=root_cone_full_radius,r2=0,h=apex_to_apex);
				//for (i = [1:number_of_teeth])   
 d_inner = 5.1;
 d_outer = 15; 
 height=20;
 thread_start_space=1;
 thread_space=1;
 thread_deep=1;
 thread_height=2;
 number_of_threads=6;
 difference(){
      cylinder (d=d_outer,h=height);   
      cylinder (d=d_inner,h=height);
      for (i = [0:number_of_threads-1]){
          translate([0,0,i*(thread_height+thread_space)+thread_start_space]){
            thread(d_outer/2-thread_deep,d_outer/2, thread_height);
          }
      }
 }

module thread(  r_inner=9, 
                r_outer=10,
                h=2
 ){
  difference(){
      cylinder (d=r_outer*2,h=h);
      cylinder (r1=r_outer,r2=r_inner,h=h/2);
        translate ([0,0,h/2]){
            cylinder (r1=r_inner,r2=r_outer,h=h/2);
        }       
    }

}