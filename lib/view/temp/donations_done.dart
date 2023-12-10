import 'package:flutter/material.dart';

class DonationsDone extends StatelessWidget{
  const DonationsDone({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body: Row(
        children: [
          Text(runtimeType.toString()),
          Text('ciao')
        ],
      ),
    );
  }


}