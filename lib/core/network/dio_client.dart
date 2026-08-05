import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmcsms/core/config/env/base_env.dart';
import 'package:pmcsms/core/config/env/dev_env.dart';
import 'package:pmcsms/core/config/env/prod_env.dart';
import 'package:pmcsms/core/config/env/staging_env.dart';
import 'package:pmcsms/core/config/interceptors/header_interceptor.dart';
import 'package:pmcsms/data/data/local_data_source/local_storage_impl.dart';

final dioProvider = Provider.family<Dio, BaseEnv>((ref, env) {
  final dio = Dio();

  dio.options.baseUrl = env.baseUrl;
  dio.options.headers = {
    'Content-Type': 'application/json',
  };

  // Watch your storage provider so Dio updates if the underlying storage service changes
  final storage = ref.watch(localStorageProvider);

  dio.interceptors.add(
    HeaderInterCeptor(
      dio: dio,
      secureStorage:
          storage, // Make sure your interceptor pulls the token dynamically in onRequest!
      onTokenExpired: () async {
        // Handle token expiration logic here
      },
    ),
  );

  return dio;
});
final appDioProvider = Provider<Dio>((ref) {
  final BaseEnv env = switch (F.appFlavor) {
    Flavor.prod => ProdEnv(),
    Flavor.staging => StagingEnv(),
    Flavor.dev => DevEnv(),
  };

  // Use watch here so downstream repositories get the updated Dio instance if things change
  return ref.watch(dioProvider(env));
});
