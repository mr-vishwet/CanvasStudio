class BrandProfile {
  final String businessName;
  final String? logoUrl;
  final String phone;
  final String address;
  final String? tagline;

  const BrandProfile({
    required this.businessName,
    required this.phone,
    required this.address,
    this.logoUrl,
    this.tagline,
  });

  BrandProfile copyWith({
    String? businessName,
    String? logoUrl,
    String? phone,
    String? address,
    String? tagline,
  }) =>
      BrandProfile(
        businessName: businessName ?? this.businessName,
        logoUrl: logoUrl ?? this.logoUrl,
        phone: phone ?? this.phone,
        address: address ?? this.address,
        tagline: tagline ?? this.tagline,
      );

  Map<String, dynamic> toJson() => {
    'business_name': businessName,
    'logo_url': logoUrl,
    'phone': phone,
    'address': address,
    'tagline': tagline,
  };

  factory BrandProfile.fromJson(Map<String, dynamic> json) => BrandProfile(
    businessName: json['business_name'] as String,
    logoUrl: json['logo_url'] as String?,
    phone: json['phone'] as String,
    address: json['address'] as String,
    tagline: json['tagline'] as String?,
  );
}
