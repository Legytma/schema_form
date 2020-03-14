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
import 'package:rxdart/subjects.dart';

import 'check_box_form_field_widget_scope.dart';

/// Implements [FormField]<[bool]> of the [SwitchListTile] control.
class CheckBoxFormFieldWidget extends FormField<bool> {
//  static final Logger _log = Logger("CheckBoxFormFieldWidget");

  final CheckBoxFormFieldWidgetScope formFieldWidgetScope;

  /// Create [SwitchFormFieldWidget] optionally using [onSaved], [validator],
  /// [initialValue], [onChange], [title] and [autoValidate].
  CheckBoxFormFieldWidget(this.formFieldWidgetScope)
      : super(
          key: formFieldWidgetScope.currentKey,
          onSaved: formFieldWidgetScope.onSaved,
          validator: formFieldWidgetScope.validator,
          initialValue: formFieldWidgetScope.initialValue,
          autovalidate: formFieldWidgetScope.autoValidate,
          enabled: formFieldWidgetScope.enabled,
          builder: formFieldWidgetScope.builder,
        );

  factory CheckBoxFormFieldWidget.createScope({
    Key key,
    @required BehaviorSubject<dynamic> controller,
    FormFieldSetter<bool> onSaved,
    FormFieldValidator<bool> validator,
    bool initialValue = false,
    ValueChanged<bool> onChanged,
    InputDecoration decoration,
    bool autoValidate = false,
    bool enabled = true,
    ListTileControlAffinity controlAffinity = ListTileControlAffinity.platform,
    Color checkColor,
    Color activeColor,
    bool isThreeLine = false,
    bool selected = false,
  }) =>
      CheckBoxFormFieldWidget(CheckBoxFormFieldWidgetScope(
        key: key ?? GlobalKey<FormFieldState<bool>>(),
        controller: controller,
        decoration: decoration,
        controlAffinity: controlAffinity ?? ListTileControlAffinity.platform,
        enabled: enabled,
        activeColor: activeColor,
        autoValidate: autoValidate,
        checkColor: checkColor,
        initialValue: initialValue,
        isThreeLine: isThreeLine,
        onChanged: onChanged,
        onSaved: onSaved,
        selected: selected,
        validator: validator,
      ));
}
