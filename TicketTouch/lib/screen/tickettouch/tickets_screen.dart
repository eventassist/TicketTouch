import 'package:another_transformer_page_view/another_transformer_page_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/controllers/simple_hidden_drawer_controller.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:ticket_widget/ticket_widget.dart';
import 'package:tickettouch/utils/buildin_transformers.dart';

class TicketsScreen extends StatefulWidget {
  const TicketsScreen({Key? key}) : super(key: key);

  @override
  _TicketsScreenState createState() => _TicketsScreenState();
}

class _TicketsScreenState extends State<TicketsScreen> {
  final auth = FirebaseAuth.instance;
  final user = FirebaseAuth.instance.currentUser;

  late Stream<QuerySnapshot> _ticketsStream;

  @override
  void initState() {
    super.initState();
    _ticketsStream = FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .collection('tickets')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          iconSize: 24,
          icon: const Icon(Icons.menu),
          onPressed: () => SimpleHiddenDrawerController.of(context).open(),
        ),
        title: const Text('My Tickets'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _ticketsStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data!.size == 0) {
            return const Center(
              child: Text('You don\'t have tickets'),
            );
          }

          return TransformerPageView(
            loop: true,
            scrollDirection: Axis.vertical,
            transformer: ScaleAndFadeTransformer(),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              final Map<String, dynamic> ticket =
                  snapshot.data!.docs[index].data() as Map<String, dynamic>;

              return StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('events')
                    .doc(ticket['eventId'])
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> eventSnapshot) {
                  if (eventSnapshot.hasError ||
                      !eventSnapshot.hasData ||
                      !eventSnapshot.data!.exists) {
                    return Container();
                  } else {
                    final Map<String, dynamic> eventData =
                        eventSnapshot.data!.data() as Map<String, dynamic>;

                    return Padding(
                      padding: const EdgeInsets.all(25),
                      child: TicketWidget(
                        width: 350,
                        height: 500,
                        color: const Color(0xFF00a9ce),
                        isCornerRounded: true,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16.0, horizontal: 16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    eventData['name'],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 28.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20, right: 20),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            child: QrImageView(
                                              data: ticket['qrCodeUrl'],
                                              version: QrVersions.auto,
                                              size: 190.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 110,
                              width: 120,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                    'assets/logos/1024_no_back.png',
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const Text(
                                    'Location',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  const SizedBox(height: 4.0),
                                  Text(
                                    eventData['location'],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                    ),
                                  ),
                                  const SizedBox(height: 16.0),
                                  const Text(
                                    'Start Date & Time',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  const SizedBox(height: 4.0),
                                  Text(
                                    "${DateFormat('EEEE, dd.MM.yyyy').format(eventData['start'].toDate())} at ${DateFormat('hh:mm').format(eventData['start'].toDate())}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                    ),
                                  ),
                                  const SizedBox(height: 16.0),
                                  const Text(
                                    'End Date & Time',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  const SizedBox(height: 4.0),
                                  Text(
                                    "${DateFormat('EEEE, dd.MM.yyyy').format(eventData['end'].toDate())} at ${DateFormat('hh:mm').format(eventData['end'].toDate())}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
