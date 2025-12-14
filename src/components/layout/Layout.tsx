import { ReactNode } from 'react';
import { Navbar } from './Navbar';

interface LayoutProps {
  children: ReactNode;
}

export function Layout({ children }: LayoutProps) {
  return (
    <div className="min-h-screen bg-background terminal-grid">
      <div className="fixed inset-0 scanline pointer-events-none" />
      <Navbar />
      <main className="pt-16 relative z-10">
        {children}
      </main>
    </div>
  );
}
