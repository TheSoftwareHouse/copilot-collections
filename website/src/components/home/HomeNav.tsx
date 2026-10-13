import React from 'react';
import GhStars from './GhStars';

export default function HomeNav(): React.JSX.Element {
  return (
    <>
      <nav className="p-nav">
        <div className="in">
          <a className="p-logo" href="#">
            <img className="p-sig" src="/img/home/asset-01-39ffbc18.png" alt="The Software House" />{' '}
            Copilot Collections
          </a>
          <a className="p-docs" href="/docs/">
            Read the docs
          </a>
          <a className="p-gh" href="https://github.com/TheSoftwareHouse/copilot-collections">
            <img src="/img/home/asset-02-0962e269.png" alt="" />
            GitHub{' '}
            <em>
              ★ <GhStars />
            </em>
          </a>
        </div>
      </nav>
    </>
  );
}
