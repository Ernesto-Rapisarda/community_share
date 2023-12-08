import 'package:community_share/model/enum/product_category.dart';
import 'package:community_share/providers/UserProvider.dart';
import 'package:community_share/providers/product_provider.dart';
import 'package:community_share/service/auth.dart';
import 'package:community_share/service/user_service.dart';
import 'package:community_share/utils/id_generator.dart';
import 'package:community_share/view/product/product_card.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../model/basic/community_basic.dart';
import '../../model/community.dart';
import '../../model/enum/product_availability.dart';
import '../../model/enum/product_condition.dart';
import '../../model/product.dart';
import '../../service/image_service.dart';
import '../../service/product_service.dart';
import '../../utils/circular_load_indicator.dart';
import '../../utils/show_snack_bar.dart';

class AddProduct extends StatefulWidget {
  final bool isEdit;

  const AddProduct({super.key, required this.isEdit});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  bool loaded = false;
  final ProductService _productService = ProductService();
  final UserService _userService = UserService();

  late List<Product> _products = [];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  late List<CommunityBasic> myCommunities = [];
  List<CommunityBasic> _selectedCommunities = [];
  String _urlImage =
      'https://dfstudio-d420.kxcdn.com/wordpress/wp-content/uploads/2019/06/digital_camera_photo-1080x675.jpg';

  DateTime _uploadDate = DateTime.now();
  DateTime _lastUpdateDate = DateTime.now();

  ProductCondition _condition = ProductCondition.newWithTag;
  ProductCategory _category = ProductCategory.other;

  @override
  void initState() {
    super.initState();
    fetchData();
    myCommunities = context.read<UserProvider>().getListCommunityBasic();
    if (widget.isEdit) {
      Product product = context.read<ProductProvider>().productVisualized;
      _titleController.text = product.title;
      _descriptionController.text = product.description;
      _locationController.text = product.locationProduct;
      _urlImage = product.urlImages;
      _condition = product.condition;
      _category = product.productCategory;
      _selectedCommunities = product.publishedOn;
    }
  }

  void fetchData()async{
    try{
      List<Product> tmp = await _userService.getUserProducts(Auth().currentUser!.uid);
      setState(() {
        loaded = true;
        _products = tmp;
      });
    }catch (error){
      callError(error.toString());
    }
  }
  void callError(String error){
    showSnackBar(context, error, isError: true);
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
        id: widget.isEdit
            ? context.read<ProductProvider>().productVisualized.id
            : IdGenerator.generateUniqueId(),
        title: _titleController.text,
        description: _descriptionController.text,
        urlImages: _urlImage,
        locationProduct: _locationController.text,
        uploadDate: _uploadDate,
        lastUpdateDate: _lastUpdateDate,
        condition: _condition,
        availability: ProductAvailability.available,
        productCategory: _category,
        giver: context.read<UserProvider>().getUserBasic(),
        publishedOn: _selectedCommunities);


    if (!widget.isEdit) {
      await _productService.createProduct(context, product);
      if (context.read<ProductProvider>().productVisualized.docRef != '') {
        context.go('/product/details/${product.id}');
      }
    } else {
      product.docRef = context.read<ProductProvider>().productVisualized.docRef;
      await _productService.updateProduct(context, product);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
/*      appBar: AppBar(
        title: widget.isEdit ? Text('Edit Product') : Text('Add Product'),
      ),*/
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 12.0,right: 12, top: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                  FaIcon(FontAwesomeIcons.handHoldingHeart,
                      size: 20, color: Theme.of(context).colorScheme.primary),
                  SizedBox(
                    width: 8,
                  ),
                  Text(AppLocalizations.of(context)!.yourDonationsForAdd,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Theme.of(context).colorScheme.primary)),
                ],
              ),
            ),
            Row(
              children: [
              !loaded
                  ? Center(
                child: CircularLoadingIndicator.circularInd(context),
              )
              :SizedBox(
               width: MediaQuery.of(context).size.width,
                height: 270,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _products.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                          height: 220,
                          width: 220,
                          child: ProductCard(product: _products[index], route: '/product/details/',))

                      );
                  },
                ),
              ),
              ]

            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0,right: 12, top: 20, bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FaIcon(FontAwesomeIcons.heartCirclePlus,
                      size: 20, color: Theme.of(context).colorScheme.primary),
                  SizedBox(
                    width: 8,
                  ),
                  Text(AppLocalizations.of(context)!.addAGift,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Theme.of(context).colorScheme.primary)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0,left: 12,right: 12),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  color: Theme.of(context)!.colorScheme.secondaryContainer,

                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        border: Border.all(width: 1,color: Theme.of(context).colorScheme.onSecondaryContainer)
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        child: Image.network(
                          _urlImage,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: 8,),
                    ElevatedButton(
                      onPressed: _selectImages,
                      child: Text('Select Images'),
                    ),
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(labelText: 'Title',
                        contentPadding:
                        const EdgeInsets.only(left: 10.0),
                        enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(width: 1),
                            borderRadius:
                            BorderRadius.circular(10.0)),

                      ),
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
                    Text('Select the communities:'),
                    ListView(
                      shrinkWrap: true,
                      children: myCommunities.map((community) {
                        bool isSelected = _selectedCommunities.contains(community);
                        return CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          title: Text(community.name),
                          value: isSelected,
                          onChanged: (value) {
                            setState(() {
                              if (value!) {
                                _selectedCommunities.add(community);
                              } else {
                                _selectedCommunities.remove(community);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],),
                ),
              ),
            ),

            /*SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _saveProduct,
              child: Text('Save Product'),
            ),*/
          ],
        ),
      ),

    );
  }
}
