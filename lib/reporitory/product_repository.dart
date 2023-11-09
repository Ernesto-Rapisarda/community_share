import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community_share/model/basic/community_basic.dart';
import 'package:community_share/model/basic/product_basic.dart';
import 'package:community_share/model/community.dart';
import 'package:community_share/providers/UserProvider.dart';
import 'package:community_share/providers/product_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/basic/user_details_basic.dart';
import '../model/enum/product_availability.dart';
import '../model/enum/product_condition.dart';
import '../model/product.dart';
import '../service/auth.dart';

class ProductRepository {
  final _db = FirebaseFirestore.instance;

  Future<void> createProduct(BuildContext context, Product product) async {
    try {
      DocumentReference documentReference =
          await _db.collection('products').add(product.toJson());
      String docRef = documentReference.id;
      product.docRef = docRef;
      context.read<ProductProvider>().setProductVisualized(context, product);
      ProductBasic productBasic = ProductBasic(
          id: product.id,
          title: product.title,
          urlImages: product.urlImages,
          uploadDate: product.uploadDate,
          availability: product.availability,
          docRefCompleteProduct: docRef);
      await _db
          .collection('Users')
          .doc(Auth().currentUser?.uid)
          .collection('given_products')
          .add(productBasic.toJson());
      for (var community in product.publishedOn) {
        await _db
            .collection('communities')
            .doc(community.docRef)
            .collection('product_published')
            .add(productBasic.toJson());
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Something went wrong. Try again"),
          backgroundColor:
              Theme.of(context).colorScheme.errorContainer.withOpacity(0.1),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<List<Product>> getProducts(BuildContext context) async {
    List<Product> products = [];

    try {
      for(Community community in context.read<UserProvider>().myCommunities){
        QuerySnapshot<Map<String, dynamic>> snapshot = await _db.collection('communities').doc(community.docRef).collection('product_published').get();
        await Future.forEach(snapshot.docs, (DocumentSnapshot<Map<String, dynamic>> document) async {
          ProductBasic productBasic = ProductBasic.fromJson(document.data()!);
          DocumentSnapshot productSnapshot = await _db.collection('products').doc(productBasic.docRefCompleteProduct).get();
          Product product = Product.fromJson(productSnapshot.data() as Map<String, dynamic>);
          product.docRef = productSnapshot.id;
          products.add(product);
        });
      }
      products.sort((a, b) => b.uploadDate.compareTo(a.uploadDate));
      return products;
    } catch (error) {
      print(error.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
          backgroundColor:
              Theme.of(context).colorScheme.errorContainer.withOpacity(0.1),
          duration: Duration(seconds: 2),
        ),
      );

      return [];
    }
  }

  Future<List<UserDetailsBasic>> getProductLikes(
      BuildContext context, String? id) async {
    List<UserDetailsBasic> users = [];
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await _db.collection('products').doc(id).collection('likes').get();
      snapshot.docs.forEach((DocumentSnapshot<Map<String, dynamic>> document) {
        UserDetailsBasic userDetailsBasic =
            UserDetailsBasic.fromJson(document.data()!);
        users.add(userDetailsBasic);
      });

      return users;
    } catch (error) {
      print(error.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
          backgroundColor:
              Theme.of(context).colorScheme.errorContainer.withOpacity(0.1),
          duration: Duration(seconds: 2),
        ),
      );

      return [];
    }
  }

  Future<void> setLikes(BuildContext context, Product tmpProduct,
      UserDetailsBasic user, bool adding) async {
    try {
      await _db
          .collection('products')
          .doc(tmpProduct.docRef)
          .update(tmpProduct.toJson());

      if (adding) {
        await _db
            .collection('products')
            .doc(tmpProduct.docRef)
            .collection('likes')
            .add(user.toJson());

        await _db
            .collection('Users')
            .doc(Auth().currentUser?.uid)
            .collection('products_liked')
            .add(tmpProduct.toJson());
      } else {
        QuerySnapshot<Map<String, dynamic>> querySnapshot = await _db
            .collection('products')
            .doc(tmpProduct.docRef)
            .collection('likes')
            .where('Id', isEqualTo: user.id)
            .get();

        print(querySnapshot.size);

        if (querySnapshot.docs.isNotEmpty) {
          await _db
              .collection('products')
              .doc(tmpProduct.docRef)
              .collection('likes')
              .doc(querySnapshot.docs.first.id)
              .delete();
        }

        print('id prod: ${tmpProduct.id}');
        QuerySnapshot<Map<String, dynamic>> querySnapshotUser = await _db
            .collection('Users')
            .doc(Auth().currentUser?.uid)
            .collection('products_liked')
            .where('id', isEqualTo: tmpProduct.id)
            .get();

        print(querySnapshotUser.size);
        if (querySnapshotUser.docs.isNotEmpty) {
          await _db
              .collection('Users')
              .doc(Auth().currentUser?.uid)
              .collection('products_liked')
              .doc(querySnapshotUser.docs.first.id)
              .delete();
        }


      }
    } catch (error) {
      print(error.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
          backgroundColor:
              Theme.of(context).colorScheme.errorContainer.withOpacity(0.1),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> updateProduct(BuildContext context, Product product) async {
    try {
      await _db
          .collection('products')
          .doc(product.docRef)
          .update(product.toJson());
      context.read<ProductProvider>().setProductVisualized(context, product);

      ProductBasic productBasic = ProductBasic(
          id: product.id,
          title: product.title,
          urlImages: product.urlImages,
          uploadDate: product.uploadDate,
          availability: product.availability,
          docRefCompleteProduct: product.docRef!);

      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _db
          .collection('Users')
          .doc(Auth().currentUser!.uid)
          .collection('given_products')
          .where('id', isEqualTo: product.id)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentReference documentReference =
            querySnapshot.docs.first.reference;

        await _db
            .collection('Users')
            .doc(Auth().currentUser?.uid)
            .collection('given_products')
            .doc(documentReference.id)
            .update(productBasic.toJson());
      }

      for (CommunityBasic community in product.publishedOn) {
        QuerySnapshot<Map<String, dynamic>> querySnapshot = await _db
            .collection('communities')
            .doc(community.docRef)
            .collection('product_published')
            .where('id', isEqualTo: product.id)
            .limit(1)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          DocumentReference documentReference =
              querySnapshot.docs.first.reference;
          await documentReference.update(productBasic.toJson());
        }
      }
    } catch (error) {
      print(error.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
          backgroundColor:
              Theme.of(context).colorScheme.errorContainer.withOpacity(0.1),
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
