import 'package:flutter/material.dart';

class Searchcard extends StatelessWidget {
  final TextEditingController fromcontroller;
  final TextEditingController tocontroller;
  final TextEditingController datecontroller;
  final VoidCallback searchbusTap;
  final VoidCallback? onSwapTap;
  final VoidCallback? onDateTap;

  static const Color cardColor = Color(0xFF1C2028);
  static const Color dividerColor = Color(0xFF2A2F3A);
  static const Color swapBg = Color(0xFF262B35);
  static const Color amber = Color(0xFFE8B84B);
  static const Color muted = Color(0xFF9AA0AA);
  static const Color originDot = Color(0xFF5B8DEF);

  const Searchcard({
    super.key,
    required this.fromcontroller,
    required this.tocontroller,
    required this.datecontroller,
    required this.searchbusTap,
    this.onSwapTap,
    this.onDateTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          /// FROM / TO TIMELINE ROW
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// TIMELINE DOTS
              Padding(
                padding: const EdgeInsets.only(top: 2, right: 12),
                child: Column(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: originDot,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 26,
                      color: const Color(0xFF3A3F4A),
                      margin: const EdgeInsets.symmetric(vertical: 3),
                    ),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: amber,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
              ),

              /// FROM / TO INPUTS
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: fromcontroller,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      decoration: const InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        hintText: "From",
                        hintStyle: TextStyle(color: muted, fontWeight: FontWeight.w400),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    const SizedBox(height: 22),
                    TextFormField(
                      controller: tocontroller,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      decoration: const InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        hintText: "To",
                        hintStyle: TextStyle(color: muted, fontWeight: FontWeight.w400),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
              ),

              /// SWAP BUTTON
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(9),
                  onTap: onSwapTap,
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      color: swapBg,
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: const Icon(
                      Icons.swap_vert_rounded,
                      color: amber,
                      size: 17,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          const Divider(height: 1, color: dividerColor),
          const SizedBox(height: 12),

          /// DATE + SEARCH BUTTON
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: onDateTap,
                borderRadius: BorderRadius.circular(8),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined, color: muted, size: 15),
                    const SizedBox(width: 7),
                    Text(
                      datecontroller.text.isEmpty
                          ? "Select date"
                          : datecontroller.text,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFFD5D8DD),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(11),
                  onTap: searchbusTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                    decoration: BoxDecoration(
                      color: amber,
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.search, color: Color(0xFF2A1E00), size: 15),
                        SizedBox(width: 5),
                        Text(
                          "Search",
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF2A1E00),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}