"use client";

import { make as I18nProvider } from "../../../../contexts/I18nContext.gen";
import { make as MediaDetailView } from "../../../../components/organisms/MediaDetailView.gen";
import type { mediaDetail } from "../../../../core/AppTypes.gen";

type Props = {
  detail: mediaDetail;
};

export default function DetailClient({ detail }: Props) {
  return (
    <I18nProvider>
      <MediaDetailView detail={detail} />
    </I18nProvider>
  );
}
