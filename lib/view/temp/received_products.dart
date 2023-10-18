import 'package:flutter/material.dart';

class ReceivedProducts extends StatelessWidget{
  const ReceivedProducts({super.key});

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