import 'package:club_hub_tech_test/domain/entity/user.dart';
import 'package:club_hub_tech_test/presenter/detail/detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DetailRoute extends GoRoute {
  static const routePath = 'detail';

  DetailRoute()
      : super(
          path: routePath,
          builder: (BuildContext context, GoRouterState state) {
            final user = GoRouterState.of(context).extra! as User;

            return DetailController(
              user: user,
            );
          },
        );
}
