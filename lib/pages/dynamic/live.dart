import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:async_wallpaper/async_wallpaper.dart';

class LiveWallpaperPage extends StatefulWidget {
  @override
  _LiveWallpaperPageState createState() => _LiveWallpaperPageState();
}

class _LiveWallpaperPageState extends State<LiveWallpaperPage> {
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
    // _initializeVideoController(_currentVideoIndex);
  }

  @override
  void dispose() {
    _controller?.removeListener(_onVideoStateChange);
    _controller?.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _fetchVideoUrls() async {
    final storageRef = FirebaseStorage.instance.ref('live');
    final ListResult result = await storageRef.listAll();

    setState(() {
      videoUrls = result.items.map((item) => item.fullPath).toList();
    });

    _initializeVideoController(_currentVideoIndex);
  }

  Future<void> _initializeVideoController(int index) async {
    _controller?.dispose();
    final videoUrl = await _getVideoUrl(index);

    final cachedVideo = await DefaultCacheManager().getFileFromCache(videoUrl);

    if (cachedVideo != null && cachedVideo.file.existsSync()) {
      _controller = VideoPlayerController.file(cachedVideo.file);
    } else {
      final file = await DefaultCacheManager().getSingleFile(videoUrl);
      _controller = VideoPlayerController.file(file);
    }

    await _controller!.initialize();
    setState(() {
      _videoInitialized = true;
      _isPlaying = true;
    });

    _controller!.setLooping(true);
    _controller!.addListener(_onVideoStateChange);
    _controller!.play();
  }

  Future<String> _getVideoUrl(int index) async {
    final ref = FirebaseStorage.instance.ref(videoUrls[index]);
    return await ref.getDownloadURL();
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
      });

      if (newPageIndex < _currentVideoIndex) {
        setState(() {
          _currentVideoIndex = newPageIndex;
        });
      } else {
        setState(() {
          _currentVideoIndex = newPageIndex;
        });
      }
    }
  }

  Future<void> applyLiveWallpaper(String videoUrl) async {
    try {
      final httpUrl = await _getVideoUrl(_currentVideoIndex);
      final file = await DefaultCacheManager().getSingleFile(httpUrl);

      await _controller?.pause();
      final result = await AsyncWallpaper.setLiveWallpaper(filePath: file.path);

      if (result) {
        print('Live wallpaper set');
      } else {
        print('Failed to set live wallpaper.');
      }

      setState(() {
        _isPlaying = true;
        _controller!.play();
      });
    } catch (e) {
      print('Error applying live wallpaper: $e');
      setState(() {
        _isPlaying = true;
        _controller!.play();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          GestureDetector(
            child: PageView.builder(
              physics: ClampingScrollPhysics(),
              scrollDirection: Axis.vertical,
              controller: _pageController,
              itemCount: videoUrls.length,
              itemBuilder: (context, index) {
                return Center(
                  child: _videoInitialized && _controller != null
                      ? AspectRatio(
                          aspectRatio: _controller!.value.aspectRatio,
                          child: Visibility(
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
