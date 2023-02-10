import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_file/screens/edit_products.dart';
import 'package:shop_file/widgets/app_drawer.dart';
import 'package:shop_file/widgets/user_product_item.dart';

import '../providers/products_providers.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Votre produit'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProducScreen.routeName,arguments:"null");
            },
          )
        ],
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: productsData.items.length,
          itemBuilder: (_, i) => Column(children: [
            UserProductItem(
              productsData.items[i].title,
              productsData.items[i].id,
              productsData.items[i].imageUrl,
            ),
            Divider()
          ]),
        ),
      ),
    );
  }
}
