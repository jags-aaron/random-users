import 'package:shared_preferences/shared_preferences.dart';

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
    await sharedPreferences.setInt('results', filter.results ?? 1);
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
    final results = sharedPreferences.getInt('results') ?? 1;
    final gender = sharedPreferences.getString('gender') ?? '';
    final nationality = sharedPreferences.getStringList('nationality') ?? List.empty();
    final page = sharedPreferences.getInt('page') ?? 1;
    final include = sharedPreferences.getStringList('include') ?? List.empty();
    final exclude = sharedPreferences.getStringList('exclude') ?? List.empty();

    return Filter(
      results: results,
      gender: Gender.values.firstWhere((element) => element.name == gender),
      nationality: nationality
          .map((e) =>
              Nationality.values.firstWhere((element) => element.name == e))
          .toList(),
      page: page,
      include: include
          .map((e) => Include.values.firstWhere((element) => element.name == e))
          .toList(),
      exclude: exclude
          .map((e) => Exclude.values.firstWhere((element) => element.name == e))
          .toList(),
    );
  }
}
