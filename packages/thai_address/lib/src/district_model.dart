// To parse this JSON data, do
//
//     final districtModel = districtModelFromJson(jsonString);

import 'dart:convert';

DistrictModel districtModelFromJson(String str) =>
    DistrictModel.fromJson(json.decode(str));

String districtModelToJson(DistrictModel data) => json.encode(data.toJson());

class DistrictModel {
  String districtCode;
  String districtNameTh;

  DistrictModel({
    required this.districtCode,
    required this.districtNameTh,
  });

  factory DistrictModel.fromJson(Map<String, dynamic> json) => DistrictModel(
        districtCode: json['districtCode'],
        districtNameTh: json['districtNameTh'],
      );

  Map<String, dynamic> toJson() => {
        'districtCode': districtCode,
        'districtNameTh': districtNameTh,
      };
}
