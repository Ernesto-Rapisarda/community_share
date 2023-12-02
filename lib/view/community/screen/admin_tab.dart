import 'package:community_share/service/community_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../model/basic/user_details_basic.dart';
import '../../../model/event.dart';
import '../../../model/product_order.dart';
import '../../../providers/community_provider.dart';
import '../components/member_row.dart';
import '../components/order_card.dart';

class AdminTab extends StatefulWidget {
  const AdminTab({super.key});

  @override
  State<AdminTab> createState() => _AdminTabState();
}

class _AdminTabState extends State<AdminTab>
    with SingleTickerProviderStateMixin {
  late TabController _innerTabController;

  List<ProductOrder> _productsOrder = [];
  List<Event> _events = [];
  int _isEventExpanded = -1;

  final CommunityService _communityService = CommunityService();

  @override
  void initState() {
    super.initState();
    _innerTabController = TabController(length: 4, vsync: this);

    fetchData();
  }

  void fetchData() async {
    List<ProductOrder> tmp = await _communityService.getCommunityOrders(
        context, context.read<CommunityProvider>().community.docRef!);
    /*_isEventExpanded = List.generate(
        context.watch<CommunityProvider>().events.length, (index) => false);*/

    List<UserDetailsBasic> members = await CommunityService().getMembers(context);

    context.read<CommunityProvider>().members = members;

    setState(() {
      _productsOrder = tmp;
    });
  }

  void deleteEvent(Event event) async {
    await _communityService.deleteEvent(context, event);
  }

  @override
  Widget build(BuildContext context) {
    var members = context.watch<CommunityProvider>().members;

    _events = context.watch<CommunityProvider>().events;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TabBar(
          controller: _innerTabController,
          tabs: [
            Tab(text: 'Ordini'),
            Tab(text: 'Eventi'),
            Tab(text: 'Segnalazioni'),
            Tab(text: 'Utenti')
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _innerTabController,
            children: [
              //tab degli order
              SingleChildScrollView(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _productsOrder.length,
                  itemBuilder: (context, index) {
                    ProductOrder order = _productsOrder[index];
                    return OrderCard(order: order, isAdministrator: true);
                  },
                ),
              ),
              //tab degli eventi
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text('Event published:',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
                      _events.length == 0
                          ? Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'No events added.',
                                    style: TextStyle(
                                        fontSize: 18, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount:
                                  context.watch<CommunityProvider>().events.length,
                              itemBuilder: (BuildContext context, int index) {
                                Event event = context
                                    .watch<CommunityProvider>()
                                    .events[index];
                                Color backgroundColor = index % 3 == 0
                                    ? Theme.of(context).colorScheme.primaryContainer
                                    : index % 3 == 1
                                        ? Theme.of(context)
                                            .colorScheme
                                            .secondaryContainer
                                        : Theme.of(context)
                                            .colorScheme
                                            .tertiaryContainer;

                                bool isLastEvent = index ==
                                    context
                                            .read<CommunityProvider>()
                                            .events
                                            .length -
                                        1;

                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if(_isEventExpanded==-1){
                                        _isEventExpanded =index;
                                      }
                                      else{
                                        _isEventExpanded = -1;
                                      }

                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: isLastEvent
                                            ? Radius.circular(15)
                                            : Radius.zero,
                                        bottomRight: isLastEvent
                                            ? Radius.circular(15)
                                            : Radius.zero,
                                      ),
                                      color: backgroundColor,
                                    ),
                                    child: Column(
                                      children: [
                                        ListTile(
                                          title: Text(
                                            event.title,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600),
                                          ),
                                          subtitle: Row(children: [ Text(
                                              'Date ${event.eventDate.day}/${event.eventDate.month}/${event.eventDate.year}'),
                                            Text(
                                                ' - Time ${event.eventDate.hour}:${event.eventDate.minute}'),],)
                                          /*Text(event.eventLocation)*/,
                                          trailing: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  IconButton(
                                                    icon: FaIcon(FontAwesomeIcons.pen, size: 14,),
                                                    onPressed: () {
                                                      _showEditEventDialog(context, event);
                                                    },
                                                  ),
                                                  IconButton(
                                                    icon: FaIcon(FontAwesomeIcons.trashCan,size: 14,),
                                                    onPressed: () {
                                                      deleteEvent(event);
                                                    },
                                                  ),
                                                ],
                                              ),

                                            ],
                                          ),
                                        ),
                                        if (_isEventExpanded!=-1 && _events.indexOf(event)==_isEventExpanded)
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  event.description,
                                                  style: TextStyle(fontSize: 16),
                                                ),
                                                Row(children: [
                                                  Text('Location: ',style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                                                  Text(event.eventLocation,style: TextStyle(fontSize: 14),)
                                                ], )
                                              ],
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                      /*ListView.builder(
                            itemCount: _events.length,
                            itemBuilder: (context, index) {
                              Event event = _events[index];
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isEventExpanded[index] = !_isEventExpanded[index];
                                  });
                                },
                                child: Card(
                                  child: Column(
                                    children: [
                                      ListTile(
                                        title: Text(event.title),
                                        subtitle: Text(event.eventLocation),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              icon: Icon(Icons.edit),
                                              onPressed: () {
                                                _showEditEventDialog(context, event);
                                              },
                                            ),
                                            IconButton(
                                              icon: Icon(Icons.delete),
                                              onPressed: () {
                                                deleteEvent(event);
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (_isEventExpanded[index])
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
                          ),*/
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                _showAddEventDialog(context);
                              },
                              child: Row(
                                children: [
                                  Icon(Icons.add),
                                  SizedBox(width: 8),
                                  Text('Add Event'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              //tab dei report
              Container(
                child: Center(
                  child: Text('Reports Tab Content'),
                ),
              ),
              //tab
              Container(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Founder:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                        MemberRow(userDetailsBasic: context.read<CommunityProvider>().community.founder),
                        SizedBox(height: 20,),
                        Text('Members: ${context.read<CommunityProvider>().community.members - 1}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                        ...members.map((tmp) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),  // Imposta la distanza desiderata
                          child: MemberRow(userDetailsBasic: tmp),
                        )).toList(),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  void _showAddEventDialog(BuildContext context) {
    TextEditingController titleController = TextEditingController();
    TextEditingController locationController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    DateTime selectedDate = DateTime.now();
    TimeOfDay selectedTime = TimeOfDay.now();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            DateTime datePicked = DateTime(
              selectedDate.year,
              selectedDate.month,
              selectedDate.day,
              selectedTime.hour,
              selectedTime.minute,
            );

            return AlertDialog(
              title: Text('Add Event'),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(labelText: 'Event Title'),
                    ),
                    TextField(
                      controller: locationController,
                      decoration: InputDecoration(labelText: 'Event Location'),
                    ),
                    TextField(
                      controller: descriptionController,
                      decoration:
                          InputDecoration(labelText: 'Event Description'),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Select date',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: selectedDate,
                              firstDate: DateTime.now(),
                              lastDate: DateTime(DateTime.now().year + 5),
                            );
                            if (pickedDate != null &&
                                pickedDate != selectedDate) {
                              setState(() {
                                selectedDate = pickedDate;
                                datePicked = DateTime(
                                  selectedDate.year,
                                  selectedDate.month,
                                  selectedDate.day,
                                  selectedTime.hour,
                                  selectedTime.minute,
                                );
                              });
                            }
                          },
                          child: Text('Pick Date'),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            TimeOfDay? pickedTime = await showTimePicker(
                              context: context,
                              initialTime: selectedTime,
                            );
                            if (pickedTime != null &&
                                pickedTime != selectedTime) {
                              setState(() {
                                selectedTime = pickedTime;
                                datePicked = DateTime(
                                  selectedDate.year,
                                  selectedDate.month,
                                  selectedDate.day,
                                  selectedTime.hour,
                                  selectedTime.minute,
                                );
                              });
                            }
                          },
                          child: Text('Pick Time'),
                        ),
                        //Text('${selectedDate.toLocal()}'),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Selected: ${DateFormat('dd/MM/yyyy HH:mm').format(datePicked.toLocal())}',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    Event newEvent = Event(
                      title: titleController.text,
                      eventLocation: locationController.text,
                      description: descriptionController.text,
                      eventDate: DateTime(
                        selectedDate.year,
                        selectedDate.month,
                        selectedDate.day,
                        selectedTime.hour,
                        selectedTime.minute,
                      ),
                    );
                    await _communityService.addOrEditEvent(context, newEvent);

