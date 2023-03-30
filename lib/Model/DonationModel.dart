class Donation {
  final String DonationId;
  final String ProductImage;
  final String ProductName;
  final String ownerName;
  final String ownerId;
  final String AddDate;
  final String ExpDate;
  final bool isShow;
  final bool isClosed;
  final String ownerImage;

  Donation({
    required this.DonationId,
    required this.ProductImage,
    required this.ProductName,
    required this.ownerName,
    required this.ownerId,
    required this.AddDate,
    required this.ExpDate,
    required this.isShow,
    required this.isClosed,
    required this.ownerImage,
  });

  Map<String, dynamic> toMap() => {
        'DonationId': DonationId,
        'ProductImage': ProductImage,
        'ProductName': ProductName,
        'ownerName': ownerName,
        'ownerId': ownerId,
        'AddDate': AddDate,
        'ExpDate': ExpDate,
        'isShow': isShow,
        'isClosed': isClosed,
        'ownerImage': ownerImage,
      };

  static Donation fromMap(map) {
    return Donation(
      DonationId: map['DonationId'],
      ProductImage: map['ProductImage'],
      ProductName: map['ProductName'],
      ownerName: map['ownerName'],
      ownerId: map['ownerId'],
      AddDate: map['AddDate'],
      ExpDate: map['ExpDate'],
      isShow: map['isShow'],
      isClosed: map['isClosed'],
      ownerImage: map['ownerImage'],
    );
  }
}
