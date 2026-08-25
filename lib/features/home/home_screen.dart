import 'package:easy_localization/easy_localization.dart';
import 'package:evently_app/features/home/tabs/fav_tab.dart';
import 'package:evently_app/features/home/tabs/home_tab.dart';
import 'package:evently_app/features/home/tabs/profile_tab.dart';
import 'package:flutter/material.dart';
import '../add_event/add_event_screen.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({super.key});
  static const String routeName = 'home_screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).primaryColor;
    return Scaffold(
      body: SafeArea(child: tabs[currentIndex]),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withValues(alpha: 0.4),
              blurRadius: 12,
              spreadRadius: 2,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () async {
            await Navigator.pushNamed(context, AddEventScreen.routeName);
            setState(() {});
          },
          backgroundColor: primaryColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          child: const Icon(Icons.add, color: Colors.white),

        ),
      ),
        bottomNavigationBar: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (value) {
              currentIndex = value;
              setState(() {});
            },
            backgroundColor: isDark ? const Color(0xff001440) : Colors.white,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: isDark ? const Color(0xFF5687F0) : primaryColor,
            unselectedItemColor: isDark ? Colors.white70 : const Color(0xff686868),
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.home_outlined),
                activeIcon: const Icon(Icons.home),
                label: "home".tr(),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.favorite_border),
                activeIcon: const Icon(Icons.favorite),
                label: "favorite".tr(),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.person_outline),
                activeIcon: const Icon(Icons.person),
                label: "profile".tr(),
              ),
            ],
          ),
        )
    );
  }
  List<Widget> get tabs => [HomeTab(), FavTab(), ProfileTab()];
}
