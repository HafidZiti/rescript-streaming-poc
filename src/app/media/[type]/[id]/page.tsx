import { notFound } from "next/navigation";
import { fetchMediaDetail } from "../../../../lib/tmdb-detail";
import DetailClient from "./DetailClient";

type Props = {
  params: Promise<{ type: string; id: string }>;
};

export default async function MediaDetailPage({ params }: Props) {
  const { type, id } = await params;

  if (type !== "movie" && type !== "tv") {
    notFound();
  }

  const detail = await fetchMediaDetail(type as "movie" | "tv", id);

  if (!detail) {
    notFound();
  }

  return <DetailClient detail={detail} />;
}
