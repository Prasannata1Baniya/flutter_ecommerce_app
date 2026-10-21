import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/cart_provider.dart';
import '../widgets/minimal_app_bar.dart';
import 'checkout_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _promoController = TextEditingController();

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final items = cartProvider.items;

    return Scaffold(
      backgroundColor: AppTheme.creamBg,
      appBar: MinimalAppBar(
        title: 'SHOPPING BAG (${cartProvider.itemCount})',
      ),
      body: items.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.shopping_bag_outlined, size: 54, color: AppTheme.greySubtle),
                  const SizedBox(height: 16),
                  Text(
                    'Your Shopping Bag is empty',
                    style: GoogleFonts.playfairDisplay(
                      color: AppTheme.blackPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Explore our curated collection to add items.',
                    style: GoogleFonts.plusJakartaSans(
                      color: AppTheme.greySubtle,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                // List of Cart Items
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: items.length,
                    separatorBuilder: (context, index) => const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Divider(color: AppTheme.borderLight, height: 1),
                    ),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      final prod = item.product;

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Thumbnail
                          Container(
                            width: 85,
                            height: 105,
                            decoration: BoxDecoration(
                              color: AppTheme.creamSurface,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppTheme.borderLight),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                prod.images.isNotEmpty ? prod.images.first : '',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  color: AppTheme.creamSurface,
                                  child: const Icon(Icons.image_not_supported_outlined, color: AppTheme.greySubtle),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),

                          // Product Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        prod.name,
                                        style: GoogleFonts.plusJakartaSans(
                                          color: AppTheme.blackPrimary,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.close, size: 18, color: AppTheme.greySubtle),
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                      onPressed: () => cartProvider.removeItem(item.id),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  prod.subtitle,
                                  style: GoogleFonts.plusJakartaSans(
                                    color: AppTheme.greySubtle,
                                    fontSize: 12,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6),
                                if (item.selectedSize != null || item.selectedColor != null)
                                  Text(
                                    '${item.selectedSize ?? ''} ${item.selectedColor != null ? '• Color' : ''}',
                                    style: GoogleFonts.plusJakartaSans(
                                      color: AppTheme.blackMuted,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                const SizedBox(height: 12),

                                // Price & Quantity Controls
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '\$${item.totalPrice.toStringAsFixed(2)}',
                                      style: GoogleFonts.plusJakartaSans(
                                        color: AppTheme.blackPrimary,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    Container(
                                      height: 32,
                                      decoration: BoxDecoration(
                                        color: AppTheme.creamSurface,
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(color: AppTheme.borderLight),
                                      ),
                                      child: Row(
                                        children: [
                                          InkWell(
                                            onTap: () => cartProvider.updateQuantity(item.id, item.quantity - 1),
                                            child: const Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 8),
                                              child: Icon(Icons.remove, size: 14, color: AppTheme.blackPrimary),
                                            ),
                                          ),
                                          Text(
                                            '${item.quantity}',
                                            style: GoogleFonts.plusJakartaSans(
                                              color: AppTheme.blackPrimary,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () => cartProvider.updateQuantity(item.id, item.quantity + 1),
                                            child: const Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 8),
                                              child: Icon(Icons.add, size: 14, color: AppTheme.blackPrimary),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),

                // Order Summary Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: AppTheme.creamSurface,
                    border: Border(
                      top: BorderSide(color: AppTheme.borderLight, width: 1),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Promo Code Row
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _promoController,
                              style: GoogleFonts.plusJakartaSans(fontSize: 12),
                              decoration: const InputDecoration(
                                hintText: 'Promo code (e.g. MINIMAL10)',
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.blackPrimary,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            ),
                            onPressed: () {
                              if (_promoController.text.isNotEmpty) {
                                final success = cartProvider.applyPromoCode(_promoController.text);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: success ? AppTheme.blackPrimary : Colors.redAccent,
                                    content: Text(
                                      success ? 'Promo code applied!' : 'Invalid promo code.',
                                      style: GoogleFonts.plusJakartaSans(color: AppTheme.creamBg),
                                    ),
                                  ),
                                );
                              }
                            },
                            child: Text(
                              'APPLY',
                              style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                      if (cartProvider.appliedPromoCode != null) ...[
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.check_circle_outline, size: 14, color: Colors.green),
                            const SizedBox(width: 4),
                            Text(
                              'Code ${cartProvider.appliedPromoCode} applied',
                              style: GoogleFonts.plusJakartaSans(color: Colors.green, fontSize: 12, fontWeight: FontWeight.w600),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () => cartProvider.removePromoCode(),
                              child: Text(
                                'Remove',
                                style: GoogleFonts.plusJakartaSans(color: AppTheme.greySubtle, fontSize: 11, decoration: TextDecoration.underline),
                              ),
                            )
                          ],
                        ),
                      ],
                      const SizedBox(height: 16),

                      // Cost Breakdown
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Subtotal', style: GoogleFonts.plusJakartaSans(color: AppTheme.greySubtle, fontSize: 13)),
                          Text('\$${cartProvider.subtotal.toStringAsFixed(2)}', style: GoogleFonts.plusJakartaSans(color: AppTheme.blackPrimary, fontSize: 13, fontWeight: FontWeight.w600)),
                        ],
                      ),
                      if (cartProvider.discountAmount > 0) ...[
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Discount', style: GoogleFonts.plusJakartaSans(color: Colors.green, fontSize: 13)),
                            Text('-\$${cartProvider.discountAmount.toStringAsFixed(2)}', style: GoogleFonts.plusJakartaSans(color: Colors.green, fontSize: 13, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ],
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Estimated Shipping', style: GoogleFonts.plusJakartaSans(color: AppTheme.greySubtle, fontSize: 13)),
                          Text(cartProvider.shippingFee == 0 ? 'FREE' : '\$${cartProvider.shippingFee.toStringAsFixed(2)}', style: GoogleFonts.plusJakartaSans(color: AppTheme.blackPrimary, fontSize: 13, fontWeight: FontWeight.w600)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Estimated Tax', style: GoogleFonts.plusJakartaSans(color: AppTheme.greySubtle, fontSize: 13)),
                          Text('\$${cartProvider.tax.toStringAsFixed(2)}', style: GoogleFonts.plusJakartaSans(color: AppTheme.blackPrimary, fontSize: 13, fontWeight: FontWeight.w600)),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Divider(color: AppTheme.borderLight),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('TOTAL', style: GoogleFonts.plusJakartaSans(color: AppTheme.blackPrimary, fontSize: 15, fontWeight: FontWeight.w800, letterSpacing: 1.0)),
                          Text('\$${cartProvider.total.toStringAsFixed(2)}', style: GoogleFonts.plusJakartaSans(color: AppTheme.blackPrimary, fontSize: 18, fontWeight: FontWeight.w800)),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Checkout CTA
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const CheckoutScreen()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.blackPrimary,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: Text(
                            'PROCEED TO CHECKOUT',
                            style: GoogleFonts.plusJakartaSans(
                              color: AppTheme.creamBg,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
