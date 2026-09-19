# AI Bootstrap: teabag-caddy

Part of the WBLundFLA 3D printing capability fleet.
Parametric interlocking CAD models in OpenSCAD adhering to **Wabble Standard Operating Procedures (WSOP)**.

## Core Directives

1. **The Holster Rule (Authorizations):**
   - You are fully authorized to read, inspect, diff, and test code.
   - NEVER push to remote, alter running production services, or overwrite deployed assets without explicit human consent.
2. **Centralized Slicing & Profiles:**
   - Canonical printer profiles and centralized headless slicing logic reside in `WBLundFLA/wabble-print-capabilities`.
   - Florida Sovol SV06 profile: `printers/william-sovol-sv06.json` (build envelope 220×220, direct drive, PEI spring steel).
   - Slicing stack: `slicer/sovol-sv06/` in `wabble-print-capabilities`.
3. **The Centauri Secret Rule:**
   - NEVER commit or log printer LAN IP addresses, access codes, or credentials.
4. **Physical Safety & Slicing:**
   - Slicing and dispatch automation must set `select=true, print=false`. Never start a thermal heater or stepper motors unattended.
