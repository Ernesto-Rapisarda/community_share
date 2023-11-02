import 'package:flutter/material.dart';

import '../model/basic/user_details_basic.dart';
import '../model/community.dart';
import '../model/enum/community_type.dart';
import '../model/event.dart';

class CommunityProvider with ChangeNotifier {
  bool _isLoading = true;
  late Community _community;
  late List<Event> _events;
  late List<UserDetailsBasic> _members;

  CommunityProvider() {
    _events = [];
    _members = [];
  }

  List<UserDetailsBasic> get members => _members;

  List<Event> get events => _events;

  Community get community => _community;
  bool get isLoading => _isLoading;

  void updateCommunity(
      {String? locationSite,
      CommunityType? type,
      String? urlLogo,
      String? name,
      String? description})
  {
    if(locationSite != null && _community.locationSite != locationSite){
      _community.locationSite = locationSite;
    }
    if (type != null && _community.type != type) {
      _community.type = type;
    }
    if (urlLogo != null && _community.urlLogo != urlLogo) {
      _community.urlLogo = urlLogo;
    }
    if (name != null && _community.name != name) {
      _community.name = name;
    }
    if (description != null && _community.description != description) {
      _community.description = description;
    }

    notifyListeners();

  }


  set community(Community value) {
    _community = value;
    _isLoading = false;
    notifyListeners();
  }

  set members(List<UserDetailsBasic> value) {
    _members = value;
    notifyListeners();

  }

  void addMembers(UserDetailsBasic tmp){
    _members.add(tmp);
    notifyListeners();

  }

  set events(List<Event> value) {
    _events = value;
    notifyListeners();

  }

  void addEvents(Event event){
    _events.add(event);
    notifyListeners();

  }
}
