import 'package:flutter/material.dart';

class PalettaColori extends StatelessWidget{
  const PalettaColori({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,

      ),
      body: Column(
        children: [
          Container(
            height: 70,
            color: Theme.of(context).colorScheme.primary,
            child: Center(
              child: Text('Primary and onPrimary, ${Theme.of(context).colorScheme.primary.value.toRadixString(16)}  ',style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),),
            ),
          ),
          Container(
            height: 70,
            color: Theme.of(context).colorScheme.secondary,
            child: Center(
              child: Text('Secondary and onSecondary ',style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),),
            ),
          ),
          Container(
            height: 70,
            color: Theme.of(context).colorScheme.tertiary,
            child: Center(
              child: Text('Tertiary and onTertiary, ${Theme.of(context).colorScheme.tertiary.value.toRadixString(16)}  ',style: TextStyle(color: Theme.of(context).colorScheme.onTertiary),),
            ),
          ),
          Container(
            height: 70,
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Center(
              child: Text('PrimaryContainer and onPrimCont ',style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer),),
            ),
          ),
          Container(
            height: 70,
            color: Theme.of(context).colorScheme.secondaryContainer,
            child: Center(
              child: Text('SecondaryCont and onSecondaryCont ',style: TextStyle(color: Theme.of(context).colorScheme.onSecondaryContainer),),
            ),
          ),
          Container(
            height: 70,
            color: Theme.of(context).colorScheme.tertiaryContainer,
            child: Center(
              child: Text('TertiaryCont and onTertiaryCont ',style: TextStyle(color: Theme.of(context).colorScheme.onTertiaryContainer),),
            ),
          ),
        ],

      ),
    ) ;
  }

}