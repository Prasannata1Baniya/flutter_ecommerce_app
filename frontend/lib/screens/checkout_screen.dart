import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/cart_provider.dart';
import '../providers/order_provider.dart';
import '../providers/user_provider.dart';
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

  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController(text: 'Kathmandu');
  final _postalController = TextEditingController(text: '44600');
  final _phoneController = TextEditingController();
  final _esewaPhoneController = TextEditingController(text: '9806800001'); // Official eSewa Test ID
  final _khaltiPhoneController = TextEditingController(text: '9801234567');

  String _selectedPaymentMethod = 'eSewa Digital Wallet';
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      if (userProvider.profile != null) {
        final p = userProvider.profile!;
        if (_nameController.text.isEmpty) _nameController.text = p.name;
        if (_addressController.text.isEmpty) _addressController.text = p.defaultAddress;
        if (_phoneController.text.isEmpty) _phoneController.text = p.phone;
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _postalController.dispose();
    _phoneController.dispose();
    _esewaPhoneController.dispose();
    _khaltiPhoneController.dispose();
    super.dispose();
  }

  Future<void> _handlePlaceOrder() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);

    // If eSewa selected, perform eSewa backend verification with EPAYTEST credentials
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
                'eSewa payment verification failed. Use test ID: 9806800001 (PIN: 1122)',
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
                'DELIVERY ADDRESS (NEPAL)',
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
                decoration: const InputDecoration(labelText: 'Full Name', hintText: 'Enter your full name'),
                validator: (val) => val == null || val.isEmpty ? 'Required field' : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _addressController,
                style: GoogleFonts.plusJakartaSans(fontSize: 14),
                decoration: const InputDecoration(labelText: 'Street / Area Address', hintText: 'e.g. Lazimpat, Ward No. 2'),
                validator: (val) => val == null || val.isEmpty ? 'Required field' : null,
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _cityController,
                      style: GoogleFonts.plusJakartaSans(fontSize: 14),
                      decoration: const InputDecoration(labelText: 'City', hintText: 'Kathmandu'),
                      validator: (val) => val == null || val.isEmpty ? 'Required field' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _postalController,
                      style: GoogleFonts.plusJakartaSans(fontSize: 14),
                      decoration: const InputDecoration(labelText: 'Postal Code', hintText: '44600'),
                      validator: (val) => val == null || val.isEmpty ? 'Required field' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _phoneController,
                style: GoogleFonts.plusJakartaSans(fontSize: 14),
                decoration: const InputDecoration(labelText: 'Mobile Number (+977)', hintText: '+977 98XXXXXXXX'),
                validator: (val) => val == null || val.isEmpty ? 'Required field' : null,
              ),
              const SizedBox(height: 28),

              // Payment Section
              Text(
                'PAYMENT METHOD (NEPAL)',
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
                  'Khalti Digital Wallet',
                  'Cash on Delivery (COD)'
                ].map((method) {
                  final isSelected = _selectedPaymentMethod == method;
                  final isEsewa = method == 'eSewa Digital Wallet';
                  final isKhalti = method == 'Khalti Digital Wallet';

                  Color activeColor = AppTheme.blackPrimary;
                  if (isEsewa) activeColor = const Color(0xFF41A124);
                  if (isKhalti) activeColor = const Color(0xFF5C2D91);

                  return GestureDetector(
                    onTap: () => setState(() => _selectedPaymentMethod = method),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: isSelected ? activeColor : AppTheme.creamSurface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected ? activeColor : AppTheme.borderLight,
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
                          else if (isKhalti)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: isSelected ? Colors.white : const Color(0xFF5C2D91),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'Khalti',
                                style: GoogleFonts.plusJakartaSans(
                                  color: isSelected ? const Color(0xFF5C2D91) : Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            )
                          else
                            Icon(
                              Icons.local_atm,
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
                            'eSewa Test Gateway (EPAYTEST)',
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
                          labelText: 'eSewa Test ID (9806800001 - 05)',
                          hintText: '9806800001',
                        ),
                        validator: (val) {
                          if (_selectedPaymentMethod == 'eSewa Digital Wallet') {
                            if (val == null || val.isEmpty) return 'Enter eSewa Test ID';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Test Credentials: Password: Nepal@123 | MPIN: 1122 | Service Code: EPAYTEST',
                        style: GoogleFonts.plusJakartaSans(
                          color: AppTheme.blackMuted,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              // Khalti Details Input Box if selected
              if (_selectedPaymentMethod == 'Khalti Digital Wallet') ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF5C2D91).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF5C2D91).withValues(alpha: 0.4)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.account_balance_wallet, size: 18, color: Color(0xFF5C2D91)),
                          const SizedBox(width: 8),
                          Text(
                            'Khalti Account Details',
                            style: GoogleFonts.plusJakartaSans(
                              color: const Color(0xFF5C2D91),
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _khaltiPhoneController,
                        keyboardType: TextInputType.phone,
                        style: GoogleFonts.plusJakartaSans(fontSize: 13),
                        decoration: const InputDecoration(
                          labelText: 'Khalti Registered Mobile Number',
                          hintText: 'e.g. 98XXXXXXXX',
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
                        : _selectedPaymentMethod == 'Khalti Digital Wallet'
                            ? const Color(0xFF5C2D91)
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
                              : _selectedPaymentMethod == 'Khalti Digital Wallet'
                                  ? 'PAY WITH KHALTI'
                                  : 'PLACE ORDER (COD)',
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
