import React from 'react';
import Head from '@docusaurus/Head';
import Layout from '@theme/Layout';
import HomeNav from '@site/src/components/home/HomeNav';
import Hero from '@site/src/components/home/Hero';
import UseCases from '@site/src/components/home/UseCases';
import Skills from '@site/src/components/home/Skills';
import Proof from '@site/src/components/home/Proof';
import Setup from '@site/src/components/home/Setup';
import TshBlock from '@site/src/components/home/TshBlock';
import HomeFooter from '@site/src/components/home/HomeFooter';
import '@site/src/components/home/home.css';

const TITLE = 'Copilot Collections | Open-Source Agentic SDLC Framework';
const DESCRIPTION =
  'Open-source agents and skills for GitHub Copilot. Plan, build and review every ticket the same way. 40% shorter lead time. MIT licence.';
const SOCIAL_TITLE = 'Copilot Collections: an open-source framework for the agentic SDLC';
const SOCIAL_DESCRIPTION =
  '12 agents and 32 skills take work from workshop notes to a reviewed pull request. Nothing merges without your approval.';

export default function Home(): React.JSX.Element {
  return (
    <Layout title={TITLE} description={DESCRIPTION} noFooter>
      <Head>
        <link
          href="https://fonts.googleapis.com/css2?family=Inter+Tight:wght@300;400;500;600&display=swap"
          rel="stylesheet"
        />
        <meta property="og:title" content={SOCIAL_TITLE} />
        <meta property="og:description" content={SOCIAL_DESCRIPTION} />
        <meta property="og:image:alt" content={SOCIAL_TITLE} />
        <meta name="twitter:card" content="summary_large_image" />
        <meta name="twitter:title" content={SOCIAL_TITLE} />
        <meta name="twitter:description" content={SOCIAL_DESCRIPTION} />
        <meta name="twitter:image:alt" content={SOCIAL_TITLE} />
      </Head>
      <div className="cc-home">
        <HomeNav />
        <Hero />
        <UseCases />
        <Skills />
        <Proof />
        <Setup />
        <TshBlock />
        <HomeFooter />
      </div>
    </Layout>
  );
}
