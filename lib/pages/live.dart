import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LiveWallCategory extends StatefulWidget {
  const LiveWallCategory({super.key});

  @override
  State<LiveWallCategory> createState() => _LiveWallCategoryState();
}

class _LiveWallCategoryState extends State<LiveWallCategory> {
  Widget build(BuildContext context) {
    Color backgroundColor = Theme.of(context).colorScheme.background;
    Color primaryColor = Theme.of(context).colorScheme.primary;

    // final message = ModalRoute.of(context)!.settings.arguments as RemoteMessage;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: backgroundColor,
        title: Text(
          'Live Wallpapers',
          style: GoogleFonts.orbitron(
            color: primaryColor,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Center(
          child: Text(
            'Live Wallpapers to be added soon,\n                 Stay connected...',
            style: GoogleFonts.kanit(color: primaryColor, fontSize: 18),
          ),

          // Column(
          //   children: [
          //     Text(message.notification!.title.toString()),
          //     Text(message.notification!.body.toString()),
          //     Text(message.data.toString()),
          //     Text(
          //       'No Notifications available',
          //       style: GoogleFonts.kanit(color: primaryColor, fontSize: 18),
          //     ),
          //   ],
          // ),
        ),
      ),
    );
  }
}
