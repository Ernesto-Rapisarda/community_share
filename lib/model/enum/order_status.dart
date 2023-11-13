enum OrderStatus {
  pending,
  productDeliveredToHotSpot,
  completed
}

OrderStatus orderStatusFromString(String value) {
  print('value $value');
  switch (value) {
    case 'productDeliveredToHotSpot':
      return OrderStatus.productDeliveredToHotSpot;
    case 'completed':
      return OrderStatus.completed;
    default:
      return OrderStatus.pending;
  }
}