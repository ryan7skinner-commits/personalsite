---
name: site-design
description: Design-quality process for ryanskinner.me. Use for any visual change to the site (new page, section, component, imagery, video, motion, restyle) before writing code, and to review a design before shipping it.
---

# Site design process

AI design output drifts to the safe, averaged, "seen it before" choice. This process exists to push past that and to judge the result honestly. It follows Discover → Define → Deliver (adapted from Anshu Chimala's "How to turn your AI into a world-class designer", Lenny's Newsletter, 2026), tuned for this site.

Skip straight to **Deliver** for small fixes (copy, spacing, a bug). Use the full loop for anything a visitor would notice as new.

## The brief (never changes without Ryan)

- **Feel:** bold, fun, vibrant, dynamic. A product manager's site with personality, not a template.
- **What Ryan likes in the references** (cloudstudio.es, therawmaterials.com/hello) is the *motion*: the active section grows, sections expand, things respond. Borrow behaviour, never the look.
- **Palette:** Tangerine `#FF5C34`, Black Cherry `#351E28`, Cool Blue `#D7EFFF`, plus white and the derived `#8e2f2a`. Tokens live in `src/styles/global.css`; never hard-code a new colour outside it. Tangerine fails contrast as small text on Cool Blue: use it for large type, fills and shapes only.
- **Type:** Bricolage Grotesque Variable (display + body, use the `opsz`/`wdth` axes), JetBrains Mono for labels.
- **Signature elements already shipped:** expanding colour-tile sidebar, neo-brutalist cards with hard offset shadows, tilted marquee, scribble highlight, spinning badge. New work should feel like the same hand made it.

## 1. Discover: go broad before going deep

1. **Seed for variety.** Run `scripts/design-seed.sh` and derive the exploration from the string (e.g. character codes pick a layout archetype, a motion verb, an outside reference), so each run starts somewhere new instead of the model's favourite answer. Never put the seed on the site or in the commit.
2. **Borrow from outside web design.** Name a concrete non-web reference and say how it shapes the work: a risograph zine, a transit map, a Teenage Engineering manual, a skate deck, a 90s game menu. "Modern and clean" is not a direction.
3. **Many thin ideas first.** Write 5–8 one-line directions, light on detail. Show Ryan the 2–3 strongest as a quick sketch or screenshot when the change is large; otherwise pick one and say why.
4. **Keep a failure log.** If a direction couldn't be built well, add a line to `docs/design-log.md` (what was tried, why it failed) so it can be retried with a newer model.

## 2. Define: build it, then let a critic who can't see the code judge it

1. Build the chosen direction.
2. Screenshot it: `scripts/shoot.sh .design-review /path/` (desktop 1440 + mobile 390, light + dark). Full-page shots cut the fixed sidebar short; that's a capture artifact, not a bug.
3. **Critic pass.** Spawn a separate subagent (strongest available model) with *only* the screenshots, the brief above, and the prompt in `critic-prompt.md`. No code, no diff, no history of earlier rounds. Use the exact same prompt every round.
4. Apply the top fixes, re-shoot, re-critique.
5. **Stop rule (don't tell the critic):** done at **9/10 or higher**. Run at most 3 rounds; if the score isn't climbing after 2, stop and show Ryan the screenshots with the critic's last notes instead of burning tokens.

## 3. Imagery, video and motion

The site currently runs on type and colour alone. Real imagery is the biggest single upgrade; gradients and blobs are the AI default and are banned as filler.

**Images**
- Prefer real photos Ryan supplies (portrait, desk, sketches, product screenshots). Generated images are for texture, illustration and case-study covers, never fake photos of Ryan or fake product UI.
- Generate via the image API whose key is in the environment (`OPENAI_API_KEY` or `GEMINI_API_KEY`). Keys are dev-only: never commit them, never reference them from site code. Local keys go in `.env.agents` (gitignored by `.env*`).
- Keep a consistent art direction per set: write the style line once (medium, palette in hex, lighting, grain) and reuse it for every image in the set.
- Put source images in `src/assets/` and render with Astro's `<Image>`/`<Picture>` (AVIF/WebP, explicit width/height, `loading="lazy"` below the fold). Hero image ≤ 200 KB after optimisation. Always write real `alt` text, or `alt=""` for decoration.

**Video**
- Use for ambient loops and transitions, not talking heads. Generate via fal.ai (`FAL_KEY`) so the best model can be picked per clip.
- *Animated graphic:* generate on a flat chroma background, key it out, export WebM (VP9 with alpha) + HEVC-alpha MP4 fallback, layer it into the page so it doesn't read as "a video".
- *State transition:* generate keyframe stills first, then interpolate between them; the last frame of one clip seeds the next. Scrub it on scroll or play it on navigation.
- Encode with ffmpeg: `-an`, ≤ 1080p, loops under 1.5 MB. `autoplay muted loop playsinline`, a `poster` image, and pause when off-screen. Clips over ~5 MB or many clips go to Cloudflare R2/Stream, not `public/` (Workers static assets cap at 25 MiB per file).

**Motion**
- Order of preference: CSS transitions/keyframes → CSS scroll-driven animations (`animation-timeline: view()`) → View Transitions (already on via `ClientRouter`) → a small library (Motion One / GSAP) only when the above can't do it. WebGL/shaders only for one hero moment, lazy-loaded.
- Motion should explain or reward: something grows because it's active, moves because you scrolled, reacts because you hovered. No motion that just loops for attention, except one signature piece per page.
- Easing: use the site's curves (`cubic-bezier(.7,0,.2,1)` for big layout moves, `cubic-bezier(.3,1.6,.5,1)` for playful overshoot). 200–400 ms for UI feedback, 600–900 ms for layout.
- Animate `transform`, `opacity`, `clip-path`, `flex-grow` sparingly; never animate properties that thrash layout on scroll.
- Everything must respect `prefers-reduced-motion` (a global kill switch exists in `global.css`; video and JS animation must check it too and show the poster/end state).

## 4. Deliver: subtract, then remove the AI tells

**Subtraction pass.** For every element ask "what does this do for the visitor?" Remove anything that only decorates: extra glows, gradients, borders inside borders, redundant labels, a second accent where one will do, custom controls that are worse than native ones. Restraint reads as confidence; one loud thing per section.

**AI tells checklist** (fix every hit):
- Purple/blue gradients, glassmorphism, glowing blobs, or "aurora" backgrounds as filler.
- Emoji as icons; generic line icons in a circle above every heading.
- Three equal cards in a row with icon + title + two lines, as the default layout for everything.
- Everything centred; identical section rhythm top to bottom.
- Rounded-2xl-shadow-lg on every box; uniform radius and spacing with no hierarchy.
- Vague hero copy ("Building the future of…"), "Lorem"-style filler, fake testimonials, invented metrics.
- Random words highlighted in the accent colour.
- Gratuitous fade-up-on-scroll on every block.
- Stock-photo-style generated people, extra fingers, garbled text in images.

**Ship checks**
- `npm run build` passes; check `/`, `/work/`, `/writing/`, `/about/` at 390 px and 1440 px, light and dark.
- Contrast: body text ≥ 4.5:1, large text ≥ 3:1.
- Keyboard: every interactive element reachable with a visible focus ring.
- No layout shift from media (dimensions set), no horizontal scroll on mobile.
- Reduced-motion mode looks finished, not broken.
- Attach the final screenshots (and the critic's last score) to the PR description.
