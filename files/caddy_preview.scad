// ============================================================
//  caddy_preview.scad  —  BOTH HALVES assembled
//  For visual checking only — do NOT export as one STL.
//  Render: F6  (takes ~60 seconds)
// ============================================================
include <caddy_params.scad>

// Front half
caddy_half(is_front = true);

// Back half sitting directly behind
translate([0, half_d, 0])
    caddy_half(is_front = false);
