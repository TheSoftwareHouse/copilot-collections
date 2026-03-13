import React from 'react';

import AgentsIcon from './icons/agents.svg';
import IntegrationsIcon from './icons/integrations.svg';
import LifecycleIcon from './icons/lifecycle.svg';
import RequirementsIcon from './icons/requirements.svg';
import VerificationIcon from './icons/verification.svg';
import WorkflowIcon from './icons/workflow.svg';
import styles from './styles.module.css';

/* ── Card data ──────────────────────────────────────────────── */

type CardItem = {
  icon: React.ReactNode;
  title: string;
  description: string;
};

const cards: CardItem[] = [
  {
    icon: <LifecycleIcon className={styles.cardIcon} />,
    title: 'End-to-End Product Lifecycle',
    description:
      'Covers Product Ideation, Development, and Quality in a single framework. From workshop transcript to production-ready code — every phase has dedicated agents, skills, and workflows.',
  },
  {
    icon: <AgentsIcon className={styles.cardIcon} />,
    title: '10 Specialized AI Agents',
    description:
      'Business Analyst, Architect, Software Engineer, Code Reviewer, UI Reviewer, E2E Engineer, DevOps Engineer, Context Engineer, Copilot Engineer, and Copilot Orchestrator — each focused on its phase, working together in a structured sequence.',
  },
  {
    icon: <WorkflowIcon className={styles.cardIcon} />,
    title: 'Structured Delivery Workflow',
    description:
      'Research → Plan → Implement → Review. Each phase feeds the next. Research becomes the plan. The plan becomes the implementation checklist. Review returns issues to the exact phase.',
  },
  {
    icon: <VerificationIcon className={styles.cardIcon} />,
    title: 'Pixel-Perfect UI Verification',
    description:
      'Automated Figma comparison loop in every UI implementation cycle. Playwright captures the rendered state and compares it to the design spec. Mismatches are fixed before review.',
  },
  {
    icon: <RequirementsIcon className={styles.cardIcon} />,
    title: 'Requirements Processing',
    description:
      'Turn workshop transcripts and meeting notes into Jira-ready user stories before a line of code is written. The framework starts at the source of the work, not just the ticket.',
  },
  {
    icon: <IntegrationsIcon className={styles.cardIcon} />,
    title: 'MCP Tool Integrations',
    description:
      'Jira, Figma Dev Mode, Context7, Playwright, Sequential Thinking, AWS API, GCP Gcloud, and more — wired into the workflow phases, not bolted on. Context flows through every step automatically.',
  },
];

/* ── Component ──────────────────────────────────────────────── */

export default function HomepageFeatures(): React.JSX.Element {
  return (
    <section className={styles.framework}>
      <div className={styles.frameworkInner}>
        <div className={styles.frameworkLabel}>
          A complete AI
          <br />
          product engineering
          <br />
          framework — not
          <br />
          just a set of prompts
        </div>
        <div className={styles.cardsGrid}>
          {cards.map((card) => (
            <div key={card.title} className={styles.cardDark}>
              {card.icon}
              <h3>{card.title}</h3>
              <p>{card.description}</p>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}
