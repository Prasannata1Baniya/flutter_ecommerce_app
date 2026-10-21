import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/product_provider.dart';
import '../widgets/product_card.dart';
import '../widgets/category_selector.dart';
import 'search_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final products = productProvider.products;

    return Scaffold(
      backgroundColor: AppTheme.creamBg,
      body: CustomScrollView(
        slivers: [
          // App Bar / Top Header
          SliverAppBar(
            floating: true,
            pinned: true,
            backgroundColor: AppTheme.creamBg,
            elevation: 0,
            scrolledUnderElevation: 0,
            title: Text(
              'M A I S O N',
              style: GoogleFonts.playfairDisplay(
                color: AppTheme.blackPrimary,
                fontSize: 22,
                fontWeight: FontWeight.w700,
                letterSpacing: 4.0,
              ),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.search_rounded, color: AppTheme.blackPrimary, size: 22),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SearchScreen()),
                  );
                },
              ),
              const SizedBox(width: 8),
            ],
          ),

          // Hero Banner
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppTheme.blackPrimary,
                  borderRadius: BorderRadius.circular(12),
                  image: const DecorationImage(
                    image: NetworkImage('https://images.unsplash.com/photo-1490481651871-ab68de25d43d?auto=format&fit=crop&q=80&w=1200'),
                    fit: BoxFit.cover,
                    opacity: 0.45,
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      color: AppTheme.creamBg,
                      child: Text(
                        'AUTUMN / WINTER 2026',
                        style: GoogleFonts.plusJakartaSans(
                          color: AppTheme.blackPrimary,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Quiet Luxury &\nMinimal Essentials',
                      style: GoogleFonts.playfairDisplay(
                        color: AppTheme.creamBg,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () => productProvider.selectCategory('all'),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'EXPLORE NOW',
                            style: GoogleFonts.plusJakartaSans(
                              color: AppTheme.creamBg,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.arrow_forward, size: 14, color: AppTheme.creamBg),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),

          // Categories Selector
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: CategorySelector(),
            ),
          ),

          // Featured Title Header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'CURATED COLLECTION',
                    style: GoogleFonts.playfairDisplay(
                      color: AppTheme.blackPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                    ),
                  ),
                  Text(
                    '${products.length} ITEMS',
                    style: GoogleFonts.plusJakartaSans(
                      color: AppTheme.greySubtle,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Product Grid
          productProvider.isLoading
              ? const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(color: AppTheme.blackPrimary, strokeWidth: 2),
                  ),
                )
              : products.isEmpty
                  ? SliverToBoxAdapter(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 60),
                        child: Column(
                          children: [
                            const Icon(Icons.inventory_2_outlined, size: 40, color: AppTheme.greySubtle),
                            const SizedBox(height: 12),
                            Text(
                              'No products found in this category.',
                              style: GoogleFonts.plusJakartaSans(
                                color: AppTheme.blackMuted,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      sliver: SliverGrid(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.62,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 18,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return ProductCard(product: products[index]);
                          },
                          childCount: products.length,
                        ),
                      ),
                    ),

          const SliverToBoxAdapter(
            child: SizedBox(height: 40),
          ),
        ],
      ),
    );
  }
}
