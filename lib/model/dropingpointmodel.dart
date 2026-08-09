import 'dart:convert';

List<DroppingData> droppingDataFromJson(String str) =>
    List<DroppingData>.from(json.decode(str).map((x) => DroppingData.fromJson(x)));

String droppingDataToJson(List<DroppingData> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DroppingData {
  String id;
  String city;
  String travelsid;
  String travelscompanyname;
  List<DroppingPoint> droppingpoints;
  String cityid;

  DroppingData({
    required this.id,
    required this.city,
    required this.travelsid,
    required this.travelscompanyname,
    required this.droppingpoints,
    required this.cityid,
  });

  factory DroppingData.fromJson(Map<String, dynamic> json) => DroppingData(
    id: json["_id"],
    city: json["city"],
    travelsid: json["travelsid"],
    travelscompanyname: json["travelscompanyname"],
    droppingpoints: List<DroppingPoint>.from(
      json["droppingpoints"].map((x) => DroppingPoint.fromJson(x)),
    ),
    cityid: json["cityid"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "city": city,
    "travelsid": travelsid,
    "travelscompanyname": travelscompanyname,
    "droppingpoints":
    List<dynamic>.from(droppingpoints.map((x) => x.toJson())),
    "cityid": cityid,
  };
}

class DroppingPoint {
  String droppingpoint;
  String time;

  DroppingPoint({
    required this.droppingpoint,
    required this.time,
  });

  factory DroppingPoint.fromJson(Map<String, dynamic> json) => DroppingPoint(
    droppingpoint: json["droppingpoint"],
    time: json["time"],
  );

  Map<String, dynamic> toJson() => {
    "droppingpoint": droppingpoint,
    "time": time,
  };
}