/******************************************************************************
 * Copyright (c) 2019 Legytma Soluções Inteligentes (https://legytma.com.br). *
 *                                                                            *
 *  Licensed under the Apache License, Version 2.0 (the "License");           *
 *  you may not use this file except in compliance with the License.          *
 *  You may obtain a copy of the License at                                   *
 *                                                                            *
 *       http://www.apache.org/licenses/LICENSE-2.0                           *
 *                                                                            *
 * Unless required by applicable law or agreed to in writing, software        *
 * distributed under the License is distributed on an "AS IS" BASIS,          *
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.   *
 * See the License for the specific language governing permissions and        *
 * limitations under the License.                                             *
 ******************************************************************************/

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
  });

  factory JsonSchemaState.initial() {
    return JsonSchemaState(
      dataSchema: null,
      layout: null,
      data: <String, dynamic>{},
      submitData: null,
    );
  }

  JsonSchemaState copyWith({
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

  @override
  List<Object> get props => [dataSchema, layout, data, submitData];
}
