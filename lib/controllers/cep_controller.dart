import 'dart:convert';
import 'package:cep_app/models/cep.models.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class CepController extends ChangeNotifier {
  ValueNotifier<CepModel?> cepModelNotifier = ValueNotifier(null);
  final inputCep = TextEditingController();
  ValueNotifier<String?> errorText = ValueNotifier(null);
  ValueNotifier<bool> btnBuscar = ValueNotifier(false);

  CepController() {
    inputCep.addListener(() {
      btnBuscar.value = inputCep.value.text.isNotEmpty;
    });
  }

  Future<Map<String, dynamic>> getCep(cep) async {
    var url = Uri.http('viacep.com.br', '/ws/$cep/json/');
    var response = await http.get(url);

    debugPrint('Response status: ${response.statusCode}');
    debugPrint('Response body: ${response.body}');

    return jsonDecode(response.body);
  }

  returnGetCep() async {
    String cep = inputCep.text;

    if (cep.length != 9) {
      errorText.value = 'CEP inválido';
    } else {
      final result = await getCep(cep);

      cepModelNotifier.value = CepModel(
          cep: result['cep'],
          logradouro: result['logradouro'],
          bairro: result['bairro'],
          cidade: result['localidade'],
          estado: result['uf']);
    }
  }
}
