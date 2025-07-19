class Budget {
  double amount;
  int month;
  int year;

  Budget({
    required this.amount,
    required this.month,
    required this.year,
  });

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'month': month,
      'year': year,
    };
  }

  factory Budget.fromMap(Map<String, dynamic> map) {
    return Budget(
      amount: map['amount'],
      month: map['month'],
      year: map['year'],
    );
  }
} 