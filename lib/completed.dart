import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:term/pdf_viewer_crm/pdf/pdf_page.dart';
import 'package:term/pdf_viewer_crm/pdf/pdf_page_comp.dart';
import 'package:term/reciever_page.dart';
import 'package:term/user_template.dart';

class Completed extends StatefulWidget {
  const Completed({super.key});

  @override
  State<Completed> createState() => _CompletedState();
}

class _CompletedState extends State<Completed> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Comp(),
    );
  }
}

class Comp extends StatelessWidget {
  const Comp({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> navigationOptions = [
      {'title': 'Completed', 'icon': Icons.accessibility_rounded},
      {'title': 'Leads', 'icon': Icons.leaderboard}
    ];
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
          builder: (context) => PdfPage2(documentId: documentId),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Completed'),
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
              .doc('completed')
              // .collection(user?.email ?? '')
              .collection('b@gmail.com')
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
