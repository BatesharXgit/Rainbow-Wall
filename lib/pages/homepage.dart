import 'dart:ui';

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:luca/pages/util/components.dart';
import 'package:luca/pages/util/notify/notify.dart';
import 'package:luca/pages/util/searchresult.dart';
import 'package:firebase_storage/firebase_storage.dart';

final FirebaseStorage storage = FirebaseStorage.instance;

final Reference wallpaperRef = storage.ref().child('wallpaper');
final Reference aiRef = storage.ref().child('ai');
final Reference abstractRef = storage.ref().child('abstract');
final Reference carsRef = storage.ref().child('cars');
final Reference illustrationRef = storage.ref().child('illustration');
final Reference fantasyRef = storage.ref().child('fantasy');

class MyHomePage extends StatefulWidget {
  final ScrollController controller;
  const MyHomePage({
    required this.controller,
    Key? key,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  ScrollController scrollController = ScrollController();
  late TabController _tabController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Reference> wallpaperRefs = [];
  List<Reference> aiRefs = [];
  List<Reference> carsRefs = [];
  List<Reference> abstractRefs = [];
  List<Reference> illustrationRefs = [];
  List<Reference> fantasyRefs = [];

  List<String> kImages = [
    'https://firebasestorage.googleapis.com/v0/b/luca-ui.appspot.com/o/category%2Fnature%2F58.jpg?alt=media&token=e3f7fafb-32bd-43b8-b006-118f91d77048',
    'https://firebasestorage.googleapis.com/v0/b/luca-ui.appspot.com/o/category%2Fminimalist%2F81.jpg?alt=media&token=e3c08b97-0be5-4ed8-b9c1-8357212b5526',
    'https://firebasestorage.googleapis.com/v0/b/luca-ui.appspot.com/o/category%2Fanime%2F72.jpg?alt=media&token=e2b1105a-46c8-4f7c-aad0-1359f5f3fd97',
    'https://firebasestorage.googleapis.com/v0/b/luca-ui.appspot.com/o/category%2Fspace%2F69.jpg?alt=media&token=65b35575-8529-4bb4-89ee-e788b89573cd',
    'https://firebasestorage.googleapis.com/v0/b/luca-ui.appspot.com/o/category%2Famoled%2F79.jpg?alt=media&token=ffd1a801-53c8-4df9-8269-d4a0cd394a19',
    'https://firebasestorage.googleapis.com/v0/b/luca-ui.appspot.com/o/category%2Famoled%2F76.jpg?alt=media&token=0f0b1b82-879b-421e-9382-e6fb5f1074ee',
  ];

  int index = 0;

  final List<String> data = [
    "For You",
    "AI",
    "Illustration",
    "Cars",
    "Abstract",
    "Fantasy",
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    loadImages();
  }

  Future<void> loadImages() async {
    final ListResult wallpaperResult = await wallpaperRef.listAll();
    wallpaperRefs = wallpaperResult.items.toList();

    final ListResult aiResult = await aiRef.listAll();
    aiRefs = aiResult.items.toList();

    final ListResult illustrationResult = await illustrationRef.listAll();
    illustrationRefs = illustrationResult.items.toList();

    final ListResult carResult = await carsRef.listAll();
    carsRefs = carResult.items.toList();

    final ListResult abstractResult = await abstractRef.listAll();
    abstractRefs = abstractResult.items.toList();

    final ListResult fantasyResult = await fantasyRef.listAll();
    fantasyRefs = fantasyResult.items.toList();
  }

  @override
  void dispose() {
    scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Theme.of(context).colorScheme.background;
    Color primaryColor = Theme.of(context).colorScheme.primary;
    Color secondaryColor = Theme.of(context).colorScheme.secondary;
    Color tertiaryColor = Theme.of(context).colorScheme.tertiary;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: NestedScrollView(
          controller: ScrollController(),
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                forceMaterialTransparency: true,
                expandedHeight: MediaQuery.of(context).size.height * 0.35,
                floating: true,
                pinned: false,
                backgroundColor: Theme.of(context).colorScheme.background,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: false,
                  title: null,
                  background: Container(
                    color: Theme.of(context)
                        .colorScheme
                        .background
                        .withOpacity(0.5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                    shape: BoxShape.circle),
                                child: IconButton(
                                  onPressed: () => Get.to(
                                      const NotificationsPage(),
                                      transition: Transition.native),
                                  icon: Icon(
                                    Iconsax.notification,
                                    color: primaryColor,
                                    size: 30,
                                  ),
                                ),
                              ),
                              Text(
                                'LUCA',
                                style: TextStyle(
                                  fontFamily: "Anurati",
                                  fontSize: 38,
                                  color: primaryColor,
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                    shape: BoxShape.circle),
                                child: IconButton(
                                  onPressed: () => Get.to(
                                      const SearchWallpaper(title: ''),
                                      transition: Transition.native),
                                  icon: Icon(
                                    BootstrapIcons.search,
                                    color: primaryColor,
                                    size: 26,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Discover',
                              style: TextStyle(
                                fontFamily: "Anurati",
                                fontSize: 24,
                                color: primaryColor,
                                // fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CarouselSlider(
                          options: CarouselOptions(
                            scrollPhysics: BouncingScrollPhysics(),
                            height: 160.0,
                            enlargeCenterPage: true,
                            viewportFraction: 0.8,
                            enlargeFactor: 0.2,
                          ),
                          items: kImages.map((String imageUrl) {
                            return Builder(
                              builder: (BuildContext context) {
                                return Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    image: DecorationImage(
                                      image:
                                          CachedNetworkImageProvider(imageUrl),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        ),
//  CarouselSlider(
//                           options: CarouselOptions(
//                               scrollPhysics: BouncingScrollPhysics(),
//                               height: 160.0,
//                               enlargeCenterPage: true,
//                               viewportFraction: 0.8,
//                               enlargeFactor: 0.2),
//                           items: ['ABC', 2, 3, 4, 5].map((i) {
//                             return Builder(
//                               builder: (BuildContext context) {
//                                 return Container(
//                                     width: MediaQuery.of(context).size.width,
//                                     decoration: BoxDecoration(
//                                         color: kColours[index + 2],
//                                         borderRadius:
//                                             BorderRadius.circular(20)),
//                                     child: Text(
//                                       'text $i',
//                                       style: TextStyle(fontSize: 16.0),
//                                     ));
//                               },
//                             );
//                           }).toList(),
//                         )
                      ],
                    ),
                  ),
                  // ),
                  // ),
                ),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: _SliverAppBarDelegate(_buildTabBar()),
              ),
            ];
          },
          body: _buildTabViews(),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    Color primaryColor = Theme.of(context).colorScheme.primary;
    Color backgroundColor = Theme.of(context).colorScheme.background;
    return Container(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
        child: TabBar(
          physics: const BouncingScrollPhysics(),
          indicatorPadding: const EdgeInsets.fromLTRB(6, 2, 6, 2),
          controller: _tabController,
          indicatorColor: Theme.of(context).colorScheme.background,
          indicator: BoxDecoration(
            color: Theme.of(context).colorScheme.tertiary,
            borderRadius: BorderRadius.circular(15),
          ),
          labelColor: primaryColor,
          unselectedLabelColor: primaryColor,
          isScrollable: true,
          labelPadding: const EdgeInsets.symmetric(horizontal: 10),
          tabs: data.map((tab) {
            return Tab(
              child: Text(
                tab,
                style: GoogleFonts.kanit(
                  fontSize: 14,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

   Widget _buildImageGridFromRef(Reference imageRef) {
    return FutureBuilder<ListResult>(
      future: imageRef.listAll(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Components.buildPlaceholder();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData && snapshot.data!.items.isNotEmpty) {
          List<Reference> imageRefs = snapshot.data!.items;

          return GridView.builder(
            clipBehavior: Clip.none,
            controller: ScrollController(),
            physics: const ClampingScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
            ),
            itemCount: imageRefs.length,
            itemBuilder: (context, index) {
              final imageRef = imageRefs[index];
              return FutureBuilder<String>(
                future: imageRef.getDownloadURL(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Components.buildCircularIndicator();
                  } else if (snapshot.hasError) {
                    return Components.buildErrorWidget();
                  } else if (snapshot.hasData) {
                    return Components.buildImageWidget(snapshot.data!);
                  } else {
                    return Container();
                  }
                },
              );
            },
          );
        } else {
          return const Center(child: Text('No images available'));
        }
      },
    );
  }

  Widget _buildTabViews() {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: TabBarView(
        controller: _tabController,
        children: [
          _buildImageGridFromRef(wallpaperRef),
          _buildImageGridFromRef(aiRef),
          _buildImageGridFromRef(illustrationRef),
          _buildImageGridFromRef(carsRef),
          _buildImageGridFromRef(abstractRef),
          _buildImageGridFromRef(fantasyRef),
        ],
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget tab;

  _SliverAppBarDelegate(this.tab);

  @override
  double get minExtent => 40;
  @override
  double get maxExtent => 40;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return tab;
  }
}
