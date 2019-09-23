import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SwitchFormField extends FormField<bool> {
  SwitchFormField({
    FormFieldSetter<bool> onSaved,
    FormFieldValidator<bool> validator,
    bool initialValue = false,
    VoidCallback onChange(bool value),
    String title = '',
    bool autoValidate = false,
  }) : super(
          onSaved: onSaved,
          validator: validator,
          initialValue: initialValue,
          autovalidate: autoValidate,
          builder: (FormFieldState<bool> state) {
            return SwitchListTile(
              value: initialValue,
              title: Text(title),
              subtitle: Text(
                state.hasError ? state.errorText : '',
                style: TextStyle(color: Color(0xFFd32f2f)),
              ),
              onChanged: (bool value) {
                state.didChange(value);
                onChange(value);
              },
            );
          },
        );
}
