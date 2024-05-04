import 'dart:ui';

import 'package:equatable/equatable.dart';

import '../../domain/entity/user.dart';

class HomeModel extends Equatable {
  const HomeModel._({
    required this.title,
    required this.users,
    required this.userPressed,
    required this.showSettings,
  });

  factory HomeModel.build({
    required String title,
    required List<User> users,
    required Function(User) userPressed,
    required VoidCallback showSettings,
  }) {
    return HomeModel._(
      title: title,
      users: users,
      userPressed: userPressed,
      showSettings: showSettings,
    );
  }

  final String title;
  final List<User> users;
  final Function(User) userPressed;
  final VoidCallback showSettings;

  @override
  List<Object> get props => [
        title,
        users,
        userPressed,
        showSettings,
      ];
}
