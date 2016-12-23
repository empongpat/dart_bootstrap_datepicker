import 'dart:html';
import 'package:angular2/core.dart';
import 'package:intl/intl.dart';
import 'package:observable/observable.dart';

import '../day_component.dart';
import 'package:dart_bootstrap_datepicker/src/utilities/date_utility.dart';

@Component(
  selector: 'datepicker-interval',
  templateUrl: 'datepicker_interval_component.html',
  styleUrls: const['datepicker_interval_component.css'],
  directives: const[DayComponent]
)

class DatepickerIntervalComponent implements OnInit, AfterContentInit, AfterViewInit {

  @Input() String componentId;
  @Input() String initialStartDate;
  @Input() String initialEndDate;

  String datepickerId;
  DateFormat dateFormat = new DateFormat("yyyy-MM-dd");
  DateTime selectedStartDate;
  DateTime selectedEndDate;
  DateTime currentStartMonthYear;
  DateTime currentEndMonthYear;
  DateTime endOfCurrentStartMonthYear;
  DateTime endOfCurrentEndMonthYear;
  String currentStartMonthName;
  String currentEndMonthName;
  InputElement inputDateInterval;
  List<DateTime> startDateList;
  List<DateTime> endDateList;
  ObservableList<DateTime> firstRowStartDateList, secondRowStartDateList,
    thirdRowStartDateList, fourthRowStartDateList, fifthRowStartDateList,
    sixthRowStartDateList;
  ObservableList <DateTime> firstRowEndDateList, secondRowEndDateList,
    thirdRowEndDateList, fourthRowEndDateList, fifthRowEndDateList,
    sixthRowEndDateList;

  ElementRef _elementRef;
  Element hostElement;

  @ViewChildren('start') ObservableList<DayComponent> startDayList;
  @ViewChildren('end') ObservableList<DayComponent> endDayList;

  DatepickerIntervalComponent(this._elementRef);

  @override
  void ngOnInit() {
    datepickerId = componentId + "-datepicker-interval";
    var now = new DateTime.now();
    if (initialStartDate == null || initialEndDate == null) {
      selectedStartDate = new DateTime(now.year, now.month, now.day);
      selectedEndDate = selectedStartDate.add(new Duration(days:
        DateUtility.findMaximumDaysInMonth(selectedStartDate.year, selectedStartDate.month)));
      initialStartDate = dateFormat.format(selectedStartDate);
      initialEndDate = dateFormat.format(selectedEndDate);
    } else {
      selectedStartDate = DateTime.parse(initialStartDate);
      selectedEndDate = DateTime.parse(initialEndDate);
    }
    currentStartMonthYear = new DateTime(selectedStartDate.year, selectedStartDate.month);
    currentEndMonthYear = new DateTime(selectedEndDate.year, selectedEndDate.month);
    refreshStartDatepicker();
    refreshEndDatepicker();
  }

  @override
  void ngAfterContentInit() {
    hostElement = _elementRef.nativeElement;
    inputDateInterval = hostElement.querySelector('input') as InputElement;
  }

  @override
  void ngAfterViewInit() {
    for (var day in startDayList) {
      day.hostElement.onClick.listen((event) => _startDateClickListener(day, event));
    }
    startDayList.changes.listen((onData) {
      for (var day in startDayList) {
        day.hostElement.onClick.listen((event) => _startDateClickListener(day, event));
      }
    });
    for (var day in endDayList) {
      day.hostElement.onClick.listen((event) => _endDateClickListener(day, event));
    }
    endDayList.changes.listen((onData) {
      for (var day in endDayList) {
        day.hostElement.onClick.listen((event) => _endDateClickListener(day, event));
      }
    });
    hostElement.onMouseDown.listen((event) {
      if (!((event.target as Element).matches('input'))) {
        event.preventDefault();
      }
    });
    inputDateInterval.onBlur.listen((event) {
      hideDatepicker();
    });
  }

  void _startDateClickListener(DayComponent currentDay, Event event) {
    for (var day in startDayList) {
      if (day.isSelected) {
        day.deselect();
        break;
      }
    }
    selectedStartDate = currentDay.select();
    inputDateInterval.value = dateFormat.format(currentDay.date)+" - "+dateFormat.format(selectedEndDate);
    if (currentDay.isPrevMonth) {
      previousStartMonth();
    }
    if (currentDay.isNextMonth) {
      nextStartMonth();
    }
  }

