// Joint area detail — front half joint face + back half joint face side by side
include <caddy_params.scad>

// Front half, clipped to just the joint region
intersection() {
    caddy_half(is_front = true);
    translate([tx_c - 60, half_d - 20, 0]) cube([120, 25, wall_h]);
}

// Back half joint face, placed adjacent
translate([0, half_d, 0])
intersection() {
    caddy_half(is_front = false);
    translate([tx_c - 60, -5, 0]) cube([120, 20, wall_h]);
}
