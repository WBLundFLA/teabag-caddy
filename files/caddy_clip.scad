// ============================================================
//  caddy_clip.scad  --  seam bridge clip for teabag caddy
//
//  Bridge overhangs the outer side wall top (self-locating in X).
//  Legs hang down INSIDE the corner (x = ow onward), avoiding the
//  side wall material entirely.
//  Y-slot spans both seam walls simultaneously (front half back
//  wall + back half front wall = 2*ow combined).
//
//  Print: bridge flat on bed, legs up. Flip to install -- bridge
//  sits proud above wall top, legs drop into the seam corner.
//  File contains left clip + mirrored right clip.
// ============================================================
include <caddy_params.scad>

cy_gap   = 2*ow + 0.6;        // 5.4mm -- Y slot (both seam walls + clearance)
cy_t     = 5.0;                // leg thickness in Y per side
cy_y     = 2*cy_t + cy_gap;   // 15.4mm total Y
leg_x    = 8.0;                // leg depth into caddy (from side wall inner face)
clip_bt  = 3.0;                // bridge thickness
clip_leg = 16.0;               // leg length
clip_h   = clip_bt + clip_leg; // 19mm total

module bridge_clip() {
    difference() {
        union() {
            // Bridge: full width, overhangs outer side wall
            cube([ow + leg_x, cy_y, clip_bt]);
            // Legs: only from inner face of side wall inward (no side wall conflict)
            translate([ow, 0, 0])
                cube([leg_x, cy_y, clip_h]);
        }
        // Y-slot through legs only
        translate([ow - 0.1, cy_t, clip_bt])
            cube([leg_x + 0.2, cy_gap, clip_leg + 1]);
    }
}

// Left clip
bridge_clip();

// Right clip (mirror in X for right side wall)
translate([2*(ow + leg_x) + 5, 0, 0])
    mirror([1, 0, 0])
        bridge_clip();
