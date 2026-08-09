import 'package:flutter/material.dart';
import 'package:travelsbookingapp/model/travelsmodel.dart';

class Selectedseats extends StatefulWidget {
  

  @override
  State<Selectedseats> createState() => _SelectedseatsState();
}

class _SelectedseatsState extends State<Selectedseats> {
  late final TravelsData travelsdata;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      print('Button pressed!');
                    },
                  ),
                  Column(
                    children: [
                      Text("${travelsdata.boardingcity}-${travelsdata.droppingcity}"),
                      Text("${travelsdata.date}")
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
