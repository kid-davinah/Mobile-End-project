class Goal {
  String name;
  double targetAmount;
  double currentAmount;
  DateTime deadline;

  Goal({
    required this.name,
    required this.targetAmount,
    required this.currentAmount,
    required this.deadline,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'targetAmount': targetAmount,
      'currentAmount': currentAmount,
      'deadline': deadline.toIso8601String(),
    };
  }

  factory Goal.fromMap(Map<String, dynamic> map) {
    return Goal(
      name: map['name'],
      targetAmount: map['targetAmount'],
      currentAmount: map['currentAmount'],
      deadline: DateTime.parse(map['deadline']),
    );
  }
} 