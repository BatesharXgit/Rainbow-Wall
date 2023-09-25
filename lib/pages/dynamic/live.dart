import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:async_wallpaper/async_wallpaper.dart';

//##############################################################################################################################
//##############################################################################################################################
//##############################################################################################################################

class CarsWallpaper extends StatefulWidget {
  @override
  _CarsWallpaperState createState() => _CarsWallpaperState();
}

class _CarsWallpaperState extends State<CarsWallpaper>
    with AutomaticKeepAliveClientMixin<CarsWallpaper> {
  PageController _pageController = PageController();
  List<String> videoUrls = [];
  int _currentVideoIndex = 0;
  VideoPlayerController? _controller;
  bool _isPlaying = true;
  bool _videoInitialized = false;

  @override
  void initState() {
    super.initState();
    _fetchVideoUrls();
    _pageController.addListener(_onPageChange);
  }

  Future<void> _fetchVideoUrls() async {
    final storageRef = FirebaseStorage.instance.ref('live');
    final ListResult result = await storageRef.listAll();

    setState(() {
      videoUrls = result.items.map((item) => item.fullPath).toList();
    });

    _initializeVideoController(_currentVideoIndex);
  }

  void _initializeVideoController(int index) async {
    _controller?.dispose();
    final videoUrl = await _getVideoUrl(index);

    final cachedVideo = await DefaultCacheManager().getFileFromCache(videoUrl);

    if (cachedVideo != null && cachedVideo.file.existsSync()) {
      _controller = VideoPlayerController.file(cachedVideo.file)
        ..initialize().then((_) {
          setState(() {
            _videoInitialized = true;
          });
          _controller!.play();
          _controller!.setLooping(true);
          _isPlaying = true;
        });
    } else {
      var file = await DefaultCacheManager().getSingleFile(videoUrl);
      _controller = VideoPlayerController.file(file)
        ..initialize().then((_) {
          setState(() {
            _videoInitialized = true;
          });
          _controller!.play();
          _controller!.setLooping(true);
          _isPlaying = true;
        });
    }

    _controller!.addListener(_onVideoStateChange);
  }

  Future<String> _getVideoUrl(int index) async {
    final ref = FirebaseStorage.instance.ref(videoUrls[index]);
    final url = await ref.getDownloadURL();
    return url;
  }

  void _onVideoStateChange() {
    if (_controller!.value.isPlaying != _isPlaying) {
      setState(() {
        _isPlaying = _controller!.value.isPlaying;
      });
    }
  }

  void _onPageChange() {
    int newPageIndex = _pageController.page!.toInt();
    if (newPageIndex != _currentVideoIndex &&
        newPageIndex >= 0 &&
        newPageIndex < videoUrls.length) {
      setState(() {
        _initializeVideoController(newPageIndex);
        _currentVideoIndex = newPageIndex;
      });
    }
  }

  @override
  void dispose() {
    _controller?.removeListener(_onVideoStateChange);
    _controller?.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  Future<void> applyLiveWallpaper(String videoUrl) async {
    String result;
    try {
      final httpUrl = await _getVideoUrl(_currentVideoIndex);

      var file = await DefaultCacheManager().getSingleFile(httpUrl);
      await _controller?.pause();
      result = await AsyncWallpaper.setLiveWallpaper(
        filePath: file.path,
      )
          ? 'Live wallpaper set'
          : 'Failed to set live wallpaper.';
    } catch (e) {
      print('Error applying live wallpaper: $e');
      result = 'Failed to set live wallpaper.';
    }
    print(result);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Color backgroundColor = Theme.of(context).colorScheme.background;
    Color primaryColor = Theme.of(context).colorScheme.primary;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: backgroundColor,
        title: Text(
          'Cars',
          style: GoogleFonts.kanit(
            color: primaryColor,
            fontSize: 22,
          ),
        ),
      ),
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          GestureDetector(
            child: PageView.builder(
              physics: ClampingScrollPhysics(),
              scrollDirection: Axis.vertical,
              padEnds: true,
              controller: _pageController,
              itemCount: videoUrls.length,
              itemBuilder: (context, index) {
                return Center(
                  child: _videoInitialized && _controller != null
                      ? Visibility(
                          visible: index == _currentVideoIndex,
                          child: AnimatedSwitcher(
                            duration: Duration(milliseconds: 100),
                            child: _controller!.value.isInitialized
                                ? VideoPlayer(_controller!)
                                : Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      VideoPlayer(_controller!),
                                      CircularProgressIndicator(),
                                    ],
                                  ),
                          ),
                        )
                      : CircularProgressIndicator(),
                );
              },
            ),
            onTap: () {
              setState(() {
                _isPlaying = !_isPlaying;
                _isPlaying ? _controller!.play() : _controller!.pause();
              });
            },
          ),
          if (!_isPlaying && _videoInitialized)
            Center(
              child: IconButton(
                icon: Icon(
                  Icons.play_arrow,
                  size: 48,
                ),
                onPressed: () {
                  setState(() {
                    _isPlaying = true;
                    _controller!.play();
                  });
                },
              ),
            ),
          Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: () async {
                if (_videoInitialized) {
                  await applyLiveWallpaper(videoUrls[_currentVideoIndex]);
                }
              },
              child: Container(
                height: 50,
                width: 200,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Apply Wallpaper',
                    style: GoogleFonts.kanit(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 22,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//##############################################################################################################################
//##############################################################################################################################
//##############################################################################################################################

class AnimeWallpaper extends StatefulWidget {
  @override
  _AnimeWallpaperState createState() => _AnimeWallpaperState();
}

class _AnimeWallpaperState extends State<AnimeWallpaper>
    with AutomaticKeepAliveClientMixin<AnimeWallpaper> {
  PageController _pageController = PageController();
  List<String> videoUrls = [];
  int _currentVideoIndex = 0;
  VideoPlayerController? _controller;
  bool _isPlaying = true;
  bool _videoInitialized = false;

  @override
  void initState() {
    super.initState();
    _fetchVideoUrls();
    _pageController.addListener(_onPageChange);
  }

  Future<void> _fetchVideoUrls() async {
    final storageRef = FirebaseStorage.instance.ref('live');
    final ListResult result = await storageRef.listAll();

    setState(() {
      videoUrls = result.items.map((item) => item.fullPath).toList();
    });

    _initializeVideoController(_currentVideoIndex);
  }

  void _initializeVideoController(int index) async {
    _controller?.dispose();
    final videoUrl = await _getVideoUrl(index);

    final cachedVideo = await DefaultCacheManager().getFileFromCache(videoUrl);

    if (cachedVideo != null && cachedVideo.file.existsSync()) {
      _controller = VideoPlayerController.file(cachedVideo.file)
        ..initialize().then((_) {
          setState(() {
            _videoInitialized = true;
          });
          _controller!.play();
          _controller!.setLooping(true);
          _isPlaying = true;
        });
    } else {
      var file = await DefaultCacheManager().getSingleFile(videoUrl);
      _controller = VideoPlayerController.file(file)
        ..initialize().then((_) {
          setState(() {
            _videoInitialized = true;
          });
          _controller!.play();
          _controller!.setLooping(true);
          _isPlaying = true;
        });
    }

    _controller!.addListener(_onVideoStateChange);
  }

  Future<String> _getVideoUrl(int index) async {
    final ref = FirebaseStorage.instance.ref(videoUrls[index]);
    final url = await ref.getDownloadURL();
    return url;
  }

  void _onVideoStateChange() {
    if (_controller!.value.isPlaying != _isPlaying) {
      setState(() {
        _isPlaying = _controller!.value.isPlaying;
      });
    }
  }

  void _onPageChange() {
    int newPageIndex = _pageController.page!.toInt();
    if (newPageIndex != _currentVideoIndex &&
        newPageIndex >= 0 &&
        newPageIndex < videoUrls.length) {
      setState(() {
        _initializeVideoController(newPageIndex);
        _currentVideoIndex = newPageIndex;
      });
    }
  }

  @override
  void dispose() {
    _controller?.removeListener(_onVideoStateChange);
    _controller?.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  Future<void> applyLiveWallpaper(String videoUrl) async {
    String result;
    try {
      final httpUrl = await _getVideoUrl(_currentVideoIndex);

      var file = await DefaultCacheManager().getSingleFile(httpUrl);
      await _controller?.pause();
      result = await AsyncWallpaper.setLiveWallpaper(
        filePath: file.path,
      )
          ? 'Live wallpaper set'
          : 'Failed to set live wallpaper.';
    } catch (e) {
      print('Error applying live wallpaper: $e');
      result = 'Failed to set live wallpaper.';
    }
    print(result);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Color backgroundColor = Theme.of(context).colorScheme.background;
    Color primaryColor = Theme.of(context).colorScheme.primary;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: backgroundColor,
        title: Text(
          'Anime',
          style: GoogleFonts.kanit(
            color: primaryColor,
            fontSize: 22,
          ),
        ),
      ),
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          GestureDetector(
            child: PageView.builder(
              physics: ClampingScrollPhysics(),
              scrollDirection: Axis.vertical,
              padEnds: true,
              controller: _pageController,
              itemCount: videoUrls.length,
              itemBuilder: (context, index) {
                return Center(
                  child: _videoInitialized && _controller != null
                      ? Visibility(
                          visible: index == _currentVideoIndex,
                          child: AnimatedSwitcher(
                            duration: Duration(milliseconds: 100),
                            child: _controller!.value.isInitialized
                                ? VideoPlayer(_controller!)
                                : Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      VideoPlayer(_controller!),
                                      CircularProgressIndicator(),
                                    ],
                                  ),
                          ),
                        )
                      : CircularProgressIndicator(),
                );
              },
            ),
            onTap: () {
              setState(() {
                _isPlaying = !_isPlaying;
                _isPlaying ? _controller!.play() : _controller!.pause();
              });
            },
          ),
          if (!_isPlaying && _videoInitialized)
            Center(
              child: IconButton(
                icon: Icon(
                  Icons.play_arrow,
                  size: 48,
                ),
                onPressed: () {
                  setState(() {
                    _isPlaying = true;
                    _controller!.play();
                  });
                },
              ),
            ),
          Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: () async {
                if (_videoInitialized) {
                  await applyLiveWallpaper(videoUrls[_currentVideoIndex]);
                }
              },
              child: Container(
                height: 50,
                width: 200,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Apply Wallpaper',
                    style: GoogleFonts.kanit(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 22,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//##############################################################################################################################
//##############################################################################################################################
//##############################################################################################################################

class NatureWallpaper extends StatefulWidget {
  @override
  _NatureWallpaperState createState() => _NatureWallpaperState();
}

class _NatureWallpaperState extends State<NatureWallpaper>
    with AutomaticKeepAliveClientMixin<NatureWallpaper> {
  PageController _pageController = PageController();
  List<String> videoUrls = [];
  int _currentVideoIndex = 0;
  VideoPlayerController? _controller;
  bool _isPlaying = true;
  bool _videoInitialized = false;

  @override
  void initState() {
    super.initState();
    _fetchVideoUrls();
    _pageController.addListener(_onPageChange);
  }

  Future<void> _fetchVideoUrls() async {
    final storageRef = FirebaseStorage.instance.ref('live');
    final ListResult result = await storageRef.listAll();

    setState(() {
      videoUrls = result.items.map((item) => item.fullPath).toList();
    });

    _initializeVideoController(_currentVideoIndex);
  }

  void _initializeVideoController(int index) async {
    _controller?.dispose();
    final videoUrl = await _getVideoUrl(index);

    final cachedVideo = await DefaultCacheManager().getFileFromCache(videoUrl);

    if (cachedVideo != null && cachedVideo.file.existsSync()) {
      _controller = VideoPlayerController.file(cachedVideo.file)
        ..initialize().then((_) {
          setState(() {
            _videoInitialized = true;
          });
          _controller!.play();
          _controller!.setLooping(true);
          _isPlaying = true;
        });
    } else {
      var file = await DefaultCacheManager().getSingleFile(videoUrl);
      _controller = VideoPlayerController.file(file)
        ..initialize().then((_) {
          setState(() {
            _videoInitialized = true;
          });
          _controller!.play();
          _controller!.setLooping(true);
          _isPlaying = true;
        });
    }

    _controller!.addListener(_onVideoStateChange);
  }

  Future<String> _getVideoUrl(int index) async {
    final ref = FirebaseStorage.instance.ref(videoUrls[index]);
    final url = await ref.getDownloadURL();
    return url;
  }

  void _onVideoStateChange() {
    if (_controller!.value.isPlaying != _isPlaying) {
      setState(() {
        _isPlaying = _controller!.value.isPlaying;
      });
    }
  }

  void _onPageChange() {
    int newPageIndex = _pageController.page!.toInt();
    if (newPageIndex != _currentVideoIndex &&
        newPageIndex >= 0 &&
        newPageIndex < videoUrls.length) {
      setState(() {
        _initializeVideoController(newPageIndex);
        _currentVideoIndex = newPageIndex;
      });
    }
  }

  @override
  void dispose() {
    _controller?.removeListener(_onVideoStateChange);
    _controller?.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  Future<void> applyLiveWallpaper(String videoUrl) async {
    String result;
    try {
      final httpUrl = await _getVideoUrl(_currentVideoIndex);

      var file = await DefaultCacheManager().getSingleFile(httpUrl);
      await _controller?.pause();
      result = await AsyncWallpaper.setLiveWallpaper(
        filePath: file.path,
      )
          ? 'Live wallpaper set'
          : 'Failed to set live wallpaper.';
    } catch (e) {
      print('Error applying live wallpaper: $e');
      result = 'Failed to set live wallpaper.';
    }
    print(result);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Color backgroundColor = Theme.of(context).colorScheme.background;
    Color primaryColor = Theme.of(context).colorScheme.primary;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: backgroundColor,
        title: Text(
          'Nature',
          style: GoogleFonts.kanit(
            color: primaryColor,
            fontSize: 22,
          ),
        ),
      ),
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          GestureDetector(
            child: PageView.builder(
              physics: ClampingScrollPhysics(),
              scrollDirection: Axis.vertical,
              padEnds: true,
              controller: _pageController,
              itemCount: videoUrls.length,
              itemBuilder: (context, index) {
                return Center(
                  child: _videoInitialized && _controller != null
                      ? Visibility(
                          visible: index == _currentVideoIndex,
                          child: AnimatedSwitcher(
                            duration: Duration(milliseconds: 100),
                            child: _controller!.value.isInitialized
                                ? VideoPlayer(_controller!)
                                : Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      VideoPlayer(_controller!),
                                      CircularProgressIndicator(),
                                    ],
                                  ),
                          ),
                        )
                      : CircularProgressIndicator(),
                );
              },
            ),
            onTap: () {
              setState(() {
                _isPlaying = !_isPlaying;
                _isPlaying ? _controller!.play() : _controller!.pause();
              });
            },
          ),
          if (!_isPlaying && _videoInitialized)
            Center(
              child: IconButton(
                icon: Icon(
                  Icons.play_arrow,
                  size: 48,
                ),
                onPressed: () {
                  setState(() {
                    _isPlaying = true;
                    _controller!.play();
                  });
                },
              ),
            ),
          Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: () async {
                if (_videoInitialized) {
                  await applyLiveWallpaper(videoUrls[_currentVideoIndex]);
                }
              },
              child: Container(
                height: 50,
                width: 200,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Apply Wallpaper',
                    style: GoogleFonts.kanit(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 22,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//##############################################################################################################################
//##############################################################################################################################
//##############################################################################################################################

class CyberWorldWallpaper extends StatefulWidget {
  @override
  _CyberWorldWallpaperState createState() => _CyberWorldWallpaperState();
}

class _CyberWorldWallpaperState extends State<CyberWorldWallpaper>
    with AutomaticKeepAliveClientMixin<CyberWorldWallpaper> {
  PageController _pageController = PageController();
  List<String> videoUrls = [];
  int _currentVideoIndex = 0;
  VideoPlayerController? _controller;
  bool _isPlaying = true;
  bool _videoInitialized = false;

  @override
  void initState() {
    super.initState();
    _fetchVideoUrls();
    _pageController.addListener(_onPageChange);
  }

  Future<void> _fetchVideoUrls() async {
    final storageRef = FirebaseStorage.instance.ref('live');
    final ListResult result = await storageRef.listAll();

    setState(() {
      videoUrls = result.items.map((item) => item.fullPath).toList();
    });

    _initializeVideoController(_currentVideoIndex);
  }

  void _initializeVideoController(int index) async {
    _controller?.dispose();
    final videoUrl = await _getVideoUrl(index);

    final cachedVideo = await DefaultCacheManager().getFileFromCache(videoUrl);

    if (cachedVideo != null && cachedVideo.file.existsSync()) {
      _controller = VideoPlayerController.file(cachedVideo.file)
        ..initialize().then((_) {
          setState(() {
            _videoInitialized = true;
          });
          _controller!.play();
          _controller!.setLooping(true);
          _isPlaying = true;
        });
    } else {
      var file = await DefaultCacheManager().getSingleFile(videoUrl);
      _controller = VideoPlayerController.file(file)
        ..initialize().then((_) {
          setState(() {
            _videoInitialized = true;
          });
          _controller!.play();
          _controller!.setLooping(true);
          _isPlaying = true;
        });
    }

    _controller!.addListener(_onVideoStateChange);
  }

  Future<String> _getVideoUrl(int index) async {
    final ref = FirebaseStorage.instance.ref(videoUrls[index]);
    final url = await ref.getDownloadURL();
    return url;
  }

  void _onVideoStateChange() {
    if (_controller!.value.isPlaying != _isPlaying) {
      setState(() {
        _isPlaying = _controller!.value.isPlaying;
      });
    }
  }

  void _onPageChange() {
    int newPageIndex = _pageController.page!.toInt();
    if (newPageIndex != _currentVideoIndex &&
        newPageIndex >= 0 &&
        newPageIndex < videoUrls.length) {
      setState(() {
        _initializeVideoController(newPageIndex);
        _currentVideoIndex = newPageIndex;
      });
    }
  }

  @override
  void dispose() {
    _controller?.removeListener(_onVideoStateChange);
    _controller?.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  Future<void> applyLiveWallpaper(String videoUrl) async {
    String result;
    try {
      final httpUrl = await _getVideoUrl(_currentVideoIndex);

      var file = await DefaultCacheManager().getSingleFile(httpUrl);
      await _controller?.pause();
      result = await AsyncWallpaper.setLiveWallpaper(
        filePath: file.path,
      )
          ? 'Live wallpaper set'
          : 'Failed to set live wallpaper.';
    } catch (e) {
      print('Error applying live wallpaper: $e');
      result = 'Failed to set live wallpaper.';
    }
    print(result);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Color backgroundColor = Theme.of(context).colorScheme.background;
    Color primaryColor = Theme.of(context).colorScheme.primary;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: backgroundColor,
        title: Text(
          'CyberWorld',
          style: GoogleFonts.kanit(
            color: primaryColor,
            fontSize: 22,
          ),
        ),
      ),
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          GestureDetector(
            child: PageView.builder(
              physics: ClampingScrollPhysics(),
              scrollDirection: Axis.vertical,
              padEnds: true,
              controller: _pageController,
              itemCount: videoUrls.length,
              itemBuilder: (context, index) {
                return Center(
                  child: _videoInitialized && _controller != null
                      ? Visibility(
                          visible: index == _currentVideoIndex,
                          child: AnimatedSwitcher(
                            duration: Duration(milliseconds: 100),
                            child: _controller!.value.isInitialized
                                ? VideoPlayer(_controller!)
                                : Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      VideoPlayer(_controller!),
                                      CircularProgressIndicator(),
                                    ],
                                  ),
                          ),
                        )
                      : CircularProgressIndicator(),
                );
              },
            ),
            onTap: () {
              setState(() {
                _isPlaying = !_isPlaying;
                _isPlaying ? _controller!.play() : _controller!.pause();
              });
            },
          ),
          if (!_isPlaying && _videoInitialized)
            Center(
              child: IconButton(
                icon: Icon(
                  Icons.play_arrow,
                  size: 48,
                ),
                onPressed: () {
                  setState(() {
                    _isPlaying = true;
                    _controller!.play();
                  });
                },
              ),
            ),
          Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: () async {
                if (_videoInitialized) {
                  await applyLiveWallpaper(videoUrls[_currentVideoIndex]);
                }
              },
              child: Container(
                height: 50,
                width: 200,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Apply Wallpaper',
                    style: GoogleFonts.kanit(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 22,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//##############################################################################################################################
//##############################################################################################################################
//##############################################################################################################################

class GamesWallpaper extends StatefulWidget {
  @override
  _GamesWallpaperState createState() => _GamesWallpaperState();
}

class _GamesWallpaperState extends State<GamesWallpaper>
    with AutomaticKeepAliveClientMixin<GamesWallpaper> {
  PageController _pageController = PageController();
  List<String> videoUrls = [];
  int _currentVideoIndex = 0;
  VideoPlayerController? _controller;
  bool _isPlaying = true;
  bool _videoInitialized = false;

  @override
  void initState() {
    super.initState();
    _fetchVideoUrls();
    _pageController.addListener(_onPageChange);
  }

  Future<void> _fetchVideoUrls() async {
    final storageRef = FirebaseStorage.instance.ref('live');
    final ListResult result = await storageRef.listAll();

    setState(() {
      videoUrls = result.items.map((item) => item.fullPath).toList();
    });

    _initializeVideoController(_currentVideoIndex);
  }

  void _initializeVideoController(int index) async {
    _controller?.dispose();
    final videoUrl = await _getVideoUrl(index);

    final cachedVideo = await DefaultCacheManager().getFileFromCache(videoUrl);

    if (cachedVideo != null && cachedVideo.file.existsSync()) {
      _controller = VideoPlayerController.file(cachedVideo.file)
        ..initialize().then((_) {
          setState(() {
            _videoInitialized = true;
          });
          _controller!.play();
          _controller!.setLooping(true);
          _isPlaying = true;
        });
    } else {
      var file = await DefaultCacheManager().getSingleFile(videoUrl);
      _controller = VideoPlayerController.file(file)
        ..initialize().then((_) {
          setState(() {
            _videoInitialized = true;
          });
          _controller!.play();
          _controller!.setLooping(true);
          _isPlaying = true;
        });
    }

    _controller!.addListener(_onVideoStateChange);
  }

  Future<String> _getVideoUrl(int index) async {
    final ref = FirebaseStorage.instance.ref(videoUrls[index]);
    final url = await ref.getDownloadURL();
    return url;
  }

  void _onVideoStateChange() {
    if (_controller!.value.isPlaying != _isPlaying) {
      setState(() {
        _isPlaying = _controller!.value.isPlaying;
      });
    }
  }

  void _onPageChange() {
    int newPageIndex = _pageController.page!.toInt();
    if (newPageIndex != _currentVideoIndex &&
        newPageIndex >= 0 &&
        newPageIndex < videoUrls.length) {
      setState(() {
        _initializeVideoController(newPageIndex);
        _currentVideoIndex = newPageIndex;
      });
    }
  }

  @override
  void dispose() {
    _controller?.removeListener(_onVideoStateChange);
    _controller?.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  Future<void> applyLiveWallpaper(String videoUrl) async {
    String result;
    try {
      final httpUrl = await _getVideoUrl(_currentVideoIndex);

      var file = await DefaultCacheManager().getSingleFile(httpUrl);
      await _controller?.pause();
      result = await AsyncWallpaper.setLiveWallpaper(
        filePath: file.path,
      )
          ? 'Live wallpaper set'
          : 'Failed to set live wallpaper.';
    } catch (e) {
      print('Error applying live wallpaper: $e');
      result = 'Failed to set live wallpaper.';
    }
    print(result);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Color backgroundColor = Theme.of(context).colorScheme.background;
    Color primaryColor = Theme.of(context).colorScheme.primary;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: backgroundColor,
        title: Text(
          'Games',
          style: GoogleFonts.kanit(
            color: primaryColor,
            fontSize: 22,
          ),
        ),
      ),
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          GestureDetector(
            child: PageView.builder(
              physics: ClampingScrollPhysics(),
              scrollDirection: Axis.vertical,
              padEnds: true,
              controller: _pageController,
              itemCount: videoUrls.length,
              itemBuilder: (context, index) {
                return Center(
                  child: _videoInitialized && _controller != null
                      ? Visibility(
                          visible: index == _currentVideoIndex,
                          child: AnimatedSwitcher(
                            duration: Duration(milliseconds: 100),
                            child: _controller!.value.isInitialized
                                ? VideoPlayer(_controller!)
                                : Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      VideoPlayer(_controller!),
                                      CircularProgressIndicator(),
                                    ],
                                  ),
                          ),
                        )
                      : CircularProgressIndicator(),
                );
              },
            ),
            onTap: () {
              setState(() {
                _isPlaying = !_isPlaying;
                _isPlaying ? _controller!.play() : _controller!.pause();
              });
            },
          ),
          if (!_isPlaying && _videoInitialized)
            Center(
              child: IconButton(
                icon: Icon(
                  Icons.play_arrow,
                  size: 48,
                ),
                onPressed: () {
                  setState(() {
                    _isPlaying = true;
                    _controller!.play();
                  });
                },
              ),
            ),
          Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: () async {
                if (_videoInitialized) {
                  await applyLiveWallpaper(videoUrls[_currentVideoIndex]);
                }
              },
              child: Container(
                height: 50,
                width: 200,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Apply Wallpaper',
                    style: GoogleFonts.kanit(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 22,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//##############################################################################################################################
//##############################################################################################################################
//##############################################################################################################################

class FantasyWallpaper extends StatefulWidget {
  @override
  _FantasyWallpaperState createState() => _FantasyWallpaperState();
}

class _FantasyWallpaperState extends State<FantasyWallpaper>
    with AutomaticKeepAliveClientMixin<FantasyWallpaper> {
  PageController _pageController = PageController();
  List<String> videoUrls = [];
  int _currentVideoIndex = 0;
  VideoPlayerController? _controller;
  bool _isPlaying = true;
  bool _videoInitialized = false;

  @override
  void initState() {
    super.initState();
    _fetchVideoUrls();
    _pageController.addListener(_onPageChange);
  }

  Future<void> _fetchVideoUrls() async {
    final storageRef = FirebaseStorage.instance.ref('live');
    final ListResult result = await storageRef.listAll();

    setState(() {
      videoUrls = result.items.map((item) => item.fullPath).toList();
    });

    _initializeVideoController(_currentVideoIndex);
  }

  void _initializeVideoController(int index) async {
    _controller?.dispose();
    final videoUrl = await _getVideoUrl(index);

    final cachedVideo = await DefaultCacheManager().getFileFromCache(videoUrl);

    if (cachedVideo != null && cachedVideo.file.existsSync()) {
      _controller = VideoPlayerController.file(cachedVideo.file)
        ..initialize().then((_) {
          setState(() {
            _videoInitialized = true;
          });
          _controller!.play();
          _controller!.setLooping(true);
          _isPlaying = true;
        });
    } else {
      var file = await DefaultCacheManager().getSingleFile(videoUrl);
      _controller = VideoPlayerController.file(file)
        ..initialize().then((_) {
          setState(() {
            _videoInitialized = true;
          });
          _controller!.play();
          _controller!.setLooping(true);
          _isPlaying = true;
        });
    }

    _controller!.addListener(_onVideoStateChange);
  }

  Future<String> _getVideoUrl(int index) async {
    final ref = FirebaseStorage.instance.ref(videoUrls[index]);
    final url = await ref.getDownloadURL();
    return url;
  }

  void _onVideoStateChange() {
    if (_controller!.value.isPlaying != _isPlaying) {
      setState(() {
        _isPlaying = _controller!.value.isPlaying;
      });
    }
  }

  void _onPageChange() {
    int newPageIndex = _pageController.page!.toInt();
    if (newPageIndex != _currentVideoIndex &&
        newPageIndex >= 0 &&
        newPageIndex < videoUrls.length) {
      setState(() {
        _initializeVideoController(newPageIndex);
        _currentVideoIndex = newPageIndex;
      });
    }
  }

  @override
  void dispose() {
    _controller?.removeListener(_onVideoStateChange);
    _controller?.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  Future<void> applyLiveWallpaper(String videoUrl) async {
    String result;
    try {
      final httpUrl = await _getVideoUrl(_currentVideoIndex);

      var file = await DefaultCacheManager().getSingleFile(httpUrl);
      await _controller?.pause();
      result = await AsyncWallpaper.setLiveWallpaper(
        filePath: file.path,
      )
          ? 'Live wallpaper set'
          : 'Failed to set live wallpaper.';
    } catch (e) {
      print('Error applying live wallpaper: $e');
      result = 'Failed to set live wallpaper.';
    }
    print(result);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Color backgroundColor = Theme.of(context).colorScheme.background;
    Color primaryColor = Theme.of(context).colorScheme.primary;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: backgroundColor,
        title: Text(
          'Fantasy',
          style: GoogleFonts.kanit(
            color: primaryColor,
            fontSize: 22,
          ),
        ),
      ),
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          GestureDetector(
            child: PageView.builder(
              physics: ClampingScrollPhysics(),
              scrollDirection: Axis.vertical,
              padEnds: true,
              controller: _pageController,
              itemCount: videoUrls.length,
              itemBuilder: (context, index) {
                return Center(
                  child: _videoInitialized && _controller != null
                      ? Visibility(
                          visible: index == _currentVideoIndex,
                          child: AnimatedSwitcher(
                            duration: Duration(milliseconds: 100),
                            child: _controller!.value.isInitialized
                                ? VideoPlayer(_controller!)
                                : Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      VideoPlayer(_controller!),
                                      CircularProgressIndicator(),
                                    ],
                                  ),
                          ),
                        )
                      : CircularProgressIndicator(),
                );
              },
            ),
            onTap: () {
              setState(() {
                _isPlaying = !_isPlaying;
                _isPlaying ? _controller!.play() : _controller!.pause();
              });
            },
          ),
          if (!_isPlaying && _videoInitialized)
            Center(
              child: IconButton(
                icon: Icon(
                  Icons.play_arrow,
                  size: 48,
                ),
                onPressed: () {
                  setState(() {
                    _isPlaying = true;
                    _controller!.play();
                  });
                },
              ),
            ),
          Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: () async {
                if (_videoInitialized) {
                  await applyLiveWallpaper(videoUrls[_currentVideoIndex]);
                }
              },
              child: Container(
                height: 50,
                width: 200,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Apply Wallpaper',
                    style: GoogleFonts.kanit(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 22,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//##############################################################################################################################
//##############################################################################################################################
//##############################################################################################################################

class EnvironmentsWallpaper extends StatefulWidget {
  @override
  _EnvironmentsWallpaperState createState() => _EnvironmentsWallpaperState();
}

class _EnvironmentsWallpaperState extends State<EnvironmentsWallpaper>
    with AutomaticKeepAliveClientMixin<EnvironmentsWallpaper> {
  PageController _pageController = PageController();
  List<String> videoUrls = [];
  int _currentVideoIndex = 0;
  VideoPlayerController? _controller;
  bool _isPlaying = true;
  bool _videoInitialized = false;

  @override
  void initState() {
    super.initState();
    _fetchVideoUrls();
    _pageController.addListener(_onPageChange);
  }

  Future<void> _fetchVideoUrls() async {
    final storageRef = FirebaseStorage.instance.ref('live');
    final ListResult result = await storageRef.listAll();

    setState(() {
      videoUrls = result.items.map((item) => item.fullPath).toList();
    });

    _initializeVideoController(_currentVideoIndex);
  }

  void _initializeVideoController(int index) async {
    _controller?.dispose();
    final videoUrl = await _getVideoUrl(index);

    final cachedVideo = await DefaultCacheManager().getFileFromCache(videoUrl);

    if (cachedVideo != null && cachedVideo.file.existsSync()) {
      _controller = VideoPlayerController.file(cachedVideo.file)
        ..initialize().then((_) {
          setState(() {
            _videoInitialized = true;
          });
          _controller!.play();
          _controller!.setLooping(true);
          _isPlaying = true;
        });
    } else {
      var file = await DefaultCacheManager().getSingleFile(videoUrl);
      _controller = VideoPlayerController.file(file)
        ..initialize().then((_) {
          setState(() {
            _videoInitialized = true;
          });
          _controller!.play();
          _controller!.setLooping(true);
          _isPlaying = true;
        });
    }

    _controller!.addListener(_onVideoStateChange);
  }

  Future<String> _getVideoUrl(int index) async {
    final ref = FirebaseStorage.instance.ref(videoUrls[index]);
    final url = await ref.getDownloadURL();
    return url;
  }

  void _onVideoStateChange() {
    if (_controller!.value.isPlaying != _isPlaying) {
      setState(() {
        _isPlaying = _controller!.value.isPlaying;
      });
    }
  }

  void _onPageChange() {
    int newPageIndex = _pageController.page!.toInt();
    if (newPageIndex != _currentVideoIndex &&
        newPageIndex >= 0 &&
        newPageIndex < videoUrls.length) {
      setState(() {
        _initializeVideoController(newPageIndex);
        _currentVideoIndex = newPageIndex;
      });
    }
  }

  @override
  void dispose() {
    _controller?.removeListener(_onVideoStateChange);
    _controller?.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  Future<void> applyLiveWallpaper(String videoUrl) async {
    String result;
    try {
      final httpUrl = await _getVideoUrl(_currentVideoIndex);

      var file = await DefaultCacheManager().getSingleFile(httpUrl);
      await _controller?.pause();
      result = await AsyncWallpaper.setLiveWallpaper(
        filePath: file.path,
      )
          ? 'Live wallpaper set'
          : 'Failed to set live wallpaper.';
    } catch (e) {
      print('Error applying live wallpaper: $e');
      result = 'Failed to set live wallpaper.';
    }
    print(result);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Color backgroundColor = Theme.of(context).colorScheme.background;
    Color primaryColor = Theme.of(context).colorScheme.primary;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: backgroundColor,
        title: Text(
          'Environments',
          style: GoogleFonts.kanit(
            color: primaryColor,
            fontSize: 22,
          ),
        ),
      ),
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          GestureDetector(
            child: PageView.builder(
              physics: ClampingScrollPhysics(),
              scrollDirection: Axis.vertical,
              padEnds: true,
              controller: _pageController,
              itemCount: videoUrls.length,
              itemBuilder: (context, index) {
                return Center(
                  child: _videoInitialized && _controller != null
                      ? Visibility(
                          visible: index == _currentVideoIndex,
                          child: AnimatedSwitcher(
                            duration: Duration(milliseconds: 100),
                            child: _controller!.value.isInitialized
                                ? VideoPlayer(_controller!)
                                : Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      VideoPlayer(_controller!),
                                      CircularProgressIndicator(),
                                    ],
                                  ),
                          ),
                        )
                      : CircularProgressIndicator(),
                );
              },
            ),
            onTap: () {
              setState(() {
                _isPlaying = !_isPlaying;
                _isPlaying ? _controller!.play() : _controller!.pause();
              });
            },
          ),
          if (!_isPlaying && _videoInitialized)
            Center(
              child: IconButton(
                icon: Icon(
                  Icons.play_arrow,
                  size: 48,
                ),
                onPressed: () {
                  setState(() {
                    _isPlaying = true;
                    _controller!.play();
                  });
                },
              ),
            ),
          Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: () async {
                if (_videoInitialized) {
                  await applyLiveWallpaper(videoUrls[_currentVideoIndex]);
                }
              },
              child: Container(
                height: 50,
                width: 200,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Apply Wallpaper',
                    style: GoogleFonts.kanit(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 22,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//##############################################################################################################################
//##############################################################################################################################
//##############################################################################################################################

class AbstractWallpaper extends StatefulWidget {
  @override
  _AbstractWallpaperState createState() => _AbstractWallpaperState();
}

class _AbstractWallpaperState extends State<AbstractWallpaper>
    with AutomaticKeepAliveClientMixin<AbstractWallpaper> {
  PageController _pageController = PageController();
  List<String> videoUrls = [];
  int _currentVideoIndex = 0;
  VideoPlayerController? _controller;
  bool _isPlaying = true;
  bool _videoInitialized = false;

  @override
  void initState() {
    super.initState();
    _fetchVideoUrls();
    _pageController.addListener(_onPageChange);
  }

  Future<void> _fetchVideoUrls() async {
    final storageRef = FirebaseStorage.instance.ref('live');
    final ListResult result = await storageRef.listAll();

    setState(() {
      videoUrls = result.items.map((item) => item.fullPath).toList();
    });

    _initializeVideoController(_currentVideoIndex);
  }

  void _initializeVideoController(int index) async {
    _controller?.dispose();
    final videoUrl = await _getVideoUrl(index);

    final cachedVideo = await DefaultCacheManager().getFileFromCache(videoUrl);

    if (cachedVideo != null && cachedVideo.file.existsSync()) {
      _controller = VideoPlayerController.file(cachedVideo.file)
        ..initialize().then((_) {
          setState(() {
            _videoInitialized = true;
          });
          _controller!.play();
          _controller!.setLooping(true);
          _isPlaying = true;
        });
    } else {
      var file = await DefaultCacheManager().getSingleFile(videoUrl);
      _controller = VideoPlayerController.file(file)
        ..initialize().then((_) {
          setState(() {
            _videoInitialized = true;
          });
          _controller!.play();
          _controller!.setLooping(true);
          _isPlaying = true;
        });
    }

    _controller!.addListener(_onVideoStateChange);
  }

  Future<String> _getVideoUrl(int index) async {
    final ref = FirebaseStorage.instance.ref(videoUrls[index]);
    final url = await ref.getDownloadURL();
    return url;
  }

  void _onVideoStateChange() {
    if (_controller!.value.isPlaying != _isPlaying) {
      setState(() {
        _isPlaying = _controller!.value.isPlaying;
      });
    }
  }

  void _onPageChange() {
    int newPageIndex = _pageController.page!.toInt();
    if (newPageIndex != _currentVideoIndex &&
        newPageIndex >= 0 &&
        newPageIndex < videoUrls.length) {
      setState(() {
        _initializeVideoController(newPageIndex);
        _currentVideoIndex = newPageIndex;
      });
    }
  }

  @override
  void dispose() {
    _controller?.removeListener(_onVideoStateChange);
    _controller?.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  Future<void> applyLiveWallpaper(String videoUrl) async {
    String result;
    try {
      final httpUrl = await _getVideoUrl(_currentVideoIndex);

      var file = await DefaultCacheManager().getSingleFile(httpUrl);
      await _controller?.pause();
      result = await AsyncWallpaper.setLiveWallpaper(
        filePath: file.path,
      )
          ? 'Live wallpaper set'
          : 'Failed to set live wallpaper.';
    } catch (e) {
      print('Error applying live wallpaper: $e');
      result = 'Failed to set live wallpaper.';
    }
    print(result);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Color backgroundColor = Theme.of(context).colorScheme.background;
    Color primaryColor = Theme.of(context).colorScheme.primary;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: backgroundColor,
        title: Text(
          'Abstract',
          style: GoogleFonts.kanit(
            color: primaryColor,
            fontSize: 22,
          ),
        ),
      ),
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          GestureDetector(
            child: PageView.builder(
              physics: ClampingScrollPhysics(),
              scrollDirection: Axis.vertical,
              padEnds: true,
              controller: _pageController,
              itemCount: videoUrls.length,
              itemBuilder: (context, index) {
                return Center(
                  child: _videoInitialized && _controller != null
                      ? Visibility(
                          visible: index == _currentVideoIndex,
                          child: AnimatedSwitcher(
                            duration: Duration(milliseconds: 100),
                            child: _controller!.value.isInitialized
                                ? VideoPlayer(_controller!)
                                : Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      VideoPlayer(_controller!),
                                      CircularProgressIndicator(),
                                    ],
                                  ),
                          ),
                        )
                      : CircularProgressIndicator(),
                );
              },
            ),
            onTap: () {
              setState(() {
                _isPlaying = !_isPlaying;
                _isPlaying ? _controller!.play() : _controller!.pause();
              });
            },
          ),
          if (!_isPlaying && _videoInitialized)
            Center(
              child: IconButton(
                icon: Icon(
                  Icons.play_arrow,
                  size: 48,
                ),
                onPressed: () {
                  setState(() {
                    _isPlaying = true;
                    _controller!.play();
                  });
                },
              ),
            ),
          Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: () async {
                if (_videoInitialized) {
                  await applyLiveWallpaper(videoUrls[_currentVideoIndex]);
                }
              },
              child: Container(
                height: 50,
                width: 200,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Apply Wallpaper',
                    style: GoogleFonts.kanit(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 22,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//##############################################################################################################################
//##############################################################################################################################
//##############################################################################################################################

class AquaticWallpaper extends StatefulWidget {
  @override
  _AquaticWallpaperState createState() => _AquaticWallpaperState();
}

class _AquaticWallpaperState extends State<AquaticWallpaper>
    with AutomaticKeepAliveClientMixin<AquaticWallpaper> {
  PageController _pageController = PageController();
  List<String> videoUrls = [];
  int _currentVideoIndex = 0;
  VideoPlayerController? _controller;
  bool _isPlaying = true;
  bool _videoInitialized = false;

  @override
  void initState() {
    super.initState();
    _fetchVideoUrls();
    _pageController.addListener(_onPageChange);
  }

  Future<void> _fetchVideoUrls() async {
    final storageRef = FirebaseStorage.instance.ref('live');
    final ListResult result = await storageRef.listAll();

    setState(() {
      videoUrls = result.items.map((item) => item.fullPath).toList();
    });

    _initializeVideoController(_currentVideoIndex);
  }

  void _initializeVideoController(int index) async {
    _controller?.dispose();
    final videoUrl = await _getVideoUrl(index);

    final cachedVideo = await DefaultCacheManager().getFileFromCache(videoUrl);

    if (cachedVideo != null && cachedVideo.file.existsSync()) {
      _controller = VideoPlayerController.file(cachedVideo.file)
        ..initialize().then((_) {
          setState(() {
            _videoInitialized = true;
          });
          _controller!.play();
          _controller!.setLooping(true);
          _isPlaying = true;
        });
    } else {
      var file = await DefaultCacheManager().getSingleFile(videoUrl);
      _controller = VideoPlayerController.file(file)
        ..initialize().then((_) {
          setState(() {
            _videoInitialized = true;
          });
          _controller!.play();
          _controller!.setLooping(true);
          _isPlaying = true;
        });
    }

    _controller!.addListener(_onVideoStateChange);
  }

  Future<String> _getVideoUrl(int index) async {
    final ref = FirebaseStorage.instance.ref(videoUrls[index]);
    final url = await ref.getDownloadURL();
    return url;
  }

  void _onVideoStateChange() {
    if (_controller!.value.isPlaying != _isPlaying) {
      setState(() {
        _isPlaying = _controller!.value.isPlaying;
      });
    }
  }

  void _onPageChange() {
    int newPageIndex = _pageController.page!.toInt();
    if (newPageIndex != _currentVideoIndex &&
        newPageIndex >= 0 &&
        newPageIndex < videoUrls.length) {
      setState(() {
        _initializeVideoController(newPageIndex);
        _currentVideoIndex = newPageIndex;
      });
    }
  }

  @override
  void dispose() {
    _controller?.removeListener(_onVideoStateChange);
    _controller?.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  Future<void> applyLiveWallpaper(String videoUrl) async {
    String result;
    try {
      final httpUrl = await _getVideoUrl(_currentVideoIndex);

      var file = await DefaultCacheManager().getSingleFile(httpUrl);
      await _controller?.pause();
      result = await AsyncWallpaper.setLiveWallpaper(
        filePath: file.path,
      )
          ? 'Live wallpaper set'
          : 'Failed to set live wallpaper.';
    } catch (e) {
      print('Error applying live wallpaper: $e');
      result = 'Failed to set live wallpaper.';
    }
    print(result);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Color backgroundColor = Theme.of(context).colorScheme.background;
    Color primaryColor = Theme.of(context).colorScheme.primary;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: backgroundColor,
        title: Text(
          'Aquatic',
          style: GoogleFonts.kanit(
            color: primaryColor,
            fontSize: 22,
          ),
        ),
      ),
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          GestureDetector(
            child: PageView.builder(
              physics: ClampingScrollPhysics(),
              scrollDirection: Axis.vertical,
              padEnds: true,
              controller: _pageController,
              itemCount: videoUrls.length,
              itemBuilder: (context, index) {
                return Center(
                  child: _videoInitialized && _controller != null
                      ? Visibility(
                          visible: index == _currentVideoIndex,
                          child: AnimatedSwitcher(
                            duration: Duration(milliseconds: 100),
                            child: _controller!.value.isInitialized
                                ? VideoPlayer(_controller!)
                                : Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      VideoPlayer(_controller!),
                                      CircularProgressIndicator(),
                                    ],
                                  ),
                          ),
                        )
                      : CircularProgressIndicator(),
                );
              },
            ),
            onTap: () {
              setState(() {
                _isPlaying = !_isPlaying;
                _isPlaying ? _controller!.play() : _controller!.pause();
              });
            },
          ),
          if (!_isPlaying && _videoInitialized)
            Center(
              child: IconButton(
                icon: Icon(
                  Icons.play_arrow,
                  size: 48,
                ),
                onPressed: () {
                  setState(() {
                    _isPlaying = true;
                    _controller!.play();
                  });
                },
              ),
            ),
          Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: () async {
                if (_videoInitialized) {
                  await applyLiveWallpaper(videoUrls[_currentVideoIndex]);
                }
              },
              child: Container(
                height: 50,
                width: 200,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Apply Wallpaper',
                    style: GoogleFonts.kanit(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 22,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//##############################################################################################################################
//##############################################################################################################################
//##############################################################################################################################

class SpaceWallpaper extends StatefulWidget {
  @override
  _SpaceWallpaperState createState() => _SpaceWallpaperState();
}

class _SpaceWallpaperState extends State<SpaceWallpaper>
    with AutomaticKeepAliveClientMixin<SpaceWallpaper> {
  PageController _pageController = PageController();
  List<String> videoUrls = [];
  int _currentVideoIndex = 0;
  VideoPlayerController? _controller;
  bool _isPlaying = true;
  bool _videoInitialized = false;

  @override
  void initState() {
    super.initState();
    _fetchVideoUrls();
    _pageController.addListener(_onPageChange);
  }

  Future<void> _fetchVideoUrls() async {
    final storageRef = FirebaseStorage.instance.ref('live');
    final ListResult result = await storageRef.listAll();

    setState(() {
      videoUrls = result.items.map((item) => item.fullPath).toList();
    });

    _initializeVideoController(_currentVideoIndex);
  }

  void _initializeVideoController(int index) async {
    _controller?.dispose();
    final videoUrl = await _getVideoUrl(index);

    final cachedVideo = await DefaultCacheManager().getFileFromCache(videoUrl);

    if (cachedVideo != null && cachedVideo.file.existsSync()) {
      _controller = VideoPlayerController.file(cachedVideo.file)
        ..initialize().then((_) {
          setState(() {
            _videoInitialized = true;
          });
          _controller!.play();
          _controller!.setLooping(true);
          _isPlaying = true;
        });
    } else {
      var file = await DefaultCacheManager().getSingleFile(videoUrl);
      _controller = VideoPlayerController.file(file)
        ..initialize().then((_) {
          setState(() {
            _videoInitialized = true;
          });
          _controller!.play();
          _controller!.setLooping(true);
          _isPlaying = true;
        });
    }

    _controller!.addListener(_onVideoStateChange);
  }

  Future<String> _getVideoUrl(int index) async {
    final ref = FirebaseStorage.instance.ref(videoUrls[index]);
    final url = await ref.getDownloadURL();
    return url;
  }

  void _onVideoStateChange() {
    if (_controller!.value.isPlaying != _isPlaying) {
      setState(() {
        _isPlaying = _controller!.value.isPlaying;
      });
    }
  }

  void _onPageChange() {
    int newPageIndex = _pageController.page!.toInt();
    if (newPageIndex != _currentVideoIndex &&
        newPageIndex >= 0 &&
        newPageIndex < videoUrls.length) {
      setState(() {
        _initializeVideoController(newPageIndex);
        _currentVideoIndex = newPageIndex;
      });
    }
  }

  @override
  void dispose() {
    _controller?.removeListener(_onVideoStateChange);
    _controller?.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  Future<void> applyLiveWallpaper(String videoUrl) async {
    String result;
    try {
      final httpUrl = await _getVideoUrl(_currentVideoIndex);

      var file = await DefaultCacheManager().getSingleFile(httpUrl);
      await _controller?.pause();
      result = await AsyncWallpaper.setLiveWallpaper(
        filePath: file.path,
      )
          ? 'Live wallpaper set'
          : 'Failed to set live wallpaper.';
    } catch (e) {
      print('Error applying live wallpaper: $e');
      result = 'Failed to set live wallpaper.';
    }
    print(result);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Color backgroundColor = Theme.of(context).colorScheme.background;
    Color primaryColor = Theme.of(context).colorScheme.primary;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: backgroundColor,
        title: Text(
          'Space',
          style: GoogleFonts.kanit(
            color: primaryColor,
            fontSize: 22,
          ),
        ),
      ),
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          GestureDetector(
            child: PageView.builder(
              physics: ClampingScrollPhysics(),
              scrollDirection: Axis.vertical,
              padEnds: true,
              controller: _pageController,
              itemCount: videoUrls.length,
              itemBuilder: (context, index) {
                return Center(
                  child: _videoInitialized && _controller != null
                      ? Visibility(
                          visible: index == _currentVideoIndex,
                          child: AnimatedSwitcher(
                            duration: Duration(milliseconds: 100),
                            child: _controller!.value.isInitialized
                                ? VideoPlayer(_controller!)
                                : Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      VideoPlayer(_controller!),
                                      CircularProgressIndicator(),
                                    ],
                                  ),
                          ),
                        )
                      : CircularProgressIndicator(),
                );
              },
            ),
            onTap: () {
              setState(() {
                _isPlaying = !_isPlaying;
                _isPlaying ? _controller!.play() : _controller!.pause();
              });
            },
          ),
          if (!_isPlaying && _videoInitialized)
            Center(
              child: IconButton(
                icon: Icon(
                  Icons.play_arrow,
                  size: 48,
                ),
                onPressed: () {
                  setState(() {
                    _isPlaying = true;
                    _controller!.play();
                  });
                },
              ),
            ),
          Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: () async {
                if (_videoInitialized) {
                  await applyLiveWallpaper(videoUrls[_currentVideoIndex]);
                }
              },
              child: Container(
                height: 50,
                width: 200,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Apply Wallpaper',
                    style: GoogleFonts.kanit(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 22,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//##############################################################################################################################
//##############################################################################################################################
//##############################################################################################################################

class TechnologyWallpaper extends StatefulWidget {
  @override
  _TechnologyWallpaperState createState() => _TechnologyWallpaperState();
}

class _TechnologyWallpaperState extends State<TechnologyWallpaper>
    with AutomaticKeepAliveClientMixin<TechnologyWallpaper> {
  PageController _pageController = PageController();
  List<String> videoUrls = [];
  int _currentVideoIndex = 0;
  VideoPlayerController? _controller;
  bool _isPlaying = true;
  bool _videoInitialized = false;

  @override
  void initState() {
    super.initState();
    _fetchVideoUrls();
    _pageController.addListener(_onPageChange);
  }

  Future<void> _fetchVideoUrls() async {
    final storageRef = FirebaseStorage.instance.ref('live');
    final ListResult result = await storageRef.listAll();

    setState(() {
      videoUrls = result.items.map((item) => item.fullPath).toList();
    });

    _initializeVideoController(_currentVideoIndex);
  }

  void _initializeVideoController(int index) async {
    _controller?.dispose();
    final videoUrl = await _getVideoUrl(index);

    final cachedVideo = await DefaultCacheManager().getFileFromCache(videoUrl);

    if (cachedVideo != null && cachedVideo.file.existsSync()) {
      _controller = VideoPlayerController.file(cachedVideo.file)
        ..initialize().then((_) {
          setState(() {
            _videoInitialized = true;
          });
          _controller!.play();
          _controller!.setLooping(true);
          _isPlaying = true;
        });
    } else {
      var file = await DefaultCacheManager().getSingleFile(videoUrl);
      _controller = VideoPlayerController.file(file)
        ..initialize().then((_) {
          setState(() {
            _videoInitialized = true;
          });
          _controller!.play();
          _controller!.setLooping(true);
          _isPlaying = true;
        });
    }

    _controller!.addListener(_onVideoStateChange);
  }

  Future<String> _getVideoUrl(int index) async {
    final ref = FirebaseStorage.instance.ref(videoUrls[index]);
    final url = await ref.getDownloadURL();
    return url;
  }

  void _onVideoStateChange() {
    if (_controller!.value.isPlaying != _isPlaying) {
      setState(() {
        _isPlaying = _controller!.value.isPlaying;
      });
    }
  }

  void _onPageChange() {
    int newPageIndex = _pageController.page!.toInt();
    if (newPageIndex != _currentVideoIndex &&
        newPageIndex >= 0 &&
        newPageIndex < videoUrls.length) {
      setState(() {
        _initializeVideoController(newPageIndex);
        _currentVideoIndex = newPageIndex;
      });
    }
  }

  @override
  void dispose() {
    _controller?.removeListener(_onVideoStateChange);
    _controller?.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  Future<void> applyLiveWallpaper(String videoUrl) async {
    String result;
    try {
      final httpUrl = await _getVideoUrl(_currentVideoIndex);

      var file = await DefaultCacheManager().getSingleFile(httpUrl);
      await _controller?.pause();
      result = await AsyncWallpaper.setLiveWallpaper(
        filePath: file.path,
      )
          ? 'Live wallpaper set'
          : 'Failed to set live wallpaper.';
    } catch (e) {
      print('Error applying live wallpaper: $e');
      result = 'Failed to set live wallpaper.';
    }
    print(result);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Color backgroundColor = Theme.of(context).colorScheme.background;
    Color primaryColor = Theme.of(context).colorScheme.primary;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: backgroundColor,
        title: Text(
          'Technology',
          style: GoogleFonts.kanit(
            color: primaryColor,
            fontSize: 22,
          ),
        ),
      ),
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          GestureDetector(
            child: PageView.builder(
              physics: ClampingScrollPhysics(),
              scrollDirection: Axis.vertical,
              padEnds: true,
              controller: _pageController,
              itemCount: videoUrls.length,
              itemBuilder: (context, index) {
                return Center(
                  child: _videoInitialized && _controller != null
                      ? Visibility(
                          visible: index == _currentVideoIndex,
                          child: AnimatedSwitcher(
                            duration: Duration(milliseconds: 100),
                            child: _controller!.value.isInitialized
                                ? VideoPlayer(_controller!)
                                : Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      VideoPlayer(_controller!),
                                      CircularProgressIndicator(),
                                    ],
                                  ),
                          ),
                        )
                      : CircularProgressIndicator(),
                );
              },
            ),
            onTap: () {
              setState(() {
                _isPlaying = !_isPlaying;
                _isPlaying ? _controller!.play() : _controller!.pause();
              });
            },
          ),
          if (!_isPlaying && _videoInitialized)
            Center(
              child: IconButton(
                icon: Icon(
                  Icons.play_arrow,
                  size: 48,
                ),
                onPressed: () {
                  setState(() {
                    _isPlaying = true;
                    _controller!.play();
                  });
                },
              ),
            ),
          Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: () async {
                if (_videoInitialized) {
                  await applyLiveWallpaper(videoUrls[_currentVideoIndex]);
                }
              },
              child: Container(
                height: 50,
                width: 200,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Apply Wallpaper',
                    style: GoogleFonts.kanit(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 22,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//##############################################################################################################################
//##############################################################################################################################
//##############################################################################################################################

class AnimalsWallpaper extends StatefulWidget {
  @override
  _AnimalsWallpaperState createState() => _AnimalsWallpaperState();
}

class _AnimalsWallpaperState extends State<AnimalsWallpaper>
    with AutomaticKeepAliveClientMixin<AnimalsWallpaper> {
  PageController _pageController = PageController();
  List<String> videoUrls = [];
  int _currentVideoIndex = 0;
  VideoPlayerController? _controller;
  bool _isPlaying = true;
  bool _videoInitialized = false;

  @override
  void initState() {
    super.initState();
    _fetchVideoUrls();
    _pageController.addListener(_onPageChange);
  }

  Future<void> _fetchVideoUrls() async {
    final storageRef = FirebaseStorage.instance.ref('live');
    final ListResult result = await storageRef.listAll();

    setState(() {
      videoUrls = result.items.map((item) => item.fullPath).toList();
    });

    _initializeVideoController(_currentVideoIndex);
  }

  void _initializeVideoController(int index) async {
    _controller?.dispose();
    final videoUrl = await _getVideoUrl(index);

    final cachedVideo = await DefaultCacheManager().getFileFromCache(videoUrl);

    if (cachedVideo != null && cachedVideo.file.existsSync()) {
      _controller = VideoPlayerController.file(cachedVideo.file)
        ..initialize().then((_) {
          setState(() {
            _videoInitialized = true;
          });
          _controller!.play();
          _controller!.setLooping(true);
          _isPlaying = true;
        });
    } else {
      var file = await DefaultCacheManager().getSingleFile(videoUrl);
      _controller = VideoPlayerController.file(file)
        ..initialize().then((_) {
          setState(() {
            _videoInitialized = true;
          });
          _controller!.play();
          _controller!.setLooping(true);
          _isPlaying = true;
        });
    }

    _controller!.addListener(_onVideoStateChange);
  }

  Future<String> _getVideoUrl(int index) async {
    final ref = FirebaseStorage.instance.ref(videoUrls[index]);
    final url = await ref.getDownloadURL();
    return url;
  }

  void _onVideoStateChange() {
    if (_controller!.value.isPlaying != _isPlaying) {
      setState(() {
        _isPlaying = _controller!.value.isPlaying;
      });
    }
  }

  void _onPageChange() {
    int newPageIndex = _pageController.page!.toInt();
    if (newPageIndex != _currentVideoIndex &&
        newPageIndex >= 0 &&
        newPageIndex < videoUrls.length) {
      setState(() {
        _initializeVideoController(newPageIndex);
        _currentVideoIndex = newPageIndex;
      });
    }
  }

  @override
  void dispose() {
    _controller?.removeListener(_onVideoStateChange);
    _controller?.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  Future<void> applyLiveWallpaper(String videoUrl) async {
    String result;
    try {
      final httpUrl = await _getVideoUrl(_currentVideoIndex);

      var file = await DefaultCacheManager().getSingleFile(httpUrl);
      await _controller?.pause();
      result = await AsyncWallpaper.setLiveWallpaper(
        filePath: file.path,
      )
          ? 'Live wallpaper set'
          : 'Failed to set live wallpaper.';
    } catch (e) {
      print('Error applying live wallpaper: $e');
      result = 'Failed to set live wallpaper.';
    }
    print(result);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Color backgroundColor = Theme.of(context).colorScheme.background;
    Color primaryColor = Theme.of(context).colorScheme.primary;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: backgroundColor,
        title: Text(
          'Animals',
          style: GoogleFonts.kanit(
            color: primaryColor,
            fontSize: 22,
          ),
        ),
      ),
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          GestureDetector(
            child: PageView.builder(
              physics: ClampingScrollPhysics(),
              scrollDirection: Axis.vertical,
              padEnds: true,
              controller: _pageController,
              itemCount: videoUrls.length,
              itemBuilder: (context, index) {
                return Center(
                  child: _videoInitialized && _controller != null
                      ? Visibility(
                          visible: index == _currentVideoIndex,
                          child: AnimatedSwitcher(
                            duration: Duration(milliseconds: 100),
                            child: _controller!.value.isInitialized
                                ? VideoPlayer(_controller!)
                                : Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      VideoPlayer(_controller!),
                                      CircularProgressIndicator(),
                                    ],
                                  ),
                          ),
                        )
                      : CircularProgressIndicator(),
                );
              },
            ),
            onTap: () {
              setState(() {
                _isPlaying = !_isPlaying;
                _isPlaying ? _controller!.play() : _controller!.pause();
              });
            },
          ),
          if (!_isPlaying && _videoInitialized)
            Center(
              child: IconButton(
                icon: Icon(
                  Icons.play_arrow,
                  size: 48,
                ),
                onPressed: () {
                  setState(() {
                    _isPlaying = true;
                    _controller!.play();
                  });
                },
              ),
            ),
          Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: () async {
                if (_videoInitialized) {
                  await applyLiveWallpaper(videoUrls[_currentVideoIndex]);
                }
              },
              child: Container(
                height: 50,
                width: 200,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Apply Wallpaper',
                    style: GoogleFonts.kanit(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 22,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
