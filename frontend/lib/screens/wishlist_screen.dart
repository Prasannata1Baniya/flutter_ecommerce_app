import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/wishlist_provider.dart';
import '../widgets/product_card.dart';
import '../widgets/minimal_app_bar.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final wishlist = wishlistProvider.wishlist;

    return Scaffold(
      backgroundColor: AppTheme.creamBg,
      appBar: MinimalAppBar(
        title: 'SAVED ITEMS (${wishlist.length})',
      ),
      body: wishlist.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.favorite_border_rounded, size: 50, color: AppTheme.greySubtle),
                  const SizedBox(height: 16),
                  Text(
                    'Your Wishlist is empty',
                    style: GoogleFonts.playfairDisplay(
                      color: AppTheme.blackPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap the heart icon on products to save them for later.',
                    style: GoogleFonts.plusJakartaSans(
                      color: AppTheme.greySubtle,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.62,
                crossAxisSpacing: 14,
                mainAxisSpacing: 18,
              ),
              itemCount: wishlist.length,
              itemBuilder: (context, index) {
                return ProductCard(product: wishlist[index]);
              },
            ),
    );
  }
}
