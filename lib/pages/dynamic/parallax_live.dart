import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:video_player/video_player.dart';
import 'package:firebase_storage/firebase_storage.dart';

class VideosScreen extends StatefulWidget {
  const VideosScreen({super.key});

  @override
  State<VideosScreen> createState() => _VideosScreenState();
}

class _VideosScreenState extends State<VideosScreen> {
  late PageController _pageController;
  List<String> videoUrls = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.8);
    fetchVideoUrls();
  }

  void fetchVideoUrls() async {
    final storageRef = FirebaseStorage.instance.ref('live');

    final ListResult result = await storageRef.list();
    for (final item in result.items) {
      final url = await item.getDownloadURL();
      setState(() {
        videoUrls.add(url);
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: PageView.builder(
              controller: _pageController,
              itemCount: videoUrls.length,
              itemBuilder: (context, index) {
                return VideoCard(
                  videoUrl: videoUrls[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class VideoCard extends StatefulWidget {
  const VideoCard({
    super.key,
    required this.videoUrl,
  });

  final String videoUrl;

  @override
  State<VideoCard> createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard> {
  late VideoPlayerController _controller;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));

    _controller
      ..addListener(() {
        if (!_isDisposed) {
          setState(() {});
        }
      })
      ..setLooping(true)
      ..setVolume(0)
      ..initialize().then((_) {
        if (!_isDisposed) {
          setState(() {});
        }
      })
      ..play();
    _loadVideo();
  }

  void _loadVideo() async {
    final videoUrl = widget.videoUrl;
    final cacheManager = DefaultCacheManager();

    FileInfo? fileInfo = await cacheManager.getFileFromCache(videoUrl);

    if (fileInfo != null && fileInfo.file.existsSync()) {
      _controller = VideoPlayerController.file(fileInfo.file);
    } else {
      await cacheManager.downloadFile(videoUrl);
      _controller = VideoPlayerController.file(
          await cacheManager.getSingleFile(videoUrl));
    }

    _controller
      ..addListener(() {
        if (!_isDisposed) {
          setState(() {});
        }
      })
      ..setLooping(true)
      ..setVolume(0)
      ..initialize().then((_) {
        if (!_isDisposed) {
          setState(() {});
        }
      })
      ..play();
  }

  @override
  void dispose() {
    _isDisposed = true;
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            offset: const Offset(0, 6),
            blurRadius: 8,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        ),
      ),
    );
  }
}
