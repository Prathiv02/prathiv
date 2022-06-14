import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ApiService {
  static final CollectionReference<Map<String, dynamic>> loginDetails =
  FirebaseFirestore.instance.collection('loginDetails');

  Future createUser({required String id,required Map<String,dynamic> data}) async {
   await loginDetails.doc(id).set(data).then((value) {
    });
  }




  Future<String> uploadImagesToDataBase(
      {required String fileName, required Uint8List image}) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child('qrImages/$fileName');
    UploadTask uploadTask = ref.putData(image);
    String imageUrl = await uploadTask.then((res) async {
      return await res.ref.getDownloadURL();
    });
    return imageUrl;
  }
}
