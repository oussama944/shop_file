import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart' show Cart;
import '../providers/order.dart' show Orders;
import '../widgets/app_drawer.dart';
import '../widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/order';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Votre commande'),
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
          future:
              Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
          builder: (ctx, dataSnashot) {
            if (dataSnashot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              if (dataSnashot.error == null) {
                return Consumer<Orders>(
                  builder: (ctx, orderData, child) => ListView.builder(
                    itemCount: orderData.orders.length,
                    itemBuilder: (ctx, i) => OrderItem(orderData.orders[i]),
                  ),
                );
              } else {
                //error
                return Center(child: Text('Il y a eu une erreur'));
              }
            }
          },
        ));
  }
}
