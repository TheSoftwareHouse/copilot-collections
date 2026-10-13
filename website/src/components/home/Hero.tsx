import React from 'react';
import GhStars from './GhStars';

export default function Hero(): React.JSX.Element {
  return (
    <>
      <section className="home-hero">
        <div className="wrap">
          <div className="hero-head">
            <div>
              <h1>
                An open-source framework <span>for the agentic&nbsp;SDLC</span>
              </h1>
            </div>
            <div style={{ paddingTop: '12px' }}>
              <p className="lead">
                25 agents and 36 skills take work from workshop notes to a reviewed pull request,
                inside the tools your team already uses. Nothing merges without your approval.
              </p>
              <div className="ctas">
                <a
                  className="btn btn-p"
                  href="https://github.com/TheSoftwareHouse/copilot-collections"
                >
                  <img src="/img/home/asset-02-0962e269.png" alt="" />
                  Get it on GitHub{' '}
                  <em>
                    ★ <GhStars />
                  </em>
                </a>
                <a className="btn btn-g" href="/docs/">
                  Read the docs
                </a>
              </div>
            </div>
          </div>
          <div className="hero-stage">
            <div className="vs">
              <div className="vs-top">
                <i></i>
                <i></i>
                <i></i>
                <span className="vs-cc">
                  <svg
                    width="12"
                    height="12"
                    viewBox="0 0 24 24"
                    fill="none"
                    stroke="currentColor"
                    strokeWidth="2"
                  >
                    <circle cx="11" cy="11" r="7" />
                    <path d="M20 20l-4-4" />
                  </svg>
                  payments-api (Workspace)
                </span>
              </div>
              <div className="vs-main">
                <div className="vs-act">
                  <span className="on">
                    <svg
                      width="20"
                      height="20"
                      viewBox="0 0 24 24"
                      fill="none"
                      stroke="currentColor"
                      strokeWidth="1.5"
                      strokeLinejoin="round"
                    >
                      <path d="M6 3h8l4 4v14H6z" />
                      <path d="M14 3v4h4" />
                    </svg>
                  </span>
                  <span className="">
                    <svg
                      width="20"
                      height="20"
                      viewBox="0 0 24 24"
                      fill="none"
                      stroke="currentColor"
                      strokeWidth="1.5"
                      strokeLinejoin="round"
                    >
                      <circle cx="11" cy="11" r="6" />
                      <path d="M20 20l-4.5-4.5" />
                    </svg>
                  </span>
                  <span className="">
                    <svg
                      width="20"
                      height="20"
                      viewBox="0 0 24 24"
                      fill="none"
                      stroke="currentColor"
                      strokeWidth="1.5"
                      strokeLinejoin="round"
                    >
                      <circle cx="6" cy="6" r="2" />
                      <circle cx="6" cy="18" r="2" />
                      <circle cx="18" cy="8" r="2" />
                      <path d="M6 8v8M18 10c0 4-6 3-11 6" />
                    </svg>
                  </span>
                  <span className="">
                    <svg
                      width="20"
                      height="20"
                      viewBox="0 0 24 24"
                      fill="none"
                      stroke="currentColor"
                      strokeWidth="1.5"
                      strokeLinejoin="round"
                    >
                      <path d="M7 5l12 7-12 7z" />
                    </svg>
                  </span>
                  <span className="">
                    <svg
                      width="20"
                      height="20"
                      viewBox="0 0 24 24"
                      fill="none"
                      stroke="currentColor"
                      strokeWidth="1.5"
                      strokeLinejoin="round"
                    >
                      <rect x="4" y="4" width="7" height="7" />
                      <rect x="13" y="4" width="7" height="7" />
                      <rect x="4" y="13" width="7" height="7" />
                      <rect x="13" y="13" width="7" height="7" />
                    </svg>
                  </span>
                </div>
                <div className="vs-tree">
                  <div className="vs-h">EXPLORER</div>
                  <div className="vs-r">▾ COPILOT-COLLECTIONS</div>
                  <div className="vs-f vs-dir vs-d1">.github</div>
                  <div className="vs-f vs-dir vs-d2">agents</div>
                  <div className="vs-f vs-ag vs-d3">tsh-business-analyst.agent.md</div>
                  <div className="vs-f vs-ag vs-d3">tsh-architect.agent.md</div>
                  <div className="vs-f vs-ag vs-d3">tsh-engineering-manager.agent.md</div>
                  <div className="vs-f vs-ag vs-d3">tsh-code-reviewer.agent.md</div>
                  <div className="vs-f vs-dir vs-d2">skills</div>
                  <div className="vs-f vs-dir vs-sk vs-d3">tsh-architecture-designing</div>
                  <div className="vs-f vs-dir vs-sk vs-d3">tsh-codebase-analysing</div>
                  <div className="vs-f vs-dir vs-sk vs-d3">tsh-e2e-testing</div>
                  <div className="vs-f vs-dir vs-d2">prompts</div>
                  <div className="vs-f vs-pr vs-d3">tsh-implement.prompt.md</div>
                  <div className="vs-f vs-pr vs-d3">tsh-review.prompt.md</div>
                  <div className="vs-r" style={{ marginTop: '6px' }}>
                    ▾ PAYMENTS-API
                  </div>
                  <div className="vs-f vs-dir vs-d1">src</div>
                  <div className="vs-f vs-dir vs-d1">.vscode</div>
                  <div className="vs-f vs-md vs-d1 vs-sel">plan.md</div>
                </div>
                <div className="vs-ed">
                  <div className="vs-tabs">
                    <span className="on">plan.md</span>
                    <span>retry.service.ts</span>
                    <span>payout.e2e.ts</span>
                  </div>
                  <div className="vs-code">
                    <div>
                      <em>1</em>
                      <span className="c-h"># PROJ-123 · Payout retry on bank timeout</span>
                    </div>
                    <div>
                      <em>2</em>
                      <span className="c-m">
                        Generated by Architect · tsh-creating-implementation-plans
                      </span>
                    </div>
                    <div>
                      <em>3</em>
                    </div>
                    <div>
                      <em>4</em>
                      <span className="c-h">## Context</span>
                    </div>
                    <div>
                      <em>5</em>
                      <span>- Jira: PROJ-123 + 4 linked issues</span>
                    </div>
                    <div>
                      <em>6</em>
                      <span>- Figma: </span>
                      <span className="c-s">"Payout status / v3"</span>
                    </div>
                    <div>
                      <em>7</em>
                      <span>- Code: 37 related files in </span>
                      <span className="c-k">src/payouts</span>
                    </div>
                    <div>
                      <em>8</em>
                    </div>
                    <div>
                      <em>9</em>
                      <span className="c-h">## Steps</span>
                    </div>
                    <div>
                      <em>10</em>
                      <span className="c-ok">- [x]</span>
                      <span> Add </span>
                      <span className="c-k">RetryPolicy</span>
                      <span> with exponential backoff</span>
                    </div>
                    <div>
                      <em>11</em>
                      <span className="c-ok">- [x]</span>
                      <span> Cap retries at 3 (bank rate limits)</span>
                    </div>
                    <div>
                      <em>12</em>
                      <span className="c-ok">- [x]</span>
                      <span> Notify ops channel on 3rd failure</span>
                    </div>
                    <div>
                      <em>13</em>
                      <span className="c-ok">- [x]</span>
                      <span> Unit tests for </span>
                      <span className="c-k">retry.service.ts</span>
                    </div>
                    <div>
                      <em>14</em>
                      <span className="c-ok">- [x]</span>
                      <span> E2E: timeout → retry → success</span>
                    </div>
                    <div>
                      <em>15</em>
                      <span className="c-p">- [ ]</span>
                      <span> Engineer review and merge</span>
                    </div>
                    <div>
                      <em>16</em>
                    </div>
                    <div>
                      <em>17</em>
                      <span className="c-h">## Definition of done</span>
                    </div>
                    <div>
                      <em>18</em>
                      <span>- Acceptance criteria 5/5 · security review · tests green</span>
                    </div>
                  </div>
                </div>
                <div className="vs-chat">
                  <div className="ch">
                    CHAT <b>＋ ⋯</b>
                  </div>
                  <div className="vs-msgs">
                    <div className="vs-u">
                      <span>/tsh-implement</span> PROJ-123
                    </div>
                    <div className="vs-a">
                      <div className="who">
                        <i>EM</i>Engineering Manager
                      </div>
                      <div className="sks">
                        <span>tsh-technical-context-discovering</span>
                        <span>tsh-architecture-designing</span>
                        <span>tsh-implementing-frontend</span>
                        <span>+3 skills</span>
                      </div>
                      <div className="stp">
                        <i>✓</i>
                        <div>
                          <b>Context Engineer</b>{' '}
                          <small>read PROJ-123, the Figma frame and 37 related files</small>
                        </div>
                      </div>
                      <div className="stp">
                        <i>✓</i>
                        <div>
                          <b>Architect</b> <small>wrote plan.md · 6 steps</small>
                        </div>
                      </div>
                      <div className="stp">
                        <i>✓</i>
                        <div>
                          <b>Software Engineer</b> <small>14 files changed, unit tests added</small>
                        </div>
                      </div>
                      <div className="stp">
                        <i>✓</i>
                        <div>
                          <b>E2E Engineer</b> <small>3 Playwright scenarios passing</small>
                        </div>
                      </div>
                      <div className="verd">
                        <div className="t">/tsh-review</div>
                        <div className="vrow">
                          <span className="vp">PASS 4</span>
                          <span className="vb">BLOCKER 0</span>
                          <span className="vsg">SUGGESTION 2</span>
                        </div>
                      </div>
                    </div>
                  </div>
                  <div className="vs-edits">
                    <span>▸ 14 files changed</span>
                    <button className="p">Keep</button>
                    <button>Undo</button>
                  </div>
                  <div className="vs-in">
                    <div className="vs-in-t">Add context (#), extensions (@), commands (/)</div>
                    <div className="vs-in-b">
                      <span>Engineering Manager ▾</span>
                      <span>Auto ▾</span>
                      <i>➤</i>
                    </div>
                  </div>
                </div>
              </div>
              <div className="vs-st">
                <span>⎇ feature/PROJ-123*</span>
                <span>↻ 0↓ 1↑</span>
                <span>Ln 15, Col 31</span>
                <span>Spaces: 2</span>
                <span>UTF-8</span>
                <span>Markdown</span>
                <span>✦ Copilot</span>
              </div>
            </div>
          </div>
          <div className="proof">
            <div>
              <b>40%</b>
              <small>shorter lead time</small>
            </div>
            <div>
              <b>300+</b>
              <small>engineers use it</small>
            </div>
            <div>
              <b>25</b>
              <small>specialised AI agents</small>
            </div>
            <div>
              <b>Free</b>
              <small>open source, MIT licence</small>
            </div>
          </div>
        </div>
      </section>
    </>
  );
}
