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

import '../model/address.dart';
import '../model/basic/product_basic.dart';
import '../model/product_order.dart';

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

      /*for (QueryDocumentSnapshot<Map<String, dynamic>> document
          in snapshot.docs) {
        CommunityBasic communityBasic = CommunityBasic.fromJson(document.data()!);
        DocumentSnapshot<Map<String, dynamic>> communitySnapshot = await _db
            .collection('communities')
            .doc(communityBasic.docRef)
            .get();

        if (communitySnapshot.exists) {
          Community community = Community.fromJson(communitySnapshot.data()!);
          community.docRef = communityBasic.docRef;
          myCommunities.add(community);
        } else {
          print('Community not found: ${communityBasic.docRef}');
        }
      }*/
      snapshot.docs.forEach((DocumentSnapshot<Map<String, dynamic>> document) {
        Community community = Community.fromJson(document.data()!);
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
          .doc(context.read<CommunityProvider>().community.docRef)
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

  Future<void> updateCommunity(BuildContext context, Community community) async{
    try
    {
      await _db.collection('communities').doc(community.docRef).update(community.toJson());

      QuerySnapshot querySnapshot = await _db
          .collection('Users').doc(community.founder.id).collection('myCommunities')
          .where('id', isEqualTo: community.id)
          .limit(1)
          .get();

      if(querySnapshot.docs.isNotEmpty){
        DocumentReference documentReference = _db.collection('Users').doc(community.founder.id).collection('myCommunities').doc(querySnapshot.docs.first.id);
        await documentReference.update(community.toJson());
      }
      else{
        throw Exception('Community not found, can\'t update');
      }
      
      QuerySnapshot querySnapshotAllMembers = await _db.collection('communities').doc(community.docRef).collection('members').get();
      List<UserDetailsBasic> tmpMembers = [];

      querySnapshotAllMembers.docs.forEach((DocumentSnapshot document) {
        UserDetailsBasic userDetailsBasic =
        UserDetailsBasic.fromJson(document.data() as Map<String, dynamic>);
        tmpMembers.add(userDetailsBasic);
      });

      for (UserDetailsBasic userDetailsBasic in tmpMembers) {QuerySnapshot querySnapshot = await _db
          .collection('Users').doc(userDetailsBasic.id).collection('myCommunities')
          .where('id', isEqualTo: community.id)
          .limit(1)
          .get();

      if(querySnapshot.docs.isNotEmpty){
        DocumentReference documentReference = _db.collection('Users').doc(userDetailsBasic.id).collection('myCommunities').doc(querySnapshot.docs.first.id);
        await documentReference.update(community.toJson());
      }
      else{
        throw Exception('Community not found, can\'t update');
      }
      }

    }catch (error)
    {
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

  Future<Address?> retrieveCommunityAddress(BuildContext context, CommunityBasic communityBasic) async{
    try
    {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await _db
          .collection('communities')
          .doc(communityBasic.docRef)
          .get();

      if (snapshot.exists){
        Community community = Community.fromJson(snapshot.data()!);
        Address communityAddress = community.hotSpotAddress;
        return communityAddress;
      }
      return null;

    }
    catch (error)
    {
      print(error.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
          backgroundColor:
          Theme.of(context).colorScheme.errorContainer.withOpacity(0.1),
          duration: Duration(seconds: 2),
        ),
      );
      return null;
    }
  }

  Future<List<ProductOrder>> getCommunityOrders(BuildContext context, String docRef) async{
    List<ProductOrder> communityOrders = [];
    try
    {
      QuerySnapshot<Map<String, dynamic>> snapshot = await _db.collection('communities').doc(docRef).collection('order').orderBy('orderDate', descending: true).get();
      
      if(snapshot.size>0){
        snapshot.docs.forEach((DocumentSnapshot<Map<String, dynamic>> document) {
          ProductOrder productOrder = ProductOrder.fromJson(document.data()!);
          communityOrders.add(productOrder);
        });
      }
      
      return communityOrders;
      
    }catch (error){
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

  Future<String> addOrEditEvent(BuildContext context, Event newEvent, String? docRef) async{
    try
    {
      if(newEvent.id!= null && newEvent.id != ''){
        await _db.collection('communities').doc(docRef!).collection('events').doc(newEvent.id).update(newEvent.toJson());
        return newEvent.id!;
      }
      else{
        DocumentReference documentReference = await _db.collection('communities').doc(docRef!).collection('events').add(newEvent.toJson());
        return documentReference.id??'';
      }
    }
    catch(error){
      print(error.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
          backgroundColor:
          Theme.of(context).colorScheme.errorContainer.withOpacity(0.1),
          duration: Duration(seconds: 2),
        ),
      );
      return '';
    }
  }

  Future<bool> deleteEvent(BuildContext context, Event event) async{
    try
    {
      await _db.collection('communities').doc(context.read<CommunityProvider>().community.docRef).collection('events').doc(event.id).delete();

      return true;
    }
    catch(error)
    {
      print(error.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
          backgroundColor:
          Theme.of(context).colorScheme.errorContainer.withOpacity(0.1),
          duration: Duration(seconds: 2),
        ),
      );
      return false;
    }
  }

  Future<List<Event>> getIncomingEventsFromMyCommunities(BuildContext context) async{
    List<Event> incomingEvents = [];
    try
    {
      for(Community community in context.read<UserProvider>().myCommunities){
        QuerySnapshot<Map<String, dynamic>> snapshot = await _db.collection('communities').doc(community.docRef).collection('events').orderBy('eventDate',descending: false).limit(5).get();
        snapshot.docs.forEach((DocumentSnapshot<Map<String, dynamic>> document)async {
          Event event = Event.fromJson(document.data()!);
          event.docRefCommunity = community.docRef;
          event.docRefCommunityName = community.name;
          incomingEvents.add(event);
        });
/*        List<Event> tmp = snapshot.docs
            .map((doc) => Event.fromJson(doc.data()!))
            .toList();
        incomingEvents.addAll(tmp);*/
      }

      incomingEvents.sort((a, b) => a.eventDate.compareTo(b.eventDate));

      if(incomingEvents.length>5){
        incomingEvents = incomingEvents.sublist(0,5);
      }

      return incomingEvents;
    }
    catch (error)
    {
      print(error.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
          backgroundColor:
          Theme.of(context).colorScheme.errorContainer.withOpacity(0.1),
          duration: Duration(seconds: 2),
        ),
      );
      return incomingEvents;
    }
  }
}
