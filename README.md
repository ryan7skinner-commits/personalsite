# ryanskinner.me

Personal site of Ryan Skinner, built with [Astro](https://astro.build) and hosted on Cloudflare Pages.

## Run locally

```sh
npm install
npm run dev      # http://localhost:4321
npm run build    # outputs to dist/
```

## Adding content

| What | Where | Notes |
| --- | --- | --- |
| Blog post | `src/content/writing/<slug>.md` | Needs `title`, `description`, `date`. Optional `tags`, `updated`, `draft`. |
| Case study | `src/content/work/<slug>.md` | Needs `title`, `summary`, `kind` (`personal` or `professional`), `date`. Optional `role`, `outcome`, `link`, `tags`, `draft`. Copy `_template.md` to start. |
| About page | `src/pages/about.astro` | |
| Name, tagline, social links, sidebar "Now" line | `src/consts.ts` | |

The file name becomes the URL. Posts with `draft: true` show up in `npm run dev` but are left out of the live site. Files starting with `_` are never published.

## Design

Brand colours live as CSS variables at the top of `src/styles/global.css`:
Tangerine `#FF5C34`, Black Cherry `#351E28`, Cool Blue `#D7EFFF`. Type is Bricolage Grotesque
(display and body) with JetBrains Mono for labels, both self-hosted via Fontsource.
Light and dark mode follow the visitor's system setting, and all motion respects
`prefers-reduced-motion`.

The homepage is a glass wall in an office: marker writing on the glass and sticky notes you can drag
around or grab. Grabbing a note grows it to fill the screen and it becomes the next page's header (matched by
view-transition name, see `src/notes.ts` and `src/components/NoteHead.astro`). The wall is a frosted glass board
standing in a studio: a generated photo in `src/assets/wall/` with a short ambient loop in `public/video/`
(desktop only, off with reduced motion). The homepage is light-only by design.

The design process (exploration, screenshot critique loop, imagery/video/motion rules and the
pre-ship checklist) lives in `.claude/skills/site-design/`. `scripts/shoot.sh` screenshots pages
at desktop and mobile sizes in light and dark mode.

## Deploying

Hosted as a Cloudflare Worker serving static assets (config in `wrangler.jsonc`).
Workers Builds runs on every push to `main`: build command `npm run build`, deploy command
`npx wrangler deploy`. The Worker's name in Cloudflare must match `name` in `wrangler.jsonc`.
