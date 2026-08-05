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
