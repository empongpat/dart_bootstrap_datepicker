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

  @Input() bool isSelected = false;
  @Input() bool isPrevMonth = false;
  @Input() bool isNextMonth = false;

  ElementRef _element;
  Element hostElement;

  DateTime date;

  DayComponent(this._element);

  @override
  void ngAfterContentInit() {
    hostElement = _element.nativeElement;
    date = new DateTime(int.parse(year), int.parse(month), int.parse(day));
    if (isPrevMonth) {
      hostElement.querySelector('div').classes.add("prev-month");
    }
    if (isNextMonth) {
      hostElement.querySelector('div').classes.add("next-month");
    }
    if (isSelected) {
      hostElement.querySelector('div').classes.add("selected");
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
