import 'package:flutter/material.dart';

class NeededProducts extends StatelessWidget{
  const NeededProducts({super.key});

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