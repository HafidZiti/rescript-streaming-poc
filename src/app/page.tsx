import ClientLayout from "./ClientLayout";
import { make as SearchShell } from "../components/zones/SearchShell.gen";
import SectionBoundary from "./SectionBoundary";
import TrendingSection from "./sections/TrendingSection";
import PopularSection from "./sections/PopularSection";
import SeriesSection from "./sections/SeriesSection";
import DocsSection from "./sections/DocsSection";
import TvShowsSection from "./sections/TvShowsSection";
import SearchResultsSection from "./sections/SearchResultsSection";

type SearchParams = Promise<{ q?: string | string[] }>;

export default async function Home(props: { searchParams: SearchParams }) {
  const searchParams = await props.searchParams;
  const rawQ = Array.isArray(searchParams.q)
    ? (searchParams.q[0] ?? "")
    : (searchParams.q ?? "");
  const q = rawQ.trim();

  return (
    <ClientLayout>
      <SearchShell initialQuery={q}>
        {q ? (
          <SectionBoundary>
            <SearchResultsSection q={q} />
          </SectionBoundary>
        ) : (
          <>
            <SectionBoundary>
              <TrendingSection />
            </SectionBoundary>
            <SectionBoundary>
              <PopularSection />
            </SectionBoundary>
            <SectionBoundary>
              <TvShowsSection />
            </SectionBoundary>
            <SectionBoundary>
              <SeriesSection />
            </SectionBoundary>
            <SectionBoundary>
              <DocsSection />
            </SectionBoundary>
          </>
        )}
      </SearchShell>
    </ClientLayout>
  );
}
