export const NAV = [
  { href: '/', label: 'Home' },
  { href: '/about/', label: 'About' },
  { href: '/writing/', label: 'Writing' },
  { href: '/work/', label: 'Work' },
];

export function activeIndex(path: string) {
  const i = NAV.findIndex((n) => n.href !== '/' && path.startsWith(n.href));
  return i === -1 ? (path === '/' ? 0 : -1) : i;
}
