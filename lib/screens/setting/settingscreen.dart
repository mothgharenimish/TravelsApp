import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travelsbookingapp/bloc/LocationBloc/locationbloc.dart';
import 'package:travelsbookingapp/bloc/bookinghistorybloc/bookinghistorybloc.dart';
import 'package:travelsbookingapp/model/bookinghistorymodel.dart';
import 'package:travelsbookingapp/model/currentuser.dart';
import 'package:travelsbookingapp/screens/login/login.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  static const Color bgColor = Color(0xFF0E1116);
  static const Color cardColor = Color(0xFF1C2028);
  static const Color borderColor = Color(0xFF262B35);
  static const Color amber = Color(0xFFE8B84B);
  static const Color muted = Color(0xFF9AA0AA);
  static const Color red = Color(0xFFE8746B);

  final Bookinghistorybloc _bloc = Bookinghistorybloc();

  // NOTE: No local LocationCubit() here. LocationCubit is provided once,
  // higher up the app (same instance Home reads via context.read), and
  // must be shared, not re-instantiated — otherwise toggling location
  // here updates a cubit nobody else is listening to, and Home never
  // sees the change. _bloc (Bookinghistorybloc) IS fine to own locally
  // since Home doesn't depend on it.

  bool pushNotifications = true;

  @override
  void initState() {
    super.initState();
    _bloc.BookingHistoryGetAPI();
    // No loadSavedState() call needed here — the shared LocationCubit
    // (read from context in build/callbacks below) already loaded its
    // saved state wherever it was created/provided.
  }

  @override
  void dispose() {
    _bloc.close();
    // Do NOT close the shared LocationCubit here — this screen doesn't
    // own it, and closing it would break every other screen (e.g. Home)
    // still listening to it.
    super.dispose();
  }

  DateTime? _parseDate(String? date) {
    if (date == null || date.isEmpty) return null;
    try {
      final parts = date.split('-');
      return DateTime(int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
    } catch (_) {
      return null;
    }
  }

  Map<String, int> _computeStats(List<BookingHistoryData> allBookings) {
    final myBookings = allBookings.where((b) => b.userid == CurrentUser.userid).toList();

    final upcoming = myBookings.where((b) {
      final date = _parseDate(b.date);
      return date != null && date.isAfter(DateTime.now());
    }).length;

    final cities = <String>{};
    for (final b in myBookings) {
      cities.add(b.droppingcity);
    }

    return {
      "trips": myBookings.length,
      "upcoming": upcoming,
      "cities": cities.length,
    };
  }

  Future<void> _logout() async {
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
                "Log out?",
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              const Text(
                "You'll need to sign in again to book or view your trips.",
                style: TextStyle(color: muted, fontSize: 12.5, height: 1.4),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: borderColor),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text("Stay signed in", style: TextStyle(color: muted)),
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
                        "Log out",
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

    if (confirmed != true || !mounted) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    CurrentUser.setUser(userid: "", name: "", emailid: "", mobilenumber: "");

    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => Login()),
          (route) => false,
    );
  }

  void _notImplemented(String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: cardColor,
        content: Text("$label is coming soon", style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      // Only provide _bloc here (screen-local data). LocationCubit is
      // NOT provided here — it's inherited from further up the tree,
      // shared with Home and everywhere else that needs live location.
      body: BlocProvider.value(
        value: _bloc,
        child: BlocBuilder<Bookinghistorybloc, List<BookingHistoryData>>(
          builder: (context, allBookings) {
            final stats = _computeStats(allBookings);

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ProfileHeader(
                    name: CurrentUser.name.isNotEmpty ? CurrentUser.name : "Guest",
                    email: CurrentUser.emailid.isNotEmpty ? CurrentUser.emailid : "-",
                    trips: stats["trips"]!,
                    upcoming: stats["upcoming"]!,
                    cities: stats["cities"]!,
                  ),

                  _sectionLabel("Account"),
                  _sectionCard([
                    _settingsRow(
                      icon: Icons.person_outline_rounded,
                      iconColor: amber,
                      label: "Edit profile",
                      trailing: Icon(Icons.chevron_right_rounded, color: muted, size: 18),
                      onTap: () => _notImplemented("Editing your profile"),
                    ),
                    _settingsRow(
                      icon: Icons.lock_outline_rounded,
                      iconColor: const Color(0xFF5FD08A),
                      label: "Change password",
                      trailing: Icon(Icons.chevron_right_rounded, color: muted, size: 18),
                      onTap: () => _notImplemented("Changing your password"),
                      showDivider: false,
                    ),
                  ]),

                  _sectionLabel("Preferences"),
                  _sectionCard([
                    _settingsRow(
                      icon: Icons.notifications_none_rounded,
                      iconColor: const Color(0xFF8B7AF0),
                      label: "Push notifications",
                      trailing: Switch(
                        value: pushNotifications,
                        activeColor: const Color(0xFF2A1E00),
                        activeTrackColor: amber,
                        inactiveThumbColor: muted,
                        inactiveTrackColor: borderColor,
                        onChanged: (value) => setState(() => pushNotifications = value),
                      ),
                    ),
                    _settingsRow(
                      icon: Icons.location_on_outlined,
                      iconColor: red,
                      label: "Location access",
                      // Reads the SAME LocationCubit instance Home reads,
                      // via the ancestor provider — not a screen-local one.
                      trailing: BlocBuilder<LocationCubit, String?>(
                        builder: (context, city) {
                          return Switch(
                            value: city != null,
                            activeColor: const Color(0xFF2A1E00),
                            activeTrackColor: amber,
                            inactiveThumbColor: muted,
                            inactiveTrackColor: borderColor,
                            onChanged: (value) async {
                              if (value) {
                                final city = await context
                                    .read<LocationCubit>()
                                    .getCurrentLocationAndSave();
                                if (city == null && mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: cardColor,
                                      content: Text(
                                        "Couldn't get your location. Check permissions.",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  );
                                }
                              } else {
                                await context.read<LocationCubit>().clearSavedCity();
                              }
                            },
                          );
                        },
                      ),
                      showDivider: false,
                    ),
                  ]),

                  _sectionLabel("Support"),
                  _sectionCard([
                    _settingsRow(
                      icon: Icons.help_outline_rounded,
                      iconColor: const Color(0xFF5DCAA5),
                      label: "Help center",
                      trailing: Icon(Icons.chevron_right_rounded, color: muted, size: 18),
                      onTap: () => _notImplemented("The help center"),
                    ),
                    _settingsRow(
                      icon: Icons.info_outline_rounded,
                      iconColor: muted,
                      label: "About",
                      trailing: const Text("v1.0.0", style: TextStyle(color: muted, fontSize: 11)),
                      showDivider: false,
                    ),
                  ]),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 6, 18, 24),
                    child: SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: _logout,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: red),
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text(
                          "Log out",
                          style: TextStyle(color: red, fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _sectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 8),
      child: Text(
        label,
        style: const TextStyle(color: muted, fontSize: 10.5, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _sectionCard(List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(children: children),
      ),
    );
  }

  Widget _settingsRow({
    required IconData icon,
    required Color iconColor,
    required String label,
    required Widget trailing,
    VoidCallback? onTap,
    bool showDivider = true,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Icon(icon, color: iconColor, size: 15),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(color: Color(0xFFD5D8DD), fontSize: 12.5),
                  ),
                ),
                trailing,
              ],
            ),
          ),
          if (showDivider)
            const Divider(height: 0.6, color: borderColor, indent: 14, endIndent: 14),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final String name;
  final String email;
  final int trips;
  final int upcoming;
  final int cities;

  const _ProfileHeader({
    required this.name,
    required this.email,
    required this.trips,
    required this.upcoming,
    required this.cities,
  });

  @override
  Widget build(BuildContext context) {
    final initial = name.isNotEmpty ? name[0].toUpperCase() : "U";

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 60, 18, 22),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF3A3591), Color(0xFF6C4FE0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 56,
                width: 56,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withOpacity(0.4), width: 1.5),
                ),
                alignment: Alignment.center,
                child: Text(
                  initial,
                  style: const TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      email,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.white.withOpacity(0.75), fontSize: 11.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              _statChip("$trips", "Total trips"),
              const SizedBox(width: 8),
              _statChip("$upcoming", "Upcoming"),
              const SizedBox(width: 8),
              _statChip("$cities", "Cities visited"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statChip(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 1),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 9.5),
            ),
          ],
        ),
      ),
    );
  }
}