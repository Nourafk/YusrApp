class Review {
  final String username;
  final String description;
  final String imagePath;
  final String date;
  final int rate;

  Review({
    required this.username,
    required this.description,
    required this.imagePath,
    required this.date,
    required this.rate,
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        'description': description,
        'imagePath': imagePath,
        'date': date,
        'rate': rate,
      };

  static Review fromJson(Map<String, dynamic> json) => Review(
        username: json['username'],
        description: json['description'],
        imagePath: json['imagePath'],
        date: json['date'],
        rate: json['rate'],
      );
}
