class StoresRequest {
  final String imageStore;
  final String desStore;
  final String nameStore;
  final String dateAdd;
  final String addByUid;
  final String state;
  final bool isShow;
  final String StoreID;

  StoresRequest({
    required this.imageStore,
    required this.desStore,
    required this.dateAdd,
    required this.state,
    required this.nameStore,
    required this.addByUid,
    required this.isShow,
    required this.StoreID,
  });

  Map<String, dynamic> toJson() => {
        'imageStore': imageStore,
        'desStore': desStore,
        'nameStore': nameStore,
        'state': state,
        'isShow': isShow,
        'addByUid': addByUid,
        'StoreID': StoreID,
      };

  static StoresRequest fromJson(Map<String, dynamic> json) => StoresRequest(
        imageStore: json['imageStore'],
        state: json['state'],
        desStore: json['desStore'],
        dateAdd: json['dateAdd'],
        nameStore: json['nameStore'],
        isShow: json['isShow'],
        addByUid: json['addByUid'],
        StoreID: json['StoreID'],
      );

  Map<String, dynamic> toMap() {
    return {
      'imageStore': imageStore,
      'desStore': desStore,
      'nameStore': nameStore,
      'state': state,
      'isShow': isShow,
      'addByUid': addByUid,
      'StoreID': StoreID,
    };
  }

  factory StoresRequest.fromMap(map) => StoresRequest(
        imageStore: map['imageStore'],
        state: map['state'],
        desStore: map['desStore'],
        dateAdd: map['dateAdd'],
        nameStore: map['nameStore'],
        isShow: map['isShow'],
        addByUid: map['addByUid'],
        StoreID: map['StoreID'],
      );
}
