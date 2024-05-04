import '../../../data/model/filter.dart';

class BlocHomeEvent {}

class InitialEvent extends BlocHomeEvent {}

class FetchWithFilterEvent extends BlocHomeEvent {
  final Filter filter;

  FetchWithFilterEvent({
    required this.filter,
  });
}
