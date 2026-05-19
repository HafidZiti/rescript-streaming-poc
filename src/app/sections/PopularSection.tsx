import { fetchPopularMovies } from "../../lib/TmdbFetchers.gen";
import { make as SectionRow } from "../../components/zones/SectionRow.gen";

export default async function PopularSection() {
  const items = await fetchPopularMovies();
  return <SectionRow titleKey="popularMovies" items={items} limit={6} />;
}
