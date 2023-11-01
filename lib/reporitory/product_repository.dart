import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community_share/providers/UserProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/basic/user_details_basic.dart';
import '../model/enum/product_availability.dart';
import '../model/enum/product_condition.dart';
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

  Future<List<Product>> getProducts(BuildContext context) async {
    List<Product> products = [];

    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await _db.collection('products').get();


      snapshot.docs.forEach((DocumentSnapshot<Map<String, dynamic>> document) {
        Product product = Product.fromJson(document.data()!);
        product.id = document.id;
        products.add(product);
      });

      return products;
    } catch (error) {
      print(error.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
          backgroundColor: Theme.of(context).colorScheme.errorContainer.withOpacity(0.1),
          duration: Duration(seconds: 2),
        ),
      );

      return [];
    }


  }

  Future<List<UserDetailsBasic>> getProductLikes(BuildContext context, String? id) async{
    List<UserDetailsBasic> users = [];
    try{
      QuerySnapshot<Map<String, dynamic>> snapshot = await _db.collection('products').doc(id).collection('likes').get();
      snapshot.docs.forEach((DocumentSnapshot<Map<String, dynamic>> document) {
          UserDetailsBasic userDetailsBasic = UserDetailsBasic.fromJson(document.data()!);
          users.add(userDetailsBasic);

        });

      return users;


    }catch(error){
      print(error.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
          backgroundColor: Theme.of(context).colorScheme.errorContainer.withOpacity(0.1),
          duration: Duration(seconds: 2),
        ),
      );

      return [];
    }
  }

  Future<void> setLikes(BuildContext context, Product tmpProduct, UserDetailsBasic tmp, bool adding)async {
    try{
      await _db
          .collection('products')
          .doc(tmpProduct.id)
          .update(tmpProduct.toJson());

      if(adding){
        await _db
            .collection('products')
            .doc(tmpProduct.id)
            .collection('likes')
            .add(tmp.toJson());
      }
      else{
        QuerySnapshot<Map<String, dynamic>> querySnapshot = await _db
            .collection('products')
            .doc(tmpProduct.id)
            .collection('likes')
            .where('Id', isEqualTo: tmp.id)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          await _db
              .collection('products')
              .doc(tmpProduct.id)
              .collection('likes')
              .doc(querySnapshot.docs.first.id)
              .delete();
        }
      }




    }catch (error){
      print(error.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
          backgroundColor: Theme.of(context).colorScheme.errorContainer.withOpacity(0.1),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

/*  Future<List<Product>> getProducts(BuildContext context) async {
    List<Product> products = [];

    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await _db.collection(
          'products').get();

      snapshot.docs.forEach((DocumentSnapshot<Map<String, dynamic>> document) {
        print('Raw Data: ${document.data()}');

        String? id = document.id;
        print('ID: $id');

        String title = document.data()!['title'];
        print('Title: $title');

        String description = document.data()!['description'];
        print('Description: $description');

        String urlImages = document.data()!['urlImages'];
        print('URL Images: $urlImages');

        String locationProduct = document.data()!['locationProduct'];
        print('Location Product: $locationProduct');

// Parsing dates from Timestamps
        DateTime uploadDate = (document.data()!['uploadDate'] as Timestamp).toDate();
        print('Upload Date: $uploadDate');

        DateTime lastUpdateDate = (document.data()!['lastUpdateDate'] as Timestamp).toDate();
        print('Last Update Date: $lastUpdateDate');

        int likesNumber = document.data()!['likesNumber'];
        print('Likes Number: $likesNumber');


// Parsing enums (assuming they are stored as strings)
        ProductCondition condition = productConditionFromString(document.data()!['condition']) ;
        print('Condition: $condition');

        ProductAvailability availability = productAvailabilityFromString(document.data()!['availability']);
        print('Availability: $availability');

        print('prima di user');

// Parsing UserDetailsBasic
        UserDetailsBasic giver = UserDetailsBasic.fromJson(document.data()!['giver']);

// Print debug information for each field
        print('Giver: $giver');

// Create Product object and add it to the list
        Product product = Product(
          id: id,
          title: title,
          description: description,
          urlImages: urlImages,
          locationProduct: locationProduct,
          uploadDate: uploadDate,
          lastUpdateDate: lastUpdateDate,
          condition: condition,
          availability: availability,
          likesNumber: likesNumber,
          giver: giver,
        );

        products.add(product);
      });

      return products;
    } catch (error) {
      print(error.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
          backgroundColor: Theme
              .of(context)
              .colorScheme
              .errorContainer
              .withOpacity(0.1),
          duration: Duration(seconds: 2),
        ),
      );

      return [];
    }
  }*/


}


