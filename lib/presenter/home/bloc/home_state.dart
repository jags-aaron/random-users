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
    this.error,
  });

  final BlocHomeResult? status;
  final List<User> users;
  final Filter? filter;
  final String? error;

  @override
  List<Object?> get props => [
        status,
        users,
        filter,
        error,
      ];

  BlocHomeState copyWith({
    required BlocHomeResult status,
    List<User>? users,
    Filter? filter,
    String? error,
  }) {
    return BlocHomeState(
      status: status,
      users: users ?? [],
      filter: filter ?? this.filter,
      error: error ?? this.error,
    );
  }
}
