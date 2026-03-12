import React, {type ReactNode} from 'react';
import clsx from 'clsx';
import type {Props} from '@theme/Admonition';
import AdmonitionLayout from '@theme/Admonition/Layout';

const infimaClassName = 'alert alert--tldr';

const defaultProps = {
  icon: '',
  title: 'TL;DR',
};

export default function AdmonitionTypeTldr(props: Props): ReactNode {
  return (
    <AdmonitionLayout
      {...defaultProps}
      {...props}
      type="tldr"
      className={clsx(infimaClassName, props.className)}>
      {props.children}
    </AdmonitionLayout>
  );
}


