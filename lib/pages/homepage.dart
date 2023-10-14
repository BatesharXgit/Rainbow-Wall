import 'package:bootstrap_icons/bootstrap_icons.dart';
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
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: NestedScrollView(
          controller: ScrollController(),
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 200.0,
                floating: false,
                pinned: false,
                backgroundColor: Theme.of(context).colorScheme.background,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: false,
                  title: null,
                  background: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/luca.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'LUCA',
                          style: TextStyle(
                            fontFamily: "Anurati",
                            fontSize: 42,
                            color: Colors.white,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () => Get.to(const NotificationsPage(),
                                  transition: Transition.native),
                              icon: Icon(
                                Iconsax.notification,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                            IconButton(
                              onPressed: () => Get.to(
                                  const SearchWallpaper(title: ''),
                                  transition: Transition.native),
                              icon: Icon(
                                BootstrapIcons.search,
                                color: Colors.white,
                                size: 26,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
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
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
        child: TabBar(
          physics: const BouncingScrollPhysics(),
          controller: _tabController,
          indicator: const BoxDecoration(
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
            // controller: widget.controller,
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
          Container(
              color: Theme.of(context).colorScheme.background,
              child: _buildImageGridFromRef(wallpaperRef)),
          Container(
              color: Theme.of(context).colorScheme.background,
              child: _buildImageGridFromRef(aiRef)),
          Container(
              color: Theme.of(context).colorScheme.background,
              child: _buildImageGridFromRef(illustrationRef)),
          Container(
              color: Theme.of(context).colorScheme.background,
              child: _buildImageGridFromRef(carsRef)),
          Container(
              color: Theme.of(context).colorScheme.background,
              child: _buildImageGridFromRef(abstractRef)),
          Container(
              color: Theme.of(context).colorScheme.background,
              child: _buildImageGridFromRef(fantasyRef)),
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
