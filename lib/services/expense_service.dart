import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/expense.dart';

class ExpenseService {
  final CollectionReference _expenses = FirebaseFirestore.instance.collection('expenses');

  // Create
  Future<void> addExpense(Expense expense) {
    return _expenses.add(expense.toMap());
  }

  // Read & Filter (Returns a real-time stream)
  Stream<List<Expense>> getExpenses({String? filterCategory}) {
    Query query = _expenses.orderBy('date', descending: true);
    
    if (filterCategory != null && filterCategory != 'All') {
      query = query.where('category', isEqualTo: filterCategory);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Expense.fromFirestore(doc)).toList();
    });
  }

  // Update
  Future<void> updateExpense(Expense expense) {
    return _expenses.doc(expense.id).update(expense.toMap());
  }

  // Delete
  Future<void> deleteExpense(String id) {
    return _expenses.doc(id).delete();
  }
}