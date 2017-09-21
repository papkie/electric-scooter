//odleglosc sruby kola 15mm
//poczatek otworu na silnik od strony uchwytu kola 45mm
//koniec 105
//min szerokosc 6mm
//max szertokosc 16mm
width=34; //koncowka od strony kola
length=125;
top_width=50;

difference() {
    union() {
        cylinder(d=width, h=3, $fn=128);
        linear_extrude(height=3)
            polygon(points=[[0,-width/2], [length,(-top_width/2)], [length,(top_width/2)] , [0,width/2]]);
    }

    translate([0,0,-0.1]) cylinder(d=9, h=3.2, $fn=128);

    translate([30,0,-0.1]) linear_extrude(height=3.2)
                polygon(points=[[0,-3], [60,-8], [60,8], [0,3]]);
}