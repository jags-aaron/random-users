import 'package:dio/dio.dart';
import 'package:talker_flutter/talker_flutter.dart';

class AppInterceptors extends Interceptor {
  final Talker talker;

  AppInterceptors({
    required this.talker,
  });

  final greenPen = AnsiPen()..green();
  final bluePen = AnsiPen()..blue();
  final redPen = AnsiPen()..red();

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    talker.debug('[Dio Request] ${options.method} ${options.uri}');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    talker.log(bluePen('[Dio Response] ${response.statusCode}'));
    super.onResponse(response, handler);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    talker.critical('[Dio Error] ${err.response?.statusCode} ${err.response?.data}');
    super.onError(err, handler);
  }
}
