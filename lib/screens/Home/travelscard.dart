import 'package:flutter/material.dart';
import 'package:travelsbookingapp/model/travelsmodel.dart';

class Travelscard extends StatefulWidget {
  final TravelsData travelsdata;
  final VoidCallback onTap;

  const Travelscard({super.key, required this.travelsdata, required this.onTap});

  @override
  State<Travelscard> createState() => _TravelscardState();
}

class _TravelscardState extends State<Travelscard> {
  static const Color cardColor = Color(0xFF1C2028);
  static const Color borderColor = Color(0xFF262B35);
  static const Color amber = Color(0xFFE8B84B);
  static const Color muted = Color(0xFF9AA0AA);
  static const Color originDot = Color(0xFF5B8DEF);
  static const Color ratingGreen = Color(0xFF5FD08A);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: widget.onTap,
          splashColor: amber.withOpacity(0.06),
          highlightColor: amber.withOpacity(0.03),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: borderColor, width: 0.6),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// DATE
                Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined, size: 12, color: muted),
                    const SizedBox(width: 6),
                    Text(
                      _formatDate(widget.travelsdata.date),
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: muted,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                /// TIMELINE ROW: TIME + DURATION + PRICE
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 3, right: 12),
                      child: Column(
                        children: [
                          Container(
                            width: 7,
                            height: 7,
                            decoration: const BoxDecoration(
                              color: originDot,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(
                            height: 46,
                            child: _DashedLine(color: Color(0xFF3A3F4A)),
                          ),
                          Container(
                            width: 7,
                            height: 7,
                            decoration: BoxDecoration(
                              color: amber,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${widget.travelsdata.boardingtime}",
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 1),
                                    Text(
                                      "${widget.travelsdata.boardingcity}",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 11.5, color: muted),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 2),
                                child: Text(
                                  widget.travelsdata.timeDifference != null
                                      ? _formatDuration(widget.travelsdata.timeDifference!)   // ← FIXED
                                      : "",
                                  style: const TextStyle(fontSize: 11, color: muted),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${widget.travelsdata.droppingtime}",
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 1),
                                    Text(
                                      "${widget.travelsdata.droppingcity}",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 11.5, color: muted),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 2),
                                child: Text(
                                  "₹${widget.travelsdata.price}",
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: amber,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),
                const Divider(height: 1, color: borderColor),
                const SizedBox(height: 12),

                /// COMPANY + SEATS + RATING
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${widget.travelsdata.travelscompanyname}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "${widget.travelsdata.bustype} • 2+1 • 14 seats left",
                            style: const TextStyle(fontSize: 11.5, color: muted),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                      decoration: BoxDecoration(
                        color: borderColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star_rounded, size: 13, color: ratingGreen),
                          const SizedBox(width: 3),
                          Text(
                            "${widget.travelsdata.rating}",
                            style: const TextStyle(
                              color: ratingGreen,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                /// TAGS
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _tag("🚌  New Bus", const Color(0xFF2A2210), const Color(0xFFE8B84B)),
                    _tag("⏰  91% On Time", const Color(0xFF12271A), ratingGreen),
                  ],
                ),

                const SizedBox(height: 12),

                /// OFFER BANNER
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF262110),
                    borderRadius: BorderRadius.circular(11),
                    border: Border.all(color: const Color(0xFF3A3010), width: 0.6),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.local_offer_rounded, color: amber, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Get ₹150 OFF on your return trip",
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: amber.withOpacity(0.95),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(String date) {
    const months = [
      "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];
    try {
      final parts = date.split('-');
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);
      return "$day ${months[month - 1]} $year";
    } catch (_) {
      return date;
    }
  }

  String _formatDuration(double hours) {
    final totalMinutes = (hours * 60).round();
    final h = totalMinutes ~/ 60;
    final m = totalMinutes % 60;

    if (h == 0) return "${m}m";
    if (m == 0) return "${h}h";
    return "${h}h ${m}m";
  }

  Widget _tag(String label, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: fg,
        ),
      ),
    );
  }
}

/// Small vertical dashed connector used in the route timeline.
class _DashedLine extends StatelessWidget {
  final Color color;
  const _DashedLine({required this.color});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final dashHeight = 3.0;
        final dashSpace = 3.0;
        final dashCount = (constraints.maxHeight / (dashHeight + dashSpace)).floor();
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: 1,
              height: dashHeight,
              child: DecoratedBox(decoration: BoxDecoration(color: color)),
            );
          }),
        );
      },
    );
  }
}