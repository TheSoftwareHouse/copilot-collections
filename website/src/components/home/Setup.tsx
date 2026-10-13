import React from 'react';
import GhStars from './GhStars';
import CopyButton from './CopyButton';

export default function Setup(): React.JSX.Element {
  return (
    <>
      <section className="su" id="setup">
        <div className="wrap">
          <div className="su-head">
            <div>
              <h2>
                Set it up in minutes and every project
                <br />
                gets the same agents, skills and&nbsp;checks
              </h2>
            </div>
            <a className="btn btn-p" href="https://github.com/TheSoftwareHouse/copilot-collections">
              <img src="/img/home/asset-02-0962e269.png" alt="" />
              Get it on GitHub{' '}
              <em>
                ★ <GhStars />
              </em>
            </a>
          </div>
          <div className="su-grid">
            <div className="su-c">
              <div>
                <span className="n">01</span>
                <h3>Clone the repo</h3>
                <p>It's just files: agents, skills and prompts. Keep it next to your projects.</p>
              </div>
              <div className="su-v su-t">
                <CopyButton text="git clone https://github.com/TheSoftwareHouse/copilot-collections" />
                <span className="pr">$</span> git clone \<br />
                &nbsp;&nbsp;github.com/TheSoftwareHouse/
                <br />
                &nbsp;&nbsp;copilot-collections
                <br />
                <span className="mu">Cloning… done.</span>
                <br />
                <br />
                <span className="d">▸ agents/</span>&nbsp;&nbsp;&nbsp;
                <span className="mu">25 agents</span>
                <br />
                <span className="d">▸ skills/</span>&nbsp;&nbsp;&nbsp;
                <span className="mu">36 skills</span>
                <br />
                <span className="d">▸ prompts/</span>&nbsp;&nbsp;
                <span className="mu">/tsh-* commands</span>
                <br />
                <span className="ok2">✓</span> Ready
              </div>
            </div>
            <div className="su-c">
              <div>
                <span className="n">02</span>
                <h3>Connect your tools</h3>
                <p>
                  Point your AI coding tool at the framework. Agents read Jira, Figma, Confluence
                  and your repo through MCP.
                </p>
              </div>
              <div className="su-v su-cn">
                <div className="cn-r">
                  <img src="/img/home/asset-07-b155b6be.png" alt="" />
                  <div>
                    <b>GitHub Copilot</b>
                    <small>AI coding tool</small>
                  </div>
                  <span className="ok">● Connected</span>
                </div>
                <div className="cn-r">
                  <img src="/img/home/asset-03-b084c527.png" alt="" />
                  <div>
                    <b>Jira</b>
                    <small>Tickets via MCP</small>
                  </div>
                  <span className="ok">● Connected</span>
                </div>
                <div className="cn-r">
                  <img src="/img/home/asset-04-34ed93f4.png" alt="" />
                  <div>
                    <b>Figma</b>
                    <small>Designs via MCP</small>
                  </div>
                  <span className="ok">● Connected</span>
                </div>
                <div className="cn-r">
                  <img src="/img/home/asset-06-05b9c8ec.png" alt="" />
                  <div>
                    <b>Confluence</b>
                    <small>Docs via MCP</small>
                  </div>
                  <span className="ok">● Connected</span>
                </div>
                <div className="cn-r">
                  <img src="/img/home/asset-08-ba9638a3.png" alt="" />
                  <div>
                    <b>Playwright</b>
                    <small>E2E and UI checks</small>
                  </div>
                  <span className="ok">● Connected</span>
                </div>
              </div>
            </div>
            <div className="su-c">
              <div>
                <span className="n">03</span>
                <h3>Run it on a ticket</h3>
                <p>Agents plan, build and review. Nothing merges without your approval.</p>
              </div>
              <div className="su-v su-run">
                <span className="cmd">/tsh-implement PROJ-123</span>
                <div className="box">
                  <div className="su-s">
                    <i>✓</i>Plan written<em>Architect</em>
                  </div>
                  <div className="su-s">
                    <i>✓</i>Code and tests<em>Software Engineer</em>
                  </div>
                  <div className="su-s">
                    <i>✓</i>Review passed<em>Code Reviewer</em>
                  </div>
                  <div className="ap">
                    Pull request ready<button className="g">Changes</button>
                    <button>Approve</button>
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
