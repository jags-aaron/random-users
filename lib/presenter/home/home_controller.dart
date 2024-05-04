import 'package:club_hub_tech_test/presenter/home/filter_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/custom_app_localizations.dart';
import '../../domain/entity/user.dart';
import 'bloc/home_bloc.dart';
import 'bloc/home_event.dart';
import 'bloc/home_state.dart';
import 'home_model.dart';
import 'home_screen.dart';

class HomeController extends StatelessWidget {
  const HomeController({
    super.key,
    required this.userPressed,
  });

  final Function(User) userPressed;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<HomeBloc>();
    final i18n = CustomAppLocalizations.of(context)!;

    return BlocConsumer<HomeBloc, BlocHomeState>(
      listener: (context, state) {
        if (state.status == BlocHomeResult.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(i18n.translate('home.error')),
              action: SnackBarAction(
                label: i18n.translate('home.retry'),
                onPressed: () {
                  bloc.add(InitialEvent());
                },
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state.status == BlocHomeResult.loading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (state.users.isEmpty && state.status != BlocHomeResult.error) {
          bloc.add(InitialEvent());
        }
        return HomeScreen(
          model: HomeModel.build(
            title: i18n.translate('home.title'),
            users: state.users,
            userPressed: userPressed,
            showSettings: () {
              showModalBottomSheet(
                useRootNavigator: true,
                enableDrag: true,
                scrollControlDisabledMaxHeightRatio: 0.9,
                context: context,
                builder: (BuildContext context) {
                  return FilterScreen(
                    saveFilter: (filter) {
                      Navigator.pop(context);
                      bloc.add(FetchWithFilterEvent(filter: filter));
                    },
                    filter: state.filter,
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
