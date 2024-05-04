import 'package:equatable/equatable.dart';

import '../../domain/entity/user.dart';

class DetailModel extends Equatable {
  const DetailModel._({
    required this.title,
    required this.user,
  });

  factory DetailModel.build({
    required String title,
    required User user,
  }) {
    return DetailModel._(
      title: title,
      user: user,
    );
  }

  final String title;
  final User user;

  @override
  List<Object> get props => [
        title,
        user,
      ];
}
