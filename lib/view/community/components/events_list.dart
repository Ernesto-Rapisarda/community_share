import 'package:community_share/providers/community_provider.dart';
import 'package:community_share/utils/circular_load_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/event.dart';

class EventsList extends StatefulWidget{
  final bool loaded;

  const EventsList({super.key, required this.loaded});

  @override
  State<EventsList> createState() => _EventsListState();
}

class _EventsListState extends State<EventsList> {
  late List<bool> _isExpanded;



  @override
  void initState() {
    super.initState();
   /* _isExpanded = List.generate(
        context.watch<CommunityProvider>().events.length, (index) => false);*/
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _isExpanded = List.generate(
        context.watch<CommunityProvider>().events.length, (index) => false);
  }



  @override
  Widget build(BuildContext context) {
/*    _isExpanded = List.generate(
        context.watch<CommunityProvider>().events.length, (index) => false);*/
    if(!widget.loaded){
      return CircularLoadingIndicator.circularInd(context);
    }
    else{
      return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            color: Theme.of(context).colorScheme.primary),
        child: Column(
          children: [
            Text(
              'Events',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onPrimary),
            ),
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

                bool isLastEvent =
                    index == context.read<CommunityProvider>().events.length - 1;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _isExpanded[index] = !_isExpanded[index];
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: isLastEvent ? Radius.circular(15) : Radius.zero,
                        bottomRight: isLastEvent ? Radius.circular(15) : Radius.zero,
                      ),
                      color: backgroundColor,
                    ),
                    child: Column(

                      children: [
                        ListTile(
                          title: Text(
                            event.title,
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(event.eventLocation),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  'Date ${event.eventDate.day}/${event.eventDate.month}/${event.eventDate.year}'),
                              Text(
                                  'Time ${event.eventDate.hour}:${event.eventDate.minute}'),
                            ],
                          ),
                        ),
                        if (_isExpanded[index])
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              event.description,
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            )
          ],
        ),
      );
    }


  }
}