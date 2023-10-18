import 'package:flutter/material.dart';

class EmailChange extends StatelessWidget{
  const EmailChange({super.key});

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