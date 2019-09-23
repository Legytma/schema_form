import 'package:dynamic_widget/dynamic_widget.dart';
import 'package:dynamic_widget/dynamic_widget/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:json_schema/json_schema.dart';
import 'package:schema_form/bloc/JsonSchemaBl.dart';
import 'package:schema_form/common/parseUtils.dart';

class SchemaTextFormFieldParser extends WidgetParser {
  @override
  bool forWidget(String widgetName) {
    return "SchemaTextFormField" == widgetName;
  }

  @override
  Widget parse(Map<String, dynamic> map, BuildContext buildContext,
      ClickListener listener) {
    final JsonSchemaBloc jsonSchemaBloc =
        BlocProvider.of<JsonSchemaBloc>(buildContext);

//      print('jsonSchemaBloc: $jsonSchemaBloc');

    final JsonSchema fieldSchema = jsonSchemaBloc.getPropertySchema(map['key']);

    StreamBuilder streamBuilder = StreamBuilder(
      stream: jsonSchemaBloc.getFieldStream(map['key']),
      builder: (context, snapshot) {
        String currentValue = snapshot?.data == null || snapshot?.data == ''
            ? fieldSchema.defaultValue ?? ''
            : _dataConverted(map, snapshot?.data, true);

        return TextFormField(
          controller: TextEditingController.fromValue(TextEditingValue(
            text: currentValue,
            selection: TextSelection.collapsed(offset: currentValue.length),
          )),
          onSaved: (value) {
            jsonSchemaBloc.dispatch(
              ChangeValueJsonSchemaEvent(
                key: map['key'],
                value: _dataConverted(map, value, false),
              ),
            );
          },
          autovalidate:
              map.containsKey('autovalidate') ? map['autovalidate'] : false,
          validator: (String value) {
            try {
              if (fieldSchema.requiredOnParent &&
                  (value == null || value == '')) {
                return "Required";
              }

              Validator validator = new Validator(fieldSchema);

              if (!validator.validate(_dataConverted(map, value, false))) {
                return validator.errors.first;
              }

              return null;
            } catch (e) {
              return e.toString();
            }
          },
          decoration: InputDecoration(
            hintText: fieldSchema.defaultValue != null
                ? fieldSchema.defaultValue
                : '',
            labelText: fieldSchema.requiredOnParent
                ? fieldSchema.title + ' *'
                : fieldSchema.title,
            suffixIcon: _sufixButton(
              map,
              context,
              listener,
              jsonSchemaBloc,
              fieldSchema,
              currentValue,
            ),
          ),
          keyboardType: map.containsKey("keyboardType")
              ? parseKeyboardType(map['keyboardType'])
              : null,
          keyboardAppearance: map.containsKey("keyboardAppearance")
              ? parseKeyboardAppearance(map['keyboardAppearance'])
              : null,
          obscureText:
              map.containsKey("obscureText") ? map['obscureText'] : false,
          readOnly: map.containsKey("readOnly") ? map['readOnly'] : false,
          textCapitalization: map.containsKey("textCapitalization")
              ? parseTextCapitalization(map['textCapitalization'])
              : TextCapitalization.none,
          autofocus: map.containsKey("autofocus") ? map['autofocus'] : false,
          autocorrect:
              map.containsKey("autocorrect") ? map['autocorrect'] : true,
          enabled: map.containsKey("enabled") ? map['enabled'] : true,
          maxLength: map.containsKey("maxLength") ? map['maxLength'] : null,
          maxLengthEnforced: map.containsKey("maxLengthEnforced")
              ? map['maxLengthEnforced']
              : true,
          maxLines: map.containsKey("maxLines") ? map['maxLines'] : 1,
          minLines: map.containsKey("minLines") ? map['minLines'] : null,
          style: map.containsKey('style') ? parseTextStyle(map['style']) : null,
          textAlign: map.containsKey('textAlign')
              ? parseTextAlign(map['textAlign'])
              : TextAlign.start,
          textDirection: map.containsKey('textDirection')
              ? parseTextDirection(map['textDirection'])
              : null,
          textInputAction: map.containsKey('textInputAction')
              ? parseTextInputAction(map['textInputAction'])
              : null,
        );
      },
    );

    return streamBuilder;
  }

