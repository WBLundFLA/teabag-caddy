// Both halves shown side-by-side with 5mm gap — visual inspection only, do NOT print
include <caddy_params.scad>

caddy_half(is_front = true);
translate([0, half_d + 5, 0])
    caddy_half(is_front = false);
