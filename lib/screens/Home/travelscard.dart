import 'package:flutter/material.dart';
import 'package:travelsbookingapp/model/travelsmodel.dart';

class Travelscard extends StatefulWidget {
  final TravelsData travelsdata;
  Travelscard({super.key, required this.travelsdata});

  @override
  State<Travelscard> createState() => _TravelscardState();
}

class _TravelscardState extends State<Travelscard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Column(
                children: [
                  Text(
                    "${widget.travelsdata.boardingtime} - ${widget.travelsdata.droppingtime}",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "${widget.travelsdata.timeDifference} - 14 Seats (5 Single)",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    "Rs ${widget.travelsdata.price}",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "Onwards",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Column(
                children: [
                  Text(
                    "${widget.travelsdata.travelscompanyname} 🚍",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "${widget.travelsdata.bustype} (2 + 1)",
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              Text(
                "⭐ ${widget.travelsdata.rating}",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                child: Text(
                  "New Bus",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                child: Text(
                  "91 % On Time",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          Container(
            child: Text(
              "✨Get Rs 150 OFF on your return trip",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
