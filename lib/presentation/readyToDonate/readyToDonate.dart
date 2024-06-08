import 'package:blood_donation/presentation/Drawer/staff_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class ReadyToDonate extends StatefulWidget {
  const ReadyToDonate({Key? key}) : super(key: key);

  @override
  State<ReadyToDonate> createState() => _ReadyToDonateState();
}

class _ReadyToDonateState extends State<ReadyToDonate> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _deleteDonationForm(String docId) async {
    try {
      await _firestore.collection('Donation Form').doc(docId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Donation Form Deleted', style: TextStyle(color: Colors.red)),
          backgroundColor: Colors.white,
        ),
      );
      print('Donation form data deleted successfully');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting donation form: $e', style: TextStyle(color: Colors.red)),
          backgroundColor: Colors.white,
        ),
      );
      print('Error deleting donation form data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        centerTitle: true,
        title: Text(
          "Ready to Donate",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      drawer: StaffDrawer(),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('Donation Form').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data?.docs ?? [];

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              return Card(
                color: Colors.grey[300],
                margin: EdgeInsets.all(10),
                child: ListTile(
                  title: Text(doc['name'],style: TextStyle(fontWeight: FontWeight.bold),),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Email : ${doc['email']}'),
                      SizedBox(height: 5),
                      Text('Age : ${doc['age']}'),
                      SizedBox(height: 5),
                      Text('Height : ${doc['height']}'),
                      SizedBox(height: 5),
                      Text('Weight : ${doc['weight']}'),
                      SizedBox(height: 5),
                      Text('Race : ${doc['race']}'),
                      SizedBox(height: 5),
                      Text('Ic Number : ${doc['icNumber']}'),
                      SizedBox(height: 5),
                      Text('Hp Number : ${doc['hpNumber']}'),
                      SizedBox(height: 5),
                      Text('MaritalStatus : ${doc['maritalStatus']}'),
                      SizedBox(height: 5),
                      Text('Address : ${doc['address']}'),
                      SizedBox(height: 5),
                      Text('Current Job : ${doc['currentJob']}'),
                      SizedBox(height: 5),

                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _deleteDonationForm(doc.id);
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    // Implement navigation to the details or edit screen here
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
