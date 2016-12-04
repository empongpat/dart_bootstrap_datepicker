import 'dart:html';
import 'package:angular2/core.dart';
import 'package:intl/intl.dart';

@Component(
  selector: 'datepicker',
  templateUrl: 'datepicker_component.html',
  styleUrls: const['datepicker_component.css']
)

class DatepickerComponent implements OnInit{

  @Input() String componentId;

  String datepickerId;
  String initialDate;
  DateFormat dateFormat = new DateFormat("yyyy-MM-dd");
  bool hidden = true;

  @override
  void ngOnInit() {
    datepickerId = componentId+"-datepicker";
    var now = new DateTime.now();
    initialDate = dateFormat.format(now);
  }

  void toggleDatepicker() {
    if (hidden) {
      showDatepicker();
    } else {
      hideDatepicker();
    }
  }

  void showDatepicker() {
    document.getElementById(datepickerId).classes.remove("hide");
    hidden = false;
    document.getElementById(componentId).querySelector("input").focus();
  }

  void hideDatepicker() {
    document.getElementById(datepickerId).classes.add("hide");
    hidden = true;
  }

}
