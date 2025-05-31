// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'dart:developer';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/admin/blocs/upload_picture_bloc/upload_picture_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:image/image.dart' as img;

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _discountController = TextEditingController();
  String? _uploadedImageUrl; // Store the uploaded image URL
  bool _isAvailable = false;
  String? _selectedCategory; // Add this line
  final List<String> _selectedSizes = [];

  // List of categories
  final List<String> _categories = [
    'Dresses',
    'Tops',
    'Jeans',
    'T-Shirt',
    'Co-ord Set',
    'Shirt',
    'Skirt'
  ];

  final Map<String, List<String>> categorySizes = {
    'Tops': ['M', 'L', 'XL', 'XXL','3XL','4XL','5XL'],
    'T-Shirt': ['M', 'L', 'XL', 'XXL','3XL','4XL','5XL'],
    'Shirt': ['M', 'L', 'XL', 'XXL'],
    'Dresses': ['M', 'L', 'XL','XXL','3XL','4XL','5XL'],
    'Co-ord Set': ['M', 'L', 'XL','XXL'],
    'Jeans': ['28','30', '32', '34', '36', '38', '40', '42','44'],
    'Skirt': ['28', '30', '32', '34', '36'],
  };

  Future<void> _addProduct() async {
    final productCollection = FirebaseFirestore.instance.collection('products');

    // Generate a new document reference
    final docRef = productCollection.doc();

    // Set discount to 0 if the field is empty
    final discount = _discountController.text.isNotEmpty
        ? int.tryParse(_discountController.text) ?? 0
        : 0;

    final product = {
      'pId': docRef.id, // Add the generated document ID
      'name': _nameController.text,
      'description': _descriptionController.text,
      'category': _selectedCategory,
      'price': int.tryParse(_priceController.text) ?? 0,
      'discount': discount,
      // 'image': _imageUrlController.text,
      'image': _uploadedImageUrl,
      'isAvailable': _isAvailable,
      'sizes': _selectedSizes, // 🔥 NEW FIELD
      'dateAdded': FieldValue.serverTimestamp(),
    };

    try {
      await docRef.set(product);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product added successfully!')));
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to add product: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final allFieldsFilled = _nameController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty &&
        _selectedCategory != null &&
        _priceController.text.isNotEmpty &&
        _uploadedImageUrl != null &&
        _selectedSizes.isNotEmpty
        ; // Ensure image URL is set

    return BlocListener<UploadPictureBloc, UploadPictureState>(
      listener: (context, state) {
        if (state is UploadPictureLoading) {
          log("EOrreev jsf");
        } else if (state is UploadPictureSuccess) {
          setState(() {
            _uploadedImageUrl = state.url; // Set the uploaded image URL
          });
          log("Image uploaded successfully: ${state.url}");
        } else {
          // log("addgg");
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Add Product')),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(
                  height: 10,
                ),
                // IMAGE UPLOAD
                InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () async {
                    final ImagePicker picker = ImagePicker();
                    final XFile? image = await picker.pickImage(
                        source: ImageSource.gallery,
                        maxHeight: 1000,
                        maxWidth: 1000);
                    if (image != null && context.mounted) {
                      // Read image file as bytes
                      final bytes = await image.readAsBytes();

                      // Decode the image using the 'image' package
                      img.Image? decodedImage = img.decodeImage(bytes);

                      if (decodedImage != null) {
                        int width = 800;
                        // int height = ((decodedImage.height / decodedImage.width) * width).toInt();
                        int height = 1060;
                        // Resize the image to 800x800 (or any preferred size)
                        final resizedImage = img.copyResize(decodedImage,
                            width: width,
                            height: height,
                            interpolation: img.Interpolation.linear);

                        // Convert the resized image back to bytes (in JPG format)
                        final resizedBytesList =
                            img.encodeJpg(resizedImage, quality: 95);

                        // Convert List<int> to Uint8List
                        final Uint8List resizedBytes =
                            Uint8List.fromList(resizedBytesList);

                        // Upload the resized image
                        context.read<UploadPictureBloc>().add(UploadPicture(
                            resizedBytes, path.basename(image.path)));
                      }
                    }
                  },
                  child: Ink(
                      height: 400,
                      width: 400,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                      ),
                      child: _uploadedImageUrl !=
                              null // Check if an image has been uploaded
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: CachedNetworkImage(
                                imageUrl: _uploadedImageUrl!,
                                height: 400,
                                width: 400,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator(),
                                ),
                                errorWidget: (context, url, error) =>
                                    const Center(
                                  child: Text(
                                    "Failed to load image",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ),
                            )
                          : const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  CupertinoIcons.cloud_upload,
                                  size: 60,
                                ),
                                Text(
                                  "Upload an image",
                                  style: TextStyle(color: Colors.grey),
                                )
                              ],
                            )),
                ),
                const SizedBox(
                  height: 10,
                ),

                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(
                  height: 10,
                ),
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  items: _categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  },
                  decoration: const InputDecoration(labelText: 'Category'),
                ),
                if (_selectedCategory != null &&
                    categorySizes.containsKey(_selectedCategory)) ...[
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    children: categorySizes[_selectedCategory!]!.map((size) {
                      final isSelected = _selectedSizes.contains(size);
                      return FilterChip(
                        label: Text(size),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedSizes.add(size);
                            } else {
                              _selectedSizes.remove(size);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                ],
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: _priceController,
                  decoration: const InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: _discountController,
                  decoration: const InputDecoration(labelText: 'Discount'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(
                  height: 10,
                ),
                const SizedBox(
                  height: 10,
                ),
                SwitchListTile(
                  title: const Text('Available'),
                  value: _isAvailable,
                  onChanged: (value) {
                    setState(() {
                      _isAvailable = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: allFieldsFilled
                      ? _addProduct
                      : null, // Disable button if fields are not filled
                  child: const Text('Add Product'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
