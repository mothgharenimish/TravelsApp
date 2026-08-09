import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travelsbookingapp/bloc/bookinghistorybloc/bookinghistorybloc.dart';
import 'package:travelsbookingapp/model/bookinghistorymodel.dart';
import 'package:travelsbookingapp/model/currentuser.dart';

enum _BookingStatus { upcoming, completed, cancelled }

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  static const Color bgColor = Color(0xFF0E1116);
  static const Color cardColor = Color(0xFF1B2140);
  static const Color cardBorder = Color(0xFF2A3158);
  static const Color chipColor = Color(0xFF1B2140);
  static const Color amber = Color(0xFFE8B84B);
  static const Color muted = Color(0xFF9AA0AA);
  static const Color green = Color(0xFF5FD08A);
  static const Color red = Color(0xFFE8746B);

  final Bookinghistorybloc _bloc = Bookinghistorybloc();

  int _selectedFilter = 0; // 0 = All, 1 = Upcoming, 2 = Completed, 3 = Cancelled
  final Set<String> _cancelledIds = {};

  @override
  void initState() {
    super.initState();
    _bloc.BookingHistoryGetAPI();
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  DateTime? _parseDate(String? date) {
    if (date == null || date.isEmpty) return null;
    try {
      final parts = date.split('-');
      return DateTime(
        int.parse(parts[2]),
        int.parse(parts[1]),
        int.parse(parts[0]),
      );
    } catch (_) {
      return null;
    }
  }

  _BookingStatus _statusOf(BookingHistoryData booking) {
    if (_cancelledIds.contains(booking.bookingid)) return _BookingStatus.cancelled;
    final date = _parseDate(booking.date);
    if (date == null) return _BookingStatus.completed;
    return date.isAfter(DateTime.now()) ? _BookingStatus.upcoming : _BookingStatus.completed;
  }

  String _formatDate(String? date) {
    final parsed = _parseDate(date);
    if (parsed == null) return "Date unavailable";
    const months = [
      "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec",
    ];
    return "${parsed.day} ${months[parsed.month - 1]} ${parsed.year}";
  }

  Future<void> _confirmCancel(BookingHistoryData booking) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Cancel this booking?",
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(
                "${booking.boardingcity} to ${booking.droppingcity} on ${_formatDate(booking.date)} will be cancelled. This can't be undone.",
                style: const TextStyle(color: muted, fontSize: 12.5, height: 1.4),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: cardBorder),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text("Keep booking", style: TextStyle(color: muted)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: red,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text(
                        "Cancel it",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (confirmed == true) {
      setState(() => _cancelledIds.add(booking.bookingid));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: cardColor,
            content: const Text("Booking cancelled", style: TextStyle(color: Colors.white)),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: BlocProvider.value(
        value: _bloc,
        child: BlocBuilder<Bookinghistorybloc, List<BookingHistoryData>>(
          builder: (context, allBookings) {
            final myBookings = allBookings
                .where((b) => b.userid == CurrentUser.userid)
                .toList()
              ..sort((a, b) {
                final da = _parseDate(a.date) ?? DateTime(2000);
                final db = _parseDate(b.date) ?? DateTime(2000);
                return db.compareTo(da);
              });

            final filtered = myBookings.where((b) {
              final status = _statusOf(b);
              switch (_selectedFilter) {
                case 1:
                  return status == _BookingStatus.upcoming;
                case 2:
                  return status == _BookingStatus.completed;
                case 3:
                  return status == _BookingStatus.cancelled;
                default:
                  return true;
              }
            }).toList();

            return Column(
              children: [
                _BezierHeader(tripCount: myBookings.length),
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 14, 18, 4),
                  child: SizedBox(
                    height: 34,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _filterChip("All", 0),
                        const SizedBox(width: 8),
                        _filterChip("Upcoming", 1),
                        const SizedBox(width: 8),
                        _filterChip("Completed", 2),
                        const SizedBox(width: 8),
                        _filterChip("Cancelled", 3),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: allBookings.isEmpty
                      ? const Center(
                    child: CircularProgressIndicator(color: amber, strokeWidth: 2.4),
                  )
                      : filtered.isEmpty
                      ? _emptyState()
                      : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(18, 6, 18, 20),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      return _BookingCard(
                        booking: filtered[index],
                        status: _statusOf(filtered[index]),
                        dateLabel: _formatDate(filtered[index].date),
                        onCancel: () => _confirmCancel(filtered[index]),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _filterChip(String label, int index) {
    final selected = _selectedFilter == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = index),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: selected ? amber : chipColor,
          borderRadius: BorderRadius.circular(20),
          border: selected ? null : Border.all(color: cardBorder),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: selected ? const Color(0xFF3A2A00) : muted,
          ),
        ),
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long_outlined, size: 56, color: muted.withOpacity(0.6)),
          const SizedBox(height: 12),
          const Text(
            "No bookings here",
            style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            "Trips you book will show up in this tab",
            style: TextStyle(color: muted, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

/// Header with a wavy bottom edge cut using a genuine cubic bezier path,
/// rather than a simple rounded-corner clip.
class _BezierHeader extends StatelessWidget {
  final int tripCount;
  const _BezierHeader({required this.tripCount});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _BezierClipper(),
      child: Container(
        height: 148,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2B1B01), Color(0xFF010007)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.fromLTRB(20, 50, 20, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              "My bookings",
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(
              "$tripCount trip${tripCount == 1 ? '' : 's'} booked so far",
              style: const TextStyle(color: Colors.white70, fontSize: 12.5),
            ),
          ],
        ),
      ),
    );
  }
}

class _BezierClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 36);
    path.quadraticBezierTo(
      size.width * 0.25, size.height,
      size.width * 0.5, size.height - 18,
    );
    path.quadraticBezierTo(
      size.width * 0.75, size.height - 40,
      size.width, size.height - 6,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _BookingCard extends StatelessWidget {
  final BookingHistoryData booking;
  final _BookingStatus status;
  final String dateLabel;
  final VoidCallback onCancel;

  static const Color cardColor = Color(0xFF1B2140);
  static const Color cardBorder = Color(0xFF2A3158);
  static const Color amber = Color(0xFFE8B84B);
  static const Color muted = Color(0xFF9AA0AA);
  static const Color green = Color(0xFF5FD08A);
  static const Color red = Color(0xFFE8746B);

  const _BookingCard({
    required this.booking,
    required this.status,
    required this.dateLabel,
    required this.onCancel,
  });

  Color get _statusColor {
    switch (status) {
      case _BookingStatus.upcoming:
        return amber;
      case _BookingStatus.completed:
        return green;
      case _BookingStatus.cancelled:
        return red;
    }
  }

  String get _statusLabel {
    switch (status) {
      case _BookingStatus.upcoming:
        return "Upcoming";
      case _BookingStatus.completed:
        return "Completed";
      case _BookingStatus.cancelled:
        return "Cancelled";
    }
  }

  @override
  Widget build(BuildContext context) {
    final seatNumbers = booking.passengers.map((p) => p.seatnumber).join(", ");

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cardBorder, width: 0.6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    booking.travelscompanyname,
                    style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 2),
                  Text(dateLabel, style: const TextStyle(color: muted, fontSize: 11)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: _statusColor.withOpacity(0.16),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  _statusLabel,
                  style: TextStyle(color: _statusColor, fontSize: 10.5, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(booking.boardingcity, style: const TextStyle(color: Color(0xFFD5D8DD), fontSize: 12.5)),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Icon(Icons.arrow_forward_rounded, color: muted, size: 13),
              ),
              Text(booking.droppingcity, style: const TextStyle(color: Color(0xFFD5D8DD), fontSize: 12.5)),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            "${booking.boardingpoint} → ${booking.droppingpoint}",
            style: const TextStyle(color: muted, fontSize: 11),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: cardBorder),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "${booking.totalpassengers} passenger${booking.totalpassengers > 1 ? 's' : ''} • $seatNumbers",
                  style: const TextStyle(color: muted, fontSize: 11),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                "₹${booking.totalprice}",
                style: const TextStyle(color: amber, fontSize: 13.5, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          if (status == _BookingStatus.upcoming) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: onCancel,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: red),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text(
                  "Cancel booking",
                  style: TextStyle(color: red, fontSize: 12.5, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}