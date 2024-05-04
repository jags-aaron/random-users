import 'package:club_hub_tech_test/presenter/home/bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../app_router.dart';
import '../presenter/home/home_controller.dart';
import 'detail_route.dart';

class HomeRoute extends GoRoute {
  static const String screenPath = '/';

  HomeRoute()
      : super(
          path: screenPath,
          parentNavigatorKey: navKey,
          builder: (context, state) {
            return BlocProvider(
              create: (context) => Provider.of<HomeBloc>(
                context,
                listen: false,
              ),
              child: HomeController(
                userPressed: (user) {
                  context.push('/${DetailRoute.routePath}', extra: user);
                },
              ),
            );
          },
          routes: <RouteBase>[
            DetailRoute(),
          ],
        );
}
