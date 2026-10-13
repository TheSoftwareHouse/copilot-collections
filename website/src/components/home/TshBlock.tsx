import React from 'react';

export default function TshBlock(): React.JSX.Element {
  return (
    <>
      <section className="tsh">
        <div className="wrap">
          <h2 className="tsh-h">Want a team that already works this&nbsp;way?</h2>
          <div className="tsh-grid">
            <a className="tc t1" href="https://tsh.io/contact-us">
              <b>Work with The Software House</b>
              <span>
                A self-managed team in 2 weeks: senior engineers who run this framework on client
                projects.
              </span>
              <span className="tc-link">Talk to an engineer →</span>
            </a>
            <a className="tc t2" href="https://tsh.io/services/ai-enablement">
              <b>Roll it out in your team</b>
              <span>
                Our AI Enablement program covers training and support while your engineers adopt it.
              </span>
              <span className="tc-link">See AI Enablement →</span>
            </a>
          </div>
        </div>
      </section>
    </>
  );
}
