// Copyright (c) 2020 Legytma Soluções Inteligentes (https://legytma.com.br).
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

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import '../schema_form_widget.dart';
import 'schema_form_widget_state.dart';

/// Schema form scope
class SchemaFormWidgetScope extends InheritedWidget {
  static final Logger _log = Logger("SchemaFormWidgetScope");

  /// Schema form state instance
  final SchemaFormWidgetState schemaFormState;

  /// Incremented every time a form field has changed. This lets us know when
  /// to rebuild the form.
  final int generation;

  /// Create instance
  const SchemaFormWidgetScope({
    Key key,
    Widget child,
    this.schemaFormState,
    this.generation,
  }) : super(key: key, child: child);

  /// The [Form] associated with this widget.
  SchemaFormWidget get schemaForm => schemaFormState.widget;

  @override
  bool updateShouldNotify(SchemaFormWidgetScope old) {
    _log.finest("Executing updateShouldNotify because '$generation'"
        " is different of '${old.generation}'...");

    return generation != old.generation;
  }
}
