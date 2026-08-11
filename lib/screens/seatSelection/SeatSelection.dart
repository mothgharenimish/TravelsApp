import 'package:flutter/material.dart';
import 'package:travelsbookingapp/screens/OnboardDroppingPoint/onboarddroppingpoint.dart';

enum SeatStatus { available, selected, booked }

class Seat {
  final String id;
  SeatStatus status;

  Seat({required this.id, this.status = SeatStatus.available});
}

class SeatSelection extends StatefulWidget {
  final String travelsid;
  final String companyName;
  final String boardingCity;
  final String droppingCity;
  final int pricePerSeat;

  const SeatSelection({
    super.key,
    required this.travelsid,
    this.companyName = "Shivneri Travels",
    this.boardingCity = "Nashik",
    this.droppingCity = "Pune",
    this.pricePerSeat = 899,
  });

  @override
  State<SeatSelection> createState() => _SeatSelectionState();
}

class _SeatSelectionState extends State<SeatSelection> {
  static const Color bgColor = Color(0xFF0E1116);
  static const Color cardColor = Color(0xFF1C2028);
  static const Color borderColor = Color(0xFF262B35);
  static const Color amber = Color(0xFFE8B84B);
  static const Color muted = Color(0xFF9AA0AA);
  static const Color bookedColor = Color(0xFF262B35);
  static const Color bookedText = Color(0xFF4A4F5A);

  bool showLowerDeck = true;

  late List<Seat> lowerSingles;
  late List<List<Seat>> lowerDoublePairs;

  late List<Seat> upperSingles;
  late List<List<Seat>> upperDoublePairs;

  @override
  void initState() {
    super.initState();

    lowerSingles = List.generate(10, (i) => Seat(id: "L${i + 1}"));
    print("The lower singles is $lowerSingles");
    lowerDoublePairs = List.generate(
      10,
          (row) => [
        Seat(id: "LL${row * 2 + 1}"),
        Seat(id: "LL${row * 2 + 2}"),
      ],
    );

    upperSingles = List.generate(10, (i) => Seat(id: "U${i + 1}"));
    upperDoublePairs = List.generate(
      10,
          (row) => [
        Seat(id: "UU${row * 2 + 1}"),
        Seat(id: "UU${row * 2 + 2}"),
      ],
    );

    lowerSingles[1].status = SeatStatus.booked;
    lowerDoublePairs[1][1].status = SeatStatus.booked;
    upperSingles[2].status = SeatStatus.booked;
    upperDoublePairs[0][0].status = SeatStatus.booked;
  }

  List<Seat> get _allSeats => [
    ...lowerSingles,
    ...lowerDoublePairs.expand((pair) => pair),
    ...upperSingles,
    ...upperDoublePairs.expand((pair) => pair),
  ];

  List<Seat> get _selectedSeats =>
      _allSeats.where((s) => s.status == SeatStatus.selected).toList();

  void _toggleSeat(Seat seat) {
    if (seat.status == SeatStatus.booked) return;
    setState(() {
      seat.status = seat.status == SeatStatus.selected
          ? SeatStatus.available
          : SeatStatus.selected;
    });
  }

  Color _seatBg(SeatStatus status) {
    switch (status) {
      case SeatStatus.selected:
        return amber;
      case SeatStatus.booked:
        return bookedColor;
      case SeatStatus.available:
        return cardColor;
    }
  }

  Color _seatTextColor(SeatStatus status) {
    switch (status) {
      case SeatStatus.selected:
        return const Color(0xFF3A2A00);
      case SeatStatus.booked:
        return bookedText;
      case SeatStatus.available:
        return const Color(0xFFD5D8DD);
    }
  }

