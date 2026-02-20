import type { Config } from '@docusaurus/types';
import type * as Preset from '@docusaurus/preset-classic';

const config: Config = {
  title: 'Copilot Collections',
  tagline: 'Opinionated GitHub Copilot setup for delivery teams',
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

  themeConfig: {
    navbar: {
      title: 'Copilot Collections',
      logo: {
        alt: 'Copilot Collections',
        src: 'img/logo.svg',
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
          to: '/docs/agents/overview',
          label: 'Agents',
          position: 'left',
        },
        {
          to: '/docs/prompts/overview',
          label: 'Prompts',
          position: 'left',
        },
        {
          to: '/docs/skills/overview',
          label: 'Skills',
          position: 'left',
        },
        {
          to: '/docs/integrations/overview',
          label: 'Integrations',
          position: 'left',
        },
        {
          to: '/docs/value/use-cases',
          label: 'Value Proposition',
          position: 'left',
        },
        {
          to: '/changelog',
          label: 'Changelog',
          position: 'right',
        },
        {
          href: 'https://github.com/TheSoftwareHouse/copilot-collections',
          label: 'GitHub',
          position: 'right',
        },
      ],
    },
    footer: {
      style: 'dark',
      links: [
        {
          title: 'Docs',
          items: [
            { label: 'Introduction', to: '/docs/' },
            { label: 'Getting Started', to: '/docs/getting-started/prerequisites' },
            { label: 'Workflow', to: '/docs/workflow/overview' },
          ],
        },
        {
          title: 'Community',
          items: [
            {
              label: 'GitHub',
              href: 'https://github.com/TheSoftwareHouse/copilot-collections',
            },
            {
              label: 'The Software House',
              href: 'https://tsh.io',
            },
          ],
        },
        {
          title: 'More',
          items: [
            { label: 'Changelog', to: '/changelog' },
            { label: 'Agents', to: '/docs/agents/overview' },
            { label: 'Skills', to: '/docs/skills/overview' },
          ],
        },
      ],
      copyright: `© ${new Date().getFullYear()} The Software House. Built with Docusaurus.`,
    },
    colorMode: {
      defaultMode: 'light',
      respectPrefersColorScheme: true,
    },
  } satisfies Preset.ThemeConfig,
};

export default config;
