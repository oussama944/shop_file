import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_file/providers/auth.dart';
import 'package:shop_file/providers/cart.dart';
import 'package:shop_file/providers/order.dart';
import 'package:shop_file/providers/products_providers.dart';
import 'package:shop_file/screens/auth_screen.dart';
import 'package:shop_file/screens/cart_screens.dart';
import 'package:shop_file/screens/edit_products.dart';
import 'package:shop_file/screens/orders_screens.dart';
import 'package:shop_file/screens/products_detail_screen.dart';
import 'package:shop_file/screens/products_overview_screen.dart';
import 'package:shop_file/screens/user_products_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (_) => Products(null, []),//error here saying 3 positional arguments expected,but 0 found.
          update: (ctx, auth, previusProducts) => Products(auth.token,
              previusProducts == null ? [] : previusProducts.items),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (_) => Orders(null, []),//error here saying 3 positional arguments expected,but 0 found.
          update: (ctx, auth, previusOrder) => Orders(auth.token,
              previusOrder == null ? [] : previusOrder.orders),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.cyan)
                .copyWith(secondary: Colors.blueAccent),
            fontFamily: 'Lato',
          ),
          home: auth.isAuth ? ProduductsOverviewScreen() : AuthScreen(),
          routes: {
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
            EditProducScreen.routeName: (ctx) => EditProducScreen(),
          },
        ),
      ),
    );
  }
}
