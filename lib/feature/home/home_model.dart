import 'package:equatable/equatable.dart';

class HomeModel extends Equatable {
  const HomeModel._({
    required this.title,
  });

  factory HomeModel.build({
    required String title,
  }) {
    return HomeModel._(
      title: title,
    );
  }

  final String title;

  @override
  List<Object> get props => [
        title,
      ];
}
