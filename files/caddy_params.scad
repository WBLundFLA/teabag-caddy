use <lattice_wall.scad>

// --- Overall dimensions ---
total_w = 215;
half_d  = 148;
wall_h  = 70;
cols    = 3;
rows    = 2;
ow      = 2.4;    // outer wall thickness
dt      = 2.0;    // divider thickness
bt      = 3.0;    // base thickness

cell_w = (total_w - 2*ow - (cols-1)*dt) / cols;
cell_d = (half_d  - 2*ow - dt) / rows;

// --- Lattice (side walls only) ---
lat_gap    = 12;
lat_strand = 1.6;

// --- Finger-cutout geometry ---
// Profile Y=0 is arc centre; arc dips to Y=-uc_bot_w/2.
// uc_z_off maps profile-Y to world-Z: world-Z = profile-Y + uc_z_off
//   arc bottom  world-Z = uc_z_off - uc_bot_w/2 = 35 - 15 = 20 mm
//   top of profile world-Z = 35 + 40 = 75 > wall_h = 70 (guaranteed open)
uc_bot_w = 30;    // bottom semicircle diameter
uc_top_w = 36;    // distance between top-corner circle centres
uc_cr    = 8;     // top-corner circle radius (also controls how far above wall the cut exits)
uc_z_off = 35;    // Z offset: arc bottom lands at Z = uc_z_off - uc_bot_w/2 = 20

// Profile-Y at wall top (world-Z = wall_h = 70)
uc_y_wt  = wall_h - uc_z_off;   // = 35

// --- Tongue/groove joint ---
tl  = 40;
th  = 10;
tt  = 5;
tol = 0.5;

// Back half centre tongue — sized to fit as-printed front groove (30mm wide, 11mm tall, ~2.5mm deep)
tl_c = 28;   // 1mm clearance each side of 30mm opening
th_c = 9;    // 1mm clearance each side of 11mm opening
tt_c = 2;    // conservative fit for ~2.5mm groove depth

function ccx(i) = ow + i*(cell_w + dt) + cell_w/2;

tx1 = ow + cell_w + dt/2;
tx2 = ow + 2*(cell_w + dt) - dt/2;
tx_c = total_w / 2;

// --- 2-D U-profile ---
// Hull of bottom half-circle + two side circles at wall-top level.
// The side circles are centred at (+-uc_top_w/2, uc_y_wt) -- IN the solid
// wall material -- so the hull curve sweeps smoothly from solid into U.
// Profile is widest at uc_y_wt (wall top) and tapers down to uc_bot_w.
// Circles reach Y = uc_y_wt + uc_cr = 43, mapping to world-Z = 78 > 70
// so the cut is guaranteed to break through the wall top with no hard edge.
module u_profile_2d() {
    hull() {
        // Bottom half-circle (dips below Y=0)
        intersection() {
            circle(r = uc_bot_w/2, $fn = 64);
            translate([-(uc_bot_w/2 + 1), -uc_bot_w])
                square([uc_bot_w + 2, uc_bot_w]);
        }
        // Top-corner circles: centres in solid wall, arcs sweep into U
        translate([ uc_top_w/2, uc_y_wt]) circle(r = uc_cr, $fn = 32);
        translate([-uc_top_w/2, uc_y_wt]) circle(r = uc_cr, $fn = 32);
    }
}

// --- 3-D cutout through wall of thickness wt ---
module u_cut(wt) {
    translate([0, wt + 0.1, uc_z_off])
        rotate([90, 0, 0])
            linear_extrude(wt + 0.2)
                u_profile_2d();
}

// --- Half-tray ---
// Front/back walls: SOLID (U cutouts print better in solid walls)
// Side walls: lattice (no cutouts, decorative/lightweight)
// 2+1 tongue scheme:
//   Front: 2 tongues (tx1,tx2) + 1 centre groove
//   Back:  2 grooves (tx1,tx2) + 1 centre tongue
module caddy_half(is_front = true) {
    wy_back = half_d - ow;
    wy_div  = ow + cell_d;

    difference() {
        union() {
            // Base
            cube([total_w, half_d, bt]);
            // Front outer wall -- SOLID
            translate([0, 0, bt])
                cube([total_w, ow, wall_h - bt]);
            // Back outer wall -- SOLID
            translate([0, wy_back, bt])
                cube([total_w, ow, wall_h - bt]);
            // Left side wall -- LATTICE
            translate([0, 0, bt])
                lattice_wall_y(half_d, wall_h - bt, ow, lat_gap, lat_strand);
            // Right side wall -- LATTICE
            translate([total_w - ow, 0, bt])
                lattice_wall_y(half_d, wall_h - bt, ow, lat_gap, lat_strand);
            // Vertical column dividers (solid)
            for (i = [1 : cols-1])
                translate([ow + i*(cell_w + dt) - dt/2, ow, bt])
                    cube([dt, half_d - 2*ow, wall_h - bt]);
            // Horizontal row divider (solid)
            translate([ow, wy_div, bt])
                cube([total_w - 2*ow, dt, wall_h - bt]);

            // Joint geometry
            if (is_front) {
                translate([tx1 - tl/2, half_d,         bt+3]) cube([tl, tt,    th]);
                translate([tx2 - tl/2, half_d,         bt+3]) cube([tl, tt,    th]);
                translate([tx_c - tl/2, half_d - tt*2, bt+3]) cube([tl, tt*2,  th]);
            } else {
                translate([tx1 - tl/2, 0, bt+3]) cube([tl, tt*2, th]);
                translate([tx2 - tl/2, 0, bt+3]) cube([tl, tt*2, th]);
                translate([tx_c - tl_c/2, -tt_c, bt+3]) cube([tl_c, tt_c, th_c]);
            }
        }

        // U cutouts
        for (i = [0 : cols-1]) translate([ccx(i), 0,       0]) u_cut(ow);
        for (i = [0 : cols-1]) translate([ccx(i), wy_back, 0]) u_cut(ow);
        for (i = [0 : cols-1]) translate([ccx(i), wy_div,  0]) u_cut(dt);

        // Groove cuts
        if (is_front) {
            translate([tx_c - tl/2 - tol, half_d - tt - tol, bt+3 - tol])
                cube([tl + 2*tol, tt + tol + 0.1, th + 2*tol]);
        } else {
            translate([tx1 - tl/2 - tol, -0.1, bt+3 - tol])
                cube([tl + 2*tol, tt + tol, th + 2*tol]);
            translate([tx2 - tl/2 - tol, -0.1, bt+3 - tol])
                cube([tl + 2*tol, tt + tol, th + 2*tol]);
        }
    }
}
