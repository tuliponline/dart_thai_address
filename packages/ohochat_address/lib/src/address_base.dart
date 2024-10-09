import 'dart:convert';
import 'model.dart';
import 'resources.resource_importer.dart';

class Location {
  Location._() {
    final decodedJson = jsonDecode(rawDB);
    final MinifyDatabase minifyDB = (decodedJson as List<dynamic>).map((province) {
      return (
        province[0] as String,
        province[1] as int,
        (province[2] as List<dynamic>).map((district) {
          return (
            district[0] as String,
            district[1] as int,
            (district[2] as List<dynamic>).map((subDistrict) {
              return (subDistrict[0] as String, subDistrict[1] as int, List<int>.from(subDistrict[2] as List<dynamic>));
            }).toList()
          );
        }).toList()
      );
    }).toList();

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
  // ignore: sort_unnamed_constructors_first
  factory Location() {
    return _instance;
  }
  final List<DatabaseSchema> _database = [];
  static final Location _instance = Location._();

  List<DatabaseSchema> get database => _database;

  List<DatabaseSchema> combineQuery(List<ComposisCondition<DatabaseSchema>> queries) {
    return _database.where((row) => queries.every((query) => query(row))).toList();
  }

  List<ComposisCondition<DatabaseSchema>> createQueryArray(DatabaseSchemaQuery? option) {
    final queries = <ComposisCondition<DatabaseSchema>>[];

    if (option != null) {
      for (final entry in option.toJson().entries) {
        if (entry.value == null) {
          continue;
        }
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
    if (cb is Function) {
      return cb as T;
    }
    return null;
  }

  List<T> execute<T>(DatabaseSchemaQuery option) {
    final res = combineQuery(createQueryArray(option));
    return res as List<T>;
  }

  List<T> map<T>(DatabaseSchemaQuery option, MapCallback<T> callback) {
    final queries = createQueryArray(option);
    final res = combineQuery(queries);

    if (res.isNotEmpty) {
      return res.map(callback).toList();
    }
    return [] as List<T>;
  }

  Init reduce<Init>(DatabaseSchemaQuery option, ReduceCallback<Init> callback, Init init) {
    final queries = createQueryArray(option);
    final res = combineQuery(queries);

    if (res.isNotEmpty) {
      return res.fold<Init>(init, callback);
    }

    return init;
  }
}
