import 'package:meta/meta.dart';
import 'package:schema_form/bloc/event/json_schema_event.dart';

class LoadDataEvent extends JsonSchemaEvent {
  final Map<String, dynamic> data;

  LoadDataEvent({@required this.data});

  @override
  List<Object> get props => [data];
}
