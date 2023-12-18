import 'package:community_share/model/enum/product_category.dart';
import 'package:community_share/providers/community_provider.dart';
import 'package:community_share/service/community_service.dart';
import 'package:community_share/service/product_service.dart';
import 'package:community_share/utils/circular_load_indicator.dart';
import 'package:community_share/view/generic_components/product_grid.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../model/community.dart';
import '../model/enum/product_condition.dart';
import '../model/event.dart';
import '../model/product.dart';
import '../utils/show_snack_bar.dart';

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final CommunityService _communityService = CommunityService();
  final ProductService _productService = ProductService();
  final TextEditingController _searchController = TextEditingController();

  bool loadedEvents = false;
  bool loadedProducts = false;
  late List<Product> _products = [];
  late List<Event> _incomingEvents = [];
  List<ProductCategory> filterCategories = [];
  List<ProductCategory> allCategories = ProductCategory.values;

  Future<void> fetchProducts(List<ProductCategory> categories) async {
    try {
      setState(() {
        loadedProducts = false;
      });

      if (categories.isEmpty) {
        categories = allCategories;
      }

      List<Product> newProducts =
          await _productService.getProducts(context, categories);

      setState(() {
        _products.clear();
        _products.addAll(newProducts);
        loadedProducts = true;
      });
    } catch (error) {
      callError(error.toString());
    }
  }

  Future<void> fetchEvents() async {
    try {
      List<Event> events =
          await _communityService.getIncomingEventsFromMyCommunities(context);

      setState(() {
        _incomingEvents = events;
        loadedEvents = true;
      });
    } catch (error) {
      callError(error.toString());
    }
  }

  void search(String text) {
    if (text.isNotEmpty && text.length >= 3) {
      _performSearch();
    } else if (text.isEmpty) {
      fetchEvents();
      fetchProducts(allCategories);
    }
  }

  Future<void> _performSearch() async {
    if (_searchController.text.isNotEmpty &&
        _searchController.text.length >= 3) {
      List<Product> foundProducts;
      try {
        foundProducts = await _productService.search(_searchController.text);
        setState(() {
          _products = foundProducts;
        });
      } catch (error) {
        callError(error.toString());
      }
    } else if (_searchController.text.isEmpty) {
      fetchEvents();
      fetchProducts(allCategories);
    }
  }

  void callError(String error) {
    showSnackBar(context, error, isError: true);
  }

  @override
  void initState() {
    super.initState();
    fetchEvents();
    fetchProducts(allCategories);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 8,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 12),
            child: Row(children: [
              FaIcon(FontAwesomeIcons.calendarDays,
                  size: 20, color: Theme.of(context).colorScheme.primary),
              SizedBox(
                width: 8,
              ),
              Text(
                AppLocalizations.of(context)!.incomingEvents,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Theme.of(context).colorScheme.primary),
              ),
            ]),
          ),
          SizedBox(
            height: 8,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
            child: !loadedEvents
                ? Center(
                    child: CircularLoadingIndicator.circularInd(context),
                  )
                : _buildEventListView(),
          ),
          //SizedBox(height: 500,)
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 12, bottom: 12),
            child: Column(
              children: [
                Row(
                  children: [
                    FaIcon(
                      FontAwesomeIcons.handHoldingHeart,
                      size: 20,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      AppLocalizations.of(context)!.fromYourCommunities,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  ],
                ),
                SizedBox(
                  height: 12,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        style: TextStyle(fontSize: 16),
                        onChanged: search,
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!.search,
                          contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
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
                    SizedBox(
                      width: 12,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _showFilterDialog(context);
                      },
                      child: Text(AppLocalizations.of(context)!.filter),
                    ),
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
            child: !loadedProducts
                ? Center(
                    child: CircularLoadingIndicator.circularInd(context),
                  )
                : _products.length > 0
                    ? ProductGrid(_products, route: '/product/details/')
                    : SizedBox(
                      width: double.infinity,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              ClipOval(
                                child: Container(
                                  width: 60,
                                  height: 100,
                                  color: Theme.of(context).colorScheme.primaryContainer,
                                  child: CircleAvatar(
                                    radius: 60,
                                    backgroundImage: AssetImage('assets/images/logoCS.png'),
                                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                                  ),
                                ),


                              ),
                              SizedBox(width: 8,),
                              Expanded(
                                child: Text(
                                  AppLocalizations.of(context)!.nothingToShow,
                                  style: TextStyle(
                                      fontSize: 20, fontWeight: FontWeight.w500),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
          ),
          //SizedBox(height: 500,)
        ],
      ),
    );
  }

  Widget _buildEventListView() {
    if (_incomingEvents.isEmpty) {
      return Center(
        child: Text(AppLocalizations.of(context)!.noUpcomingEvents),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _incomingEvents.length,
      itemBuilder: (context, index) {
        bool isEven = index % 2 == 0;
        Color backgroundColor =
            isEven ? Colors.grey.withOpacity(0.1) : Colors.transparent;
        return InkWell(
          onTap: () => _openCommunity(_incomingEvents[index]),
          child: Container(
            height: 60,
            child: ListTile(
              tileColor: backgroundColor,
              visualDensity: VisualDensity(horizontal: 0, vertical: -4),
              //dense: true,
              title: Text(_incomingEvents[index].title),
              subtitle: Text(
                '${_incomingEvents[index].docRefCommunityName}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          'Date ${_incomingEvents[index].eventDate.day}/${_incomingEvents[index].eventDate.month}/${_incomingEvents[index].eventDate.year}'),
                      Text(
                          'Time ${_incomingEvents[index].eventDate.hour.toString().padLeft(2, '0')}:${_incomingEvents[index].eventDate.minute.toString().padLeft(2, '0')}'),
                    ],
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [FaIcon(FontAwesomeIcons.chevronRight)],
                  )
                ],
              ),
            ),
          ),
        );
      },
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
                    label: Text(productCategoryToString(category,
                            context) /* category
                        .toString()
                        .split('.')
                        .last*/
                        ), // Rimuove il prefisso dell'enum
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

  _openCommunity(Event incomingEvent) async {
    try {
      Community community =
          await _communityService.getCommunity(incomingEvent.docRefCommunity!);
      _openCommunityHome(community);
    } catch (error) {
      callError(error.toString());
    }
  }

  _openCommunityHome(Community community) {
    context.read<CommunityProvider>().community = community;
    context.go('/communities/home/${community.name}');
  }
}
