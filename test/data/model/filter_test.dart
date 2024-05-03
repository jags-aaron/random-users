import 'package:club_hub_tech_test/data/model/filter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
      'toQueryParams should throw AssertionError when both include and exclude are not null',
      () {
    expect(
        () => Filter(include: [Include.gender], exclude: [Exclude.gender])
            .toQueryParams(),
        throwsA(isA<AssertionError>()));
  });

  test(
      'toQueryParams should throw AssertionError when results is not between 1 and 5000',
      () {
    expect(() => Filter(results: 0).toQueryParams(),
        throwsA(isA<AssertionError>()));
    expect(() => Filter(results: 5001).toQueryParams(),
        throwsA(isA<AssertionError>()));
  });


  test('toQueryParams should return the correct query parameters', () {
    final filter = Filter(
      results: 1,
      nationality: [Nationality.au, Nationality.br],
      include: [Include.name, Include.location],
      gender: Gender.female,
    );
    expect(filter.toQueryParams(), {
      'results': '1',
      'gender': 'female',
      'nat': 'au,br',
      'inc': 'name,location',
    });
  });
}
