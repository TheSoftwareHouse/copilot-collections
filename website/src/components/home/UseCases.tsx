import React from 'react';

export default function UseCases(): React.JSX.Element {
  return (
    <>
      <section className="sec pzs" id="uc">
        <div className="wrap">
          <h2>
            One connected workflow,
            <br />
            with AI&nbsp;agents for every phase
          </h2>
          <div className="pz-grid">
            <div className="pz pz-bk tint-o">
              <div className="pz-t">
                <span className="pz-ag">
                  <span className="agvs">
                    <span className="agv sm" style={{ background: '#ffc269' }}>
                      <svg
                        viewBox="0 0 24 24"
                        fill="none"
                        stroke="#fff"
                        strokeWidth="2.2"
                        strokeLinecap="round"
                        strokeLinejoin="round"
                      >
                        <path d="M9 4h6v3H9z" />
                        <path d="M8 5H6v15h12V5h-2" />
                        <path d="M9 11h6M9 15h4" />
                      </svg>
                    </span>
                    <span className="agv sm" style={{ background: '#ffc269' }}>
                      <svg
                        viewBox="0 0 24 24"
                        fill="none"
                        stroke="#fff"
                        strokeWidth="2.2"
                        strokeLinecap="round"
                        strokeLinejoin="round"
                      >
                        <circle cx="11" cy="11" r="6" />
                        <path d="M20 20l-4.5-4.5" />
                      </svg>
                    </span>
                  </span>
                  Business Analyst + Context Engineer agents
                </span>
                <h3>Gathers the full context and turns it into a backlog</h3>
              </div>
              <div className="feed">
                <div className="fsrc">
                  <div className="fs">
                    <span className="fi">
                      <svg
                        width="20"
                        height="20"
                        viewBox="0 0 24 24"
                        fill="none"
                        stroke="#313435"
                        strokeWidth="1.6"
                        strokeLinecap="round"
                        strokeLinejoin="round"
                      >
                        <path d="M4 20h4L19 9a2.8 2.8 0 0 0-4-4L4 16v4z" />
                        <path d="M13.5 6.5l4 4" />
                      </svg>
                    </span>
                    <div>
                      <b>Workshop</b>
                      <small>transcript</small>
                    </div>
                  </div>
                  <div className="fs">
                    <span className="fi">
                      <img src="/img/home/asset-03-b084c527.png" alt="" />
                    </span>
                    <div>
                      <b>Jira</b>
                      <small>linked issues</small>
                    </div>
                  </div>
                  <div className="fs">
                    <span className="fi">
                      <img src="/img/home/asset-04-34ed93f4.png" alt="" />
                    </span>
                    <div>
                      <b>Figma</b>
                      <small>design frames</small>
                    </div>
                  </div>
                  <div className="fs">
                    <span className="fi">
                      <img src="/img/home/asset-05-957696bb.png" alt="Slack" />
                    </span>
                    <div>
                      <b>Slack</b>
                      <small>threads</small>
                    </div>
                  </div>
                  <div className="fs">
                    <span className="fi">
                      <img src="/img/home/asset-06-05b9c8ec.png" alt="" />
                    </span>
                    <div>
                      <b>Confluence</b>
                      <small>specs and docs</small>
                    </div>
                  </div>
                  <div className="fs">
                    <span className="fi">
                      <img src="/img/home/asset-02-0962e269.png" alt="" />
                    </span>
                    <div>
                      <b>GitHub</b>
                      <small>your codebase</small>
                    </div>
                  </div>
                </div>
                <svg className="farr" width="56" height="345" viewBox="0 0 56 345" fill="none">
                  <g stroke="#e0a352" strokeWidth="1.4" strokeDasharray="4 4">
                    <path d="M0 25 C30 25 26 172 54 172" />
                    <path d="M0 84 C30 84 26 172 54 172" />
                    <path d="M0 143 C30 143 26 172 54 172" />
                    <path d="M0 202 C30 202 26 172 54 172" />
                    <path d="M0 261 C30 261 26 172 54 172" />
                    <path d="M0 320 C30 320 26 172 54 172" />
                  </g>
                </svg>
                <div className="fboard">
                  <div className="v">
                    <div className="v-h">
                      <img
                        src="/img/home/asset-03-b084c527.png"
                        alt="Jira"
                        style={{ height: '20px' }}
                      />
                      <b>PROJ · Epic: Payouts</b>
                      <small>24 stories created by Business Analyst</small>
                    </div>
                    <div className="jb">
                      <div className="jc">
                        <div className="t">Retry payout on bank timeout</div>
                        <div className="ac">✓ 4 acceptance criteria</div>
                        <div className="m">
                          <i>PROJ-201</i>Story<span className="pt">5</span>
                        </div>
                      </div>
                      <div className="jc">
                        <div className="t">Notify ops after 3rd failed attempt</div>
                        <div className="ac">✓ 3 acceptance criteria</div>
                        <div className="m">
                          <i>PROJ-202</i>Story<span className="pt">3</span>
                        </div>
                      </div>
                      <div className="jc">
                        <div className="t">Show payout status to the merchant</div>
                        <div className="ac">✓ 5 acceptance criteria</div>
                        <div className="m">
                          <i>PROJ-203</i>Story<span className="pt">5</span>
                        </div>
                      </div>
                      <div className="jc">
                        <div className="t">Audit log for every retry</div>
                        <div className="ac">✓ 3 acceptance criteria</div>
                        <div className="m">
                          <i>PROJ-204</i>Story<span className="pt">2</span>
                        </div>
                      </div>
                      <div className="jc">
                        <div className="t">Cap retries to bank rate limits</div>
                        <div className="ac">✓ 2 acceptance criteria</div>
                        <div className="m">
                          <i>PROJ-205</i>Story<span className="pt">3</span>
                        </div>
                      </div>
                      <div className="jc">
                        <div className="t">Admin view of failed payouts</div>
                        <div className="ac">✓ 4 acceptance criteria</div>
                        <div className="m">
                          <i>PROJ-206</i>Story<span className="pt">5</span>
                        </div>
                      </div>
                      <div className="jmore">+ 18 more stories in 3 epics</div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <div className="pz pz-pl tint-p">
              <div className="pz-t">
                <span className="pz-ag">
                  <span className="agvs">
                    <span className="agv sm" style={{ background: '#9d8cf3' }}>
                      <svg
                        viewBox="0 0 24 24"
                        fill="none"
                        stroke="#fff"
                        strokeWidth="2.2"
                        strokeLinecap="round"
                        strokeLinejoin="round"
                      >
                        <path d="M12 3l9 5-9 5-9-5 9-5z" />
                        <path d="M3 13l9 5 9-5" />
                      </svg>
                    </span>
                  </span>
                  Architect agent
                </span>
                <h3>Plans the work before anyone writes code</h3>
              </div>
              <div className="pz-v">
                <div className="pled">
                  <div className="pled-h">
                    <span className="dots">
                      <i></i>
                      <i></i>
                      <i></i>
                    </span>
                    <b>plan.md</b>
                    <small>Ready for review</small>
                  </div>
                  <div className="pled-b">
                    <div>
                      <em>1</em>
                      <span className="h"># Payout retry on bank timeout</span>
                    </div>
                    <div>
                      <em>2</em>
                      <span className="h">## Steps</span>
                    </div>
                    <div>
                      <em>3</em>
                      <span className="s">1. RetryPolicy with exponential backoff</span>
                    </div>
                    <div>
                      <em>4</em>
                      <span className="s">2. Cap retries at 3 (bank rate limits)</span>
                    </div>
                    <div>
                      <em>5</em>
                      <span className="s">3. Notify ops on the 3rd failure</span>
                    </div>
                    <div>
                      <em>6</em>
                      <span className="s">4. Unit tests for retry.service</span>
                    </div>
                    <div>
                      <em>7</em>
                      <span className="s">5. E2E: timeout → retry → success</span>
                    </div>
                    <div>
                      <em>8</em>
                      <span className="s">6. Engineer review and merge</span>
                    </div>
                    <div>
                      <em>9</em>
                      <span className=""></span>
                    </div>
                    <div>
                      <em>10</em>
                      <span className="h">## Edge cases</span>
                    </div>
                    <div>
                      <em>11</em>
                      <span className="w">! Duplicate payouts on retry</span>
                    </div>
                    <div>
                      <em>12</em>
                      <span className="w">! Timeouts during deploys</span>
                    </div>
                    <div className="cur">
                      <em>13</em>
                      <span className="cursor"></span>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <div className="pz pz-dg tint-p">
              <div className="pz-t">
                <span className="pz-ag">
                  <span className="agvs">
                    <span className="agv sm" style={{ background: '#9d8cf3' }}>
                      <svg
                        viewBox="0 0 24 24"
                        fill="none"
                        stroke="#fff"
                        strokeWidth="2.2"
                        strokeLinecap="round"
                        strokeLinejoin="round"
                      >
                        <rect x="9" y="3" width="6" height="5" rx="1" />
                        <rect x="3" y="16" width="6" height="5" rx="1" />
                        <rect x="15" y="16" width="6" height="5" rx="1" />
                        <path d="M12 8v4M6 16v-4h12v4" />
                      </svg>
                    </span>
                  </span>
                  Engineering Manager agent
                </span>
                <h3>Hands the build to specialised agents</h3>
              </div>
              <div className="pz-v">
                <div className="hb">
                  <svg className="hbl" viewBox="0 0 100 100" preserveAspectRatio="none">
                    <g
                      stroke="#a99cf0"
                      strokeWidth="1.5"
                      strokeDasharray="4 4"
                      vectorEffect="non-scaling-stroke"
                    >
                      <line x1="50" y1="50" x2="19" y2="12" />
                      <line x1="50" y1="50" x2="81" y2="12" />
                      <line x1="50" y1="50" x2="19" y2="88" />
                      <line x1="50" y1="50" x2="81" y2="88" />
                    </g>
                  </svg>
                  <div className="hbn" style={{ left: '19%', top: '12%' }}>
                    <span className="agv" style={{ background: '#ffc269' }} title="UI">
                      <svg
                        viewBox="0 0 24 24"
                        fill="none"
                        stroke="#fff"
                        strokeWidth="2.2"
                        strokeLinecap="round"
                        strokeLinejoin="round"
                      >
                        <path d="M4 20c3 0 4-1.5 4-3.5S9.5 13 11 13s3 1.5 3 3.5" />
                        <path d="M11 13l8-9 1 1-8 9" />
                      </svg>
                    </span>
                    <div>
                      <b>UI Engineer</b>
                      <span>✓ 5 components</span>
                    </div>
                  </div>
                  <div className="hbn" style={{ left: '81%', top: '12%' }}>
                    <span className="agv" style={{ background: '#9d8cf3' }} title="SE">
                      <svg
                        viewBox="0 0 24 24"
                        fill="none"
                        stroke="#fff"
                        strokeWidth="2.2"
                        strokeLinecap="round"
                        strokeLinejoin="round"
                      >
                        <path d="M8 7l-5 5 5 5M16 7l5 5-5 5" />
                      </svg>
                    </span>
                    <div>
                      <b>Software Engineer</b>
                      <span>✓ 14 files</span>
                    </div>
                  </div>
                  <div className="hbn" style={{ left: '19%', top: '88%' }}>
                    <span className="agv" style={{ background: '#8fcaf2' }} title="DO">
                      <svg
                        viewBox="0 0 24 24"
                        fill="none"
                        stroke="#fff"
                        strokeWidth="2.2"
                        strokeLinecap="round"
                        strokeLinejoin="round"
                      >
                        <path d="M4 6l5 5-5 5M12 18h8" />
                      </svg>
                    </span>
                    <div>
                      <b>DevOps Engineer</b>
                      <span>✓ pipeline</span>
                    </div>
                  </div>
                  <div className="hbn" style={{ left: '81%', top: '88%' }}>
                    <span className="agv" style={{ background: '#ffc269' }} title="E2E">
                      <svg
                        viewBox="0 0 24 24"
                        fill="none"
                        stroke="#fff"
                        strokeWidth="2.2"
                        strokeLinecap="round"
                        strokeLinejoin="round"
                      >
                        <path d="M9 3h6M10 3v6l-5 10h14L14 9V3" />
                      </svg>
                    </span>
                    <div>
                      <b>E2E Engineer</b>
                      <span>✓ 3 tests</span>
                    </div>
                  </div>
                  <div className="hbc">
                    <span className="agv" style={{ background: '#9d8cf3' }} title="EM">
                      <svg
                        viewBox="0 0 24 24"
                        fill="none"
                        stroke="#fff"
                        strokeWidth="2.2"
                        strokeLinecap="round"
                        strokeLinejoin="round"
                      >
                        <rect x="9" y="3" width="6" height="5" rx="1" />
                        <rect x="3" y="16" width="6" height="5" rx="1" />
                        <rect x="15" y="16" width="6" height="5" rx="1" />
                        <path d="M12 8v4M6 16v-4h12v4" />
                      </svg>
                    </span>
                    <b>Engineering Manager</b>
                    <span>PROJ-123 · plan.md</span>
                  </div>
                </div>
              </div>
            </div>
            <div className="pz pz-rv tint-b">
              <div className="pz-t">
                <span className="pz-ag">
                  <span className="agvs">
                    <span className="agv sm" style={{ background: '#8fcaf2' }}>
                      <svg
                        viewBox="0 0 24 24"
                        fill="none"
                        stroke="#fff"
                        strokeWidth="2.2"
                        strokeLinecap="round"
                        strokeLinejoin="round"
                      >
                        <circle cx="6" cy="6" r="2.2" />
                        <circle cx="6" cy="18" r="2.2" />
                        <circle cx="18" cy="18" r="2.2" />
                        <path d="M6 8.2v7.6M18 15.8V9a3 3 0 0 0-3-3h-4" />
                        <path d="M13 4l-2 2 2 2" />
                      </svg>
                    </span>
                  </span>
                  Code Reviewer agent
                </span>
                <h3>Reviews every PR the same&nbsp;way</h3>
              </div>
              <div className="pz-v">
                <div className="rvs">
                  <div className="rvs-card">
                    <div className="rvs-h">
                      <b>PR #94 · Refund retry</b>
                      <span>Changes requested</span>
                    </div>
                    <div className="rvs-code">
                      <div className="fn">src/refunds/refund.service.ts</div>
                      <div className="">
                        <em>38</em>export async function retryRefund(refund) &#123;
                      </div>
                      <div className="">
                        <em>39</em> const attempt = await bank.refund(refund);
                      </div>
                      <div className="">
                        <em>40</em>
                      </div>
                      <div className="">
                        <em>41</em> if (attempt.timedOut) &#123;
                      </div>
                      <div className="bad">
                        <em>42</em> logger.info('retry', refund.accountId);
                      </div>
                      <div className="">
                        <em>43</em> return retry(refund, policy);
                      </div>
                      <div className="">
                        <em>44</em> &#125;
                      </div>
                      <div className="">
                        <em>45</em> return attempt;
                      </div>
                      <div className="">
                        <em>46</em>&#125;
                      </div>
                    </div>
                    <div className="rvs-note">
                      <span>Blocker</span>
                      <p>accountId is logged in plain text. Mask it before logging.</p>
                    </div>
                  </div>
                  <div className="rvs-you">
                    <span className="av">You</span>
                    <b>Fix 1 blocker before merge</b>
                    <button>Approve</button>
                  </div>
                </div>
              </div>
            </div>
            <div className="pz pz-ui tint-b">
              <div className="pz-t">
                <span className="pz-ag">
                  <span className="agvs">
                    <span className="agv sm" style={{ background: '#8fcaf2' }}>
                      <svg
                        viewBox="0 0 24 24"
                        fill="none"
                        stroke="#fff"
                        strokeWidth="2.2"
                        strokeLinecap="round"
                        strokeLinejoin="round"
                      >
                        <path d="M2 12s3.5-6 10-6 10 6 10 6-3.5 6-10 6S2 12 2 12z" />
                        <circle cx="12" cy="12" r="2.6" />
                      </svg>
                    </span>
                  </span>
                  UI Reviewer agent
                </span>
                <h3>Checks the build against the design</h3>
              </div>
              <div className="pz-v">
                <div className="ul">
                  <div className="ul-pair">
                    <div className="ul-s d">
                      <span className="ul-lb">Figma</span>
                      <i className="t"></i>
                      <i className="l"></i>
                      <i className="l s"></i>
                      <i className="b"></i>
                    </div>
                    <span className="ul-eq">→</span>
                    <div className="ul-s bd">
                      <span className="ul-lb">Build</span>
                      <i className="t"></i>
                      <i className="l"></i>
                      <i className="l s"></i>
                      <i className="b ulmk"></i>
                    </div>
                  </div>
                  <div className="ul-it">
                    <span>7 diffs</span>
                    <span>2 diffs</span>
                    <span className="ok">✓ Matches design</span>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>
    </>
  );
}
