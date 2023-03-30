class Product {
  final String ProductID;
  final String ProductName;
  final String ProductPhoto;
  final String callories;

  Product({
    required this.ProductID,
    required this.ProductName,
    required this.ProductPhoto,
    required this.callories,
  });

  Map<String, dynamic> toJson() => {
        'ProductID': ProductID,
        'ProductName': ProductName,
        'ProductPhoto': ProductPhoto,
        'callories': callories,
      };

  static Product fromJson(Map<String, dynamic> json) => Product(
        ProductID: json['ProductID'],
        ProductName: json['ProductName'],
        ProductPhoto: json['ProductPhoto'],
        callories: json['callories'],
      );

  Map<String, dynamic> toMap() {
    return {
      'ProductID': ProductID,
      'ProductName': ProductName,
      'ProductPhoto': ProductPhoto,
      'callories': callories,
    };
  }

  factory Product.fromMap(map) {
    return Product(
      ProductID: map['ProductID'],
      ProductName: map['ProductName'],
      ProductPhoto: map['ProductPhoto'],
      callories: map['callories'],
    );
  }
}
