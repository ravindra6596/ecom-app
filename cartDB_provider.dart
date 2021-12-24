import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_daru/carts/cartDB_Attributes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CartDBProvider with ChangeNotifier {
  List<CartDBAttributes> cartItems = [];
  List<CartDBAttributes> get cartLists {
    return cartItems;
  }
  Map<String, CartDBAttributes> getCartItems = {};
  Map<String, CartDBAttributes> get getCartItemsList {
    return {...getCartItems};
  }
  Future fetchCartDB() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User user = auth.currentUser!;
    var loggedInUserId = user.uid;

    try {
      await FirebaseFirestore.instance
          .collection('cartItems')
          .where(
            'userId',
            isEqualTo: loggedInUserId,
          )
          .get()
          .then(
        (QuerySnapshot snapshot) {
          cartItems.clear();
          snapshot.docs.forEach(
            (element) {
              cartItems.insert(
                0,
                CartDBAttributes(
                  userId: element.get('userId'),
                  productId: element.get('productId'),
                  title: element.get('title'),
                  image: element.get('image'),
                  price: element.get('price'),
                  quantity: element.get('quantity'),
                  orderDate: element.get('orderDate'),
                ),
              );
            },
          );
        },
      );
    } catch (e) {}
    notifyListeners();
  }
}
