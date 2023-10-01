import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:luca/pages/util/applyWallpaperPage.dart';
import 'package:luca/pages/util/favouritesManager.dart';
import 'package:provider/provider.dart';

class FavoriteImagesPage extends StatelessWidget {
  const FavoriteImagesPage({
    super.key,
  });

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
            icon: Icon(Iconsax.trash),
          )
        ],
        elevation: 0,
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
            print('Favorite Images: $favoriteImages');
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
          title: Text('Clear Favorites?'),
          content:
              Text('Are you sure you want to clear all your favorite images?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Clear favorites and close the dialog
                Provider.of<FavoriteImagesProvider>(context, listen: false)
                    .clearFavorites();
                Navigator.of(context).pop();
              },
              child: Text(
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
