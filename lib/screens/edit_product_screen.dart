import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products_provider.dart';

class EditProductScreen extends StatefulWidget {
  static const String routeName = "/edit-product";
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey();
  bool _isInit = true;
  bool _newProduct = true;
  bool _isLoading = false;
  Product _editedProduct = Product(
    id: "",
    title: "",
    description: "",
    price: 0,
    imageUrl: "",
  );

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImagePreview);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImagePreview);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final passedProduct = ModalRoute.of(context).settings.arguments;
      if (passedProduct != null) {
        print("Previews Product");
        _editedProduct = passedProduct;
        _imageUrlController.text = _editedProduct.imageUrl;
        _newProduct = false;
      }
      _isInit = false;
    }

    super.didChangeDependencies();
  }

  void _updateImagePreview() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  void _saveForm() async {
    final isValid = _form.currentState.validate();
    if (isValid) {
      _form.currentState.save();
      setState(() {
        _isLoading = true;
      });
      if (_newProduct) {
        try {
          await Provider.of<Products>(context).addProduct(_editedProduct);
        } catch (err) {
          await showDialog<String>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text("An error accurd"),
              content: Text("Something went wrong..."),
              actions: <Widget>[
                FlatButton(
                  child: Text("OK"),
                  onPressed: () => Navigator.of(ctx).pop(),
                )
              ],
            ),
          );
        }
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      } else {
        Provider.of<Products>(context).updateProduct(_editedProduct);
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      }
    }
  }

  Widget _saveButtonBuilder(Function onTap) {
    return LayoutBuilder(
      builder: (context, constraints) {
        print(
            "width: ${constraints.maxWidth}, height: ${constraints.maxHeight}");
        return Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(right: 8),
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Save"),
            ),
            onTap: onTap,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Edit Product"),
        actions: <Widget>[
          _saveButtonBuilder(_saveForm),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        initialValue: _newProduct ? "" : _editedProduct.title,
                        decoration: InputDecoration(labelText: "Title"),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) => FocusScope.of(context)
                            .requestFocus(_priceFocusNode),
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please enter a title";
                          }
                          return null;
                        },
                        onSaved: (newValue) => _editedProduct = Product(
                          id: _editedProduct.id,
                          isFavorite: _editedProduct.isFavorite,
                          title: newValue,
                          price: _editedProduct.price,
                          description: _editedProduct.description,
                          imageUrl: _editedProduct.imageUrl,
                        ),
                      ),
                      TextFormField(
                        initialValue:
                            _newProduct ? "" : _editedProduct.price.toString(),
                        decoration: InputDecoration(labelText: "Price"),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _priceFocusNode,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please enter a price";
                          }
                          if (double.tryParse(value) == null) {
                            return "Please enter a valid number";
                          }
                          if (double.parse(value) <= 0) {
                            return "Please enter a number above zero";
                          }
                          return null;
                        },
                        onFieldSubmitted: (value) => FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode),
                        onSaved: (newValue) => _editedProduct = Product(
                          id: _editedProduct.id,
                          isFavorite: _editedProduct.isFavorite,
                          title: _editedProduct.title,
                          price: double.parse(newValue),
                          description: _editedProduct.description,
                          imageUrl: _editedProduct.imageUrl,
                        ),
                      ),
                      TextFormField(
                        initialValue:
                            _newProduct ? "" : _editedProduct.description,
                        decoration: InputDecoration(
                          labelText: "Description",
                        ),
                        keyboardType: TextInputType.multiline,
                        maxLines: 3,
                        focusNode: _descriptionFocusNode,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please enter a description";
                          }
                          return null;
                        },
                        onSaved: (newValue) => _editedProduct = Product(
                          id: _editedProduct.id,
                          isFavorite: _editedProduct.isFavorite,
                          title: _editedProduct.title,
                          price: _editedProduct.price,
                          description: newValue,
                          imageUrl: _editedProduct.imageUrl,
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            width: 100,
                            height: 100,
                            margin: EdgeInsets.only(right: 10, top: 10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Colors.grey,
                              ),
                            ),
                            child: _imageUrlController.text.isEmpty
                                ? Center(child: Text("Enter a URL"))
                                : Image.network(
                                    _imageUrlController.text,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration:
                                  InputDecoration(labelText: "Image URL"),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              controller: _imageUrlController,
                              focusNode: _imageUrlFocusNode,
                              onChanged: (_) => setState(() {}),
                              onFieldSubmitted: (value) => _saveForm(),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Please enter a image Url";
                                }
                                return null;
                              },
                              onSaved: (newValue) => _editedProduct = Product(
                                id: _editedProduct.id,
                                isFavorite: _editedProduct.isFavorite,
                                title: _editedProduct.title,
                                price: _editedProduct.price,
                                description: _editedProduct.description,
                                imageUrl: newValue,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
