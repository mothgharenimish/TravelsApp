import 'dart:convert';

List<BookingHistoryData> bookingHistoryDataFromJson(String str) =>
    List<BookingHistoryData>.from(
      json.decode(str).map((x) => BookingHistoryData.fromJson(x)),
    );

String bookingHistoryDataToJson(List<BookingHistoryData> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BookingHistoryData {
  String id;
  String bookingid;
  String userid;
  String emailid;
  String mobilenumber;
  String travelsid;
  String travelscompanyname;
  String boardingcity;
  String droppingcity;
  String boardingpoint;
  String droppingpoint;
  String? date;
  List<Passenger> passengers;
  int totalpassengers;
  int totalprice;

  BookingHistoryData({
    required this.id,
    required this.bookingid,
    required this.userid,
    required this.emailid,
    required this.mobilenumber,
    required this.travelsid,
    required this.travelscompanyname,
    required this.boardingcity,
    required this.droppingcity,
    required this.boardingpoint,
    required this.droppingpoint,
    this.date,
    required this.passengers,
    required this.totalpassengers,
    required this.totalprice,
  });

  factory BookingHistoryData.fromJson(Map<String, dynamic> json) => BookingHistoryData(
    id: json["_id"],
    bookingid: json["bookingid"],
    userid: json["userid"],
    emailid: json["emailid"],
    mobilenumber: json["mobilenumber"],
    travelsid: json["travelsid"],
    travelscompanyname: json["travelscompanyname"],
    boardingcity: json["boardingcity"],
    droppingcity: json["droppingcity"],
    boardingpoint: json["boardingpoint"],
    droppingpoint: json["droppingpoint"],
    date: json["date"],
    passengers: List<Passenger>.from(
      (json["passengers"] ?? []).map((x) => Passenger.fromJson(x)),
    ),
    totalpassengers: json["totalpassengers"],
    totalprice: json["totalprice"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "bookingid": bookingid,
    "userid": userid,
    "emailid": emailid,
    "mobilenumber": mobilenumber,
    "travelsid": travelsid,
    "travelscompanyname": travelscompanyname,
    "boardingcity": boardingcity,
    "droppingcity": droppingcity,
    "boardingpoint": boardingpoint,
    "droppingpoint": droppingpoint,
    "date": date,
    "passengers": List<dynamic>.from(passengers.map((x) => x.toJson())),
    "totalpassengers": totalpassengers,
    "totalprice": totalprice,
  };
}

class Passenger {
  String name;
  String gender;
  String seatnumber;

  Passenger({
    required this.name,
    required this.gender,
    required this.seatnumber,
  });

  factory Passenger.fromJson(Map<String, dynamic> json) => Passenger(
    name: json["name"],
    gender: json["gender"],
    seatnumber: json["seatnumber"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "gender": gender,
    "seatnumber": seatnumber,
  };
}