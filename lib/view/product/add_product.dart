import 'package:community_share/model/enum/product_category.dart';
import 'package:community_share/providers/UserProvider.dart';
import 'package:community_share/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../model/enum/product_availability.dart';
import '../../model/enum/product_condition.dart';
import '../../model/product.dart';
import '../../service/image_service.dart';
import '../../service/product_service.dart';

class AddProduct extends StatefulWidget {
  final bool isEdit;

  const AddProduct({super.key, required this.isEdit});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final ProductService _productService = ProductService();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  String _urlImage =
      'https://dfstudio-d420.kxcdn.com/wordpress/wp-content/uploads/2019/06/digital_camera_photo-1080x675.jpg';

  DateTime _uploadDate = DateTime.now();
  DateTime _lastUpdateDate = DateTime.now();

  ProductCondition _condition = ProductCondition.newWithTag;
  ProductAvailability _availability = ProductAvailability.available;
  ProductCategory _category = ProductCategory.other;

  @override
  void initState() {
    super.initState();
    if (widget.isEdit) {
      Product product = context.read<ProductProvider>().productVisualized;
      _titleController.text = product.title;
      _descriptionController.text = product.description;
      _locationController.text = product.locationProduct;
      _urlImage = product.urlImages;
      _condition = product.condition;
      _availability = product.availability;
      _category = product.productCategory;
    }
  }

  void _selectImages() async {
    XFile? imageFile = await ImageService().pickImage(ImageSource.gallery);
    if (imageFile != null) {
      String? imageUrl = await ImageService().uploadImage(imageFile);
      /*setState(() {
        _imageUrl = imageUrl;
      });*/
      if (imageUrl != null) {
        setState(() {
          _urlImage = imageUrl;
        });
      }
    }
  }

  // Metodo per salvare il prodotto nel database
  void _saveProduct() async {
    Product product = Product(
        title: _titleController.text,
        description: _descriptionController.text,
        urlImages: _urlImage,
        locationProduct: _locationController.text,
        uploadDate: _uploadDate,
        lastUpdateDate: _lastUpdateDate,
        condition: _condition,
        availability: _availability,
        productCategory: _category,
        giver: context.read<UserProvider>().getUserBasic());

    if(!widget.isEdit){
      String productID = await _productService.createProduct(context, product);
      if (productID != '') {
        product.id = productID;
        context.read<ProductProvider>().setProductVisualized(context, product);
        context.go('/product/details/${productID}');
      }
    }
    else{
      product.id = context.read<ProductProvider>().productVisualized.id;
      await _productService.updateProduct(context, product);
      context.read<ProductProvider>().setProductVisualized(context, product);
      Navigator.of(context).pop();
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.isEdit ? Text('Edit Product') : Text('Add Product'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Image.network(_urlImage),
              ),
              ElevatedButton(
                onPressed: _selectImages,
                child: Text('Select Images'),
              ),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: _locationController,
                decoration: InputDecoration(labelText: 'Location'),
              ),
              Row(
                children: <Widget>[
                  Text('Condition: '),
                  DropdownButton<ProductCondition>(
                    value: _condition,
                    onChanged: (newValue) {
                      setState(() {
                        _condition = newValue!;
                      });
                    },
                    items: ProductCondition.values.map((condition) {
                      return DropdownMenuItem<ProductCondition>(
                        value: condition,
                        child: Text(condition.toString().split('.')[1]),
                      );
                    }).toList(),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Text('Availability: '),
                  DropdownButton<ProductAvailability>(
                    value: _availability,
                    onChanged: (newValue) {
                      setState(() {
                        _availability = newValue!;
                      });
                    },
                    items: ProductAvailability.values.map((availability) {
                      return DropdownMenuItem<ProductAvailability>(
                        value: availability,
                        child: Text(availability.toString().split('.')[1]),
                      );
                    }).toList(),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Text('Category: '),
                  DropdownButton<ProductCategory>(
                    value: _category,
                    onChanged: (newValue) {
                      setState(() {
                        _category = newValue!;
                      });
                    },
                    items: ProductCategory.values.map((category) {
                      return DropdownMenuItem<ProductCategory>(
                        value: category,
                        child: Text(category.toString().split('.')[1]),
                      );
                    }).toList(),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _saveProduct,
                child: Text('Save Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  
}
