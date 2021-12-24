import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_daru/carts/cartDB_provider.dart';
import 'package:ecom_daru/products/feedBrands.dart';
import 'package:ecom_daru/provider/cart_provider.dart';
import 'package:ecom_daru/provider/favourite_provider.dart';
import 'package:ecom_daru/provider/products_provider.dart';
import 'package:ecom_daru/wishlist/wishList.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import 'cart.dart';

class BrandDetails extends StatefulWidget {
  const BrandDetails({Key? key}) : super(key: key);
  static const routeName = '/BrandDetails';
  @override
  _BrandDetailsState createState() => _BrandDetailsState();
}

class _BrandDetailsState extends State<BrandDetails> {
  GlobalKey key = new GlobalKey();
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(
      context,
      listen: false,
    );
    final productsList = productsData.product;
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final proId = productsData.findById(productId);
    final cartProvider = Provider.of<CartDBProvider>(context);
    final favouriteProvider = Provider.of<FavouriteProvider>(context);
    final FirebaseAuth auth = FirebaseAuth.instance;
    final Uuid uuid = Uuid();
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Colors.transparent,
        elevation: 0,

        title: Text(
          proId.title,
          style: TextStyle(fontSize: 26),
        ),
        actions: [
          Consumer<FavouriteProvider>(
            builder: (_, fav, ch) => Badge(
              animationType: BadgeAnimationType.slide,
              toAnimate: true,
              position: BadgePosition.topEnd(
                top: 5,
                end: 7,
              ),
              badgeContent: Text(
                fav.getfavouriteItems.length.toString(),
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              child: IconButton(
                onPressed: () =>
                    Navigator.of(context).pushNamed(WishList.routeName),
                icon: Icon(
                  Icons.favorite_border,
                  color: Colors.red,
                ),
              ),
            ),
          ),
          Consumer<CartProvider>(
            builder: (_, cart, ch) => Badge(
              badgeColor: Colors.black,
              animationType: BadgeAnimationType.slide,
              toAnimate: true,
              position: BadgePosition.topEnd(
                top: 5,
                end: 7,
              ),
              badgeContent: Text(
                cart.getCartItems.length.toString(),
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              child: IconButton(
                onPressed: () =>
                    Navigator.of(context).pushNamed(Cart.routeName),
                icon: Icon(
                  Icons.shopping_cart,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * .45,
            width: double.infinity,
            child: Image.network(
              proId.image,
            ),
          ),
          SingleChildScrollView(
            padding: EdgeInsets.only(
              top: 16,
              bottom: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 250,
                ),
                Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * .9,
                              child: Text(
                                proId.title,
                                maxLines: 2,
                                style: TextStyle(
                                  fontSize: 28.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              proId.price.toString(),
                              style: TextStyle(
                                color: Theme.of(context).disabledColor,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 3.0),
                            Divider(
                              thickness: 1,
                              height: 1,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 5.0),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                proId.desc,
                                style: TextStyle(
                                  color: Theme.of(context).disabledColor,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(height: 5.0),
                            Divider(
                              thickness: 1,
                              height: 1,
                              color: Colors.grey,
                            ),
                            brandInfo('BrandType', proId.brand),
                            brandInfo('Category', proId.productCattitle),
                            brandInfo('Popularity',
                                proId.isPopuler ? 'Populer' : 'No Populer'),
                            Divider(
                              thickness: 1,
                              height: 9,
                              color: Colors.grey,
                            ),
                            Container(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                'Suggested products',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              height: 200,
                              margin: EdgeInsets.only(bottom: 30),
                              child: ListView.builder(
                                  itemCount: productsList.length < 7
                                      ? productsList.length
                                      : 7,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, int index) {
                                    return ChangeNotifierProvider.value(
                                      value: productsList[index],
                                      child: FeedBrands(),
                                    );
                                  }),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Row(
              children: [
                //here is my cart section
                Expanded(
                  flex: 3,
                  child: Container(
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          side: BorderSide.none,
                        ),
                        primary:
                            cartProvider.getCartItems.containsKey(productId)
                                ? Colors.green //brand in cart
                                : Colors.redAccent[400], //brand no cart
                      ),
                      onPressed:
                          cartProvider.getCartItems.containsKey(productId)
                              ? () {}
                              : () async {
                                  /* cartProvider.addBrandToCart(
                                    productId,
                                    proId.price,
                                    proId.title,
                                    proId.image,
                                    proId.productCattitle,
                                  ); */

                                  User user = auth.currentUser!;
                                  final uid = user.uid;
                                  print('Looged in user id = $uid');
                                  cartProvider.getCartItemsList
                                      .forEach((key, orderValue) async {
                                    final orderId = uuid.v4();
                                    try {
                                      await FirebaseFirestore.instance
                                          .collection('cartsItem')
                                          .doc(orderId)
                                          .set({
                                        'orderId': orderId,
                                        'userId': uid,
                                        'productId': orderValue.productId,
                                        'title': orderValue.title,
                                        'price': orderValue.price *
                                            int.parse(orderValue.quantity),
                                        'image': orderValue.image,
                                        'quantity': orderValue.quantity,
                                        'orderDate': Timestamp.now(),
                                      });
                                    } catch (err) {}
                                  });
                                },
                      child: Text(
                        cartProvider.getCartItems.containsKey(productId)
                            ? 'In Cart'.toUpperCase()
                            : 'Add To Cart'.toUpperCase(),
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          side: BorderSide.none,
                        ),
                        primary: Colors.white,
                      ),
                      onPressed: () {},
                      child: Row(
                        children: [
                          Text(
                            'Buy Now'.toUpperCase(),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(
                            Icons.payment,
                            color: Colors.green,
                            size: 19,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          side: BorderSide.none,
                        ),
                        primary: Colors.grey[200],
                      ),
                      onPressed: () {
                        favouriteProvider.addRemoveFavourite(
                          productId,
                          proId.price,
                          proId.title,
                          proId.image,
                          proId.productCattitle,
                        );
                      },
                      child: favouriteProvider.getfavouriteItems
                              .containsKey(productId)
                          ? Icon(
                              Icons.favorite,
                              color: Colors.red,
                            )
                          : Icon(
                              Icons.favorite_border,
                              color: Colors.black,
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Positioned appbar(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'DETAIL',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(WishList.routeName),
            icon: Icon(
              Icons.favorite_border,
              color: Colors.red,
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pushNamed(Cart.routeName),
            icon: Icon(
              Icons.shopping_cart,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  brandInfo(String title, String info) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              info,
              style: TextStyle(
                color: Colors.black54,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
