import 'package:flutter/material.dart';

class ProfileSettings extends StatelessWidget{
  const ProfileSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body: Text(runtimeType.toString()),
    );
  }


}