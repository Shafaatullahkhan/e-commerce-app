import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future addUser(String userId, Map<String, dynamic> UserInfoMap) {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .set(UserInfoMap);
  }

  //  Future addProduct(String categoryname, Map<String, dynamic> UserInfoMap) {
  //   return FirebaseFirestore.instance
  //       .collection("users")
  //       .doc(categoryname)
  //       .set(UserInfoMap);
  // }

  Future<Future<DocumentReference<Map<String, dynamic>>>> addProduct(
      String categoryName, Map<String, dynamic> productMap) async {
    return FirebaseFirestore.instance
        .collection("products")
        .doc(categoryName)
        .collection("items")
        .add(productMap);
  }

  Future<Stream<QuerySnapshot>> getProducts(String category) async {
    return FirebaseFirestore.instance
        .collection("products")
        .doc(category)
        .collection("items")
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> getOrders(String email) async {
    return FirebaseFirestore.instance
        .collection("Orders")
        .where("Email", isEqualTo: email)
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> allOrders() async {
    return FirebaseFirestore.instance
        .collection("Orders")
        .where("Status", isEqualTo: "On the way")
        .snapshots();
  }

  Future orderDetails(Map<String, dynamic> UserInfoMap) {
    return FirebaseFirestore.instance.collection("Orders").add(UserInfoMap);
  }

  updateStatus(String id) async {
    return await FirebaseFirestore.instance
        .collection("Orders")
        .doc(id)
        .update({"Status": "Delivered"});
  }


  Future<void> saveAdminToken(String token) async {
  await FirebaseFirestore.instance
      .collection('Admin')
      .doc('mainAdmin') // fixed admin doc
      .set({
    'fcmToken': token,
  }, SetOptions(merge: true));
}


Future<String> getAdminToken() async {
  final doc = await FirebaseFirestore.instance
      .collection('Admin')
      .doc('mainAdmin')
      .get();

  return doc.exists ? doc['fcmToken'] : '';
}


}
