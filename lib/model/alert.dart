import 'dart:convert';

Alert alertFromJson(String str) => Alert.fromJson(json.decode(str));

String alertToJson(Alert data) => json.encode(data.toJson());

class Alert {
  Alert({
    this.districtId,
    this.vaccine,
    this.price,
    this.age,
    this.qtyDose1,
    this.qtyDose2,
  });

  List<dynamic> districtId;
  String vaccine;
  String price;
  String age;
  int qtyDose1;
  int qtyDose2;

  factory Alert.fromJson(Map<String, dynamic> json) => Alert(
    districtId: List<dynamic>.from(json["district_id"].map((x) => x)),
    vaccine: json["vaccine"],
    price: json["price"],
    age: json["age"],
    qtyDose1: json["qty_dose_1"],
    qtyDose2: json["qty_dose_2"],
  );

  Map<String, dynamic> toJson() => {
    "district_id": List<dynamic>.from(districtId.map((x) => x)),
    "vaccine": vaccine,
    "price": price,
    "age": age,
    "qty_dose_1": qtyDose1,
    "qty_dose_2": qtyDose2,
  };
}
