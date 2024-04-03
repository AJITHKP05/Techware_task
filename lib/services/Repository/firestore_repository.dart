import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task/model/product.dart';

class FireStoreRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> getStreamData() {
    return _firestore.collection('product').snapshots();
  }

 Future addProduct(Product data)async {
    return await _firestore.collection('product').add(data.toJson());
  }
}
