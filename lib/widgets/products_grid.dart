
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shop_file/widgets/product_item.dart';

import '../providers/products_providers.dart';


class ProductsGrid extends StatelessWidget {
  final bool showOnlyFav;

  ProductsGrid(this.showOnlyFav);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    width = width/100 -2;
    print(width);
    final int test = width.round();
    print(" taille : $test");
    final productData = Provider.of<Products>(context);
    final products = showOnlyFav? productData.favoriteItems : productData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: products.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: products[i],
        child :ProductItem(
          //products[i].id,
          //products[i].title,
          //products[i].imageUrl,
        ),
      ),
      gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: test ,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
    );
  }
}