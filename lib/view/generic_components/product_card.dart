import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../model/enum/product_condition.dart';
import '../../model/product.dart';

class ProductCard extends StatelessWidget {
  late final Product product;

  ProductCard(this.product, {super.key});

  @override
  Widget build(BuildContext context) {
/*
    print('Dati del prodotto: ${product.toJson()}'); // Stampa tutti i dati del prodotto
*/

    return Card(
      elevation: 3,
      margin: EdgeInsets.all(10),
      child: IntrinsicHeight(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                product.urlImage,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 8),
              Text(
                product.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8,top: 5,bottom: 5,right: 8),

                child: Text('Lorem Ipsum è un testo segnaposto utilizzato nel settore della tipografia e della stampa. Lorem Ipsum è considerato il testo segnaposto standard sin dal sedicesimo secolo, quando un anonimo tipografo prese una cassetta di caratteri e li assemblò per preparare un testo campione.',maxLines: 3,overflow: TextOverflow.ellipsis,),
              ),

              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 16,left: 8, bottom: 5),
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
                  FaIcon(FontAwesomeIcons.heart, size: 18),
                  Text(
                    '${product.likesNumber}',
                    style: TextStyle(fontSize: 14, color: Colors.blue),
                  ),
                ],
              ),
              Divider(height: 8,color: Colors.blue.shade900,thickness: 2,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('VIEW'),
                  /*FaIcon(FontAwesomeIcons.heart, size: 18),
                  Text(
                    '${product.likesNumber}',
                    style: TextStyle(fontSize: 14, color: Colors.blue),
                  ),*/
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
