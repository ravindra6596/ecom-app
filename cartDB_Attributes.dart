import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CartDBAttributes with ChangeNotifier {
  final String userId;
  final String productId;
  final title;
  final String image;
  final String price;
  final String quantity;
  final Timestamp orderDate;

  CartDBAttributes({
    required this.userId,
    required this.productId,
    required this.title,
    required this.image,
    required this.price,
    required this.quantity,
    required this.orderDate,
  });
}
