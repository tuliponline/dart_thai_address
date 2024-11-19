// To parse this JSON data, do
//
//     final subdistrictModel = subdistrictModelFromJson(jsonString);

import 'dart:convert';

SubdistrictModel subdistrictModelFromJson(String str) =>
    SubdistrictModel.fromJson(json.decode(str));

String subdistrictModelToJson(SubdistrictModel data) =>
    json.encode(data.toJson());

class SubdistrictModel {
  String subdistrictCode;
  String subdistrictNameTh;
  String postalCode;

  SubdistrictModel({
    required this.subdistrictCode,
    required this.subdistrictNameTh,
    required this.postalCode,
  });

  factory SubdistrictModel.fromJson(Map<String, dynamic> json) =>
      SubdistrictModel(
        subdistrictCode: json['subdistrictCode'],
        subdistrictNameTh: json['subdistrictNameTH'],
        postalCode: json['postalCode'],
      );

  Map<String, dynamic> toJson() => {
        'subdistrictCode': subdistrictCode,
        'subdistrictNameTH': subdistrictNameTh,
        'postalCode': postalCode,
      };
}
