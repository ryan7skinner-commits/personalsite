# ryanskinner.me

Astro 7 + Markdown site, deployed as a Cloudflare Worker serving static assets. See README.md for content and deploy details.

- Any visual change (new page, section, component, imagery, video, motion, restyle): follow `.claude/skills/site-design/SKILL.md` before writing code, including its critic subagent loop and ship checks.
- `npm run build` must pass before a PR. `scripts/shoot.sh` builds and screenshots pages for review.
- Image/video generation keys (`OPENAI_API_KEY`, `GEMINI_API_KEY`, `FAL_KEY`) are for development only. Never commit them or use them from site code. Local copies go in `.env.agents` (gitignored).
