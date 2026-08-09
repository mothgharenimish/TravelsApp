import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travelsbookingapp/bloc/boardingpointbloc/boardingpointbloc.dart';
import 'package:travelsbookingapp/bloc/bookingcubit/bookincubit.dart';
import 'package:travelsbookingapp/bloc/dropingpointbloc/dropingpointbloc.dart';
import 'package:travelsbookingapp/model/boardingpointmodel.dart';
import 'package:travelsbookingapp/model/currentuser.dart';
import 'package:travelsbookingapp/model/dropingpointmodel.dart';
import 'package:travelsbookingapp/screens/ticketscreen/ticketscreen.dart';

const Color _sheetColor = Color(0xFF161A21);
const Color _cardColor = Color(0xFF1C2028);
const Color _borderColor = Color(0xFF262B35);
const Color _amber = Color(0xFFE8B84B);
const Color _muted = Color(0xFF9AA0AA);
const Color _errorColor = Color(0xFFE8746B);

class Onboarddroppingpoint extends StatefulWidget {
  final String travelsid;
  final String travelscompanyname;
  final String boardingcity;
  final String droppingcity;
  final int pricePerSeat;
  final List<String> selectedSeats;

  const Onboarddroppingpoint({
    super.key,
    required this.travelsid,
    required this.travelscompanyname,
    required this.boardingcity,
    required this.droppingcity,
    required this.pricePerSeat,
    required this.selectedSeats,
  });

  @override
  State<Onboarddroppingpoint> createState() => _OnboarddroppingpointState();
}

class _OnboarddroppingpointState extends State<Onboarddroppingpoint> {
  final BoardingCubit boardingCubit = BoardingCubit();
  final DroppingCubit droppingCubit = DroppingCubit();

  BoardingPoint? selectedBoarding;
  DroppingPoint? selectedDropping;

  @override
  void initState() {
    super.initState();
    boardingCubit.BoardingGetAPI();
    droppingCubit.DroppingGetAPI();
  }

  @override
  void dispose() {
    boardingCubit.close();
    droppingCubit.close();
    super.dispose();
  }

