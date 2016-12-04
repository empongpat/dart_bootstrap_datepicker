import 'package:angular2/core.dart';
import 'package:dart_bootstrap_datepicker/src/components/datepicker_component.dart';

@Component(
  selector: 'example-component',
  templateUrl: 'example_component.html',
  directives: const[DatePickerComponent]
)

class ExampleComponent {
  @ViewChild(DatePickerComponent) DatePickerComponent datePicker;

}
