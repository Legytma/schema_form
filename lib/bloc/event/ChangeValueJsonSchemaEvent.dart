import 'package:meta/meta.dart';
import 'package:schema_form/bloc/event/JsonSchemaEvent.dart';

class ChangeValueJsonSchemaEvent extends JsonSchemaEvent {
  final String key;
  final dynamic value;

  ChangeValueJsonSchemaEvent({@required this.key, @required this.value})
      : super([key, value]);
}
