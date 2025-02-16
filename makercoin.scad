$fa = 2;     //minimum angle, impacts the resolution of all shapes
$fs = 1;     //minimum polygon size, impacts the resolution of all shapes
inner_h= 6;  //height at center
rim_r=5;     //radius of rimborder
coin_r=20;   //inner coin radius
exr = 14;    //cutout radius
cut_num = 8; //number of cut outs
mode = "coin"; //thing to display ["coin","profile","body"]

if(mode == "profile") coinprofile(r=coin_r, or=rim_r, innerh=inner_h);
else if(mode == "body") 
 maker_coin_body(r=coin_r, or=rim_r, innerh=inner_h, exd=exr, n=cut_num);
 else
 maker_coin(r=coin_r, or=rim_r, innerh=inner_h, exd=exr, n=cut_num) {
     linear_extrude(height=2*rim_r, convexity=5)
         text("OS", size= 10, halign = "center", valign = "center");
 }

// r= radius of the coin- outercircle diam, inner height
module maker_coin(r=coin_r, or=rim_r, innerh=inner_h, exd=exr, n=cut_num) {
    difference() {
        maker_coin_body(r=coin_r, or=rim_r, innerh=inner_h, exd=exd, n=n);
        translate([0,0,2]) children();
    }
}

module maker_coin_body(r=coin_r, or=rim_r, innerh=inner_h, exd=exr, n=cut_num) {
  assert(n!= 0,"number of cutouts can't be 0");
    difference() {
        union() {
            rotate_extrude() {
               coinprofile(r=r, or=or, innerh=innerh);
            }
        }
        union() {
            for(w=[0:360/n:360]) rotate([0,0,w])
                translate([r+2*or,0,-.1]) cutout(r=r, or=or, exd=exd);
        }
    }
}

module coinprofile(r=coin_r, or=rim_r, innerh=inner_h)
{
  resth = 2*or-innerh;
  bigd = (r^2+resth^2)/resth; //euklidischer Höhensatz·
  tangent = 45-asin(2*r/bigd); //angles start at 90, so... not 90 but 45
  echo("tan = ",tangent);

  difference() 
  {
    union() {
      square([r, 2*or]);
      translate([r,or])circle(r=or);
    }
    translate([0,bigd/2 + innerh]) {
      circle(d = bigd);
    }
    translate([0,or]) 
    {
    translate([r-2.5,or-.5]) 
        rotate([0,0,tangent/2])
      square([5,2]);
    }
    //bevel attempt
    translate([r,2*or+1-0.3*sin(tangent)]) 
        rotate([0,0,tangent/2])
      square([5,2], center = true);
  }
  //   color("magenta")
  // translate([r,2*or+1-0.75*sin(tangent)]) 
  //     rotate([0,0,tangent/2])
  //   square([5,2], center = true);
}

module cutout(r=coin_r, or=rim_r, exd=ex) {
    rotate_extrude() {
        difference() {
            square([0.75*exd, 2*or + 2]);
            cutr = or+0.2;
            translate([exd/2+cutr,cutr-0.2])
                circle(r=cutr);
        }
    }
}
