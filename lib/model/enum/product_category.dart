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