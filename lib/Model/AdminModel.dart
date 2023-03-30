class AdminModel {
  String? email;
  String? name;

  AdminModel({this.email, this.name});

  // receiving data from server
  factory AdminModel.fromMap(map) {
    return AdminModel(email: map['Email'], name: map['name']);
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {'Email': email, 'name': name};
  }
}
