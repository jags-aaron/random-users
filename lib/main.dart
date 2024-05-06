import 'package:club_hub_tech_test/presenter/_widgets/presentation_frame.dart';
import 'package:club_hub_tech_test/presenter/home/bloc/home_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'app_router.dart';
import 'common/custom_app_localizations.dart';
import 'common/mobile_platform_client.dart';
import 'common/scroll_behavior.dart';
import 'common/themes.dart';
import 'data/source/local_source.dart';
import 'data/source/remote_source.dart';
import 'domain/user_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GlobalConfiguration().loadFromAsset("app_settings");
  runApp(
    await globalProvidersSetup(
      child: const MyApp(),
    ),
  );
}

/// GLOBAL PROVIDERS
Future<Widget> globalProvidersSetup({required Widget child}) async {
  return MultiProvider(
    providers: [
      Provider<SharedPreferences>.value(
        value: await SharedPreferences.getInstance(),
      ),
      Provider<Talker>.value(
        value: TalkerFlutter.init(
          settings: TalkerSettings(
            useConsoleLogs: true,
            enabled: true,
            colors: <TalkerLogType, AnsiPen>{
              TalkerLogType.error: AnsiPen()..red(),
              TalkerLogType.exception: AnsiPen()..red(bg: true),
              TalkerLogType.httpError: AnsiPen()..yellow(),
            },
          ),
        ),
      ),
    ],
    child: child,
  );
}

/// BLOC PROVIDERS
Widget blocProviders({
  required Widget child,
  required BuildContext context,
}) {
  return MultiProvider(
    providers: [
      Provider<HomeBloc>.value(
        value: HomeBloc(
          repository: UserRepositoryImp(
            remoteSource: RemoteDataSourceImpl(
              platformClient: PlatformClientImp(
                talker: Provider.of<Talker>(context),
              ),
            ),
            localSource: LocalSourceImpl(
              sharedPreferences: Provider.of<SharedPreferences>(
                context,
              ),
            ),
          ),
        ),
      ),
    ],
    child: child,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return blocProviders(
      context: context,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
          ),
          useMaterial3: true,
        ),
        home: PresentationFrame(
          child: MaterialApp.router(
            scrollBehavior: kIsWeb ? WebScrollBehavior() : null,
            debugShowCheckedModeBanner: false,
            title: 'Random Users',
            theme: lightTheme(),
            darkTheme: darkTheme(),
            themeMode: ThemeMode.light,
            routerConfig: appRouter,
            locale: const Locale('es'),
            supportedLocales: const <Locale>[Locale('es')],
            localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
              CustomAppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
          ),
        ),
      ),
    );
  }
}
