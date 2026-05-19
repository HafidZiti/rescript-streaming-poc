import { searchTmdb } from "../../lib/TmdbFetchers.gen";
import { make as SectionRow } from "../../components/zones/SectionRow.gen";

export default async function SearchResultsSection({ q }: { q: string }) {
  const items = await searchTmdb(q);
  return <SectionRow titleKey="searchResults" items={items} />;
}
