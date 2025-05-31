import 'package:ecommerce/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  final String phoneNumber;
  final String uid;

  const ProfilePage({
    super.key,
    required this.phoneNumber,
    required this.uid,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _pincodeController = TextEditingController();

  bool isButtonEnabled = false;

  void _checkFieldsFilled() {
    setState(() {
      isButtonEnabled = _nameController.text.isNotEmpty &&
          _emailController.text.isNotEmpty &&
          _addressController.text.isNotEmpty &&
          _cityController.text.isNotEmpty &&
          _stateController.text.isNotEmpty &&
          _pincodeController.text.isNotEmpty;
    });
  }

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_checkFieldsFilled);
    _emailController.addListener(_checkFieldsFilled);
    _addressController.addListener(_checkFieldsFilled);
    _cityController.addListener(_checkFieldsFilled);
    _stateController.addListener(_checkFieldsFilled);
    _pincodeController.addListener(_checkFieldsFilled);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pincodeController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    final user = UserModel(
      uid: widget.uid,
      phoneNumber: widget.phoneNumber,
      email: _emailController.text.trim(),
      name: _nameController.text.trim(),
      address: _addressController.text.trim(),
      city: _cityController.text.trim(),
      state: _stateController.text.trim(),
      pincode: _pincodeController.text.trim(),
    );

    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.uid)
        .set(user.toMap());

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully')),
    );

    // TODO: Redirect to next screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(26.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // 👤 Circular profile image (dummy)
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey,
                  child: const Icon(Icons.person, size: 50, color: Colors.white),
                ),
              ),
              const SizedBox(height: 24),

              // 📱 Phone number with "Verified"
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: widget.phoneNumber,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        border: OutlineInputBorder(),
                      ),
                      enabled: false,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "Verified",
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 📧 Email
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // 👤 Name
              TextFormField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // 🏠 Address
              TextFormField(
                controller: _addressController,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // 🏙 City
              TextFormField(
                controller: _cityController,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'City',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // 🗺 State
              TextFormField(
                controller: _stateController,
                decoration: const InputDecoration(
                  labelText: 'State',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // 🔢 Pincode
              TextFormField(
                controller: _pincodeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Pincode',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),

              // ✅ Update Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: isButtonEnabled ? _saveProfile : null,
                  child: const Text('Update Profile'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
