//  dart run packages/ohochat_address/test/address_test.dart

import 'package:test/test.dart';
import '../lib/thai_address.dart';

void main() {
  group('group of tests location', () {
    final location = Location();

    test('Test location execute', () {
      final List<DatabaseSchema> results = location.execute(
        DatabaseSchemaQuery(
          postalCode: '10270',
          subDistrictName: 'ปากน้ำ',
        ),
      );

      final Map<String, dynamic> resJson = results.first.toJson();

      expect(
        {
          'provinceCode': 11,
          'provinceName': 'สมุทรปราการ',
          'districtCode': 1101,
          'districtName': 'เมืองสมุทรปราการ',
          'subDistrictCode': 110101,
          'subDistrictName': 'ปากน้ำ',
          'postalCode': '10270',
        },
        resJson,
      );
    });

    test('Test location reduce', () {
      final results = location.reduce(
        DatabaseSchemaQuery(provinceName: 'กรุง', districtName: 'บางนา'),
        (acc, row) {
          acc['provinceName']!.add(row.provinceName);
          return acc;
        },
        {'provinceName': <String>{}},
      );

      expect(
        {
          'provinceName': {'กรุงเทพมหานคร'},
        },
        results,
      );
    });

    test('Test location map', () {
      final resJson = location.map(
        DatabaseSchemaQuery(provinceName: 'กรุง', districtName: 'บางนา'),
        (row) {
          return '${row.subDistrictName}-${row.districtName}-${row.provinceName}-${row.postalCode}';
        },
      );

      expect(
        [
          'บางนาเหนือ-บางนา-กรุงเทพมหานคร-10260',
          'บางนาใต้-บางนา-กรุงเทพมหานคร-10260',
        ],
        resJson,
      );
    });

    test('Test location getAllProvinces', () {
      final result = location.getAllProvinces();

      final Map<String, dynamic> resJson = result.first.toJson();
      print(result.length);
      for (var i = 0; i < result.length; i++) {
        print(result[i].toJson());
      }
      expect(
        true,
        result.isNotEmpty,
      );
    });

    test('Test location getAllDistricts', () {
      final result = location.getDistrictsByProvinceCode('47');

      final Map<String, dynamic> resJson = result.first.toJson();
      print(result.length);
      for (var i = 0; i < result.length; i++) {
        print(result[i].toJson());
      }
      expect(
        true,
        result.isNotEmpty,
      );
    });

    test('Test location getAllSubDistricts', () {
      final result = location.getSubDistrictsByDistrictCode('4711');

      final Map<String, dynamic> resJson = result.first.toJson();
      print(result.length);
      for (var i = 0; i < result.length; i++) {
        print(result[i].toJson());
      }
      expect(
        true,
        result.isNotEmpty,
      );
    });
  });
}
