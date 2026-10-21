import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/order_provider.dart';
import '../widgets/minimal_app_bar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final orders = orderProvider.orders;

    return Scaffold(
      backgroundColor: AppTheme.creamBg,
      appBar: const MinimalAppBar(
        title: 'MY ACCOUNT',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Header Row
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.blackPrimary,
                    image: DecorationImage(
                      image: NetworkImage('https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=400'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Alex Morgan',
                      style: GoogleFonts.playfairDisplay(
                        color: AppTheme.blackPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'alex.morgan@maison.com',
                      style: GoogleFonts.plusJakartaSans(
                        color: AppTheme.greySubtle,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 28),

            // Order History Header
            Text(
              'RECENT ORDERS (${orders.length})',
              style: GoogleFonts.plusJakartaSans(
                color: AppTheme.blackPrimary,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 12),

            if (orders.isEmpty)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.creamSurface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.borderLight),
                ),
                child: Center(
                  child: Text(
                    'No orders placed yet.',
                    style: GoogleFonts.plusJakartaSans(color: AppTheme.greySubtle, fontSize: 13),
                  ),
                ),
              )
            else
              Column(
                children: orders.map((order) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.creamSurface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.borderLight),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              order.id,
                              style: GoogleFonts.plusJakartaSans(
                                color: AppTheme.blackPrimary,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: order.status == 'Delivered'
                                    ? Colors.green.withValues(alpha: 0.12)
                                    : AppTheme.blackPrimary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                order.status.toUpperCase(),
                                style: GoogleFonts.plusJakartaSans(
                                  color: order.status == 'Delivered' ? Colors.green[800] : AppTheme.blackPrimary,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${order.items.length} Item(s) • Total: \$${order.totalAmount.toStringAsFixed(2)}',
                          style: GoogleFonts.plusJakartaSans(
                            color: AppTheme.blackMuted,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Placed on ${order.createdAt}',
                          style: GoogleFonts.plusJakartaSans(
                            color: AppTheme.greySubtle,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),

            const SizedBox(height: 28),

            // Account Settings Menu
            Text(
              'PREFERENCES & SETTINGS',
              style: GoogleFonts.plusJakartaSans(
                color: AppTheme.blackPrimary,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 12),

            _buildMenuItem(Icons.location_on_outlined, 'Shipping Addresses', '742 Evergreen Terrace, Springfield'),
            _buildMenuItem(Icons.payment_outlined, 'Payment Methods', 'Apple Pay, Visa ending in 4242'),
            _buildMenuItem(Icons.notifications_outlined, 'Notifications', 'Order updates & exclusive drops'),
            _buildMenuItem(Icons.help_outline_rounded, 'Customer Concierge', 'Live support 24/7'),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppTheme.creamSurface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.borderLight),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.blackPrimary, size: 20),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    color: AppTheme.blackPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.plusJakartaSans(
                    color: AppTheme.greySubtle,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppTheme.greySubtle),
        ],
      ),
    );
  }
}
