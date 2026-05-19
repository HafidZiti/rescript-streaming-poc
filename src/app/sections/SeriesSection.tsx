import { fetchSeries } from "../../lib/TmdbFetchers.gen";
import { make as SectionRow } from "../../components/zones/SectionRow.gen";

export default async function SeriesSection() {
  const items = await fetchSeries();
  return <SectionRow titleKey="sectionSeries" items={items} limit={6} />;
}
