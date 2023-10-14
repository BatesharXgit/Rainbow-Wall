import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:luca/authentication/auth%20pages/auth_page.dart';
import 'package:luca/pages/util/favourites_manager.dart';
import 'package:luca/pages/util/notify/notification.dart';
import 'package:luca/pages/util/notify/notify.dart';
import 'package:luca/themes/themes.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final navigatorKey = GlobalKey<NavigatorState>();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: 'AIzaSyBlcFvKT-auh3Xp73-dPmEGSi2LGvi9qdQ',
      appId: '1:803978399683:android:f2ca5f5d55c12a4a9d7776',
      messagingSenderId: '803978399683',
      projectId: 'luca-ui',
      storageBucket: 'luca-ui.appspot.com',
    ),
  );
  await FirebaseApi().initNotifications();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  final prefs = await SharedPreferences.getInstance();
  runApp(
    ChangeNotifierProvider(
      create: (context) => FavoriteImagesProvider(prefs),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: lightTheme,
      darkTheme: darkTheme,
      home: const AuthPage(),
      navigatorKey: navigatorKey,
      routes: {
        'notification_screen': (context) => const NotificationsPage(),
      },
    );
  }
}
