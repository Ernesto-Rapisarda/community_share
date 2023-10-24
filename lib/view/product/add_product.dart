import 'package:community_share/providers/UserProvider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../model/enum/product_availability.dart';
import '../../model/enum/product_condition.dart';
import '../../model/product.dart';
import '../../service/image_service.dart';
import '../../service/product_service.dart';

class AddProduct extends StatefulWidget{
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  String _urlImage = 'https://dfstudio-d420.kxcdn.com/wordpress/wp-content/uploads/2019/06/digital_camera_photo-1080x675.jpg';

  DateTime _uploadDate = DateTime.now();
  DateTime _lastUpdateDate = DateTime.now();

  ProductCondition _condition = ProductCondition.newWithTag;
  ProductAvailability _availability = ProductAvailability.available;


  void _selectImages() async {
    XFile? imageFile = await ImageService().pickImage(ImageSource.gallery);
    if (imageFile != null) {
      String? imageUrl = await ImageService().uploadImage(imageFile);
      /*setState(() {
        _imageUrl = imageUrl;
      });*/
      if(imageUrl != null){
        setState(() {
          _urlImage = imageUrl;
        });
      }
    }
  }

  // Metodo per salvare il prodotto nel database
  void _saveProduct() {
    print(context.read<UserProvider>().userDetails);
    // Costruisci un oggetto Product utilizzando i dati inseriti dall'utente
    Product product = Product(
      title: _titleController.text,
      description: _descriptionController.text,
      urlImages: _urlImage,
      locationProduct: _locationController.text,
      uploadDate: _uploadDate,
      lastUpdateDate: _lastUpdateDate,
      condition: _condition,
      availability: _availability,
      giver: context.read<UserProvider>().getUserBasic()
    );

    ProductService().createProduct(context, product);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
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