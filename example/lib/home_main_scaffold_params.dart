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

import 'main.dart';

class HomeWidget extends StatelessWidget {
  static final String title = "Home";

  @override
  Widget build(BuildContext context) {
    var drawerItens = <Widget>[getDefaultHeader(context)];

    drawerItens.addAll(getItens(context));

    return Scaffold(
      appBar: getDefaultAppBar(context),
      drawer: Drawer(
        child: ListView(
          children: drawerItens,
        ),
      ),
      body: Center(
        child: Row(
          children: <Widget>[
            Icon(Icons.arrow_back),
            Text("Uilize o menu lateral para navegar entre os exemplos."),
          ],
        ),
      ),
    );
  }
}
