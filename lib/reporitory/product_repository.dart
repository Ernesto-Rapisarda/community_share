import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community_share/providers/UserProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/product.dart';
import '../service/auth.dart';

class ProductRepository{
  final _db = FirebaseFirestore.instance;

  Future<void> createProduct(BuildContext context, Product product) async{
    try{
      await _db.collection('products').add(product.toJson());
    }
    catch (error){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Something went wrong. Try again"),
          backgroundColor: Theme.of(context).colorScheme.errorContainer.withOpacity(0.1),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }


}
