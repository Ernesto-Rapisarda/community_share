import 'dart:io';

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
  late double _screenSize;
  ScrollController _scrollController = ScrollController();

  final ProductService _productService = ProductService();
  final UserService _userService = UserService();

  late List<Product> _products = [];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  late List<CommunityBasic> myCommunities = [];
  List<CommunityBasic> _selectedCommunities = [];
  String _urlImage = '';

  //'https://dfstudio-d420.kxcdn.com/wordpress/wp-content/uploads/2019/06/digital_camera_photo-1080x675.jpg';
  XFile? imageFile;
  bool _showImagePreview = false;

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

  void fetchData() async {
    try {
      List<Product> tmp =
          await _userService.getUserProducts(Auth().currentUser!.uid);
      setState(() {
        loaded = true;
        _products = tmp;
      });
    } catch (error) {
      callError(error.toString());
    }
  }

  void callError(String error) {
    showSnackBar(context, error, isError: true);
  }

  void _selectImages() async {
    imageFile = await ImageService().pickImage(ImageSource.gallery);
    if (imageFile != null) {
      //String? imageUrl = await ImageService().uploadImage(imageFile);
      /*setState(() {
        _imageUrl = imageUrl;
      });*/
      if (imageFile != null) {
        setState(() {
          _showImagePreview = true;
        });
      }
    }
  }

  Future<String?> uploadImage() async {
    return await ImageService().uploadImage(imageFile!);
  }

  bool checkAllFilled() {
    if (_titleController.text != '' &&
        _descriptionController.text != '' &&
        _locationController.text != '' &&
        _selectedCommunities.isNotEmpty &&
        imageFile != null) {
      return true;
    }
    return false;
  }

  void _saveProduct() async {
    if (checkAllFilled()) {
      String? urlImage = await uploadImage();

      Product product = Product(
          id: widget.isEdit
              ? context.read<ProductProvider>().productVisualized.id
              : IdGenerator.generateUniqueId(),
          title: _titleController.text,
          description: _descriptionController.text,
          urlImages: urlImage ?? '',
          locationProduct: _locationController.text,
          uploadDate: _uploadDate,
          lastUpdateDate: _lastUpdateDate,
          condition: _condition,
          availability: ProductAvailability.available,
          productCategory: _category,
          giver: context.read<UserProvider>().getUserBasic(),
          publishedOn: _selectedCommunities,
        search: _titleController.text.toLowerCase()
      );


      if (!widget.isEdit) {
        await _productService.createProduct(context, product);
        if (context.read<ProductProvider>().productVisualized.docRef != '') {
          setState(() {
            _products.insert(0, product);
            _titleController.text = '';
            _descriptionController.text = '';
            _locationController.text = '';
            _condition = ProductCondition.newWithTag;
            _category = ProductCategory.other;
            _selectedCommunities.clear();
            _showImagePreview = false;
            imageFile = null;
          });
          _scrollController.animateTo(
            0.0,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
          //context.go('/product/details/${product.id}');


        }
      } else {
        product.docRef =
            context.read<ProductProvider>().productVisualized.docRef;
        await _productService.updateProduct(context, product);
        Navigator.of(context).pop();
      }
    } else {
      callError(AppLocalizations.of(context)!.fillField);
    }
  }

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size.width - 36;

    return Scaffold(
/*      appBar: AppBar(
        title: widget.isEdit ? Text('Edit Product') : Text('Add Product'),
      ),*/
      body: SingleChildScrollView(
        controller: _scrollController,

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12, top: 12),
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
            Row(children: [
              !loaded
                  ? Center(
                      child: CircularLoadingIndicator.circularInd(context),
                    )
                  : _products.length > 0
                      ? SizedBox(
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
                                      child: ProductCard(
                                        product: _products[index],
                                        route:
                                            '/product/details/${_products[index].id}',
                                      )));
                            },
                          ),
                        )
                      : Expanded(
                        child: SizedBox(
                width: double.infinity,
                          child: Center(
                            child: Text(
                                AppLocalizations.of(context)!.nothingToShow,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                                textAlign: TextAlign.center,
                              ),
                          ),
                        ),
                      ),
            ]),
            Padding(
              padding: const EdgeInsets.only(
                  left: 12.0, right: 12, top: 20, bottom: 8),
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
              padding: const EdgeInsets.only(bottom: 12.0, left: 12, right: 12),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  color: Theme.of(context)!.colorScheme.secondaryContainer,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            border: Border.all(
                                width: 1,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSecondaryContainer),
                            color: Theme.of(context).colorScheme.background),
                        child: _showImagePreview
                            ? ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                child: Image(
                                  image: Image.file(File(imageFile?.path ?? ""))
                                      .image,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : SizedBox(
                                width: double.infinity,
                                height: 170,
                                child: Center(
                                    child: Text(
                                  AppLocalizations.of(context)!.noImageSelected,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                )),
                              ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      ElevatedButton(
                        onPressed: _selectImages,
                        child: Text('Select Images'),
                      ),
                      TextField(
                        controller: _titleController,
                        maxLength: 30,
                        onChanged: (text) {
                          setState(() {});
                        },
                        decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.title,
                            labelStyle: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).colorScheme.primary),
                            counterText: '${_titleController.text.length}/30'),
                      ),
                      TextField(
                        controller: _descriptionController,
                        maxLength: 200,
                        onChanged: (text) {
                          setState(() {});
                        },
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.description,
                          labelStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          counterText:
                              '${_descriptionController.text.length}/200',
                        ),
                      ),
                      TextField(
                        controller: _locationController,
                        decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.location,
                            labelStyle: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).colorScheme.primary)),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            AppLocalizations.of(context)!.condition,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
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
                                child: Text(productConditionToString(
                                    condition, context)),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            AppLocalizations.of(context)!.category,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
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
                                child: Text(
                                    productCategoryToString(category, context)),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.selectCommunities,
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).colorScheme.primary),
                          ),
                        ],
                      ),
                      ListView(
                        shrinkWrap: true,
                        children: myCommunities.map((community) {
                          bool isSelected =
                              _selectedCommunities.contains(community);
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
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12),
              child: Row(
                children: [
                  Expanded(
                      child: SizedBox(
                    width: double.infinity,
                  )),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: _showSummaryDialog,
                    child: Row(
                      children: [
                        FaIcon(
                          FontAwesomeIcons.floppyDisk,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          AppLocalizations.of(context)!.saveProduct,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onPrimary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.0),
          ],
        ),
      ),
    );
  }

  void _showSummaryDialog() {
    String publishedOn = _selectedCommunities
        .map((community) => community.name)
        .join(', ');
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.summary),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: _screenSize / 3,
                  height: _screenSize / 9 * 4,
                  child: ClipRRect(
                    borderRadius:
                    BorderRadius.all(Radius.circular(15)),
                    child: Image(
                      image: Image.file(File(imageFile?.path ?? ""))
                          .image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Center(child: Text('${_titleController.text}',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),)),
              SizedBox(height: 8,),
              Text('${_descriptionController.text}'),
              SizedBox(height: 8,),
              Text('${AppLocalizations.of(context)!.description}:',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600)),
              RichText(text: TextSpan(children: [
                TextSpan(text: '${AppLocalizations.of(context)!.category}: ',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.black)),
                TextSpan(text: productCategoryToString(_category, context),style: TextStyle(fontSize: 16,color: Colors.black))
              ]),),
              RichText(text: TextSpan(children: [
                TextSpan(text: '${AppLocalizations.of(context)!.condition}: ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.black)),
                TextSpan(text: productConditionToString(_condition, context),style: TextStyle(fontSize: 16,color: Colors.black))
              ]),),
              RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: 'Pubblicato su: ',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.black),
                    ),
                    TextSpan(
                      text: publishedOn,
                      style: TextStyle(fontSize: 16,color: Colors.black),
                    ),
                  ],)),

              SizedBox(height: 16),
              Text(AppLocalizations.of(context)!.confirmMessage,style: TextStyle(fontSize: 18),),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Chiudi il dialog senza salvare
              },
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Chiudi il dialog
                _saveProduct(); // Salva la community
              },
              child: Text(AppLocalizations.of(context)!.confirm),
            ),
          ],
        );
      },
    );
  }
}
