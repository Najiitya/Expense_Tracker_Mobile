import 'package:cloud_firestore/cloud_firestore.dart';

class Expense {
  String id;
  String title;
  double amount;
  String category;
  DateTime date;

  Expense({
    required this.id, 
    required this.title, 
    required this.amount, 
    required this.category, 
    required this.date
  });

  // Outgoing: Converts Dart object to Firestore Map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'amount': amount,
      'category': category,
      'date': Timestamp.fromDate(date),
    };
  }

  // Incoming: Converts Firestore Map to Dart object
  factory Expense.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Expense(
      id: doc.id,
      title: data['title'] ?? '',
      amount: (data['amount'] ?? 0.0).toDouble(),
      category: data['category'] ?? 'Other',
      date: (data['date'] as Timestamp).toDate(),
    );
  }
}