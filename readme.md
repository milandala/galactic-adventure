# Galactic Adventure — Project Documentation

## Overview

Galactic Adventure is a SAP Cloud Application Programming (CAP) project that manages spacefarers across the galaxy. It enforces planet-based data isolation — users can only access spacefarers from their own planet. The project exposes an OData v4 service consumed by a SAP Fiori Elements List Report application.

---

## Project Structure

```
galactic-adventure/
├── app/                          # UI layer
│   └── galactic-adventure/       # Fiori Elements app
│       └─── annotations.cds       # UI annotations (LineItem, Facets, FieldGroups)
│
├── db/                           # Data layer
│   ├── schema.cds                # Entity definitions
│   └── data/                     # CSV seed data
│       ├── galactic-Spacefarers.csv
│       ├── galactic-Planets.csv
│       ├── galactic-Departments.csv
│       └── galactic-Positions.csv
├── srv/                          # Service layer
│   ├── cosmic-service.cds        # Service definition & authorization
│   └── cosmic-service.js         # Custom event handlers
└── package.json                  # Project config, mocked users
```

---

## Data Model

### Entity Relationship Diagram

```
┌─────────────────────────────────────────┐
│              Spacefarers                │
│─────────────────────────────────────────│
│ ID                : UUID (key)          │
│ name              : String              │
│ stardustCollection: Integer             │
│ wormholeNavSkill  : Integer             │
│ spacesuitColor    : String              │
│ originPlanet_code : String (FK)         │
│ department_ID     : UUID (FK)           │
│ position_ID       : UUID (FK)           │
└──────────┬──────────┬───────────────────┘
           │          │              │
           │          │              │
    ┌──────▼───┐  ┌───▼────────┐  ┌─▼──────────┐
    │ Planets  │  │Departments │  │ Positions  │
    │──────────│  │────────────│  │────────────│
    │code (key)│  │ ID (key)   │  │ ID (key)   │
    │name      │  │ name       │  │ name       │
    │dangerLvl │  │ role       │  │gravityLevel│
    └──────────┘  └────────────┘  └────────────┘
```

### Entity Descriptions

**Spacefarers** — the core entity representing individual spacefarers. Each spacefarer belongs to a planet, and optionally to a department and position. Seed data is loaded from `galactic-Spacefarers.csv` using fixed UUIDs for cross-referencing.

**Planets** — uses `code` (e.g. `EARTH`, `MARS`) as the natural primary key instead of a generated UUID. This makes cross-referencing in CSV seed data straightforward and human-readable. I also tried to use different approaches for cross-referencing seed data.

**Departments** — reference data representing organizational units. Read-only for all authenticated users via `@restrict`.

**Positions** — reference data representing roles within departments. Read-only for all authenticated users via `@restrict`.

---

## Service Layer

### CosmicService

Exposed at `/odata/v4/cosmic/`. Requires authentication for all endpoints. To conform to the requirement of __users can only access spacefarers from their own planet__, I have restricted read operations for every user to protect data integrity.

| Entity       | Allowed Operations          | Restriction                                      |
|--------------|-----------------------------|--------------------------------------------------|
| Spacefarers  | CREATE, READ, UPDATE, DELETE| Only spacefarers from the user's own planet      |
| Departments  | READ                        | All authenticated users                          |
| Positions    | READ                        | All authenticated users                          |
| Planets      | READ                        | All authenticated users                          |

### Planet-Based Authorization

Authorization is enforced via the `@restrict` annotation with a `where` clause:

```cds
@restrict: [{
  grant: ['CREATE', 'READ', 'UPDATE', 'DELETE'],
  where: 'originPlanet.code = $user.planetCode'
}]
```

The `$user.planetCode` value is resolved from the authenticated user's `attr.planetCode` attribute, defined in `package.json` under mocked users:

```json
"spacepilot": {
  "password": "123",
  "attr": { "planetCode": "EARTH" }
}
```

> **Important:** The attribute must be defined under `attr` (not `attributes`) for `$user.planetCode` to resolve correctly in the `@restrict` where clause.

### Query Limiting

To enforce server-side pagination, the Spacefarers entity applies a query limit:

```cds
@cds.query.limit: { default: 10, max: 20 }
```

This caps all queries at 20 results regardless of what `$top` value the client sends.

---

## Event Handlers

Custom handlers are defined in `srv/cosmic-service.js`.

### Before CREATE — Validation & Enhancement

Before a new spacefarer is created, the handler:
1. Validates that `wormholeNavigationSkill` and `stardustCollection` are above 0
2. Enhances both values by +5 as a "cosmic boost"

```
Client POST /Spacefarers
        │
        ▼
┌───────────────────┐
│ validateSpacefarer│  → rejects if skill/stardust < 0
└────────┬──────────┘
         │
         ▼
┌───────────────────┐
│  enhanceSkills    │  → adds +5 to both fields
└────────┬──────────┘
         │
         ▼
    Record saved
```

### After CREATE — Welcome Notification

After a spacefarer is successfully created, a simulated welcome email is logged to the console congratulating the new spacefarer on joining the cosmic fleet.

---

## UI Application

Built with SAP Fiori Elements, the app consists of two pages:

### List Report (Task 4)
- Displays all spacefarers visible to the authenticated user
- Columns: Name, Stardust Collection, Spacesuit Color, Origin Planet
- Filter bar: filter by Stardust Collection and Spacesuit Color
- Sorting: available on all columns
- Pagination: enforced server-side via `@cds.query.limit`

### Object Page (Task 5)
- Opens when a row is clicked in the List Report
- Displays full spacefarer details in a "Cosmic Details" section
- Supports editing via SAP Fiori draft pattern (`@odata.draft.enabled`)
- `originPlanet` is immutable (`@Core.Immutable`) — prevents users from reassigning spacefarers to other planets, which would cause data isolation issues

---

## Authentication

The project uses CAP's mocked authentication strategy for local development. Users are defined in `package.json`:

| Username   | Password | Planet |
|------------|----------|--------|
| spacepilot | 123      | EARTH  |
| alien      | 123      | MARS   |

In a production environment, mocked auth would be replaced with a real provider such as XSUAA, with planet codes delivered as JWT claims.

---

## Local Setup

```bash
# Install dependencies
npm install

# Deploy schema and seed data
cds deploy --to sqlite

# Start the development server
cds watch
```

The app is then available at:
- CAP landing page: `http://localhost:4004`
- Fiori app: `http://localhost:4004/galactic-adventure/webapp/index.html`
- OData service: `http://localhost:4004/odata/v4/cosmic`
