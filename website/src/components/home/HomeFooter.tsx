import React from 'react';

export default function HomeFooter(): React.JSX.Element {
  return (
    <>
      <footer>
        <div className="wrap">
          <a href="https://github.com/TheSoftwareHouse/copilot-collections">GitHub</a>
          <a href="/docs/">Read the docs</a>
          <a href="https://tsh.io">tsh.io</a>
          <span>Built by The Software House · MIT licence</span>
        </div>
      </footer>
    </>
  );
}
