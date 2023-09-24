import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:async_wallpaper/async_wallpaper.dart';

class LiveWallpaperPage extends StatefulWidget {
  @override
  _LiveWallpaperPageState createState() => _LiveWallpaperPageState();
}

class _LiveWallpaperPageState extends State<LiveWallpaperPage>
    with AutomaticKeepAliveClientMixin<LiveWallpaperPage> {
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
        _currentVideoIndex = newPageIndex;
      });
      _initializeVideoController(newPageIndex);
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
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          GestureDetector(
            child: PageView.builder(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              padEnds: false,
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
                              duration: Duration(milliseconds: 500),
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
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
              onPressed: () async {
                if (_videoInitialized) {
                  await applyLiveWallpaper(videoUrls[_currentVideoIndex]);
                  setState(() {
                    _isPlaying = true;
                    _controller!.play();
                  });
                }
              },
              child: Text(
                'Apply wallpaper',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
