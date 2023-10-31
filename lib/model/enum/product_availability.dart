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