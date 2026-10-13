import React from 'react';
import Navbar from '@theme-original/Navbar';
import type NavbarType from '@theme/Navbar';
import type { WrapperProps } from '@docusaurus/types';
import { useLocation } from '@docusaurus/router';
import useBaseUrl from '@docusaurus/useBaseUrl';

type Props = WrapperProps<typeof NavbarType>;

/** The homepage ships its own navigation, so the global Docusaurus navbar is hidden there only. */
export default function NavbarWrapper(props: Props): React.JSX.Element | null {
  const { pathname } = useLocation();
  const home = useBaseUrl('/');
  if (pathname === home || pathname === home.replace(/\/$/, '')) return null;
  return <Navbar {...props} />;
}
