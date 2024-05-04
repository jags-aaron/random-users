import 'package:club_hub_tech_test/data/model/filter.dart';
import 'package:club_hub_tech_test/data/model/random_users_response_model.dart';
import 'package:club_hub_tech_test/data/source/local_source.dart';
import 'package:club_hub_tech_test/data/source/remote_source.dart';
import 'package:club_hub_tech_test/domain/entity/user.dart';
import 'package:club_hub_tech_test/domain/user_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRemoteDataSource extends Mock implements RemoteDataSource {}

class MockLocalSource extends Mock implements LocalSource {}

void main() {
  late UserRepositoryImp userRepository;
  late MockRemoteDataSource mockRemoteDataSource;
  late MockLocalSource mockLocalSource;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalSource = MockLocalSource();
    userRepository = UserRepositoryImp(
      remoteSource: mockRemoteDataSource,
      localSource: mockLocalSource,
    );
  });

  final tResponse = RandomUserResponseModel(results: []);

  group('fetchRandomUsers', () {
    test(
        'should return a list of users when the call to remote data source is successful',
        () async {
      // Arrange
      final filter = Filter();
      when(() => mockRemoteDataSource.fetchRandomUsers(filter: filter))
          .thenAnswer(
        (_) async => tResponse,
      );

      // Act
      final result = await userRepository.fetchRandomUsers(filter: filter);

      // Assert
      verify(() => mockRemoteDataSource.fetchRandomUsers(filter: filter));
      expect(result, isA<List<User>>());
    });

    test(
        'getFilterFromPrefs should return a list of users when the call to remote data source is successful',
        () async {
      // Arrange
      when(() => mockLocalSource.getFilters()).thenAnswer(
        (_) async => Filter(),
      );

      // Act
      final result = await userRepository.getFilterFromPrefs();

      // Assert
      verify(() => mockLocalSource.getFilters());
      expect(result, isA<Filter>());
    });

    // test for saveFilterPrefs method
    test(
        'saveFilterPrefs should return a list of users when the call to remote data source is successful',
        () async {
      // Arrange
      final filter = Filter();
      when(() => mockLocalSource.saveFilters(filter: filter)).thenAnswer(
        (_) async {},
      );

      // Act
      final result = await userRepository.saveFilterPrefs(filter: filter);

      // Assert
      verify(() => mockLocalSource.saveFilters(filter: filter));
      expect(() => result, isA<void>());
    });
  });
}
