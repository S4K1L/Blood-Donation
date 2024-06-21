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
                      Text('Marital Status : ${doc['maritalStatus']}'),
                      SizedBox(height: 5),
                      Text('Address : ${doc['address']}'),
                      SizedBox(height: 5),
                      Text('Current Job : ${doc['currentJob']}'),
                      SizedBox(height: 5),
                    ],
                  ),
                  trailing: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: IconButton(
                          icon: Icon(Icons.edit, color: Colors.red),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditDonationForm(doc: doc),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 10,),
                      Expanded(
                        child: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _deleteDonationForm(doc.id);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class EditDonationForm extends StatefulWidget {
  final DocumentSnapshot doc;

  const EditDonationForm({required this.doc, Key? key}) : super(key: key);

  @override
  _EditDonationFormState createState() => _EditDonationFormState();
}

class _EditDonationFormState extends State<EditDonationForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _ageController;
  late TextEditingController _heightController;
  late TextEditingController _weightController;
  late TextEditingController _raceController;
  late TextEditingController _icNumberController;
  late TextEditingController _hpNumberController;
  late TextEditingController _maritalStatusController;
  late TextEditingController _addressController;
  late TextEditingController _currentJobController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.doc['name']);
    _emailController = TextEditingController(text: widget.doc['email']);
    _ageController = TextEditingController(text: widget.doc['age']);
    _heightController = TextEditingController(text: widget.doc['height']);
    _weightController = TextEditingController(text: widget.doc['weight']);
    _raceController = TextEditingController(text: widget.doc['race']);
    _icNumberController = TextEditingController(text: widget.doc['icNumber']);
    _hpNumberController = TextEditingController(text: widget.doc['hpNumber']);
    _maritalStatusController = TextEditingController(text: widget.doc['maritalStatus']);
    _addressController = TextEditingController(text: widget.doc['address']);
    _currentJobController = TextEditingController(text: widget.doc['currentJob']);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _raceController.dispose();
    _icNumberController.dispose();
    _hpNumberController.dispose();
    _maritalStatusController.dispose();
    _addressController.dispose();
    _currentJobController.dispose();
    super.dispose();
  }

  Future<void> _updateDonationForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        await widget.doc.reference.update({
          'name': _nameController.text,
          'email': _emailController.text,
          'age': _ageController.text,
          'height': _heightController.text,
          'weight': _weightController.text,
          'race': _raceController.text,
          'icNumber': _icNumberController.text,
          'hpNumber': _hpNumberController.text,
          'maritalStatus': _maritalStatusController.text,
          'address': _addressController.text,
          'currentJob': _currentJobController.text,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Donation Form Updated', style: TextStyle(color: Colors.green)),
            backgroundColor: Colors.white,
          ),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating donation form: $e', style: TextStyle(color: Colors.red)),
            backgroundColor: Colors.white,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        centerTitle: true,
        title: Text(
          "Edit Donation Form",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _ageController,
                decoration: InputDecoration(labelText: 'Age'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the age';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _heightController,
                decoration: InputDecoration(labelText: 'Height'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the height';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _weightController,
                decoration: InputDecoration(labelText: 'Weight'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the weight';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _raceController,
                decoration: InputDecoration(labelText: 'Race'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the race';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _icNumberController,
                decoration: InputDecoration(labelText: 'IC Number'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the IC number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _hpNumberController,
                decoration: InputDecoration(labelText: 'HP Number'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the HP number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _maritalStatusController,
                decoration: InputDecoration(labelText: 'Marital Status'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the marital status';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(labelText: 'Address'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the address';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _currentJobController,
                decoration: InputDecoration(labelText: 'Current Job'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the current job';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Container(
                height: 45,
                width: MediaQuery.of(context).size.width/2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.red
                ),
                child: TextButton(
                  onPressed: _updateDonationForm,
                  child: Text('Update',style: TextStyle(
                    color: Colors.white,
                    fontSize: 18
                  ),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
