import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community_share/model/basic/product_basic.dart';
import 'package:community_share/model/product_order.dart';
import 'package:community_share/model/user_details.dart';
import 'package:community_share/providers/UserProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/community.dart';
import '../model/product.dart';
import '../service/auth.dart';

class UserRepository {
  final _db = FirebaseFirestore.instance;

  Future<void> createUserDetails(String uid, UserDetails userDetails) async {
    try {
      await _db.collection("Users").doc(uid).set(userDetails.toJson());
      /*
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Your account has been created"),
          backgroundColor:
              Theme.of(context).colorScheme.tertiaryContainer.withOpacity(0.1),
          duration: Duration(seconds: 2),
        ),
      );*/
    } catch (error) {
      rethrow; /*
       ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Something went wrong. Try again"),
          backgroundColor:
              Theme.of(context).colorScheme.errorContainer.withOpacity(0.1),
          duration: Duration(seconds: 2),
        ),
      );
      print(error.toString());*/
    }
  }

  Future<void> updateUserDetails(BuildContext context) async {
    try {
      await _db
          .collection("Users")
          .doc(Auth().currentUser?.uid)
          .update(context.read<UserProvider>().userDetails.toJson());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Your account has been updated"),
          backgroundColor:
              Theme.of(context).colorScheme.tertiaryContainer.withOpacity(0.1),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Something went wrong. Try again"),
          backgroundColor:
              Theme.of(context).colorScheme.errorContainer.withOpacity(0.1),
          duration: Duration(seconds: 2),
        ),
      );
      print(error.toString());
    }
  }

  Future<UserDetails> getUserDetails(BuildContext context) async {
    try {
      DocumentSnapshot userDocument =
          await _db.collection("Users").doc(Auth().currentUser?.uid).get();

      if (userDocument.exists) {
        UserDetails userDetails =
            UserDetails.fromJson(userDocument.data() as Map<String, dynamic>);
        userDetails.id = userDocument.id;
        //context.read<UserProvider>().setData(userDetails,[]);
        return userDetails;
      } else {
        throw Exception("User not found in database");
      }
    } catch (error) {
      print(error.toString());
      throw Exception("Failed to fetch user details");
    }
  }

  Future<List<Community>> getMyCommunities(BuildContext context) async {
    List<Community> myCommunities = [];
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await _db
          .collection("Users")
          .doc(Auth().currentUser?.uid)
          .collection('myCommunities')
          .get();

      snapshot.docs.forEach((DocumentSnapshot<Map<String, dynamic>> document) {
        Community community = Community.fromJson(document.data()!);
        //todo check perchè questa assegnazione potrebbe essere sbagliata
        //community.id = document.id;
        myCommunities.add(community);
      });

      return myCommunities;
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
      //throw Exception(error.toString());

      return [];
    }
  }

  Future<List<Product>> getProductsLiked(BuildContext context) async {
    List<Product> productsLiked = [];
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await _db
          .collection('Users')
          .doc(Auth().currentUser?.uid)
          .collection('products_liked')
          .get();

      snapshot.docs.forEach((DocumentSnapshot<Map<String, dynamic>> document) {
        Product product = Product.fromJson(document.data()!);
        productsLiked.add(product);
      });

      return productsLiked;
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
      return productsLiked;
    }
  }

  Future<List<ProductOrder>> getMyOrders(
      BuildContext context, bool outcoming) async {
    List<ProductOrder> myOrders = [];

    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot;
      if (outcoming) {
        querySnapshot = await _db
            .collection('Users')
            .doc(Auth().currentUser?.uid)
            .collection('outcoming_orders')
            .get();
      } else {
        querySnapshot = await _db
            .collection('Users')
            .doc(Auth().currentUser?.uid)
            .collection('incoming_orders')
            .get();
      }

      querySnapshot.docs
          .forEach((DocumentSnapshot<Map<String, dynamic>> document) {
        ProductOrder productOrder = ProductOrder.fromJson(document.data()!);
        myOrders.add(productOrder);
      });

      return myOrders;
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
      return myOrders;
    }
  }

  Future<List<Product>> getUserProducts(String id) async {
    List<Product> products = [];
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await _db
          .collection('Users')
          .doc(id)
          .collection('given_products')
          .get();

      print(snapshot.size);

      for (QueryDocumentSnapshot<Map<String, dynamic>> document
          in snapshot.docs) {
        ProductBasic productBasic= ProductBasic.fromJson(document.data());
        /*String productId = document.['docRefCompleteProduct'];
        print(productId);*/

        DocumentSnapshot<Map<String, dynamic>> productDoc =
            await _db.collection('products').doc(productBasic.docRefCompleteProduct).get();

        if (productDoc.exists) {
          Product product = Product.fromJson(productDoc.data()!);
          products.add(product);
        }
      }
      return products;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Community>> getUserCommunities(String id) async {
    List<Community> communities = [];
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await _db
          .collection('Users')
          .doc(id)
          .collection('myCommunities')
          .get();

      snapshot.docs.forEach((DocumentSnapshot<Map<String, dynamic>> document) {
        Community community = Community.fromJson(document.data()!);
        communities.add(community);
      });
      return [];
    } catch (e) {
      rethrow;
    }
  }
}
