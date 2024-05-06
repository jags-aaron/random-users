import 'package:club_hub_tech_test/data/model/filter.dart';
import 'package:club_hub_tech_test/domain/user_repository.dart';
import 'package:club_hub_tech_test/presenter/home/bloc/home_bloc.dart';
import 'package:club_hub_tech_test/presenter/home/bloc/home_event.dart';
import 'package:club_hub_tech_test/presenter/home/bloc/home_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../util/widget_test_utils.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late HomeBloc bloc;
  late MockUserRepository repository;

  Filter emptyFilter = Filter();

  setUp(() {
    repository = MockUserRepository();
    bloc = HomeBloc(
      repository: repository,
    );
  });

  test('Initial state', () {
    expect(bloc.state.status, BlocHomeResult.initial);
  });

  test('When initial result is valid', () async {
    when(() => repository.getFilterFromPrefs())
        .thenAnswer((_) async => emptyFilter);
    when(() => repository.fetchRandomUsers(filter: emptyFilter))
        .thenAnswer((_) async => []);

    final expected = [
      const BlocHomeState(
        status: BlocHomeResult.loading,
        users: [],
        filter: null,
        error: null,
      ),
      BlocHomeState(
        status: BlocHomeResult.success,
        users: const [],
        filter: emptyFilter,
        error: null,
      ),
    ];
    bloc.add(InitialEvent());
    await emitsExactly(bloc, expected);
  });

  test('When error result is returned', () async {
    final tError = Exception('Error');
    when(() => repository.getFilterFromPrefs())
        .thenThrow(tError);
    when(() => repository.fetchRandomUsers(filter: emptyFilter))
        .thenAnswer((_) async => []);

    final expected = [
      const BlocHomeState(
        status: BlocHomeResult.loading,
        users: [],
        filter: null,
        error: null,
      ),
      BlocHomeState(
        status: BlocHomeResult.error,
        users: const [],
        filter: null,
        error: tError.toString(),
      ),
    ];
    bloc.add(InitialEvent());
    await emitsExactly(bloc, expected);
  });

  test('When FetchWithFilterEvent success result is returned', () async {

    // TODO Fix this test

    when(() => repository.getFilterFromPrefs())
        .thenAnswer((_) async => emptyFilter);
    when(() => repository.fetchRandomUsers(filter: emptyFilter))
        .thenAnswer((_) async => []);

    final expected = [
      const BlocHomeState(
        status: BlocHomeResult.loading,
        users: [],
        filter: null,
        error: null,
      ),
      BlocHomeState(
        status: BlocHomeResult.success,
        users: const [],
        filter: emptyFilter,
      ),
    ];
    bloc.add(FetchWithFilterEvent(filter: emptyFilter));
    await emitsExactly(bloc, expected);
  });
}
