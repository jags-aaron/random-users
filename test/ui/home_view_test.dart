import 'package:club_hub_tech_test/presenter/home/home_model.dart';
import 'package:club_hub_tech_test/presenter/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../util/widget_test_utils.dart';

void main() {
  group('FooView', () {
    testWidgets('screen renders correctly', (tester) async {
      final model = HomeModel.build(
        title: 'foo',
        users: [],
        userPressed: (User) {},
        showSettings: () {},
      );

      await wrapPumpAndSettle(
        HomeScreen(model: model),
        tester,
      );
      await tester.pumpAndSettle();

      expect(find.byType(Text), findsOneWidget);
      expect(find.text('foo'), findsOneWidget);
    });
  });
}
