teeth = 80; // Number of teeth, standard Mendel T5 belt = 8, gives Outside Diameter of 11.88mm

motor_shaft = 8.5; // NEMA17 motor shaft exact diameter = 5
m3_dia = 3.2; // 3mm hole diameter
m3_nut_hex = 1; // 1 for hex, 0 for square nut
m3_nut_flats = 5.7; // normal M3 hex nut exact width = 5.5
m3_nut_depth = 2.7; // normal M3 hex nut exact depth = 2.4, nyloc = 4

retainer = 1; // Belt retainer above teeth, 0 = No, 1 = Yes
retainer_ht = 1.5; // height of retainer flange over pulley, standard = 1.5
idler = 1; // Belt retainer below teeth, 0 = No, 1 = Yes
idler_ht = 1.5; // height of idler flange over pulley, standard = 1.5

pulley_t_ht = 12; // length of toothed part of pulley, standard = 12
pulley_b_ht = 1.5; // pulley base height, standard = 8. Set to same as idler_ht if you want an idler but no pulley.
pulley_b_dia = 20; // pulley base diameter, standard = 20
no_of_nuts = 1; // number of captive nuts required, standard = 1
nut_angle = 90; // angle between nuts, standard = 90
nut_shaft_distance = 1.2; // distance between inner face of nut and shaft, can be negative.

additional_tooth_width = 0.2; //mm

additional_tooth_depth = 0; //mm


nut_elevation = pulley_b_ht / 2;
m3_nut_points = 2 * ((m3_nut_flats / 2) / cos(30)); // This is needed for the nut trap

// m5_nut
m5_nut_number=5;
m5_diameter=5;
m5_distance=30;
m5_nut_diameter=8;
m5_nut_depth=2;

HTD_3mm_pulley_dia = tooth_spacing(3, 0.381);
difference() {
  pulley("HTD 3mm", HTD_3mm_pulley_dia, 1.289, 2.27);
  for(i=[1:m5_nut_number]) {
    union() {
      translate([m5_distance*cos(i*(360/m5_nut_number)), m5_distance*sin(i*(360/m5_nut_number)), 0])
        rotate([0, 0, 360/m5_nut_number])
        cylinder(r = m5_nut_diameter / 2, h = m5_nut_depth, center = true, $fn = 6);

      translate([m5_distance*cos(i*(360/m5_nut_number)), m5_distance*sin(i*(360/m5_nut_number)), 0])
        cylinder(r = m5_diameter/2, h=pulley_t_ht+19, center = true);
    }
  }
  // 608rs
  translate([0,0,pulley_t_ht - 0.6]) cylinder(r=50/2, h=8, center = true);
  translate([0,0,pulley_t_ht - 5.3]) difference() {
    cylinder(r=11.2, h=14, center = true, $fn=360);
    translate([0,0,0.1]) cylinder(r=4, h=14.2, center = true, $fn=360);
  }
}

function tooth_spaceing_curvefit(b, c, d) = ((c * pow(teeth, d)) / (b + pow(teeth, d))) * teeth;

function tooth_spacing(tooth_pitch, pitch_line_offset) = (2 * ((teeth * tooth_pitch) / (3.14159265 * 2) - pitch_line_offset));

// Main Module

module pulley(belt_type, pulley_OD, tooth_depth, tooth_width) {
  echo(str("Belt type = ", belt_type, "; Number of teeth = ", teeth, "; Pulley Outside Diameter = ", pulley_OD, "mm "));
  tooth_distance_from_centre = sqrt(pow(pulley_OD / 2, 2) - pow((tooth_width + additional_tooth_width) / 2, 2));
  tooth_width_scale = (tooth_width + additional_tooth_width) / tooth_width;
  tooth_depth_scale = ((tooth_depth + additional_tooth_depth) / tooth_depth);

  translate([0, 0, pulley_b_ht + pulley_t_ht + retainer_ht]) rotate([0, 180, 0])

