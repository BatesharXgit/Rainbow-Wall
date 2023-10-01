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
    required Color color,
  }) : super(key: key);

  @override
  State<Category> createState() => CategoryState();
}

class CategoryState extends State<Category> {
  List<Reference> amoledRefs = [];
  List<Reference> landscapesRefs = [];
  List<Reference> cityscapesRefs = [];
  List<Reference> spaceRefs = [];
  List<Reference> stockRefs = [];
  List<Reference> minimalistRefs = [];
  List<Reference> natureRefs = [];
  List<Reference> animalsRefs = [];
  List<Reference> scifiRefs = [];
  List<Reference> gamesRefs = [];

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

  @override
  void initState() {
    super.initState();
    loadamoledImages();
    loadlandscapesImages();
    loadcityscapesImages();
    loadspaceImages();
    loadstockImages();
    loadminimalistImages();
    loadnatureImages();
    loadanimalsmages();
    loadscifiImages();
    loadgamesImages();
  }

  Future<void> loadamoledImages() async {
    final ListResult result = await amoledRef.listAll();
    amoledRefs = result.items.toList();
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> loadlandscapesImages() async {
    final ListResult result = await landscapesRef.listAll();
    landscapesRefs = result.items.toList();
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> loadcityscapesImages() async {
    final ListResult result = await cityscapesRef.listAll();
    cityscapesRefs = result.items.toList();
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> loadspaceImages() async {
    final ListResult result = await spaceRef.listAll();
    spaceRefs = result.items.toList();
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> loadstockImages() async {
    final ListResult result = await stockRef.listAll();
    stockRefs = result.items.toList();
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> loadminimalistImages() async {
    final ListResult result = await minimalistRef.listAll();
    minimalistRefs = result.items.toList();
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> loadnatureImages() async {
    final ListResult result = await natureRef.listAll();
    natureRefs = result.items.toList();
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> loadanimalsmages() async {
    final ListResult result = await animalsRef.listAll();
    animalsRefs = result.items.toList();
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> loadscifiImages() async {
    final ListResult result = await scifiRef.listAll();
    scifiRefs = result.items.toList();
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> loadgamesImages() async {
    final ListResult result = await gamesRef.listAll();
    gamesRefs = result.items.toList();
    if (mounted) {
      setState(() {});
    }
  }

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
            physics: BouncingScrollPhysics(),
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
                            Get.to(AmoledWallpaper());
                          },
                          child: Row(
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
                        physics: BouncingScrollPhysics(),
                        itemCount: min(8, amoledRefs.length),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          // final imageRef = amoledRefs[index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: FutureBuilder(
                                future: amoledRefs[index].getDownloadURL(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Container(
                                      width: 120,
                                      child: _buildCircularIndicator(),
                                    );
                                  }
                                  if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  }
                                  if (!snapshot.hasData ||
                                      snapshot.data == null) {
                                    return Text('No Data');
                                  }

                                  return Container(
                                    width: 120,
                                    child: CachedNetworkImage(
                                      imageUrl: snapshot.data.toString(),
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                },
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
                            Get.to(SpaceWallpaper());
                          },
                          child: Row(
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
                        physics: BouncingScrollPhysics(),
                        itemCount: min(8, amoledRefs.length),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          // final imageRef = amoledRefs[index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: FutureBuilder(
                                future: amoledRefs[index].getDownloadURL(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Container(
                                      width: 120,
                                      child: _buildCircularIndicator(),
                                    );
                                  }
                                  if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  }
                                  if (!snapshot.hasData ||
                                      snapshot.data == null) {
                                    return Text('No Data');
                                  }
                                  return Container(
                                    width: 120,
                                    child: CachedNetworkImage(
                                      imageUrl: snapshot.data.toString(),
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                },
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
                            Get.to(StockWallpapers());
                          },
                          child: Row(
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
                        physics: BouncingScrollPhysics(),
                        itemCount: min(8, amoledRefs.length),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          // final imageRef = amoledRefs[index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: FutureBuilder(
                                future: amoledRefs[index].getDownloadURL(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Container(
                                      width: 120,
                                      child: _buildCircularIndicator(),
                                    );
                                  }
                                  if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  }
                                  if (!snapshot.hasData ||
                                      snapshot.data == null) {
                                    return Text('No Data');
                                  }
                                  return Container(
                                    width: 120,
                                    child: CachedNetworkImage(
                                      imageUrl: snapshot.data.toString(),
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                },
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
                            Get.to(MinimalistWallpaper());
                          },
                          child: Row(
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
                        physics: BouncingScrollPhysics(),
                        itemCount: min(8, amoledRefs.length),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          // final imageRef = amoledRefs[index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: FutureBuilder(
                                future: amoledRefs[index].getDownloadURL(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Container(
                                      width: 120,
                                      child: _buildCircularIndicator(),
                                    );
                                  }
                                  if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  }
                                  if (!snapshot.hasData ||
                                      snapshot.data == null) {
                                    return Text('No Data');
                                  }
                                  return Container(
                                    width: 120,
                                    child: CachedNetworkImage(
                                      imageUrl: snapshot.data.toString(),
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                },
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
                            Get.to(NatureWallpaper());
                          },
                          child: Row(
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
                        physics: BouncingScrollPhysics(),
                        itemCount: min(8, amoledRefs.length),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          // final imageRef = amoledRefs[index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: FutureBuilder(
                                future: amoledRefs[index].getDownloadURL(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Container(
                                      width: 120,
                                      child: _buildCircularIndicator(),
                                    );
                                  }
                                  if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  }
                                  if (!snapshot.hasData ||
                                      snapshot.data == null) {
                                    return Text('No Data');
                                  }
                                  return Container(
                                    width: 120,
                                    child: CachedNetworkImage(
                                      imageUrl: snapshot.data.toString(),
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                },
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
                            Get.to(AnimalsWallpaper());
                          },
                          child: Row(
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
                        physics: BouncingScrollPhysics(),
                        itemCount: min(8, amoledRefs.length),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          // final imageRef = amoledRefs[index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: FutureBuilder(
                                future: amoledRefs[index].getDownloadURL(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Container(
                                      width: 120,
                                      child: _buildCircularIndicator(),
                                    );
                                  }
                                  if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  }
                                  if (!snapshot.hasData ||
                                      snapshot.data == null) {
                                    return Text('No Data');
                                  }
                                  return Container(
                                    width: 120,
                                    child: CachedNetworkImage(
                                      imageUrl: snapshot.data.toString(),
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                },
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
                            Get.to(ScifiWallpaper());
                          },
                          child: Row(
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
                        physics: BouncingScrollPhysics(),
                        itemCount: min(8, amoledRefs.length),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          // final imageRef = amoledRefs[index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: FutureBuilder(
                                future: amoledRefs[index].getDownloadURL(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Container(
                                      width: 120,
                                      child: _buildCircularIndicator(),
                                    );
                                  }
                                  if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  }
                                  if (!snapshot.hasData ||
                                      snapshot.data == null) {
                                    return Text('No Data');
                                  }
                                  return Container(
                                    width: 120,
                                    child: CachedNetworkImage(
                                      imageUrl: snapshot.data.toString(),
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                },
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
                            Get.to(GamesWallpaper());
                          },
                          child: Row(
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
                        physics: BouncingScrollPhysics(),
                        itemCount: min(8, amoledRefs.length),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          // final imageRef = amoledRefs[index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: FutureBuilder(
                                future: amoledRefs[index].getDownloadURL(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Container(
                                      width: 120,
                                      child: _buildCircularIndicator(),
                                    );
                                  }
                                  if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  }
                                  if (!snapshot.hasData ||
                                      snapshot.data == null) {
                                    return Text('No Data');
                                  }
                                  return Container(
                                    width: 120,
                                    child: CachedNetworkImage(
                                      imageUrl: snapshot.data.toString(),
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                },
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
