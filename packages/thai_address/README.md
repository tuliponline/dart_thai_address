# Address for Thailand


Introducing `thai_address` — a no-nonsense Thailand address helper for Flutter.

This lightweight package empowers you to focus on building address features faster, eliminating the complexity of address handling. It is framework-agnostic and works seamlessly across platforms in any Flutter application.

With this package, you can effortlessly:

- Use pre-built relationships between address components.
- Filter addresses by criteria like postcode, province, district, and sub-district.
- Build robust address-based applications without worrying about the underlying complexity.

This package is designed and brought to you by [Oho Chat](https://www.oho.chat) — the No. 1 customer support and sales management platform!

## Features

By using `thai_address`, you'll enjoy:

- Efficient address lookup for Thai provinces, districts, and sub-districts.
- Flexible queries that handle both partial and exact address matching.
- Compatibility with Flutter’s mobile, web, and desktop apps.

## Getting Started

To install the package, add it to your `pubspec.yaml` file:

```yaml
dependencies:
  ohochat_address: latest
```
## Location

Use **Location** to find addresses with search constraints.

### Creating an instance

```dart
import 'package:thai_address/thai_address.dart';

final location = Location();
```

You can create a new instance of **Location**. A Location let you query addresses based on your criteria, resulting in one or more matched addresses (or zero if not matched!). An address is made up from the following **components**:

- postalCode
- provinceName (changwat)
- districtName (amphoe)
- subDistrctName (tambon)

These components can be refered to by a standardized numerical code in 2, 4 and 6 digits. For example, code `10` is "กรุงเทพมหานคร", `1001` is "เขตบางรัก กรุงเทพมหานคร" and `100403` is "แขวงสุริยวงศ์ เขตบางรัก กรุงเทพมหานคร". You can use the following **codes** in an address interchangeably with the textual components.

- provinceCode
- districtCode
- subDistricteCode

### Find Location Address

Find addresses using queries. The resulting addresses can be passed to mapping or map-reduce function for convenience.

```dart
// Find address
import 'package:ohochat_address/ohochat_address.dart';

void main() {
  final location = Location();
  
  final results = location.execute(DatabaseSchemaQuery(
    postalCode: 10270,
    subDistrictName: 'ปากน้ำ',
  ));

  print(results);
}
```

#### Location Query

These are the available query options for searching by address components or codes. There are 2 ways to find addresses:

1. Exact match using MOI code.
2. Partial match using address component.

You can mix exact and partial matches in a single query. Otherwise, you can pass `{}` and get all of the addresses (why not!).

```


{
    // 1. Exact match using MOI code

    // provinceCode in 2 digits like 11
    provinceCode?: int

    // districtCode in 4 digits like 1101
    districtCode?: int

    // subDistrictCode in 6 digits like 110101
    subDistrictCode?: int

    // 2. Partial match using address component

    // province name beginning with กรุง
    provinceName?: string

    // district name beginning with บาง
    districtName?: string

    // sub district name beginning with บาง
    subDistrictName?: string

    // postal code beginning with 10
    postalCode?: string
}
```


### Use Cases
```dart
// Get address details
final results = location.execute(DatabaseSchemaQuery(postalCode: '10270',provinceName:'สมุทร'));

// results1
[
    {
        districtCode: 1101,
        districtName: 'เมืองสมุทรปราการ',
        postalCode: 10270,
        provinceCode: 11,
        provinceName: 'สมุทรปราการ',
        subDistrictCode: 110101,
        subDistrictName: 'ปากน้ำ',
    },
]


// Get address details and mapping data
const results2 = location.reduce(
        DatabaseSchemaQuery(provinceName: 'กรุง', districtName: 'บางนา'),
        (acc, row) {
          acc['provinceName']!.add(row.provinceName);
          return acc;
        },
        {'provinceName': <String>{}},
      );

// results2
[
    {
        'provinceName': {'กรุงเทพมหานคร'},
    },
]


// Get address detail and restucture data
const results3 = llocation.map(
        DatabaseSchemaQuery(provinceName: 'กรุง', districtName: 'บางนา'),
        (row) {
          return '${row.subDistrictName}-${row.districtName}-${row.provinceName}-${row.postalCode}';
        },
    );

// results3
[
    'บางนาเหนือ-บางนา-กรุงเทพมหานคร-10260',
    'บางนาใต้-บางนา-กรุงเทพมหานคร-10260',
],
```

## Development

### Initial Setup

1.  Clone the project from github:

    ```bash
    git clone git@github.com:ohoexperience/ohochat_address_flutter.git

    ```

2.  Install the dependencies:

    ```bash
    dart pub get
    ```

### Testing
```bash
dart run ../address_test.dart
```

