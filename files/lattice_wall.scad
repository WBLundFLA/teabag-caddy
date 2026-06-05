// lattice_wall.scad

// Front/back walls: run along X, thickness in Y, height in Z
module lattice_wall(len, ht, thick, gap=12, strand=1.6) {
    pitch = gap + strand;
    difference() {
        cube([len, thick, ht]);
        for (xi = [pitch : pitch : len - pitch/2],
             zi = [pitch : pitch : ht  - pitch/2])
            translate([xi, -0.1, zi])
                rotate([0, 45, 0])
                    cube([gap*0.707, thick+0.2, gap*0.707], center=true);
    }
}

// Side walls: run along Y, thickness in X, height in Z
// Holes are diamond-shaped in YZ (visible when looking from outside in X)
module lattice_wall_y(len, ht, thick, gap=12, strand=1.6) {
    pitch = gap + strand;
    difference() {
        cube([thick, len, ht]);
        for (yi = [pitch : pitch : len - pitch/2],
             zi = [pitch : pitch : ht  - pitch/2])
            translate([thick/2, yi, zi])
                rotate([45, 0, 0])
                    cube([thick+0.2, gap*0.707, gap*0.707], center=true);
    }
}
