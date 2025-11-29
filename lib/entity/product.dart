import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final bool isBuy;

  const Product({
    required this.id,
    required this.name,
    required this.isBuy,
  });
  factory Product.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Product(
      id: doc.id,
      name: data['name'],
      isBuy: data['isBuy'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "id": id,
      "name": name,
      "isBuy": isBuy,
    };
  }
}
