import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gems_pay/model/expense_model.dart';

class FirestoreService {
  final String uid;

  FirestoreService(this.uid);

  final CollectionReference _expensesCollection =
      FirebaseFirestore.instance.collection('expenses');

  Future<void> addExpense(
      String description, String category, double amount, DateTime date) async {
    try {
      await _expensesCollection.add({
        'userId': uid,
        'category': category,
        'description': description,
        'amount': amount,
        'date': date,
      });
    } catch (e) {
      print("Error adding expense: $e");
      rethrow;
    }
  }

  Future<void> editExpense(
      String docId, Map<String, dynamic> updatedData) async {
    try {
      await _expensesCollection.doc(docId).update(updatedData);
    } catch (e) {
      print("Error editing expense: $e");
      rethrow;
    }
  }

  Future<void> deleteExpense(String docId) async {
    try {
      await _expensesCollection.doc(docId).delete();
    } catch (e) {
      print("Error deleting expense: $e");
      rethrow;
    }
  }

  Stream<List<Expense>> getExpenses() {
    return _expensesCollection.where('userId', isEqualTo: uid).snapshots().map(
        (snapshot) =>
            snapshot.docs.map((doc) => Expense.fromFirestore(doc)).toList());
  }
}
