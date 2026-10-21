import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/product_provider.dart';
import '../widgets/product_card.dart';
import '../widgets/minimal_app_bar.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<ProductProvider>(context, listen: false);
    _searchController.text = provider.searchQuery;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final products = productProvider.products;

    return Scaffold(
      backgroundColor: AppTheme.creamBg,
      appBar: const MinimalAppBar(
        title: 'Search & Discover',
        showBackButton: true,
      ),
      body: Column(
        children: [
          // Search Field & Sort Row
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  autofocus: false,
                  style: GoogleFonts.plusJakartaSans(color: AppTheme.blackPrimary, fontSize: 14),
                  onChanged: (val) => productProvider.setSearchQuery(val),
                  decoration: InputDecoration(
                    hintText: 'Search ceramic, linen, leather, watch...',
                    prefixIcon: const Icon(Icons.search, color: AppTheme.greySubtle, size: 20),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.close, color: AppTheme.blackPrimary, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              productProvider.setSearchQuery('');
                            },
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${products.length} RESULTS',
                      style: GoogleFonts.plusJakartaSans(
                        color: AppTheme.blackMuted,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.0,
                      ),
                    ),
                    DropdownButton<String>(
                      value: productProvider.sortBy,
                      underline: const SizedBox(),
                      icon: const Icon(Icons.keyboard_arrow_down, color: AppTheme.blackPrimary, size: 18),
                      style: GoogleFonts.plusJakartaSans(
                        color: AppTheme.blackPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                      dropdownColor: AppTheme.creamSurface,
                      onChanged: (String? val) {
                        if (val != null) productProvider.setSortBy(val);
                      },
                      items: const [
                        DropdownMenuItem(value: 'featured', child: Text('Sort: Featured')),
                        DropdownMenuItem(value: 'price_low', child: Text('Price: Low to High')),
                        DropdownMenuItem(value: 'price_high', child: Text('Price: High to Low')),
                        DropdownMenuItem(value: 'rating', child: Text('Highest Rated')),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Results Grid
          Expanded(
            child: products.isEmpty
                ? Center(
                    child: Text(
                      'No matching minimalist products found.',
                      style: GoogleFonts.plusJakartaSans(color: AppTheme.greySubtle, fontSize: 14),
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.62,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 18,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      return ProductCard(product: products[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
