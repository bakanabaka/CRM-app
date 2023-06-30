import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:term/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MaterialApp(
    home: IncrementCountWidget(),
  ));
}

class IncrementCountWidget extends StatefulWidget {
  @override
  _IncrementCountWidgetState createState() => _IncrementCountWidgetState();
}

class _IncrementCountWidgetState extends State<IncrementCountWidget> {
  int count = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    const duration = Duration(seconds: 120);
    timer = Timer.periodic(duration, (Timer t) {
      setState(() {
        count++;
      });
      updateFirebaseDays(
          count); // Update Firestore document with the updated count
    });
  }

  void updateFirebaseDays(int days) {
    FirebaseFirestore.instance
        .collection('reciever')
        .doc('lead_info')
        .collection('b@gmail.com')
        .get()
        .then((snapshot) {
      for (var doc in snapshot.docs) {
        doc.reference.update({'days': days});
      }
      print('Firebase update successful');
    }).catchError((error) => print('Firebase update failed: $error'));
  }

  @override
  void dispose() {
    timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (count > 2) {
      Future.delayed(Duration.zero, () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Count Alert'),
              content: Text('Count is greater than 10'),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    updateFirebaseDays(0);
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Increment Count'),
      ),
      // body: Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       Text(
      //         'Count: $count',
      //         style: TextStyle(fontSize: 24),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