  difference() {
    union() {
      //base

      if (pulley_b_ht < 2) {
        echo("CAN'T DRAW PULLEY BASE, HEIGHT LESS THAN 2!!!");
      } else {
        rotate_extrude($fn = pulley_b_dia * 2) {
          square([pulley_b_dia / 2 - 1, pulley_b_ht]);
          square([pulley_b_dia / 2, pulley_b_ht - 1]);
          translate([pulley_b_dia / 2 - 1, pulley_b_ht - 1]) circle(1);
        }
      }

      difference() {
        //shaft - diameter is outside diameter of pulley

        translate([0, 0, pulley_b_ht])
        rotate([0, 0, 360 / (teeth * 4)])
        cylinder(r = pulley_OD / 2, h = pulley_t_ht, $fn = teeth * 4);

        //teeth - cut out of shaft

        for (i = [1: teeth])
          rotate([0, 0, i * (360 / teeth)])
        translate([0, -tooth_distance_from_centre, pulley_b_ht - 1])
        scale([tooth_width_scale, tooth_depth_scale, 1]) {
          HTD_3mm();
        }

      }

      //belt retainer / idler
      if (retainer > 0) {
        translate([0, 0, pulley_b_ht + pulley_t_ht])
        rotate_extrude($fn = teeth * 4)
        polygon([
          [0, 0],
          [pulley_OD / 2, 0],
          [pulley_OD / 2 + retainer_ht, retainer_ht],
          [0, retainer_ht],
          [0, 0]
        ]);
      }

      if (idler > 0) {
        translate([0, 0, pulley_b_ht - idler_ht])
        rotate_extrude($fn = teeth * 4)
        polygon([
          [0, 0],
          [pulley_OD / 2 + idler_ht, 0],
          [pulley_OD / 2, idler_ht],
          [0, idler_ht],
          [0, 0]
        ]);
      }

    }

    //hole for motor shaft
    translate([0, 0, -1]) cylinder(r = motor_shaft / 2, h = pulley_b_ht + pulley_t_ht + retainer_ht + 2, $fn = motor_shaft * 4);

    //captive nut and grub screw holes
    cylinder(h = 100, r = 2.5, center = true) translate([-100, 0, 0])


    if (pulley_b_ht < m3_nut_flats) {
      echo("CAN'T DRAW CAPTIVE NUTS, HEIGHT LESS THAN NUT DIAMETER!!!");
    } else {
      if ((pulley_b_dia - motor_shaft) / 2 < m3_nut_depth + 3) {
        echo("CAN'T DRAW CAPTIVE NUTS, DIAMETER TOO SMALL FOR NUT DEPTH!!!");
      } else {

        for (j = [1: no_of_nuts]) rotate([0, 0, j * nut_angle])
        translate([0, 0, nut_elevation]) rotate([90, 0, 0])

        union() {
          //entrance
          translate([0, -pulley_b_ht / 4 - 0.5, motor_shaft / 2 + m3_nut_depth / 2 + nut_shaft_distance]) cube([m3_nut_flats, pulley_b_ht / 2 + 1, m3_nut_depth], center = true);

          //nut
          if (m3_nut_hex > 0) {
            // hex nut
            translate([0, 0.25, motor_shaft / 2 + m3_nut_depth / 2 + nut_shaft_distance]) rotate([0, 0, 30]) cylinder(r = m3_nut_points / 2, h = m3_nut_depth, center = true, $fn = 6);
          } else {
            // square nut
            translate([0, 0.25, motor_shaft / 2 + m3_nut_depth / 2 + nut_shaft_distance]) cube([m3_nut_flats, m3_nut_flats, m3_nut_depth], center = true);
          }

          //grub screw hole
          rotate([0, 0, 22.5]) cylinder(r = m3_dia / 2, h = pulley_b_dia / 2 + 1, $fn = 8);
        }
      }
    }
  }
}

module HTD_3mm() {
  linear_extrude(height = pulley_t_ht + 2) polygon([
    [-1.135062, -0.5],
    [-1.135062, 0],
    [-1.048323, 0.015484],
    [-0.974284, 0.058517],
    [-0.919162, 0.123974],
    [-0.889176, 0.206728],
    [-0.81721, 0.579614],
    [-0.800806, 0.653232],
    [-0.778384, 0.72416],
    [-0.750244, 0.792137],
    [-0.716685, 0.856903],
    [-0.678005, 0.918199],
    [-0.634505, 0.975764],
    [-0.586483, 1.029338],
    [-0.534238, 1.078662],
    [-0.47807, 1.123476],
    [-0.418278, 1.16352],
    [-0.355162, 1.198533],
    [-0.289019, 1.228257],
    [-0.22015, 1.25243],
    [-0.148854, 1.270793],
    [-0.07543, 1.283087],
    [-0.000176, 1.28905],
    [0.075081, 1.283145],
    [0.148515, 1.270895],
    [0.219827, 1.252561],
    [0.288716, 1.228406],
    [0.354879, 1.19869],
    [0.418018, 1.163675],
    [0.477831, 1.123623],
    [0.534017, 1.078795],
    [0.586276, 1.029452],
    [0.634307, 0.975857],
    [0.677809, 0.91827],
    [0.716481, 0.856953],
    [0.750022, 0.792167],
    [0.778133, 0.724174],
    [0.800511, 0.653236],
    [0.816857, 0.579614],
    [0.888471, 0.206728],
    [0.919014, 0.123974],
    [0.974328, 0.058517],
    [1.048362, 0.015484],
    [1.135062, 0],
    [1.135062, -0.5]
  ]);
}
