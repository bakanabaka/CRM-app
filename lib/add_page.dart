import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddPage extends StatelessWidget {
  const AddPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();
    final TextEditingController streetController = TextEditingController();
    final TextEditingController areaController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController assignedToController = TextEditingController();

    void submitForm() async {
      // Access the Firestore instance
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Prepare the data to be stored in Firestore
      final data = {
        'name': nameController.text,
        'email': emailController.text,
        'phone': phoneController.text,
        'address': {
          'street': streetController.text,
          'area': areaController.text,
        },
        'description': descriptionController.text,
        'assigned_to': assignedToController.text,
        'priority': 0,
        'days': 0,
      };

      // Store the data in Firestore
      await firestore
          .collection('adder')
          .doc('personal_info')
          .collection('Info')
          .add(data);
      await firestore
          .collection('reciever')
          .doc('lead_info')
          .collection(assignedToController.text)
          .add(data);

      // Reload the page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AddPage()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Success'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Personal Info",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextFormField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Phone'),
              ),
              const SizedBox(height: 46),
              const Text(
                "Address Info",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              TextFormField(
                controller: streetController,
                decoration: const InputDecoration(labelText: 'Street'),
              ),
              TextFormField(
                controller: areaController,
                decoration: const InputDecoration(labelText: 'Area'),
              ),
              const SizedBox(height: 46),
              const Text(
                "Description",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              const SizedBox(height: 46),
              const Text(
                "Assigned_to",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              TextFormField(
                controller: assignedToController,
                decoration: const InputDecoration(labelText: 'Assigning mail'),
              ),
              const SizedBox(height: 46),
              ElevatedButton(
                onPressed: submitForm,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: Colors.amber,
                  padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
                ),
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
