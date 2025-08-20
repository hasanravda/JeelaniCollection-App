// import 'package:ecommerce/models/user_model.dart';
// import 'package:ecommerce/screens/login/screens/login_redirect_widget.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class ProfileUpdatePage extends StatefulWidget {
//   final String phoneNumber;
//   final String uid;

//   const ProfileUpdatePage({
//     super.key,
//     required this.phoneNumber,
//     required this.uid,
//   });

//   @override
//   State<ProfileUpdatePage> createState() => _ProfileUpdatePageState();
// }

// class _ProfileUpdatePageState extends State<ProfileUpdatePage> {
//   bool _isLoading = true;
//   @override
//   void initState() {
//     super.initState();

//     final currentUser = FirebaseAuth.instance.currentUser;

//     if (currentUser == null) {
//       // User is not logged in — redirect to login screen
//         LoginRedirectWidget.showLoginSheet(context);
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         Navigator.of(context).popUntil((route) => route.isFirst);
//         // Optionally: show login bottom sheet again here
//       });
//     } else {
//       _nameController.addListener(_checkFieldsFilled);
//       _emailController.addListener(_checkFieldsFilled);
//       _addressController.addListener(_checkFieldsFilled);
//       _cityController.addListener(_checkFieldsFilled);
//       _stateController.addListener(_checkFieldsFilled);
//       _pincodeController.addListener(_checkFieldsFilled);
//       _loadUserData(); // 🔥 Load Firestore data into the form
//     }
//   }

//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _addressController = TextEditingController();
//   final _cityController = TextEditingController();
//   final _stateController = TextEditingController();
//   final _pincodeController = TextEditingController();

//   bool isButtonEnabled = false;

  

//   Future<void> _loadUserData() async {
//     final doc = await FirebaseFirestore.instance
//         .collection('users')
//         .doc(widget.uid)
//         .get();

//     if (doc.exists) {
//       final data = doc.data()!;
//       _nameController.text = data['name'] ?? '';
//       _emailController.text = data['email'] ?? '';
//       _addressController.text = data['address'] ?? '';
//       _cityController.text = data['city'] ?? '';
//       _stateController.text = data['state'] ?? '';
//       _pincodeController.text = data['pincode'] ?? '';
//     }

//     setState(() {
//       _isLoading = false;
//       _checkFieldsFilled();
//     });
//   }

//   void _checkFieldsFilled() {
//     setState(() {
//       isButtonEnabled = _nameController.text.isNotEmpty &&
//           _emailController.text.isNotEmpty &&
//           _addressController.text.isNotEmpty &&
//           _cityController.text.isNotEmpty &&
//           _stateController.text.isNotEmpty &&
//           _pincodeController.text.isNotEmpty;
//     });
//   }


//   @override
//   void dispose() {
//     _nameController.dispose();
//     _emailController.dispose();
//     _addressController.dispose();
//     _cityController.dispose();
//     _stateController.dispose();
//     _pincodeController.dispose();
//     super.dispose();
//   }

//   Future<void> _saveProfile() async {
//     final user = UserModel(
//       uid: widget.uid,
//       phoneNumber: widget.phoneNumber,
//       email: _emailController.text.trim(),
//       name: _nameController.text.trim(),
//       address: _addressController.text.trim(),
//       city: _cityController.text.trim(),
//       state: _stateController.text.trim(),
//       pincode: _pincodeController.text.trim(),
//     );

//     await FirebaseFirestore.instance
//         .collection('users')
//         .doc(widget.uid)
//         .set(user.toMap());

//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Profile updated successfully')),
//     );

//     Navigator.of(context).popUntil((route) => route.isFirst);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Profile')),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : Padding(
//               padding: const EdgeInsets.all(26.0),
//               child: Form(
//                 key: _formKey,
//                 child: ListView(
//                   children: [
//                     // 👤 Circular profile image (dummy)
//                     Center(
//                       child: CircleAvatar(
//                         radius: 50,
//                         backgroundColor: Colors.grey,
//                         child: const Icon(Icons.person,
//                             size: 50, color: Colors.white),
//                       ),
//                     ),
//                     const SizedBox(height: 24),

//                     // 📱 Phone number with "Verified"
//                     Row(
//                       children: [
//                         Expanded(
//                           child: TextFormField(
//                             initialValue: widget.phoneNumber,
//                             decoration: const InputDecoration(
//                               labelText: 'Phone Number',
//                               border: OutlineInputBorder(),
//                             ),
//                             enabled: false,
//                           ),
//                         ),
//                         const SizedBox(width: 10),
//                         const Text(
//                           "Verified",
//                           style: TextStyle(
//                             color: Colors.green,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 16),

