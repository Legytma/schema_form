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
import 'package:flutter/widgets.dart';

/// Implements [FormField]<[T]> of the [RadioListTile] control.
class RadioListFormField<T> extends FormField<T> {
  /// Create [RadioListFormField] optionally using [onSaved], [validator],
  /// [initialValue], [onChange], [title] and [autoValidate].
  RadioListFormField({
    FormFieldSetter<T> onSaved,
    FormFieldValidator<T> validator,
    T radioValue,
    T initialValue,
    VoidCallback onChange(T value),
    String title = '',
    bool autoValidate = false,
  }) : super(
          onSaved: onSaved,
          validator: validator,
          initialValue: initialValue,
          autovalidate: autoValidate,
          builder: (FormFieldState<T> state) {
            return RadioListTile<T>(
              value: radioValue,
              groupValue: initialValue,
              title: Text(
                title,
                maxLines: 1,
                softWrap: false,
              ),
              subtitle: Text(
                state.hasError ? state.errorText : '',
                style: TextStyle(color: Color(0xFFd32f2f)),
                softWrap: false,
              ),
              onChanged: (T value) {
                state.didChange(value);
                onChange(value);
              },
            );
          },
        );
}
