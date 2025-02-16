//Maker token by Raymond West

scd =14;  //radius of cylindrical notch
fr=2; // radius of fillet
bit=0.1; // for small differances.  to fudge lines the smaller more accurate
md=10; // diameter of cross section of 'outer ring'
mh =6 ; // height of  centre 
cd =20; // diameter of circle of outer rings
cpn = 55; //diameter of ring for centre point for notches
n=8; //number of notches;
ts=8; //textsize

//$fn=30;
$fs=1;
//$fa=10;


/////////////////////////////////////////////////

module profile(){
   //  $fn=90;
       square([cd,mh]);
      square (17.8);  // need to calculate
      translate([cd, md/2]) circle(d=md);
}
//profile();

module profile2(){
//$fn=90;
square([mh+mh,mh]);
   difference(){
      profile();
      translate ([0,53.14]) circle(r=47.15); // need to calculate
    }  
      translate([-fr,0])square([fr+fr,mh]);
 }
//profile2();

module smallprofile(){  //profile2 less fr, for use with miskowski notching
  //   $fn=90;
     offset(r=-fr) profile2();
 //  translate([0,fr]) square([fr+fr,mh-fr-fr]);
}
//#smallprofile();
/*
module shape(){
    rotate_extrude(convexity=10)profile2();
}
 //#shape();
  */
 module smallshape(){
      rotate_extrude(convexity=md/2)smallprofile();
  }
//smallshape();
  
  module notchmin(){
    translate([cpn/2,0,0])cylinder (h=cd,d=scd+fr+fr);
  }

  module notchesmin(){
   for (j=[0:360/n:360])
        rotate([0,0,j]) notchmin(); 
  }
  
  module b4min(){
       difference(){
        smallshape();
        notchesmin();
     }
  }
  
  module coin(){
    minkowski(){
      b4min();
       sphere(fr);
      }
}
 
 //coin();
 
 module emboss(){
  translate([0,0,mh-1])  linear_extrude(10) text("RW",halign= "center",valign="center", size=ts);
 }
 
 module done(){
     difference(){
       coin();
       emboss();
    }
 }
 
done();
 
