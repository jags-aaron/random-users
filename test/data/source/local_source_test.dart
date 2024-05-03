import 'package:club_hub_tech_test/data/model/filter.dart';
import 'package:club_hub_tech_test/data/source/local_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  group('LocalSourceImpl', () {
    late LocalSourceImpl localSource;
    late MockSharedPreferences mockSharedPreferences;

    setUp(() {
      mockSharedPreferences = MockSharedPreferences();
      localSource = LocalSourceImpl(
        sharedPreferences: mockSharedPreferences,
      );
    });

    test('saveFilters should correctly save filters', () async {

      final filter = Filter(
        results: 2,
        gender: Gender.female,
        nationality: [Nationality.us, Nationality.dk],
        page: 1,
        include: [Include.gender, Include.name],
        exclude: [Exclude.login],
      );

      when(() => mockSharedPreferences.setInt(any(), any())).thenAnswer((_) async => true);
      when(() => mockSharedPreferences.setString(any(), any())).thenAnswer((_) async => true);
      when(() => mockSharedPreferences.setStringList(any(), any())).thenAnswer((_) async => true);

      await localSource.saveFilters(filter: filter);

      verify(() => mockSharedPreferences.setInt('results', 2));
      verify(() => mockSharedPreferences.setString('gender', 'female'));
      verify(() => mockSharedPreferences.setStringList('nationality', ['us', 'dk']));
      verify(() => mockSharedPreferences.setInt('page', 1));
      verify(() => mockSharedPreferences.setStringList('include', ['gender', 'name']));
      verify(() => mockSharedPreferences.setStringList('exclude', ['login']));
    });

    test('getFilters should correctly retrieve filters', () async {
      when(() => mockSharedPreferences.getInt('results')).thenReturn(2);
      when(() => mockSharedPreferences.getString('gender')).thenReturn('female');
      when(() => mockSharedPreferences.getStringList('nationality')).thenReturn(['us', 'dk']);
      when(() => mockSharedPreferences.getInt('page')).thenReturn(1);
      when(() => mockSharedPreferences.getStringList('include')).thenReturn(['gender', 'name']);
      when(() => mockSharedPreferences.getStringList('exclude')).thenReturn(['login']);

      final filter = await localSource.getFilters();

      expect(filter.results, 2);
      expect(filter.gender, Gender.female);
      expect(filter.nationality, [Nationality.us, Nationality.dk]);
      expect(filter.page, 1);
      expect(filter.include, [Include.gender, Include.name]);
      expect(filter.exclude, [Exclude.login]);
    });
  });
}