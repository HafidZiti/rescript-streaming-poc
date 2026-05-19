import { fetchTrending } from "../../lib/TmdbFetchers.gen";
import { make as SectionRow } from "../../components/zones/SectionRow.gen";

export default async function TrendingSection() {
  const items = await fetchTrending();
  return <SectionRow titleKey="trendingNow" items={items} showDot />;
}
