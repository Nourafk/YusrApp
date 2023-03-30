class ProductsRequest {
  final String imageProduct;
  final String productType;
  final String callories;
  final String nameProduct;
  final String dateAdd;
  final String addByUid;
  final String state;
  final bool isShow;
  final String ProductID;

  ProductsRequest({
    required this.imageProduct,
    required this.callories,
    required this.productType,
    required this.dateAdd,
    required this.state,
    required this.nameProduct,
    required this.addByUid,
    required this.isShow,
    required this.ProductID,
  });

  Map<String, dynamic> toJson() => {
        'imageProduct': imageProduct,
        'callories': callories,
        'productType': productType,
        'nameProduct': nameProduct,
        'state': state,
        'isShow': isShow,
        'addByUid': addByUid,
        'ProductID': ProductID,
      };

  static ProductsRequest fromJson(Map<String, dynamic> json) => ProductsRequest(
        imageProduct: json['imageProduct'],
        productType: json['productType'] ?? "",
        state: json['state'],
        callories: json['callories'],
        dateAdd: json['dateAdd'],
        nameProduct: json['nameProduct'],
        isShow: json['isShow'],
        addByUid: json['addByUid'],
        ProductID: json['ProductID'],
      );

  Map<String, dynamic> toMap() {
    return {
      'imageProduct': imageProduct,
      'callories': callories,
      'productType': productType,
      'nameProduct': nameProduct,
      'state': state,
      'isShow': isShow,
      'addByUid': addByUid,
      'ProductID': ProductID,
    };
  }

  factory ProductsRequest.fromMap(map) => ProductsRequest(
        imageProduct: map['imageProduct'],
        productType: map['productType'] ?? "",
        state: map['state'],
        callories: map['callories'],
        dateAdd: map['dateAdd'],
        nameProduct: map['nameProduct'],
        isShow: map['isShow'],
        addByUid: map['addByUid'],
        ProductID: map['ProductID'],
      );
}
