import 'package:community_share/view/generic_components/product_grid.dart';
import 'package:flutter/material.dart';

import '../model/enum/product_condition.dart';
import '../model/product.dart';

class MainPage extends StatelessWidget {
  MainPage({super.key});

  final List<Product> products = [
    Product(
        id: '1',
        title: 'Sample Product',
        description: 'This is a sample product description.',
        uploadDate: '2023-10-13',
        condition: ProductCondition.newWithTag,
        likesNumber: 100,
        urlImage:
            'https://as1.ftcdn.net/v2/jpg/02/65/23/70/1000_F_265237090_Muthvb72m2POYFjyx7F5UCQLh9JdBtKN.jpg'),
    Product(
        id: '1',
        title: 'Sample Product',
        description: 'This is a sample product description.',
        uploadDate: '2023-10-13',
        condition: ProductCondition.newWithTag,
        likesNumber: 100,
        urlImage:
        'https://as1.ftcdn.net/v2/jpg/02/65/23/70/1000_F_265237090_Muthvb72m2POYFjyx7F5UCQLh9JdBtKN.jpg'),
    Product(
        id: '1',
        title: 'Sample Product',
        description: 'This is a sample product description.',
        uploadDate: '2023-10-13',
        condition: ProductCondition.newWithTag,
        likesNumber: 100,
        urlImage:
        'https://as1.ftcdn.net/v2/jpg/02/65/23/70/1000_F_265237090_Muthvb72m2POYFjyx7F5UCQLh9JdBtKN.jpg'),
    Product(
        id: '1',
        title: 'Sample Product',
        description: 'This is a sample product description.',
        uploadDate: '2023-10-13',
        condition: ProductCondition.newWithTag,
        likesNumber: 100,
        urlImage:
        'https://as1.ftcdn.net/v2/jpg/02/65/23/70/1000_F_265237090_Muthvb72m2POYFjyx7F5UCQLh9JdBtKN.jpg'),
    Product(
        id: '1',
        title: 'Sample Product',
        description: 'This is a sample product description.',
        uploadDate: '2023-10-13',
        condition: ProductCondition.newWithTag,
        likesNumber: 100,
        urlImage:
        'https://as1.ftcdn.net/v2/jpg/02/65/23/70/1000_F_265237090_Muthvb72m2POYFjyx7F5UCQLh9JdBtKN.jpg'),
    Product(
        id: '1',
        title: 'Sample Product',
        description: 'This is a sample product description.',
        uploadDate: '2023-10-13',
        condition: ProductCondition.newWithTag,
        likesNumber: 100,
        urlImage:
        'https://as1.ftcdn.net/v2/jpg/02/65/23/70/1000_F_265237090_Muthvb72m2POYFjyx7F5UCQLh9JdBtKN.jpg'),
    Product(
        id: '1',
        title: 'Sample Product',
        description: 'This is a sample product description.',
        uploadDate: '2023-10-13',
        condition: ProductCondition.newWithTag,
        likesNumber: 100,
        urlImage:
        'https://as1.ftcdn.net/v2/jpg/02/65/23/70/1000_F_265237090_Muthvb72m2POYFjyx7F5UCQLh9JdBtKN.jpg'),
    Product(
        id: '1',
        title: 'Sample Product',
        description: 'This is a sample product description.',
        uploadDate: '2023-10-13',
        condition: ProductCondition.newWithTag,
        likesNumber: 100,
        urlImage:
        'https://as1.ftcdn.net/v2/jpg/02/65/23/70/1000_F_265237090_Muthvb72m2POYFjyx7F5UCQLh9JdBtKN.jpg'),
    Product(
        id: '1',
        title: 'Sample Product',
        description: 'This is a sample product description.',
        uploadDate: '2023-10-13',
        condition: ProductCondition.newWithTag,
        likesNumber: 100,
        urlImage:
        'https://as1.ftcdn.net/v2/jpg/02/65/23/70/1000_F_265237090_Muthvb72m2POYFjyx7F5UCQLh9JdBtKN.jpg'),
    Product(
        id: '1',
        title: 'Sample Product',
        description: 'This is a sample product description.',
        uploadDate: '2023-10-13',
        condition: ProductCondition.newWithTag,
        likesNumber: 100,
        urlImage:
        'https://as1.ftcdn.net/v2/jpg/02/65/23/70/1000_F_265237090_Muthvb72m2POYFjyx7F5UCQLh9JdBtKN.jpg'),
    Product(
        id: '1',
        title: 'Sample Product',
        description: 'This is a sample product description.',
        uploadDate: '2023-10-13',
        condition: ProductCondition.newWithTag,
        likesNumber: 100,
        urlImage:
        'https://as1.ftcdn.net/v2/jpg/02/65/23/70/1000_F_265237090_Muthvb72m2POYFjyx7F5UCQLh9JdBtKN.jpg'),
    Product(
        id: '1',
        title: 'Sample Product',
        description: 'This is a sample product description.',
        uploadDate: '2023-10-13',
        condition: ProductCondition.newWithTag,
        likesNumber: 100,
        urlImage:
        'https://as1.ftcdn.net/v2/jpg/02/65/23/70/1000_F_265237090_Muthvb72m2POYFjyx7F5UCQLh9JdBtKN.jpg'),
    Product(
        id: '1',
        title: 'Sample Product',
        description: 'This is a sample product description.',
        uploadDate: '2023-10-13',
        condition: ProductCondition.newWithTag,
        likesNumber: 100,
        urlImage:
        'https://as1.ftcdn.net/v2/jpg/02/65/23/70/1000_F_265237090_Muthvb72m2POYFjyx7F5UCQLh9JdBtKN.jpg'),
    Product(
        id: '1',
        title: 'Sample Product',
        description: 'This is a sample product description.',
        uploadDate: '2023-10-13',
        condition: ProductCondition.newWithTag,
        likesNumber: 100,
        urlImage:
        'https://as1.ftcdn.net/v2/jpg/02/65/23/70/1000_F_265237090_Muthvb72m2POYFjyx7F5UCQLh9JdBtKN.jpg'),
    Product(
        id: '1',
        title: 'Sample Product',
        description: 'This is a sample product description.',
        uploadDate: '2023-10-13',
        condition: ProductCondition.newWithTag,
        likesNumber: 100,
        urlImage:
        'https://as1.ftcdn.net/v2/jpg/02/65/23/70/1000_F_265237090_Muthvb72m2POYFjyx7F5UCQLh9JdBtKN.jpg'),
    Product(
        id: '1',
        title: 'Sample Product',
        description: 'This is a sample product description.',
        uploadDate: '2023-10-13',
        condition: ProductCondition.newWithTag,
        likesNumber: 100,
        urlImage:
        'https://as1.ftcdn.net/v2/jpg/02/65/23/70/1000_F_265237090_Muthvb72m2POYFjyx7F5UCQLh9JdBtKN.jpg'),
    Product(
        id: '1',
        title: 'Sample Product',
        description: 'This is a sample product description.',
        uploadDate: '2023-10-13',
        condition: ProductCondition.newWithTag,
        likesNumber: 100,
        urlImage:
        'https://as1.ftcdn.net/v2/jpg/02/65/23/70/1000_F_265237090_Muthvb72m2POYFjyx7F5UCQLh9JdBtKN.jpg'),
    Product(
        id: '1',
        title: 'Sample Product',
        description: 'This is a sample product description.',
        uploadDate: '2023-10-13',
        condition: ProductCondition.newWithTag,
        likesNumber: 100,
        urlImage:
        'https://as1.ftcdn.net/v2/jpg/02/65/23/70/1000_F_265237090_Muthvb72m2POYFjyx7F5UCQLh9JdBtKN.jpg'),
    Product(
        id: '1',
        title: 'Sample Product',
        description: 'This is a sample product description.',
        uploadDate: '2023-10-13',
        condition: ProductCondition.newWithTag,
        likesNumber: 100,
        urlImage:
        'https://as1.ftcdn.net/v2/jpg/02/65/23/70/1000_F_265237090_Muthvb72m2POYFjyx7F5UCQLh9JdBtKN.jpg'),
    Product(
        id: '1',
        title: 'Sample Product',
        description: 'This is a sample product description.',
        uploadDate: '2023-10-13',
        condition: ProductCondition.newWithTag,
        likesNumber: 100,
        urlImage:
        'https://as1.ftcdn.net/v2/jpg/02/65/23/70/1000_F_265237090_Muthvb72m2POYFjyx7F5UCQLh9JdBtKN.jpg'),
    Product(
        id: '1',
        title: 'Sample Product',
        description: 'This is a sample product description.',
        uploadDate: '2023-10-13',
        condition: ProductCondition.newWithTag,
        likesNumber: 100,
        urlImage:
        'https://as1.ftcdn.net/v2/jpg/02/65/23/70/1000_F_265237090_Muthvb72m2POYFjyx7F5UCQLh9JdBtKN.jpg'),
    Product(
        id: '1',
        title: 'Sample Product',
        description: 'This is a sample product description.',
        uploadDate: '2023-10-13',
        condition: ProductCondition.newWithTag,
        likesNumber: 100,
        urlImage:
        'https://as1.ftcdn.net/v2/jpg/02/65/23/70/1000_F_265237090_Muthvb72m2POYFjyx7F5UCQLh9JdBtKN.jpg'),
    Product(
        id: '1',
        title: 'Sample Product',
        description: 'This is a sample product description.',
        uploadDate: '2023-10-13',
        condition: ProductCondition.newWithTag,
        likesNumber: 100,
        urlImage:
        'https://as1.ftcdn.net/v2/jpg/02/65/23/70/1000_F_265237090_Muthvb72m2POYFjyx7F5UCQLh9JdBtKN.jpg'),
  ];

  @override
  Widget build(BuildContext context) {
    return ProductGrid(products);
  }
}
