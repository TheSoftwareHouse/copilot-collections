import React from 'react';

import styles from './styles.module.css';

const stats = [
  { value: '30%', label: 'Faster Delivery' },
  { value: '200%+', label: 'AI Usage Growth' },
  { value: '50+', label: 'AI-Powered Projects' },
];

export default function SocialProof(): React.JSX.Element {
  return (
    <section className={styles.socialProof}>
      <div className="container">
        <div className={styles.sectionHeader}>
          <h2 className={styles.sectionTitle}>Built for Real Teams</h2>
          <p className={styles.sectionSubtitle}>
            Validated across 50+ projects at The Software House
          </p>
        </div>

        <div className={styles.quote}>
          <p className={styles.quoteText}>
            "Focus on building features. Let Copilot handle the glue."
          </p>
          <p className={styles.quoteCaption}>
            The framework acts as a virtual delivery team that handles the grunt
            work — consolidating requirements, extracting design details, mapping
            existing code, building implementation plans, and enforcing quality
            gates.
          </p>
        </div>

        <div className={styles.statsGrid}>
          {stats.map((stat) => (
            <div key={stat.label} className={styles.statCard}>
              <span className={styles.statCardValue}>{stat.value}</span>
              <span className={styles.statCardLabel}>{stat.label}</span>
            </div>
          ))}
        </div>

        <div className={styles.gartnerContext}>
          <p className={styles.gartnerText}>
            According to Gartner, only{' '}
            <span className={styles.gartnerHighlight}>
              10% of software engineers
            </span>{' '}
            see meaningful productivity improvement from AI tools. Our framework
            bridges that gap by providing structure, specialization, and
            repeatable workflows that turn AI potential into real delivery gains.
          </p>
        </div>
      </div>
    </section>
  );
}
