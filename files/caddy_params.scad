use <lattice_wall.scad>

// --- Overall dimensions ---
total_w = 220;    // full tray width across drawer
half_d  = 148;    // front-to-back depth per half
wall_h  = 70;     // wall height
cols    = 3;
rows    = 2;
ow      = 2.4;    // outer wall thickness
dt      = 2.0;    // divider thickness
bt      = 3.0;    // base thickness

cell_w = (total_w - 2*ow - (cols-1)*dt) / cols;
cell_d = (half_d  - 2*ow - dt) / rows;

// --- Lattice ---
lat_gap    = 12;
lat_strand = 1.6;

// --- Finger-cutout geometry ---
// Profile lives in XY plane with Y pointing up the wall.
// Arc dips to Y = -uc_bot_w/2; open top is at Y = uc_dep.
// uc_z_off positions the arc: bottom-of-arc lands at
//   Z = uc_z_off - uc_bot_w/2  (= 35 - 15 = 20 mm above base)
// Top of profile at Z = uc_z_off + uc_dep = 35+40 = 75 > wall_h (good)
uc_bot_w = 30;   // semicircle diameter (narrow base)
uc_top_w = 46;   // flared opening width at top
uc_dep   = 40;   // profile height from arc-centre line to top edge
uc_z_off = 35;   // Z placement of arc-centre line

// --- Tongue/groove joint ---
tl  = 40;
th  = 10;
tt  = 5;
tol = 0.3;

function ccx(i) = ow + i*(cell_w + dt) + cell_w/2;

// 2-D U-profile: convex hull of bottom half-circle + wide top line.
// Result: rounded base, flaring sides, no sharp corners anywhere.
module u_profile_2d() {
    hull() {
        // Bottom half-circle (arc dips below Y=0)
        intersection() {
            circle(r = uc_bot_w/2, $fn = 64);
            translate([-(uc_bot_w/2 + 1), -uc_bot_w])
                square([uc_bot_w + 2, uc_bot_w]);
        }
        // Wide top opening line (extends above wall_h after Z transform)
        translate([-(uc_top_w/2), uc_dep - 1])
            square([uc_top_w, 2]);
    }
}

// 3-D cutout through a wall of thickness wt.
// rotate([90,0,0]) maps profile-Y to world-Z, extrusion to world-Y.
module u_cut(wt) {
    translate([0, wt + 0.1, uc_z_off])
        rotate([90, 0, 0])
            linear_extrude(wt + 0.2)
                u_profile_2d();
}

// --- Half-tray ---
module caddy_half(is_front = true) {
    wy_back = half_d - ow;
    wy_div  = ow + cell_d;
    tx1 = ow + cell_w + dt/2;
    tx2 = ow + 2*(cell_w + dt) - dt/2;

    difference() {
        union() {
            // Base
            cube([total_w, half_d, bt]);
            // Front outer wall (lattice)
            translate([0, 0, bt])
                lattice_wall(total_w, wall_h - bt, ow, lat_gap, lat_strand);
            // Back outer wall (lattice)
            translate([0, wy_back, bt])
                lattice_wall(total_w, wall_h - bt, ow, lat_gap, lat_strand);
            // Left side wall (lattice)
            translate([0, 0, bt])
                lattice_wall_y(half_d, wall_h - bt, ow, lat_gap, lat_strand);
            // Right side wall (lattice)
            translate([total_w - ow, 0, bt])
                lattice_wall_y(half_d, wall_h - bt, ow, lat_gap, lat_strand);
            // Vertical column dividers (solid)
            for (i = [1 : cols-1])
                translate([ow + i*(cell_w + dt) - dt/2, ow, bt])
                    cube([dt, half_d - 2*ow, wall_h - bt]);
            // Horizontal row divider (solid)
            translate([ow, wy_div, bt])
                cube([total_w - 2*ow, dt, wall_h - bt]);
            // Joint: tongues on front half, receiver blocks on back half
            if (is_front) {
                translate([tx1 - tl/2, half_d, bt + 3]) cube([tl, tt, th]);
                translate([tx2 - tl/2, half_d, bt + 3]) cube([tl, tt, th]);
            } else {
                translate([tx1 - tl/2, 0, bt + 3]) cube([tl, tt*2, th]);
                translate([tx2 - tl/2, 0, bt + 3]) cube([tl, tt*2, th]);
            }
        }
        // U cutouts on front outer wall
        for (i = [0 : cols-1])
            translate([ccx(i), 0, 0]) u_cut(ow);
        // U cutouts on back outer wall
        for (i = [0 : cols-1])
            translate([ccx(i), wy_back, 0]) u_cut(ow);
        // U cutouts on horizontal divider
        for (i = [0 : cols-1])
            translate([ccx(i), wy_div, 0]) u_cut(dt);
        // Groove pockets (back half only)
        if (!is_front) {
            translate([tx1 - tl/2 - tol, -0.1, bt + 3 - tol])
                cube([tl + tol*2, tt + tol, th + tol + 0.1]);
            translate([tx2 - tl/2 - tol, -0.1, bt + 3 - tol])
                cube([tl + tol*2, tt + tol, th + tol + 0.1]);
        }
    }
}
