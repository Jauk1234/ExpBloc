import 'package:expense_repository/expense_repository.dart';

class ExpenseEntity {
  String expenseId;
  Category category;
  DateTime date;
  int amount;

  ExpenseEntity({
    required this.expenseId,
    required this.category,
    required this.date,
    required this.amount,
  });
  Map<String, Object?> toDocument() {
    return {
      'expenseId': expenseId,
      'category': category.toEntity().toDocument(),
      'date': date.toIso8601String(),
      'amount': amount,
    };
  }

  static ExpenseEntity fromDocument(Map<String, dynamic> doc) {
    return ExpenseEntity(
      expenseId: doc['expenseId'],
      category: Category.fromEntity(CategoryEntity.fromDocument(
        doc['category'],
      )),
      date: DateTime.parse(doc['date']),
      amount: doc['amount'],
    );
  }
}
