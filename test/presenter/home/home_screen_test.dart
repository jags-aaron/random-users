import 'package:club_hub_tech_test/presenter/home/home_model.dart';
import 'package:club_hub_tech_test/presenter/home/home_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';

import '../../util/widget_test_utils.dart';

class MockHomeModel extends Mock implements HomeModel {}

void main() {

  group('HomeScreen', () {
    testWidgets('screen renders correctly', (tester) async {
      final model = MockHomeModel();
      final user1 = tUser.copyWith(id: "1");
      when(() => model.title).thenReturn('title');
      when(() => model.users).thenAnswer((_) => [user1, tUser.copyWith(id: "2")]);
      when(() => model.userPressed(user1)).thenAnswer((_) => () {});
      when(() => model.showSettings()).thenAnswer((_) => () {});

      await mockNetworkImages(() async {
        await wrapPumpAndSettle(
          HomeScreen(model: model),
          tester,
        );
        await tester.pumpAndSettle();
      });

      await tester.tap(find.byKey(const Key('button-filter-key')));
      await tester.pumpAndSettle();
      verify(() => model.showSettings()).called(1);

      // TODO Add more tests
    });
  });
}