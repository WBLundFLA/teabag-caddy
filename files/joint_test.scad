// ============================================================
//  joint_test.scad — 1-cell prototype, lattice front/back
//  Print TWO: joint_test.scad (front) + joint_back.scad (back)
//  Each ~45 min, print together on same bed
// ============================================================

cw   = 74;
cd   = 80;
wh   = 70;
ow   = 2.4;
bt   = 3.0;
tt   = 5;
tl   = 40;
th   = 10;
tol  = 0.3;
lat_gap    = 12;
lat_strand = 1.6;
uc_w = 36;
uc_r = 18;
uc_dep = 42;
tc_r = 6;
tx = cw / 2;

// Lattice wall running along X
module lat_wall_x(len, ht, thick, gap, strand) {
    pitch = gap + strand;
    difference() {
        cube([len, thick, ht]);
        for (xi=[pitch:pitch:len-pitch/2], zi=[pitch:pitch:ht-pitch/2])
            translate([xi,-0.1,zi]) rotate([0,45,0])
                cube([gap*0.707,thick+0.2,gap*0.707],center=true);
    }
}

module u_profile_2d() {
    half = uc_w/2;
    difference() {
        union() {
            translate([-half, uc_r]) square([uc_w, uc_dep-uc_r]);
            translate([0, uc_r]) circle(r=uc_r, $fn=64);
        }
        translate([-half-tc_r, uc_dep-tc_r]) circle(r=tc_r*1.4, $fn=32);
        translate([ half+tc_r, uc_dep-tc_r]) circle(r=tc_r*1.4, $fn=32);
    }
}

module u_cut(wt) {
    translate([0, wt, wh-uc_dep])
        rotate([90,0,0])
            linear_extrude(wt+0.2)
                u_profile_2d();
}

module test_piece(is_front=true) {
    difference() {
        union() {
            // Base
            cube([cw, cd, bt]);
            // Front wall — lattice
            translate([0, 0, bt])
                lat_wall_x(cw, wh-bt, ow, lat_gap, lat_strand);
            // Back wall — lattice
            translate([0, cd-ow, bt])
                lat_wall_x(cw, wh-bt, ow, lat_gap, lat_strand);
            // Left wall — solid
            translate([0, 0, bt]) cube([ow, cd, wh-bt]);
            // Right wall — solid
            translate([cw-ow, 0, bt]) cube([ow, cd, wh-bt]);

            // Tongue or receiver block
            if (is_front)
                translate([tx-tl/2, cd, bt+3]) cube([tl, tt, th]);
            else
                translate([tx-tl/2, 0, bt+3]) cube([tl, tt*2, th]);
        }

        // U cutouts
        translate([cw/2, 0, 0])    u_cut(ow);
        translate([cw/2, cd-ow, 0]) u_cut(ow);

        // Groove pocket on back piece
        if (!is_front)
            translate([tx-tl/2-tol, -0.1, bt+3-tol])
                cube([tl+tol*2, tt+tol, th+tol+0.1]);
    }
}

test_piece(is_front=true);
// For back piece: change to test_piece(is_front=false);
