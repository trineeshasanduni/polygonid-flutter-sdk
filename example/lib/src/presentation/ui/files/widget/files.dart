import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/dependency_injection/dependencies_provider.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/files/bloc/file_bloc.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/home/home_bloc.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/home/home_event.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/home/home_state.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

class Files extends StatefulWidget {
  const Files({super.key});

  @override
  State<Files> createState() => _FilesState();
}

class _FilesState extends State<Files> {
  List<PlatformFile> selectedFiles = [];
  bool _isLoading = false;
  late final FileBloc _fileBloc;
  late final HomeBloc _homeBloc;
  String identity = '';
  final walletAddress = '';

  @override
  void initState() {
    super.initState();
    _fileBloc = getIt<FileBloc>();
    _homeBloc = getIt<HomeBloc>();
    _deployContract();
    // _initializeValues();
    _initGetIdentifier();
  }

  // Future<void> _initializeValues() async {
  //   final storage = GetStorage();
  //   walletAddress = storage.read('walletAddress') ?? '';
  //   print('walletAddress fetch: $walletAddress');

  // }

  void _initGetIdentifier() {
    _homeBloc.add(const GetIdentifierHomeEvent());
  }

  Future<void> openFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      setState(() {
        selectedFiles = result.files;
      });
      _uploadFiles();
    }
  }

  Future<void> _deployContract() async {
    var httpClient = Client();
    Web3Client? _web3Client;
    try {
      var rpcUrl = 'https://polygon-rpc.com/';
      _web3Client = Web3Client(rpcUrl, httpClient, socketConnector: () {
        return IOWebSocketChannel.connect('wss://polygon-mainnet.infura.io')
            .cast<String>();
      });

      final abiFile =
          await rootBundle.loadString('assets/abi/FileStorage.json');
      if (abiFile.isEmpty) throw FormatException('ABI file is empty');

      final jsonAbi = jsonDecode(abiFile);
      final _abiCode =
          ContractAbi.fromJson(jsonEncode(jsonAbi['abi']), 'FileStorage');
      final _contractAddress =
          EthereumAddress.fromHex('0xB9f09905ef2bA45b8f84DCE94465831B459bCe24');
      final _contract = DeployedContract(_abiCode, _contractAddress);
      final _getAllBatchesFunction = _contract.function('getAllBatches');

      final result = await _web3Client.call(
        contract: _contract,
        function: _getAllBatchesFunction,
        params: [],
      );

      if (result.isNotEmpty && result[0] is List) {
        _processContractResult(result[0]);
      } else {
        print('No data returned from contract');
      }
    } catch (e) {
      print('An error occurred: $e');
    } finally {
      httpClient.close();
    }
  }

  void _processContractResult(List<dynamic> dataResult) {
    for (var batch in dataResult) {
      var batchDetails = batch as List<dynamic>;
      print('Owner DID: ${batchDetails[0]}');
      print('Batch Hash: ${batchDetails[1]}');
      print('Files Count: ${batchDetails[2]}');
      print('Batch Size: ${batchDetails[3]}');
      print('Verified: ${batchDetails[4]}');
      print('---');
    }
  }

  Future<void> _uploadFiles() async {
    BlocBuilder<HomeBloc, HomeState>(
        bloc: _homeBloc,
        builder: (BuildContext context, HomeState state) {
          identity = state.identifier as String;
          print('identity checking: $identity');
          return const SizedBox.shrink();
        });

    final storage = GetStorage();
    // final getDID = storage.read('did');
    final walletAddress = storage.read('walletAddress');
    print('walletAddress : $walletAddress');

    setState(() {
      _isLoading = true;
    });

    try {
      for (var file in selectedFiles) {
        final fileToSave = await saveFile(file);
        _fileBloc.add(FileuploadEvent(
          did: 'did:polygonid:polygon:main:2pzuZ5jPYEFcKj4byRmdm3p6UJAqUDL3sJofLpaAi7',
          ownerDid: walletAddress,
          fileData: fileToSave,
        ));
      }
    } catch (e) {
      print('Upload failed: $e');
      setState(() {
        selectedFiles.clear();
      });
      _showSnackbar('Failed to upload files');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<File> saveFile(PlatformFile file) async {
    final storage = await getApplicationDocumentsDirectory();
    final newFile = File('${storage.path}/${file.name}');
    return File(file.path!).copy(newFile.path);
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _fileBloc,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          body: BlocListener<FileBloc, FileState>(
            listener: (context, state) {
              if (state is FileUploading) {
                setState(() {
                  _isLoading = true;
                });
              } else if (state is FileUploaded) {
                setState(() {
                  _isLoading = false;
                  selectedFiles.clear();
                });
                _showSnackbar('Files uploaded successfully!');
              } else if (state is FileUploadFailed) {
                setState(() {
                  _isLoading = false;
                });
                _showSnackbar('Failed to upload files: ${state.message}');
              }
            },
            child: Column(
              children: [
                _buildHeader(),
                _buildFileSelectionButton(),
                Expanded(child: _buildFileList()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return ListTile(
      title: Row(
        children: [
          Image.asset('assets/images/launcher_icon.png', width: 30, height: 30),
          RichText(
            text: TextSpan(
              text: 'zkp',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 20,
                fontFamily: GoogleFonts.robotoMono().fontFamily,
                fontWeight: FontWeight.w300,
              ),
              children: [
                TextSpan(
                  text: 'STORAGE',
                  style: TextStyle(
                    color: Theme.of(context).secondaryHeaderColor,
                    fontSize: 20,
                    fontFamily: GoogleFonts.robotoMono().fontFamily,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      trailing: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Theme.of(context).colorScheme.secondary,
            width: 1,
          ),
        ),
        child: Icon(
          Icons.wallet,
          color: Theme.of(context).secondaryHeaderColor,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildFileSelectionButton() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 10,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildFileInfoColumn('0', 'Files'),
            _buildFileInfoColumn('0MiB', 'Usage'),
            GestureDetector(
              onTap: _isLoading ? null : openFile,
              child: Container(
                width: MediaQuery.of(context).size.width / 3,
                alignment: Alignment.bottomCenter,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(6),
                  border: const GradientBoxBorder(
                    gradient: LinearGradient(
                        colors: [Color(0xFFa3d902), Color(0xFF2CFFAE)]),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                          'Select Files',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            fontFamily: GoogleFonts.robotoMono().fontFamily,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFileInfoColumn(String value, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(value,
            style: TextStyle(fontFamily: GoogleFonts.robotoMono().fontFamily)),
        Text(label,
            style: TextStyle(
                fontSize: 8, fontFamily: GoogleFonts.robotoMono().fontFamily)),
      ],
    );
  }

  Widget _buildFileList() {
    return ListView.builder(
      itemCount: selectedFiles.length,
      itemBuilder: (context, index) {
        final file = selectedFiles[index];
        return Card(
          child: ListTile(
            leading: Icon(Icons.file_present),
            title: Text(file.name),
            subtitle:
                Text('Size: ${file.size} bytes\nExtension: ${file.extension}'),
          ),
        );
      },
    );
  }
}
