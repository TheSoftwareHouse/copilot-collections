import React, { useEffect, useState } from 'react';

const REPO_API = 'https://api.github.com/repos/TheSoftwareHouse/copilot-collections';
const FALLBACK_STARS = '283';

const formatStars = (n: number): string =>
  n >= 1000 ? (n / 1000).toFixed(n >= 10000 ? 0 : 1).replace(/\.0$/, '') + 'k' : String(n);

let cached: string | null = null;
let pending: Promise<string | null> | null = null;

function fetchStars(): Promise<string | null> {
  if (cached) return Promise.resolve(cached);
  pending ??= fetch(REPO_API)
    .then((r) => (r.ok ? r.json() : null))
    .then((d) =>
      d && typeof d.stargazers_count === 'number' ? formatStars(d.stargazers_count) : null,
    )
    .catch(() => null);
  return pending.then((v) => (cached = v));
}

/** Live GitHub star count; keeps the fallback number if the API is unavailable or rate-limited. */
export default function GhStars(): React.JSX.Element {
  const [stars, setStars] = useState(cached ?? FALLBACK_STARS);

  useEffect(() => {
    let alive = true;
    fetchStars().then((v) => alive && v && setStars(v));
    return () => {
      alive = false;
    };
  }, []);

  return <span>{stars}</span>;
}
