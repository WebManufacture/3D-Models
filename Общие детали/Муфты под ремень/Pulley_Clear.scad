// Parametric clear Pulley
// by Semchenkov Alexander

// tuneable constants

pulley_dia = 8;
shaft_dia = 6;// NEMA17 motor shaft exact diameter = 5
height = 8;   // length of toothed part of pulley, standard = 12

retainer = 0.5;     // Belt retainer above teeth, 0 = No, 1 = Yes
retainer_ht = 1;   // height of retainer flange over pulley, standard = 1.5
idler = 0.5;            // Belt retainer below teeth, 0 = No, 1 = Yes
idler_ht = 1;     // height of idler flange over pulley, standard = 1.5

base_ht = 0;    
base_dia = 0; // pulley base diameter, standard = 20; 0 for Auto

pulley();

module pulley(){
     y = 0;
     fn = pulley_dia*8;
    
     difference(){
         union(){
            cylinder(d=pulley_dia,h=height+base_ht+retainer_ht+idler_ht, $fn=fn);
            //base
            if ( base_ht > 0 ){
                if ( base_dia == 0 ) {
                    cylinder(d=pulley_dia + 2*idler,h=base_ht, $fn=fn);
                } else {
                    cylinder(d=base_dia,h=base_ht, $fn=fn);
                }
            }
           
            //belt retainer / idler
            if ( idler > 0 ) {
                translate ([0,0,base_ht]) 
                    rotate_extrude($fn=fn)  
                        polygon([[0,0],[pulley_dia/2+idler_ht,0],[pulley_dia/2 , idler_ht],[0 , idler_ht],[0,0]]);
            }
            
            if ( retainer > 0 ) {
                translate ([0,0,base_ht+idler_ht+height]) 
                    rotate_extrude($fn=fn)  
                        polygon([[0,0],[pulley_dia/2,0],[pulley_dia/2+retainer_ht, retainer_ht],[0 , retainer_ht],[0,0]]);
            }
        }

        translate([0,0,0]) 
        cylinder(d=shaft_dia,h=height+base_ht+retainer_ht+idler_ht, $fn=fn);
    }
 }