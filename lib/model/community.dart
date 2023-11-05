import 'package:community_share/model/enum/community_type.dart';
import 'package:community_share/model/product.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'basic/user_details_basic.dart';
import 'event.dart';

class Community {
/*  late List<Product> productsOffered;
  late List<Product> productsSearched;
  late List<String> members;

  late List<Event> events;*/

  String id;
  String locationSite;
  CommunityType type;
  String urlLogo;
  String name;
  String description;
  int members;
  String? docRef;

  UserDetailsBasic founder;

  //todo aggiungere la chat

  Community(
      {required this.id,
      required this.locationSite,
      required this.type,
      required this.urlLogo,
      required this.description,
      required this.name,
        required this.members,
      required this.founder, this.docRef,
      });

  toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'urlLogo': urlLogo,
      'type': type.name,
      'locationSite': locationSite,
      'founder': founder.toJson(),
      'members_number': members,
      if(docRef != null) 'docRef': docRef


    };
  }

  factory Community.fromJson(Map<String, dynamic> json) {
    return Community(
      id: json['id'],
        name: json['name'],
        description: json['description'],
        urlLogo: json['urlLogo'],
        type: json['type'] != null
            ? communityTypeFromString(json['type'])
            : CommunityType.undefined,
        locationSite: json['locationSite'],
      founder: UserDetailsBasic.fromJson(json['founder']),
      members: json['members_number'],
      docRef: json['docRef']

    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Community &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          type == other.type &&
          name == other.name;

  @override
  int get hashCode => id.hashCode ^ type.hashCode ^ name.hashCode;

  @override
  String toString() {
    return 'Community{id: $id, locationSite: $locationSite, type: $type, urlLogo: $urlLogo, name: $name, description: $description, members: $members, docRef: $docRef, founder: $founder}';
  }
}