  Widget _pointTile({
    required String name,
    required String time,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: _cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? _amber : _borderColor,
            width: selected ? 1.4 : 1,
          ),
        ),
        child: Row(
          children: [
            const Icon(Icons.location_on_outlined, color: _muted, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(time, style: const TextStyle(color: _muted, fontSize: 11.5)),
                ],
              ),
            ),
            Container(
              height: 18,
              width: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? _amber : Colors.transparent,
                border: Border.all(color: selected ? _amber : _muted, width: 1.4),
              ),
              child: selected
                  ? const Icon(Icons.check, size: 12, color: Color(0xFF2A1E00))
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title, String city) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 6),
          Text("in $city", style: const TextStyle(color: _muted, fontSize: 12)),
        ],
      ),
    );
  }

  Future<void> _handleContinue() async {
    if (selectedBoarding == null || selectedDropping == null) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => _PassengerDetailsDialog(
        seatNumbers: widget.selectedSeats,
        travelsid: widget.travelsid,
        travelscompanyname: widget.travelscompanyname,
        boardingcity: widget.boardingcity,
        droppingcity: widget.droppingcity,
        boardingpoint: selectedBoarding!.boardingpoint,
        boardingtime: selectedBoarding!.time,
        droppingpoint: selectedDropping!.droppingpoint,
        droppingtime: selectedDropping!.time,
        price: widget.pricePerSeat,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: boardingCubit),
        BlocProvider.value(value: droppingCubit),
      ],
      child: DraggableScrollableSheet(
        initialChildSize: 0.75,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: _sheetColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Container(
                  height: 4,
                  width: 40,
                  decoration: BoxDecoration(
                    color: _borderColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 14, 10, 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Boarding & dropping points",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close_rounded, color: _muted, size: 20),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.fromLTRB(18, 4, 18, 4),
                    children: [
                      _sectionTitle("Boarding point", widget.boardingcity),
                      BlocBuilder<BoardingCubit, List<BoardingData>>(
                        builder: (context, boardingList) {
                          final matches = boardingList.where(
                                (d) =>
                            d.travelsid == widget.travelsid &&
                                d.city == widget.boardingcity,
                          );
                          final points = matches.expand((d) => d.boardingpoints).toList();

                          if (boardingList.isEmpty) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: _amber,
                                  strokeWidth: 2.4,
                                ),
                              ),
                            );
                          }

                          if (points.isEmpty) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                "No boarding points available",
                                style: TextStyle(color: _muted, fontSize: 12.5),
                              ),
                            );
                          }

                          return Column(
                            children: points.map((point) {
                              final selected =
                                  selectedBoarding?.boardingpoint == point.boardingpoint;
                              return _pointTile(
                                name: point.boardingpoint,
                                time: point.time,
                                selected: selected,
                                onTap: () => setState(() => selectedBoarding = point),
                              );
                            }).toList(),
                          );
                        },
                      ),
                      const SizedBox(height: 18),
                      _sectionTitle("Dropping point", widget.droppingcity),
                      BlocBuilder<DroppingCubit, List<DroppingData>>(
                        builder: (context, droppingList) {
                          final matches = droppingList.where(
                                (d) =>
                            d.travelsid == widget.travelsid &&
                                d.city == widget.droppingcity,
                          );
                          final points = matches.expand((d) => d.droppingpoints).toList();

                          if (droppingList.isEmpty) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: _amber,
                                  strokeWidth: 2.4,
                                ),
                              ),
                            );
                          }

                          if (points.isEmpty) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                "No dropping points available",
                                style: TextStyle(color: _muted, fontSize: 12.5),
                              ),
                            );
                          }

                          return Column(
                            children: points.map((point) {
                              final selected =
                                  selectedDropping?.droppingpoint == point.droppingpoint;
                              return _pointTile(
                                name: point.droppingpoint,
                                time: point.time,
                                selected: selected,
                                onTap: () => setState(() => selectedDropping = point),
                              );
                            }).toList(),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),

                /// CONTINUE BAR
                Container(
                  padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
                  decoration: const BoxDecoration(
                    border: Border(top: BorderSide(color: _borderColor, width: 0.6)),
                  ),
                  child: SizedBox(
                    height: 48,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: (selectedBoarding == null || selectedDropping == null)
                          ? null
                          : _handleContinue,
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: _amber,
                        disabledBackgroundColor: _amber.withOpacity(0.4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Continue",
                        style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF2A1E00),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Dialog that collects one passenger (name + gender) per selected seat,
/// books the trip directly via BookingCubit, and on success navigates to
/// TicketScreen — replacing this dialog and the boarding/dropping sheet.
class _PassengerDetailsDialog extends StatefulWidget {
  final List<String> seatNumbers;
  final String travelsid;
  final String travelscompanyname;
  final String boardingcity;
  final String droppingcity;
  final String boardingpoint;
  final String boardingtime;
  final String droppingpoint;
  final String droppingtime;
  final int price;

  const _PassengerDetailsDialog({
    required this.seatNumbers,
    required this.travelsid,
    required this.travelscompanyname,
    required this.boardingcity,
    required this.droppingcity,
    required this.boardingpoint,
    required this.boardingtime,
    required this.droppingpoint,
    required this.droppingtime,
    required this.price,
  });

  @override
  State<_PassengerDetailsDialog> createState() => _PassengerDetailsDialogState();
}

class _PassengerDetailsDialogState extends State<_PassengerDetailsDialog> {
  late List<TextEditingController> nameControllers;
  late List<String> genders;
  String? errorText;
  bool isBooking = false;

  final BookingCubit bookingCubit = BookingCubit();

  @override
  void initState() {
    super.initState();
    nameControllers = widget.seatNumbers.map((_) => TextEditingController()).toList();
    genders = widget.seatNumbers.map((_) => "Male").toList();
  }

  @override
  void dispose() {
    for (final c in nameControllers) {
      c.dispose();
    }
    bookingCubit.close();
    super.dispose();
  }

  Widget _genderChip(int index, String label) {
    final selected = genders[index] == label;
    return GestureDetector(
      onTap: isBooking ? null : () => setState(() => genders[index] = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? _amber : _sheetColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? _amber : _borderColor),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: selected ? const Color(0xFF2A1E00) : _muted,
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    for (final c in nameControllers) {
      if (c.text.trim().isEmpty) {
        setState(() => errorText = "Please enter a name for every passenger");
        return;
      }
    }

    setState(() {
      errorText = null;
      isBooking = true;
    });

    final passengers = List.generate(widget.seatNumbers.length, (i) {
      return {
        "name": nameControllers[i].text.trim(),
        "gender": genders[i],
        "seatnumber": widget.seatNumbers[i],
      };
    });

    await bookingCubit.BookingApi(
      travelsid: widget.travelsid,
      userid: CurrentUser.userid,
      emailid: CurrentUser.emailid,
      mobilenumber: CurrentUser.mobilenumber,
      boardingcity: widget.boardingcity,
      droppingcity: widget.droppingcity,
      boardingpoint: widget.boardingpoint,
      droppingpoint: widget.droppingpoint,
      price: widget.price,
      passengers: passengers,
    );

    if (!mounted) return;

    if (bookingCubit.state == true) {
      final details = bookingCubit.bookingdetails ?? {};
      final navigator = Navigator.of(context);
      navigator.pop(); // close this dialog
      navigator.pop(); // close the boarding/dropping bottom sheet
      navigator.pushReplacement(
        MaterialPageRoute(
          builder: (_) => TicketScreen(
            companyName: details["travelscompanyname"]?.toString() ?? widget.travelscompanyname,
            boardingCity: details["boardingcity"]?.toString() ?? widget.boardingcity,
            droppingCity: details["droppingcity"]?.toString() ?? widget.droppingcity,
            boardingPoint: details["boardingpoint"]?.toString() ?? widget.boardingpoint,
            boardingTime: widget.boardingtime,
            droppingPoint: details["droppingpoint"]?.toString() ?? widget.droppingpoint,
            droppingTime: widget.droppingtime,
            date: details["date"]?.toString() ?? "",
            bookingId: details["bookingid"]?.toString() ?? "",
            totalPrice: details["totalprice"] ?? widget.price,
            passengers: List<Map<String, dynamic>>.from(details["passengers"] ?? []),
          ),
        ),
      );
    }else {
      setState(() {
        isBooking = false;
        errorText = bookingCubit.errormessage.isNotEmpty
            ? bookingCubit.errormessage
            : "Booking failed. Please try again.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: _cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 520),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Passenger details",
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Text(
                "${widget.seatNumbers.length} seat${widget.seatNumbers.length > 1 ? 's' : ''} selected",
                style: const TextStyle(color: _muted, fontSize: 12),
              ),
              const SizedBox(height: 16),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    children: List.generate(widget.seatNumbers.length, (i) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Seat ${widget.seatNumbers[i]}",
                              style: const TextStyle(color: _amber, fontSize: 12.5, fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 6),
                            TextField(
                              controller: nameControllers[i],
                              enabled: !isBooking,
                              style: const TextStyle(color: Colors.white, fontSize: 14),
                              decoration: InputDecoration(
                                hintText: "Passenger name",
                                hintStyle: const TextStyle(color: _muted, fontSize: 13),
                                filled: true,
                                fillColor: _sheetColor,
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(color: _borderColor),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(color: _borderColor),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(color: _amber, width: 1.3),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                _genderChip(i, "Male"),
                                const SizedBox(width: 8),
                                _genderChip(i, "Female"),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              ),
              if (errorText != null) ...[
                const SizedBox(height: 6),
                Text(errorText!, style: const TextStyle(color: _errorColor, fontSize: 12)),
              ],
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: isBooking ? null : () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: _borderColor),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text("Cancel", style: TextStyle(color: _muted)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: isBooking ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: _amber,
                        disabledBackgroundColor: _amber.withOpacity(0.5),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: isBooking
                          ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2.2, color: Color(0xFF2A1E00)),
                      )
                          : const Text(
                        "Book now",
                        style: TextStyle(color: Color(0xFF2A1E00), fontWeight: FontWeight.w700),
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
  }
}