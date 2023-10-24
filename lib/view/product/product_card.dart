import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../model/enum/product_condition.dart';
import '../../model/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  ProductCard(this.product, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.go('/product/details/${product.id}', extra: product);
      },
      child: Card(
        color: Theme.of(context).cardTheme.color,
        elevation: 3,
        margin: EdgeInsets.all(10),
        child: IntrinsicHeight(
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  'https://img.freepik.com/free-photo/cosmetics-product-advertising-stand-exhibition-wooden-podium-green-background-with-leaves-sha_1258-170111.jpg?t=st=1698164268~exp=1698167868~hmac=2f63555e1a9cabee2727d5bb9cada9873e45d20a551075db913a3e09c8f132ba&w=740',
                  //product.urlImages,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 8),
                Text(
                  product.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8, top: 5, bottom: 5, right: 8),
                  child: Text(
                    'Lorem Ipsum è un testo segnaposto utilizzato nel settore della tipografia e della stampa. Lorem Ipsum è considerato il testo segnaposto standard sin dal sedicesimo secolo, quando un anonimo tipografo prese una cassetta di caratteri e li assemblò per preparare un testo campione.',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 16, left: 8, bottom: 5),
                      child: FaIcon(FontAwesomeIcons.locationPin, size: 16),
                    ),
                    Text('Milano', style: TextStyle(fontSize: 12)),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8, left: 8),
                      child: FaIcon(FontAwesomeIcons.users, size: 16),
                    ),
                    Text('3', style: TextStyle(fontSize: 12)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FaIcon(FontAwesomeIcons.heart, size: 18, color: Theme.of(context).colorScheme.primary),
                    Text(
                      '${product.likesNumber}',
                      style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.primary),
                    ),
                  ],
                ),
                Divider(height: 8, color: Theme.of(context).colorScheme.primary, thickness: 2),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'VIEW',
                      style: TextStyle(color: Theme.of(context).colorScheme.primary),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}