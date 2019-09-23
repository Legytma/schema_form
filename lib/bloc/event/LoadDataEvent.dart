import 'package:meta/meta.dart';
import 'package:schema_form/bloc/event/JsonSchemaEvent.dart';

class LoadDataEvent extends JsonSchemaEvent {
  final Map<String, dynamic> data;

  LoadDataEvent({@required this.data}) : super([data]);
}
