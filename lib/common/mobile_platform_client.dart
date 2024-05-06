import 'package:club_hub_tech_test/common/app_interceptors.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:talker_flutter/talker_flutter.dart';

abstract class PlatformClient {
  Dio get dioClient;
}

class PlatformClientImp extends PlatformClient {
  final Talker talker;

  PlatformClientImp({
    required this.talker,
  });

  @override
  Dio get dioClient => _createDioClient();

  Duration timeout() => const Duration(milliseconds: 5000);

  Dio _createDioClient() {
    final dio = Dio(
      BaseOptions(
        connectTimeout: timeout(),
        receiveTimeout: timeout(),
        baseUrl: GlobalConfiguration().getValue('baseUrlApp'),
      ),
    );

    final cacheOptions = CacheOptions(
      // A default store is required for interceptor.
      store: MemCacheStore(maxSize: 10485760, maxEntrySize: 1048576),

      // All subsequent fields are optional.

      // Default.
      policy: CachePolicy.forceCache,
      // Returns a cached response on error but for statuses 401 & 403.
      // Also allows to return a cached response on network errors (e.g. offline usage).
      // Defaults to [null].
      hitCacheOnErrorExcept: [401, 403],
      // Overrides any HTTP directive to delete entry past this duration.
      // Useful only when origin server has no cache config or custom behaviour is desired.
      // Defaults to [null].
      maxStale: const Duration(seconds: 5),
      // Default. Allows 3 cache sets and ease cleanup.
      priority: CachePriority.normal,
      // Default. Body and headers encryption with your own algorithm.
      cipher: null,
      // Default. Key builder to retrieve requests.
      keyBuilder: CacheOptions.defaultCacheKeyBuilder,
      // Default. Allows to cache POST requests.
      // Overriding [keyBuilder] is strongly recommended when [true].
      allowPostMethod: false,
    );
    dio.interceptors.addAll([
      DioCacheInterceptor(options: cacheOptions),
      AppInterceptors(talker: talker),
    ]);

    return dio;
  }
}
