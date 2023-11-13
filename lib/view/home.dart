import 'package:community_share/model/enum/product_category.dart';
import 'package:community_share/service/product_service.dart';
import 'package:community_share/utils/circular_load_indicator.dart';
import 'package:community_share/view/generic_components/product_grid.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../model/enum/product_condition.dart';
import '../model/product.dart';
import '../utils/show_snack_bar.dart';

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool loaded = false;
  late List<Product> _products =[];
  List<ProductCategory> filterCategories = [];
  List<ProductCategory> allCategories = ProductCategory.values;

  Future<void> fetchProducts(List<ProductCategory> categories) async{
    try {
      setState(() {
        loaded = false;
      });
      if(categories.isEmpty){
        categories = allCategories;
      }
      List<Product> products = await ProductService().getProducts(context, categories);
      setState(() {
        _products = products;
        loaded = true;
      });
    } catch (error) {
      showSnackBar(context, error.toString());
    }
  }

  @override
  void initState(){
    super.initState();
    fetchProducts(allCategories);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 8,),
          Padding(
            padding: const EdgeInsets.only(left: 12.0,right: 12),
            child: Row(
              children: [
                Text('Products from your community',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Theme.of(context).colorScheme.primary),),
                Expanded(child: SizedBox(width: double.infinity,)),
                ElevatedButton(
                  onPressed: () {
                    _showFilterDialog(context);
                  },
                  child: Text('Filter'),
                ),
              ]

            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12,right: 12, bottom: 12),
            child: !loaded ? Center(child: CircularLoadingIndicator.circularInd(context),) : ProductGrid(_products),
          ),
          //SizedBox(height: 500,)
        ],
      ),
    );
  }

  Future<void> _showFilterDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Filter by Category'),
          content: Container(
            width: double.maxFinite,
            child: Wrap(
              spacing: 4.0,
              runSpacing: 2.0,
              children: [
                for (ProductCategory category in allCategories)
                  FilterChip(
                    label: Text(category.toString().split('.').last), // Rimuove il prefisso dell'enum
                    selected: filterCategories.contains(category),
                    selectedColor: Theme.of(context).colorScheme.primaryContainer,

                    onSelected: (bool selected) {
                      setState(() {
                        if (selected) {
                          filterCategories.add(category);

                        } else {
                          filterCategories.remove(category);
                        }
                        //todo fixare e capire perchè non funziona il selectedcolor senza ricaricare la schermata
                        Navigator.of(context).pop();
                        _showFilterDialog(context);
                      });
                    },
                  ),
              ],
            ),
          ),
          actions: [
            OutlinedButton(

              onPressed: () {
                Navigator.of(context).pop();
                fetchProducts(filterCategories);
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FaIcon(FontAwesomeIcons.check,size: 14,),
                  SizedBox(width: 4,),
                  Text('Apply'),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
