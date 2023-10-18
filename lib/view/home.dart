import 'package:community_share/view/generic_components/product_grid.dart';
import 'package:flutter/material.dart';

import '../model/enum/product_condition.dart';
import '../model/product.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final List<Product> products = [
    Product(
        id: '1',
        title: 'Sample Product 1',
        description: 'This is a sample product description.',
        uploadDate: '2023-10-13',
        condition: ProductCondition.newWithTag,
        likesNumber: 100,
        urlImage:
            'https://as1.ftcdn.net/v2/jpg/02/65/23/70/1000_F_265237090_Muthvb72m2POYFjyx7F5UCQLh9JdBtKN.jpg'),
    Product(
        id: '2',
        title: 'Sample Product 2',
        description: 'This is a sample product description.',
        uploadDate: '2023-10-13',
        condition: ProductCondition.newWithTag,
        likesNumber: 100,
        urlImage:
        'https://as1.ftcdn.net/v2/jpg/02/65/23/70/1000_F_265237090_Muthvb72m2POYFjyx7F5UCQLh9JdBtKN.jpg'),
    Product(
        id: '3',
        title: 'Sample Product 3',
        description: 'This is a sample product description.',
        uploadDate: '2023-10-13',
        condition: ProductCondition.newWithTag,
        likesNumber: 100,
        urlImage:
        'https://as1.ftcdn.net/v2/jpg/02/65/23/70/1000_F_265237090_Muthvb72m2POYFjyx7F5UCQLh9JdBtKN.jpg'),
    Product(
        id: '4',
        title: 'Sample Product 4',
        description: 'This is a sample product description.',
        uploadDate: '2023-10-13',
        condition: ProductCondition.newWithTag,
        likesNumber: 100,
        urlImage:
        'https://as1.ftcdn.net/v2/jpg/02/65/23/70/1000_F_265237090_Muthvb72m2POYFjyx7F5UCQLh9JdBtKN.jpg'),
    Product(
        id: '5',
        title: 'Sample Product 5',
        description: 'This is a sample product description.',
        uploadDate: '2023-10-13',
        condition: ProductCondition.newWithTag,
        likesNumber: 100,
        urlImage:
        'https://as1.ftcdn.net/v2/jpg/02/65/23/70/1000_F_265237090_Muthvb72m2POYFjyx7F5UCQLh9JdBtKN.jpg'),
    Product(
        id: '6',
        title: 'Sample Product 6',
        description: 'This is a sample product description.',
        uploadDate: '2023-10-13',
        condition: ProductCondition.newWithTag,
        likesNumber: 100,
        urlImage:
        'https://as1.ftcdn.net/v2/jpg/02/65/23/70/1000_F_265237090_Muthvb72m2POYFjyx7F5UCQLh9JdBtKN.jpg'),
    Product(
        id: '7',
        title: 'Sample Product 7',
        description: 'This is a sample product description.',
        uploadDate: '2023-10-13',
        condition: ProductCondition.newWithTag,
        likesNumber: 100,
        urlImage:
        'https://as1.ftcdn.net/v2/jpg/02/65/23/70/1000_F_265237090_Muthvb72m2POYFjyx7F5UCQLh9JdBtKN.jpg'),
    Product(
        id: '8',
        title: 'Sample Product 8',
        description: 'This is a sample product description.',
        uploadDate: '2023-10-13',
        condition: ProductCondition.newWithTag,
        likesNumber: 100,
        urlImage:
        'https://as1.ftcdn.net/v2/jpg/02/65/23/70/1000_F_265237090_Muthvb72m2POYFjyx7F5UCQLh9JdBtKN.jpg'),
    Product(
        id: '9',
        title: 'Sample Product 9',
        description: 'This is a sample product description.',
        uploadDate: '2023-10-13',
        condition: ProductCondition.newWithTag,
        likesNumber: 100,
        urlImage:
        'https://as1.ftcdn.net/v2/jpg/02/65/23/70/1000_F_265237090_Muthvb72m2POYFjyx7F5UCQLh9JdBtKN.jpg'),
    Product(
        id: '10',
        title: 'Sample Product 10',
        description: 'This is a sample product description.',
        uploadDate: '2023-10-13',
        condition: ProductCondition.newWithTag,
        likesNumber: 100,
        urlImage:
        'https://as1.ftcdn.net/v2/jpg/02/65/23/70/1000_F_265237090_Muthvb72m2POYFjyx7F5UCQLh9JdBtKN.jpg'),
    Product(
        id: '11',
        title: 'Sample Product 11',
        description: 'This is a sample product description.',
        uploadDate: '2023-10-13',
        condition: ProductCondition.newWithTag,
        likesNumber: 100,
        urlImage:
        'https://as1.ftcdn.net/v2/jpg/02/65/23/70/1000_F_265237090_Muthvb72m2POYFjyx7F5UCQLh9JdBtKN.jpg'),
    Product(
        id: '12',
        title: 'Sample Product 12',
        description: 'This is a sample product description.',
        uploadDate: '2023-10-13',
        condition: ProductCondition.newWithTag,
        likesNumber: 100,
        urlImage:
        'https://as1.ftcdn.net/v2/jpg/02/65/23/70/1000_F_265237090_Muthvb72m2POYFjyx7F5UCQLh9JdBtKN.jpg'),
    Product(
        id: '13',
        title: 'Sample Product 13',
        description: 'This is a sample product description.',
        uploadDate: '2023-10-13',
        condition: ProductCondition.newWithTag,
        likesNumber: 100,
        urlImage:
        'https://as1.ftcdn.net/v2/jpg/02/65/23/70/1000_F_265237090_Muthvb72m2POYFjyx7F5UCQLh9JdBtKN.jpg'),
    Product(
        id: '14',
        title: 'Sample Product 14',
        description: 'This is a sample product description.',
        uploadDate: '2023-10-13',
        condition: ProductCondition.newWithTag,
        likesNumber: 100,
        urlImage:
        'https://as1.ftcdn.net/v2/jpg/02/65/23/70/1000_F_265237090_Muthvb72m2POYFjyx7F5UCQLh9JdBtKN.jpg'),
    Product(
        id: '15',
        title: 'Sample Product 15',
        description: 'This is a sample product description.',
        uploadDate: '2023-10-13',
        condition: ProductCondition.newWithTag,
        likesNumber: 100,
        urlImage:
        'https://as1.ftcdn.net/v2/jpg/02/65/23/70/1000_F_265237090_Muthvb72m2POYFjyx7F5UCQLh9JdBtKN.jpg'),
    Product(
        id: '16',
        title: 'Sample Product 16',
        description: 'This is a sample product description.',
        uploadDate: '2023-10-13',
        condition: ProductCondition.newWithTag,
        likesNumber: 100,
        urlImage:
        'https://as1.ftcdn.net/v2/jpg/02/65/23/70/1000_F_265237090_Muthvb72m2POYFjyx7F5UCQLh9JdBtKN.jpg'),
    Product(
        id: '17',
        title: 'Sample Product 17',
        description: 'This is a sample product description.',
        uploadDate: '2023-10-13',
        condition: ProductCondition.newWithTag,
        likesNumber: 100,
        urlImage:
        'https://as1.ftcdn.net/v2/jpg/02/65/23/70/1000_F_265237090_Muthvb72m2POYFjyx7F5UCQLh9JdBtKN.jpg'),
    Product(
        id: '18',
        title: 'Sample Product 18',
        description: 'This is a sample product description.',
        uploadDate: '2023-10-13',
        condition: ProductCondition.newWithTag,
        likesNumber: 100,
        urlImage:
        'https://as1.ftcdn.net/v2/jpg/02/65/23/70/1000_F_265237090_Muthvb72m2POYFjyx7F5UCQLh9JdBtKN.jpg'),
    Product(
        id: '19',
        title: 'Sample Product 19',
        description: 'This is a sample product description.',
        uploadDate: '2023-10-13',
        condition: ProductCondition.newWithTag,
        likesNumber: 100,
        urlImage:
        'https://as1.ftcdn.net/v2/jpg/02/65/23/70/1000_F_265237090_Muthvb72m2POYFjyx7F5UCQLh9JdBtKN.jpg'),
    Product(
        id: '20',
        title: 'Sample Product 20',
        description: 'This is a sample product description.',
        uploadDate: '2023-10-13',
        condition: ProductCondition.newWithTag,
        likesNumber: 100,
        urlImage:
        'https://as1.ftcdn.net/v2/jpg/02/65/23/70/1000_F_265237090_Muthvb72m2POYFjyx7F5UCQLh9JdBtKN.jpg'),
    Product(
        id: '21',
        title: 'Sample Product 21',
        description: 'This is a sample product description.',
        uploadDate: '2023-10-13',
        condition: ProductCondition.newWithTag,
        likesNumber: 100,
        urlImage:
        'https://as1.ftcdn.net/v2/jpg/02/65/23/70/1000_F_265237090_Muthvb72m2POYFjyx7F5UCQLh9JdBtKN.jpg'),
    Product(
        id: '22',
        title: 'Sample Product 22',
        description: 'This is a sample product description.',
        uploadDate: '2023-10-13',
        condition: ProductCondition.newWithTag,
        likesNumber: 100,
        urlImage:
        'https://as1.ftcdn.net/v2/jpg/02/65/23/70/1000_F_265237090_Muthvb72m2POYFjyx7F5UCQLh9JdBtKN.jpg'),
    Product(
        id: '23',
        title: 'Sample Product 23',
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
