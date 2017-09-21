//odleglosc sruby kola 15mm
//poczatek otworu na silnik od strony uchwytu kola 45mm
//koniec 105
//min szerokosc 6mm
//max szertokosc 16mm
width=34; //koncowka od strony kola
length=105;
top_width=60;
height=4;

difference() {
    union() {
        cylinder(d=width, h=height, $fn=128);
        linear_extrude(height=height)
            polygon(points=[[0,-width/2], [length,(-top_width/2)], [length,(top_width/2)] , [0,width/2]]);
    }

    translate([0,0,-0.1]) cylinder(d=9, h=height+0.2, $fn=128);
    
    translate([35,0,-0.1]) cylinder(d=8, h=height+0.2, $fn=128);

    translate([75,0,-0.1]) rotate([0,0,0]) union() {
        cylinder(d=32, h=height+0.2, $fn=128);
        for (i=[0:120:360]) {
            rotate([0,0,i]) translate([21, 0, 0]) cylinder(d=5, h=height+0.2, $fn=128);
        }
    }
}

//#translate([30,0,-0.1]) linear_extrude(height=3.2)
//                polygon(points=[[0,-3], [60,-8], [60,8], [0,3]]);
