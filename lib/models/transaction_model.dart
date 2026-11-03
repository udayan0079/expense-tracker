class TransactionModel {
  final int? id;
  final String title;
  final double amount;
  final String category;
  final String type; // 'Income' or 'Expense'
  final String date; // 'YYYY-MM-DD'

  TransactionModel({
    this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.type,
    required this.date,
  });

  // Convert a TransactionModel object into a Map for SQLite
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'title': title,
      'amount': amount,
      'category': category,
      'type': type,
      'date': date,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  // Create a TransactionModel object from a Map from SQLite
  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'] as int?,
      title: map['title'] as String,
      amount: (map['amount'] as num).toDouble(),
      category: map['category'] as String,
      type: map['type'] as String,
      date: map['date'] as String,
    );
  }

  // Helper getter to check if this is an Income
  bool get isIncome => type == 'Income';
}

