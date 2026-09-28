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

  // Maps the Dart object into a JSON format Firestore can understand
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'amount': amount,
      'category': category,
      'date': Timestamp.fromDate(date),
    };
  }
}