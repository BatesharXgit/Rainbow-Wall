import 'dart:ui';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:luca/pages/util/components.dart';
import 'package:luca/pages/util/applyWallpaperPage.dart';
import 'package:luca/pages/util/location_list.dart';
import 'package:luca/pages/util/notify/notify.dart';
import 'package:luca/pages/util/searchresult.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:luca/pages/settings.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

final FirebaseStorage storage = FirebaseStorage.instance;

final Reference wallpaperRef = storage.ref().child('wallpaper');
final Reference aiRef = storage.ref().child('ai');
final Reference abstractRef = storage.ref().child('abstract');
final Reference carsRef = storage.ref().child('cars');
final Reference illustrationRef = storage.ref().child('illustration');
final Reference fantasyRef = storage.ref().child('fantasy');

class MyHomePage extends StatefulWidget {
  const MyHomePage({
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

  int index = 0;

  final List<String> data = [
    "For You",
    "AI",
    "Illustration",
    "Cars",
    "Abstract",
    "Fantasy",
  ];

  // @override
  // void initState() {
  //   super.initState();
  //   _tabController = TabController(length: data.length, vsync: this);
  //   loadWallpaperImages();
  //   loadCarsImages();
  //   loadAbstractImages();
  //   loadaiImages();
  //   loadfantasyImages();
  // }

  @override
  void dispose() {
    scrollController.dispose();
    _tabController.dispose();
    super.dispose();
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

  void initState() {
    super.initState();
    _tabController = TabController(length: data.length, vsync: this);
    loadImages();
  }

  Future<Uint8List> resizeImage(String imageUrl) async {
    final response = await http.get(Uri.parse(imageUrl));
    final List<int> originalImage = response.bodyBytes;

    final Uint8List compressedImage = Uint8List.fromList(originalImage);

    return compressedImage;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          key: _scaffoldKey,
          appBar: null,
          backgroundColor: Theme.of(context).colorScheme.background,
          body: SafeArea(
            child: Column(
              children: [
                _buildAppBar(context),
                _buildTabBar(),
                Expanded(
                  child: _buildTabViews(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar(context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 48,
                width: 48,
                child: ClipRRect(
                  child: Image.asset('lib/images/luca.png'),
                ),
              ),
              const SizedBox(
                width: 8.0,
              ),
              Text(
                'LUCA',
                style: TextStyle(
                  fontFamily: 'Anurati',
                  color: Theme.of(context).iconTheme.color,
                  fontSize: 32,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                // onPressed: () {},
                onPressed: () => Get.to(
                  NotificationsPage(),
                  transition: Transition.fadeIn,
                ),
                icon: Icon(
                  Iconsax.notification,
                  color: Theme.of(context).iconTheme.color,
                  size: 30,
                ),
              ),
              IconButton(
                onPressed: () => Get.to(
                  const SearchWallpaper(
                    title: '',
                  ),
                  transition: Transition.fadeIn,
                ),
                icon: Icon(
                  BootstrapIcons.search,
                  color: Theme.of(context).iconTheme.color,
                  size: 26,
                ),
              ),
              IconButton(
                icon: const Icon(
                  Iconsax.setting_2,
                  size: 30,
                ),
                color: Theme.of(context).iconTheme.color,
                onPressed: () =>
                    Get.to(SettingsPage(), transition: Transition.fadeIn),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
      child: TabBar(
        physics: const BouncingScrollPhysics(),
        controller: _tabController,
        indicator: BoxDecoration(
          color: Colors.transparent,
          border:
              Border(bottom: BorderSide(color: Colors.transparent, width: 0)),
        ),
        labelColor: Theme.of(context).colorScheme.primary,
        unselectedLabelColor: Theme.of(context).colorScheme.secondary,
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
    );
  }

  Widget _buildLoadingWidget() {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(const Color(0xB700FF00)),
        backgroundColor: Colors.black,
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
            // controller: widget.controller,
            physics: ClampingScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
          return Center(child: Text('No images available'));
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

  Widget _buildImageWidget(String imageUrl) {
    return Builder(
      builder: (context) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ApplyWallpaperPage(imageUrl: imageUrl),
              ),
            );
          },
          child: FutureBuilder<Uint8List>(
            future: resizeImage(imageUrl),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Components.buildCircularIndicator();
              } else if (snapshot.hasError) {
                return Components.buildErrorWidget();
              } else if (snapshot.hasData) {
                return Hero(
                  tag: imageUrl,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: LocationListItem(
                        imageBytes:
                            snapshot.data, // Pass the resized image bytes
                        scrollController: scrollController, imageUrl: imageUrl,
                      ),
                    ),
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
        );
      },
    );
  }
}
