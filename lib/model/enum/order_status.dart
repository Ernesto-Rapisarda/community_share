enum OrderStatus {
  pending,
  productDelivered,
  completed
}

OrderStatus orderStatusFromString(String value) {
  print('value $value');
  switch (value) {
    case 'productDelivered':
      return OrderStatus.productDelivered;
    case 'completed':
      return OrderStatus.completed;
    default:
      return OrderStatus.pending;
  }
}