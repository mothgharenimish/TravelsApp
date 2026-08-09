import 'package:flutter/material.dart';
import 'package:travelsbookingapp/screens/Home/home.dart';
import 'package:travelsbookingapp/screens/history/historyscreen.dart';
import 'package:travelsbookingapp/screens/setting/settingscreen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  static const Color bgColor = Color(0xFF0E1116);
  static const Color barColor = Color(0xFF161A21);
  static const Color borderColor = Color(0xFF262B35);

  int _selectedIndex = 0;

  final List<Widget> _screens = [
    Home(),
    const HistoryScreen(),
    const SettingsScreen(),
  ];

  void _onTabTapped(int index) {
    if (index == _selectedIndex) return;
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: barColor,
          border: Border(top: BorderSide(color: borderColor, width: 0.6)),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: _SegmentedNavBar(
              selectedIndex: _selectedIndex,
              onTap: _onTabTapped,
              items: const [
                _NavItemData(icon: Icons.home_rounded, label: "Home"),
                _NavItemData(icon: Icons.history_rounded, label: "History"),
                _NavItemData(icon: Icons.settings_rounded, label: "Settings"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItemData {
  final IconData icon;
  final String label;
  const _NavItemData({required this.icon, required this.label});
}

/// Segmented-control style bottom nav: a solid amber fill slides between
/// three equal-width segments, each always showing icon + label.
class _SegmentedNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;
  final List<_NavItemData> items;

  static const Color trackColor = Color(0xFF1C2028);
  static const Color amber = Color(0xFFE8B84B);
  static const Color muted = Color(0xFF9AA0AA);
  static const Color onAmber = Color(0xFF2A1E00);

  const _SegmentedNavBar({
    required this.selectedIndex,
    required this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: trackColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeOutCubic,
            alignment: Alignment(
              -1 + (2 / (items.length - 1)) * selectedIndex,
              0,
            ),
            child: FractionallySizedBox(
              widthFactor: 1 / items.length,
              heightFactor: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: amber,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Row(
            children: List.generate(items.length, (index) {
              final selected = index == selectedIndex;
              final item = items[index];
              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onTap(index),
                  child: TweenAnimationBuilder<Color?>(
                    tween: ColorTween(end: selected ? onAmber : muted),
                    duration: const Duration(milliseconds: 220),
                    builder: (context, color, child) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(item.icon, color: color, size: 18),
                            const SizedBox(height: 2),
                            Text(
                              item.label,
                              style: TextStyle(
                                color: color,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}