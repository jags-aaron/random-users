import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

class MockBuildContext extends Mock implements BuildContext {}

class MockBloc extends Mock implements Bloc {}

Widget wrapWithMockProviders(
  Widget child, {
  Map<String, IconData> images = const {},
  Map<String, String> texts = const {},
}) {
  final mockContext = MockBuildContext();

  return MultiProvider(
    providers: [
      Provider<BuildContext>.value(value: mockContext),
    ],
    child: MaterialApp(
      home: BlocProvider<MockBloc>(
        create: (context) => MockBloc(),
        child: child,
      ),
    ),
  );
}

Future<void> wrapPumpAndSettle(
  Widget child,
  WidgetTester tester, {
  Map<String, IconData> images = const {},
  Map<String, String> texts = const {},
}) async {
  await tester.pumpWidget(wrapWithMockProviders(child));
  await tester.pumpAndSettle();
}

Future<void> wrapAndPump(
  Widget child,
  WidgetTester tester, {
  Map<String, IconData> images = const {},
  Map<String, String> texts = const {},
}) async {
  await tester.pumpWidget(wrapWithMockProviders(child));
  await tester.pump();
}

extension LocalizeTextFinder on CommonFinders {
  Finder localizedText(String text, {bool skipOffstage = true}) =>
      this.text('${text}_localized', skipOffstage: skipOffstage);

  Finder byLocalizedSemanticsLabel(Pattern label, {bool skipOffstage = true}) =>
      bySemanticsLabel('${label}_localized', skipOffstage: skipOffstage);
}
