class UserModel {
  String? uid;
  String? name;
  String? email;
  String? phonenumber;
  String? dateofbirth;
  String? imagePath;
  String? gender;
  String? username;
  int? points;
  String? fcmToken;

  UserModel({
    this.uid,
    this.email,
    this.name,
    this.phonenumber,
    this.dateofbirth,
    this.imagePath,
    this.gender,
    this.username,
    this.points,
    this.fcmToken,
  });

  // receiving data from server
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      name: map['name'],
      email: map['email'],
      phonenumber: map['phonenumber'],
      dateofbirth: map['dateofbirth'],
      imagePath: map['imagePath'],
      gender: map['gender'],
      username: map['username'],
      points: map['points'],
      fcmToken: map['fcmToken'],
    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phonenumber': phonenumber,
      'dateofbirth': dateofbirth,
      'imagePath': imagePath,
      'gender': gender,
      'username': username,
      'points': points,
      'fcmToken': fcmToken,
    };
  }

  UserModel copy({
    String? uid,
    String? name,
    String? email,
    String? phonenumber,
    String? dateofbirth,
    String? imagePath,
    String? gender,
    String? username,
    int? points,
    String? fcmToken,
  }) =>
      UserModel(
          uid: uid ?? this.uid,
          imagePath: imagePath ?? this.imagePath,
          name: name ?? this.name,
          username: username ?? this.username,
          email: email ?? this.email,
          phonenumber: phonenumber ?? this.phonenumber,
          dateofbirth: dateofbirth ?? this.dateofbirth,
          gender: gender ?? this.gender,
          points: points ?? this.points,
          fcmToken: fcmToken ?? this.fcmToken);
}
