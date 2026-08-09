import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travelsbookingapp/bloc/travelsbloc/travelsapibloc.dart';
import 'package:travelsbookingapp/bloc/travelsbloc/travelsapistate.dart';
import 'package:travelsbookingapp/model/currentuser.dart';
import 'package:travelsbookingapp/model/travelsmodel.dart';
import 'package:travelsbookingapp/screens/Home/travelscard.dart';
import 'package:travelsbookingapp/screens/seatSelection/SeatSelection.dart';
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
  bool isLoading = true;
  int selectedFilter = 0;
  int selectedNav = 0;

  static const Color bgColor = Color(0xFF0E1116);
  static const Color cardColor = Color(0xFF1C2028);
  static const Color borderColor = Color(0xFF262B35);
  static const Color amber = Color(0xFFE8B84B);
  static const Color muted = Color(0xFF9AA0AA);

  final List<String> filters = ["All routes", "AC sleeper", "Seater"];
  final List<IconData> navIcons = [
    Icons.home_rounded,
    Icons.confirmation_number_outlined,
    Icons.location_on_outlined,
    Icons.person_outline_rounded,
  ];

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

  void _swapLocations() {
    final temp = widget.fromController.text;
    widget.fromController.text = widget.toController.text;
    widget.toController.text = temp;
    setState(() {});
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 180)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: amber,
              onPrimary: Colors.black,
              surface: cardColor,
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: bgColor,
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      widget.dateController.text =
      "${picked.year.toString().padLeft(4, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      setState(() {});
    }
  }

  String get _greeting {
    final hour = DateTime.now().hour;
    print(hour);
    if (hour < 12) return "GOOD MORNING";
    if (hour < 17) return "GOOD AFTERNOON";
    return "GOOD EVENING";
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
        setState(() => isLoading = false);
      },
      child: Scaffold(
        backgroundColor: bgColor,
        body: SafeArea(
          child: Column(
            children: [
              /// HEADER
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 14, 18, 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _greeting,
                          style: const TextStyle(
                            color: muted,
                            fontSize: 11,
                            letterSpacing: 0.6,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                         Text(
                          CurrentUser.name,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 21,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 38,
                      width: 38,
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: const Icon(
                        Icons.notifications_none_rounded,
                        color: amber,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Searchcard(
                  fromcontroller: widget.fromController,
                  tocontroller: widget.toController,
                  datecontroller: widget.dateController,
                  onSwapTap: _swapLocations,
                  onDateTap: _pickDate,
                  searchbusTap: () {
                    FocusScope.of(context).unfocus();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: cardColor,
                        content: const Text(
                          "Searching buses for your route...",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 8),

              /// RESULTS HEADER
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 10, 18, 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "${sortedTravels.length} buses found",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          "Sort",
                          style: TextStyle(fontSize: 12, color: muted),
                        ),
                        const SizedBox(width: 2),
                        Icon(Icons.keyboard_arrow_down_rounded,
                            size: 16, color: muted),
                      ],
                    ),
                  ],
                ),
              ),

              /// LIST
              Expanded(
                child: isLoading
                    ? const Center(
                  child: CircularProgressIndicator(color: amber),
                )
                    : sortedTravels.isEmpty
                    ? _EmptyState(muted: muted)
                    : ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(18, 4, 18, 90),
                  itemCount: sortedTravels.length,
                  itemBuilder: (context, index) {
                    final travelsdata = sortedTravels[index];
                    return Travelscard(
                      travelsdata: travelsdata,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SeatSelection(
                              travelsid: travelsdata.travelsid,
                              companyName: travelsdata.travelscompanyname,
                              boardingCity: travelsdata.boardingcity,
                              droppingCity: travelsdata.droppingcity,
                              pricePerSeat: travelsdata.price,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),


      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final Color muted;
  const _EmptyState({required this.muted});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.directions_bus_filled_outlined, size: 60, color: muted),
          const SizedBox(height: 12),
          Text(
            "No buses found",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Try adjusting your search",
            style: TextStyle(fontSize: 12, color: muted),
          ),
        ],
      ),
    );
  }
}