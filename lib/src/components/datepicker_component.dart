import 'dart:html';
import 'package:angular2/core.dart';
import 'package:intl/intl.dart';
import 'package:observable/observable.dart';

import 'day_component.dart';
import 'package:dart_bootstrap_datepicker/src/utilities/date_utility.dart';

@Component(
  selector: 'datepicker',
  templateUrl: 'datepicker_component.html',
  styleUrls: const['datepicker_component.css'],
  directives: const[DayComponent]
)

class DatepickerComponent implements OnInit, AfterContentInit, AfterViewInit{

  @Input() String componentId;
  @Input() String initialDate;
  @Input() String format;		

  ///String defaultDateFormat = "yyyy-MM-dd";
  String datepickerId;
  DateFormat dateFormat = new DateFormat("yyyy-MM-dd");
  DateTime selectedDate;
  DateTime currentMonthYear;
  DateTime endOfCurrentMonthYear;
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
    if (format != null) {
	try {
    	    dateFormat = new DateFormat(format);
	} on FormatException {
    	    dateFormat = new DateFormat("yyyy-MM-dd");
	}
    }
    if (initialDate == null) {
      selectedDate = new DateTime(now.year, now.month, now.day);
      initialDate = dateFormat.format(now);
    } else {
      selectedDate = DateTime.parse(initialDate);
    }
    currentMonthYear = new DateTime(selectedDate.year, selectedDate.month);
    refreshDatepicker();
  }

  @override
  void ngAfterContentInit() {
    hostElement = _elementRef.nativeElement;
    inputDate = hostElement.querySelector('input') as InputElement;
  }

  @override
  void ngAfterViewInit() {
    for (var day in dayList) {
      day.hostElement.onClick.listen((event) => _dateClickListener(day, event));
    }
    dayList.changes.listen((onData) {
      for (var day in dayList) {
        day.hostElement.onClick.listen((event) => _dateClickListener(day, event));
      }
    });
  }

  void _renderCalendarDates() {
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

  void _dateClickListener(DayComponent currentDay, Event event) {
    for (var day in dayList) {
      if (day.isSelected) {
        day.deselect();
        break;
      }
    }
    selectedDate = currentDay.select();
    inputDate.value = dateFormat.format(currentDay.date);
    inputDate.focus();
    if (currentDay.isPrevMonth) {
      previousMonth();
    }
    if (currentDay.isNextMonth) {
      nextMonth();
    }
  }

  void previousMonth() {
    //check Min
    if (currentMonthYear.month > 1) {
      currentMonthYear = new DateTime(currentMonthYear.year, currentMonthYear.month-1);
    } else {
      currentMonthYear = new DateTime(currentMonthYear.year-1, 12);
    }
    refreshDatepicker();
  }

  void nextMonth() {
    //check Max
    if (currentMonthYear.month == 12) {
      currentMonthYear = new DateTime(currentMonthYear.year+1);
    } else {
      currentMonthYear = new DateTime(currentMonthYear.year, currentMonthYear.month+1);
    }
    refreshDatepicker();
  }

  void resetDatepicker() {
    var now = new DateTime.now();
    inputDate.value = initialDate;
    selectedDate = new DateTime(now.year, now.month, now.day);
    currentMonthYear = new DateTime(now.year, now.month);
    refreshDatepicker();
  }

  void refreshDatepicker() {
    endOfCurrentMonthYear = new DateTime(
      currentMonthYear.year, currentMonthYear.month, DateUtility.findMaximumDaysInMonth(currentMonthYear.year, currentMonthYear.month));
    currentMonthName = DateUtility.getMonthName(currentMonthYear.month);
    dateList = DateUtility.findDates(currentMonthYear);
    _renderCalendarDates();
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

  DateTime getSelectedDate() {
    return selectedDate;
  }

}
