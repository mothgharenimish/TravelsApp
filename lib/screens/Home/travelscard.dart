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

        ],
      ),
    );
  }
}
