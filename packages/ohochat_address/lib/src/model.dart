class GeographyDTO {
  final int id;
  final int provinceCode;
  final String provinceNameEn;
  final String provinceNameTh;
  final int districtCode;
  final String districtNameEn;
  final String districtNameTh;
  final int subdistrictCode;
  final String subdistrictNameEn;
  final String subdistrictNameTh;
  final int postalCode;

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
}

class DatabaseSchema {
  final int provinceCode;
  final String provinceName;
  final int districtCode;
  final String districtName;
  final int subDistrictCode;
  final String subDistrictName;
  final String postalCode;

  DatabaseSchema({
    required this.provinceCode,
    required this.provinceName,
    required this.districtCode,
    required this.districtName,
    required this.subDistrictCode,
    required this.subDistrictName,
    required this.postalCode,
  });

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

class DatabaseSchemaQuery {
  final int? provinceCode;
  final int? districtCode;
  final int? subDistrictCode;
  final String? postalCode;
  final String? provinceName;
  final String? districtName;
  final String? subDistrictName;

  DatabaseSchemaQuery({
    this.provinceCode,
    this.districtCode,
    this.subDistrictCode,
    this.postalCode,
    this.provinceName,
    this.districtName,
    this.subDistrictName,
  });

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

typedef MinifySubDistrictDatabase = (String, int, List<int>);
typedef MinifyDistrictDatabase = (String, int, List<MinifySubDistrictDatabase>);
typedef MinifyProvinceDatabase = (String, int, List<MinifyDistrictDatabase>);
typedef MinifyDatabase = List<MinifyProvinceDatabase>;

typedef ComposisCondition<T> = bool Function(T);

typedef MapCallback<Res> = Res Function(DatabaseSchema);
typedef ReduceCallback<Init> = Init Function(Init, DatabaseSchema);
