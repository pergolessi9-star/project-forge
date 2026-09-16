import "./globals.css";
import type { ReactNode } from "react";
export const metadata = { title: "PROJECT FORGE", description: "Evidence-first project discovery engine" };
export default function RootLayout({ children }: { children: ReactNode }) { return <html lang="en"><body>{children}</body></html>; }
