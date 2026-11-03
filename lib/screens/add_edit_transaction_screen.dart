import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../database/db_helper.dart';
import '../models/transaction_model.dart';

class AddEditTransactionScreen extends StatefulWidget {
  final TransactionModel? transaction;

  const AddEditTransactionScreen({super.key, this.transaction});

  @override
  State<AddEditTransactionScreen> createState() =>
      _AddEditTransactionScreenState();
}

class _AddEditTransactionScreenState extends State<AddEditTransactionScreen> {
  final _formKey = GlobalKey<FormState>();

  // Text Editing Controllers
  late TextEditingController _titleController;
  late TextEditingController _amountController;

  // Selected values
  String? _selectedCategory;
  String? _selectedType;
  DateTime _selectedDate = DateTime.now();

  // Category list
  final List<String> _categories = [
    'Salary',
    'Business',
    'Freelance',
    'Investment',
    'Food',
    'Transport',
    'Rent',
    'Shopping',
    'Bills',
    'Entertainment',
    'Health',
    'Education',
    'Other',
  ];

  // Transaction Types
  final List<String> _transactionTypes = ['Income', 'Expense'];

  bool get _isEditing => widget.transaction != null;

  @override
  void initState() {
    super.initState();
    final item = widget.transaction;

    // Initialize with existing values if editing, or defaults if adding
    _titleController = TextEditingController(text: item?.title ?? '');
    _amountController =
        TextEditingController(text: item != null ? item.amount.toString() : '');
    _selectedCategory = item?.category;
    _selectedType = item?.type;

    if (item != null) {
      try {
        _selectedDate = DateTime.parse(item.date);
      } catch (_) {
        _selectedDate = DateTime.now();
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  // Date picker method
  Future<void> _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  // Save or update transaction
  Future<void> _saveTransaction() async {
    // Validate form inputs according to criteria
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final title = _titleController.text.trim();
    final amount = double.parse(_amountController.text.trim());
    final category = _selectedCategory!;
    final type = _selectedType!;
    final date = DateFormat('yyyy-MM-dd').format(_selectedDate);

    final transaction = TransactionModel(
      id: widget.transaction?.id,
      title: title,
      amount: amount,
      category: category,
      type: type,
      date: date,
    );

    if (_isEditing) {
      await DatabaseHelper.instance.updateTransaction(transaction);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Transaction updated successfully!'),
            backgroundColor: Colors.teal,
          ),
        );
      }
    } else {
      await DatabaseHelper.instance.insertTransaction(transaction);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Transaction added successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }

    if (mounted) {
      Navigator.pop(context, true); // Pop and return true to indicate change
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Transaction' : 'Add Transaction'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Title (TextField)
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  hintText: 'e.g., Monthly Salary, Grocery Shopping',
                  prefixIcon: Icon(Icons.title),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Title cannot be empty';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 2. Amount (TextField)
              TextFormField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Amount (BDT)',
                  hintText: '0.00',
                  prefixText: '৳ ',
                  prefixIcon: Icon(Icons.payments_outlined),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Amount cannot be empty';
                  }
                  final parsed = double.tryParse(value.trim());
                  if (parsed == null || parsed <= 0) {
                    return 'Amount must be a valid positive number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 3. Category (DropdownButton)
              DropdownButtonFormField<String>(
                initialValue: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  prefixIcon: Icon(Icons.category),
                  border: OutlineInputBorder(),
                ),
                hint: const Text('Select Category'),
                items: _categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    _selectedCategory = val;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Category must be selected';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 4. Transaction Type (Income / Expense)
              DropdownButtonFormField<String>(
                initialValue: _selectedType,
                decoration: const InputDecoration(
                  labelText: 'Transaction Type',
                  prefixIcon: Icon(Icons.swap_horiz),
                  border: OutlineInputBorder(),
                ),
                hint: const Text('Select Type'),
                items: _transactionTypes.map((type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Row(
                      children: [
                        Icon(
                          type == 'Income'
                              ? Icons.arrow_downward
                              : Icons.arrow_upward,
                          color: type == 'Income' ? Colors.green : Colors.red,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          type,
                          style: TextStyle(
                            color:
                                type == 'Income' ? Colors.green : Colors.red,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    _selectedType = val;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Transaction type must be selected';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 5. Date (Date Picker)
              InkWell(
                onTap: _pickDate,
                borderRadius: BorderRadius.circular(4),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Date',
                    prefixIcon: Icon(Icons.calendar_today),
                    border: OutlineInputBorder(),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat('yyyy-MM-dd').format(_selectedDate),
                        style: const TextStyle(fontSize: 16),
                      ),
                      const Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 6. Save Button
              ElevatedButton.icon(
                onPressed: _saveTransaction,
                icon: const Icon(Icons.save),
                label: Text(
                  _isEditing ? 'Update Transaction' : 'Save Transaction',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

