import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pizzashop/Services/database.dart';
import 'package:pizzashop/Widgets/widget_supported.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController detailController = TextEditingController();

  //If you have a Storage
  // This is a Best Method to Store Image in Storage
  // Also in the Fire Store database
  //   // For Image Picker Fuction

  // final ImagePicker _picker = ImagePicker();
  // File? selectedImage;

  // // Fuction to Get Image From Gallery
  // Future getImage() async {
  //   var image = await _picker.pickImage(source: ImageSource.gallery);
  //   selectedImage = File(image!.path);
  //   setState(() {});
  // }

  // // Uploaded Image to Firebase Storage
  // // Fuction to Uplaoded  Image to Firebase Storage

  // uploadItem() async {
  //   if (selectedImage != null && nameController.text != "") {
  //     String addId = randomAlphaNumeric(10);
  //     Reference firebaseStorageRef =
  //         FirebaseStorage.instance.ref().child("blogImage").child(addId);

  //     final UploadTask task = firebaseStorageRef.putFile(selectedImage!);
  //     var downloadUrl = await (await task).ref.getDownloadURL();

  //     // Map For FireStore Database Collection
  //     Map<String, dynamic> addProduct = {
  //       "Name": nameController.text,
  //       "Image": downloadUrl,
  //     };
  //     await DatabaseMethods().addProduct(value!, addProduct).then((value) {
  //       selectedImage = null;
  //       nameController.text = "";
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //           backgroundColor: Colors.green,
  //           content: Text(
  //             "Product Has been Uploded!!",
  //             style: AppWidget.SimpleTextFeildStyle(),
  //           )));
  //     });
  //   }
  // }

  //This Function when you have not the Storage Only Firebase Firestore

  final ImagePicker _picker = ImagePicker();
  File? selectedImage;
  String? selectedCategory;

  // ---------------- Pick Image from Gallery ----------------
  Future<void> getImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
      });
    }
  }

  // ---------------- Encode Image to Base64 ----------------
  String encodeImage(File imageFile) {
    final bytes = imageFile.readAsBytesSync();
    return base64Encode(bytes);
  }

  // ---------------- Upload Product to Firestore ----------------
  uploadItem() async {
    if (selectedImage == null ||
        nameController.text.isEmpty ||
        selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    try {
      // Encode image
      String base64Image = encodeImage(selectedImage!);

      // Product Map
      Map<String, dynamic> addProduct = {
        "Name": nameController.text,
        "ImageBase64": base64Image,
        "Category": selectedCategory,
        "CreatedAt": Timestamp.now(),
        "Price": priceController.text,
        "Detail": detailController.text,
      };

      await DatabaseMethods().addProduct(selectedCategory!, addProduct);

      // Clear fields
      setState(() {
        selectedImage = null;
        nameController.clear();
        selectedCategory = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            "Product Has been Uploaded!!",
            style: AppWidget.SimpleTextFeildStyle(),
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text("Error: $e"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F6FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: const BackButton(color: Colors.black),
        centerTitle: true,
        title: const Text(
          "Add Product",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: width * 0.06),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: height * 0.02),

            // ---------------- Upload Image ----------------
            const Text(
              "Upload the Product Image",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),

            SizedBox(height: height * 0.04),

            selectedImage == null
                ? GestureDetector(
                    onTap: getImage,
                    child: Center(
                      child: Container(
                        height: width * 0.35,
                        width: width * 0.35,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.black, width: 1.2),
                        ),
                        child: const Icon(Icons.camera_alt_outlined, size: 32),
                      ),
                    ),
                  )
                : Center(
                    child: Container(
                      height: width * 0.35,
                      width: width * 0.35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.black, width: 1.2),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.file(selectedImage!, fit: BoxFit.cover),
                      ),
                    ),
                  ),

            SizedBox(height: height * 0.04),

            // ---------------- Product Name ----------------
            const Text(
              "Product Name",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),

            SizedBox(height: height * 0.01),

            Container(
              height: height * 0.06,
              decoration: BoxDecoration(
                color: const Color(0xFFECEEF5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  hintText: "Enter product name",
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
            ),

            SizedBox(height: height * 0.03),

           // ---------------- Product Price ----------------
const Text(
  "Product Price",
  style: TextStyle(fontSize: 16, color: Colors.grey),
),

SizedBox(height: height * 0.01),

Container(
  height: height * 0.06,
  decoration: BoxDecoration(
    color: const Color(0xFFECEEF5),
    borderRadius: BorderRadius.circular(12),
  ),
  child: TextField(
    controller: priceController,
    
    keyboardType: TextInputType.number, // Numeric keyboard
    inputFormatters: [

      FilteringTextInputFormatter.digitsOnly, // Allow only 0-9
    ],
    decoration: const InputDecoration(
      hintText: "Enter product price",
      border: InputBorder.none,
      contentPadding:
          EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
  ),
),

SizedBox(height: height * 0.03),

         // ---------------- Product Details ----------------
const Text(
  "Product Details",
  style: TextStyle(fontSize: 16, color: Colors.grey),
),

SizedBox(height: height * 0.01),

Container(
  decoration: BoxDecoration(
    color: const Color(0xFFECEEF5),
    borderRadius: BorderRadius.circular(12),
  ),
  child: TextField(
    controller: detailController,
    maxLines: 6, // ✅ 6 lines visible
    decoration: const InputDecoration(
      hintText: "Enter product Details",
      border: InputBorder.none,
      contentPadding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
    ),
  ),
),


            SizedBox(height: height * 0.03),

            // ---------------- Category ----------------
            const Text(
              "Product Category",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),

            SizedBox(height: height * 0.01),

            Container(
              height: height * 0.06,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFECEEF5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  hint: const Text("Select Category"),
                  value: selectedCategory,
                  isExpanded: true,
                  items: const [
                    DropdownMenuItem(
                        value: "Smart Phone", child: Text("Smart Phone")),
                    DropdownMenuItem(
                        value: "Smart Watch", child: Text("Smart Watch")),
                    DropdownMenuItem(value: "Laptop", child: Text("Laptop")),
                    DropdownMenuItem(
                        value: "Headphone", child: Text("Headphone")),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value;
                    });
                  },
                ),
              ),
            ),

            SizedBox(height: height * 0.05),

            // ---------------- Add Button ----------------
            Center(
              child: SizedBox(
                width: width,
                height: height * 0.055,
                child: ElevatedButton(
                  onPressed: uploadItem,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text(
                    "Add Product",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16),
                  ),
                ),
              ),
            ),

            SizedBox(height: height * 0.04),
          ],
        ),
      ),
    );
  }
}
