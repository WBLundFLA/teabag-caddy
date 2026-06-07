# Teabag Caddy - Claude Project Context

## What this is
OpenSCAD design for a 3x4 tea bag drawer caddy. Two interlocking 3x2 halves,
printed on a Sovol SV06 (235x235mm bed). Files are in the `files/` subfolder.

## File roles
- `files/caddy_params.scad` -- ALL parameters and modules. This is the only file to edit.
- `files/lattice_wall.scad` -- lattice_wall() and lattice_wall_y() modules. Stable.
- `files/caddy_front.scad` -- renders front half. Open this in OpenSCAD, F6, export STL.
- `files/caddy_back.scad`  -- renders back half. Same workflow.
- `files/caddy_preview.scad` -- both halves assembled for visual checking only.

## Hard rules (violations have caused failures before)
1. NO non-ASCII characters in any .scad file -- no em dashes, arrows, degree symbols.
   ASCII only or the OpenSCAD parser errors out silently.
2. Lattice cut cubes must be centred in the wall thickness: translate([x, thick/2, z]).
   Using translate([x, -0.1, z]) only cuts halfway through, leaving a skin.
3. Do NOT use corner-square-minus-arc shapes for fillets -- they create pointed horn spikes.
4. No bottom chamfer on any print -- causes "no extrusions on first layer" in PrusaSlicer.

## Key design parameters (in caddy_params.scad)
- total_w=220, half_d=148, wall_h=70 -- overall dimensions per half (mm)
- cols=3, rows=2 -- grid per half (3 wide x 2 deep, giving 3x4 assembled)
- lat_gap=12, lat_strand=1.6 -- lattice openness
- tol=0.5 -- tongue/groove clearance (Sovol prints slightly over-size)
- uc_bot_w=30, uc_top_w=36, uc_cr=8 -- U cutout shape parameters
- tx1, tx2 -- tongue X positions (at column dividers)
- tx_c=total_w/2 -- centre reverse-tongue position (2+1 joint scheme)

## Joint scheme
Front half: 2 tongues (tx1, tx2) protruding in +Y + 1 groove at tx_c.
Back half:  2 grooves (tx1, tx2) + 1 reverse tongue at tx_c protruding in -Y.

## Print settings (PrusaSlicer, Sovol SV06, PLA)
- Layer height: 0.2mm
- Perimeters: 3
- Infill: 15%
- Supports: none needed
- Print one half first as a test before committing to both

## GitHub
https://github.com/WBLundFLA/teabag-caddy
