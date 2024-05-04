import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../model/filter.dart';

abstract class LocalSource {
  Future<void> saveFilters({required Filter filter});

  Future<Filter> getFilters();
}

class LocalSourceImpl implements LocalSource {
  final SharedPreferences sharedPreferences;

  LocalSourceImpl({
    required this.sharedPreferences,
  });

  @override
  Future<void> saveFilters({required Filter filter}) async {
    await sharedPreferences.setInt('results', filter.results ?? 5);
    await sharedPreferences.setString('gender', filter.gender?.name ?? '');
    await sharedPreferences.setStringList('nationality',
        filter.nationality?.map((e) => e.name).toList() ?? List.empty());
    await sharedPreferences.setInt('page', filter.page ?? 1);
    await sharedPreferences.setStringList(
        'include', filter.include?.map((e) => e.name).toList() ?? List.empty());
    await sharedPreferences.setStringList(
        'exclude', filter.exclude?.map((e) => e.name).toList() ?? List.empty());
  }

  @override
  Future<Filter> getFilters() async {
    final int? results = sharedPreferences.getInt('results');
    final String? gender = sharedPreferences.getString('gender');
    final List<String>? nationality =
        sharedPreferences.getStringList('nationality');
    final int? page = sharedPreferences.getInt('page');
    final List<String>? include = sharedPreferences.getStringList('include');
    final List<String>? exclude = sharedPreferences.getStringList('exclude');

    return Filter(
      results: results ?? 10,
      gender:
          Gender.values.firstWhereOrNull((element) => element.name == gender),
      nationality: nationality
          ?.map((e) =>
              Nationality.values.firstWhere((element) => element.name == e))
          .toList(),
      page: page,
      include: include
          ?.map(
              (e) => Include.values.firstWhere((element) => element.name == e))
          .toList(),
      exclude: exclude
          ?.map(
              (e) => Exclude.values.firstWhere((element) => element.name == e))
          .toList(),
    );
  }
}
