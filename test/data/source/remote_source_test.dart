import 'dart:convert';

import 'package:club_hub_tech_test/common/mobile_platform_client.dart';
import 'package:club_hub_tech_test/data/model/filter.dart';
import 'package:club_hub_tech_test/data/model/random_users_response_model.dart';
import 'package:club_hub_tech_test/data/source/remote_source.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../fixtures/fixture_reader.dart';

class PlatformClientMock extends Mock implements PlatformClient {}

class DioMock extends Mock implements Dio {}

void main() {
  late PlatformClient platformClient;
  late RemoteDataSourceImpl remoteSource;

  final dioMock = DioMock();

  setUp(() {
    platformClient = PlatformClientMock();
    when(() => platformClient.dioClient).thenAnswer((_) => dioMock);

    remoteSource = RemoteDataSourceImpl(
      platformClient: platformClient,
    );
  });

  test(
    'empty filters',
    () async {
      final filter = Filter();
      final mockResponse = fixture('1_user_default_response.json');

      when(() => dioMock.get(any(), queryParameters: filter.toQueryParams()))
          .thenAnswer(
        (_) async => Response(
          data: jsonDecode(mockResponse),
          requestOptions: RequestOptions(path: '/api'),
          statusCode: 200,
        ),
      );

      final response = await remoteSource.fetchRandomUsers(filter: filter);
      expect(response, isA<RandomUserResponseModel>());
      expect(response.toJson(), jsonDecode(mockResponse));
    },
  );

  test(
    'get 1 random user',
    () async {
      final filter = Filter(results: 1);
      final mockResponse = fixture('1_user_default_response.json');

      when(() => dioMock.get(any(), queryParameters: filter.toQueryParams()))
          .thenAnswer(
        (_) async => Response(
          data: jsonDecode(mockResponse),
          requestOptions: RequestOptions(path: '/api'),
          statusCode: 200,
        ),
      );

      final response = await remoteSource.fetchRandomUsers(filter: filter);
      expect(response, isA<RandomUserResponseModel>());
      expect(response.toJson(), jsonDecode(mockResponse));
    },
  );

  test(
    'get 2 male random user',
    () async {
      final filter = Filter(
        results: 2,
        gender: Gender.male,
      );
      final mockResponse = fixture('2_users_only_male_response.json');

      when(() => dioMock.get(any(), queryParameters: filter.toQueryParams()))
          .thenAnswer(
        (_) async => Response(
          data: jsonDecode(mockResponse),
          requestOptions: RequestOptions(path: '/api'),
          statusCode: 200,
        ),
      );

      final response = await remoteSource.fetchRandomUsers(filter: filter);
      final noOfMaleUsers =
          response.results?.where((user) => user.gender == 'male').length;
      final noOfFemaleUsers =
          response.results?.where((user) => user.gender == 'female').length;
      expect(response, isA<RandomUserResponseModel>());
      expect(response.toJson(), jsonDecode(mockResponse));
      expect(noOfMaleUsers, 2);
      expect(noOfFemaleUsers, 0);
    },
  );

  test(
    'get 2 female random user',
    () async {
      final filter = Filter(
        results: 2,
        gender: Gender.female,
      );
      final mockResponse = fixture('2_users_only_female_response.json');

      when(() => dioMock.get(any(), queryParameters: filter.toQueryParams()))
          .thenAnswer(
        (_) async => Response(
          data: jsonDecode(mockResponse),
          requestOptions: RequestOptions(path: '/api'),
          statusCode: 200,
        ),
      );

      final response = await remoteSource.fetchRandomUsers(filter: filter);
      final noOfMaleUsers =
          response.results?.where((user) => user.gender == 'male').length;
      final noOfFemaleUsers =
          response.results?.where((user) => user.gender == 'female').length;
      expect(response, isA<RandomUserResponseModel>());
      expect(response.toJson(), jsonDecode(mockResponse));
      expect(noOfMaleUsers, 0);
      expect(noOfFemaleUsers, 2);
    },
  );

  test(
    'get random users with some filters',
    () async {
      final filter = Filter(
        results: 2,
        nationality: [
          Nationality.us,
          Nationality.dk,
          Nationality.fr,
        ],
        include: [
          Include.name,
          Include.location,
          Include.email,
        ],
      );
      final mockResponse = fixture('10_users_only_response.json');

      when(() => dioMock.get(any(), queryParameters: filter.toQueryParams()))
          .thenAnswer(
        (_) async => Response(
          data: jsonDecode(mockResponse),
          requestOptions: RequestOptions(path: '/api'),
          statusCode: 200,
        ),
      );

      final response = await remoteSource.fetchRandomUsers(filter: filter);
      expect(response, isA<RandomUserResponseModel>());

      // Verify the method is called with correct parameters
      verify(() => dioMock.get(
            any(),
            queryParameters: filter.toQueryParams(),
          )).called(1);
    },
  );

  test(
      'toQueryParams should throw AssertionError when both include and exclude are not null',
      () {
    expect(
        () => Filter(include: [Include.gender], exclude: [Exclude.gender])
            .toQueryParams(),
        throwsA(isA<AssertionError>()));
  });

  test(
      'toQueryParams should throw AssertionError when results is not between 1 and 5000',
      () {
    expect(() => Filter(results: 0).toQueryParams(),
        throwsA(isA<AssertionError>()));
    expect(() => Filter(results: 5001).toQueryParams(),
        throwsA(isA<AssertionError>()));
  });
}
