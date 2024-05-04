import 'package:bloc_test/bloc_test.dart';
import 'package:club_hub_tech_test/presenter/home/bloc/home_bloc.dart';
import 'package:club_hub_tech_test/presenter/home/bloc/home_event.dart';
import 'package:club_hub_tech_test/presenter/home/bloc/home_state.dart';
import 'package:club_hub_tech_test/presenter/home/home_controller.dart';
import 'package:club_hub_tech_test/presenter/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart' as mocktail;

import '../../util/widget_test_utils.dart' hide MockBloc;

class MockHomeBlock extends MockBloc<BlocHomeEvent, BlocHomeState>
    implements HomeBloc {}

class FakeBlockHomeState extends Fake implements BlocHomeState {}

class FakeBlocHomeEvent extends Fake implements BlocHomeEvent {}

void main() {
  late MockHomeBlock _mockBloc;

  setUpAll(() {
    mocktail.registerFallbackValue(FakeBlockHomeState());
    mocktail.registerFallbackValue(FakeBlocHomeEvent());
    _mockBloc = MockHomeBlock();
  });

  testWidgets(
    'should return HomeScreen when bloc state is InitialState',
    (tester) async {
      whenListen(
        _mockBloc,
        Stream.value(const BlocHomeState()),
        initialState: const BlocHomeState(),
      );

      await wrapAndPump(
        BlocProvider<HomeBloc>(
          create: (_) => _mockBloc,
          child: Builder(builder: (context) {
            return HomeController(
              userPressed: (user) {},
            );
          }),
        ),
        tester,
      );

      expect(find.byType(HomeScreen), findsOneWidget);
    },
  );
}
