import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:luca/pages/util/apply_walls.dart';
import 'package:luca/pages/util/favourites_manager.dart';
import 'package:provider/provider.dart';

class FavoriteImagesPage extends StatelessWidget {
  const FavoriteImagesPage({super.key, required ScrollController controller});

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Theme.of(context).colorScheme.background;
    Color primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              _showClearFavoritesConfirmationDialog(context);
            },
            icon: const Icon(Iconsax.trash),
          )
        ],
        // elevation: 0,
        iconTheme: Theme.of(context).iconTheme,
        centerTitle: true,
        backgroundColor: backgroundColor,
        title: Text(
          'Favourites',
          style: GoogleFonts.orbitron(
            color: primaryColor,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Consumer<FavoriteImagesProvider>(
          builder: (context, provider, child) {
            final favoriteImages = provider.favoriteImages;
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, childAspectRatio: 0.65),
              itemCount: favoriteImages.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ApplyWallpaperPage(
                              imageUrl: favoriteImages[index]),
                        ),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: CachedNetworkImage(
                        imageUrl: favoriteImages[index],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _showClearFavoritesConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.background,
          title: const Text('Clear Favorites?'),
          content: const Text(
              'Are you sure you want to clear all your favorite images?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Provider.of<FavoriteImagesProvider>(context, listen: false)
                    .clearFavorites();
                Navigator.of(context).pop();
              },
              child: const Text(
                'Clear',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