/*                    newEvent.id = id;
                    context.read<CommunityProvider>().addEvents(newEvent);*/

                    Navigator.of(context).pop();
                  },
                  child: Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showEditEventDialog(BuildContext context, Event event) {
    TextEditingController titleController =
        TextEditingController(text: event.title);
    TextEditingController locationController =
        TextEditingController(text: event.eventLocation);
    TextEditingController descriptionController =
        TextEditingController(text: event.description);
    DateTime selectedDate = event.eventDate;
    TimeOfDay selectedTime =
        TimeOfDay(hour: selectedDate.hour, minute: selectedDate.minute);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            DateTime datePicked = DateTime(
              selectedDate.year,
              selectedDate.month,
              selectedDate.day,
              selectedTime.hour,
              selectedTime.minute,
            );

            return AlertDialog(
              title: Text('Edit Event'),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(labelText: 'Event Title'),
                    ),
                    TextField(
                      controller: locationController,
                      decoration: InputDecoration(labelText: 'Event Location'),
                    ),
                    TextField(
                      controller: descriptionController,
                      decoration:
                          InputDecoration(labelText: 'Event Description'),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Select date',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: selectedDate,
                              firstDate: DateTime.now(),
                              lastDate: DateTime(DateTime.now().year + 5),
                            );
                            if (pickedDate != null &&
                                pickedDate != selectedDate) {
                              setState(() {
                                selectedDate = pickedDate;
                                datePicked = DateTime(
                                  selectedDate.year,
                                  selectedDate.month,
                                  selectedDate.day,
                                  selectedTime.hour,
                                  selectedTime.minute,
                                );
                              });
                            }
                          },
                          child: Text('Pick Date'),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            TimeOfDay? pickedTime = await showTimePicker(
                              context: context,
                              initialTime: selectedTime,
                            );
                            if (pickedTime != null &&
                                pickedTime != selectedTime) {
                              setState(() {
                                selectedTime = pickedTime;
                                datePicked = DateTime(
                                  selectedDate.year,
                                  selectedDate.month,
                                  selectedDate.day,
                                  selectedTime.hour,
                                  selectedTime.minute,
                                );
                              });
                            }
                          },
                          child: Text('Pick Time'),
                        ),
                        //Text('${selectedDate.toLocal()}'),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Selected: ${DateFormat('dd/MM/yyyy HH:mm').format(datePicked.toLocal())}',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    Event tmpEvent = Event(
                        eventDate: datePicked,
                        title: titleController.text,
                        eventLocation: locationController.text,
                        description: descriptionController.text);

                    if (event.id != null && event.id != '') {
                      tmpEvent.id = event.id;
                    }

                    await _communityService.addOrEditEvent(context, tmpEvent);

                    Navigator.of(context).pop();
                  },
                  child: Text('Update'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
