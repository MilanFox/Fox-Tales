import 'package:flutter/material.dart';
import 'package:fox_tales/models/screen.dart';
import 'package:fox_tales/screens/home_screen.dart';
import 'package:fox_tales/screens/favorites_screen.dart';
import 'package:fox_tales/screens/messages_screen.dart';
import 'package:fox_tales/widgets/molecules/main_drawer.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() {
    return _MainNavigationState();
  }
}

class _MainNavigationState extends State<MainNavigation> {
  int _pageIndex = 0;

  final List<Screen> _screens = [
    Screen(
      icon: const Icon(Icons.auto_awesome_mosaic),
      label: "Feed",
      screen: const HomeScreen(),
    ),
    Screen(
      icon: const Icon(Icons.star),
      label: "Favorites",
      screen: const FavoritesScreen(),
    ),
    Screen(
      icon: const Icon(Icons.inbox),
      label: "Messages",
      screen: const MessagesScreen(),
    ),
  ];

  void _selectPage(int index) {
    setState(() {
      _pageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'FoxTales',
          style: TextStyle(fontFamily: 'Tahu', fontSize: 40),
        ),
        backgroundColor: Colors.white,
      ),
      drawer: const MainDrawer(),
      body: _screens[_pageIndex].screen,
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _pageIndex,
        onTap: _selectPage,
        items: _screens
            .map((screen) => BottomNavigationBarItem(
                  icon: screen.icon,
                  label: screen.label,
                ))
            .toList(),
      ),
    );
  }
}