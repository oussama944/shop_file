import 'package:flutter/material.dart';

import '../providers/product.dart';

class EditProducScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  State<EditProducScreen> createState() => _EditProducScreenState();
}

class _EditProducScreenState extends State<EditProducScreen> {
  final _imagesUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _editeProduct =  Product(id: '', title: '', description: '', price: 0, imageUrl: '');

  @override
  void dispose() {
    // TODO: implement dispose
    _imagesUrlController.dispose();
    super.dispose();
  }

  void _saveForm(){
    _form.currentState?.save();
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: SingleChildScrollView(
              child: Column(
            children: <Widget>[
              TextFormField(
                  decoration: InputDecoration(labelText: 'Titre'),
                  textInputAction: TextInputAction.next,
                onSaved: (value){
                    _editeProduct = Product(id: _editeProduct.id, title: value.toString(), description: _editeProduct.description, price: _editeProduct.price, imageUrl: _editeProduct.imageUrl);
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Prix'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                onSaved: (value){
                  _editeProduct = Product(id: _editeProduct.id, title: _editeProduct.toString(), description: _editeProduct.description, price: double.parse(value.toString()), imageUrl: _editeProduct.imageUrl);
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 4,
                keyboardType: TextInputType.multiline,
                onSaved: (value){
                  _editeProduct = Product(id: _editeProduct.id, title: _editeProduct.toString(), description: value.toString(), price: _editeProduct.price, imageUrl: _editeProduct.imageUrl);
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
                      onFieldSubmitted: (_){
                        _saveForm();
                      },
                      onSaved: (value){
                        _editeProduct = Product(id: _editeProduct.id, title: _editeProduct.toString(), description: _editeProduct.description, price: _editeProduct.price, imageUrl: value.toString());
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
