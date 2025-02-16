include <BOSL2/std.scad>
include <BOSL2/isosurface.scad> 

h1  = 10;
r1 = 25;
r2 = 5;
d1 = r1 * 2;

isovalue = 1;
voxel_size = 0.5;

infl = 0.2;
cut  = 10;

function  tmat(ang) = move(cylindrical_to_xyz(r1,ang,0));  

difference() {
    metaballs([
        IDENT, mb_disk(h1,r1),
        up(r1-2),  mb_sphere(r1*4, influence = 1,  negative = true, cutoff = r1+2),
        
	for (ang = [0:45:315])
            each [tmat(ang),   mb_sphere(r2, influence = infl, negative = true, cutoff = cut)]
    ], 
        voxel_size, [[-d1,-d1,-h1], [d1,d1,h1]], isovalue);

    text3d(h = h1/2, "BOSL2", size = 4, center = true);  
} 
