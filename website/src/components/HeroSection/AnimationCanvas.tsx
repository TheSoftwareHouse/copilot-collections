import React, { useEffect, useRef } from 'react';

const PALETTES = [
  [180, 180, 255], // violet
  [141, 212, 255], // blue
  [255, 194, 105], // amber
];

const CONNECT_DIST = 140;
const MAX_LINKS = 3;
const DENSITY_FACTOR = 18000;

interface Particle {
  x: number;
  y: number;
  vx: number;
  vy: number;
  radius: number;
  color: number[];
  phase: number;
  phaseSpeed: number;
}

function createParticles(width: number, height: number): Particle[] {
  const count = Math.floor((width * height) / DENSITY_FACTOR);

  return Array.from({ length: count }, () => ({
    x: Math.random() * width,
    y: Math.random() * height,
    vx: (Math.random() - 0.5) * 0.28,
    vy: (Math.random() - 0.5) * 0.28,
    radius: 1.2 + Math.random() * 1.6,
    color: PALETTES[Math.floor(Math.random() * PALETTES.length)],
    phase: Math.random() * Math.PI * 2,
    phaseSpeed: 0.012 + Math.random() * 0.01,
  }));
}

function updateParticles(particles: Particle[], width: number, height: number) {
  for (const p of particles) {
    p.x += p.vx;
    p.y += p.vy;
    p.phase += p.phaseSpeed;

    if (p.x < 0 || p.x > width) p.vx *= -1;
    if (p.y < 0 || p.y > height) p.vy *= -1;
  }
}

function drawEdges(ctx: CanvasRenderingContext2D, particles: Particle[]) {
  for (let i = 0; i < particles.length; i++) {
    let links = 0;

    for (let j = i + 1; j < particles.length && links < MAX_LINKS; j++) {
      const dx = particles[i].x - particles[j].x;
      const dy = particles[i].y - particles[j].y;
      const dist = Math.sqrt(dx * dx + dy * dy);

      if (dist >= CONNECT_DIST) continue;
      links++;

      const alpha = (1 - dist / CONNECT_DIST) * 0.25;
      const ci = particles[i].color;
      const cj = particles[j].color;
      const r = (ci[0] + cj[0]) >> 1;
      const g = (ci[1] + cj[1]) >> 1;
      const b = (ci[2] + cj[2]) >> 1;

      ctx.beginPath();
      ctx.moveTo(particles[i].x, particles[i].y);
      ctx.lineTo(particles[j].x, particles[j].y);
      ctx.strokeStyle = `rgba(${r},${g},${b},${alpha})`;
      ctx.lineWidth = 0.8;
      ctx.stroke();
    }
  }
}

function drawParticles(ctx: CanvasRenderingContext2D, particles: Particle[]) {
  for (const p of particles) {
    const pulse = 0.6 + 0.4 * Math.sin(p.phase);
    const [r, g, b] = p.color;

    // glow
    const glow = ctx.createRadialGradient(p.x, p.y, 0, p.x, p.y, p.radius * 5);
    glow.addColorStop(0, `rgba(${r},${g},${b},${0.18 * pulse})`);
    glow.addColorStop(1, `rgba(${r},${g},${b},0)`);
    ctx.beginPath();
    ctx.arc(p.x, p.y, p.radius * 5, 0, Math.PI * 2);
    ctx.fillStyle = glow;
    ctx.fill();

    // core dot
    ctx.beginPath();
    ctx.arc(p.x, p.y, p.radius * pulse, 0, Math.PI * 2);
    ctx.fillStyle = `rgba(${r},${g},${b},${0.75 * pulse})`;
    ctx.fill();
  }
}

export default function AnimationCanvas(): React.JSX.Element {
  const canvasRef = useRef<HTMLCanvasElement>(null);

  useEffect(() => {
    const canvas = canvasRef.current;
    if (!canvas) return;
    const ctx = canvas.getContext('2d');
    if (!ctx) return;

    let width = 0;
    let height = 0;
    let particles: Particle[] = [];
    let animId: number;

    function resize() {
      const parent = canvas.parentElement;
      if (!parent) return;

      const rect = parent.getBoundingClientRect();
      const dpr = window.devicePixelRatio || 1;

      width = rect.width;
      height = rect.height;

      canvas.width = width * dpr;
      canvas.height = height * dpr;
      canvas.style.width = width + 'px';
      canvas.style.height = height + 'px';
      ctx.setTransform(dpr, 0, 0, dpr, 0, 0);

      particles = createParticles(width, height);
    }

    function draw() {
      ctx.clearRect(0, 0, width, height);
      updateParticles(particles, width, height);
      drawEdges(ctx, particles);
      drawParticles(ctx, particles);
      animId = requestAnimationFrame(draw);
    }

    resize();
    draw();
    window.addEventListener('resize', resize);

    return () => {
      window.removeEventListener('resize', resize);
      cancelAnimationFrame(animId);
    };
  }, []);

  return (
    <canvas
      ref={canvasRef}
      aria-hidden="true"
      style={{
        position: 'absolute',
        top: 0,
        left: '50%',
        transform: 'translateX(-50%)',
        maxWidth: '1440px',
        width: '100%',
        height: '100%',
        pointerEvents: 'none',
        zIndex: 0,
        opacity: 0.5,
      }}
    />
  );
}
