class AppConfig {
  static const Map<String, String> _baseUrls = {
    'staging': 'https://cabby-service-staging-jtj2mdm6ta-ez.a.run.app',
    'production': 'https://cabby-service-production-jtj2mdm6ta-ez.a.run.app',
  };

  // Set the current environment here
  // e.g. 'staging' or 'production'
  static const String currentEnvironment = 'staging';

  static String get rentalAgreementUrl =>
      "${_baseUrls[currentEnvironment]}/assets/cabby_huurovereenkomst.pdf";

  static String get baseUrl =>
      _baseUrls[currentEnvironment] ?? _baseUrls['staging']!;

  static String get apiUrl => '$baseUrl/api/v1/$currentEnvironment';
}
