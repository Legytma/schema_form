// Copyright (c) 2019 Legytma Soluções Inteligentes (https://legytma.com.br).
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:equatable/equatable.dart';
import 'package:json_schema/json_schema.dart';
import 'package:meta/meta.dart';

/// Object derived from class [Equatable] to store the state of the form.
class JsonSchemaState extends Equatable {
  /// [JsonSchema] for validation and description of properties in [Object] to
  /// be edited.
  final JsonSchema dataSchema;

  /// Form layout definition [Map].
  final Map<String, dynamic> layout;

  /// Serialization [Map] of the data to be edited.
  final Map<String, dynamic> data;

  /// Creates a [JsonSchemaState] using [dataSchema], [layout], and [data].
  JsonSchemaState({
    @required this.dataSchema,
    @required this.layout,
    @required this.data,
  });

  /// Creates a [JsonSchemaState] with default values.
  factory JsonSchemaState.initial() {
    return JsonSchemaState(
      dataSchema: null,
      layout: null,
      data: <String, dynamic>{},
    );
  }

  /// Creates a clone of the current [JsonSchemaState], replacing any properties
  /// that are passed as an argument.
  JsonSchemaState copyWith({
    JsonSchema dataSchema,
    Map<String, dynamic> layout,
    Map<String, dynamic> data,
  }) {
    return JsonSchemaState(
      dataSchema: dataSchema ?? this.dataSchema,
      layout: layout ?? this.layout,
      data: data ?? this.data,
    );
  }

  @override
  List<Object> get props => [dataSchema, layout, data];
}
