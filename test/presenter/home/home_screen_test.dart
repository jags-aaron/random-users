import 'package:club_hub_tech_test/domain/entity/user.dart';
import 'package:club_hub_tech_test/presenter/home/home_model.dart';
import 'package:club_hub_tech_test/presenter/home/home_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';

import '../../util/widget_test_utils.dart';

class MockHomeModel extends Mock implements HomeModel {}

void main() {

  final user1 = tUser.copyWith(id: "1");

  setUpAll(() {
    registerFallbackValue(user1);
  });

  group('HomeScreen', () {
    testWidgets('screen renders correctly', (tester) async {
      final model = MockHomeModel();
      when(() => model.title).thenReturn('title');
      when(() => model.users).thenAnswer((_) => [user1]);
      when(() => model.userPressed(user1)).thenAnswer((_) => (user) => () {});
      when(() => model.showSettings()).thenAnswer((_) => () {});

      await mockNetworkImages(() async {
        await wrapPumpAndSettle(
          HomeScreen(model: model),
          tester,
        );
        await tester.pumpAndSettle();
      });

      // click on the filter button
      await tester.tap(find.byKey(const Key('button-filter-key')));
      await tester.pumpAndSettle();
      verify(() => model.showSettings()).called(1);

      // click on the first user
      await tester.tap(find.byKey(const Key('user-key-1')));
      await tester.pumpAndSettle();
      verify(() => model.userPressed(user1)).called(1);

      // perform scroll to test if the list is scrollable
      await tester.fling(find.byType(ListView), const Offset(0, -200), 3000);
      await tester.pumpAndSettle();
    });
  });
}