import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:term/completed.dart';
import 'package:term/firebase_options.dart';
import 'package:term/user_template.dart';
import 'package:term/pdf_viewer_crm/pdf/pdf_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: RecieverPage());
  }
}

class RecieverPage extends StatefulWidget {
  const RecieverPage({Key? key}) : super(key: key);

  @override
  _RecieverPageState createState() => _RecieverPageState();
}

class _RecieverPageState extends State<RecieverPage> {
  void navigateToDetailsPage(String documentId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserDetailsPage(documentId: documentId),
      ),
    );
  }

  void navigateToPrintPage(String documentId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PdfPage1(documentId: documentId),
      ),
    );
  }

  Future<void> deleteData(String documentId) async {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final userEmail = user.email;
      await FirebaseFirestore.instance
          .collection('reciever')
          .doc('lead_info')
          .collection(userEmail!)
          .doc(documentId)
          .delete();
    }
  }

  Future<void> copyData(String documentId) async {
    DocumentSnapshot<Map<String, dynamic>> oldDocumentSnapshot =
        await FirebaseFirestore.instance
            .collection('reciever')
            .doc('lead_info')
            .collection('b@gmail.com')
            .doc(documentId)
            .get();
    if (oldDocumentSnapshot.exists) {
      // Get the data as a Map
      Map<String, dynamic> data = oldDocumentSnapshot.data()!;

      // Add to the new collection
      await FirebaseFirestore.instance
          .collection('reciever')
          .doc('completed')
          .collection('b@gmail.com')
          .doc(documentId)
          .set(data);
      await FirebaseFirestore.instance
          .collection('reciever')
          .doc('lead_info')
          .collection('b@gmail.com')
          .doc(documentId)
          .delete();
    }
  }

  final List<Map<String, dynamic>> navigationOptions = [
    {'title': 'Completed', 'icon': Icons.accessibility_rounded},
    {'title': 'Leads', 'icon': Icons.leaderboard}
  ];

  // void updateFirebaseDaysDocs(int days, String documentId) {
  //   FirebaseFirestore.instance
  //       .collection('reciever')
  //       .doc('lead_info')
  //       .collection('b@gmail.com')
  //       .doc(documentId)
  //       .update({'days': days});
  //   print('Firebase update successful');
  // }

  int count = 0;
  Map<String, int> documentCounts = {};
  Timer? timer;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() {
    documentCounts.clear();
    fetchInitialCounts();
    startTimer();
  }

  void fetchInitialCounts() {
    FirebaseFirestore.instance
        .collection('reciever')
        .doc('lead_info')
        .collection('b@gmail.com')
        .get()
        .then((snapshot) {
      for (var doc in snapshot.docs) {
        documentCounts[doc.id] = doc.data()['days'] ?? 0;
      }
      print('Initial counts retrieved successfully');
    }).catchError(
            (error) => print('Failed to retrieve initial counts: $error'));
  }

  void startTimer() {
    const duration = Duration(seconds: 15);
    timer = Timer.periodic(duration, (Timer t) {
      setState(() {
        for (var documentId in documentCounts.keys) {
          if (documentCounts[documentId] == 0) {
            documentCounts[documentId] = 1;
          } else {
            documentCounts[documentId] = (documentCounts[documentId] ?? 0) + 1;
          }
        }
      });
      updateFirebaseDays();
    });
  }

  Future<void> updateFirebaseDays() async {
    for (var documentId in documentCounts.keys) {
      final days = documentCounts[documentId];
      try {
        await FirebaseFirestore.instance
            .collection('reciever')
            .doc('lead_info')
            .collection('b@gmail.com')
            .doc(documentId)
            .update({'days': days});
        // print('Firebase update successful');
      } catch (error) {
        print('Firebase update failed: $error');
      }
    }
  }

  void resetCount(String documentId) {
    documentCounts[documentId] = 0;
    FirebaseFirestore.instance
        .collection('reciever')
        .doc('lead_info')
        .collection('b@gmail.com')
        .doc(documentId)
        .update({'days': 0}).then((_) {
      setState(() {
        documentCounts[documentId] = 0;
      });
      print('Count reset successful');
      updateFirebaseDays(); // Update Firestore documents with the updated counts
      fetchInitialCounts(); // Fetch updated counts after reset
    }).catchError((error) {
      print('Count reset failed: $error');
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (documentCounts.isNotEmpty) {
      documentCounts.forEach((documentId, count) {
        if (count > 5) {
          Future.delayed(Duration.zero, () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Count Alert'),
                  content:
                      Text('Count is greater than 5 for user: $documentId'),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        updateFirebaseDays();
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
          });
        }
      });
    }

    final User? user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Success'),
      ),
      drawer: Drawer(
        child: ListView.builder(
          itemCount: navigationOptions.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Icon(navigationOptions[index]['icon']),
              title: Text(navigationOptions[index]['title']),
              onTap: () {
                // Perform navigation based on the selected option
                Navigator.pop(context); // Close the sidebar
                if (index == 0) {
                  // Option 1 selected
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Completed(),
                    ),
                  );
                } else if (index == 1) {
                  // Option 2 selected
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RecieverPage(),
                    ),
                  );
                }
              },
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('reciever')
              .doc('lead_info')
              // .collection(user?.email ?? '')
              .collection(user?.email ?? 'b@gmail.com')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SizedBox(
                height: MediaQuery.of(context).size.height,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (snapshot.hasData) {
              final documents = snapshot.data!.docs;

              // Sort documents based on priority value
              documents.sort((a, b) {
                final priorityA = a['priority'] as int? ?? 0;
                final priorityB = b['priority'] as int? ?? 0;
                return priorityA.compareTo(priorityB);
              });

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: documents.length,
                itemBuilder: (context, index) {
                  final document = documents[index];
                  final data = document.data() as Map<String, dynamic>;
                  final name = data['name'];
                  final email = data['email'];
                  final phone = data['phone'];
                  final description = data['description'];
                  final assignedTo = data['assigned_to'];
                  final label = data['label'];
                  final priority = data['priority'];
                  final days = data['days'];

                  return GestureDetector(
                    onTap: () {
                      // updateFirebaseDaysDocs(0, document.id);
                      navigateToDetailsPage(document.id);
                      resetCount(document.id);
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Name:',
                                          style: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.7),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(name),
                                      ],
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          'Email:',
                                          style: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.7),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(email),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Phone:',
                                          style: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.7),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(phone),
                                      ],
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          'Assigned:',
                                          style: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.7),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(assignedTo),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            // Container(
                            //   child: Row(
                            //     children: [
                            //       Expanded(
                            //         child: Column(
                            //           children: [
                            //             Text(
                            //               'Priority:',
                            //               style: TextStyle(
                            //                 color:
                            //                     Colors.black.withOpacity(0.7),
                            //                 fontWeight: FontWeight.bold,
                            //               ),
                            //             ),
                            //             const SizedBox(height: 4),
                            //             Text(priority != -1
                            //                 ? priority.toString()
                            //                 : ''),
                            //             const SizedBox(height: 6),
                            //           ],
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            const SizedBox(
                              height: 1,
                            ),
                            Container(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Text(
                                          'Description:',
                                          style: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.7),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(description),
                                        const SizedBox(height: 6),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right:
                                                  28.0), // Adjust the left padding as needed
                                          // child: IconButton(
                                          //   onPressed: () {
                                          //     deleteData(document.id);
                                          //   },
                                          //   icon: const Icon(Icons.delete),
                                          //   color: Colors.red,
                                          // ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Text(
                                          'Label:',
                                          style: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.7),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(label ?? ''),
                                        const SizedBox(height: 6),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      navigateToPrintPage(document.id);
                                    },
                                    child: Text("Generate Report"),
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      backgroundColor: Colors.amber,
                                      padding: const EdgeInsets.fromLTRB(
                                          30, 20, 30, 20),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      copyData(document.id);
                                    },
                                    child: Text("Set as Completed"),
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      backgroundColor: Colors.amber,
                                      padding: const EdgeInsets.fromLTRB(
                                          30, 20, 30, 20),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return const Text('Error retrieving data from Firestore');
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}
