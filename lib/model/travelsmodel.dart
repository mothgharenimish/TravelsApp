import 'dart:convert';

List<TravelsData> travelsDataFromJson(String str) => List<TravelsData>.from(json.decode(str).map((x) => TravelsData.fromJson(x)));

String travelsDataToJson(List<TravelsData> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TravelsData {
  String id;
  String travelscompanyname;
  String travelsid;
  String boardingcity;
  String droppingcity;
  String bustype;
  int price;
  double rating;
  String boardingtime;
  String droppingtime;
  String date;
  double? timeDifference;

  TravelsData({
    required this.id,
    required this.travelscompanyname,
    required this.travelsid,
    required this.boardingcity,
    required this.droppingcity,
    required this.bustype,
    required this.price,
    required this.rating,
    required this.boardingtime,
    required this.droppingtime,
    required this.date,
    this.timeDifference
  });

  factory TravelsData.fromJson(Map<String, dynamic> json) => TravelsData(
    id: json["_id"],
    travelscompanyname: json["travelscompanyname"],
    travelsid: json["travelsid"],
    boardingcity: json["boardingcity"],
    droppingcity: json["droppingcity"],
    bustype: json["bustype"],
    price: json["price"],
    rating: json["rating"]?.toDouble(),
    boardingtime: json["boardingtime"],
    droppingtime: json["droppingtime"],
    date: json["date"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "travelscompanyname": travelscompanyname,
    "travelsid": travelsid,
    "boardingcity": boardingcity,
    "droppingcity": droppingcity,
    "bustype": bustype,
    "price": price,
    "rating": rating,
    "boardingtime": boardingtime,
    "droppingtime": droppingtime,
    "date": date,
  };
}
