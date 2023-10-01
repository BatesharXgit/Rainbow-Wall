import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../util/walls_category.dart';

final FirebaseStorage storage = FirebaseStorage.instance;
final Reference amoledRef = storage.ref().child('wallpaper');
final Reference landscapesRef = storage.ref().child('wallpaper');
final Reference cityscapesRef = storage.ref().child('wallpaper');
final Reference spaceRef = storage.ref().child('wallpaper');
final Reference stockRef = storage.ref().child('wallpaper');
final Reference minimalistRef = storage.ref().child('wallpaper');
final Reference natureRef = storage.ref().child('wallpaper');
final Reference animalsRef = storage.ref().child('wallpaper');
final Reference scifiRef = storage.ref().child('wallpaper');
final Reference gamesRef = storage.ref().child('wallpaper');

class Category extends StatefulWidget {
  const Category({
    Key? key,
  }) : super(key: key);

  @override
  State<Category> createState() => CategoryState();
}

class CategoryState extends State<Category> {
  // List<Reference> amoledRefs = [];
  // List<Reference> landscapesRefs = [];
  // List<Reference> cityscapesRefs = [];
  // List<Reference> spaceRefs = [];
  // List<Reference> stockRefs = [];
  // List<Reference> minimalistRefs = [];
  // List<Reference> natureRefs = [];
  // List<Reference> animalsRefs = [];
  // List<Reference> scifiRefs = [];
  // List<Reference> gamesRefs = [];

  final List<String> categories = [
    'Amoled',
    'Landscapes',
    'Cityscapes',
    'Space',
    'Stock',
    'Minimalist',
    'Nature',
    'Animals',
    'Sci-Fi',
    'Games',
  ];

  final List<String> _amoled = [
    'https://firebasestorage.googleapis.com/v0/b/luca-ui.appspot.com/o/category%2Famoled%2F93.jpg?alt=media&token=dd4741da-9f8c-4c03-80b6-b2df77e5de74',
    'https://firebasestorage.googleapis.com/v0/b/luca-ui.appspot.com/o/category%2Famoled%2F83.jpg?alt=media&token=52cb7707-0ab0-4961-b3ad-8c79ff5c3b70',
    'https://firebasestorage.googleapis.com/v0/b/luca-ui.appspot.com/o/category%2Famoled%2F79.jpg?alt=media&token=ffd1a801-53c8-4df9-8269-d4a0cd394a19',
    'https://firebasestorage.googleapis.com/v0/b/luca-ui.appspot.com/o/category%2Famoled%2F76.jpg?alt=media&token=0f0b1b82-879b-421e-9382-e6fb5f1074ee',
    'https://firebasestorage.googleapis.com/v0/b/luca-ui.appspot.com/o/category%2Famoled%2F71.jpg?alt=media&token=98ede1b5-f454-43c5-a8d3-75431eb133a9',
    'https://firebasestorage.googleapis.com/v0/b/luca-ui.appspot.com/o/category%2Famoled%2F66.jpg?alt=media&token=3025b56b-c208-4844-8d37-c18df18b0843',
    'https://firebasestorage.googleapis.com/v0/b/luca-ui.appspot.com/o/category%2Famoled%2F59.jpg?alt=media&token=6db4ae15-1ea3-47c3-aa6e-b5db13ac759d',
    'https://firebasestorage.googleapis.com/v0/b/luca-ui.appspot.com/o/category%2Famoled%2F90.jpg?alt=media&token=5bac6a75-a3f0-4ce4-8f69-0b127c650d46'
  ];

  @override
  void initState() {
    super.initState();
    // loadamoledImages();
    // loadlandscapesImages();
    // loadcityscapesImages();
    // loadspaceImages();
    // loadstockImages();
    // loadminimalistImages();
    // loadnatureImages();
    // loadanimalsmages();
    // loadscifiImages();
    // loadgamesImages();
  }

  // Future<void> loadamoledImages() async {
  //   final ListResult result = await amoledRef.listAll();
  //   amoledRefs = result.items.toList();
  //   if (mounted) {
  //     setState(() {});
  //   }
  // }

  // Future<void> loadlandscapesImages() async {
  //   final ListResult result = await landscapesRef.listAll();
  //   landscapesRefs = result.items.toList();
  //   if (mounted) {
  //     setState(() {});
  //   }
  // }

  // Future<void> loadcityscapesImages() async {
  //   final ListResult result = await cityscapesRef.listAll();
  //   cityscapesRefs = result.items.toList();
  //   if (mounted) {
  //     setState(() {});
  //   }
  // }

  // Future<void> loadspaceImages() async {
  //   final ListResult result = await spaceRef.listAll();
  //   spaceRefs = result.items.toList();
  //   if (mounted) {
  //     setState(() {});
  //   }
  // }

  // Future<void> loadstockImages() async {
  //   final ListResult result = await stockRef.listAll();
  //   stockRefs = result.items.toList();
  //   if (mounted) {
  //     setState(() {});
  //   }
  // }

