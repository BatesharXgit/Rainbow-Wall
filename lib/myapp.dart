// import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:luca/pages/favourite.dart';
// import 'package:luca/pages/homepage.dart';
// import 'package:luca/pages/dynamic/live_category.dart';
// import 'package:luca/pages/static/wallpapers.dart';
// import 'package:luca/themes/themes.dart';

// class LucaHome extends StatefulWidget {
//   const LucaHome({
//     super.key,
//   });

//   @override
//   State<LucaHome> createState() => _LucaHomeState();
// }

// class _LucaHomeState extends State<LucaHome> {
//   int _selectedIndex = 0;
//   final colour = Colors.white;
//   final List<Widget> _pages = [
//     const MyHomePage(),
//     const Category(),
//     const LiveWallCategory(),
//     FavoriteImagesPage(),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       themeMode: ThemeMode.system,
//       theme: lightTheme,
//       darkTheme: darkTheme,
//       title: 'Luca',
//       home: Scaffold(
//         body: _pages[_selectedIndex],
//         bottomNavigationBar: SizedBox(
//           height: 64,
//           child: FlashyTabBar(
//             backgroundColor: const Color(0xFF131321),
//             animationCurve: Curves.linear,
//             selectedIndex: _selectedIndex,
//             iconSize: 24,
//             // showElevation: false,
//             onItemSelected: (index) => setState(() {
//               _selectedIndex = index;
//             }),
//             items: [
//               FlashyTabBarItem(
//                 activeColor: Colors.white,
//                 inactiveColor: Colors.grey,
//                 icon: const Icon(Iconsax.home_2),
//                 title: const Text('Home'),
//               ),
//               FlashyTabBarItem(
//                 activeColor: Colors.white,
//                 inactiveColor: Colors.grey,
//                 icon: const Icon(
//                   Iconsax.image4,
//                   size: 25,
//                 ),
//                 title: const Text('Category'),
//               ),
//               FlashyTabBarItem(
//                 activeColor: Colors.white,
//                 inactiveColor: Colors.grey,
//                 icon: const Icon(
//                   Iconsax.video_circle,
//                   size: 25,
//                 ),
//                 title: const Text('Live'),
//               ),
//               FlashyTabBarItem(
//                 activeColor: Colors.white,
//                 inactiveColor: Colors.grey,
//                 icon: const Icon(
//                   Iconsax.heart,
//                   size: 25,
//                 ),
//                 title: const Text('Favourites'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_floating_bottom_bar/flutter_floating_bottom_bar.dart';
import 'package:iconsax/iconsax.dart';
import 'package:luca/pages/dynamic/live_category.dart';
import 'package:luca/pages/favourite.dart';
import 'package:luca/pages/homepage.dart';
import 'package:luca/pages/static/wallpapers.dart';

class LucaHome extends StatefulWidget {
  const LucaHome({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _LucaHomeState createState() => _LucaHomeState();
}

class _LucaHomeState extends State<LucaHome>
    with SingleTickerProviderStateMixin {
  late int currentPage;
  late TabController tabController;
  // final List<Color> colors = [
  //   Colors.red,
  //   Colors.red,
  //   Colors.red,
  //   Colors.red,
  // ];

  @override
  void initState() {
    currentPage = 0;
    tabController = TabController(length: 4, vsync: this);
    tabController.animation!.addListener(
      () {
        final value = tabController.animation!.value.round();
        if (value != currentPage && mounted) {
          changePage(value);
        }
      },
    );
    super.initState();
  }

  void changePage(int newPage) {
    setState(() {
      currentPage = newPage;
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Theme.of(context).colorScheme.background;
    Color primaryColor = Theme.of(context).colorScheme.primary;
    Color secondaryColor = Theme.of(context).colorScheme.secondary;
    Color tertiaryColor = Theme.of(context).colorScheme.tertiary;
    // final Color unselectedColor = colors[currentPage].computeLuminance() < 0.5
    //     ? Colors.black
    //     : Colors.white;
    return SafeArea(
      child: Scaffold(
        appBar: null,
        body: BottomBar(
          child: TabBar(
            indicatorPadding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
            controller: tabController,
            indicator: UnderlineTabIndicator(
                borderSide: BorderSide(
                    color: primaryColor,
                    // color: currentPage == 0
                    //     ? colors[0]
                    //     : currentPage == 1
                    //         ? colors[1]
                    //         : currentPage == 2
                    //             ? colors[2]
                    //             : currentPage == 3
                    //                 ? colors[3]
                    //                 : currentPage == 4
                    //                     ? colors[4]
                    //                     : unselectedColor,
                    width: 4),
                insets: EdgeInsets.fromLTRB(16, 0, 16, 8)),
            tabs: [
              SizedBox(
                height: 55,
                width: 40,
                child: Center(
                    child: Icon(
                  Iconsax.home_1,
                  // color: currentPage == 0 ? colors[0] : unselectedColor,
                  color: primaryColor,
                )),
              ),
              SizedBox(
                height: 55,
                width: 40,
                child: Center(
                    child: Icon(
                  Iconsax.image4,
                  // color: currentPage == 1 ? colors[1] : unselectedColor,
                  color: primaryColor,
                )),
              ),
              SizedBox(
                height: 55,
                width: 40,
                child: Center(
                    child: Icon(
                  Iconsax.video_circle,
                  // color: currentPage == 3 ? colors[3] : unselectedColor,
                  color: primaryColor,
                )),
              ),
              SizedBox(
                height: 55,
                width: 40,
                child: Center(
                    child: Icon(
                  Iconsax.heart,
                  // color: currentPage == 4 ? colors[4] : unselectedColor,
                  color: primaryColor,
                )),
              ),
            ],
          ),
          // fit: StackFit.expand,

          borderRadius: BorderRadius.circular(500),
          duration: Duration(milliseconds: 500),
          curve: Curves.decelerate,
          showIcon: true,
          width: MediaQuery.of(context).size.width * 0.8,
          barColor: backgroundColor,
          // barColor: colors[currentPage].computeLuminance() > 0.5
          //     ? Colors.black
          //     : Colors.white,
          start: 2,
          end: 0,
          offset: 10,
          barAlignment: Alignment.bottomCenter,
          iconHeight: 35,
          iconWidth: 35,
          reverse: false,
          hideOnScroll: true,
          scrollOpposite: false,
          onBottomBarHidden: () {},
          onBottomBarShown: () {},
          body: (context, controller) => TabBarView(
            controller: tabController,
            dragStartBehavior: DragStartBehavior.down,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              MyHomePage(),
              Category(),
              LiveWallCategory(),
              FavoriteImagesPage(),
            ],
          ),
        ),
      ),
    );
  }
}
