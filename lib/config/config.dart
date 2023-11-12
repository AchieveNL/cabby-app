class AppConfig {
  static const Map<String, String> _baseUrls = {
    'staging': 'https://api-staging.cabbyrentals.com',
    'production': 'https://api.cabbyrentals.com',
  };

  // Set the current environment here
  // e.g. 'staging' or 'production'
  static const String currentEnvironment = 'staging';

  static String get rentalAgreementUrl =>
      "${_baseUrls[currentEnvironment]}/assets/cabby_huurovereenkomst.pdf";

  static String get baseUrl =>
      _baseUrls[currentEnvironment] ?? _baseUrls['staging']!;

  static String get apiUrl => '$baseUrl/api/v1/$currentEnvironment';

  static String get supabaseUrl => 'https://wlmxjjyhoqjmfntsfxzg.supabase.co';
  static String get supabaseAnonKey =>
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndsbXhqanlob3FqbWZudHNmeHpnIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTY5MzcwNjUsImV4cCI6MjAxMjUxMzA2NX0.jDAhBgGXp-OjpkhlITBDKxIP4ZvSukiTgqH8RGjZLNc';
}
