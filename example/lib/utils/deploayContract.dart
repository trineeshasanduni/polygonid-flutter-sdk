import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:web3modal_flutter/web3modal_flutter.dart';
import 'package:http/http.dart' as http;


class FileStorageService {
  Web3Client? _web3Client;
  final String rpcUrl;
  final String _contractAddress ;
  final String _abiPath ;
  var httpClient = http.Client();

  FileStorageService(this.rpcUrl, this._contractAddress,this._abiPath);

  Future<void> initializeWeb3Client() async {
    if (_web3Client == null) {
      _web3Client = Web3Client(rpcUrl, httpClient);
    }
  }

  Future<DeployedContract> loadContract(String contractName) async {
    final abiFile = await rootBundle.loadString(_abiPath);
    if (abiFile.isEmpty) throw FormatException('ABI file is empty');

    final jsonAbi = jsonDecode(abiFile);
    final abiCode = ContractAbi.fromJson(jsonEncode(jsonAbi['abi']), contractName);
    return DeployedContract(abiCode, EthereumAddress.fromHex(_contractAddress));
  }

  Future<List<dynamic>?> callContractFunction(
    DeployedContract contract,
    String functionName,
    List<dynamic> params, {
    String? senderAddress,
  }) async {
    final function = contract.function(functionName);

    final storage = GetStorage();
    final walletAddress1 = senderAddress ?? storage.read('walletAddress');

    final result = await _web3Client?.call(
      contract: contract,
      function: function,
      params: params,
      sender: EthereumAddress.fromHex(walletAddress1!),
    );

    return result;
  }
}
