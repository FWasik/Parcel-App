class CustomUser {
  final String uid;
  final String email;
  final String phoneNumber;
  final String fullName;

  CustomUser(
      {required this.uid,
      required this.email,
      required this.phoneNumber,
      required this.fullName});

  factory CustomUser.fromJson(Map<String, dynamic> json) {
    return CustomUser(
        uid: json['uid'],
        email: json['email'],
        phoneNumber: json['phoneNumber'],
        fullName: json['fullName']);
  }

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'email': email,
        'phoneNumber': phoneNumber,
        'fullName': fullName
      };
}
