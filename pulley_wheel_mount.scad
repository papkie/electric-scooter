supports=5;
m5_distance=30;
base_height=5;
support_height=32;

module pie_slice(r=3.0, h=10, a=30) {
  $fn=128;
  intersection() {
    cylinder(r=r, h=h, center=true);
    translate([0,0,-1*(h/2)]) cube([r,r,h + 0.1]);
    translate([0,0,-1*(h/2)]) rotate(a-90) cube([r,r,h + 0.1]);
  }
}

difference() {
    union() {
        translate([0, 0, base_height/2]) cylinder(r=m5_distance+10, h=base_height, center=true, $fn=128);
        for (i=[0:(360/supports):360]) {
            translate([0, 0, (support_height/2)+base_height]) {
                rotate([0,0,i-10]) translate([15,0,0]) pie_slice(r=25,h=support_height,a=50);
            }
        }
    }
    translate([0, 0, (base_height+support_height)/2]) union() {
        for (i=[0:(360/supports):360]) {
            rotate([0,0,i]) {
                translate([m5_distance, 0, 0]) {
                    cylinder(r=2.5, h=base_height+0.1+support_height, center=true);
                }
            }
        }
    }

    translate([0, 0, (base_height+support_height)/2]) cylinder(r=25, h=base_height+support_height+0.1, center=true);
}