  // Future<void> loadminimalistImages() async {
  //   final ListResult result = await minimalistRef.listAll();
  //   minimalistRefs = result.items.toList();
  //   if (mounted) {
  //     setState(() {});
  //   }
  // }

  // Future<void> loadnatureImages() async {
  //   final ListResult result = await natureRef.listAll();
  //   natureRefs = result.items.toList();
  //   if (mounted) {
  //     setState(() {});
  //   }
  // }

  // Future<void> loadanimalsmages() async {
  //   final ListResult result = await animalsRef.listAll();
  //   animalsRefs = result.items.toList();
  //   if (mounted) {
  //     setState(() {});
  //   }
  // }

  // Future<void> loadscifiImages() async {
  //   final ListResult result = await scifiRef.listAll();
  //   scifiRefs = result.items.toList();
  //   if (mounted) {
  //     setState(() {});
  //   }
  // }

  // Future<void> loadgamesImages() async {
  //   final ListResult result = await gamesRef.listAll();
  //   gamesRefs = result.items.toList();
  //   if (mounted) {
  //     setState(() {});
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Theme.of(context).colorScheme.background;
    Color primaryColor = Theme.of(context).colorScheme.primary;
    // Color secondaryColor = Theme.of(context).colorScheme.secondary;
    // Color tertiaryColor = Theme.of(context).colorScheme.tertiary;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: backgroundColor,
        title: Text(
          'Categories',
          style: GoogleFonts.orbitron(
            color: primaryColor,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: AnimationLimiter(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: AnimationConfiguration.toStaggeredList(
                duration: const Duration(milliseconds: 375),
                childAnimationBuilder: (widget) => SlideAnimation(
                  horizontalOffset: 50.0,
                  child: FadeInAnimation(
                    child: widget,
                  ),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Amoled",
                          style: GoogleFonts.kanit(
                            fontSize: 18,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.to(const AmoledWallpaper());
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "See All",
                                style: TextStyle(
                                    decoration: TextDecoration.underline),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
                    child: SizedBox(
                      height: 200,
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: min(8, _amoled.length),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: 120,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: CachedNetworkImage(
                                  imageUrl: _amoled[index],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Space",
                          style: GoogleFonts.kanit(
                            fontSize: 18,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.to(const SpaceWallpaper());
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "See All",
                                style: TextStyle(
                                    decoration: TextDecoration.underline),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
                    child: SizedBox(
                      height: 200,
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: min(8, _amoled.length),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: 120,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: CachedNetworkImage(
                                  imageUrl: _amoled[index],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Stock",
                          style: GoogleFonts.kanit(
                            fontSize: 18,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.to(const StockWallpapers());
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "See All",
                                style: TextStyle(
                                    decoration: TextDecoration.underline),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
                    child: SizedBox(
                      height: 200,
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: min(8, _amoled.length),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: 120,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: CachedNetworkImage(
                                  imageUrl: _amoled[index],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Minimalist",
                          style: GoogleFonts.kanit(
                            fontSize: 18,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.to(const MinimalistWallpaper());
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "See All",
                                style: TextStyle(
                                    decoration: TextDecoration.underline),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
                    child: SizedBox(
                      height: 200,
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: min(8, _amoled.length),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: 120,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: CachedNetworkImage(
                                  imageUrl: _amoled[index],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Nature",
                          style: GoogleFonts.kanit(
                            fontSize: 18,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.to(const NatureWallpaper());
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "See All",
                                style: TextStyle(
                                    decoration: TextDecoration.underline),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
                    child: SizedBox(
                      height: 200,
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: min(8, _amoled.length),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: 120,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: CachedNetworkImage(
                                  imageUrl: _amoled[index],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Animals",
                          style: GoogleFonts.kanit(
                            fontSize: 18,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.to(const AnimalsWallpaper());
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "See All",
                                style: TextStyle(
                                    decoration: TextDecoration.underline),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
                    child: SizedBox(
                      height: 200,
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: min(8, _amoled.length),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: 120,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: CachedNetworkImage(
                                  imageUrl: _amoled[index],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Sci-Fi",
                          style: GoogleFonts.kanit(
                            fontSize: 18,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.to(const ScifiWallpaper());
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "See All",
                                style: TextStyle(
                                    decoration: TextDecoration.underline),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
                    child: SizedBox(
                      height: 200,
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: min(8, _amoled.length),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: 120,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: CachedNetworkImage(
                                  imageUrl: _amoled[index],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Games",
                          style: GoogleFonts.kanit(
                            fontSize: 18,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.to(const GamesWallpaper());
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "See All",
                                style: TextStyle(
                                    decoration: TextDecoration.underline),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
                    child: SizedBox(
                      height: 200,
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: min(8, _amoled.length),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: 120,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: CachedNetworkImage(
                                  imageUrl: _amoled[index],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCircularIndicator() {
    return Center(
      child: LoadingAnimationWidget.fallingDot(
        size: 35,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
