import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travelsbookingapp/bloc/travelsbloc/travelsapibloc.dart';
import 'package:travelsbookingapp/bloc/travelsbloc/travelsapistate.dart';
import 'package:travelsbookingapp/model/travelsmodel.dart';
import 'package:travelsbookingapp/screens/Home/travelscard.dart';
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
  List<TravelsData> sortedTravels = [];

  @override
  void initState() {
    super.initState();

    context.read<TravelsCubit>().TravelGetAPI();
  }

  DateTime parseDate(String date) {
    List<String> parts = date.split('-');

    return DateTime(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TravelsCubit, TravelsapiState>(
      listener: (context, state) {
        sortedTravels = List.from(state.travelsdata);

        sortedTravels.sort((a, b) {
          DateTime dateA = parseDate(a.date);
          DateTime dateB = parseDate(b.date);

          return dateB.compareTo(dateA);
        });

        setState(() {});
      },

      child: Scaffold(
        backgroundColor: Colors.grey.shade100,

        body: Stack(
          children: [
            /// RED BACKGROUND
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
            ),

            /// MAIN CONTENT
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),

                child: Column(
                  children: [
                    /// TOP SPACE
                    const SizedBox(height: 10),

                    /// HEADER
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      crossAxisAlignment: CrossAxisAlignment.center,

                      children: [
                        /// TEXTS
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: const [
                            Text(
                              "Hi, Nimish",

                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "Bus Booking Tickets",

                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
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

                    const SizedBox(height: 20),

                    Searchcard(
                      fromcontroller: widget.fromController,

                      tocontroller: widget.toController,

                      datecontroller: widget.dateController,

                      searchbusTap: () {
                        print("Search Bus Clicked");
                      },
                    ),

                    const SizedBox(height: 10),

                    Expanded(
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),

                        itemCount: sortedTravels.length,

                        itemBuilder: (context, index) {
                          return Travelscard(travelsdata: sortedTravels[index]);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
