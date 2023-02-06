import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final double price;
  final String productId;
  final int quantity;
  final String title;

  CartItem(this.id, this.price, this.quantity, this.title, this.productId);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.bottomRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('etes vous sur ?'),
            content: Text('Voulez vous supprimer le prduit ?'),
            actions: <Widget>[
              TextButton(onPressed: (){
                Navigator.of(ctx).pop(true);
              }, child: Text('Oui')),
              TextButton(onPressed: (){
                Navigator.of(ctx).pop(false);
              }, child: Text('Non')),
            ],
          ),
        );

      },
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      child: Card(
          margin: EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 4,
          ),
          child: Padding(
            padding: EdgeInsets.all(8),
            child: ListTile(
              leading: CircleAvatar(
                child: FittedBox(
                  child: Text(
                    '${price}\$',
                  ),
                ),
              ),
              title: Text(title),
              subtitle: Text('Tota: ${price * quantity} \$'),
              trailing: Text('${quantity}'),
            ),
          )),
    );
  }
}
