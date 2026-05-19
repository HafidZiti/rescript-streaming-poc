import { fetchDocumentaries } from "../../lib/TmdbFetchers.gen";
import { make as SectionRow } from "../../components/zones/SectionRow.gen";

export default async function DocsSection() {
  const items = await fetchDocumentaries();
  return <SectionRow titleKey="sectionDocumentaries" items={items} limit={6} />;
}
