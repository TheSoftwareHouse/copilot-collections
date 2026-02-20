import React from 'react';

import styles from './styles.module.css';

const phases = [
  {
    number: 1,
    name: 'Research',
    agent: 'Business Analyst',
    command: '/research',
    description:
      'Gather context from Jira, Figma, and the codebase. Identify gaps and open questions.',
  },
  {
    number: 2,
    name: 'Plan',
    agent: 'Architect',
    command: '/plan',
    description:
      'Design the solution and create a phased implementation plan with clear definitions of done.',
  },
  {
    number: 3,
    name: 'Implement',
    agent: 'Software Engineer',
    command: '/implement',
    description:
      'Execute the plan step-by-step with scoped, reviewable changes and continuous verification.',
  },
  {
    number: 4,
    name: 'Review',
    agent: 'Code Reviewer',
    command: '/review',
    description:
      'Verify against acceptance criteria, security, reliability, and maintainability standards.',
  },
];

export default function WorkflowShowcase(): React.JSX.Element {
  return (
    <section className={styles.showcase}>
      <div className="container">
        <div className={styles.sectionHeader}>
          <h2 className={styles.sectionTitle}>How It Works</h2>
          <p className={styles.sectionSubtitle}>
            A structured 4-phase workflow that mirrors a well-run human delivery
            process
          </p>
        </div>

        <div className={styles.timeline}>
          {phases.map((phase) => (
            <div key={phase.name} className={styles.phase}>
              <span className={styles.phaseNumber}>{phase.number}</span>
              <span className={styles.phaseName}>{phase.name}</span>
              <span className={styles.phaseAgent}>{phase.agent}</span>
              <code className={styles.phaseCommand}>{phase.command}</code>
              <p className={styles.phaseDesc}>{phase.description}</p>
            </div>
          ))}
        </div>

        <div className={styles.codeExample}>
          <div className={styles.codeHeader}>Example: End-to-End Workflow</div>
          <div className={styles.codeBody}>
            <span className={styles.codeComment}>
              # 1. Gather context and requirements
            </span>
            {'\n'}
            <span className={styles.codeCommand}>/research PROJ-123</span>
            {'\n\n'}
            <span className={styles.codeComment}>
              # 2. Create a phased implementation plan
            </span>
            {'\n'}
            <span className={styles.codeCommand}>/plan PROJ-123</span>
            {'\n\n'}
            <span className={styles.codeComment}>
              # 3. Implement with tracked progress
            </span>
            {'\n'}
            <span className={styles.codeCommand}>/implement PROJ-123</span>
            {'\n\n'}
            <span className={styles.codeComment}>
              # 4. Structured code review
            </span>
            {'\n'}
            <span className={styles.codeCommand}>/review PROJ-123</span>
          </div>
        </div>
      </div>
    </section>
  );
}
