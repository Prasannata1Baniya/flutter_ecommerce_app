import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../models/order.dart';

class OrderConfirmationScreen extends StatelessWidget {
  final OrderModel order;

  const OrderConfirmationScreen({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.creamBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // Success Icon Container
              Container(
                width: 72,
                height: 72,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.blackPrimary,
                ),
                child: const Icon(Icons.check_rounded, size: 38, color: AppTheme.creamBg),
              ),
              const SizedBox(height: 24),

              // Title
              Text(
                'ORDER CONFIRMED',
                style: GoogleFonts.playfairDisplay(
                  color: AppTheme.blackPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2.0,
                ),
              ),
              const SizedBox(height: 8),

              Text(
                'Thank you for your purchase. Your order number is ${order.id}.',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  color: AppTheme.blackMuted,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 28),

              // Summary Box
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.creamSurface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.borderLight),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Order Reference:', style: GoogleFonts.plusJakartaSans(color: AppTheme.greySubtle, fontSize: 12)),
                        Text(order.id, style: GoogleFonts.plusJakartaSans(color: AppTheme.blackPrimary, fontSize: 12, fontWeight: FontWeight.w700)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Estimated Delivery:', style: GoogleFonts.plusJakartaSans(color: AppTheme.greySubtle, fontSize: 12)),
                        Text('3-5 Business Days', style: GoogleFonts.plusJakartaSans(color: AppTheme.blackPrimary, fontSize: 12, fontWeight: FontWeight.w700)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total Amount Paid:', style: GoogleFonts.plusJakartaSans(color: AppTheme.greySubtle, fontSize: 12)),
                        Text('\$${order.totalAmount.toStringAsFixed(2)}', style: GoogleFonts.plusJakartaSans(color: AppTheme.blackPrimary, fontSize: 13, fontWeight: FontWeight.w800)),
                      ],
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Back to Home Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.blackPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  child: Text(
                    'CONTINUE SHOPPING',
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
    );
  }
}
