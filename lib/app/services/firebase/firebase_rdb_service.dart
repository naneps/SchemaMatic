import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

class FirebaseRDbService<T> extends GetxService {
  // Mengubah ke protected agar bisa diakses oleh subclass
  late final DatabaseReference dbRef;
  final String collectionPath;

  FirebaseRDbService(this.collectionPath);

// Fungsi untuk membuat atau menambahkan data
  Future<void> create(T data) async {
    try {
      await dbRef.child(collectionPath).push().set(data);
      print('Data successfully created');
    } catch (e) {
      throw Exception('Failed to create data: $e');
    }
  }

  // Fungsi untuk menghapus data
  Future<void> delete(String id) async {
    try {
      await dbRef.child(collectionPath).child(id).remove();
      print('Data successfully deleted');
    } catch (e) {
      throw Exception('Failed to delete data: $e');
    }
  }

  @override
  void onInit() {
    super.onInit();
    final firebaseApp = Firebase.app();
    dbRef = FirebaseDatabase.instanceFor(
            app: firebaseApp,
            databaseURL: "https://schematic-5cd75-default-rtdb.firebaseio.com/")
        .ref();
  }

  // Fungsi untuk mendapatkan data berdasarkan ID
  Future<T?> read(String id) async {
    try {
      DataSnapshot snapshot = await dbRef.child(collectionPath).child(id).get();
      if (snapshot.value != null) {
        return snapshot.value as T;
      }
      return null;
    } catch (e) {
      throw Exception('Failed to read data: $e');
    }
  }

  // Fungsi untuk mendapatkan semua data
  Future<List<T>> readAll() async {
    List<T> itemList = [];
    try {
      DataSnapshot snapshot = await dbRef.child(collectionPath).get();
      if (snapshot.value != null) {
        Map<dynamic, dynamic> values = snapshot.value as Map<dynamic, dynamic>;
        values.forEach((key, value) {
          itemList.add(value as T);
        });
      }
      return itemList;
    } catch (e) {
      throw Exception('Failed to read all data: $e');
    }
  }

  // Fungsi untuk update data
  Future<void> update(String id, Map<String, dynamic> updates) async {
    try {
      await dbRef.child(collectionPath).child(id).update(updates);
      print('Data successfully updated');
    } catch (e) {
      throw Exception('Failed to update data: $e');
    }
  }
}
