import 'dart:html';
import 'package:angular2/core.dart';

@Component(
  selector: 'day',
  templateUrl: 'day_component.html',
  styleUrls: const['day_component.css']
)

class DayComponent implements AfterContentInit{

  @Input() String day;
  @Input() String month;
  @Input() String year;

  @Input() String isPrevMonth = "false";
  @Input() String isNextMonth = "false";

  ElementRef _element;
  Element hostElement;

  DateTime date;
  bool isSelected = false;

  DayComponent(this._element);

  @override
  void ngAfterContentInit() {
    hostElement = _element.nativeElement;
    if (isPrevMonth == "true") {
      hostElement.querySelector('div').classes.add("prev-month");
    }
    if (isNextMonth == "true") {
      hostElement.querySelector('div').classes.add("next-month");
    }
    date = new DateTime(int.parse(year), int.parse(month), int.parse(day));
    var now = new DateTime.now();
    if (date.isAtSameMomentAs(new DateTime(now.year, now.month, now.day))) {
      hostElement.querySelector('div').classes.add("selected");
      isSelected = true;
    }
  }

  DateTime select() {
    hostElement.querySelector('div').classes.add("selected");
    isSelected = true;
    return this.date;
  }

  void deselect() {
    hostElement.querySelector('div').classes.remove("selected");
    isSelected = false;
  }
}
