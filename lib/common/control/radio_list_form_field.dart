import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RadioListFormField<T> extends FormField<T> {
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
              title: Text(title),
              subtitle: Text(
                state.hasError ? state.errorText : '',
                style: TextStyle(color: Color(0xFFd32f2f)),
              ),
              onChanged: (T value) {
                state.didChange(value);
                onChange(value);
              },
            );
          },
        );
}
