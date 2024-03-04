import 'package:expense_tracker/models/expense_items.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveDataBase {
  // reference our box
  final _mybox = Hive.box("expense_database2");
  // writing data
  void saveData(List<ExpenseItem> allExpense) {
    /*
    Hive can only store strings datetime and not custom objects like ExpenseItem so let's convert
    ExpenseItem Objects into types that can be stored in our db 

    allExpense = 
    [
      ExpenseItem (name/amount/ datetime )
      ...
    ]

    -->

    [

    [name , amount , datetime],
    ...   

    ]

    */

    List<List<dynamic>> allExpensesFormatted = [];

    for (var expense in allExpense) {
      // convert each expenseitem into a list of storable types (strings, datetime)
      List<dynamic> allExpensesFormatted = [
        expense.name,
        expense.amount,
        expense.dateTime,
      ];
      allExpensesFormatted.add(allExpensesFormatted);
    }
    // Finally lets store in our database!
    _mybox.put("All Expenses", allExpensesFormatted);
  }

  // reading data
  List<ExpenseItem> readData() {
    /*

    Data is stored hive as a list of strings + datetime , so let's convert our saved data into 
    ExpenseItem objects 

    savedData = 
    [

    [name, amount, datetime ],
    ..

    ]

    -->

    [

    Expenseitem [name / amount / datetime ],
    ..

    ]

    */

    List savedExpenses = _mybox.get("All Expenses") ?? [];
    List<ExpenseItem> allExpenses = [];

    for (int i = 0; i < savedExpenses.length; i++) {
      // Collect invdividual expense data
      String name = savedExpenses[i][0];
      String amount = savedExpenses[i][1];
      DateTime dateTime = savedExpenses[i][2];

      // create expense items
      ExpenseItem expense = ExpenseItem(
        amount: amount,
        name: name,
        dateTime: dateTime,
      );

      // add expense to overall list of expenses 
      allExpenses.add(expense);
    }
    return allExpenses;
  }
}
