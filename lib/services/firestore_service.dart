import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:to_do_app/models/item_todo.dart';

class FirestoreService {
  static final _firestore = FirebaseFirestore.instance;
  static final collection = 'todo_items';

  FirestoreService._privateConstructor();
  static final FirestoreService instance = FirestoreService._privateConstructor();

  // Adiciona um novo item no Firestore
  Future<DocumentReference> insert(Map<String, dynamic> row) async {
    row['createdDate'] = Timestamp.fromDate(DateTime.now());
    DocumentReference ref = await _firestore.collection(collection).add(row);
    print('Inserted item with id: ${ref.id} and data: $row');
    return ref;
  }

  // Consulta todos os documentos da coleção
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    QuerySnapshot snapshot = await _firestore.collection(collection).orderBy('createdDate', descending: true).get();
    List<Map<String, dynamic>> items = snapshot.docs.map((doc) => {
      'id': doc.id,
      ...doc.data() as Map<String, dynamic>
    }).toList();
    print('Fetched ${items.length} items from Firestore.');
    return items;
  }

  // Método para retornar um stream de itens do todo
  Stream<List<TodoItem>> todoItemsStream() {
    return _firestore.collection(collection).orderBy('createdDate', descending: true).snapshots().map((snapshot) {
        return snapshot.docs.map((doc) => TodoItem.fromMap({
            'id': doc.id,
            ...doc.data() as Map<String, dynamic>
        })).toList();
    });
  }

  // Atualiza um documento no Firestore
  Future<void> update(Map<String, dynamic> row) async {
    if (row['id'] == null) {
      print('Erro: id é null');
      return;
    }
    String id = row['id'];
    row.remove('id'); // Removendo o ID para evitar sobrescrever no Firestore
    print('Updating item with ID $id with data: $row');
    await _firestore.collection(collection).doc(id).update(row);
  }

  // Exclui um documento do Firestore
  Future<void> delete(String id) async {
    print('Deleting item with id: $id');
    await _firestore.collection(collection).doc(id).delete();
  }
}
