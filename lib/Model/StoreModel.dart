class Store {
  final String StoreID;
  final String StoreName;
  final String StoreLogo;
  String kilometers;
  final num lat;
  final num lng;
  final String description;

  Store({
    required this.StoreID,
    required this.StoreName,
    required this.StoreLogo,
    required this.kilometers,
    required this.lat,
    required this.lng,
    required this.description,
  });

  Map<String, dynamic> toJson() => {
        'StoreId': StoreID,
        'StoreName': StoreName,
        'StoreLogo': StoreLogo,
        'kilometers': kilometers,
        'lat': lat,
        'lng': lng,
        'description': description,
      };

  static Store fromJson(Map<String, dynamic> json) => Store(
        StoreID: json['StoreId'],
        StoreName: json['StoreName'],
        StoreLogo: json['StoreLogo'],
        kilometers: json['kilometers'].toString(),
        lat: json['lat'],
        lng: json['lng'],
        description: json['description'],
      );

  Map<String, dynamic> toMap() {
    return {
      'StoreId': StoreID,
      'StoreName': StoreName,
      'StoreLogo': StoreLogo,
      'kilometers': kilometers,
      'lat': lat,
      'lng': lng,
      'description': description,
    };
  }

  factory Store.fromMap(map) {
    return Store(
      StoreID: map['StoreId'],
      StoreName: map['StoreName'],
      StoreLogo: map['StoreLogo'],
      kilometers: map['kilometers'].toString(),
      lat: map['lat'],
      lng: map['lng'],
      description: map['description'],
    );
  }
}
