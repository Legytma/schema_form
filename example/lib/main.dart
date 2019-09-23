import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:json_schema/json_schema.dart';
import 'package:schema_form/SchemaForm.dart';
import 'package:schema_form/bloc/JsonSchemaBl.dart';

void main() => runApp(MyApp());

enum FileLocate { asset, storage, url }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Flutter JsonSchema Demo';
    JsonSchemaBloc jsonSchemaBloc = JsonSchemaBloc(formContext: context);

    loadSchemasFrom(
      FileLocate.asset,
      context,
      jsonSchemaBloc,
    );

    return MaterialApp(
      locale: Locale("pt", "BR"),
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: Text(appTitle),
        ),
        drawer: Drawer(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Text(appTitle),
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
              ),
              ListTile(
                title: Text('Load from Asset'),
                onTap: () => loadSchemasFrom(
                  FileLocate.asset,
                  context,
                  jsonSchemaBloc,
                ),
              ),
              ListTile(
                title: Text('Load from Storage'),
                onTap: () => loadSchemasFrom(
                  FileLocate.storage,
                  context,
                  jsonSchemaBloc,
                ),
              ),
              ListTile(
                title: Text('Load from URL'),
                onTap: () => loadSchemasFrom(
                  FileLocate.url,
                  context,
                  jsonSchemaBloc,
                ),
              ),
            ],
          ),
        ),
        body: SchemaForm(jsonSchemaBloc: jsonSchemaBloc),
      ),
    );
  }

  void loadSchemasFrom(FileLocate fileLocate, BuildContext context,
      JsonSchemaBloc jsonSchemaBloc) {
    loadJsonFrom(fileLocate, context, "testLayoutSchema.json").then(
        (Map<String, dynamic> layoutSchema) => jsonSchemaBloc
            .dispatch(LoadLayoutSchemaEvent(layout: layoutSchema)));

    loadJsonFrom(fileLocate, context, "testDataSchema.json").then(
        (Map<String, dynamic> jsonMap) => jsonSchemaBloc.dispatch(
            LoadDataSchemaEvent(dataSchema: JsonSchema.createSchema(jsonMap))));

    loadJsonFrom(fileLocate, context, "testDataValue.json").then(
        (Map<String, dynamic> dataValue) =>
            jsonSchemaBloc.dispatch(LoadDataEvent(data: dataValue)));
  }

  Future<Map<String, dynamic>> loadJsonFrom(
      FileLocate fileLocate, BuildContext context, String fileName) async {
    switch (fileLocate) {
      case FileLocate.asset:
        return await loadJsonFromAsset(context, 'assets/$fileName');
      case FileLocate.storage:
        return await loadJsonFromStorage(
            context, '/storage/emulated/0/Json/files/$fileName');
      case FileLocate.url:
        return await loadJsonFromUrl(context,
            'https://legytma-platform-open-api-back.herokuapp.com/schema/mongo/$fileName');
      default:
        throw "Não implementado!";
    }
  }

  Future<Map<String, dynamic>> loadJsonFromAsset(
      BuildContext context, String filePath) async {
    print("filePath: $filePath");

    String content = await DefaultAssetBundle.of(context).loadString(filePath);

    print("content: $content");

    Map<String, dynamic> jsonMap = json.decode(content);

    return jsonMap;
  }

  Future<Map<String, dynamic>> loadJsonFromStorage(
      BuildContext context, String filePath) async {
    print("filePath: $filePath");

    File file = new File(filePath);

    if (file.existsSync()) {
      String content = file.readAsStringSync();

      print("content: $content");

      Map<String, dynamic> jsonMap = json.decode(content);

      return jsonMap;
    }

    throw "File not found!";
  }

  Future<Map<String, dynamic>> loadJsonFromUrl(
      BuildContext context, String filePath) async {
    print("filePath: $filePath");

    String username = '';
    String password = '';
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    print('basicAuth: $basicAuth');

    http.Response response = await http.get(Uri.encodeFull(filePath), headers: {
      "Accept": "application/json",
      "Authorization": basicAuth,
    });

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonMap = json.decode(response.body);

      return jsonMap;
    }

    throw "${response.statusCode} - ${response.reasonPhrase}: ${response.body}";
  }
}
