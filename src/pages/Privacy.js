import React, { useEffect } from "react";
import ReactMarkdown from "react-markdown";
import { PageAnimationWrapper, Loader } from "components";
import { useGetPrivacyPolicyQuery } from "services";
import { useTranslation } from "react-i18next";
import { useParams } from "react-router-dom";
import Error from "./Error";

const Privacy = () => {
  const { t, i18n } = useTranslation();
  const { lang } = useParams();
  const {
    data = "",
    isLoading,
    isFetching,
    isError,
    refetch,
  } = useGetPrivacyPolicyQuery(i18n.resolvedLanguage, {
    refetchOnMountOrArgChange: true,
  });

  useEffect(() => {
    // check locale
    if (lang === "fr") {
      i18n.changeLanguage("fr");
    }
  }, [lang, i18n]);

  if (isLoading || isFetching) {
    return <Loader light />;
  }

  if (isError) {
    return (
      <div className="bg-gray-50">
        <Error message={t("error-messages.network-error")} callBack={refetch} />
      </div>
    );
  }
  return (
    <PageAnimationWrapper>
      <div className="p-6 bg-white md:p-16">
        <div className="max-w-screen-xl mx-auto prose text-gray-900">
          <ReactMarkdown>{data}</ReactMarkdown>
        </div>
      </div>
    </PageAnimationWrapper>
  );
};

export default Privacy;
