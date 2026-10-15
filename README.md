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
| Name, tagline, social links | `src/consts.ts` | |

The file name becomes the URL. Posts with `draft: true` show up in `npm run dev` but are left out of the live site. Files starting with `_` are never published.

## Deploying

Cloudflare Pages builds every push to `main`. Build command `npm run build`, output directory `dist`.
