import React from 'react';
import Link from '@docusaurus/Link';

import styles from './styles.module.css';

const steps = [
  {
    num: 1,
    title: 'Clone the repo',
    description: (
      <>
        <code>git clone [repo] copilot-collections</code> alongside your
        existing projects
      </>
    ),
  },
  {
    num: 2,
    title: 'Configure VS Code',
    description: (
      <>
        Open User Settings (JSON) → add{' '}
        <code>chat.promptFilesLocations</code> and{' '}
        <code>chat.modeFilesLocations</code> pointing to the cloned folder.
        Done once — works globally.
      </>
    ),
  },
  {
    num: 3,
    title: 'Configure MCP servers',
    description: (
      <>
        Copy <code>.vscode/mcp.json</code> to your User MCP config. Connects
        Jira, Figma, Playwright, and Context7.
      </>
    ),
  },
  {
    num: 4,
    title: 'Run your first command',
    description: (
      <>
        Open Copilot Chat → select an agent → type{' '}
        <code>/tsh-implement [JIRA_ID]</code>. If agents appear in the dropdown,
        you're ready.
      </>
    ),
  },
];

export default function GettingStartedSection(): React.JSX.Element {
  return (
    <section className={styles.gettingStarted}>
      <div className={styles.gettingStartedInner}>
        <div className={styles.leftCol}>
          <h2>
            Set up once.
            <br />
            Works across
            <br />
            every project.
          </h2>
          <p className={styles.sub}>
            Clone the repo next to your projects, configure VS Code User
            Settings once, and start using <code>/tsh-implement</code> in any
            workspace immediately.
          </p>
          <div className={styles.gsActions}>
            <Link
              className={styles.btnPrimary}
              href="https://github.com/TheSoftwareHouse/copilot-collections"
              target="_blank"
              rel="noopener noreferrer"
            >
              Get the repo on GitHub
            </Link>
            <Link className={styles.btnSecondary} to="/docs/">
              Read the docs
            </Link>
          </div>
        </div>
        <div className={styles.steps}>
          {steps.map((step, idx) => (
            <div
              key={step.num}
              className={`${styles.step} ${idx === 0 ? styles.stepFirst : ''} ${idx === steps.length - 1 ? styles.stepLast : ''}`}
            >
              <div className={styles.stepNum}>{step.num}</div>
              <div className={styles.stepContent}>
                <h4>{step.title}</h4>
                <p>{step.description}</p>
              </div>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}
