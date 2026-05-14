import 'package:flutter/material.dart';
import 'searchcard.dart';

class Home extends StatefulWidget {
  Home({super.key});

  final TextEditingController fromController = TextEditingController();
  final TextEditingController toController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      body: Column(
        children: [
          Container(
            height: 260,
            width: double.infinity,

            decoration: const BoxDecoration(
              color: Color(0xFFD84E55),

              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(45),
                bottomRight: Radius.circular(45),
              ),
            ),

            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),

                child: Transform.translate(
                  offset: const Offset(0,-49),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,

                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: const [
                          Text(
                            "Hi, Nimish",
                            style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),

                          Text(
                            "Bus Booking Tickets",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),

                      Image.asset(
                        "assets/images/images.png",
                        height: 90,
                        width: 90,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          Transform.translate(
            offset: const Offset(0, -109),

            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),

              child: Searchcard(
                fromcontroller: widget.fromController,
                tocontroller: widget.toController,
                datecontroller: widget.dateController,

                searchbusTap: () {
                  print("Search Bus Clicked");
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}