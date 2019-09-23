import 'package:equatable/equatable.dart';
import 'package:json_schema/json_schema.dart';
import 'package:meta/meta.dart';

class JsonSchemaState extends Equatable {
  final JsonSchema dataSchema;
  final Map<String, dynamic> layout;
  final Map<String, dynamic> data;
  final String submitData;

  JsonSchemaState({
    @required this.dataSchema,
    @required this.layout,
    @required this.data,
    @required this.submitData,
  }) : super([dataSchema, layout, data, submitData]);

  factory JsonSchemaState.initial() {
    return JsonSchemaState(
      dataSchema: null,
      layout: null,
      data: Map<String, dynamic>(),
      submitData: null,
    );
  }

  copyWith({
    JsonSchema dataSchema,
    Map<String, dynamic> layout,
    Map<String, dynamic> data,
    String submitData,
  }) {
    return JsonSchemaState(
      dataSchema: dataSchema ?? this.dataSchema,
      layout: layout ?? this.layout,
      data: data ?? this.data,
      submitData: submitData ?? this.submitData,
    );
  }
}