  void _endDateClickListener(DayComponent currentDay, Event event) {
    for (var day in endDayList) {
      if (day.isSelected) {
        day.deselect();
        break;
      }
    }
    selectedEndDate = currentDay.select();
    inputDateInterval.value = dateFormat.format(selectedStartDate)+" - "+dateFormat.format(currentDay.date);
    inputDateInterval.focus();
    if (currentDay.isPrevMonth) {
      previousEndMonth();
    }
    if (currentDay.isNextMonth) {
      nextEndMonth();
    }
  }

  void previousStartMonth() {
    //check Min
    if (currentStartMonthYear.month > 1) {
      currentStartMonthYear = new DateTime(currentStartMonthYear.year, currentStartMonthYear.month-1);
    } else {
      currentStartMonthYear = new DateTime(currentStartMonthYear.year-1, 12);
    }
    refreshStartDatepicker();
  }

  void previousEndMonth() {
    //check Min
    if (currentEndMonthYear.month > 1) {
      currentEndMonthYear = new DateTime(currentEndMonthYear.year, currentEndMonthYear.month-1);
    } else {
      currentEndMonthYear = new DateTime(currentEndMonthYear.year-1, 12);
    }
    refreshEndDatepicker();
  }

  void nextStartMonth() {
    //check Max
    if (currentStartMonthYear.month == 12) {
      currentStartMonthYear = new DateTime(currentStartMonthYear.year+1);
    } else {
      currentStartMonthYear = new DateTime(currentStartMonthYear.year, currentStartMonthYear.month+1);
    }
    refreshStartDatepicker();
  }

  void nextEndMonth() {
    //check Max
    if (currentEndMonthYear.month == 12) {
      currentEndMonthYear = new DateTime(currentEndMonthYear.year+1);
    } else {
      currentEndMonthYear = new DateTime(currentEndMonthYear.year, currentEndMonthYear.month+1);
    }
    refreshEndDatepicker();
  }

  void refreshStartDatepicker() {
    endOfCurrentStartMonthYear = new DateTime(
      currentStartMonthYear.year, currentStartMonthYear.month, DateUtility.findMaximumDaysInMonth(currentStartMonthYear.year, currentStartMonthYear.month));
    currentStartMonthName = DateUtility.getMonthName(currentStartMonthYear.month);
    startDateList = DateUtility.findDates(currentStartMonthYear);
    _renderCalendarStartDates();
  }

  void refreshEndDatepicker() {
    endOfCurrentEndMonthYear = new DateTime(
      currentEndMonthYear.year, currentEndMonthYear.month, DateUtility.findMaximumDaysInMonth(currentEndMonthYear.year, currentEndMonthYear.month));
    currentEndMonthName = DateUtility.getMonthName(currentEndMonthYear.month);
    endDateList = DateUtility.findDates(currentEndMonthYear);
    _renderCalendarEndDates();
  }

  void _renderCalendarStartDates() {
    firstRowStartDateList = [];
    secondRowStartDateList = [];
    thirdRowStartDateList = [];
    fourthRowStartDateList = [];
    fifthRowStartDateList = [];
    sixthRowStartDateList = [];
    for (var i=0; i<7; i++) {
      firstRowStartDateList.add(startDateList[i]);
      secondRowStartDateList.add(startDateList[i+7]);
      thirdRowStartDateList.add(startDateList[i+7*2]);
      fourthRowStartDateList.add(startDateList[i+7*3]);
      fifthRowStartDateList.add(startDateList[i+7*4]);
      sixthRowStartDateList.add(startDateList[i+7*5]);
    }
  }

  void _renderCalendarEndDates() {
    firstRowEndDateList = [];
    secondRowEndDateList = [];
    thirdRowEndDateList = [];
    fourthRowEndDateList = [];
    fifthRowEndDateList = [];
    sixthRowEndDateList = [];
    for (var i=0; i<7; i++) {
      firstRowEndDateList.add(endDateList[i]);
      secondRowEndDateList.add(endDateList[i+7]);
      thirdRowEndDateList.add(endDateList[i+7*2]);
      fourthRowEndDateList.add(endDateList[i+7*3]);
      fifthRowEndDateList.add(endDateList[i+7*4]);
      sixthRowEndDateList.add(endDateList[i+7*5]);
    }
  }

  void toggleDatepicker() {
    if (hostElement.querySelector("#$datepickerId").classes.contains("hide")) {
      showDatepicker();
    } else {
      hideDatepicker();
    }
  }

  void showDatepicker() {
    hostElement.querySelector("#$datepickerId").classes.remove("hide");
    inputDateInterval.focus();
  }

  void hideDatepicker() {
    hostElement.querySelector("#$datepickerId").classes.add("hide");
    inputDateInterval.blur();
  }

  DateTime getSelectedStartDate() {
    return selectedStartDate;
  }

  DateTime getSelectedEndDate() {
    return selectedEndDate;
  }

}
