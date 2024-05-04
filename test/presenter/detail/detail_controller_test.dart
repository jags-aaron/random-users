import 'dart:io';

import 'package:club_hub_tech_test/presenter/detail/detail_controller.dart';
import 'package:club_hub_tech_test/presenter/detail/detail_screen.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../util/widget_test_utils.dart' hide MockBloc;

void main() {
  setUpAll(() => HttpOverrides.global = null);

  testWidgets(
    'should return DetailScreen when bloc state is InitialState',
    (tester) async {
      await wrapPumpAndSettle(
          DetailController(
            user: tUser,
          ),
          tester);

      expect(find.byType(DetailScreen), findsOneWidget);
    },
  );
}
