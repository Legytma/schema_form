import 'package:json_schema/json_schema.dart';
import 'package:meta/meta.dart';
import 'package:schema_form/bloc/event/JsonSchemaEvent.dart';

class LoadDataSchemaEvent extends JsonSchemaEvent {
  final JsonSchema dataSchema;

  LoadDataSchemaEvent({@required this.dataSchema}) : super([dataSchema]);
}
