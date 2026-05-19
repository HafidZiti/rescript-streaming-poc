"use client";

import { Suspense } from "react";
import { ErrorBoundary } from "react-error-boundary";
import { useRouter } from "next/navigation";
import { make as Spinner } from "../components/atoms/Spinner.gen";
import { make as ErrorView } from "../components/organisms/ErrorView.gen";

export default function SectionBoundary({
  children,
}: {
  children: React.ReactNode;
}) {
  const router = useRouter();
  return (
    <ErrorBoundary
      FallbackComponent={({ error, resetErrorBoundary }) => (
        <ErrorView
          error={{
            message: error instanceof Error ? error.message : String(error),
          }}
          reset={resetErrorBoundary}
        />
      )}
      onReset={() => router.refresh()}
    >
      <Suspense fallback={<Spinner />}>{children}</Suspense>
    </ErrorBoundary>
  );
}
