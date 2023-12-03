import 'package:flutter/cupertino.dart';

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

String productConditionToString (ProductCondition productCondition, BuildContext context){
  switch (productCondition){
    case ProductCondition.newWithTag:
      return 'nuovo con cartellino';
    case ProductCondition.newWithoutTag:
      return 'nuovo senza cartellino';
    case ProductCondition.veryGood:
      return 'molto buone';
    case ProductCondition.good:
      return 'buone';
    case ProductCondition.acceptable:
      return 'accettabili';
    default:
      return 'sconosciute';
  }
}