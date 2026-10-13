import React from 'react';

export default function Proof(): React.JSX.Element {
  return (
    <>
      <section className="sec">
        <div className="wrap">
          <h2 style={{ maxWidth: 'none' }}>Battle-tested on commercial projects</h2>
          <div className="pr-grid">
            <div className="prc">
              <b className="big">
                40%<sup>*</sup>
              </b>
              <span>shorter lead time on average</span>
            </div>
            <div className="prc">
              <b className="big" style={{ whiteSpace: 'nowrap', fontSize: '104px' }}>
                2–3×
              </b>
              <span>faster requirement gathering</span>
            </div>
            <a className="prc case" href="https://tsh.io/portfolio/100-percent-ai-driven-project">
              <span className="tag">Case study · US healthtech</span>
              <h3 className="q">
                &ldquo;We delivered a full project with 1&nbsp;developer in the time 3&nbsp;would
                normally take.&rdquo;
              </h3>
              <div className="facts">
                <div>
                  <strong>600</strong>
                  <small>tasks from the BA agent</small>
                </div>
                <div>
                  <strong>30–40</strong>
                  <small>min per feature</small>
                </div>
              </div>
              <span className="case-link">Read the case study →</span>
            </a>
          </div>
          <p className="pr-note">
            * Average across several AI agentic projects at The Software House, compared with the
            same teams before adoption.
          </p>
        </div>
      </section>
    </>
  );
}
