# Galactic Adventure — Project Documentation

## Overview

Galactic Adventure is a SAP Cloud Application Programming (CAP) project that manages spacefarers across the galaxy. It enforces planet-based data isolation — regular users can only access and manage spacefarers from their own planet, while admin users have full control over all entities. The project exposes two OData v4 services consumed by two separate SAP Fiori Elements List Report applications.

---

## Project Structure

```
galactic-adventure/
├── app/
│   ├── galactic-adventure/           # Fiori Elements app (regular users)
│   │   ├── webapp/
│   │   │   └── annotations.cds       # UI annotations
│   │   └── manifest.json
│   └── galactic-adventure-admin/     # Fiori Elements app (admin users)
│       ├── webapp/
│       │   └── annotations.cds
│       └── manifest.json
│
├── db/                               # Data layer
│   ├── schema.cds                    # Entity definitions
│   └── data/                         # CSV seed data
│
├── srv/                              # Service layer
│   ├── cosmic-service.cds            # User service definition & authorization
│   ├── cosmic-service.js             # User service event handlers
│   ├── cosmic-service-admin.cds      # Admin service definition
│   ├── cosmic-service-admin.js       # Admin service event handlers
│   └── email-service.js             # Nodemailer email helper
│
└── package.json                      # Project config, mocked users
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
│ originPlanet_code : String (FK)         │
│ spacesuitColor_code: String (FK)        │
│ department_ID     : UUID (FK)           │
│ position_ID       : UUID (FK)           │
└──────┬───────────┬───────────┬──────────┘
       │           │           │          │
┌──────▼───┐ ┌────▼───────┐ ┌─▼────────┐ ┌▼──────────────┐
│ Planets  │ │Departments │ │Positions │ │SpacesuitColors│
│──────────│ │────────────│ │──────────│ │───────────────│
│code (key)│ │ ID (key)   │ │ID (key)  │ │code (key)     │
│name      │ │ name       │ │name      │ │name           │
│dangerLvl │ │ role       │ │gravityLvl│ └───────────────┘
└──────────┘ └────────────┘ └──────────┘
```

### Entity Descriptions

**Spacefarers** — the core entity representing individual spacefarers. Each spacefarer belongs to a planet, a department, a position, and has an associated spacesuit color. Seed data is loaded from `galactic-Spacefarers.csv` using fixed UUIDs for cross-referencing.

**Planets** — uses `code` (e.g. `EARTH`, `MARS`) as the natural primary key instead of a generated UUID. This makes cross-referencing in CSV seed data straightforward and human-readable.

**SpacesuitColors** — reference entity for valid spacesuit colors (e.g. `red`, `blue`). Using an entity instead of a CDS enum ensures a single source of truth — colors can be added or removed from the database without requiring code changes.

**Departments** — reference data representing organizational units. Read-only for regular users.

**Positions** — reference data representing roles within departments. Read-only for regular users.

---

## Service Layer

### CosmicService (Regular Users)

Exposed at `/odata/v4/cosmic/`. Requires authentication. Users can only access and manage spacefarers from their own planet — enforced via both a `@restrict` where clause and backend event handlers.

| Entity        | Allowed Operations           | Restriction                                  |
|---------------|------------------------------|----------------------------------------------|
| Spacefarers   | CREATE, READ, UPDATE, DELETE | Only spacefarers from the user's own planet  |
| Departments   | READ                         | All authenticated users                      |
| Positions     | READ                         | All authenticated users                      |
| Planets       | READ                         | All authenticated users                      |
| SpacesuitColors | READ                       | All authenticated users                      |

### CosmicServiceAdmin (Admin Users)

Exposed at `/odata/v4/cosmic-service-admin/`. Requires the `admin` role. Full CRUD on all entities with no planet-based restrictions.

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

> **Important:** The attribute must be defined under `attr` for `$user.planetCode` to resolve correctly in the `@restrict` where clause.

### Query Limiting

The user-facing Spacefarers entity applies a server-side query limit:

```cds
@cds.query.limit: { default: 10, max: 20 }
```

This caps all queries at 20 results per request regardless of what `$top` value the client sends. The admin service has no such limit, allowing admins to paginate freely through all records.

---

## Event Handlers

### CosmicService Handlers (`srv/cosmic-service.js`)

#### Before CREATE (drafts) — Auto-assign Origin Planet

When a user clicks Create, the origin planet is automatically pre-filled from their user profile before the draft is initialized:

#### Before CREATE — Validation & Enhancement

When the draft is activated (saved), the handler:
1. Validates that `wormholeNavigationSkill` and `stardustCollection` are non-negative numbers
2. Validates that `originPlanet_code` matches the user's own planet (tamper protection)
3. Enhances both skill values by +5 as a "cosmic boost"

```
Client POST /Spacefarers
        │
        ▼
┌───────────────────┐
│ validateSpacefarer│  → rejects if values invalid or planet mismatch
└────────┬──────────┘
         │
         ▼
┌───────────────────┐
│  enhanceSkills    │  → adds +5 to wormholeNavigationSkill and stardustCollection
└────────┬──────────┘
         │
         ▼
    Record saved
```

#### After CREATE — Welcome Email

After a spacefarer is successfully created, a welcome email is sent.

### CosmicServiceAdmin Handlers (`srv/cosmic-service-admin.js`)

Same validation and enhancement logic as the user service, but without the planet-matching check — admins can create spacefarers for any planet.

---

## Email Service (`srv/email-service.js`)

Uses Nodemailer to send a welcome email when a spacefarer is created. SMTP configuration is provided via a `.env` file at the project root.

---

## UI Applications

Two SAP Fiori Elements applications are included, each consisting of a List Report and an Object Page.

**Galactic Adventure** (`app/galactic-adventure`) — points to `CosmicService`. Regular users see and manage only their own planet's spacefarers.

**Galactic Adventure Admin** (`app/galactic-adventure-admin`) — points to `CosmicServiceAdmin`. Admins have full CRUD access to all entities across all planets.

---

## Authentication

The project uses CAP's mocked authentication strategy for local development. Users are defined in `package.json`:

| Username   | Password | Planet | Role  |
|------------|----------|--------|-------|
| spacepilot | 123      | EARTH  | —     |
| alien      | 123      | MARS   | —     |
| admin      | admin    | —      | admin |


---

## Local Setup

```bash
# Install dependencies
npm install

# Start the development server
cds watch
```

The app is then available at:
- CAP landing page: `http://localhost:4004`
- User Fiori app: `http://localhost:4004/galactic-adventure/webapp/index.html`
- Admin Fiori app: `http://localhost:4004/galactic-adventure-admin/webapp/index.html`
- User OData service: `http://localhost:4004/odata/v4/cosmic`
- Admin OData service: `http://localhost:4004/odata/v4/cosmic-service-admin`
- Fiori preview (user): `http://localhost:4004/$fiori-preview/CosmicService/Spacefarers#preview-app`
- Fiori preview (admin): `http://localhost:4004/$fiori-preview/CosmicServiceAdmin/Spacefarers#preview-app`
