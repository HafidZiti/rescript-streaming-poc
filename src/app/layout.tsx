import type { Metadata } from "next";
import { Lato } from "next/font/google";
import EmotionRegistry from "./EmotionRegistry";

const lato = Lato({
  subsets: ["latin"],
  weight: ["300", "400", "700", "900"],
  display: "swap",
});

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
    <html
      lang="en"
      className={lato.className}
      style={{ margin: 0, padding: 0 }}
    >
      <body
        style={{
          margin: 0,
          padding: 0,
          overflowX: "hidden",
          backgroundColor: "#0a0a0f",
        }}
      >
        <EmotionRegistry>{children}</EmotionRegistry>
      </body>
    </html>
  );
}
