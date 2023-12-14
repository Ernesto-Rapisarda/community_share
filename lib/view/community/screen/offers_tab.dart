import 'package:community_share/providers/community_provider.dart';
import 'package:community_share/service/community_service.dart';
import 'package:community_share/view/generic_components/product_grid.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../model/basic/product_basic.dart';
import '../../../model/enum/product_category.dart';
import '../../../model/product.dart';
import '../../../utils/circular_load_indicator.dart';
import '../../../utils/show_snack_bar.dart';

class OffersTab extends StatefulWidget{
  const OffersTab({super.key});

  @override
  State<OffersTab> createState() => _OffersTabState();
}

class _OffersTabState extends State<OffersTab> {
  List<Product> _communityProducts = [];
  final CommunityService _communityService = CommunityService();
  final TextEditingController _searchController = TextEditingController();
  bool loaded = false;

  List<ProductCategory> filterCategories = [];
  List<ProductCategory> allCategories = ProductCategory.values;

  @override
  void initState() {
    super.initState();
    fetchProducts(allCategories);

  }

  void fetchProducts(List<ProductCategory> categories )async{
    try{
      setState(() {
        loaded = false;

      });

      List<Product> products = await _communityService.getCommunitysProducts(context);
      setState(() {
        loaded = true;
        _communityProducts = products;
      });
    }catch (error){
      callError(error.toString());
    }

  }

  void search(String text) {
    if (text.isNotEmpty && text.length >= 3) {
      _performSearch();
    } else if (text.isEmpty) {
      fetchProducts(allCategories);
    }
  }

  Future<void> _performSearch() async{
    if (_searchController.text.isNotEmpty && _searchController.text.length >= 3) {
      List<Product> foundProducts;
      try {
        /*foundProducts = await _productService.search(_searchController.text);
        setState(() {
          _products = foundProducts;
        });*/
      } catch (error) {
        callError(error.toString());
      }
    } else if (_searchController.text.isEmpty) {
      fetchProducts(allCategories);
    }

  }

  void callError(String error){
    showSnackBar(context, error, isError: true);
  }



  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 12, bottom: 12),
            child: Column(
              children: [
                SizedBox(height: 12,),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        style: TextStyle(fontSize: 16),
                        onChanged: search,
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!.search,
                          contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.search),
                            onPressed: () {
                              search;
                            },
                          ),

                        ),
                      ),
                    ),
                    SizedBox(width: 12,),
                    ElevatedButton(
                      onPressed: () {
                        _showFilterDialog(context);
                      },
                      child: Text(AppLocalizations.of(context)!.filter),
                    ),
                  ],)

              ],
            ),

          ),
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
            child: !loaded
                ? Center(
              child: CircularLoadingIndicator.circularInd(context),
            )
                : ProductGrid(_communityProducts,route: '/communities/home/${context.read<CommunityProvider>().community.id}/product/details/'),
          ),
          //ProductGrid(_communityProducts, route: '/communities/home/${context.read<CommunityProvider>().community.id}/product/details/',),
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
                    label: Text(productCategoryToString(category, context)/* category
                        .toString()
                        .split('.')
                        .last*/), // Rimuove il prefisso dell'enum
                    selected: filterCategories.contains(category),
                    selectedColor:
                    Theme.of(context).colorScheme.primaryContainer,

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
                  FaIcon(
                    FontAwesomeIcons.check,
                    size: 14,
                  ),
                  SizedBox(
                    width: 4,
                  ),
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

