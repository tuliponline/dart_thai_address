// To parse this JSON data, do
//
//     final provinceModel = provinceModelFromJson(jsonString);

import 'dart:convert';

ProvinceModel provinceModelFromJson(String str) =>
    ProvinceModel.fromJson(json.decode(str));

String provinceModelToJson(ProvinceModel data) => json.encode(data.toJson());

class ProvinceModel {
  String provinceCode;
  String provinceNameTh;

  ProvinceModel({
    required this.provinceCode,
    required this.provinceNameTh,
  });

  factory ProvinceModel.fromJson(Map<String, dynamic> json) => ProvinceModel(
        provinceCode: json['provinceCode'],
        provinceNameTh: json['provinceNameTh'],
      );

  Map<String, dynamic> toJson() => {
        'provinceCode': provinceCode,
        'provinceNameTh': provinceNameTh,
      };
}
