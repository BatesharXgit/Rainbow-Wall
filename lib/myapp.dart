import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:luca/pages/dynamic/live.dart';
import 'package:luca/pages/favourite.dart';
import 'package:luca/pages/homepage.dart';
import 'package:luca/pages/dynamic/live_category.dart';
import 'package:luca/pages/static/wallpapers.dart';
import 'package:luca/themes/themes.dart';

class LucaHome extends StatefulWidget {
  const LucaHome({super.key, required this.title});
  final String title;

  @override
  State<LucaHome> createState() => _LucaHomeState();
}

class _LucaHomeState extends State<LucaHome> {
  int _selectedIndex = 0;
  final colour = Colors.white;
  final List<Widget> _pages = [
    const MyHomePage(
      title: 'Luca Home',
    ),
    const Category(
      title: 'Category',
    ),
    const LiveWallCategory(),
    // FavouritePage(),
    // LiveWallpaperPage(),
    FavoriteImagesPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      themeMode: ThemeMode.system,
      theme: lightTheme,
      darkTheme: darkTheme,
      title: 'Luca',
      home: Scaffold(
        body: _pages[_selectedIndex],
        bottomNavigationBar: SizedBox(
          height: 64,
          child: FlashyTabBar(
            backgroundColor: const Color(0xFF131321),
            animationCurve: Curves.linear,
            selectedIndex: _selectedIndex,
            iconSize: 24,
            // showElevation: false,
            onItemSelected: (index) => setState(() {
              _selectedIndex = index;
            }),
            items: [
              FlashyTabBarItem(
                activeColor: Colors.white,
                inactiveColor: Colors.grey,
                icon: const Icon(Iconsax.home_2),
                title: const Text('Home'),
              ),
              FlashyTabBarItem(
                activeColor: Colors.white,
                inactiveColor: Colors.grey,
                icon: const Icon(
                  Iconsax.image4,
                  size: 25,
                ),
                title: const Text('Category'),
              ),
              FlashyTabBarItem(
                activeColor: Colors.white,
                inactiveColor: Colors.grey,
                icon: const Icon(
                  Iconsax.video_circle,
                  size: 25,
                ),
                title: const Text('Live'),
              ),
              FlashyTabBarItem(
                activeColor: Colors.white,
                inactiveColor: Colors.grey,
                icon: const Icon(
                  Iconsax.heart,
                  size: 25,
                ),
                title: const Text('Favourites'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
