abstract class BaseEnv {
  String get baseUrl;
}

enum Flavor {
  prod('PMCSMS Prod'),
  staging('PMCSMS Staging'),
  dev('PMCSMS Dev');

  const Flavor(this.title);
  final String title;
}

class F {
  static Flavor appFlavor = Flavor.prod;
}

// --- Dev Environment ---
class DevEnv implements BaseEnv {
  factory DevEnv() => _instance;
  DevEnv._internal();
  static final DevEnv _instance = DevEnv._internal();

  @override
  String get baseUrl => 'https://pmcsms.com'; // Local emulator address loopback
}

// --- Staging Environment ---
class StagingEnv implements BaseEnv {
  factory StagingEnv() => _instance;
  StagingEnv._internal();
  static final StagingEnv _instance = StagingEnv._internal();

  @override
  String get baseUrl =>
      'https://pmcsms.com'; // Replace with your actual staging URL if different
}

// --- Prod Environment ---
class ProdEnv implements BaseEnv {
  factory ProdEnv() => _instance;
  ProdEnv._internal();
  static final ProdEnv _instance = ProdEnv._internal();

  @override
  String get baseUrl => 'https://pmcsms.com';
}