//                     // 📧 Email
//                     TextFormField(
//                       controller: _emailController,
//                       keyboardType: TextInputType.emailAddress,
//                       decoration: const InputDecoration(
//                         labelText: 'Email',
//                         border: OutlineInputBorder(),
//                       ),
//                     ),
//                     const SizedBox(height: 16),

//                     // 👤 Name
//                     TextFormField(
//                       controller: _nameController,
//                       textCapitalization: TextCapitalization.words,
//                       decoration: const InputDecoration(
//                         labelText: 'Name',
//                         border: OutlineInputBorder(),
//                       ),
//                     ),
//                     const SizedBox(height: 16),

//                     // 🏠 Address
//                     TextFormField(
//                       controller: _addressController,
//                       textCapitalization: TextCapitalization.sentences,
//                       decoration: const InputDecoration(
//                         labelText: 'Address',
//                         border: OutlineInputBorder(),
//                       ),
//                     ),
//                     const SizedBox(height: 16),

//                     // 🏙 City
//                     TextFormField(
//                       controller: _cityController,
//                       textCapitalization: TextCapitalization.sentences,
//                       decoration: const InputDecoration(
//                         labelText: 'City',
//                         border: OutlineInputBorder(),
//                       ),
//                     ),
//                     const SizedBox(height: 16),

//                     // 🗺 State
//                     TextFormField(
//                       controller: _stateController,
//                       decoration: const InputDecoration(
//                         labelText: 'State',
//                         border: OutlineInputBorder(),
//                       ),
//                     ),
//                     const SizedBox(height: 16),

//                     // 🔢 Pincode
//                     TextFormField(
//                       controller: _pincodeController,
//                       keyboardType: TextInputType.number,
//                       decoration: const InputDecoration(
//                         labelText: 'Pincode',
//                         border: OutlineInputBorder(),
//                       ),
//                     ),
//                     const SizedBox(height: 24),

//                     // ✅ Update Button
//                     SizedBox(
//                       width: double.infinity,
//                       height: 50,
//                       child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(8)),
//                         ),
//                         onPressed: isButtonEnabled ? _saveProfile : null,
//                         child: const Text('Update Profile'),
//                       ),
//                     ),

//                     const SizedBox(height: 16),
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         padding: const EdgeInsets.symmetric(vertical: 16),
//                         backgroundColor: Colors.red,
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8)),
//                       ),
//                       child: const Text('Logout'),
//                       onPressed: () {
//                         FirebaseAuth.instance.signOut();
//                         Navigator.of(context)
//                             .popUntil((route) => route.isFirst);
//                         // Navigator.pop(
//                         //     context); // Pop to the root of the navigation stack
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }
// }
import 'package:ecommerce/models/user_model.dart';
import 'package:ecommerce/screens/login/screens/login_redirect_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileUpdatePage extends StatefulWidget {
  final String phoneNumber;
  final String uid;

  const ProfileUpdatePage({
    super.key,
    required this.phoneNumber,
    required this.uid,
  });

  @override
  State<ProfileUpdatePage> createState() => _ProfileUpdatePageState();
}

