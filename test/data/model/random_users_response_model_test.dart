import 'dart:convert';

import 'package:club_hub_tech_test/data/model/random_users_response_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../fixtures/fixture_reader.dart';

void main() {
  group('RandomUserResponseModel', () {

    test('fromJson should correctly parse json', () {
      final json = fixture('1_user_default_response.json');
      final model = RandomUserResponseModel.fromJson(jsonDecode(json));

      expect(model.results!.first.gender, 'female');
      expect(model.results!.first.name!.first, 'Lucille');
      expect(model.results!.first.name!.last, 'Hansen');
      expect(model.results!.first.nat, 'AU');
      expect(model.info!.seed, '05be2ba08cf917a2');
      expect(model.info!.results, 1);
      expect(model.info!.page, 1);
      expect(model.info!.version, '1.4');
    });

    test('toJson should correctly convert to json', () {
      final model = RandomUserResponseModel(
        results: [
          Results(
            gender: 'male',
            name: Name(title: 'mr', first: 'john', last: 'doe'),
            nat: 'US',
          ),
        ],
        info: Info(seed: 'abc', results: 1, page: 1, version: '1.0'),
      );

      final json = model.toJson();

      expect(json['results'].first['gender'], 'male');
      expect(json['results'].first['name']['first'], 'john');
      expect(json['results'].first['name']['last'], 'doe');
      expect(json['results'].first['nat'], 'US');
      expect(json['info']['seed'], 'abc');
      expect(json['info']['results'], 1);
      expect(json['info']['page'], 1);
      expect(json['info']['version'], '1.0');
    });
  });
}
