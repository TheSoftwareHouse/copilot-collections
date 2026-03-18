import React from 'react';

import styles from './styles.module.css';

export default function SdlcDiagram(): React.JSX.Element {
  return (
    <div
      className={styles.wrapper}
      role="img"
      aria-label="SDLC workflow diagram showing the flow from Human Intent through Product Ideation, Development, and Quality phases to delivery"
    >
      <div className={styles.diagram}>
        {/* Human Intent */}
        <div className={styles.pill}>
          <span className={styles.pip} />
          Human Intent + Context
        </div>
        <div className={`${styles.conn} ${styles.conn20}`} />

        {/* AI Agent */}
        <div className={styles.agentNode}>
          <div className={styles.agentTitle}>AI Agent</div>
          <div className={styles.agentSub}>Copilot Collections</div>
        </div>
        <div className={`${styles.conn} ${styles.conn36}`} />

        {/* Ideation Phase */}
        <div className={`${styles.phase} ${styles.phaseIdeation}`}>
          <div className={styles.phaseHeader}>
            <span className={styles.phaseTag}>Product Ideation</span>
          </div>
          <div className={styles.card}>
            <div className={styles.cardCmd}>
              <strong className={styles.cardCmdStrong}>/tsh-analyze-materials</strong>
            </div>
            <div className={styles.cardDesc}>
              Clean transcript → extract tasks → produce Jira-ready stories with
              full acceptance criteria
            </div>
          </div>
        </div>
        <div className={`${styles.conn} ${styles.conn36}`} />

        {/* Development Phase */}
        <div className={`${styles.phase} ${styles.phaseDev}`}>
          <div className={styles.phaseHeader}>
            <span className={styles.phaseTag}>Development</span>
          </div>
          <div className={styles.card}>
            <div className={styles.cardCmd}>
              <strong className={styles.cardCmdStrong}>/tsh-research</strong>
            </div>
            <div className={styles.cardDesc}>
              Gather all technical context — Jira, GitHub, Figma — in a single
              session
            </div>
          </div>
          <div className={styles.innerConn} />
          <div className={styles.card}>
            <div className={styles.cardCmd}>
              <strong className={styles.cardCmdStrong}>/tsh-plan</strong>
            </div>
            <div className={styles.cardDesc}>
              Design architecture, define steps, surface edge cases before
              writing a line of code
            </div>
          </div>
          <div className={styles.innerConn} />
          <div className={styles.card}>
            <div className={styles.cardCmd}>
              <strong className={styles.cardCmdStrong}>/tsh-implement</strong>
              <span style={{fontSize: '0.7rem', opacity: 0.7, marginLeft: '0.5rem'}}>Engineering Manager</span>
            </div>
            <div className={styles.cardDesc}>
              Orchestrates work — delegates backend, frontend, infra, and tests
              to specialized agents
            </div>
          </div>
          <div className={styles.parallelLabel}>↓ delegates to</div>
          <div className={styles.grid3}>
            <div className={styles.card}>
              <div className={styles.cardCmd}>
                <strong className={styles.cardCmdStrong}>Software Engineer</strong>
              </div>
              <div className={styles.cardDesc}>
                Backend, frontend, APIs, data layers
              </div>
            </div>
            <div className={styles.card}>
              <div className={styles.cardCmd}>
                <strong className={styles.cardCmdStrong}>DevOps Engineer</strong>
              </div>
              <div className={styles.cardDesc}>
                Cloud and infrastructure
              </div>
            </div>
            <div className={styles.card}>
              <div className={styles.cardCmd}>
                <strong className={styles.cardCmdStrong}>E2E Engineer</strong>
              </div>
              <div className={styles.cardDesc}>
                End-to-end tests
              </div>
            </div>
          </div>
        </div>

        {/* Issues Found */}
        <div className={`${styles.conn} ${styles.conn20} ${styles.connOrange}`} />
        <div className={`${styles.badge} ${styles.badgeIssues}`}>
          <span className={styles.badgeIcon} aria-hidden="true">↑</span>
          Issues found
          <span className={styles.badgeIcon} aria-hidden="true">↓</span>
        </div>
        <div className={`${styles.conn} ${styles.conn20} ${styles.connOrange}`} />

        {/* Quality Phase */}
        <div className={`${styles.phase} ${styles.phaseQuality}`}>
          <div className={styles.phaseHeader}>
            <span className={styles.phaseTag}>Quality</span>
          </div>
          <div className={styles.grid2}>
            <div className={styles.card}>
              <div className={styles.cardCmd}>
                <strong className={styles.cardCmdStrong}>/tsh-review</strong>
              </div>
              <div className={styles.cardDesc}>
                PASS / BLOCKER / SUGGESTION — security, perf, coding standards
              </div>
            </div>
            <div className={styles.card}>
              <div className={styles.cardCmd}>
                <strong className={styles.cardCmdStrong}>/tsh-review-ui</strong>
              </div>
              <div className={styles.cardDesc}>
                Playwright vs Figma · up to 5 auto-iterations
              </div>
            </div>
          </div>
        </div>

        {/* Approved */}
        <div className={`${styles.conn} ${styles.conn20} ${styles.connGreen}`} />
        <div className={`${styles.badge} ${styles.badgeApproved}`}>
          <span className={styles.badgeIcon} aria-hidden="true">✓</span>
          Approved
        </div>
        <div className={`${styles.conn} ${styles.conn20} ${styles.connGreen}`} />

        {/* Observe */}
        <div className={styles.observeWrap}>
          <div className={styles.observeDiamond} />
          <div className={styles.observeText}>Observe</div>
        </div>

        {/* Fine */}
        <div className={`${styles.conn} ${styles.conn20} ${styles.connBlue}`} />
        <div className={`${styles.badge} ${styles.badgeFine}`}>
          <span className={styles.badgeIcon} aria-hidden="true">✓</span>
          Fine
        </div>
        <div className={`${styles.conn} ${styles.conn20} ${styles.connBlue}`} />

        {/* Next Intent */}
        <div className={styles.pill}>
          <span className={styles.pip} />
          Next Intent
        </div>

        {/* Problem Return Arc */}
        <svg
          className={styles.returnSvg}
          viewBox="0 0 80 600"
          preserveAspectRatio="none"
          aria-hidden="true"
        >
          <defs>
            <marker
              id="arr-p"
              markerWidth="8"
              markerHeight="8"
              refX="4"
              refY="4"
              orient="auto"
            >
              <path d="M0,0 L0,8 L8,4 z" fill="#f97316" />
            </marker>
          </defs>
          <path
            d="M 8 555 Q 60 555 60 300 Q 60 55 8 55"
            stroke="#f97316"
            strokeWidth="1.5"
            fill="none"
            strokeDasharray="5,4"
            markerEnd="url(#arr-p)"
            opacity="0.6"
          />
          <text
            x="74"
            y="300"
            fill="rgba(249,115,22,0.8)"
            fontSize="8.5"
            fontFamily="DM Mono,monospace"
            letterSpacing="2.5"
            textAnchor="middle"
            transform="rotate(90,74,300)"
          >
            PROBLEM
          </text>
        </svg>
      </div>
    </div>
  );
}
