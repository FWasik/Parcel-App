class Package {
  final String id;
  final String uidSender;
  final String uidReceiver;
  final String fullName;
  final String phoneNumber;
  final String address;
  final String timeCreated;

  Package(
      {required this.id,
      required this.uidSender,
      required this.uidReceiver,
      required this.fullName,
      required this.phoneNumber,
      required this.address,
      required this.timeCreated});

  factory Package.fromJson(Map<String, dynamic> json) {
    return Package(
      id: json['id'],
      uidSender: json['uidSender'],
      uidReceiver: json['uidReceiver'],
      fullName: json['fullName'],
      phoneNumber: json["phoneNumber"],
      address: json["address"],
      timeCreated: json["timeCreated"],
    );
  }
}
