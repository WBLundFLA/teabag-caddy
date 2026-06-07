# Teabag Caddy

OpenSCAD design for a 3x4 tea bag drawer organiser. Bags sit vertically, tags visible,
U-shaped finger cutouts make grabbing easy.

## Design

- **Grid:** 3 columns x 4 rows (12 cells), ~70 x 70mm each
- **Overall:** 220 x 296 x 70mm assembled
- **Split:** Two identical 220 x 148mm halves joined by a 2+1 tongue-and-groove joint
- **Bed requirement:** Each half fits a 235x235mm bed (Sovol SV06, Ender 3, etc.)
- **Walls:** Solid front/back with U finger cutouts; diamond lattice sides
- **Material:** PLA, ~110-130g per half

## Files

| File | Purpose |
|------|---------|
| `files/caddy_front.scad` | Front half -- open in OpenSCAD, F6, export STL |
| `files/caddy_back.scad` | Back half -- same workflow |
| `files/caddy_preview.scad` | Both halves assembled for visual check |
| `files/caddy_params.scad` | All parameters -- edit this to customise |
| `files/lattice_wall.scad` | Lattice wall modules (dependency, do not edit) |

## Print settings

- Layer height: 0.2mm
- Perimeters: 3
- Infill: 15%
- Supports: none
- Brim: recommended for the first half

## Assembly

The two halves slot together along the long edge. The front half has two tongues and
one centre groove; the back half has two grooves and one centre tongue. Press together
until the tongues click home. No glue needed -- the drawer walls hold them in place.
