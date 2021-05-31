// To parse this JSON data, do
//
//     final slotResponse = slotResponseFromJson(jsonString);

import 'dart:convert';

SlotResponse slotResponseFromJson(String str) => SlotResponse.fromJson(json.decode(str));

String slotResponseToJson(SlotResponse data) => json.encode(data.toJson());

class SlotResponse {
  SlotResponse({
    this.centers,
  });

  List<SlotCenter> centers;

  factory SlotResponse.fromJson(Map<String, dynamic> json) => SlotResponse(
    centers: List<SlotCenter>.from(json["centers"].map((x) => SlotCenter.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "centers": List<dynamic>.from(centers.map((x) => x.toJson())),
  };
}

class SlotCenter {
  SlotCenter({
    this.centerId,
    this.name,
    this.address,
    this.stateName,
    this.districtName,
    this.blockName,
    this.pincode,
    this.lat,
    this.long,
    this.from,
    this.to,
    this.feeType,
    this.sessions,
    this.vaccineFees,
  });

  int centerId;
  String name;
  String address;
  StateName stateName;
  DistrictName districtName;
  String blockName;
  int pincode;
  int lat;
  int long;
  String from;
  String to;
  FeeType feeType;
  List<Session> sessions;
  List<VaccineFee> vaccineFees;

  factory SlotCenter.fromJson(Map<String, dynamic> json) => SlotCenter(
    centerId: json["center_id"],
    name: json["name"],
    address: json["address"],
    stateName: stateNameValues.map[json["state_name"]],
    districtName: districtNameValues.map[json["district_name"]],
    blockName: json["block_name"],
    pincode: json["pincode"],
    lat: json["lat"],
    long: json["long"],
    from: json["from"],
    to: json["to"],
    feeType: feeTypeValues.map[json["fee_type"]],
    sessions: List<Session>.from(json["sessions"].map((x) => Session.fromJson(x))),
    vaccineFees: json["vaccine_fees"] == null ? null : List<VaccineFee>.from(json["vaccine_fees"].map((x) => VaccineFee.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "center_id": centerId,
    "name": name,
    "address": address,
    "state_name": stateNameValues.reverse[stateName],
    "district_name": districtNameValues.reverse[districtName],
    "block_name": blockName,
    "pincode": pincode,
    "lat": lat,
    "long": long,
    "from": from,
    "to": to,
    "fee_type": feeTypeValues.reverse[feeType],
    "sessions": List<dynamic>.from(sessions.map((x) => x.toJson())),
    "vaccine_fees": vaccineFees == null ? null : List<dynamic>.from(vaccineFees.map((x) => x.toJson())),
  };
}

enum DistrictName { GHAZIABAD }

final districtNameValues = EnumValues({
  "Ghaziabad": DistrictName.GHAZIABAD
});

enum FeeType { FREE, PAID }

final feeTypeValues = EnumValues({
  "Free": FeeType.FREE,
  "Paid": FeeType.PAID
});

class Session {
  Session({
    this.sessionId,
    this.date,
    this.availableCapacity,
    this.minAgeLimit,
    this.vaccine,
    this.slots,
    this.availableCapacityDose1,
    this.availableCapacityDose2,
  });

  String sessionId;
  Date date;
  int availableCapacity;
  int minAgeLimit;
  Vaccine vaccine;
  List<Slot> slots;
  int availableCapacityDose1;
  int availableCapacityDose2;

  factory Session.fromJson(Map<String, dynamic> json) => Session(
    sessionId: json["session_id"],
    date: dateValues.map[json["date"]],
    availableCapacity: json["available_capacity"],
    minAgeLimit: json["min_age_limit"],
    vaccine: vaccineValues.map[json["vaccine"]],
    slots: List<Slot>.from(json["slots"].map((x) => slotValues.map[x])),
    availableCapacityDose1: json["available_capacity_dose1"],
    availableCapacityDose2: json["available_capacity_dose2"],
  );

  Map<String, dynamic> toJson() => {
    "session_id": sessionId,
    "date": dateValues.reverse[date],
    "available_capacity": availableCapacity,
    "min_age_limit": minAgeLimit,
    "vaccine": vaccineValues.reverse[vaccine],
    "slots": List<dynamic>.from(slots.map((x) => slotValues.reverse[x])),
    "available_capacity_dose1": availableCapacityDose1,
    "available_capacity_dose2": availableCapacityDose2,
  };
}

enum Date { THE_31052021, THE_01062021, THE_02062021, THE_03062021, THE_04062021, THE_05062021 }

final dateValues = EnumValues({
  "01-06-2021": Date.THE_01062021,
  "02-06-2021": Date.THE_02062021,
  "03-06-2021": Date.THE_03062021,
  "04-06-2021": Date.THE_04062021,
  "05-06-2021": Date.THE_05062021,
  "31-05-2021": Date.THE_31052021
});

enum Slot { THE_0900_AM_1100_AM, THE_1100_AM_0100_PM, THE_0100_PM_0300_PM, THE_0300_PM_0400_PM, THE_1000_AM_1100_AM, THE_1100_AM_1200_PM, THE_1200_PM_0100_PM, THE_0100_PM_0400_PM, THE_0300_PM_0600_PM }

final slotValues = EnumValues({
  "01:00PM-03:00PM": Slot.THE_0100_PM_0300_PM,
  "01:00PM-04:00PM": Slot.THE_0100_PM_0400_PM,
  "03:00PM-04:00PM": Slot.THE_0300_PM_0400_PM,
  "03:00PM-06:00PM": Slot.THE_0300_PM_0600_PM,
  "09:00AM-11:00AM": Slot.THE_0900_AM_1100_AM,
  "10:00AM-11:00AM": Slot.THE_1000_AM_1100_AM,
  "11:00AM-01:00PM": Slot.THE_1100_AM_0100_PM,
  "11:00AM-12:00PM": Slot.THE_1100_AM_1200_PM,
  "12:00PM-01:00PM": Slot.THE_1200_PM_0100_PM
});

enum Vaccine { COVISHIELD, COVAXIN }

final vaccineValues = EnumValues({
  "COVAXIN": Vaccine.COVAXIN,
  "COVISHIELD": Vaccine.COVISHIELD
});

enum StateName { UTTAR_PRADESH }

final stateNameValues = EnumValues({
  "Uttar Pradesh": StateName.UTTAR_PRADESH
});

class VaccineFee {
  VaccineFee({
    this.vaccine,
    this.fee,
  });

  Vaccine vaccine;
  String fee;

  factory VaccineFee.fromJson(Map<String, dynamic> json) => VaccineFee(
    vaccine: vaccineValues.map[json["vaccine"]],
    fee: json["fee"],
  );

  Map<String, dynamic> toJson() => {
    "vaccine": vaccineValues.reverse[vaccine],
    "fee": fee,
  };
}

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
