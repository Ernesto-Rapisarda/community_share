import 'package:flutter/material.dart';

import '../../../model/community.dart';

class CommunityHome extends StatefulWidget{
  final Community community;
  const CommunityHome({super.key, required this.community});

  @override
  State<CommunityHome> createState() => _CommunityHomeState();
}

class _CommunityHomeState extends State<CommunityHome> {



  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(widget.community.name),

    );
  }
}