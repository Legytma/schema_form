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

import 'package:dynamic_widget/dynamic_widget.dart';
import 'package:schema_form/bloc/json_schema_bl.dart';

class JsonSchemaBlocClickListener implements ClickListener {
  final JsonSchemaBloc _jsonSchemaBloc;

  JsonSchemaBlocClickListener(this._jsonSchemaBloc);

  @override
  void onClicked(String event) {
    if ('SchemaForm://submit' == event) {
      print("Executing: $event");

      _jsonSchemaBloc.add(SubmitJsonSchemaEvent());
    } else {
      print("Click event not implemented: $event");
    }
  }
}
