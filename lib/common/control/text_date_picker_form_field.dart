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

//import 'package:flutter/material.dart';
//import 'package:flutter/widgets.dart';
//
//class CheckboxFormField extends TextFormField {
//  CheckboxFormField({
//    FormFieldSetter<bool> onSaved,
//    FormFieldValidator<bool> validator,
//    bool initialValue = false,
//    VoidCallback onChange(bool value),
//    String title = '',
//    bool autoValidate = false,
//  }) : super(
//          onSaved: onSaved,
//          validator: validator,
//          initialValue: initialValue,
//          autovalidate: autoValidate,
//          builder: (FormFieldState<bool> state) {
//            return CheckboxListTile(
//              value: initialValue,
//              title: Text(title),
//              subtitle: Text(
//                state.hasError ? state.errorText : '',
//                style: TextStyle(color: Color(0xFFd32f2f)),
//              ),
//              controlAffinity: ListTileControlAffinity.leading,
//              onChanged: (bool value) {
//                state.didChange(value);
//                onChange(value);
//              },
//            );
//          },
//        );
//}
