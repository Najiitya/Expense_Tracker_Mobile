import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/expense.dart';

class ExpenseService {
  // This targets the specific 'expenses' collection in your cloud database
  final CollectionReference _expenses = FirebaseFirestore.instance.collection('expenses');

  // Pushes a new expense document to the cloud
  Future<void> addExpense(Expense expense) {
    return _expenses.add(expense.toMap());
  }
}