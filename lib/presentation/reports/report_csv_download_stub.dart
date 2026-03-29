/// Non-web: CSV file download is not implemented (web-first export).
void triggerReportCsvDownload(String filename, String csvUtf8Content) {
  throw UnsupportedError(
    'Report CSV download is only available on web in this build.',
  );
}
