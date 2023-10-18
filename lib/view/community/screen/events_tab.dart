import 'package:flutter/material.dart';

class EventsTab extends StatelessWidget{
  const EventsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: Center(

        child: Text('events'),
      ),
    );
  }

}