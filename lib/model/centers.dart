// To parse this JSON data, do
//
//     final centerResponse = centerResponseFromJson(jsonString);

import 'dart:convert';

CenterResponse centerResponseFromJson(String str) => CenterResponse.fromJson(json.decode(str));

String centerResponseToJson(CenterResponse data) => json.encode(data.toJson());

class CenterResponse {
  CenterResponse({
    this.centers,
    this.ttl,
  });

  List<Center> centers;
  int ttl;

  factory CenterResponse.fromJson(Map<String, dynamic> json) => CenterResponse(
    centers: List<Center>.from(json["centers"].map((x) => Center.fromJson(x))),
    ttl: json["ttl"],
  );

  Map<String, dynamic> toJson() => {
    "centers": List<dynamic>.from(centers.map((x) => x.toJson())),
    "ttl": ttl,
  };
}

class Center {
  Center({
    this.centerId,
    this.name,
    this.districtName,
    this.stateName,
    this.location,
    this.pincode,
    this.blockName,
    this.lat,
    this.long,
  });

  int centerId;
  String name;
  DistrictName districtName;
  StateName stateName;
  String location;
  String pincode;
  String blockName;
  String lat;
  String long;

  factory Center.fromJson(Map<String, dynamic> json) => Center(
    centerId: json["center_id"],
    name: json["name"],
    districtName: districtNameValues.map[json["district_name"]],
    stateName: stateNameValues.map[json["state_name"]],
    location: json["location"],
    pincode: json["pincode"],
    blockName: json["block_name"],
    lat: json["lat"],
    long: json["long"],
  );

  Map<String, dynamic> toJson() => {
    "center_id": centerId,
    "name": name,
    "district_name": districtNameValues.reverse[districtName],
    "state_name": stateNameValues.reverse[stateName],
    "location": location,
    "pincode": pincode,
    "block_name": blockName,
    "lat": lat,
    "long": long,
  };
}

enum DistrictName { GHAZIABAD, GAUTAM_BUDDHA_NAGAR, EAST_DELHI, AGATTI_ISLAND, NORTH_DELHI }

final districtNameValues = EnumValues({
  "Agatti Island": DistrictName.AGATTI_ISLAND,
  "East Delhi": DistrictName.EAST_DELHI,
  "Gautam Buddha Nagar": DistrictName.GAUTAM_BUDDHA_NAGAR,
  "Ghaziabad": DistrictName.GHAZIABAD,
  "North Delhi": DistrictName.NORTH_DELHI
});

enum StateName { UTTAR_PRADESH, DELHI, LAKSHADWEEP }

final stateNameValues = EnumValues({
  "Delhi": StateName.DELHI,
  "Lakshadweep": StateName.LAKSHADWEEP,
  "Uttar Pradesh": StateName.UTTAR_PRADESH
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
