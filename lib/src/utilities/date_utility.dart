class DateUtility {

  static List<DateTime> findDates(DateTime currentMonthYear) {
    var resultList = [];
    var maxDaysOfCurrentMonth = DateUtility.findMaximumDaysInMonth(currentMonthYear.year, currentMonthYear.month);
    // Determine dates before current month by weekday of the first day of the month
    if (currentMonthYear.weekday != 7) {
      var maxDaysOfPreviousMonth;
      if (currentMonthYear.month != 1) {
        maxDaysOfPreviousMonth = DateUtility.findMaximumDaysInMonth(currentMonthYear.year, currentMonthYear.month-1);
        for (var i=maxDaysOfPreviousMonth; i > (maxDaysOfPreviousMonth - currentMonthYear.weekday); i--) {
          resultList.add(new DateTime(currentMonthYear.year, currentMonthYear.month-1, i));
        }
      } else {
        maxDaysOfPreviousMonth = DateUtility.findMaximumDaysInMonth(currentMonthYear.year-1, 12);
        for (var i=maxDaysOfPreviousMonth; i > (maxDaysOfPreviousMonth - currentMonthYear.weekday); i--) {
          resultList.add(new DateTime(currentMonthYear.year-1, 12, i));
        }
      }
      resultList = resultList.reversed.toList();
      for (var i=1; i<=maxDaysOfCurrentMonth; i++) {
        resultList.add(new DateTime(currentMonthYear.year, currentMonthYear.month, i));
      }
      var dayEmptySpaces = 42 - currentMonthYear.weekday - maxDaysOfCurrentMonth;
      if (currentMonthYear.month != 12) {
        for (var i=1; i<=dayEmptySpaces; i++) {
          resultList.add(new DateTime(currentMonthYear.year, currentMonthYear.month+1, i));
        }
      } else {
        for (var i=1; i<=dayEmptySpaces; i++) {
          resultList.add(new DateTime(currentMonthYear.year+1, 1, i));
        }
      }
    } else {
      for (var i=1; i<=maxDaysOfCurrentMonth; i++) {
        resultList.add(new DateTime(currentMonthYear.year, currentMonthYear.month, i));
      }
      var dayEmptySpaces = 42 - maxDaysOfCurrentMonth;
      if (currentMonthYear.month != 12) {
        for (var i=1; i<=dayEmptySpaces; i++) {
          resultList.add(new DateTime(currentMonthYear.year, currentMonthYear.month+1, i));
        }
      } else {
        for (var i=1; i<=dayEmptySpaces; i++) {
          resultList.add(new DateTime(currentMonthYear.year+1, 1, i));
        }
      }
    }
    return resultList;
  }

  static int findMaximumDaysInMonth(int year, int month) {
    // For JAN, MAR, MAY, JULY, AUG, OCT, DEC
    if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {
      return 31;
    }
    // For APR, JUN, SEP, NOV
    else if (month == 4 || month == 6 || month == 9 || month == 11) {
      return 30;
    }
    // For FEB
    else {
      // Every 4th year is a leap year
      if (year % 4 == 0) {
        // However not every hundredth year but
        // every four hundrerd years is a leap year
        if (year % 100 != 0 || year % 400 == 0) {
          return 29;
        } else {
          return 28;
        }
      } else {
        return 28;
      }
    }
  }

  static String getMonthName(int month) {
    String name;
    switch(month) {
      case 1: name = "January";
        break;
      case 2: name = "February";
        break;
      case 3: name = "March";
        break;
      case 4: name = "April";
        break;
      case 5: name = "May";
        break;
      case 6: name = "June";
        break;
      case 7: name = "July";
        break;
      case 8: name = "August";
        break;
      case 9: name = "September";
        break;
      case 10: name = "October";
        break;
      case 11: name = "November";
        break;
      case 12: name = "December";
        break;
    }
    return name;
  }

}
