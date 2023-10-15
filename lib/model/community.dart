import 'package:community_share/model/enum/community_type.dart';
import 'package:community_share/model/product.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'event.dart';

class Community{
  late List<Product> productsOffered;
  late List<Product> productsSearched;
//  late List<User> members;
  late List<String> members;

  late List<Event> events;
  late String locationSite;
  late CommunityType type;
  late String urlLogo;
  late String name;
  //aggiungere la chat

}