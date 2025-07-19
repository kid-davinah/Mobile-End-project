class Expense {
  String id;
  String title;
  double amount;
  String categoryId;
  String note;
  DateTime date;
  String category;

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.categoryId,
    required this.note,
    required this.date,
    required this.category,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'categoryId': categoryId,
      'note': note,
      'date': date.toIso8601String(),
      'category': category,
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      title: map['title'],
      amount: map['amount'],
      categoryId: map['categoryId'],
      note: map['note'],
      date: DateTime.parse(map['date']),
      category: map['category'],
    );
  }
} 