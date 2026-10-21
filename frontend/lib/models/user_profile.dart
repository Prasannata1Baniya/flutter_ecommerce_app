class UserProfile {
  final String id;
  final String name;
  final String email;
  final String avatarUrl;
  final String phone;
  final String defaultAddress;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.avatarUrl,
    required this.phone,
    required this.defaultAddress,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Alex Morgan',
      email: json['email'] ?? 'alex.morgan@maison.com',
      avatarUrl: json['avatar_url'] ??
          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=400',
      phone: json['phone'] ?? '+1 (555) 234-5678',
      defaultAddress: json['default_address'] ?? '742 Evergreen Terrace, Springfield',
    );
  }
}
