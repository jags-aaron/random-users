import 'package:club_hub_tech_test/common/custom_app_localizations.dart';
import 'package:club_hub_tech_test/domain/entity/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

User tUser = User(
  gender: '',
  nationality: '',
  name: '',
  location: '',
  email: '',
  dob: '',
  phone: '',
  id: '',
  picture:
      'https://media.istockphoto.com/id/1495088043/vector/user-profile-icon-avatar-or-person-icon-profile-picture-portrait-symbol-default-portrait.jpg?s=612x612&w=0&k=20&c=dhV2p1JwmloBTOaGAtaA3AW1KSnjsdMt7-U_3EZElZ0=',
);

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
      locale: const Locale('es'),
      supportedLocales: const <Locale>[Locale('es')],
      localizationsDelegates: const [
        CustomAppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
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
