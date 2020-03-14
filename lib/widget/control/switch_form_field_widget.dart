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

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'switch_form_field_widget_scope.dart';

/// Implements [FormField]<[bool]> of the [SwitchListTile] control.
class SwitchFormFieldWidget extends FormField<bool> {
//  static final Logger _log = Logger("SwitchFormFieldWidget");

  final SwitchFormFieldWidgetScope formFieldWidgetScope;

  /// Create [SwitchFormFieldWidget] optionally using [onSaved], [validator],
  /// [initialValue], [onChange], [title] and [autoValidate].
  SwitchFormFieldWidget(this.formFieldWidgetScope)
      : super(
          key: formFieldWidgetScope.currentKey,
          onSaved: formFieldWidgetScope.onSaved,
          validator: formFieldWidgetScope.validator,
          initialValue: formFieldWidgetScope.initialValue,
          autovalidate: formFieldWidgetScope.autoValidate,
          enabled: formFieldWidgetScope.enabled,
          builder: formFieldWidgetScope.builder,
        );

  factory SwitchFormFieldWidget.createScope({
    Key key,
    @required BehaviorSubject<dynamic> controller,
    FormFieldSetter<bool> onSaved,
    FormFieldValidator<bool> validator,
    bool initialValue = false,
    ValueChanged<bool> onChanged,
    InputDecoration decoration,
    bool autoValidate = false,
    bool enabled = true,
    Color activeColor,
    Color activeTrackColor,
    Color inactiveThumbColor,
    Color inactiveTrackColor,
    ImageProvider inactiveThumbImage,
    ImageProvider activeThumbImage,
    bool isThreeLine = false,
    bool selected = false,
  }) =>
      SwitchFormFieldWidget(SwitchFormFieldWidgetScope(
        key: key ?? GlobalKey<FormFieldState<bool>>(),
        controller: controller,
        validator: validator,
        selected: selected,
        onSaved: onSaved,
        onChanged: onChanged,
        isThreeLine: isThreeLine,
        initialValue: initialValue,
        autoValidate: autoValidate,
        activeColor: activeColor,
        enabled: enabled,
        decoration: decoration,
        activeThumbImage: activeThumbImage,
        activeTrackColor: activeTrackColor,
        inactiveThumbColor: inactiveThumbColor,
        inactiveThumbImage: inactiveThumbImage,
        inactiveTrackColor: inactiveTrackColor,
      ));
}
