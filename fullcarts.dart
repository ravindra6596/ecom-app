
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_daru/carts/cartDB_Attributes.dart';
import 'package:ecom_daru/screens/brandDetails.dart';
import 'package:ecom_daru/widgets/alerts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FullCarts extends StatefulWidget {
  @override
  _FullCartsState createState() => _FullCartsState();
}

class _FullCartsState extends State<FullCarts> {
  @override
  Widget build(BuildContext context) {
    final cartsAttri = Provider.of<CartDBAttributes>(context);
    bool isLoading = false;
    var date = cartsAttri.orderDate.toDate();
    var parseDate = DateTime.parse(date.toString());
    var formatedDate = "${parseDate.day}-${parseDate.month}-${parseDate.year}\t"
        "${parseDate.hour}:${parseDate.minute}:${parseDate.second}";

    return InkWell(
      onTap: () => Navigator.pushNamed(
        context,
        BrandDetails.routeName,
        arguments: cartsAttri.productId,
      ),
      child: Container(
        height: 120,
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(16),
          ),
          color: Colors.grey.shade100,
        ),
        child: Row(
          children: [
            Container(
              width: 130,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(16),
                ),
                image: DecorationImage(
                  image: NetworkImage(
                    cartsAttri.image, //
                  ),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        cartsAttri.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            removeItemAlert(context, 'Remove Item',
                                'Are you sure you want to remove this item from your orders.',
                                () async {
                              setState(() {
                                isLoading = true;
                              });
                              await FirebaseFirestore.instance
                                  .collection('cartItems')
                                  .doc(cartsAttri.productId)
                                  .delete();
                            });
                          },
                          child: isLoading
                              ? CircularProgressIndicator()
                              : Icon(
                                  Icons.close,
                                  color: Colors.red,
                                ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Quantity: ${cartsAttri.quantity}',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: Text(
                          cartsAttri.price,
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            right: 12,
                            top: 8,
                          ),
                          child: Text(
                            'D/T : $formatedDate',
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
