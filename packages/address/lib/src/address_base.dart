import 'dart:convert';

import 'model.dart';
import 'package:flutter/services.dart';

class Location<T> {
  final List<DatabaseSchema> _database = [];

  Future<void> init() async {
    String jsonFile = await rootBundle.loadString('packages/address_flutter/assets/minifyDB.json');
    var decodedJson = jsonDecode(jsonFile) as List<dynamic>;

    MinifyDatabase minifyDB = decodedJson.map((province) {
      String provinceName = province[0];
      int provinceId = province[1];
      List<MinifyDistrictDatabase> districts = (province[2] as List<dynamic>).map((district) {
        String districtName = district[0];
        int districtId = district[1];
        List<MinifySubDistrictDatabase> subDistricts = (district[2] as List<dynamic>).map((subDistrict) {
          String subDistrictName = subDistrict[0];
          int subDistrictId = subDistrict[1];
          List<int> postCodes = List<int>.from(subDistrict[2]);
          return (subDistrictName, subDistrictId, postCodes);
        }).toList();
        return (districtName, districtId, subDistricts);
      }).toList();
      return (provinceName, provinceId, districts);
    }).toList();

    if (_database.isEmpty) {
      for (final province in minifyDB) {
        for (final district in province.$3) {
          for (final subDistrict in district.$3) {
            for (final postalCode in subDistrict.$3) {
              _database.add(DatabaseSchema(
                provinceName: province.$1,
                provinceCode: province.$2,
                districtName: district.$1,
                districtCode: district.$2,
                subDistrictName: subDistrict.$1,
                subDistrictCode: subDistrict.$2,
                postalCode: '$postalCode',
              ));
            }
          }
        }
      }
    }
  }

  List<DatabaseSchema> get database => _database;

  List<DatabaseSchema> combineQuery(List<ComposisCondition<DatabaseSchema>> queries) {
    return _database.where((row) => queries.every((query) => query(row))).toList();
  }

  List<ComposisCondition<DatabaseSchema>> createQueryArray(DatabaseSchemaQuery? option) {
    final queries = <ComposisCondition<DatabaseSchema>>[];

    if (option != null) {
      for (final entry in option.toJson().entries) {
        if (entry.value == null) continue;
        queries.add((row) {
          final rowJson = row.toJson();
          return ['provinceCode', 'districtCode', 'subDistrictCode'].contains(entry.key)
              ? rowJson[entry.key] == entry.value
              : ['provinceName', 'districtName', 'subDistrictName'].contains(entry.key)
                  ? rowJson[entry.key].toString().startsWith(entry.value.toString())
                  : entry.key == 'postalCode'
                      ? rowJson[entry.key].toString().startsWith(entry.value.toString())
                      : false;
        });
      }
    }

    return queries;
  }

  T? detectFunction<T>(dynamic cb, {required bool init}) {
    if (cb is Function) return cb as T;
    return null;
  }

  List<T> execute(DatabaseSchemaQuery option, [String? message]) {
    final res = combineQuery(createQueryArray(option));
    return res as List<T>;
  }

  // ignore: avoid_shadowing_type_parameters
  List<T> map<T, Res>(DatabaseSchemaQuery option, MapCallback<Res> callback) {
    final queries = createQueryArray(option);
    final res = combineQuery(queries);

    if (res.isNotEmpty) {
      return res.map(callback as Function(DatabaseSchema e)).firstOrNull();
    }
    return [] as List<T>;
  }
}
