import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_file/providers/products_providers.dart';
import 'package:shop_file/screens/cart_screens.dart';
import 'package:shop_file/widgets/app_drawer.dart';
import 'package:shop_file/widgets/badge.dart';

import '../providers/cart.dart';
import '../widgets/products_grid.dart';

enum FilterOption { Favorites, All }

class ProduductsOverviewScreen extends StatefulWidget {
  @override
  State<ProduductsOverviewScreen> createState() =>
      _ProduductsOverviewScreenState();
}

class _ProduductsOverviewScreenState extends State<ProduductsOverviewScreen> {
  var _showOnlyFavorites = false;
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading=true;
      });
      Provider.of<Products>(context,listen: false).fetchAndSetProducts().then((_){
        setState(() {
          _isLoading=false;
        });
      });
    }
    _isInit=false;
    super.didChangeDependencies();
  }

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Myshop'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOption selectedValue) {
              setState(() {
                if (selectedValue == FilterOption.Favorites) {
                  _showOnlyFavorites = true;
                } else {
                  _showOnlyFavorites = false;
                }
              });
            },
            icon: Icon(
              Icons.more_vert,
            ),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Les favoris'),
                value: FilterOption.Favorites,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: FilterOption.All,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              value: cart.itemCount.toString(),
              child: ch!,
            ),
          child :IconButton(
            icon: Icon(Icons.shopping_cart_rounded),
            onPressed: () {
              Navigator.of(context).pushNamed(CartScreen.routeName);
            },
          ),)
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading? Center(child: CircularProgressIndicator(),) : ProductsGrid(_showOnlyFavorites),
    );
  }
}
