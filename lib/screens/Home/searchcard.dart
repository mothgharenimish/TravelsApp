import 'package:flutter/material.dart';

class Searchcard extends StatelessWidget {
  final TextEditingController fromcontroller;
  final TextEditingController tocontroller;
  final TextEditingController datecontroller;
  final VoidCallback searchbusTap;

  const Searchcard({
    super.key,
    required this.fromcontroller,
    required this.tocontroller,
    required this.datecontroller,
    required this.searchbusTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      width: 380,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            height: 50,
            child: Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: TextFormField(
                controller: fromcontroller,
                decoration: const InputDecoration(
                  labelText: "From",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.red,
                      width: 2,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.red,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: 5),
          SizedBox(
            height: 50,
            child: Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: TextFormField(
                controller: tocontroller,
                decoration: const InputDecoration(
                  labelText: "To",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.red,
                      width: 2,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.red,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 5),

          SizedBox(
            height: 50,
            child: Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: TextFormField(
                controller: datecontroller,
                decoration: const InputDecoration(
                  labelText: "Date",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.red,
                      width: 2,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.red,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),

            child: SizedBox(
              height: 50,
              width: double.infinity,

              child: ElevatedButton(
                onPressed: () {
                  searchbusTap;
                },

                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),

                  backgroundColor: const Color(0xFFD84E55),
                ),

                child: Text(
                  "Search Bus",

                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
