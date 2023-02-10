import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_file/providers/products_providers.dart';

import '../providers/product.dart';

class EditProducScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  State<EditProducScreen> createState() => _EditProducScreenState();
}

class _EditProducScreenState extends State<EditProducScreen> {
  final _imagesUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _editeProduct =
      Product(id: '', title: '', description: '', price: 0, imageUrl: '');

  var _isInit = true;
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };
  var _isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    _imagesUrlController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {


    if (_isInit) {
      final productId = ModalRoute.of(context)?.settings.arguments as String;
      if (productId != "null") {
        _editeProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initValues = {
          'title': _editeProduct.title,
          'description': _editeProduct.description,
          'price': _editeProduct.price.toString(),
          'imageUrl': '',
        };
        _imagesUrlController.text = _editeProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> _saveForm() async {
    final bool isValid = _form.currentState?.validate() ?? false;
    if (!isValid) return;

    _form.currentState?.save();
    setState(() {
      _isLoading = true;
    });

    if (_editeProduct.id != '') {
      Provider.of<Products>(context, listen: false)
          .updateProduct(_editeProduct.id, _editeProduct);
      Navigator.of(context).pop();
      setState(() {
        _isLoading = false;
      });
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addPrduct(_editeProduct);
      } catch (error) {
        showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('Il y a eu une erreur'),
                  content: Text('Une erreur c\'est produite '),
                  actions: <Widget>[
                    TextButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        },
                        child: Text('OK'))
                  ],
                ));
      }finally{
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editer les produits'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save_alt_rounded),
            onPressed: _saveForm,
          )
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: SingleChildScrollView(
                    child: Column(
                  children: <Widget>[
                    TextFormField(
                      initialValue: _initValues['title'],
                      decoration: InputDecoration(labelText: 'Titre'),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value?.trim().isEmpty == true)
                          return " Donnée incorrecte";
                        return null;
                      },
                      onSaved: (value) {
                        _editeProduct = Product(
                            id: _editeProduct.id,
                            title: value.toString(),
                            description: _editeProduct.description,
                            price: _editeProduct.price,
                            isFavorite: _editeProduct.isFavorite,
                            imageUrl: _editeProduct.imageUrl);
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['price'],
                      decoration: InputDecoration(labelText: 'Prix'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value?.trim().isEmpty == true)
                          return " Donnée incorrecte";
                        if (double.tryParse(value!) == null)
                          return " Nombre incorrecte";
                        if (double.tryParse(value!)! <= 0)
                          return " Nombre trop petit";
                        return null;
                      },
                      onSaved: (value) {
                        _editeProduct = Product(
                            id: _editeProduct.id,
                            title: _editeProduct.title,
                            isFavorite: _editeProduct.isFavorite,
                            description: _editeProduct.description,
                            price: double.parse(value.toString()),
                            imageUrl: _editeProduct.imageUrl);
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['description'],
                      decoration: InputDecoration(labelText: 'Description'),
                      maxLines: 4,
                      keyboardType: TextInputType.multiline,
                      onSaved: (value) {
                        _editeProduct = Product(
                            id: _editeProduct.id,
                            title: _editeProduct.title,
                            description: value.toString(),
                            price: _editeProduct.price,
                            isFavorite: _editeProduct.isFavorite,
                            imageUrl: _editeProduct.imageUrl);
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(top: 8, right: 10),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.black45),
                          ),
                          child: _imagesUrlController.text.isEmpty
                              ? Text('Entrer une url')
                              : FittedBox(
                                  child: Image.network(
                                    _imagesUrlController.text,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'URL de l\'image',
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 3,
                                    color: Colors.greenAccent), //<-- SEE HERE
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                            ),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imagesUrlController,
                            onEditingComplete: () {
                              setState(() {});
                            },
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                            onSaved: (value) {
                              _editeProduct = Product(
                                  id: _editeProduct.id,
                                  title: _editeProduct.title,
                                  description: _editeProduct.description,
                                  price: _editeProduct.price,
                                  isFavorite: _editeProduct.isFavorite,
                                  imageUrl: value.toString());
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                )),
              ),
            ),
    );
  }
}
