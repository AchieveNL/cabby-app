class Config {
  static const Map<String, String> _baseUrls = {
    'staging': 'https://cabby-service-staging-jtj2mdm6ta-ez.a.run.app',
    'production': 'https://cabby-service-production-jtj2mdm6ta-ez.a.run.app',
  };

  // Set the current environment here
  // e.g. 'staging' or 'production'
  static const String currentEnvironment = 'staging';

  static String get baseUrl =>
      _baseUrls[currentEnvironment] ?? _baseUrls['staging']!;
}
