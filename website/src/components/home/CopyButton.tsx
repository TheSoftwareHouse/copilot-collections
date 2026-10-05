import React, { useState } from 'react';

/** Copies `text` to the clipboard and briefly shows "Copied". */
export default function CopyButton({ text }: { text: string }): React.JSX.Element {
  const [copied, setCopied] = useState(false);

  const onClick = () => {
    navigator.clipboard?.writeText(text).catch(() => {});
    setCopied(true);
    setTimeout(() => setCopied(false), 1500);
  };

  return (
    <span className="cp" onClick={onClick}>
      {copied ? 'Copied' : 'Copy'}
    </span>
  );
}
