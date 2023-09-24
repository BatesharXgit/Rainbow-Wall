import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:luca/authentication/auth%20pages/auth_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:luca/myapp.dart';
import 'package:luca/pages/util/favouritesManager.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   SystemChrome.setPreferredOrientations([
//     DeviceOrientation.portraitUp,
//   ]);

//   runApp(const MyApp());
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  final prefs = await SharedPreferences.getInstance();
  runApp(
    // MyApp(),
    ChangeNotifierProvider(
      create: (context) => FavoriteImagesProvider(prefs),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LucaHome(
        title: 'Luca',
      ),
    );
  }
}