  Widget _buildSeat(Seat seat, {double height = 40}) {
    final bg = _seatBg(seat.status);
    final textColor = _seatTextColor(seat.status);
    final isBooked = seat.status == SeatStatus.booked;

    return Expanded(
      child: GestureDetector(
        onTap: () => _toggleSeat(seat),
        child: Container(
          height: height,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
              bottomLeft: Radius.circular(4),
              bottomRight: Radius.circular(4),
            ),
            border: isBooked || seat.status == SeatStatus.selected
                ? null
                : Border.all(color: borderColor, width: 1),
          ),
          child: Text(
            seat.id,
            style: TextStyle(
              fontSize: 11,
              fontWeight: seat.status == SeatStatus.selected
                  ? FontWeight.w700
                  : FontWeight.w500,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSingleColumn(List<Seat> singles) {
    return Column(
      children: [
        for (int i = 0; i < singles.length; i++) ...[
          SizedBox(
            width: 40,
            child: Row(children: [_buildSeat(singles[i])]),
          ),
          if (i != singles.length - 1) const SizedBox(height: 12),
        ],
      ],
    );
  }

  Widget _buildDoubleColumn(List<List<Seat>> pairs) {
    return Column(
      children: [
        for (int i = 0; i < pairs.length; i++) ...[
          Row(
            children: [
              _buildSeat(pairs[i][0]),
              const SizedBox(width: 8),
              _buildSeat(pairs[i][1]),
            ],
          ),
          if (i != pairs.length - 1) const SizedBox(height: 12),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final singles = showLowerDeck ? lowerSingles : upperSingles;
    final doubles = showLowerDeck ? lowerDoublePairs : upperDoublePairs;
    final selected = _selectedSeats;
    final total = selected.length * widget.pricePerSeat;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            /// HEADER
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 10, 18, 6),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Select seats",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          "${widget.companyName} • ${widget.boardingCity} to ${widget.droppingCity}",
                          style: const TextStyle(color: muted, fontSize: 11),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            /// DECK TOGGLE
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 4),
              child: Row(
                children: [
                  _deckChip("Lower deck", showLowerDeck, () {
                    setState(() => showLowerDeck = true);
                  }),
                  const SizedBox(width: 8),
                  _deckChip("Upper deck", !showLowerDeck, () {
                    setState(() => showLowerDeck = false);
                  }),
                ],
              ),
            ),

            /// STEERING ICON
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 14, 0, 6),
              child: Icon(Icons.tour_rounded, color: Color(0xFF5A5F6A), size: 20),
            ),

            /// SEAT GRID
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSingleColumn(singles),
                    const SizedBox(width: 22),
                    Expanded(child: _buildDoubleColumn(doubles)),
                  ],
                ),
              ),
            ),

            /// LEGEND
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 10, 18, 6),
              child: Row(
                children: [
                  _legendItem(cardColor, "Available", bordered: true),
                  const SizedBox(width: 16),
                  _legendItem(amber, "Selected"),
                  const SizedBox(width: 16),
                  _legendItem(bookedColor, "Booked"),
                ],
              ),
            ),

            /// BOTTOM SUMMARY BAR
            Container(
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
              decoration: const BoxDecoration(
                color: Color(0xFF161A21),
                border: Border(top: BorderSide(color: borderColor, width: 0.6)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selected.isEmpty
                            ? "No seat selected"
                            : "${selected.length} seat${selected.length > 1 ? 's' : ''} • ${selected.map((s) => s.id).join(', ')}",
                        style: const TextStyle(color: muted, fontSize: 10.5),
                      ),
                      Text(
                        "₹$total",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(11),
                      onTap: selected.isEmpty
                          ? null
                          : () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (_) => Onboarddroppingpoint(
                            travelsid: widget.travelsid,
                            travelscompanyname: widget.companyName,
                            boardingcity: widget.boardingCity,
                            droppingcity: widget.droppingCity,
                            pricePerSeat: widget.pricePerSeat,
                            selectedSeats: selected.map((s) => s.id).toList(),

                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                        decoration: BoxDecoration(
                          color: selected.isEmpty ? borderColor : amber,
                          borderRadius: BorderRadius.circular(11),
                        ),
                        child: Text(
                          "Continue",
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: selected.isEmpty ? muted : const Color(0xFF2A1E00),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _deckChip(String label, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? amber : cardColor,
          borderRadius: BorderRadius.circular(20),
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

  Widget _legendItem(Color color, String label, {bool bordered = false}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 11,
          height: 11,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
            border: bordered ? Border.all(color: borderColor) : null,
          ),
        ),
        const SizedBox(width: 5),
        Text(label, style: const TextStyle(color: muted, fontSize: 10.5)),
      ],
    );
  }
}