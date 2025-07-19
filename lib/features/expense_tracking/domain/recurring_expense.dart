class RecurringExpense {
  String id;
  String title;
  double amount;
  String categoryId;
  String category;
  String note;
  DateTime startDate;
  String frequency; // daily, weekly, monthly
  DateTime nextDueDate;
  DateTime? lastAppliedDate;

  RecurringExpense({
    required this.id,
    required this.title,
    required this.amount,
    required this.categoryId,
    required this.category,
    required this.note,
    required this.startDate,
    required this.frequency,
    required this.nextDueDate,
    this.lastAppliedDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'categoryId': categoryId,
      'category': category,
      'note': note,
      'start_date': startDate.toIso8601String(),
      'frequency': frequency,
      'next_due_date': nextDueDate.toIso8601String(),
      'last_applied_date': lastAppliedDate?.toIso8601String(),
    };
  }

  factory RecurringExpense.fromMap(Map<String, dynamic> map) {
    return RecurringExpense(
      id: map['id'],
      title: map['title'],
      amount: map['amount'],
      categoryId: map['category'] ?? '',
      category: map['category'],
      note: map['note'] ?? '',
      startDate: DateTime.parse(map['start_date']),
      frequency: map['frequency'],
      nextDueDate: DateTime.parse(map['next_due_date']),
      lastAppliedDate: map['last_applied_date'] != null ? DateTime.tryParse(map['last_applied_date']) : null,
    );
  }
} 