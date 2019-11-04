import 'package:meta/meta.dart';
import 'package:schema_form/bloc/event/JsonSchemaEvent.dart';

class LoadLayoutSchemaEvent extends JsonSchemaEvent {
  final Map<String, dynamic> layout;

  LoadLayoutSchemaEvent({@required this.layout});

  @override
  List<Object> get props => [layout];
}
