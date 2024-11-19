import '../lib/thai_address.dart';

// dart run packages/ohochat_address/example/ohochat_address.dart
void main() {
  final location = Location();

  final List<DatabaseSchema> results = location.execute(
    DatabaseSchemaQuery(
      postalCode: '10270',
      subDistrictName: 'ปากน้ำ',
    ),
  );

  print('${results.first.toJson()}');
}
