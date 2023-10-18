import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../model/product.dart';

class FullProduct extends StatefulWidget{
  late Product product;

  FullProduct({super.key,required this.product});

  @override
  State<StatefulWidget> createState() => _FullProductState();

}

class _FullProductState extends State<FullProduct> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,

      ),
      body: Center(
        child: Text(widget.product.title),
      ),
    );
  }

}