import 'package:flutter/material.dart';

class CircularLoadingIndicator{
  static circularInd(BuildContext context){
    return const Stack(
      alignment: Alignment.center,
      children: [
        Center(child: SizedBox(
            width: 120,
            height: 120,
            child: CircularProgressIndicator())),
      ]
    );
  }
}