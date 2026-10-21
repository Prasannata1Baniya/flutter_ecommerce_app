import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import '../providers/cart_provider.dart';
import '../providers/wishlist_provider.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;

  const ProductDetailScreen({
    super.key,
    required this.productId,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  Product? _product;
  bool _isLoading = true;
  int _selectedImageIndex = 0;
  String? _selectedColor;
  String? _selectedSize;
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    _loadProduct();
  }

  Future<void> _loadProduct() async {
    final prod = await ApiService.getProductById(widget.productId);
    if (mounted) {
      setState(() {
        _product = prod;
        _isLoading = false;
        if (prod != null) {
          if (prod.colors.isNotEmpty) _selectedColor = prod.colors.first;
          if (prod.sizes.isNotEmpty) _selectedSize = prod.sizes.first;
        }
      });
    }
  }

  Color _parseHexColor(String hexString) {
    try {
      final buffer = StringBuffer();
      if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
      buffer.write(hexString.replaceFirst('#', ''));
      return Color(int.parse(buffer.toString(), radix: 16));
    } catch (_) {
      return AppTheme.blackPrimary;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppTheme.creamBg,
        body: Center(
          child: CircularProgressIndicator(color: AppTheme.blackPrimary, strokeWidth: 2),
        ),
      );
    }

    if (_product == null) {
      return Scaffold(
        backgroundColor: AppTheme.creamBg,
        appBar: AppBar(backgroundColor: AppTheme.creamBg, elevation: 0),
        body: const Center(child: Text('Product not found.')),
      );
    }

    final product = _product!;
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final isFav = wishlistProvider.isFavorite(product.id);

    return Scaffold(
      backgroundColor: AppTheme.creamBg,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // Top Image Carousel Banner
              SliverAppBar(
                expandedHeight: 420,
                pinned: true,
                backgroundColor: AppTheme.creamBg,
                elevation: 0,
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: AppTheme.creamBg.withValues(alpha: 0.85),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: AppTheme.blackPrimary),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: AppTheme.creamBg.withValues(alpha: 0.85),
                      child: IconButton(
                        icon: Icon(
                          isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                          size: 20,
                          color: isFav ? const Color(0xFFC84B31) : AppTheme.blackPrimary,
                        ),
                        onPressed: () => wishlistProvider.toggleFavorite(product),
                      ),
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      PageView.builder(
                        itemCount: product.images.length,
                        onPageChanged: (idx) => setState(() => _selectedImageIndex = idx),
                        itemBuilder: (context, index) {
                          return Image.network(
                            product.images[index],
                            fit: BoxFit.cover,
                            width: double.infinity,
                          );
                        },
                      ),
                      if (product.images.length > 1)
                        Positioned(
                          bottom: 16,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              product.images.length,
                              (index) => AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                width: _selectedImageIndex == index ? 20 : 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: _selectedImageIndex == index ? AppTheme.blackPrimary : AppTheme.borderDark,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                            ),
                          ),
                        )
                    ],
                  ),
                ),
              ),

              // Product Info Body
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category Tag
                      Text(
                        product.category.toUpperCase(),
                        style: GoogleFonts.plusJakartaSans(
                          color: AppTheme.greySubtle,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2.0,
                        ),
                      ),
                      const SizedBox(height: 6),

                      // Name
                      Text(
                        product.name,
                        style: GoogleFonts.playfairDisplay(
                          color: AppTheme.blackPrimary,
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Subtitle
                      Text(
                        product.subtitle,
                        style: GoogleFonts.plusJakartaSans(
                          color: AppTheme.blackMuted,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Rating Row
                      Row(
                        children: [
                          Row(
                            children: List.generate(
                              5,
                              (i) => Icon(
                                i < product.rating.floor() ? Icons.star_rounded : Icons.star_half_rounded,
                                size: 16,
                                color: const Color(0xFFD4A373),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${product.rating} (${product.reviewsCount} reviews)',
                            style: GoogleFonts.plusJakartaSans(
                              color: AppTheme.greySubtle,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      const Divider(color: AppTheme.borderLight),
                      const SizedBox(height: 16),

                      // Color Options Selector
                      if (product.colors.isNotEmpty) ...[
                        Text(
                          'COLOR SELECTION',
                          style: GoogleFonts.plusJakartaSans(
                            color: AppTheme.blackPrimary,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: product.colors.map((hex) {
                            final isSelected = _selectedColor == hex;
                            return GestureDetector(
                              onTap: () => setState(() => _selectedColor = hex),
                              child: Container(
                                margin: const EdgeInsets.only(right: 12),
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelected ? AppTheme.blackPrimary : Colors.transparent,
                                    width: 1.5,
                                  ),
                                ),
                                child: Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _parseHexColor(hex),
                                    border: Border.all(color: AppTheme.borderLight),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 20),
                      ],

                      // Size Options Selector
                      if (product.sizes.isNotEmpty) ...[
                        Text(
                          'SIZE',
                          style: GoogleFonts.plusJakartaSans(
                            color: AppTheme.blackPrimary,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 10,
                          children: product.sizes.map((sz) {
                            final isSelected = _selectedSize == sz;
                            return GestureDetector(
                              onTap: () => setState(() => _selectedSize = sz),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                decoration: BoxDecoration(
                                  color: isSelected ? AppTheme.blackPrimary : AppTheme.creamSurface,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: isSelected ? AppTheme.blackPrimary : AppTheme.borderLight,
                                  ),
                                ),
                                child: Text(
                                  sz,
                                  style: GoogleFonts.plusJakartaSans(
                                    color: isSelected ? AppTheme.creamBg : AppTheme.blackPrimary,
                                    fontSize: 13,
                                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 20),
                      ],

                      // Quantity Selector
                      Row(
                        children: [
                          Text(
                            'QUANTITY',
                            style: GoogleFonts.plusJakartaSans(
                              color: AppTheme.blackPrimary,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            decoration: BoxDecoration(
                              color: AppTheme.creamSurface,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: AppTheme.borderLight),
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove, size: 16),
                                  onPressed: _quantity > 1 ? () => setState(() => _quantity--) : null,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Text(
                                    '$_quantity',
                                    style: GoogleFonts.plusJakartaSans(
                                      color: AppTheme.blackPrimary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add, size: 16),
                                  onPressed: () => setState(() => _quantity++),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Description
                      Text(
                        'ABOUT THIS PIECE',
                        style: GoogleFonts.plusJakartaSans(
                          color: AppTheme.blackPrimary,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        product.description,
                        style: GoogleFonts.plusJakartaSans(
                          color: AppTheme.blackMuted,
                          fontSize: 14,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Bullet details
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: product.details.map((detail) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(top: 6, right: 10),
                                  width: 5,
                                  height: 5,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppTheme.blackPrimary,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    detail,
                                    style: GoogleFonts.plusJakartaSans(
                                      color: AppTheme.blackMuted,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 100), // Space for bottom action bar
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Sticky Bottom Action Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: AppTheme.creamBg,
                border: const Border(
                  top: BorderSide(color: AppTheme.borderLight, width: 1),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  )
                ],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'TOTAL PRICE',
                          style: GoogleFonts.plusJakartaSans(
                            color: AppTheme.greySubtle,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.0,
                          ),
                        ),
                        Text(
                          '\$${(product.price * _quantity).toStringAsFixed(2)}',
                          style: GoogleFonts.plusJakartaSans(
                            color: AppTheme.blackPrimary,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.blackPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: () {
                          cartProvider.addToCart(
                            product,
                            quantity: _quantity,
                            selectedColor: _selectedColor,
                            selectedSize: _selectedSize,
                          );

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: AppTheme.blackPrimary,
                              content: Text(
                                '${product.name} added to your bag.',
                                style: GoogleFonts.plusJakartaSans(color: AppTheme.creamBg),
                              ),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        child: Text(
                          'ADD TO BAG',
                          style: GoogleFonts.plusJakartaSans(
                            color: AppTheme.creamBg,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
