# Teabag Caddy - Claude Project Context

## What this is

OpenSCAD design for a 3x4 tea bag drawer caddy. Two interlocking 3x2 halves,
printed on a Sovol SV06 (235x235mm bed). Files are in the `files/` subfolder.

## File roles

- `files/caddy_params.scad` -- ALL parameters and modules. This is the ONLY file to edit.
- `files/lattice_wall.scad` -- lattice_wall() and lattice_wall_y() modules. Stable, do not edit.
- `files/caddy_front.scad` -- renders front half. F6 then File > Export > STL.
- `files/caddy_back.scad`  -- renders back half. Same workflow.
- `files/caddy_clip.scad`  -- renders both T-clips (left + mirrored right). Print from caddy_clip.stl.
- `files/caddy_preview.scad` -- both halves assembled for visual check only, do NOT print.
- `files/caddy_assembled_preview.scad` -- both halves with 5mm gap, safe to export for PrusaSlicer preview.

## Hard rules (violations have caused failures before)

1. NO non-ASCII characters in any .scad file -- no em dashes, arrows, degree symbols.
   ASCII only or the OpenSCAD parser errors out silently.
2. Lattice cut cubes must be centred in wall thickness: translate([x, thick/2, z]).
   Using translate([x, -0.1, z]) only cuts halfway through, leaving a skin.
3. Do NOT use corner-square-minus-arc shapes for fillets -- they create pointed horn spikes.
4. No bottom chamfer on any print -- causes "no extrusions on first layer" in PrusaSlicer.

## Key design parameters (in caddy_params.scad)

- total_w=215, half_d=148, wall_h=70 -- overall dimensions per half (mm)
- cols=3, rows=2 -- grid per half (3 wide x 2 deep, giving 3x4 assembled)
- lat_gap=12, lat_strand=1.6 -- lattice openness
- tol=0.5 -- tongue/groove clearance
- ow=2.4 -- outer wall thickness
- uc_bot_w=30, uc_top_w=36, uc_cr=8 -- U cutout shape
- tx1, tx2 -- side tongue X positions (at column dividers)
- tx_c=total_w/2 -- centre groove/tongue position

## Joint scheme (2+1)

Front half: 2 tongues (tx1, tx2) protruding in +Y + 1 groove at tx_c.
Back half:  2 grooves (tx1, tx2) + 1 centre tongue at tx_c protruding in -Y.

### Known joint issue (as of first print)

The tongue/groove joint printed too loose to hold reliably. Root causes:

- Centre groove on front printed 30mm wide (designed 40mm) because tongues at
  tx1/tx2 overlap the groove opening in X by ~5mm each side.
- Back centre tongue was redesigned to tl_c=28mm, th_c=9mm, tt_c=2mm to fit
  the as-printed 30mm groove opening.
- Side joints also printed loose -- tolerance needs revisiting.
- Joint redesign deferred; clips are the interim fix.

## Clip design (seam bridge clip, caddy_clip.scad)

Two bridge clips hold the halves together -- one at each outer seam corner.
Each clip slides down from above onto the seam corner:

- Bridge (3mm thick) overhangs the outer side wall top -- self-locating in X,
  sits proud above wall_h so it is visible and grabbable
- Legs (16mm) hang down INSIDE the corner only (x=ow=2.4mm inward), avoiding
  the side wall material entirely -- no geometric conflict
- Y-slot (cy_gap=5.4mm) grips both seam walls simultaneously:
  front half back wall + back half front wall = 4.8mm combined + 0.6mm clearance
- cy_t=5mm per side, leg_x=8mm deep into caddy
- caddy_clip.stl contains BOTH clips (left + mirrored right) -- print as-is, no supports.
- Orient with flat bridge face on bed, legs pointing up. Flip and slide down to install.

NOTE: Earlier T-clip design (with X-slot for side wall) was abandoned -- the crossbar
legs geometrically conflicted with the side wall material at the outer corner.

## Print settings (PrusaSlicer, Sovol SV06, PLA)

- Layer height: 0.2mm
- Perimeters: 3
- Infill: 15%
- Supports: none needed
- Bed temp: 65C (bumped from 60C to reduce corner lift)
- First layer speed: 20-25mm/s to prevent corner warp

## Print history

- Front half: printed, confirmed dimensions accurate (215x148x70mm).
  Minor corner lift on front-right. Blob artifact near centre groove (cosmetic).
- Back half: printed with updated centre tongue (tl_c/th_c/tt_c params).
  Joint too loose to hold reliably.
- Clips: designed, STL ready, not yet printed.

## GitHub

[https://github.com/WBLundFLA/teabag-caddy](https://github.com/WBLundFLA/teabag-caddy)
