import 'model.dart';

typedef ComposisCondition<T> = Predicate<T>;
typedef DatabaseSchemaQuery = Map<String, dynamic>;
typedef ReduceCallback<Init, Res> = (Init value, Res previousValue) => Res;
typedef MapCallback<Res> = (DatabaseSchema value) => Res;


class Location {
  final List<DatabaseSchema> _database = [];

  Location();

  void init() {
    if (_database.isEmpty) {
      minifyDB.forEach((province) {
        province[2].forEach((district) {
          district[2].forEach((subDistrict) {
            subDistrict[2].forEach((postalCode) {
              _database.add({
                'provinceName': province[0],
                'provinceCode': province[1],
                'districtName': district[0],
                'districtCode': district[1],
                'subDistrictName': subDistrict[0],
                'subDistrictCode': subDistrict[1],
                'postalCode': postalCode,
              });
            });
          });
        });
      });
    }
  }

  List<DatabaseSchema> get database => _database;

  List<DatabaseSchema> combineQuery(
      List<ComposisCondition<DatabaseSchema>> queries) {
    return _database
        .where((row) => queries.every((query) => query(row)))
        .toList();
  }

  List<ComposisCondition<DatabaseSchema>> createQueryArray(
      DatabaseSchemaQuery? option) {
    final queries = <ComposisCondition<DatabaseSchema>>[];

    if (option != null) {
      for (final entry in option.entries) {
        if (!entry.value) continue;

        queries.add((row) {
          return ['provinceCode', 'districtCode', 'subDistrictCode']
                  .contains(entry.key)
              ? row[entry.key] == entry.value
              : ['provinceName', 'districtName', 'subDistrictName']
                      .contains(entry.key)
                  ? row[entry.key].toString().startsWith(entry.value.toString())
                  : entry.key == 'postalCode'
                      ? row[entry.key]
                          .toString()
                          .startsWith(entry.value.toString())
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

  List<DatabaseSchema> execute(DatabaseSchemaQuery option) {
    final res = combineQuery(createQueryArray(option));
    return res;
  }

  Res? map<T, Res>(DatabaseSchemaQuery option,
      {required MapCallback<Res> callback}) {
    final queries = createQueryArray(option);
    final res = combineQuery(queries);

    if (res.isNotEmpty) {
      return res.map(callback as Function(DatabaseSchema e)).firstOrNull();
    }
    return null;
  }

  Init? reduce<T, Res, Init>(DatabaseSchemaQuery option,
      {required ReduceCallback<Init, Res> callback, required Init init}) {
    final queries = createQueryArray(option);
    final res = combineQuery(queries);

    if (res.isNotEmpty) {
      return res.reduce(callback, init);
    }
    return null;
  }

  void main() async {
    // Usage example:
    Location location = Location();
    location.init();

    DatabaseSchemaQuery option = {
      'provinceName': 'Bangkok',
      'postalCode': '10200'
    };

    List<DatabaseSchema> result = location.execute(option);
    print(result);

    Res? res1 =
        await location.map(option, callback: (value) => value['districtName']);
    print(res1);

    Init? init1 = 10;
    Result? res2 = await location.reduce<T, Res, Init>(option,
        callback: (value, previousValue) => value + previousValue, init: init1);
    print(res2);
  }
}
