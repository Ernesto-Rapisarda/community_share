import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community_share/model/basic/community_basic.dart';
import 'package:community_share/model/basic/user_details_basic.dart';
import 'package:community_share/model/community.dart';
import 'package:community_share/model/event.dart';
import 'package:community_share/model/product.dart';
import 'package:community_share/providers/UserProvider.dart';
import 'package:community_share/providers/community_provider.dart';
import 'package:community_share/service/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/basic/product_basic.dart';

class CommunityRepository {
  final _db = FirebaseFirestore.instance;

  Future<void> createCommunity(
      BuildContext context, Community community) async {
    try {
      DocumentReference documentReference =
          await _db.collection('communities').add(community.toJson());
      community.docRef = documentReference.id;
      await _db
          .collection('Users')
          .doc(Auth().currentUser?.uid)
          .collection('myCommunities')
          .add(community.toJson());
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

  Future<List<Community>> getMyCommunities(BuildContext context) async {
    List<Community> myCommunities = [];
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await _db
          .collection('Users')
          .doc(Auth().currentUser?.uid)
          .collection('myCommunities')
          .get();

      for (QueryDocumentSnapshot<Map<String, dynamic>> document
          in snapshot.docs) {
        CommunityBasic communityBasic =
            CommunityBasic.fromJson(document.data()!);
        DocumentSnapshot<Map<String, dynamic>> communitySnapshot = await _db
            .collection('communities')
            .doc(communityBasic.docRef)
            .get();
        if (communitySnapshot.exists) {
          Community community = Community.fromJson(communitySnapshot.data()!);
          myCommunities.add(community);
        } else {
          print('Community not found: ${communityBasic.docRef}');
        }
      }

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

      return [];
    }
  }

  Future<void> joinCommunity(BuildContext context, Community community) async {
    try {
      await _db
          .collection('communities')
          .doc(community.docRef)
          .update(community.toJson());

      await _db
          .collection('communities')
          .doc(community.docRef)
          .collection('members')
          .add(context.read<UserProvider>().getUserBasic().toJson());
      await _db
          .collection('Users')
          .doc(context.read<UserProvider>().userDetails.id)
          .collection('myCommunities')
          .add(community.toJson());
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

  Future<List<Event>> getEventsForCommunity(BuildContext context) async {
    List<Event> events = [];
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await _db
          .collection('communities')
          .doc(context.read<CommunityProvider>().community.id)
          .collection('events')
          .get();

      snapshot.docs.forEach((DocumentSnapshot<Map<String, dynamic>> document) {
        Event event = Event.fromJson(document.data()!);
        event.id = document.id;
        events.add(event);
      });

      return events;
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

  Future<List<UserDetailsBasic>> getMembers(BuildContext context) async {
    List<UserDetailsBasic> members = [];
    try {
      print(context.read<CommunityProvider>().community.docRef);
      QuerySnapshot<Map<String, dynamic>> snapshot = await _db
          .collection('communities')
          .doc(context.read<CommunityProvider>().community.docRef)
          .collection('members')
          .get();

      snapshot.docs.forEach((DocumentSnapshot<Map<String, dynamic>> document) {
        UserDetailsBasic member = UserDetailsBasic.fromJson(document.data()!);
        //member = document.id;
        members.add(member);
      });

      return members;
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

  Future<List<Community>> getAllCommunities(BuildContext context) async {
    List<Community> communities = [];

    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await _db
          .collection('communities')
          .where('founder.Id',
              isNotEqualTo: context.read<UserProvider>().userDetails.id)
          .get();

      snapshot.docs.forEach((DocumentSnapshot<Map<String, dynamic>> document) {
        Community community = Community.fromJson(document.data()!);
        community.docRef = document.id;
        communities.add(community);

/*        if (!context.read<UserProvider>().myCommunities.contains(community)) {
        }*/
      });

      return communities;
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

  Future<List<Product>> getCommunitysProducts(BuildContext context) async {
    List<Product> products = [];
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await _db
          .collection('communities')
          .doc(context.read<CommunityProvider>().community.docRef)
          .collection('product_published')
          .get();

      List<ProductBasic> productBasics = snapshot.docs
          .map((doc) => ProductBasic.fromJson(doc.data()))
          .toList();

      for (ProductBasic productBasic in productBasics) {
        DocumentSnapshot<Map<String, dynamic>> productDoc = await _db
            .collection('products')
            .doc(productBasic.docRefCompleteProduct)
            .get();

        if (productDoc.exists) {
          Product product = Product.fromJson(productDoc.data()!);
          products.add(product);
        }
      }

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
}
