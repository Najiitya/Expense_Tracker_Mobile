import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../services/expense_service.dart';
import 'add_expense_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedFilter = 'All';
  final List<String> _filterOptions = ['All', 'Food', 'Transport', 'Utilities', 'Entertainment', 'Other'];

  double _calculateMonthlyTotal(List<Expense> expenses) {
    final now = DateTime.now();
    return expenses
        .where((e) => e.date.year == now.year && e.date.month == now.month)
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CyphLab Expenses'),
        actions: [
          DropdownButton<String>(
            value: _selectedFilter,
            icon: const Icon(Icons.filter_list, color: Colors.white),
            dropdownColor: Colors.blue,
            style: const TextStyle(color: Colors.white),
            underline: Container(),
            items: _filterOptions.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
            onChanged: (val) => setState(() => _selectedFilter = val!),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: StreamBuilder<List<Expense>>(
        stream: ExpenseService().getExpenses(filterCategory: _selectedFilter),
        builder: (context, snapshot) {
          // 1. Error State
          if (snapshot.hasError) return const Center(child: Text('Error loading data.'));
          
          // 2. Loading State
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final expenses = snapshot.data ?? [];
          final monthlyTotal = _calculateMonthlyTotal(expenses);

          return Column(
            children: [
              // Monthly Total Display
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                color: Colors.blue.withOpacity(0.1),
                child: Column(
                  children: [
                    const Text('This Month\'s Total', style: TextStyle(fontSize: 16)),
                    Text('\$${monthlyTotal.toStringAsFixed(2)}', style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              
              // 3. Empty State
              if (expenses.isEmpty)
                const Expanded(child: Center(child: Text('No expenses found.'))),
                
              // 4. Success State (List)
              if (expenses.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    itemCount: expenses.length,
                    itemBuilder: (context, index) {
                      final expense = expenses[index];
                      return Dismissible(
                        key: Key(expense.id),
                        direction: DismissDirection.endToStart,
                        background: Container(color: Colors.red, alignment: Alignment.centerRight, padding: const EdgeInsets.only(right: 20), child: const Icon(Icons.delete, color: Colors.white)),
                        onDismissed: (direction) => ExpenseService().deleteExpense(expense.id),
                        child: ListTile(
                          title: Text(expense.title),
                          subtitle: Text(expense.category),
                          trailing: Text('\$${expense.amount.toStringAsFixed(2)}'),
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AddExpenseScreen(existingExpense: expense))),
                        ),
                      );
                    },
                  ),
                ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddExpenseScreen())),
        child: const Icon(Icons.add),
      ),
    );
  }
}