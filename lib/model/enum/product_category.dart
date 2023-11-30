import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum ProductCategory {
  homeAndGarden,
  consoleAndVideogames,
  cinemaAndBookAndMusic,
  phoneAndAccessories,
  itAndElectronics,
  clothingAndAccessories,
  sportAndHobby,
  homeAppliances,
  other
}

ProductCategory productCategoryFromString(String value) {
  switch (value) {
    case 'homeAndGarden':
      return ProductCategory.homeAndGarden;
    case 'consoleAndVideogames':
      return ProductCategory.consoleAndVideogames;
    case 'cinemaAndBookAndMusic':
      return ProductCategory.cinemaAndBookAndMusic;
    case 'phoneAndAccessories':
      return ProductCategory.phoneAndAccessories;
    case 'itAndElectronics':
      return ProductCategory.itAndElectronics;
    case 'clothingAndAccessories':
      return ProductCategory.clothingAndAccessories;
    case 'sportAndHobby':
      return ProductCategory.sportAndHobby;
    case 'homeAppliances':
      return ProductCategory.homeAppliances;
    default:
      return ProductCategory.other;
  }
}

String productCategoryToString(ProductCategory category,BuildContext context) {
  switch (category) {
    case ProductCategory.homeAndGarden:
      return AppLocalizations.of(context)!.homeAndGarden;
    case ProductCategory.consoleAndVideogames:
      return AppLocalizations.of(context)!.consoleAndVideogames;
    case ProductCategory.cinemaAndBookAndMusic:
      return AppLocalizations.of(context)!.cinemaAndBookAndMusic;
    case ProductCategory.phoneAndAccessories:
      return AppLocalizations.of(context)!.phoneAndAccessories;
    case ProductCategory.itAndElectronics:
      return AppLocalizations.of(context)!.itAndElectronics;
    case ProductCategory.clothingAndAccessories:
      return AppLocalizations.of(context)!.clothingAndAccessories;
    case ProductCategory.sportAndHobby:
      return AppLocalizations.of(context)!.sportAndHobby;
    case ProductCategory.homeAppliances:
      return AppLocalizations.of(context)!.homeAppliances;
    default:
      return AppLocalizations.of(context)!.other;
  }
}