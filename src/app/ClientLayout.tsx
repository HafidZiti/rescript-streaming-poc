"use client";

import { make as I18nProvider } from "../contexts/I18nContext.gen";
import { make as Navbar } from "../components/organisms/Navbar.gen";

export default function ClientLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <I18nProvider>
      <Navbar />
      {children}
    </I18nProvider>
  );
}
