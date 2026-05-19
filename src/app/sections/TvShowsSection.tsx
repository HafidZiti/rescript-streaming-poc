import { fetchTvShows } from "../../lib/TmdbFetchers.gen";
import { make as SectionRow } from "../../components/zones/SectionRow.gen";

export default async function TvShowsSection() {
  const items = await fetchTvShows();
  return <SectionRow titleKey="sectionTvShows" items={items} limit={6} />;
}
