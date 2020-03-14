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
import 'package:json_schema/json_schema.dart';

import 'state/schema_form_widget_scope.dart';
import 'state/schema_form_widget_state.dart';
import 'template/widget_template.dart';

/// Signature of callbacks that have no arguments and return no data.
typedef SaveCallback = void Function(Map<String, dynamic> value);

/// SchemaForm control
class SchemaFormWidget extends StatefulWidget {
  /// The widget below this widget in the tree.
  ///
  /// This is the root of the widget hierarchy that contains this form.
  ///
  /// {@macro flutter.widgets.child}
  final Widget child;

  /// If true, form fields will validate and update their error text
  /// immediately after every change. Otherwise, you must call
  /// [FormState.validate] to validate.
  final bool autovalidate;

  /// Enables the form to veto attempts by the user to dismiss the [ModalRoute]
  /// that contains the form.
  ///
  /// If the callback returns a Future that resolves to false, the form's route
  /// will not be popped.
  ///
  /// See also:
  ///
  ///  * [WillPopScope], another widget that provides a way to intercept the
  ///    back button.
  final WillPopCallback onWillPop;

  /// Called when one of the form fields changes.
  ///
  /// In addition to this callback being invoked, all the form fields themselves
  /// will rebuild.
  final VoidCallback onChanged;

  /// Json schema for data validation
  final JsonSchema jsonSchema;

  /// Initial form data value
  final Map<String, dynamic> initialData;

  /// Called on form save.
  final SaveCallback onSave;

  final Map<String, WidgetTemplate> controlTemplateMap;
  final Map<SchemaType, WidgetTemplate> typeTemplateMap;

  final bool defaultHeader;

  /// Create instance
  SchemaFormWidget({
    Key key,
    @required this.child,
    this.autovalidate = false,
    this.onWillPop,
    this.onChanged,
    @required this.jsonSchema,
    this.initialData,
    this.onSave,
    this.controlTemplateMap,
    this.typeTemplateMap,
    this.defaultHeader = true,
  })  : assert(jsonSchema != null),
        super(key: key);

  /// Returns the closest [FormState] which encloses the given context.
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// FormState form = Form.of(context);
  /// form.save();
  /// ```
  static SchemaFormWidgetState of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<SchemaFormWidgetScope>();

    return scope?.schemaFormState;
  }

  @override
  SchemaFormWidgetState createState() => SchemaFormWidgetState();
}
