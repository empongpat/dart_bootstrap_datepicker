import 'dart:html';
import 'package:angular2/core.dart';
import 'package:intl/intl.dart';
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
  bool hidden = true;
  InputElement inputDate;

  ElementRef _elementRef;
  Element hostElement;

  @ViewChildren(DayComponent) List<DayComponent> dayList;

  DatepickerComponent(this._elementRef);

  @override
  void ngOnInit() {
    datepickerId = componentId+"-datepicker";
    var now = new DateTime.now();
    initialDate = dateFormat.format(now);
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
