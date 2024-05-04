import 'package:club_hub_tech_test/navigation/detail_route.dart';
import 'package:club_hub_tech_test/navigation/home_route.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Provides access to the mainNavigator of the app throughout the app.
final GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: navKey,
  initialLocation: HomeRoute.screenPath,
  redirect: (BuildContext context, GoRouterState state) {
    return null;
  },
  routes: <RouteBase>[
    HomeRoute(),
  ],
  debugLogDiagnostics: true,
);
