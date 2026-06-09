// Clip-on-corner context view -- visual check only, do NOT print
include <caddy_params.scad>

cy_gap   = 2*ow + 0.6;
cy_t     = 5.0;
cy_y     = 2*cy_t + cy_gap;
leg_x    = 8.0;
clip_bt  = 3.0;
clip_leg = 16.0;
clip_h   = clip_bt + clip_leg;

module bridge_clip() {
    difference() {
        union() {
            cube([ow + leg_x, cy_y, clip_bt]);
            translate([ow, 0, 0])
                cube([leg_x, cy_y, clip_h]);
        }
        translate([ow - 0.1, cy_t, clip_bt])
            cube([leg_x + 0.2, cy_gap, clip_leg + 1]);
    }
}

// Front half -- left corner + seam region only
intersection() {
    caddy_half(is_front = true);
    cube([30, half_d, wall_h]);
}

// Back half -- left corner + seam region only
translate([0, half_d, 0])
intersection() {
    caddy_half(is_front = false);
    cube([30, 25, wall_h]);
}

// Left clip in installed position:
// bridge overhangs side wall (x=0..ow), legs hang down inside (x=ow..ow+leg_x)
// bridge sits above wall_h, legs descend into corner
translate([0, half_d - cy_t - cy_gap/2, wall_h + clip_bt])
    mirror([0, 0, 1])
        color("red", 0.8)
            bridge_clip();
