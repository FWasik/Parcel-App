class Return {
  final String id;
  final String packageId;
  final String type;
  final String description;
  final String timeCreated;

  Return(
      {required this.id,
      required this.packageId,
      required this.type,
      required this.description,
      required this.timeCreated});

  factory Return.fromJson(Map<String, dynamic> json) {
    return Return(
        id: json['id'],
        packageId: json['packageId'],
        type: json['type'],
        description: json['description'],
        timeCreated: json['timeCreated']);
  }
}
