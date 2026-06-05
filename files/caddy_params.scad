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
// Profile in XY: Y=0 is arc centre line, arc dips to Y=-uc_bot_w/2,
// top opening is at Y=uc_dep.  uc_z_off maps arc centre to world-Z.
//   bottom-of-arc world Z = uc_z_off - uc_bot_w/2 = 35-15 = 20 mm
//   top of profile world Z = uc_z_off + uc_dep     = 35+40 = 75 > wall_h (good)
uc_bot_w = 30;
uc_top_w = 46;
uc_dep   = 40;
uc_z_off = 35;

// --- Tongue/groove joint ---
tl  = 40;    // tongue length (X)
th  = 10;    // tongue height (Z)
tt  = 5;     // tongue thickness (Y)
tol = 0.5;   // clearance (increased from 0.3 -- was too tight)

function ccx(i) = ow + i*(cell_w + dt) + cell_w/2;

// Tongue X positions: at column dividers and centre
tx1 = ow + cell_w + dt/2;
tx2 = ow + 2*(cell_w + dt) - dt/2;
tx_c = total_w / 2;   // centre reverse-tongue position

// --- 2-D U-profile: hull of bottom half-circle + wide top line ---
module u_profile_2d() {
    hull() {
        intersection() {
            circle(r = uc_bot_w/2, $fn = 64);
            translate([-(uc_bot_w/2 + 1), -uc_bot_w])
                square([uc_bot_w + 2, uc_bot_w]);
        }
        translate([-(uc_top_w/2), uc_dep - 1])
            square([uc_top_w, 2]);
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
// 2+1 tongue scheme:
//   Front half: 2 tongues (tx1, tx2) protrude in +Y from mating face
//               1 groove  (tx_c)  cut into mating face for back's tongue
//   Back half:  2 grooves (tx1, tx2) receive front's tongues
//               1 tongue  (tx_c)  protrudes in -Y from mating face
module caddy_half(is_front = true) {
    wy_back = half_d - ow;
    wy_div  = ow + cell_d;

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

            // --- Joint geometry ---
            if (is_front) {
                // 2 tongues protruding past mating face in +Y
                translate([tx1 - tl/2, half_d,       bt+3]) cube([tl, tt,    th]);
                translate([tx2 - tl/2, half_d,       bt+3]) cube([tl, tt,    th]);
                // Receiver block at centre for back's reverse tongue
                translate([tx_c - tl/2, half_d - tt*2, bt+3]) cube([tl, tt*2, th]);
            } else {
                // 2 receiver blocks for front's tongues
                translate([tx1 - tl/2, 0, bt+3]) cube([tl, tt*2, th]);
                translate([tx2 - tl/2, 0, bt+3]) cube([tl, tt*2, th]);
                // 1 reverse tongue protruding in -Y
                translate([tx_c - tl/2, -tt, bt+3]) cube([tl, tt, th]);
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

        // --- Groove cuts ---
        if (is_front) {
            // Centre groove receives back's reverse tongue
            translate([tx_c - tl/2 - tol, half_d - tt - tol, bt+3 - tol])
                cube([tl + 2*tol, tt + tol + 0.1, th + 2*tol]);
        } else {
            // 2 grooves receive front's tongues
            translate([tx1 - tl/2 - tol, -0.1, bt+3 - tol])
                cube([tl + 2*tol, tt + tol, th + 2*tol]);
            translate([tx2 - tl/2 - tol, -0.1, bt+3 - tol])
                cube([tl + 2*tol, tt + tol, th + 2*tol]);
        }
    }
}
