// To parse this JSON data, do
//
//     final districtsResponse = districtsResponseFromJson(jsonString);

import 'dart:convert';

DistrictsResponse districtsResponseFromJson(String str) => DistrictsResponse.fromJson(json.decode(str));

class DistrictsResponse {
  DistrictsResponse({
    this.districts,
    this.ttl,
  });

  List<District> districts;
  int ttl;

  factory DistrictsResponse.fromJson(Map<String, dynamic> json) => DistrictsResponse(
    districts: List<District>.from(json["districts"].map((x) => District.fromJson(x))),
    ttl: json["ttl"],
  );
}

class District {
  District({
    this.districtId,
    this.districtName,
  });

  int districtId;
  String districtName;

  factory District.fromJson(Map<String, dynamic> json) => District(
    districtId: json["district_id"],
    districtName: json["district_name"],
  );
}
