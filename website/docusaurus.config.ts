import type { Config } from '@docusaurus/types';
import type * as Preset from '@docusaurus/preset-classic';

const config: Config = {
  title: 'Copilot Collections',
  tagline: 'AI-powered product engineering framework — from ideation to delivery',
  favicon: 'img/favicon.ico',

  url: 'https://copilot-collections.vercel.app',
  baseUrl: '/',

  onBrokenLinks: 'throw',

  i18n: {
    defaultLocale: 'en',
    locales: ['en'],
  },

  presets: [
    [
      'classic',
      {
        docs: {
          sidebarPath: './sidebars.ts',
          routeBasePath: 'docs',
        },
        blog: false,
        pages: {},
        theme: {
          customCss: './src/css/custom.css',
        },
      } satisfies Preset.Options,
    ],
  ],

  themes: [
    [
      '@easyops-cn/docusaurus-search-local',
      {
        hashed: true,
        indexBlog: false,
      },
    ],
  ],

  headTags: [
    {
      tagName: 'link',
      attributes: {
        rel: 'preconnect',
        href: 'https://fonts.googleapis.com',
      },
    },
    {
      tagName: 'link',
      attributes: {
        rel: 'preconnect',
        href: 'https://fonts.gstatic.com',
        crossorigin: 'anonymous',
      },
    },
    {
      tagName: 'link',
      attributes: {
        rel: 'stylesheet',
        href: 'https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap',
      },
    },
  ],

  themeConfig: {
    navbar: {
      title: 'Copilot Collections',
      logo: {
        alt: 'tsh-logo',
        src: 'img/logo-white.svg',
      },
      items: [
        {
          type: 'docSidebar',
          sidebarId: 'tutorialSidebar',
          position: 'left',
          label: 'Docs',
        },
        {
          to: '/docs/workflow/overview',
          label: 'Workflow',
          position: 'left',
        },
        {
          type: 'dropdown',
          label: 'Components',
          position: 'left',
          items: [
            {
              to: '/docs/agents/overview',
              label: 'Agents',
            },
            {
              to: '/docs/prompts/overview',
              label: 'Prompts',
            },
            {
              to: '/docs/skills/overview',
              label: 'Skills',
            },
            {
              to: '/docs/integrations/overview',
              label: 'Integrations',
            },
          ],
        },
        {
          to: '/docs/use-cases',
          label: 'Use Cases',
          position: 'left',
        },
        {
          to: '/docs/for-ctos',
          label: 'For CTOs',
          position: 'left',
          className: 'navbar__link--cto',
        },
        {
          to: '/changelog',
          label: 'Changelog',
          position: 'right',
          className: 'navbar__link--meta',
        },
        {
          href: 'https://github.com/TheSoftwareHouse/copilot-collections',
          label: 'GitHub ↗',
          position: 'right',
          className: 'navbar__link--github',
        },
      ],
    },
    footer: {
      style: 'light',
      copyright: `copilot-collections · Built by <a href="https://tsh.io" target="_blank" rel="noopener noreferrer">The Software House</a> · MIT licence · Free`,
      links: [
        {
          title: ' ',
          items: [
            {
              href: 'https://github.com/TheSoftwareHouse/copilot-collections',
              label: 'GitHub',
            },
            { label: 'Docs', to: '/docs/' },
            { label: 'Methodology', to: '/docs/workflow/overview' },
            {
              label: 'tsh.io',
              href: 'https://tsh.io',
            },
          ],
        },
      ],
    },
    colorMode: {
      defaultMode: 'dark',
      disableSwitch: true,
      respectPrefersColorScheme: false,
    },
  } satisfies Preset.ThemeConfig,
};

export default config;