  FlatButton _sufixButton(
      Map<String, dynamic> map,
      BuildContext buildContext,
      ClickListener listener,
      JsonSchemaBloc jsonSchemaBloc,
      JsonSchema fieldSchema,
      String currentValue) {
    print("map: $map");

    if (map.containsKey('datePicker')) {
      return FlatButton(
        child: Icon(Icons.calendar_today),
        onPressed: () {
          DateTime currentDate =
              _parseDateTime(map, currentValue) ?? DateTime.now();
          TimeOfDay currentTime = TimeOfDay.fromDateTime(currentDate);

          if (map['datePicker'] == "Time") {
            showTimePicker(context: buildContext, initialTime: currentTime)
                .then((TimeOfDay selectedTime) {
              DateTime selectedDateTime = DateTime(
                currentDate.year,
                currentDate.month,
                currentDate.day,
                selectedTime.hour,
                selectedTime.minute,
              );
              print("selectedDateTime: $selectedDateTime");

              jsonSchemaBloc.dispatch(
                ChangeValueJsonSchemaEvent(
                  key: map['key'],
                  value: selectedDateTime.toString(),
                ),
              );
            });
          } else {
            showDatePicker(
              context: buildContext,
              initialDate: currentDate,
              firstDate: DateTime(1900),
              lastDate: DateTime(2099),
              locale: Localizations.localeOf(buildContext),
            ).then((DateTime selectedDate) {
              print("selectedDate: $selectedDate");

              if (map['datePicker'] == "DateTime") {
                showTimePicker(context: buildContext, initialTime: currentTime)
                    .then((TimeOfDay selectedTime) {
                  DateTime selectedDateTime = DateTime(
                    selectedDate.year,
                    selectedDate.month,
                    selectedDate.day,
                    selectedTime.hour,
                    selectedTime.minute,
                  );
                  print("selectedDateTime: $selectedDateTime");

                  jsonSchemaBloc.dispatch(
                    ChangeValueJsonSchemaEvent(
                      key: map['key'],
                      value: selectedDateTime.toString(),
                    ),
                  );
                });
              } else {
                jsonSchemaBloc.dispatch(
                  ChangeValueJsonSchemaEvent(
                    key: map['key'],
                    value: selectedDate.toString(),
                  ),
                );
              }
            });
          }
        },
      );
    }

    return null;
  }

  String _formatDateTime(Map<String, dynamic> map, DateTime dateTime) {
    return _dateFormat(map).format(dateTime);
  }

  DateTime _parseDateTime(Map<String, dynamic> map, String dateTime) {
    return _dateFormat(map).parse(dateTime);
  }

  DateFormat _dateFormat(Map<String, dynamic> map) {
    initializeDateFormatting(map['locale'] == null || map['locale'] == ''
        ? Intl.getCurrentLocale()
        : map['locale']);

    return DateFormat(
        map['format'] == null || map['format'] == ''
            ? _defaultDateTimeFormat(map['datePicker'])
            : map['format'],
        map['locale'] == null || map['locale'] == ''
            ? Intl.getCurrentLocale()
            : map['locale']);
  }

  String _defaultDateTimeFormat(String datePicker) {
    switch (datePicker) {
      case 'Date':
        return 'dd/MM/yyyy';
      case 'Time':
        return 'HH:mm:ss';
      default:
        return 'dd/MM/yyyy HH:mm:ss';
    }
  }

  String _dataConverted(Map<String, dynamic> map, String value, bool view) {
    if (map.containsKey('datePicker')) {
      DateTime currentConverted = DateTime.tryParse(value);

      if (currentConverted == null) {
        currentConverted = _parseDateTime(map, value);

        if (currentConverted == null) {
          return '';
        }
      }

      if (view) {
        return _formatDateTime(map, currentConverted);
      }

      return currentConverted.toString();
    }

    return value ?? '';
  }
}
