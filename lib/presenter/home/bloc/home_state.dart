import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../data/model/filter.dart';
import '../../../domain/entity/user.dart';

enum BlocHomeResult {
  initial,
  loading,
  error,
  success,
}

@immutable
class BlocHomeState extends Equatable {
  const BlocHomeState({
    this.status = BlocHomeResult.initial,
    this.users = const [],
    this.filter,
  });

  final BlocHomeResult? status;
  final List<User> users;
  final Filter? filter;

  @override
  List<Object?> get props => [
        status,
        users,
        filter,
      ];

  BlocHomeState copyWith({
    required BlocHomeResult status,
    List<User>? users,
    Filter? filter,
  }) {
    return BlocHomeState(
      status: status,
      users: users ?? [],
      filter: filter ?? this.filter,
    );
  }
}
