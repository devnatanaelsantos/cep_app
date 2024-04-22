import 'package:flutter/services.dart';

import '../controllers/cep_controller.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CepController cepController = CepController();
  bool visibility = false;

  @override
  void dispose() {
    cepController.inputCep.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F2F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0073AB),
        title: const Text(
          'Buscar CEP',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Informe o CEP para localizar o endereço.',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF9BA2A5),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 180,
                width: 330,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.08),
                      offset: const Offset(0, 0),
                      blurRadius: 10,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 130,
                      height: 50,
                      child: ValueListenableBuilder(
                        valueListenable: cepController.errorText,
                        builder: (context, value, __) {
                          return TextField(
                            controller: cepController.inputCep,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(9),
                              CepInputFormatter(),
                            ],
                            decoration: InputDecoration(
                              hintText: 'Ex.: 01310-930',
                              hintStyle: const TextStyle(
                                color: Color(0xFF9BA2A5),
                              ),
                              border: const UnderlineInputBorder(),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFF003A6C),
                                ),
                              ),
                              errorText: cepController.errorText.value,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    SizedBox(
                      height: 40,
                      width: 100,
                      child: ValueListenableBuilder(
                        valueListenable: cepController.btnBuscar,
                        builder: (context, value, __) {
                          return ElevatedButton(
                            onPressed: !value
                                ? null
                                : () async {
                                    cepController.returnGetCep();
                                    visibility = true;
                                  },
                            style: const ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(
                                Color(0xFF003A6C),
                              ),
                            ),
                            child: const Text(
                              'Buscar',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          ValueListenableBuilder(
            valueListenable: cepController.cepModelNotifier,
            builder: (context, value, __) {
              return Visibility(
                visible: visibility,
                child: Text(
                  textAlign: TextAlign.center,
                  cepController.cepModelNotifier.value.toString(),
                  style: const TextStyle(
                    //color: Color(0xFF9BA2A5),
                    fontSize: 16,
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}

class CepInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    String sanitizedText = newValue.text;

    if (sanitizedText.length > 5) {
      sanitizedText =
          '${sanitizedText.substring(0, 5)}-${sanitizedText.substring(5)}';
    }

    return TextEditingValue(
      text: sanitizedText,
      selection: TextSelection.collapsed(offset: sanitizedText.length),
    );
  }
}
