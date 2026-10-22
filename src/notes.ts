// Every sticky note on the homepage wall opens a page, and that page's header is the
// same note grown to full width (matched by view-transition name).
export type Tone = 'tangerine' | 'white' | 'blue';

export const SECTION_NOTES = {
  about: { name: 'note-about', tone: 'tangerine' },
  work: { name: 'note-work', tone: 'white' },
  writing: { name: 'note-writing', tone: 'blue' },
} as const satisfies Record<string, { name: string; tone: Tone }>;

// Case studies are tangerine (personal) or blue (professional); posts are white.
export const itemNote = (collection: 'work' | 'writing', id: string, kind?: 'personal' | 'professional') => ({
  name: `note-${collection}-${id}`.replace(/[^a-z0-9-]/gi, '-'),
  tone: (collection === 'writing' ? 'white' : kind === 'professional' ? 'blue' : 'tangerine') as Tone,
});
