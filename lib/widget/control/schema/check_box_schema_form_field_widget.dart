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
import 'package:flutter/widgets.dart';
import 'package:rxdart/subjects.dart';

import '../switch_form_field_widget.dart';
import 'state/checkbox_schema_form_field_widget_state.dart';

/// Implements [FormField]<[bool]> of the [SwitchListTile] control.
class CheckBoxSchemaFormFieldWidget extends StatefulWidget {
  final String fieldName;
  final BehaviorSubject<bool> controller;
  final FormFieldValidator<bool> validator;
  final FormFieldSetter<bool> onSaved;
  final bool initialValue;
  final InputDecoration decoration;
  final bool autoValidate;
  final bool enabled;
  final Color activeColor;
  final bool isThreeLine;
  final bool selected;
  final ListTileControlAffinity controlAffinity;
  final Color checkColor;
  final ValueChanged<bool> onChanged;

  /// Create [SwitchFormFieldWidget] optionally using [onSaved], [validator],
  /// [initialValue], [onChange], [title] and [autoValidate].
  CheckBoxSchemaFormFieldWidget({
    Key key,
    @required this.fieldName,
    this.controller,
    this.onSaved,
    this.onChanged,
    this.validator,
    this.initialValue = false,
    this.decoration,
    this.autoValidate = false,
    this.enabled = true,
    this.activeColor,
    this.isThreeLine,
    this.selected,
    this.controlAffinity = ListTileControlAffinity.platform,
    this.checkColor,
  }) : super(key: key);

  @override
  CheckboxSchemaFormFieldWidgetState createState() =>
      CheckboxSchemaFormFieldWidgetState();
}
