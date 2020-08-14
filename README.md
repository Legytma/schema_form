[![GitHub issues](https://img.shields.io/github/issues/Legytma/schema_form)](https://github.com/Legytma/schema_form/issues)
[![GitHub forks](https://img.shields.io/github/forks/Legytma/schema_form)](https://github.com/Legytma/schema_form/network)
[![GitHub stars](https://img.shields.io/github/stars/Legytma/schema_form)](https://github.com/Legytma/schema_form/stargazers)
[![GitHub license](https://img.shields.io/github/license/Legytma/schema_form)](https://github.com/Legytma/schema_form/blob/master/LICENSE)
[![Pub](https://img.shields.io/pub/v/schema_form)](https://pub.dev/packages/schema_form)
[![style: effective dart](https://img.shields.io/badge/style-effective_dart-40c4ff.svg)](https://github.com/tenhobi/effective_dart)
![GitHub tag (latest SemVer)](https://img.shields.io/github/v/tag/Legytma/schema_form)
![GitHub top language](https://img.shields.io/github/languages/top/Legytma/schema_form)
![GitHub contributors](https://img.shields.io/github/contributors/Legytma/schema_form)
![GitHub last commit](https://img.shields.io/github/last-commit/Legytma/schema_form)
![Flutter CI](https://github.com/Legytma/schema_form/workflows/Flutter%20CI/badge.svg "Flutter CI")

# Convert Json Schema to Form for Flutter apps

* [What is it](#what-is-it)
  * [Motivation](#motivation)
  * [How this work](#how-this-work)
* [Getting Started](#getting-started)
  * [Installation](#installation)
  * [Usage](#usage)
* [CHANGELOG](https://github.com/Legytma/schema_form/blob/master/CHANGELOG.md)
* [Next steps](#next-steps)
* [LICENSE](https://github.com/Legytma/schema_form/blob/master/LICENSE)

## What is it

[schema_form](https://pub.dev/packages/schema_form "schema_form") is a Flutter package to produce forms dynamically by interpreting JSON Schemas based on the [json_schema](https://pub.dev/packages/json_schema "json_schema") package.

### Motivation
A major difficulty for any application developer is to ensure that all users keep their applications up to date to ensure the same user experience and to reduce the time required to fix bugs.

The most commonly used alternative to accelerate this process is [Code Push](https://github.com/Microsoft/code-push) which allows the application update without the need for a new deploy in the store. However in Code Push GitHub itself there is a [Code Push Support for Flutter](https://github.com/Microsoft/code-push/issues/624#issuecomment-532358395) request with comment saying that support depends on implementing dynamic update support in Flutter, there is also a reference to [Flutter Roadmap](https://github.com/flutter/flutter/wiki/Roadmap#changes) saying that support for This type of update is postponed according to the official comment [Code Push / Hot Update / out of band updates](https://github.com/flutter/flutter/issues/14330#issuecomment-485565194), which explains the reasons that led to the decision.

One possible solution to this deadlock is to implement a JSON interpreter that enables screen redesign, which can be obtained using [dynamic_widget](https://github.com/dengyin2000/dynamic_widget). However dynamic_widget does not support a dynamic form. This package was designed to meet this need.

### How this work

## Getting Started

* For help over FormSchema usage, view the [example](https://github.com/Legytma/schema_form/tree/master/example);
* For help over class documentation, view the [documentation](https://raw.githubusercontent.com/Legytma/schema_form/master/doc/api/index.html);
* For help getting started with Flutter, view our online [documentation](https://flutter.io/);
* For help on editing package code, view the [documentation](https://flutter.io/developing-packages/).

### Installation

* Add this to your package's pubspec.yaml file:
```yaml
dependencies:
  schema_form: "^1.0.0"
```
* You can install packages from the command line:
  with Flutter:
```
$ flutter packages get
```
* Import it Now in your Dart code, you can use:
```dart
 import 'schema_form_widget.dart'; 
```

### Usage

```dart
  JsonSchemaBloc jsonSchemaBloc = JsonSchemaBloc(formContext: context); // Business Logic
  SchemaForm schemaForm = SchemaForm(jsonSchemaBloc: jsonSchemaBloc);   // Form Widget

  // Load files
  File layoutSchemaFile = new File("layoutSchema.json");  // JSON screen layout
  File dataSchemaFile = new File("dataSchema.json");      // Data Schema
  File dataValueFile = new File("dataValue.json");        // Object for editing

  // Get content of files
  String layoutSchemaContent = layoutSchemaFile.readAsStringSync();
  String dataSchemaContent = dataSchemaFile.readAsStringSync();
  String dataValueContent = dataValueFile.readAsStringSync();

  // Turn content into Map
  Map<String, dynamic> layoutSchemaMap = json.decode(layoutSchemaContent);
  Map<String, dynamic> dataSchemaMap = json.decode(dataSchemaContent);
  Map<String, dynamic> dataValueMap = json.decode(dataValueContent);

  // Turn Map into JsonSchema
  JsonSchema dataJsonSchema = JsonSchema.createSchema(dataSchemaMap);

  // Load to Business Logic
  jsonSchemaBloc.add(LoadLayoutSchemaEvent(layout: layoutSchemaMap));   // Layout
  jsonSchemaBloc.add(LoadDataSchemaEvent(dataSchema: dataJsonSchema));  // Json Schema
  jsonSchemaBloc.add(LoadDataEvent(data: dataValueMap));                // Object in edit

  print(jsonSchemaBloc.getFormData());  // Print the object being edited
```

<p align="center">
  <img width="300" src="https://raw.githubusercontent.com/Legytma/schema_form/master/image1.png"/>
  <img width="300" src="https://raw.githubusercontent.com/Legytma/schema_form/master/image2.png"/>
</p>

## Next steps

- [x] Make MVP
- [x] Minimal documentation
- [ ] Change event binding of click event
