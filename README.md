# Air Power Operations Platform (Tactical Air Operations Console)

This project is a high-density, client-side tactical air operations command console imported and adapted from Google Stitch (Project ID: `4332693569655994458`).

## Design System
- **Theme**: Tactical Air Operations Console
- **Primary Navy**: `#0F2942` / Dark Navy: `#001428`
- **Secondary Slate**: `#334E68` / `#46617C`
- **Light Surface / Background**: `#F8FAFC` / `#F8F9FF`
- **Borders & Dividers**: `#CBD5E1`
- **Status Protocols**:
  - Green (Optimal / Available): `#059669`
  - Amber (Warning / Maintenance): `#D97706`
  - Red (Critical / Standby): `#E11D48`
- **Typography**: Inter (UI / Text) & JetBrains Mono (Technical / Identifiers / Clocks)

## Modules Included
1. **Overview & Real-Time Dashboard**: Summary KPI bento grid, fleet readiness %, live UTC/IST clocks, dynamic simulated activity, and top anomaly banner.
2. **Aircraft & Resources**: Fictional fleet inventory (Su-30MKI, Tejas MK1A, Rafale EH, C-130J), search, filter by readiness/base, and full add/edit/delete CRUD.
3. **Crew Management**: Aircrew duty status, fatigue hours, rank, role, base assignment, and pilot enrollment/management.
4. **Weather & Airspace**: Fictional METAR cards (Ambala, Jodhpur, Sulur), airspace restriction NOTAMs, staleness tracking (>120 mins).
5. **Equipment & Configurations**: Sensor pods, EW suites, auxiliary fuel systems, mandatory justification audit logs.
6. **Mission Planning**: Air Tasking Order (ATO) administrative sorties, priority ranking, pilot/airframe linking, mandatory modification logging.
7. **AI Decision Support**: Deterministic rule base (Rules R1 through R6) evaluating cross-module resource conflicts with human-in-the-loop action triggers.
8. **Integrations & Health**: Telemetry ingest pipelines, heartbeat monitoring, and simulated stale record injections.

## How to Run Locally

### Option 1: Native PowerShell (No Node/npm required)
```powershell
powershell -ExecutionPolicy Bypass -File .\server.ps1
```
Open your browser at `http://localhost:3000/`.

### Option 2: npm / Node (if Node.js is installed in PATH)
```bash
npm start
```
Or open `index.html` directly in any modern browser.

## Safety & Data Ethics
All records, coordinates, tail numbers, and personnel data are synthetic, non-operational demonstration data designed specifically for prototype evaluation.
