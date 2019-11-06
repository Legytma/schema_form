import 'package:meta/meta.dart';
import 'package:schema_form/bloc/event/json_schema_event.dart';

class ChangeValueJsonSchemaEvent extends JsonSchemaEvent {
  final String key;
  final dynamic value;

  ChangeValueJsonSchemaEvent({@required this.key, @required this.value});

  @override
  List<Object> get props => [key, value];
}
