class CustomUser {
  final String email;
  final String phoneNumber;
  final String fullName;

  CustomUser(
      {required this.email, required this.phoneNumber, required this.fullName});

  factory CustomUser.fromJson(Map<String, dynamic> json) {
    return CustomUser(
        email: json['email'],
        phoneNumber: json['phoneNumber'],
        fullName: json['fullName']);
  }
}
