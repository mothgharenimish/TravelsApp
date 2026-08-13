import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travelsbookingapp/bloc/LocationBloc/locationbloc.dart';
import 'package:travelsbookingapp/bloc/travelsbloc/travelsapibloc.dart';
import 'package:travelsbookingapp/bloc/travelsbloc/travelsapistate.dart';
import 'package:travelsbookingapp/model/currentuser.dart';
import 'package:travelsbookingapp/model/travelsmodel.dart';
import 'package:travelsbookingapp/screens/Home/travelscard.dart';
import 'package:travelsbookingapp/screens/seatSelection/SeatSelection.dart';
import 'searchcard.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController fromController = TextEditingController();
  final TextEditingController toController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  final FocusNode fromFocusNode = FocusNode();
  final FocusNode toFocusNode = FocusNode();

  // sortedTravels = full dataset from the API (sorted by date desc).
  // filteredTravels = what's actually shown, after From/To/Date filtering.
  List<TravelsData> sortedTravels = [];
  List<TravelsData> filteredTravels = [];
  List<TravelsData> pastTravels = [];
  List<TravelsData> upcomingTravels = [];

  bool isLoading = true;
  int selectedFilter = 0;
  int selectedNav = 0;

  static const Color bgColor = Color(0xFF0E1116);
  static const Color cardColor = Color(0xFF1C2028);
  static const Color borderColor = Color(0xFF262B35);
  static const Color amber = Color(0xFFE8B84B);
  static const Color muted = Color(0xFF9AA0AA);

  // final TravelsCubit _travelsCubit = TravelsCubit();
  // final LocationCubit _locationCubit = LocationCubit();

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

  @override
  void dispose() {
    fromController.dispose();
    toController.dispose();
    dateController.dispose();
    fromFocusNode.dispose();
    toFocusNode.dispose();
    super.dispose();
  }

  DateTime parseDate(String date) {
    List<String> parts = date.split('-');
    return DateTime(
      int.parse(parts[2]),
      int.parse(parts[1]),
      int.parse(parts[0]),
    );
  }

  Future<void> _onRefresh() async {
    final travelsCubit = context.read<TravelsCubit>();
    final locationCubit = context.read<LocationCubit>();

    travelsCubit.TravelGetAPI();
    locationCubit.getCurrentLocationAndSave();

    try {
      await Future.wait([
        travelsCubit.stream.first.timeout(const Duration(seconds: 10)),
        locationCubit.stream.first.timeout(const Duration(seconds: 10)),
      ]);
    } catch (_) {
      // Timed out or errored — RefreshIndicator still resolves below,
      // so the spinner just stops; any partial state already emitted
      // (e.g. travels succeeded but location timed out) is still shown.
    }
  }
  /// Splits [source] into past vs upcoming (today or later) buses using a
  /// plain loop. Sets pastTravels as a side effect and returns the
  /// upcoming list, which is what the Home screen should show by default.
  List<TravelsData> _splitPastAndUpcoming(List<TravelsData> source) {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day); // strip time

    List<TravelsData> past = [];
    List<TravelsData> upcoming = [];

    for (int i = 0; i < source.length; i++) {
      TravelsData travel = source[i];

      // Format is "d-M-yyyy" (day-month-year, not zero-padded), e.g. "8-05-2026".
      List<String> dateParts = travel.date.split('-');
      int day = int.parse(dateParts[0]);
      int month = int.parse(dateParts[1]);
      int year = int.parse(dateParts[2]);
      DateTime travelDate = DateTime(year, month, day);

      if (travelDate.isBefore(today)) {
        past.add(travel);
      } else {
        upcoming.add(travel);
      }
    }

    pastTravels = past;
    return upcoming;
  }

  /// Filters [source] by whatever is currently in the From/To/Date fields.
  /// Empty fields are ignored (match everything). Called both when fresh
  /// API data arrives and when the Search button is tapped.
  List<TravelsData> _applyFilters(List<TravelsData> source) {
    String fromQuery = fromController.text.trim().toLowerCase();
    String toQuery = toController.text.trim().toLowerCase();
    String dateQuery = dateController.text.trim();

    List<TravelsData> result = [];

    for (int i = 0; i < source.length; i++) {
      TravelsData travel = source[i];

      bool matchesFrom = true;
      if (fromQuery.isNotEmpty) {
        matchesFrom = travel.boardingcity.toLowerCase().contains(fromQuery);
      }

      bool matchesTo = true;
      if (toQuery.isNotEmpty) {
        matchesTo = travel.droppingcity.toLowerCase().contains(toQuery);
      }

      bool matchesDate = true;
      if (dateQuery.isNotEmpty) {
        // dateQuery is "yyyy-MM-dd" (from the date picker).
        // travel.date is "d-M-yyyy" (from the API) — normalize both to compare.
        List<String> travelParts = travel.date.split('-');
        String normalizedTravelDate =
            "${travelParts[2]}-${travelParts[1].padLeft(2, '0')}-${travelParts[0].padLeft(2, '0')}";
        matchesDate = normalizedTravelDate == dateQuery;
      }

      if (matchesFrom && matchesTo && matchesDate) {
        result.add(travel);
      }
    }

    return result;
  }

  /// Moves entries whose boardingcity matches [currentCity] to the front,
  /// preserving the relative order within both groups. Same partition-then
  /// -concat approach as the original ArrangingElements example: collect
  /// matches in a pass, strip them out of a copy of the source, then
  /// concatenate matches + rest.
  List<TravelsData> _prioritizeCurrentCity(
      List<TravelsData> source, String? currentCity) {
    if (currentCity == null || currentCity.trim().isEmpty) {
      return source;
    }

    final String target = currentCity.trim().toLowerCase();
    List<TravelsData> matched = [];

    for (int i = 0; i < source.length; i++) {
      if (source[i].boardingcity.trim().toLowerCase() == target) {
        matched.add(source[i]);
      }
    }

    List<TravelsData> rest = List.from(source);
    rest.removeWhere((t) => t.boardingcity.trim().toLowerCase() == target);

    return matched + rest;
  }

  void _searchBuses() {
    FocusScope.of(context).unfocus();

    setState(() {
      filteredTravels = _applyFilters(upcomingTravels);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: cardColor,
        content: Text(
          filteredTravels.isEmpty
              ? "No buses found for this route/date"
              : "Found ${filteredTravels.length} bus(es)",
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Future<void> _swapLocations() async {
    // Force both fields to fully release the keyboard/IME before we touch
    // the controllers — matters especially when swapping to/from empty.
    fromFocusNode.unfocus();
    toFocusNode.unfocus();
    FocusManager.instance.primaryFocus?.unfocus();

    await Future.delayed(const Duration(milliseconds: 50));
    if (!mounted) return;

    final fromText = fromController.text;
    final toText = toController.text;

    setState(() {
      fromController.value = TextEditingValue(
        text: toText,
        selection: TextSelection.collapsed(offset: toText.length),
      );
      toController.value = TextEditingValue(
        text: fromText,
        selection: TextSelection.collapsed(offset: fromText.length),
      );
    });
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
      dateController.text =
      "${picked.year.toString().padLeft(4, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      setState(() {});
    }
  }

  String get _greeting {
    final hour = DateTime.now().hour;
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

        upcomingTravels = _splitPastAndUpcoming(sortedTravels);
        print("The Upcoming Travels $upcomingTravels");
        filteredTravels = _applyFilters(upcomingTravels);

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
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 21,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Current city, read live from LocationCubit.
                        BlocBuilder<LocationCubit, String?>(
                          builder: (context, city) {
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  size: 13,
                                  color: city != null ? amber : muted,
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  city ?? "Location off",
                                  style: TextStyle(
                                    color: city != null ? amber : muted,
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            );
                          },
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
                  fromcontroller: fromController,
                  tocontroller: toController,
                  datecontroller: dateController,
                  fromfocusnode: fromFocusNode,
                  toFocusNode: toFocusNode,
                  onSwapTap: _swapLocations,
                  onDateTap: _pickDate,
                  searchbusTap: _searchBuses,
                ),
              ),

              const SizedBox(height: 8),

              Padding(
                padding: const EdgeInsets.fromLTRB(18, 10, 18, 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "${filteredTravels.length} buses found",
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
                    : filteredTravels.isEmpty
                    ? _EmptyState(muted: muted)
                    : BlocBuilder<LocationCubit, String?>(
                  // Re-sorts (current-city-first) whenever location changes,
                  // without needing a full setState from the parent.
                  builder: (context, city) {
                    final List<TravelsData> displayList =
                    _prioritizeCurrentCity(filteredTravels, city);

                    return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(18, 4, 18, 90),
                      itemCount: displayList.length,
                      itemBuilder: (context, index) {
                        final travelsdata = displayList[index];
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