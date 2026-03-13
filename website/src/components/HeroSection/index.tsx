import Link from "@docusaurus/Link";
import AnimationCanvas from "@site/src/components/HeroSection/AnimationCanvas";
import styles from './index.module.css';

const HeroSection = () => {
  return (
    <div className={styles.heroBanner}>
      <AnimationCanvas />
      <div className={styles.heroContent}>
        <h1 className={styles.heroTitle}>
          Copilot
          <br />
          Collections
        </h1>
      </div>
      <div className={`${styles.heroRight} ${styles.heroContent}`}>
        <p className={styles.heroSub}>
          Stop switching between Jira, Figma, and your codebase. One framework.
          Every phase of delivery. AI at every step.
        </p>
        <div className={styles.heroActions}>
          <Link
            className={styles.btnPrimary}
            href="https://github.com/TheSoftwareHouse/copilot-collections"
            target="_blank"
            rel="noopener noreferrer"
          >
            See on GitHub
          </Link>
          <Link className={styles.btnSecondary} to="/docs/">
            Read the docs
          </Link>
        </div>
        <p className={styles.heroProof}>
          Built by The Software House · Used daily by 300+ engineers · 50+
          commercial projects
        </p>
      </div>
    </div>
  )
}

export default HeroSection;
