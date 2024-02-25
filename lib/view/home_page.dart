import 'package:flutter/material.dart';
import 'package:gems_pay/model/expense_model.dart';
import 'package:gems_pay/service/fire_auth_service.dart';
import 'package:gems_pay/service/firestore_service.dart';
import 'package:intl/intl.dart';

class FinanceTrackerHomePage extends StatefulWidget {
  final user;
  const FinanceTrackerHomePage({super.key, required this.user});

  @override
  FinanceTrackerHomePageState createState() => FinanceTrackerHomePageState();
}

class FinanceTrackerHomePageState extends State<FinanceTrackerHomePage> {
  final FireAuth _fireAuth = FireAuth();
  late final FirestoreService _firestoreService;
  List<Transaction> transactions = [];

  @override
  void initState() {
    super.initState();
    _firestoreService = FirestoreService(widget.user.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finance Tracker'),
        actions: [
          IconButton(
              onPressed: () => _fireAuth.signOut(context),
              icon: const Icon(Icons.power_settings_new))
        ],
      ),
      body: StreamBuilder<List<Expense>>(
        stream: _firestoreService.getExpenses(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            List<Expense> expenses = snapshot.data ?? [];
            return expenses.isEmpty
                ? const Center(
                    child: Text("No Expense yet"),
                  )
                : ListView.builder(
                    itemCount: expenses.length,
                    itemBuilder: (context, index) {
                      // Build your list item UI here
                      return GestureDetector(
                        onTap: () => _editTransaction(context, expenses[index]),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,

                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(expenses[index].description),
                                  Text(expenses[index]
                                      .amount
                                      .toDouble()
                                      .toString()),
                                ],
                              ),
                              Row(children: [
                                IconButton(
                                    onPressed: () => _editTransaction(
                                        context, expenses[index]),
                                    icon: const Icon(Icons.edit)),
                                IconButton(
                                    onPressed: () => _firestoreService
                                        .deleteExpense(expenses[index].id),
                                    icon: const Icon(Icons.delete))
                              ]),
                            ],

                            // Add more fields as needed
                          ),
                        ),
                      );
                    },
                  );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _startAddNewTransaction(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return NewTransaction(addTransaction: _addTransaction);
      },
    );
  }

  void _addTransaction(
      String title, double amount, DateTime date, String category) {
    _firestoreService.addExpense(title, category, amount, date);
  }

  void _editTransaction(BuildContext context, Expense transaction) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return EditTransaction(
          id: transaction.id,
          uid: transaction.userId,
          initialTitle: transaction.description,
          initialAmount: transaction.amount.toString(),
          initialDate: transaction.date,
          initialCategory: transaction.category,
        );
      },
    );
  }
}

class EditTransaction extends StatefulWidget {
  final String? id;
  final String? uid;
  final String? initialTitle;
  final String? initialAmount;
  final DateTime? initialDate;
  final String? initialCategory;

  const EditTransaction({
    super.key,
    this.id,
    this.uid,
    this.initialTitle,
    this.initialAmount,
    this.initialDate,
    this.initialCategory,
  });

  @override
  EditTransactionState createState() => EditTransactionState();
}

class EditTransactionState extends State<EditTransaction> {
  late final FirestoreService _firestoreService;
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  String? _selectedCategory;
  String errorText = "";

  @override
  void initState() {
    super.initState();
    _firestoreService = FirestoreService(widget.uid!);
    _titleController.text = widget.initialTitle ?? '';
    _amountController.text = widget.initialAmount ?? '';
    _selectedDate = widget.initialDate ?? DateTime.now();
    _selectedCategory = widget.initialCategory;
  }

  void _submitData() {
    final enteredTitle = _titleController.text;
    final enteredAmount = double.tryParse(_amountController.text) ?? 0.0;

    if (enteredTitle.isEmpty ||
        enteredAmount <= 0 ||
        _selectedDate == null ||
        _selectedCategory == null) {
      setState(() {
        errorText = "Fill the complete form";
      });

      return;
    }

    setState(() {
      errorText = "";
    });

    _firestoreService.editExpense(
      widget.id!,
      {
        'category': _selectedCategory,
        'description': enteredTitle,
        'amount': enteredAmount,
        'date': _selectedDate,
      },
    );

    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                errorText,
                style: const TextStyle(color: Colors.red),
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Note'),
                controller: _titleController,
                onSubmitted: (_) => _submitData(),
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Amount'),
                controller: _amountController,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => _submitData(),
              ),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                items: categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category.name,
                    child: Text(category.name),
                  );
                }).toList(),
                hint: const Text('Select a category'),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      _selectedDate == null
                          ? 'No Date Chosen'
                          : 'Picked Date: ${DateFormat.yMd().format(_selectedDate!)}',
                    ),
                  ),
                  TextButton(
                    onPressed: _presentDatePicker,
                    child: const Text(
                      'Choose Date',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: _submitData,
                child: const Text('Save Transaction'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NewTransaction extends StatefulWidget {
  final Function? addTransaction;
  final String? initialTitle;
  final String? initialAmount;
  final DateTime? initialDate;
  final String? initialCategory;

  const NewTransaction({
    super.key,
    this.addTransaction,
    this.initialTitle,
    this.initialAmount,
    this.initialDate,
    this.initialCategory,
  });

  @override
  NewTransactionState createState() => NewTransactionState();
}

class NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  String? _selectedCategory;

  String errorText = "";

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.initialTitle ?? '';
    _amountController.text = widget.initialAmount ?? '';
    _selectedDate = widget.initialDate ?? DateTime.now();
    _selectedCategory = widget.initialCategory;
  }

  void _submitData() {
    final enteredTitle = _titleController.text;
    final enteredAmount = double.tryParse(_amountController.text) ?? 0.0;

    if (enteredTitle.isEmpty ||
        enteredAmount <= 0 ||
        _selectedDate == null ||
        _selectedCategory == null) {
      setState(() {
        errorText = "Fill the complete form";
      });

      return;
    }

    setState(() {
      errorText = "";
    });

    widget.addTransaction!(
      enteredTitle,
      enteredAmount,
      _selectedDate!,
      _selectedCategory!,
    );

    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                errorText,
                style: const TextStyle(color: Colors.red),
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Note'),
                controller: _titleController,
                onSubmitted: (_) => _submitData(),
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Amount'),
                controller: _amountController,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => _submitData(),
              ),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                items: categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category.name,
                    child: Text(category.name),
                  );
                }).toList(),
                hint: const Text('Select a category'),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      _selectedDate == null
                          ? 'No Date Chosen'
                          : 'Picked Date: ${DateFormat.yMd().format(_selectedDate!)}',
                    ),
                  ),
                  TextButton(
                    onPressed: _presentDatePicker,
                    child: const Text(
                      'Choose Date',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: _submitData,
                child: const Text('Save Transaction'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Transaction {
  String title;
  double amount;
  DateTime date;
  Category category;

  Transaction({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  });
}

class Category {
  final String name;

  Category({required this.name});
}

List<Category> categories = [
  Category(name: 'Salary'),
  Category(name: 'Rent'),
  Category(name: 'Groceries'),
];
