import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:term/reciever_page.dart';
import 'package:url_launcher/url_launcher.dart';

class UserDetailsPage extends StatelessWidget {
  final String documentId;

  const UserDetailsPage({required this.documentId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Ranga(documentId: documentId),
    );
  }
}

class Ranga extends StatefulWidget {
  final String documentId;
  const Ranga({required this.documentId, Key? key}) : super(key: key);

  @override
  State<Ranga> createState() => _RangaState();
}

class _RangaState extends State<Ranga> {
  late final String documentId;
  bool showNumbers = false;
  int selectedPriority = -1;

  @override
  void initState() {
    documentId = widget.documentId;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController label = TextEditingController();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => RecieverPage()),
            );
          },
        ),
        title: Text("Hey Ruth"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(30, 40, 30, 40),
        child: Center(
          child: SingleChildScrollView(
            child: FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('reciever')
                  .doc('lead_info')
                  .collection('b@gmail.com')
                  .doc(documentId)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Show a loading indicator while fetching data
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  // Handle error if any
                  return const Text('Error occurred while fetching data');
                }
                if (snapshot.hasData && snapshot.data != null) {
                  // Data fetched successfully
                  // final data = snapshot.data?.data();
                  final data = snapshot.data!.data() as Map<String, dynamic>;
                  final name = data['name'] as String? ?? '';
                  final email = data['email'] as String? ?? '';
                  final phone = data['phone'] as String? ?? '';
                  final locationData =
                      data?['address'] as Map<String, dynamic>?;

                  final area = locationData?['area'] as String? ?? '';
                  final street = locationData?['street'] as String? ?? '';
                  final description = data['description'] as String? ?? '';
                  final labels = data['label'] as String? ?? '';
                  final prioritys = data['priority']?.toString() ?? '';

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Name',
                        style: TextStyle(
                            color: Colors.grey[700], letterSpacing: 2),
                      ),
                      const SizedBox(height: 5.0),
                      Text(
                        name,
                        style: TextStyle(
                          color: Colors.amber.shade700,
                          letterSpacing: 2,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        children: [
                          Icon(
                            Icons.email,
                            color: Colors.grey[700],
                          ),
                          const SizedBox(width: 10),
                          Text(
                            email,
                            style: TextStyle(
                              color: Colors.blue[700],
                              fontSize: 18,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Row(
                        children: [
                          Icon(
                            Icons.phone,
                            color: Colors.grey[700],
                          ),
                          const SizedBox(width: 10),
                          Text(
                            phone,
                            style: TextStyle(
                              color: Colors.deepPurple[500],
                              fontSize: 18,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              final phoneNumber = '+91 :$phone';
                              launch('tel:$phoneNumber');
                            },
                            child: Text("Call User"),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              backgroundColor: Colors.amber,
                              padding:
                                  const EdgeInsets.fromLTRB(20, 20, 20, 20),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Row(
                        children: [
                          Icon(
                            Icons.location_city,
                            color: Colors.grey[700],
                          ),
                          const SizedBox(width: 10),
                          Row(
                            children: [
                              Text(
                                street,
                                style: TextStyle(
                                  color: Colors.deepPurple[500],
                                  fontSize: 18,
                                  letterSpacing: 1,
                                ),
                              ),
                              const SizedBox(
                                width: 3,
                              ),
                              Text(
                                area,
                                style: TextStyle(
                                  color: Colors.deepPurple[500],
                                  fontSize: 18,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // if (labels.isNotEmpty)
                          Align(
                            alignment: Alignment.topLeft,
                            child: Icon(
                              Icons.priority_high_sharp,
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Flexible(
                            child: Text(
                              prioritys,
                              style: TextStyle(
                                color: Colors.deepPurple[500],
                                fontSize: 18,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Icon(
                              Icons.description,
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Flexible(
                            child: Text(
                              description,
                              style: TextStyle(
                                color: Colors.deepPurple[500],
                                fontSize: 18,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (labels.isNotEmpty)
                            Align(
                              alignment: Alignment.topLeft,
                              child: Icon(
                                Icons.label,
                                color: Colors.grey[700],
                              ),
                            ),
                          const SizedBox(width: 10),
                          Flexible(
                            child: Text(
                              labels,
                              style: TextStyle(
                                color: Colors.deepPurple[500],
                                fontSize: 18,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 17,
                      ),
                      TextField(
                        controller: label,
                        maxLines: null,
                        decoration: const InputDecoration(
                          labelText: 'Label',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Column(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    showNumbers = !showNumbers;
                                  });
                                },
                                child: Text(showNumbers
                                    ? 'Hide Priority'
                                    : 'Set Priority'),
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  backgroundColor: Colors.amber,
                                  padding:
                                      const EdgeInsets.fromLTRB(30, 20, 30, 20),
                                ),
                              ),
                              Visibility(
                                visible: showNumbers,
                                child: Column(
                                  children: List.generate(10, (index) {
                                    int number = index + 1;
                                    return InkWell(
                                      onTap: () {
                                        selectedPriority = number;
                                        // print('Selected number: $number');
                                      },
                                      child: SizedBox(
                                        height: 25,
                                        child: Center(
                                          child: Text(
                                            '$number',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          String newLabel = label.text.trim();
                          if (newLabel.isNotEmpty) {
                            FirebaseFirestore.instance
                                .collection('reciever')
                                .doc('lead_info')
                                .collection('b@gmail.com')
                                .doc(documentId)
                                .update({'label': newLabel}).then((value) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RecieverPage()),
                              );
                            }).catchError((error) {});
                          }
                          if (selectedPriority != -1) {
                            FirebaseFirestore.instance
                                .collection('reciever')
                                .doc('lead_info')
                                .collection('b@gmail.com')
                                .doc(documentId)
                                .update({'priority': selectedPriority}).then(
                                    (value) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RecieverPage()),
                              );
                            }).catchError((error) {});
                          }
                          if (newLabel.isNotEmpty && selectedPriority != -1) {
                            FirebaseFirestore.instance
                                .collection('reciever')
                                .doc('lead_info')
                                .collection('b@gmail.com')
                                .doc(documentId)
                                .update({
                              'label': newLabel,
                              'priority': selectedPriority
                            }).then((value) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RecieverPage()),
                              );
                            }).catchError((error) {});
                          }
                        },
                        child: Text("Save"),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: Colors.amber,
                          padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                    ],
                  );
                }
                return const Text('No data available');
              },
            ),
          ),
        ),
      ),
    );
  }
}

// class Test extends StatelessWidget {
//   final String documentId;

//   const Test({required this.documentId, Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final TextEditingController label = TextEditingController();
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(builder: (context) => RecieverPage()),
//             );
//           },
//         ),
//         title: Text("Hey Ruth"),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.fromLTRB(30, 40, 30, 40),
//         child: Center(
//           child: SingleChildScrollView(
//             child: FutureBuilder<DocumentSnapshot>(
//               future: FirebaseFirestore.instance
//                   .collection('reciever')
//                   .doc('lead_info')
//                   .collection('b@gmail.com')
//                   .doc(documentId)
//                   .get(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   // Show a loading indicator while fetching data
//                   return const CircularProgressIndicator();
//                 }
//                 if (snapshot.hasError) {
//                   // Handle error if any
//                   return const Text('Error occurred while fetching data');
//                 }
//                 if (snapshot.hasData && snapshot.data != null) {
//                   // Data fetched successfully
//                   // final data = snapshot.data?.data();
//                   final data = snapshot.data!.data() as Map<String, dynamic>;
//                   final name = data['name'] as String? ?? '';
//                   final email = data['email'] as String? ?? '';
//                   final phone = data['phone'] as String? ?? '';
//                   final locationData =
//                       data?['address'] as Map<String, dynamic>?;

//                   final area = locationData?['area'] as String? ?? '';
//                   final street = locationData?['street'] as String? ?? '';
//                   final description = data['description'] as String? ?? '';
//                   final labels = data['label'] as String? ?? '';

//                   return Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Name',
//                         style: TextStyle(
//                             color: Colors.grey[700], letterSpacing: 2),
//                       ),
//                       const SizedBox(height: 5.0),
//                       Text(
//                         name,
//                         style: TextStyle(
//                           color: Colors.amber.shade700,
//                           letterSpacing: 2,
//                           fontSize: 28,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 30),
//                       Row(
//                         children: [
//                           Icon(
//                             Icons.email,
//                             color: Colors.grey[700],
//                           ),
//                           const SizedBox(width: 10),
//                           Text(
//                             email,
//                             style: TextStyle(
//                               color: Colors.blue[700],
//                               fontSize: 18,
//                               letterSpacing: 1,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 30),
//                       Row(
//                         children: [
//                           Icon(
//                             Icons.phone,
//                             color: Colors.grey[700],
//                           ),
//                           const SizedBox(width: 10),
//                           Text(
//                             phone,
//                             style: TextStyle(
//                               color: Colors.deepPurple[500],
//                               fontSize: 18,
//                               letterSpacing: 1,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 30),
//                       Row(
//                         children: [
//                           Icon(
//                             Icons.location_city,
//                             color: Colors.grey[700],
//                           ),
//                           const SizedBox(width: 10),
//                           Row(
//                             children: [
//                               Text(
//                                 street,
//                                 style: TextStyle(
//                                   color: Colors.deepPurple[500],
//                                   fontSize: 18,
//                                   letterSpacing: 1,
//                                 ),
//                               ),
//                               const SizedBox(
//                                 width: 3,
//                               ),
//                               Text(
//                                 area,
//                                 style: TextStyle(
//                                   color: Colors.deepPurple[500],
//                                   fontSize: 18,
//                                   letterSpacing: 1,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 30),
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Align(
//                             alignment: Alignment.topLeft,
//                             child: Icon(
//                               Icons.description,
//                               color: Colors.grey[700],
//                             ),
//                           ),
//                           const SizedBox(width: 10),
//                           Flexible(
//                             child: Text(
//                               description,
//                               style: TextStyle(
//                                 color: Colors.deepPurple[500],
//                                 fontSize: 18,
//                                 letterSpacing: 1,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(
//                         height: 20,
//                       ),
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           if (labels.isNotEmpty)
//                             Align(
//                               alignment: Alignment.topLeft,
//                               child: Icon(
//                                 Icons.label,
//                                 color: Colors.grey[700],
//                               ),
//                             ),
//                           const SizedBox(width: 10),
//                           Flexible(
//                             child: Text(
//                               labels,
//                               style: TextStyle(
//                                 color: Colors.deepPurple[500],
//                                 fontSize: 18,
//                                 letterSpacing: 1,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(
//                         height: 17,
//                       ),
//                       TextField(
//                         controller: label,
//                         maxLines: null, // Allows typing a large text
//                         decoration: const InputDecoration(
//                           labelText: 'Label',
//                           border: OutlineInputBorder(),
//                         ),
//                       ),
//                       Column(
//                         children: List.generate(10, (index) {
//                           int number = index + 1;
//                           return InkWell(
//                             onTap: () {
//                               // Handle the selection of the number
//                               print('Selected number: $number');
//                             },
//                             child: SizedBox(
//                               height: 25,
//                               child: Center(
//                                 child: Text(
//                                   '$number',
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.black,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           );
//                         }),
//                       ),
//                       ElevatedButton(
//                         onPressed: () {
//                           String newLabel = label.text.trim();
//                           if (newLabel.isNotEmpty) {
//                             FirebaseFirestore.instance
//                                 .collection('reciever')
//                                 .doc('lead_info')
//                                 .collection('b@gmail.com')
//                                 .doc(documentId)
//                                 .update({'label': newLabel}).then((value) {
//                               Navigator.pushReplacement(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) => RecieverPage()),
//                               );
//                             }).catchError((error) {});
//                           }
//                         },
//                         child: Text("Save"),
//                         style: ElevatedButton.styleFrom(
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           backgroundColor: Colors.amber,
//                           padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 25,
//                       ),
//                     ],
//                   );
//                 }
//                 return const Text('No data available');
//               },
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
