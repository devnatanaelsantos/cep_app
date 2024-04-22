// ignore_for_file: public_member_api_docs, sort_constructors_first
class CepModel {
  final String cep;
  final String logradouro;
  final String bairro;
  final String cidade;
  final String estado;

  CepModel(
      {required this.cep,
      required this.logradouro,
      required this.bairro,
      required this.cidade,
      required this.estado});

  @override
  String toString() {
    return 'Cep: $cep \nLogradouro: $logradouro \nBairro: $bairro \nCidade: $cidade \nEstado: $estado';
  }
}
