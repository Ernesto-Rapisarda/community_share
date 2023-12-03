import 'package:flutter/cupertino.dart';

enum ProductAvailability{
  available,
  pending,
  donated,
  unknown
}

ProductAvailability productAvailabilityFromString(String value) {
  switch (value) {
    case 'available':
      return ProductAvailability.available;
    case 'pending':
      return ProductAvailability.pending;
    case 'donated':
      return ProductAvailability.donated;
    default:
      return ProductAvailability.unknown;
  }
}

String productAvailabilityToString (ProductAvailability productAvailability, BuildContext context){
  switch (productAvailability){
    case ProductAvailability.available:
      return 'disponibile';
    case ProductAvailability.pending:
      return 'in sospeso';
    case ProductAvailability.donated:
      return 'donato';
    default:
      return 'sconosciuto';
  }
}