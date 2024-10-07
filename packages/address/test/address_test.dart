import 'package:test/test.dart';

import '../lib/address.dart';

void main() {
  group('A group of tests', () {
    final location = Location();
    location.init();

    setUp(() {
      // Additional setup goes here.
    });

    test('First Test', () {
      DatabaseSchemaQuery option = DatabaseSchemaQuery(postalCode: '10200');
      print(location.execute(option));
    });
  });
}
