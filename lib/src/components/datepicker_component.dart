import 'dart:html';
import 'package:angular2/core.dart';
import 'package:intl/intl.dart';
import 'package:observable/observable.dart';
import 'day_component.dart';

@Component(
  selector: 'datepicker',
  templateUrl: 'datepicker_component.html',
  styleUrls: const['datepicker_component.css'],
  directives: const[DayComponent]
)

class DatepickerComponent implements OnInit, AfterContentInit, AfterViewInit{

  @Input() String componentId;

  String datepickerId;
  String initialDate;
  DateFormat dateFormat = new DateFormat("yyyy-MM-dd");
  DateTime currentMonthYear;
  String currentMonthName;
  bool hidden = true;
  InputElement inputDate;
  List<DateTime> dateList;
  ObservableList<DateTime> firstRowDateList, secondRowDateList, thirdRowDateList,
    fourthRowDateList, fifthRowDateList, sixthRowDateList;

  ElementRef _elementRef;
  Element hostElement;

  @ViewChildren(DayComponent) ObservableList<DayComponent> dayList;

  DatepickerComponent(this._elementRef);

  @override
  void ngOnInit() {
    datepickerId = componentId+"-datepicker";
    var now = new DateTime.now();
    initialDate = dateFormat.format(now);
    currentMonthYear = new DateTime(now.year, now.month);
    currentMonthName = getMonthName(currentMonthYear.month);
    dateList = findDates();
    renderCalendarDates();
  }

  @override
  void ngAfterContentInit() {
    hostElement = _elementRef.nativeElement;
    inputDate = hostElement.querySelector('input') as InputElement;
  }

  @override
  void ngAfterViewInit() {
    for (var day in dayList) {
      day.hostElement.onClick.listen((event) => dateClickListener(day, event));
    }
    dayList.changes.listen((onData) {
      for (var day in dayList) {
        day.hostElement.onClick.listen((event) => dateClickListener(day, event));
      }
    });
  }

  List<DateTime> findDates() {
    var resultList = [];
    var maxDaysOfCurrentMonth = findMaximumDaysInMonth(currentMonthYear.year, currentMonthYear.month);
    // Determine dates before current month by weekday of the first day of the month
    if (currentMonthYear.weekday != 7) {
      var maxDaysOfPreviousMonth;
      if (currentMonthYear.month != 1) {
        maxDaysOfPreviousMonth = findMaximumDaysInMonth(currentMonthYear.year, currentMonthYear.month-1);
        for (var i=maxDaysOfPreviousMonth; i > (maxDaysOfPreviousMonth - currentMonthYear.weekday); i--) {
          resultList.add(new DateTime(currentMonthYear.year, currentMonthYear.month-1, i));
        }
      } else {
        maxDaysOfPreviousMonth = findMaximumDaysInMonth(currentMonthYear.year-1, 12);
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

  void renderCalendarDates() {
    firstRowDateList = [];
    secondRowDateList = [];
    thirdRowDateList = [];
    fourthRowDateList = [];
    fifthRowDateList = [];
    sixthRowDateList = [];
    for (var i=0; i<7; i++) {
      firstRowDateList.add(dateList[i]);
      secondRowDateList.add(dateList[i+7]);
      thirdRowDateList.add(dateList[i+7*2]);
      fourthRowDateList.add(dateList[i+7*3]);
      fifthRowDateList.add(dateList[i+7*4]);
      sixthRowDateList.add(dateList[i+7*5]);
    }
  }

  int findMaximumDaysInMonth(int year, int month) {
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

  String getMonthName(int month) {
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

  void dateClickListener(DayComponent currentDay, Event event) {
    for (var day in dayList) {
      if (day.isSelected) {
        day.deselect();
        break;
      }
    }
    currentDay.select();
    inputDate.value = dateFormat.format(currentDay.date);
    inputDate.focus();
  }

  void previousMonth() {
    //check Min
    if (currentMonthYear.month > 1) {
      currentMonthYear = new DateTime(currentMonthYear.year, currentMonthYear.month-1);
    } else {
      currentMonthYear = new DateTime(currentMonthYear.year-1, 12);
    }
    currentMonthName = getMonthName(currentMonthYear.month);
    dateList = findDates();
    renderCalendarDates();
  }

  void nextMonth() {
    //check Max
    if (currentMonthYear.month == 12) {
      currentMonthYear = new DateTime(currentMonthYear.year+1);
    } else {
      currentMonthYear = new DateTime(currentMonthYear.year, currentMonthYear.month+1);
    }
    currentMonthName = getMonthName(currentMonthYear.month);
    dateList = findDates();
    renderCalendarDates();
  }

  void toggleDatepicker() {
    if (hidden) {
      showDatepicker();
    } else {
      hideDatepicker();
    }
  }

  void showDatepicker() {
    hostElement.querySelector("#$datepickerId").classes.remove("hide");
    hidden = false;
    inputDate.focus();
  }

  void hideDatepicker() {
    hostElement.querySelector("#$datepickerId").classes.add("hide");
    hidden = true;
  }

}