class _ProfileUpdatePageState extends State<ProfileUpdatePage> {
  bool _isLoading = true;
  bool _isUpdating = false;
  
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _pincodeController = TextEditingController();

  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _checkAuthAndLoadData();
  }

  void _initializeControllers() {
    _nameController.addListener(_checkFieldsFilled);
    _emailController.addListener(_checkFieldsFilled);
    _addressController.addListener(_checkFieldsFilled);
    _cityController.addListener(_checkFieldsFilled);
    _stateController.addListener(_checkFieldsFilled);
    _pincodeController.addListener(_checkFieldsFilled);
  }

  Future<void> _checkAuthAndLoadData() async {
    try {
      // Wait for Firebase Auth to initialize
      await Future.delayed(const Duration(milliseconds: 100));
      
      final currentUser = FirebaseAuth.instance.currentUser;
      
      if (currentUser == null) {
        // User is not logged in — redirect to login screen
        if (mounted) {
          _showLoginAndRedirect();
        }
        return;
      }
      
      // Verify the UID matches
      if (currentUser.uid != widget.uid) {
        print('UID mismatch: ${currentUser.uid} vs ${widget.uid}');
        if (mounted) {
          _showLoginAndRedirect();
        }
        return;
      }
      
      // Load user data
      await _loadUserData();
      
    } catch (e) {
      print('Error checking auth: $e');
      if (mounted) {
        _showLoginAndRedirect();
      }
    }
  }

  void _showLoginAndRedirect() {
    LoginRedirectWidget.showLoginSheet(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    });
  }

  Future<void> _loadUserData() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      if (doc.exists) {
        final data = doc.data()!;
        if (mounted) {
          _nameController.text = data['name'] ?? '';
          _emailController.text = data['email'] ?? '';
          _addressController.text = data['address'] ?? '';
          _cityController.text = data['city'] ?? '';
          _stateController.text = data['state'] ?? '';
          _pincodeController.text = data['pincode'] ?? '';
        }
      }

      if (mounted) {
        setState(() {
          _isLoading = false;
          _checkFieldsFilled();
        });
      }
    } catch (e) {
      print('Error loading user data: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading profile: $e')),
        );
      }
    }
  }

  void _checkFieldsFilled() {
    if (mounted) {
      setState(() {
        isButtonEnabled = _nameController.text.trim().isNotEmpty &&
            _emailController.text.trim().isNotEmpty &&
            _addressController.text.trim().isNotEmpty &&
            _cityController.text.trim().isNotEmpty &&
            _stateController.text.trim().isNotEmpty &&
            _pincodeController.text.trim().isNotEmpty;
      });
    }
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
    if (!_formKey.currentState!.validate()) return;
    
    setState(() {
      _isUpdating = true;
    });

    try {
      // Double check authentication before saving
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null || currentUser.uid != widget.uid) {
        throw Exception('Authentication failed');
      }

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
          .set(user.toMap(), SetOptions(merge: true));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      print('Error saving profile: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating profile: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUpdating = false;
        });
      }
    }
  }

  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      if (mounted) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } catch (e) {
      print('Error logging out: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error logging out: $e')),
        );
      }
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  String? _validatePincode(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Pincode is required';
    }
    if (value.trim().length != 6) {
      return 'Pincode must be 6 digits';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26,vertical: 12),
              child: ListView(
                  children: [
                    // 👤 Circular profile image (dummy)
                    Center(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            
                            radius: 60,
                            backgroundColor: Colors.grey.shade300,
                            // online image
                            child: Image(image: NetworkImage(
                              'https://avatar.iran.liara.run/public/boy',
                            )) ,
                          ),
                          // Placeholder for profile image
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.edit,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
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
                              prefixIcon: Icon(Icons.phone),
                            ),
                            enabled: false,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.verified, 
                                   color: Colors.green.shade700, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                "Verified",
                                style: TextStyle(
                                  color: Colors.green.shade700,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // 📧 Email
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: _validateEmail,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 👤 Name
                    TextFormField(
                      controller: _nameController,
                      textCapitalization: TextCapitalization.words,
                      validator: (value) => _validateRequired(value, 'Name'),
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 🏠 Address
                    TextFormField(
                      controller: _addressController,
                      textCapitalization: TextCapitalization.sentences,
                      validator: (value) => _validateRequired(value, 'Address'),
                      decoration: const InputDecoration(
                        labelText: 'Address',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.home),
                        alignLabelWithHint: true,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 🏙 City
                    TextFormField(
                      controller: _cityController,
                      textCapitalization: TextCapitalization.words,
                      validator: (value) => _validateRequired(value, 'City'),
                      decoration: const InputDecoration(
                        labelText: 'City',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.location_city),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 🗺 State
                    TextFormField(
                      controller: _stateController,
                      textCapitalization: TextCapitalization.words,
                      validator: (value) => _validateRequired(value, 'State'),
                      decoration: const InputDecoration(
                        labelText: 'State',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.map),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 🔢 Pincode
                    TextFormField(
                      controller: _pincodeController,
                      keyboardType: TextInputType.number,
                      validator: _validatePincode,
                      decoration: const InputDecoration(
                        labelText: 'Pincode',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.pin_drop),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ✅ Update Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: (isButtonEnabled && !_isUpdating) 
                            ? _saveProfile 
                            : null,
                        child: _isUpdating
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Update Profile',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 16),
                    
                    // 🔴 Logout Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _logout,
                        child: const Text(
                          'Logout',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
            ),
          ),
    );
  }
}