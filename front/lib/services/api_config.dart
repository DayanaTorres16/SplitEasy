class ApiConfig {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3001',
  );

  static String normalize(String url) {
    return url.endsWith('/') ? url.substring(0, url.length - 1) : url;
  }
}
