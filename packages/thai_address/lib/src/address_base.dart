import 'dart:convert';
import 'district_model.dart';
import 'model.dart';
import 'province_model.dart';
import 'resources.resource_importer.dart';
import 'subdistrict_model.dart';

/// Singleton class for managing and querying address data.
class Location {
  /// Factory constructor to enforce singleton pattern.
  factory Location() {
    return _instance;
  }

  Location._() {
    // Decode raw JSON data and convert it into structured data.
    final decodedJson = jsonDecode(rawDB);
    final MinifyDatabase minifyDB =
        (decodedJson as List<dynamic>).map((province) {
      return (
        province[0] as String,
        province[1] as int,
        (province[2] as List<dynamic>).map((district) {
          return (
            district[0] as String,
            district[1] as int,
            (district[2] as List<dynamic>).map((subDistrict) {
              return (
                subDistrict[0] as String,
                subDistrict[1] as int,
                List<int>.from(subDistrict[2] as List<dynamic>)
              );
            }).toList()
          );
        }).toList()
      );
    }).toList();

    // Populate the database with structured data.
    if (_database.isEmpty) {
      for (final province in minifyDB) {
        for (final district in province.$3) {
          for (final subDistrict in district.$3) {
            for (final postalCode in subDistrict.$3) {
              _database.add(
                DatabaseSchema(
                  provinceName: province.$1,
                  provinceCode: province.$2,
                  districtName: district.$1,
                  districtCode: district.$2,
                  subDistrictName: subDistrict.$1,
                  subDistrictCode: subDistrict.$2,
                  postalCode: '$postalCode',
                ),
              );
            }
          }
        }
      }
    }
  }

  /// A list of all database schema elements.
  final List<DatabaseSchema> _database = [];

  List<ProvinceModel> getAllProvinces() {
    final provinces = <String, ProvinceModel>{};
    for (final entry in _database) {
      provinces.putIfAbsent(
        entry.provinceName,
        () => ProvinceModel(
          provinceNameTh: entry.provinceName,
          provinceCode: entry.provinceCode.toString(),
        ),
      );
    }
    return provinces.values.toList();
  }

  List<DistrictModel> getDistrictsByProvinceCode(String provinceCode) {
    final districts = <String, DistrictModel>{};

    for (final entry in _database) {
      if (entry.provinceCode.toString() == provinceCode) {
        districts.putIfAbsent(
          entry.districtName,
          () => DistrictModel(
            districtNameTh: entry.districtName,
            districtCode: entry.districtCode.toString(),
          ),
        );
      }
    }
    return districts.values.toList();
  }

  List<SubdistrictModel> getSubDistrictsByDistrictCode(String districtCode) {
    final subDistricts = <String, SubdistrictModel>{};
    for (final entry in _database) {
      if (entry.districtCode.toString() == districtCode) {
        subDistricts.putIfAbsent(
          entry.subDistrictName,
          () => SubdistrictModel(
            subdistrictNameTh: entry.subDistrictName,
            subdistrictCode: entry.subDistrictCode.toString(),
            postalCode: entry.postalCode,
          ),
        );
      }
    }
    return subDistricts.values.toList();
  }

  // Singleton instance.
  static final Location _instance = Location._();

  /// Getter to retrieve the entire database.
  List<DatabaseSchema> get database => _database;

  /// Combines multiple query conditions and returns the matching results.
  List<DatabaseSchema> combineQuery(
    List<ComposisCondition<DatabaseSchema>> queries,
  ) {
    return _database
        .where((row) => queries.every((query) => query(row)))
        .toList();
  }

  /// Creates an array of query conditions based on the provided options.
  List<ComposisCondition<DatabaseSchema>> createQueryArray(
    DatabaseSchemaQuery? option,
  ) {
    final queries = <ComposisCondition<DatabaseSchema>>[];

    if (option != null) {
      for (final entry in option.toJson().entries) {
        if (entry.value == null) {
          continue;
        }
        queries.add((row) {
          final rowJson = row.toJson();
          return ['provinceCode', 'districtCode', 'subDistrictCode']
                  .contains(entry.key)
              ? rowJson[entry.key] == entry.value
              : ['provinceName', 'districtName', 'subDistrictName']
                      .contains(entry.key)
                  ? rowJson[entry.key]
                      .toString()
                      .startsWith(entry.value.toString())
                  : entry.key == 'postalCode'
                      ? rowJson[entry.key]
                          .toString()
                          .startsWith(entry.value.toString())
                      : false;
        });
      }
    }

    return queries;
  }

  /// Detects if the provided object is a function and returns it as type [T].
  T? detectFunction<T>(dynamic cb, {required bool init}) {
    if (cb is Function) {
      return cb as T;
    }
    return null;
  }

  /// Executes the query based on the provided options and returns the results.
  List<T> execute<T>(DatabaseSchemaQuery option) {
    final res = combineQuery(createQueryArray(option));
    return res as List<T>;
  }

  /// Maps the query results using the provided callback function.
  List<T> map<T>(DatabaseSchemaQuery option, MapCallback<T> callback) {
    final queries = createQueryArray(option);
    final res = combineQuery(queries);

    if (res.isNotEmpty) {
      return res.map(callback).toList();
    }
    return [] as List<T>;
  }

  /// Reduces the query results using the provided callback function and initial value.
  Init reduce<Init>(
    DatabaseSchemaQuery option,
    ReduceCallback<Init> callback,
    Init init,
  ) {
    final queries = createQueryArray(option);
    final res = combineQuery(queries);

    if (res.isNotEmpty) {
      return res.fold<Init>(init, callback);
    }

    return init;
  }
}
