import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travelsbookingapp/bloc/loginbloc/loginbloc.dart';
import 'package:travelsbookingapp/screens/Home/home.dart';
import 'package:travelsbookingapp/screens/bottomnavigation/mainNavigation.dart';
import 'package:travelsbookingapp/screens/login/login.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with TickerProviderStateMixin {
  static const Color bgColor = Color(0xFF0E1116);
  static const Color cardColor = Color(0xFF1C2028);
  static const Color borderColor = Color(0xFF262B35);
  static const Color amber = Color(0xFFE8B84B);
  static const Color muted = Color(0xFF9AA0AA);
  static const Color faint = Color(0xFF5A5F6A);

  static const Duration _minSplashDuration = Duration(milliseconds: 3000);

  late final AnimationController _entrance;
  late final AnimationController _pulse;
  late final AnimationController _progress;

  late final Animation<Offset> _busSlide;
  late final Animation<double> _busFade;
  late final Animation<Offset> _nameSlide;
  late final Animation<double> _nameFade;
  late final Animation<double> _taglineFade;

  @override
  void initState() {
    super.initState();

    _entrance = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    );

    _busSlide = Tween<Offset>(begin: const Offset(-1.6, 0), end: Offset.zero)
        .animate(CurvedAnimation(
      parent: _entrance,
      curve: const Interval(0.0, 0.55, curve: Curves.easeOutBack),
    ));

    _busFade = CurvedAnimation(
      parent: _entrance,
      curve: const Interval(0.0, 0.35, curve: Curves.easeOut),
    );

    _nameSlide = Tween<Offset>(begin: const Offset(0, 0.4), end: Offset.zero)
        .animate(CurvedAnimation(
      parent: _entrance,
      curve: const Interval(0.45, 0.75, curve: Curves.easeOut),
    ));

    _nameFade = CurvedAnimation(
      parent: _entrance,
      curve: const Interval(0.45, 0.75, curve: Curves.easeOut),
    );

    _taglineFade = CurvedAnimation(
      parent: _entrance,
      curve: const Interval(0.65, 1.0, curve: Curves.easeOut),
    );

    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1700),
    )..repeat();

    _progress = AnimationController(
      vsync: this,
      duration: _minSplashDuration,
    )..forward();

    _entrance.forward();
    _decideNavigation();
  }

  @override
  void dispose() {
    _entrance.dispose();
    _pulse.dispose();
    _progress.dispose();
    super.dispose();
  }

  /// Waits for BOTH the minimum splash duration AND the login-status check
  /// to finish, then navigates exactly once — a single navigation decision,
  /// never two competing ones.
  Future<void> _decideNavigation() async {
    final results = await Future.wait([
      Future.delayed(_minSplashDuration),
      context.read<LoginCubit>().checkLogin(),
    ]);

    final isLogin = results[1] as bool;

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => isLogin ? MainNavigation() : Login()),
    );
  }

  Widget _dash() => Container(
    width: 5,
    height: 2,
    decoration: BoxDecoration(
      color: faint.withOpacity(0.5),
      borderRadius: BorderRadius.circular(2),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// PULSING RADAR RING + BUS BADGE
                    SizedBox(
                      height: 120,
                      width: 120,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          AnimatedBuilder(
                            animation: _pulse,
                            builder: (context, child) {
                              final t = _pulse.value;
                              return Opacity(
                                opacity: (1 - t).clamp(0.0, 1.0) * 0.35,
                                child: Transform.scale(
                                  scale: 1.0 + t * 0.6,
                                  child: Container(
                                    height: 96,
                                    width: 96,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: amber, width: 1.4),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          FadeTransition(
                            opacity: _busFade,
                            child: SlideTransition(
                              position: _busSlide,
                              child: Container(
                                height: 88,
                                width: 88,
                                decoration: BoxDecoration(
                                  color: cardColor,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: borderColor, width: 1),
                                  boxShadow: [
                                    BoxShadow(
                                      color: amber.withOpacity(0.18),
                                      blurRadius: 26,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.directions_bus_filled_rounded,
                                  color: amber,
                                  size: 42,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    /// DASHED "ROAD" UNDER THE BUS
                    FadeTransition(
                      opacity: _busFade,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(9, (_) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3),
                          child: _dash(),
                        )),
                      ),
                    ),

                    const SizedBox(height: 26),

                    FadeTransition(
                      opacity: _nameFade,
                      child: SlideTransition(
                        position: _nameSlide,
                        child: const Text(
                          "TravelGo",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 6),

                    FadeTransition(
                      opacity: _taglineFade,
                      child: const Text(
                        "Book your journey, hassle-free",
                        style: TextStyle(color: muted, fontSize: 12.5),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// PROGRESS BAR + STATUS TEXT
            Padding(
              padding: const EdgeInsets.fromLTRB(48, 0, 48, 44),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: SizedBox(
                      height: 4,
                      child: AnimatedBuilder(
                        animation: _progress,
                        builder: (context, child) {
                          return LinearProgressIndicator(
                            value: _progress.value,
                            backgroundColor: borderColor,
                            valueColor: const AlwaysStoppedAnimation<Color>(amber),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Checking your session...",
                    style: TextStyle(color: faint, fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}