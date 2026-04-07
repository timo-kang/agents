# Voca Project Context

## Core Stack

- Backend is Python 3.7+ standard library only.
- Primary server logic lives in `app.py`.
- Database access is SQLite through `db.py`.
- Spaced repetition logic lives in `sm2.py`.
- Schema definitions live in `schema.sql`.
- Server-rendered HTML lives in `templates/`.
- Client behavior lives in `static/js/`.
- Styling lives primarily in `static/style.css` and `static/card.css`.

## Important Constraints

- The core app intentionally has no framework and no build step.
- Avoid introducing backend dependencies or JS frameworks unless the user explicitly wants a migration.
- CSP is strict: no inline scripts and no inline event handlers.
- Core web-app work should preserve server-rendered flows rather than assuming SPA patterns.
- SQLite is the source of truth; schema changes must consider indexes, constraints, seed implications, and rollback risk.
- The optional `mobile/` directory is a Capacitor wrapper around the web app, not the main architecture.

## Security Baseline

- CSRF tokens are part of the request model.
- Sessions use cookies with strong defaults.
- SQL should remain parameterized.
- Input validation, path safety, and HTML safety are expected by default.

## Common Change Map

- Route or handler behavior: `app.py`
- DB connection and pragmas: `db.py`
- Schema and indexes: `schema.sql`
- Review scheduling logic: `sm2.py`
- HTML structure and server-rendered state: `templates/`
- Browser interactions: `static/js/`
- Mobile wrapper config: `mobile/`

## Project-Specific Standards

- Prefer changes that fit the current monolithic server unless the user explicitly asks for a strategic redesign.
- Keep behavior easy to trace across server, template, and JS boundaries.
- Treat accessibility, mobile behavior, and security posture as baseline quality, not optional polish.
- If a proposed change materially increases operational or architectural complexity, state that tradeoff directly.
