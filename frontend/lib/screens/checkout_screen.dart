import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/cart_provider.dart';
import '../providers/order_provider.dart';
import '../services/api_service.dart';
import '../widgets/minimal_app_bar.dart';
import 'order_confirmation_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController(text: 'Alex Morgan');
  final _addressController = TextEditingController(text: '742 Evergreen Terrace');
  final _cityController = TextEditingController(text: 'Springfield');
  final _postalController = TextEditingController(text: '97477');
  final _phoneController = TextEditingController(text: '+1 (555) 234-5678');
  final _esewaPhoneController = TextEditingController(text: '9801234567');

  String _selectedPaymentMethod = 'eSewa Digital Wallet';
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _postalController.dispose();
    _phoneController.dispose();
    _esewaPhoneController.dispose();
    super.dispose();
  }

  Future<void> _handlePlaceOrder() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);

    // If eSewa selected, perform eSewa backend verification
    if (_selectedPaymentMethod == 'eSewa Digital Wallet') {
      final esewaResult = await ApiService.verifyEsewaPayment(
        amount: cartProvider.total,
        esewaPhone: _esewaPhoneController.text,
      );

      if (esewaResult == null || esewaResult['status'] != 'SUCCESS') {
        if (mounted) {
          setState(() => _isSubmitting = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.redAccent,
              content: Text(
                'eSewa payment verification failed. Please try again.',
                style: GoogleFonts.plusJakartaSans(color: Colors.white),
              ),
            ),
          );
        }
        return;
      }
    }

    final newOrder = await orderProvider.placeOrder(
      items: cartProvider.items,
      fullName: _nameController.text,
      address: _addressController.text,
      city: _cityController.text,
      postalCode: _postalController.text,
      phone: _phoneController.text,
      paymentMethod: _selectedPaymentMethod,
    );

    if (mounted) {
      setState(() => _isSubmitting = false);

      if (newOrder != null) {
        cartProvider.clearCart();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => OrderConfirmationScreen(order: newOrder),
          ),
          (route) => route.isFirst,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: AppTheme.creamBg,
      appBar: const MinimalAppBar(
        title: 'CHECKOUT',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Shipping Section Header
              Text(
                'SHIPPING ADDRESS',
                style: GoogleFonts.plusJakartaSans(
                  color: AppTheme.blackPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _nameController,
                style: GoogleFonts.plusJakartaSans(fontSize: 14),
                decoration: const InputDecoration(labelText: 'Full Name'),
                validator: (val) => val == null || val.isEmpty ? 'Required field' : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _addressController,
                style: GoogleFonts.plusJakartaSans(fontSize: 14),
                decoration: const InputDecoration(labelText: 'Street Address'),
                validator: (val) => val == null || val.isEmpty ? 'Required field' : null,
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _cityController,
                      style: GoogleFonts.plusJakartaSans(fontSize: 14),
                      decoration: const InputDecoration(labelText: 'City'),
                      validator: (val) => val == null || val.isEmpty ? 'Required field' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _postalController,
                      style: GoogleFonts.plusJakartaSans(fontSize: 14),
                      decoration: const InputDecoration(labelText: 'Postal Code'),
                      validator: (val) => val == null || val.isEmpty ? 'Required field' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _phoneController,
                style: GoogleFonts.plusJakartaSans(fontSize: 14),
                decoration: const InputDecoration(labelText: 'Phone Number'),
                validator: (val) => val == null || val.isEmpty ? 'Required field' : null,
              ),
              const SizedBox(height: 28),

              // Payment Section
              Text(
                'PAYMENT METHOD',
                style: GoogleFonts.plusJakartaSans(
                  color: AppTheme.blackPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 12),

              Column(
                children: [
                  'eSewa Digital Wallet',
                  'Apple Pay',
                  'Credit / Debit Card',
                  'Cash on Delivery'
                ].map((method) {
                  final isSelected = _selectedPaymentMethod == method;
                  final isEsewa = method == 'eSewa Digital Wallet';

                  return GestureDetector(
                    onTap: () => setState(() => _selectedPaymentMethod = method),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? (isEsewa ? const Color(0xFF41A124) : AppTheme.blackPrimary)
                            : AppTheme.creamSurface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected
                              ? (isEsewa ? const Color(0xFF41A124) : AppTheme.blackPrimary)
                              : AppTheme.borderLight,
                        ),
                      ),
                      child: Row(
                        children: [
                          if (isEsewa)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: isSelected ? Colors.white : const Color(0xFF60BB46),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'eSewa',
                                style: GoogleFonts.plusJakartaSans(
                                  color: isSelected ? const Color(0xFF41A124) : Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            )
                          else
                            Icon(
                              method == 'Apple Pay'
                                  ? Icons.apple
                                  : method == 'Credit / Debit Card'
                                      ? Icons.credit_card
                                      : Icons.local_atm,
                              color: isSelected ? AppTheme.creamBg : AppTheme.blackPrimary,
                              size: 20,
                            ),
                          const SizedBox(width: 12),
                          Text(
                            method,
                            style: GoogleFonts.plusJakartaSans(
                              color: isSelected ? Colors.white : AppTheme.blackPrimary,
                              fontSize: 13,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            ),
                          ),
                          const Spacer(),
                          if (isSelected)
                            const Icon(Icons.check_circle, color: Colors.white, size: 18),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),

              // eSewa Details Input Box if selected
              if (_selectedPaymentMethod == 'eSewa Digital Wallet') ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF60BB46).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF41A124).withValues(alpha: 0.4)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.account_balance_wallet, size: 18, color: Color(0xFF41A124)),
                          const SizedBox(width: 8),
                          Text(
                            'eSewa Account Details',
                            style: GoogleFonts.plusJakartaSans(
                              color: const Color(0xFF2E7D32),
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _esewaPhoneController,
                        keyboardType: TextInputType.phone,
                        style: GoogleFonts.plusJakartaSans(fontSize: 13),
                        decoration: const InputDecoration(
                          labelText: 'eSewa ID / Mobile Number',
                          hintText: 'e.g. 9801234567',
                        ),
                        validator: (val) {
                          if (_selectedPaymentMethod == 'eSewa Digital Wallet') {
                            if (val == null || val.isEmpty) return 'Enter eSewa ID or Mobile Number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Your eSewa wallet will be securely charged upon order confirmation.',
                        style: GoogleFonts.plusJakartaSans(
                          color: AppTheme.greySubtle,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 28),

              // Order Summary Box
              Container(
                padding: const EdgeInsets.all(16),
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
                        Text('Subtotal', style: GoogleFonts.plusJakartaSans(color: AppTheme.greySubtle, fontSize: 13)),
                        Text('\$${cartProvider.subtotal.toStringAsFixed(2)}', style: GoogleFonts.plusJakartaSans(color: AppTheme.blackPrimary, fontSize: 13)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Shipping & Tax', style: GoogleFonts.plusJakartaSans(color: AppTheme.greySubtle, fontSize: 13)),
                        Text('\$${(cartProvider.shippingFee + cartProvider.tax).toStringAsFixed(2)}', style: GoogleFonts.plusJakartaSans(color: AppTheme.blackPrimary, fontSize: 13)),
                      ],
                    ),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Divider(color: AppTheme.borderLight)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('TOTAL AMOUNT', style: GoogleFonts.plusJakartaSans(color: AppTheme.blackPrimary, fontSize: 14, fontWeight: FontWeight.w800)),
                        Text('\$${cartProvider.total.toStringAsFixed(2)}', style: GoogleFonts.plusJakartaSans(color: AppTheme.blackPrimary, fontSize: 18, fontWeight: FontWeight.w800)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Submit CTA Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedPaymentMethod == 'eSewa Digital Wallet'
                        ? const Color(0xFF41A124)
                        : AppTheme.blackPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: _isSubmitting ? null : _handlePlaceOrder,
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(color: AppTheme.creamBg, strokeWidth: 2),
                        )
                      : Text(
                          _selectedPaymentMethod == 'eSewa Digital Wallet'
                              ? 'PAY WITH ESEWA'
                              : 'COMPLETE PURCHASE',
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
