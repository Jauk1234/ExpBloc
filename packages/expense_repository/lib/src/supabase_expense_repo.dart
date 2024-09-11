import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../expense_repository.dart';

class SupabaseExpenseRepo implements ExpenseRepository {
  final logger = Logger();
  final categoryTable = Supabase.instance.client.from('categories');

  final expenseTable = Supabase.instance.client.from('expenses');

  @override
  Future<void> createCategory(Category category) async {
    try {
      await categoryTable.insert(category.toEntity().toDocument());
    } catch (e) {
      logger.e(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<Category>> getCategory() async {
    try {
      return await categoryTable.select().then((value) => value
          .map((e) => Category.fromEntity(CategoryEntity.fromDocument((e))))
          .toList());
    } catch (e) {
      logger.e(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> createExpense(Expense expense) async {
    try {
      await expenseTable.insert(expense.toEntity().toDocument());
    } catch (e) {
      logger.e(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<Expense>> getExpenses() async {
    try {
      return await expenseTable.select().then((value) =>
          (value as List<dynamic>)
              .map((e) => Expense.fromEntity(ExpenseEntity.fromDocument(e)))
              .toList());
    } catch (e) {
      logger.e(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> deleteExpense(String expenseId) async {
    try {
      await expenseTable.delete().eq('expenseId', expenseId);
    } catch (e) {
      logger.e(e.toString());
    }
  }

  @override
  Future<int> getTotalExpenses() async {
    try {
      final expenses = await getExpenses();

      int total = 0;

      for (var expense in expenses) {
        total = total + expense.amount;
      }

      return total;
    } catch (e) {
      logger.e(e.toString());
      rethrow;
    }
  }
}
