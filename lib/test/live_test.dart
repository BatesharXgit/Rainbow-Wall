import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class LiveTest extends StatefulWidget {
  const LiveTest({Key? key}) : super(key: key);

  @override
  State<LiveTest> createState() => _LiveTestState();
}

class _LiveTestState extends State<LiveTest> {
  String _liveWallpaper = 'Unknown';
  String liveUrl =
      'https://firebasestorage.googleapis.com/v0/b/luca-1cfb7.appspot.com/o/live%2F3.mp4?alt=media&token=06da287c-45be-401c-8d97-1285bd72ed82';

  late bool goToHome;

  @override
  void initState() {
    super.initState();
    goToHome = false;
  }

  Future<void> setLiveWallpaper() async {
    setState(() {
      _liveWallpaper = 'Loading';
    });
    String result;
    var file = await DefaultCacheManager().getSingleFile(liveUrl);
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await AsyncWallpaper.setLiveWallpaper(
        filePath: file.path,
        goToHome: goToHome,
        toastDetails: ToastDetails.success(),
        errorToastDetails: ToastDetails.error(),
      )
          ? 'Wallpaper set'
          : 'Failed to get wallpaper.';
    } on PlatformException {
      result = 'Failed to get wallpaper.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _liveWallpaper = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              ElevatedButton(
                onPressed: setLiveWallpaper,
                child: _liveWallpaper == 'Loading'
                    ? const CircularProgressIndicator()
                    : const Text('Set live wallpaper'),
              ),
              Center(
                child: Text('Wallpaper status: $_liveWallpaper\n'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
