import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // para fazer as requisições
import 'package:async/async.dart'; //fazer requisições sem que fiquemos esperando

void main() async {
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
        hintColor: Colors.amber,
        primaryColor: Colors.white,
        inputDecorationTheme: InputDecorationTheme(
            enabledBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
            focusedBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
            hintStyle: TextStyle(color: Colors.amber))),
  ));
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<Map<String, dynamic>> fetchData() async {
    final response = await http
        .get(Uri.parse('https://api.hgbrasil.com/finance?key=8cf93218'));
    print(response.body);

    if (response.statusCode == 200) {
      // Se a resposta for bem-sucedida, convertemos o JSON para um mapa
      return json.decode(response.body);
    } else {
      // Se houver algum erro na requisição, lançamos uma exceção
      throw Exception('Falha ao carregar os dados');
    }
  }

  //stfull - comando para criar as classes

  @override
  Widget build(BuildContext context) {
    double dolar;
    double euro;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Converter'),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
          future: fetchData(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return const Center(
                  child: Text(
                    'Carregando...',
                    style: TextStyle(color: Colors.amber),
                    textAlign: TextAlign.center,
                  ),
                );
              default:
                if (snapshot.hasError) {
                  return const Center(
                    child: Text(
                      'Erro ao carregar dados.',
                      style: TextStyle(color: Colors.amber),
                      textAlign: TextAlign.center,
                    ),
                  );
                } else {
                  dolar = snapshot.data!["results"]["currencies"]["USD"]["buy"];
                  euro = snapshot.data!["results"]["currencies"]["EUR"]["buy"];
                  return SingleChildScrollView(
                    padding: EdgeInsets.all(10),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment
                            .stretch, //alinhar no centro, isso alarga tudo da coluna
                        children: [
                          Icon(
                            Icons.monetization_on,
                            size: 150,
                            color: Colors.amber,
                          ),
                          SizedBox(height: 15,),
                          TextField(
                            decoration: InputDecoration(
                                labelText: 'Reais',
                                labelStyle: TextStyle(color: Colors.amber),
                                border: OutlineInputBorder(),
                                prefixText: 'R\$'),
                            style: TextStyle(color: Colors.amber),
                          ),
                          SizedBox(height: 15,),
                          TextField(
                            decoration: InputDecoration(
                                labelText: 'Dolar',
                                labelStyle: TextStyle(color: Colors.amber),
                                border: OutlineInputBorder(),
                                prefixText: 'US\$'),
                            style: TextStyle(color: Colors.amber),
                          ),
                          SizedBox(height: 15,),
                          TextField(
                            decoration: InputDecoration(
                                labelText: 'Euro',
                                labelStyle: TextStyle(color: Colors.amber),
                                border: OutlineInputBorder(),
                                prefixText: '€\$'),
                            style: TextStyle(color: Colors.amber),
                          ),
                        ]),
                  );
                }
            }
          }),
    );
  }
}
