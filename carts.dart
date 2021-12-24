import 'package:ecom_daru/carts/emptycarts.dart';
import 'package:ecom_daru/carts/fullcarts.dart';
import 'package:ecom_daru/carts/cartDB_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Carts extends StatelessWidget {
  const Carts({Key? key}) : super(key: key);
  static const routeName = '/CartsScreen';
  @override
  Widget build(BuildContext context) {
    final cartsProvider = Provider.of<CartDBProvider>(context);

    return FutureBuilder(
        future: cartsProvider.fetchCartDB(),
        builder: (context, snapshot) {
          return cartsProvider.getCartItemsList.isEmpty
              ? Scaffold(
                  body: EmptyCarts(),
                )
              : Scaffold(
                  appBar: AppBar(
                    title: Text(
                      'CARTS Items (${cartsProvider.getCartItemsList.length})',
                    ),
                    /* actions: [
                      IconButton(
                        onPressed: () {
                           removeItemAlert(
                          context,
                          'Clear Cart',
                          'Are you sure you want to Clear your Cart.',
                          () => cartsProvider.dispose(),
                        );
                        },
                        icon: Icon(
                          Icons.delete,
                        ),
                      ),
                    ], */
                  ),
                  body: Container(
                    margin: EdgeInsets.only(bottom: 40),
                    child: ListView.builder(
                        itemCount: cartsProvider.getCartItemsList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ChangeNotifierProvider.value(
                            value: cartsProvider.getCartItemsList[index],
                            child: FullCarts(),
                          );
                        }),
                  ),
                );
        });
  }
}
