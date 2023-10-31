enum ProductCondition {
  newWithTag,
  newWithoutTag,
  veryGood,
  good,
  acceptable,
  unknown
}

ProductCondition productConditionFromString(String value) {
  switch (value) {
    case 'newWithTag':
      return ProductCondition.newWithTag;
    case 'newWithoutTag':
      return ProductCondition.newWithoutTag;
    case 'veryGood':
      return ProductCondition.veryGood;
    case 'good':
      return ProductCondition.good;
    case 'acceptable':
      return ProductCondition.acceptable;
    default:
      return ProductCondition.unknown;
  }
}