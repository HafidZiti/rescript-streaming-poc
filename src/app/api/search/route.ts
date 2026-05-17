import { NextResponse } from "next/server";
import { searchTmdb } from "../../../lib/TmdbFetchers.gen";

export async function GET(request: Request) {
  const { searchParams } = new URL(request.url);
  const q = searchParams.get("q") ?? "";

  const results = await searchTmdb(q);
  return NextResponse.json(results, {
    headers: { "Cache-Control": "no-store" },
  });
}
