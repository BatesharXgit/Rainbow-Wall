import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:flutter/services.dart';
// ignore: depend_on_referenced_packages
import 'package:fluttertoast/fluttertoast.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';

// ignore: constant_identifier_names
const String API_KEY =
    'tLLFbgWVeyvt2Onc1QYv0R1BZ3IfLH7iT7zduYlsHkDyB8eSpddwR2th';

class SearchWallpaper extends StatefulWidget {
  const SearchWallpaper({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<SearchWallpaper> createState() => SearchWallpaperState();
}

class SearchWallpaperState extends State<SearchWallpaper> {
  List<dynamic> _images = [];
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _searchImages(String query) async {
    setState(() {
      _isLoading = true;
    });

    String url = 'https://api.pexels.com/v1/search?query=$query&per_page=50';

    final response = await http.get(Uri.parse(url), headers: {
      'Authorization': API_KEY,
    });

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        _images = data['photos'];
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Theme.of(context).colorScheme.background;
    Color primaryColor = Theme.of(context).colorScheme.primary;
    return Scaffold(
      appBar: null,
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.015,
              ),
              buildSearchBox(context),
              const Divider(
                thickness: 2.0,
                color: Colors.transparent,
              ),
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : _images.isEmpty
                        ? Center(
                            child: Text(
                              'Unleash the magic of search.',
                              style: TextStyle(color: primaryColor),
                            ),
                          )
                        : MasonryGridView.builder(
                            gridDelegate:
                                const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2),
                            itemCount: _images.length,
                            itemBuilder: (context, index) {
                              String mediumImageUrl =
                                  _images[index]['src']['medium'];
                              String originalImageUrl =
                                  _images[index]['src']['original'];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FullScreenImage(
                                        mediumImageUrl: mediumImageUrl,
                                        originalImageUrl: originalImageUrl,
                                      ),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Hero(
                                      tag: originalImageUrl,
                                      child: CachedNetworkImage(
                                        imageUrl: mediumImageUrl,
                                        fit: BoxFit.cover,
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSearchBox(BuildContext context) {
    Color primaryColor = Theme.of(context).colorScheme.primary;
    Color tertiaryColor = Theme.of(context).colorScheme.tertiary;
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        height: MediaQuery.of(context).size.height * 0.055,
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  onChanged: (query) => _debouncedSearch(query),
                  style: GoogleFonts.kanit(
                    fontSize: 18,
                    color: tertiaryColor,
                  ),
                  decoration: InputDecoration(
                    hintText: 'What you are looking for...',
                    hintStyle: GoogleFonts.kanit(
                      color: tertiaryColor.withOpacity(0.8),
                      fontSize: 16,
                    ),
                    border: InputBorder.none,
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.search_outlined,
                        color: tertiaryColor,
                      ),
                      onPressed: () {},
                    ),
                  ),
                  cursorColor: primaryColor,
                  cursorRadius: const Radius.circular(20),
                  cursorWidth: 3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Timer? _debounceTimer;

  void _debouncedSearch(String query) {
    if (_debounceTimer != null && _debounceTimer!.isActive) {
      _debounceTimer!.cancel();
    }
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _searchImages(query);
    });
  }
}

class FullScreenImage extends StatelessWidget {
  final String mediumImageUrl;
  final String originalImageUrl;

  const FullScreenImage(
      {super.key, required this.mediumImageUrl, required this.originalImageUrl});
  Future<void> applyHomescreen(BuildContext context) async {
    try {
      bool success = await AsyncWallpaper.setWallpaper(
        url: originalImageUrl,
        wallpaperLocation: AsyncWallpaper.HOME_SCREEN,
        goToHome: true,
      );
      if (success) {
        Fluttertoast.showToast(
          msg: 'Wallpaper set',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
      } else {
        Fluttertoast.showToast(
          msg: 'Failed to set wallpaper',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } on PlatformException {
      Fluttertoast.showToast(
        msg: 'Failed to set wallpaper',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  Future<void> applyLockscreen(BuildContext context) async {
    try {
      bool success = await AsyncWallpaper.setWallpaper(
        url: originalImageUrl,
        wallpaperLocation: AsyncWallpaper.LOCK_SCREEN,
        goToHome: true,
      );
      if (success) {
        Fluttertoast.showToast(
          msg: 'Wallpaper set',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
      } else {
        Fluttertoast.showToast(
          msg: 'Failed to set wallpaper',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } on PlatformException {
      Fluttertoast.showToast(
        msg: 'Failed to set wallpaper',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  Future<void> applyBoth(BuildContext context) async {
    try {
      bool success = await AsyncWallpaper.setWallpaper(
        url: originalImageUrl,
        wallpaperLocation: AsyncWallpaper.BOTH_SCREENS,
        goToHome: true,
      );
      if (success) {
        Fluttertoast.showToast(
          msg: 'Wallpaper set',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
      } else {
        Fluttertoast.showToast(
          msg: 'Failed to set wallpaper',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } on PlatformException {
      Fluttertoast.showToast(
        msg: 'Failed to set wallpaper',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          Hero(
            tag: originalImageUrl,
            child: Image.network(
              originalImageUrl,
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              filterQuality: FilterQuality.high,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 10, left: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios_new_outlined,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: MediaQuery.of(context).padding.bottom + 10,
            child: GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (BuildContext context) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10.0,
                            spreadRadius: 2.0,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        // Apply the blur effect only to the bottom sheet
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16.0),
                        ),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                title: Text(
                                  'Apply to Home Screen',
                                  style: GoogleFonts.kanit(color: Colors.white),
                                ),
                                onTap: () {
                                  applyHomescreen(context);
                                },
                              ),
                              ListTile(
                                title: Text(
                                  'Apply to Lock Screen',
                                  style: GoogleFonts.kanit(color: Colors.white),
                                ),
                                onTap: () {
                                  applyLockscreen(context);
                                },
                              ),
                              ListTile(
                                title: Text(
                                  'Apply to Both',
                                  style: GoogleFonts.kanit(color: Colors.white),
                                ),
                                onTap: () {
                                  applyBoth(context);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 30.0, sigmaY: 30.0),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                        child: Center(
                          child: Text(
                            'Apply Wallpaper',
                            style: GoogleFonts.kanit(
                                color: Colors.white, fontSize: 22),
                          ),
                        ),
                      ),
                    ),
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
