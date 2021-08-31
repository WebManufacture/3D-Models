//
// B E L T
//
// By Sylvain Rochette (sylvain.rochette@gmail.com)
//
// Helper to generate a belt, actually you can generate 
// all types of belt (rounded type) if you know the basic values needed...
//
// Supported Modules:
//
// belt(width, length, pitch, height, teeth_height, radius)
// inverse_belt(width, length, pitch, height, teeth_height, radius)
// gt2_belt(width, length)
// inverse_gt2_belt(width, length)
//

module teeth(width, pitch, radius, inner_radius)
{
    circle(r = radius, $fn = 32);
    
    for (x = [-1, 1])
    {
        translate([x * (radius + inner_radius), 0])
        intersection()
        {
            translate([x * -inner_radius, -inner_radius])
            square([inner_radius * 2, inner_radius * 2], center = true);
            
            difference()
            {
                circle(r = inner_radius + 1, $fn = 32);

                translate([0, 0])
                circle(r = inner_radius, $fn = 32);
            }
        }
    }
}

module belt(width, length, pitch, height, teeth_height, radius)
{
    teeth_count = ceil(length / pitch) - 1;
    
    rotate([90, 0, 0])
    translate([length * -0.5, height * -0.5, 0])
    linear_extrude(height = width, center = true, convexity = 10)
    {
        // Rectangular base
        square([length, height - teeth_height]);
        
        // Teeths
        translate([0, height - radius])
        for (i = [0:teeth_count])
        {
            translate([pitch * 0.5 + i * pitch, 0])
            teeth(
                width = width, 
                pitch = pitch, 
                radius = radius, 
                inner_radius = radius * 0.4,
                teeth_height = teeth_height);
        }
    }
}

module inverse_belt(width, length, pitch, height, teeth_height, radius)
{
    difference()
    {
        translate([length * -0.5, width * -0.5, height * -0.5])
        cube([length, width, height]);
        
        rotate([180, 0, 0])
        translate([0, 0, height * -0.5])
        belt(
            width = width + 1, 
            length = length, 
            pitch = pitch, 
            height = height, 
            teeth_height = teeth_height,
            radius = radius);
    }   
}

module gt2_belt(width, length)
{
    belt(
        width = width, 
        length = length, 
        pitch = 2, 
        height = 1.52, 
        teeth_height = 0.76,
        radius = 0.555);
}

module inverse_gt2_belt(width, length)
{
    inverse_belt(
        width = width, 
        length = length, 
        pitch = 2, 
        height = 1.52, 
        teeth_height = 0.76,
        radius = 0.555);
}

//gt2_belt(5, 30);
inverse_gt2_belt(8, 26);
