import 'package:club_hub_tech_test/data/model/filter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/user_repository.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<BlocHomeEvent, BlocHomeState> {
  final UserRepository repository;

  HomeBloc({
    required this.repository,
  }) : super(const BlocHomeState()) {
    on<InitialEvent>(
      (event, emit) => _initialStream(event, emit),
    );
    on<FetchWithFilterEvent>(
      (event, emit) => _fetchWithFilterStream(event, emit),
    );
  }

  void _initialStream(
    InitialEvent event,
    Emitter<BlocHomeState> emit,
  ) async {
    try {
      emit(state.copyWith(status: BlocHomeResult.loading));

      final filter = await repository.getFilterFromPrefs();
      final result = await repository.fetchRandomUsers(
        filter: filter,
      );

      emit(
        state.copyWith(
          status: BlocHomeResult.success,
          users: result,
          filter: filter,
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
      emit(
        state.copyWith(
          status: BlocHomeResult.error,
        ),
      );
    }
  }

  void _fetchWithFilterStream(
    FetchWithFilterEvent event,
    Emitter<BlocHomeState> emit,
  ) async {
    try {
      emit(
        state.copyWith(
          status: BlocHomeResult.loading,
        ),
      );

      await repository.saveFilterPrefs(filter: event.filter);
      final result = await repository.fetchRandomUsers(
        filter: event.filter,
      );

      emit(
        state.copyWith(
          status: BlocHomeResult.success,
          users: result,
          filter: event.filter,
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
      emit(
        state.copyWith(
          status: BlocHomeResult.error,
        ),
      );
    }
  }
}
