// lattice_wall.scad
// len=X, ht=Z, thick=Y
// For side walls (running in Y): call with len=half_d, then
// place with translate([x,0,z]) — no rotation needed if we
// provide a second module for Y-oriented walls.

module lattice_wall(len, ht, thick, gap=12, strand=1.6) {
    pitch = gap + strand;
    difference() {
        cube([len, thick, ht]);
        for (xi = [pitch : pitch : len-pitch/2],
             zi = [pitch : pitch : ht-pitch/2])
            translate([xi, -0.1, zi])
                rotate([0,45,0])
                    cube([gap*0.707, thick+0.2, gap*0.707], center=true);
    }
}

// Side wall: runs along Y axis, thickness in X, height in Z
module lattice_wall_y(len, ht, thick, gap=12, strand=1.6) {
    pitch = gap + strand;
    difference() {
        cube([thick, len, ht]);
        for (yi = [pitch : pitch : len-pitch/2],
             zi = [pitch : pitch : ht-pitch/2])
            translate([-0.1, yi, zi])
                rotate([0,0,0])
                    // cut in XZ plane rotated 45 around Y
                    rotate([0,45,0])
                        cube([gap*0.707, thick+0.2, gap*0.707], center=true);
    }
}
