import 'package:go_router/go_router.dart';

import '../../common/custom_app_localizations.dart';
import 'home_model.dart';
import 'home_screen.dart';

class HomeRoute extends GoRoute {
  static const String screenPath = '/home';

  HomeRoute()
      : super(
          path: screenPath,
          builder: (context, state) {
            final appLocalizations = CustomAppLocalizations.of(context)!;

            return HomeScreen(
              model: HomeModel.build(
                title: appLocalizations.translate('home.title'),
              ),
            );
          },
        );
}
