import 'package:community_share/providers/community_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/event.dart';

class EventsList extends StatefulWidget{
  const EventsList({super.key});

  @override
  State<EventsList> createState() => _EventsListState();
}

class _EventsListState extends State<EventsList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        color: Theme.of(context).colorScheme.primary
      ),
      child: Column(
        children: [
          Text('Events', style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,color: Theme.of(context).colorScheme.onPrimary),),
          ListView.builder(
            shrinkWrap: true,
            itemCount: context.watch<CommunityProvider>().events.length,
            itemBuilder: (BuildContext context, int index) {
              Event event = context.watch<CommunityProvider>().events[index];
              Color backgroundColor = index % 3 == 0
                  ? Theme.of(context).colorScheme.primaryContainer
                  : index % 3 == 1
                  ? Theme.of(context).colorScheme.secondaryContainer
                  : Theme.of(context).colorScheme.tertiaryContainer;

              bool isLastEvent = index == context.read<CommunityProvider>().events.length - 1;

              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: isLastEvent ? Radius.circular(15) : Radius.zero,
                    bottomRight: isLastEvent ? Radius.circular(15) : Radius.zero,
                  ),
                  color: backgroundColor,
                ),
                child: ListTile(
                  title: Text(event.title,style: TextStyle(fontWeight: FontWeight.w600),),
                  subtitle: Text(event.eventLocation),
                  trailing: Text('${event.eventDate.day}/${event.eventDate.month}/${event.eventDate.year}'),
                  onTap: () {
                    // Azioni quando l'evento viene toccato
                    print('Tapped Event: ${event.title}');
                  },
                ),
              );
            },
          )
        ],
      ),
    );
  }
}