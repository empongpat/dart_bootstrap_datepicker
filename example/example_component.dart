import 'package:angular2/core.dart';
import 'package:dart_bootstrap_datepicker/src/components/datepicker_component.dart';
import 'package:dart_bootstrap_datepicker/src/components/interval/datepicker_interval_component.dart';

@Component(
  selector: 'example-component',
  templateUrl: 'example_component.html',
  directives: const[DatepickerComponent, DatepickerIntervalComponent]
)

class ExampleComponent {

}
