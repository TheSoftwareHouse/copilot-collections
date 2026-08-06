// Single source of truth: tsh-architect.agent.md. Regenerates the band
// variants with identical bodies and band-specific frontmatter.
// CI must fail if running this script produces a git diff.
import { readFileSync, writeFileSync } from "node:fs";

const BASE = ".github/agents/tsh-architect.agent.md";

const VARIANTS = [
  {
    file: ".github/agents/tsh-architect-deep.agent.md",
    model: '["Claude Opus 5", "Claude Sonnet 5"]',
    description:
      '"Deep-band architect variant for rare, hardest planning problems: irreversible or high-cost decisions, schema migrations, security boundary design, or cross-component architecture. Identical behavior to tsh-architect; differs only in model band. Delegation target only."',
  },
  {
    file: ".github/agents/tsh-architect-fast.agent.md",
    model: '["GPT-5.6 Luna", "Gemini 3.6 Flash"]',
    description:
      '"Fast-band architect variant restricted to light-tier plans that satisfy the tier predicate owned by tsh-creating-implementation-plans. Never authors a full-template plan: on any predicate failure it stops and returns a tier mismatch for re-delegation to tsh-architect. Delegation target only."',
  },
];

const raw = readFileSync(BASE, "utf8");
const parts = raw.split(/^---$/m);
if (parts.length < 3) throw new Error(`Cannot parse frontmatter in ${BASE}`);
const frontmatter = parts[1];
const body = parts.slice(2).join("---");

for (const v of VARIANTS) {
  let fm = frontmatter;

  const modelRe = /^model:\s*\[.*\]$/m;
  if (!modelRe.test(fm)) throw new Error("model line not found — fix script before merging");
  fm = fm.replace(modelRe, `model: ${v.model}`);

  const descRe = /^description:\s*".*"$/m;
  if (!descRe.test(fm)) throw new Error("description line not found — fix script before merging");
  fm = fm.replace(descRe, `description: ${v.description}`);

  if (/^user-invocable:/m.test(fm)) {
    fm = fm.replace(/^user-invocable:.*$/m, "user-invocable: false");
  } else {
    fm = fm.replace(modelRe, (m) => `${m}\nuser-invocable: false`);
  }

  writeFileSync(v.file, `---${fm}---${body}`);
  console.log(`synced ${v.file}`);
}
