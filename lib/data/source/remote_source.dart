import 'dart:io';

import 'package:dio/dio.dart';

import '../../common/mobile_platform_client.dart';
import '../model/filter.dart';
import '../model/random_users_response_model.dart';

abstract class RemoteDataSource {
  Future<RandomUserResponseModel> fetchRandomUsers({
    required Filter filter,
  });
}

class RemoteDataSourceImpl implements RemoteDataSource {
  RemoteDataSourceImpl({
    required PlatformClient platformClient,
  }) : _dio = platformClient.dioClient;

  final Dio _dio;

  bool _isFailure(int? statusCode) {
    if(statusCode == null) return true;
    return !(statusCode == HttpStatus.ok || statusCode < 300);
  }

  @override
  Future<RandomUserResponseModel> fetchRandomUsers({
    required Filter filter,
  }) async {
    final queryParams = filter.toQueryParams();

    try {
      final response = await _dio.get('/api', queryParameters: queryParams);

      if(_isFailure(response.statusCode)) {
        throw Exception(response.data.toString());
      }

      if (response.statusCode == 200) {
        return RandomUserResponseModel.fromJson(response.data);
      } else {
        throw Exception('Failed to fetch random users: ${response.toString()}');
      }
    } catch (error) {
      throw Exception(error.toString());
    }
  }
}
