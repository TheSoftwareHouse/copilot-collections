import React from 'react';

import styles from './styles.module.css';

type UseCase = {
  track: 'product' | 'dev' | 'quality';
  trackLabel: string;
  title: string;
  problem: string;
  time: string;
};

const useCases: UseCase[] = [
  {
    track: 'product',
    trackLabel: 'Product Ideation',
    title: 'Workshop Outputs to Jira Backlog',
    problem:
      'Discovery workshops produce valuable transcripts, Figma boards, and shared notes — but converting them into structured, actionable Jira tickets is a manual, error-prone process. Tasks are vague, edge cases are missed, and the backlog doesn\u2019t reflect what was actually discussed.',
    time: '~15 min vs 1–2 days',
  },
  {
    track: 'dev',
    trackLabel: 'Development',
    title: 'Single-Session Context Gathering',
    problem:
      'Requirements live in Jira, designs in Figma, documentation in Confluence, code in GitHub. Developers constantly context-switch to gather information. MCP integrations bring all context into a single Copilot chat session.',
    time: '~3 min vs 30–60 min',
  },
  {
    track: 'quality',
    trackLabel: 'Quality',
    title: 'Automated Code Review',
    problem:
      'Multi-dimensional review checking acceptance criteria, security, performance, database patterns, and coding standards. Clear PASS/BLOCKER/SUGGESTION verdicts on every run.',
    time: '~5 min',
  },
  {
    track: 'dev',
    trackLabel: 'Development',
    title: 'Pixel-Perfect UI Delivery',
    problem:
      'Frontend implementations deviate from Figma — wrong spacing, colours, component variants. QA catches these late, causing rework. The automated Figma verification loop runs up to 5 iterations, comparing the running app via Playwright against Figma specs before the code ever reaches human review.',
    time: '95–99% design accuracy',
  },
  {
    track: 'quality',
    trackLabel: 'Quality',
    title: 'Security Built Into Every Plan and Review',
    problem:
      'Security reviews happen at the end of a sprint — if at all. DRY, KISS, and proper error handling are inconsistently applied. Every plan includes security considerations by default. The Code Reviewer agent checks for vulnerabilities, missing input validation, and exposed secrets on every run.',
    time: 'Built in, every time',
  },
  {
    track: 'dev',
    trackLabel: 'Development',
    title: 'Onboarding New Team Members',
    problem:
      'New developers spend days understanding the codebase, conventions, and task requirements before they can contribute. The /tsh-implement prompt triggers the Engineering Manager, which automatically delegates to the Context Engineer to gather context from Jira, Confluence, Figma, and the codebase. It then delegates to the Architect to create a step-by-step implementation path — within minutes, not days.',
    time: '~5 min per task',
  },
  {
    track: 'dev',
    trackLabel: 'Development',
    title: 'Architecture Plan from a Ticket',
    problem:
      'Generates a phased implementation plan with CREATE/MODIFY/REUSE labels, security considerations, and clear definitions of done — directly from a Jira ticket.',
    time: '~5 min',
  },
  {
    track: 'quality',
    trackLabel: 'Quality',
    title: 'Reliable E2E Test Suites',
    problem:
      'E2E tests are written inconsistently, use brittle selectors, and break on unrelated changes. Teams stop trusting them and start skipping them. The E2E Engineer agent enforces Page Object patterns, accessibility-first locators, and verifies tests for 3+ consecutive passes before commit.',
    time: '~10 min per test suite',
  },
  {
    track: 'dev',
    trackLabel: 'Infrastructure',
    title: 'Cloud Cost Optimization',
    problem:
      'Cloud bills keep growing but nobody knows which resources are wasteful. The DevOps Engineer agent performs hybrid audits — analyzing IaC code and validating against live infrastructure via AWS/GCP APIs to identify savings opportunities.',
    time: '~10 min per audit',
  },
];

export default function QuickWins(): React.JSX.Element {
  return (
    <section className={styles.useCases}>
      <div className={styles.useCasesInner}>
        <div className={styles.useCasesHeader}>
          <h2>Core use cases</h2>
          <p>
            Every use case has dedicated agents, prompts, and workflows — not
            generic AI assistance.
          </p>
        </div>

        <div className={styles.useCasesGrid}>
          {useCases.map((uc) => (
            <div key={uc.title} className={styles.ucCard}>
              <div className={`${styles.ucTrack} ${styles[uc.track]}`}>
                {uc.trackLabel}
              </div>
              <div className={styles.ucTitle}>{uc.title}</div>
              <div className={styles.ucProblem}>{uc.problem}</div>
              <div className={styles.ucValue}>
                <span className={styles.time}>
                  <span className={styles.timeBracket}>[</span>
                  {uc.time}
                  <span className={styles.timeBracket}>]</span>
                </span>
              </div>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}
