import 'package:flutter/material.dart';

class Searchcard extends StatelessWidget {
  final TextEditingController fromcontroller;
  final TextEditingController tocontroller;
  final TextEditingController datecontroller;

  const Searchcard({super.key, required this.fromcontroller, required this.tocontroller, required this.datecontroller});


  @override
  Widget build(BuildContext context) {
    return  Container(

     child: Column(
       children: [
         Padding(
           padding: EdgeInsets.only(
             top: 10,
             left: 15,
             right: 15,
           ),
           child: TextFormField(
             controller: fromcontroller,
             decoration: InputDecoration(
               labelText: "From",
               border: OutlineInputBorder(
                 borderRadius: BorderRadius.circular(12),
               ),
             ),
           ),
         ),
         Padding(
           padding: EdgeInsets.only(
             top: 7,
             left: 20,
             right: 20,
           ),
           child: TextFormField(
             controller: tocontroller,
             decoration: InputDecoration(
               labelText: "To",
               border: OutlineInputBorder(
                 borderRadius: BorderRadius.circular(12),
               ),
             ),
           ),
         ),

         Padding(
           padding: EdgeInsets.only(
             top: 7,
             left: 20,
             right: 20,
           ),
           child: TextFormField(
             controller: datecontroller,
             decoration: InputDecoration(
               labelText: "Date",
               border: OutlineInputBorder(
                 borderRadius: BorderRadius.circular(12),
               ),
             ),
           ),
         ),
       ],
     ),




    );
  }
}
