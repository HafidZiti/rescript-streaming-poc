import type { Metadata } from "next";

export const metadata: Metadata = {
  title: "Streamify — Films, Séries & Live",
  description:
    "Plateforme de streaming / Streaming platform — Movies, TV Shows & Live",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en" style={{ margin: 0, padding: 0 }}>
      <body style={{ margin: 0, padding: 0, overflowX: "hidden" }}>
        {children}
      </body>
    </html>
  );
}
