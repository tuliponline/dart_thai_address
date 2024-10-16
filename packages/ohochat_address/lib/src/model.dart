/// Data Transfer Object (DTO) for representing geographic information.
class GeographyDTO {
  /// Data Transfer Object (DTO) for representing geographic information.
  GeographyDTO({
    required this.id,
    required this.provinceCode,
    required this.provinceNameEn,
    required this.provinceNameTh,
    required this.districtCode,
    required this.districtNameEn,
    required this.districtNameTh,
    required this.subdistrictCode,
    required this.subdistrictNameEn,
    required this.subdistrictNameTh,
    required this.postalCode,
  });

  /// Unique identifier for the geographic record.
  final int id;

  /// Code for the province.
  final int provinceCode;

  /// English name of the province.
  final String provinceNameEn;

  /// Thai name of the province.
  final String provinceNameTh;

  /// Code for the district.
  final int districtCode;

  /// English name of the district.
  final String districtNameEn;

  /// Thai name of the district.
  final String districtNameTh;

  /// Code for the subdistrict.
  final int subdistrictCode;

  /// English name of the subdistrict.
  final String subdistrictNameEn;

  /// Thai name of the subdistrict.
  final String subdistrictNameTh;

  /// Postal code for the area.
  final int postalCode;
}

/// Represents the schema for storing address-related data in the database.
class DatabaseSchema {
  /// Data in the database
  DatabaseSchema({
    required this.provinceCode,
    required this.provinceName,
    required this.districtCode,
    required this.districtName,
    required this.subDistrictCode,
    required this.subDistrictName,
    required this.postalCode,
  });

  /// Code for the province.
  final int provinceCode;

  /// Name of the province.
  final String provinceName;

  /// Code for the district.
  final int districtCode;

  /// Name of the district.
  final String districtName;

  /// Code for the subdistrict.
  final int subDistrictCode;

  /// Name of the subdistrict.
  final String subDistrictName;

  /// Postal code for the area.
  final String postalCode;

  /// Converts the schema data into a JSON representation.
  Map<String, dynamic> toJson() {
    return {
      'provinceCode': provinceCode,
      'provinceName': provinceName,
      'districtCode': districtCode,
      'districtName': districtName,
      'subDistrictCode': subDistrictCode,
      'subDistrictName': subDistrictName,
      'postalCode': postalCode,
    };
  }
}

/// Query object for filtering database schema elements.
class DatabaseSchemaQuery {
  /// Query object for filtering database schema elements.
  DatabaseSchemaQuery({
    this.provinceCode,
    this.districtCode,
    this.subDistrictCode,
    this.postalCode,
    this.provinceName,
    this.districtName,
    this.subDistrictName,
  });

  /// Optional code for filtering by province.
  final int? provinceCode;

  /// Optional code for filtering by district.
  final int? districtCode;

  /// Optional code for filtering by subdistrict.
  final int? subDistrictCode;

  /// Optional postal code for filtering.
  final String? postalCode;

  /// Optional name for filtering by province.
  final String? provinceName;

  /// Optional name for filtering by district.
  final String? districtName;

  /// Optional name for filtering by subdistrict.
  final String? subDistrictName;

  /// Converts the query object into a JSON representation for easy comparison.
  Map<String, dynamic> toJson() {
    return {
      'provinceCode': provinceCode,
      'provinceName': provinceName,
      'districtCode': districtCode,
      'districtName': districtName,
      'subDistrictCode': subDistrictCode,
      'subDistrictName': subDistrictName,
      'postalCode': postalCode,
    };
  }
}

/// Type definitions for handling compressed address data.
typedef MinifySubDistrictDatabase = (String, int, List<int>);

/// Type definitions for handling compressed address data.
typedef MinifyDistrictDatabase = (String, int, List<MinifySubDistrictDatabase>);

/// Type definitions for handling compressed address data.
typedef MinifyProvinceDatabase = (String, int, List<MinifyDistrictDatabase>);

/// Type definitions for handling compressed address data.
typedef MinifyDatabase = List<MinifyProvinceDatabase>;

/// A condition function type for checking specific conditions on the data.
typedef ComposisCondition<T> = bool Function(T);

/// A callback type for transforming data elements.
typedef MapCallback<Res> = Res Function(DatabaseSchema);

/// A callback type for reducing a collection of data elements.
typedef ReduceCallback<Init> = Init Function(Init, DatabaseSchema);
