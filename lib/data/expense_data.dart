import 'package:expense_tracker/data/hive_database.dart';
import 'package:expense_tracker/models/expense_items.dart';
import 'package:flutter/material.dart';

import '../datetime/date_time_helper.dart';

class ExpenseData extends ChangeNotifier {

  // List of all expenses
  List<ExpenseItem> overallExpenseList = [];

  // get expense list 
  List<ExpenseItem> getAllExpenseList () {
    return overallExpenseList;
  }

  // prepare data to display 
  final db = HiveDataBase();
  void prepareData () {
    // if there exists data , get it 
    if (db.readData().isNotEmpty) {
      overallExpenseList = db.readData();
    }
  }

  // add new expense
  void addNewExpense (ExpenseItem newExpense) {
    overallExpenseList.add(newExpense);
    notifyListeners();
    db.saveData(overallExpenseList);
  }

  // delete expense
  void deleteExpense (ExpenseItem expense) {
    overallExpenseList.remove(expense);
    notifyListeners();
    db.saveData(overallExpenseList);
  }

  // get weekday (mon, tues, etc) from dateTime object
  String getDayName(DateTime dateTime) {
    switch (dateTime.weekday) {
      case 1:
        return 'Mon';
        case 2:
        return 'Tue';
        case 3:
        return 'Wed';
        case 4:
        return 'Thur';
        case 5:
        return 'Fri';
        case 6:
        return 'Sat';
        case 7:
        return 'Sun';
      default:
      return '';
    }
  }

  // get the data for start of the week (Sunday)
  DateTime startOfWeekDate () {
    DateTime? startOfWeek;

    // get today's date
    DateTime today = DateTime.now();

    // go backwards from today to find sunday
    for (int i=0; i<=7; i++) {
      if (getDayName(today.subtract(Duration(days: i))) == 'Sun') {
        startOfWeek = today.subtract(Duration(days: i));
      }

    }
    return startOfWeek!;
  }

  /*
  convert overall list of expenses into  a daily expense summary
  e.g.

  overallExpenseList = 
  [
    [food, 2023/01/30, $10],
    [hat, 2023/01/30, 15$],
    [drinks,2023/01/31, 6$],
    [food, 2023/02/01, 5$],
    [food, 2023/02/01, 6$],
    [food, 2023/02/03, 7$],
    [food, 2023/02/05, 10$],
    [food, 2023/02/05, 11$],
    
  ]
  
  -->
  
  DailyExpenseSummary = 

  [
    [20240130, $25],
    [20240131, $1],
    [20240201, $11],
    [20240203, $7],
    [20240205, $21],

  ]
  */

  Map<String,double> calculateDailyExpenseSummary () {
    Map<String,double> dailyExpenseSummary = {
      // date (yyyymmdd) : amountTotalForThatDay
    };
    
    for(var expense in overallExpenseList) {
      String date = convertDateTimeToString(expense.dateTime);
      double amount = double.parse(expense.amount);

      if (dailyExpenseSummary.containsKey(date)) {
        double currentAmount = dailyExpenseSummary[date]!;
        currentAmount == amount;
        dailyExpenseSummary[date] = currentAmount;
      } else {
        dailyExpenseSummary.addAll({date:amount});
        
      }
    }
    return dailyExpenseSummary;
  }
}