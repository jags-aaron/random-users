import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';
import 'package:talker_dio_logger/talker_dio_logger_settings.dart';
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
    dio.interceptors.addAll([
      TalkerDioLogger(
        talker: talker,
        settings: const TalkerDioLoggerSettings(
          printRequestHeaders: true,
          printResponseHeaders: true,
          printRequestData: true,
          printResponseData: true,
          printResponseMessage: true,
        ),
      ),
    ]);

    final cacheOptions = CacheOptions(
      store: MemCacheStore(maxSize: 10485760, maxEntrySize: 1048576),
      policy: CachePolicy.forceCache,
      // Returns a cached response on error but for statuses 401 & 403.
      // Also allows to return a cached response on network errors (e.g. offline usage).
      // Defaults to [null].
      hitCacheOnErrorExcept: [401, 403],
      // Overrides any HTTP directive to delete entry past this duration.
      // Useful only when origin server has no cache config or custom behaviour is desired.
      // Defaults to [null].
      maxStale: const Duration(minutes: 10),
      // Default. Allows 3 cache sets and ease cleanup.
      priority: CachePriority.normal,
    );
    dio.interceptors.add(DioCacheInterceptor(options: cacheOptions));

    return dio;
  }
}
