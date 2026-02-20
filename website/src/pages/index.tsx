import React from 'react';
import Link from '@docusaurus/Link';
import useDocusaurusContext from '@docusaurus/useDocusaurusContext';
import Layout from '@theme/Layout';
import HomepageFeatures from '@site/src/components/HomepageFeatures';
import WorkflowShowcase from '@site/src/components/WorkflowShowcase';
import SocialProof from '@site/src/components/SocialProof';

import styles from './index.module.css';

const frameworkStats = [
  { value: '6', label: 'Agents' },
  { value: '10', label: 'Skills' },
  { value: '8', label: 'Commands' },
  { value: '5', label: 'MCPs' },
];

const impactStats = [
  { value: '30%', label: 'Faster Delivery' },
  { value: '200%+', label: 'AI Usage Growth' },
  { value: '50+', label: 'AI-Powered Projects' },
];

function HomepageHeader() {
  const { siteConfig } = useDocusaurusContext();

  return (
    <header className={styles.heroBanner}>
      <div className="container">
        <h1 className={styles.heroTitle}>{siteConfig.title}</h1>
        <p className={styles.heroSubtitle}>{siteConfig.tagline}</p>
        <p className={styles.heroDescription}>
          Focus on building features – let Copilot handle the glue.
          <br />
          Built by{' '}
          <a
            href="https://tsh.io"
            target="_blank"
            rel="noopener noreferrer"
            className={styles.heroLink}
          >
            The Software House
          </a>
          .
        </p>

        <div className={styles.statsBar}>
          {frameworkStats.map((stat) => (
            <div key={stat.label} className={styles.statItem}>
              <span className={styles.statValue}>{stat.value}</span>
              <span className={styles.statLabel}>{stat.label}</span>
            </div>
          ))}
        </div>

        <div className={styles.impactStats}>
          {impactStats.map((stat) => (
            <div key={stat.label} className={styles.impactItem}>
              <span className={styles.impactValue}>{stat.value}</span>
              <span className={styles.impactLabel}>{stat.label}</span>
            </div>
          ))}
        </div>

        <div className={styles.buttons}>
          <Link className={styles.ctaPrimary} to="/docs/">
            Get Started
          </Link>
          <Link
            className={styles.ctaSecondary}
            href="https://github.com/TheSoftwareHouse/copilot-collections"
            target="_blank"
            rel="noopener noreferrer"
          >
            GitHub
          </Link>
        </div>
      </div>
    </header>
  );
}

export default function Home(): React.JSX.Element {
  const { siteConfig } = useDocusaurusContext();

  return (
    <Layout
      title={siteConfig.title}
      description="Opinionated GitHub Copilot setup for delivery teams – with shared workflows, agents, prompts, skills and MCP integrations."
    >
      <HomepageHeader />
      <main>
        <HomepageFeatures />
        <WorkflowShowcase />
        <SocialProof />
      </main>
    </Layout>
  );
}
