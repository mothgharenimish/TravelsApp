import 'dart:convert';

List<BoardingData> boardingDataFromJson(String str) =>
    List<BoardingData>.from(json.decode(str).map((x) => BoardingData.fromJson(x)));

String boardingDataToJson(List<BoardingData> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BoardingData {
  String id;
  String city;
  List<BoardingPoint> boardingpoints;
  String travelscompanyname;
  String cityid;
  String travelsid;

  BoardingData({
    required this.id,
    required this.city,
    required this.boardingpoints,
    required this.travelscompanyname,
    required this.cityid,
    required this.travelsid,
  });

  factory BoardingData.fromJson(Map<String, dynamic> json) => BoardingData(
    id: json["_id"],
    city: json["city"],
    boardingpoints: List<BoardingPoint>.from(
      json["boardingpoints"].map((x) => BoardingPoint.fromJson(x)),
    ),
    travelscompanyname: json["travelscompanyname"],
    cityid: json["cityid"],
    travelsid: json["travelsid"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "city": city,
    "boardingpoints":
    List<dynamic>.from(boardingpoints.map((x) => x.toJson())),
    "travelscompanyname": travelscompanyname,
    "cityid": cityid,
    "travelsid": travelsid,
  };
}

class BoardingPoint {
  String boardingpoint;
  String time;

  BoardingPoint({
    required this.boardingpoint,
    required this.time,
  });

  factory BoardingPoint.fromJson(Map<String, dynamic> json) => BoardingPoint(
    boardingpoint: json["boardingpoint"],
    time: json["time"],
  );

  Map<String, dynamic> toJson() => {
    "boardingpoint": boardingpoint,
    "time": time,
  };
}