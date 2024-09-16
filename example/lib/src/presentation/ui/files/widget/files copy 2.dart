import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:polygonid_flutter_sdk/file/data/model/fileName_model.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/dependency_injection/dependencies_provider.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/files/bloc/file_bloc.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/home/home_bloc.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/home/home_event.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/home/home_state.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web3modal_flutter/utils/debouncer.dart';
import 'package:web_socket_channel/io.dart';

class Files extends StatefulWidget {
  final String? did;
  const Files({super.key, required this.did});

  @override
  State<Files> createState() => _FilesState();
}

class _FilesState extends State<Files> {
  List<PlatformFile> selectedFiles = [];
  int size = 0;
  bool _isLoading = false;
  late final FileBloc _fileBloc;
  late final HomeBloc _homeBloc;
  String identity = '';
  final walletAddress = '';
  bool _isRequestInProgress = false;
  List<String> fileNames = [];

  List<dynamic> dataResult = []; // Store contract data as a list of lists

  @override
  void initState() {
    super.initState();
    _fileBloc = getIt<FileBloc>();
    _homeBloc = getIt<HomeBloc>();

    final storage = GetStorage();
    _deployContract();
    _initGetIdentifier();
  }

  void _initGetIdentifier() {
    _homeBloc.add(const GetIdentifierHomeEvent());
  }

  Future<void> openFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      setState(() {
        selectedFiles = result.files;
        size = result.files.single.size;
        print('size: $size');
      });
      _uploadFiles();
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
      final did = jsonDecode(widget.did.toString());
      print('did12344: $did');
      for (var file in selectedFiles) {
        final fileToSave = await saveFile(file);
        _fileBloc.add(FileuploadEvent(
          did: did,
          ownerDid: walletAddress,
          fileData: fileToSave,
        ));
      }
    } catch (e) {
      print('Upload failed: $e');
      setState(() {
        selectedFiles.clear();
      });
      // _showSnackbar('Failed to upload files');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSnackbar(String message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    });
  }

  Future<File> saveFile(PlatformFile file) async {
    final storage = await getApplicationDocumentsDirectory();
    final newFile = File('${storage.path}/${file.name}');
    return File(file.path!).copy(newFile.path);
  }

  Future<void> _deployContract() async {
    var httpClient = http.Client();
    Web3Client? _web3Client;
    try {
      var rpcUrl =
          'https://polygon-mainnet.g.alchemy.com/v2/pHKWzuctaLCPxAKYc0c8bKQA8d85oPlk';
      _web3Client = Web3Client(rpcUrl, httpClient);

      final abiFile =
          await rootBundle.loadString('assets/abi/FileStorage.json');
      if (abiFile.isEmpty) throw FormatException('ABI file is empty');

      final jsonAbi = jsonDecode(abiFile);
      final _abiCode =
          ContractAbi.fromJson(jsonEncode(jsonAbi['abi']), 'FileStorage');

      final _contractAddress =
          EthereumAddress.fromHex('0x665e346D9c68587Bd51C53eAd71e0F5367E7950C');

      final _contract = DeployedContract(_abiCode, _contractAddress);
      final _getAllBatchesFunction = _contract.function('getAllBatches');

      final storage = GetStorage();
      final walletAddress1 = storage.read('walletAddress');

      final result = await _web3Client.call(
        contract: _contract,
        function: _getAllBatchesFunction,
        params: [],
        sender: EthereumAddress.fromHex(walletAddress1),
      );

      if (result.isNotEmpty && result[0] is List) {
        setState(() {
          dataResult = List<dynamic>.from(result[0]);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            // Store the result
            _processContractResult(result[0]);
          });
        });
      } else {
        print('No data returned from contract or result format is unexpected');
      }
    } catch (e) {
      print('An error occurred: $e');
    } finally {
      httpClient.close();
    }
  }

//   Future<void> _processContractResult(List<dynamic> dataResult) async {
//   await _deployContract(); // Ensure wallet address is loaded
//   // final debouncer = FileNameDebouncer(delay: Duration(seconds: 1));
//   // debouncer.run(() {
//     for (var batchDetails in dataResult) {
//       final batchHash = batchDetails[1].toString();
//       _fileBloc.add(GetFileNameEvent(BatchHash: batchHash));
//     }
//   // });
// }
  Future<void> _processContractResult(List<dynamic> dataResult) async {
    if (_isRequestInProgress) {
      // If a request is already in progress, do nothing
      return;
    }

    setState(() {
      _isRequestInProgress = true; // Set the flag to true when request starts
    });

    try {
      for (var batchDetails in dataResult) {
        final batchHash = batchDetails[1].toString();
        var batchDetail = batchDetails as List<dynamic>;
        final count = dataResult.length;
        print("count: $count");
        print('batchDetail: $batchDetail');
        if (batchDetail.length >= count) {
          await Future.delayed(Duration(milliseconds: 500), () {
            _fileBloc.add(GetFileNameEvent(BatchHash: batchHash));
          });
        }

        // _fileBloc.stream.listen((state) {
        // if (state is FileNameLoaded) {
        //   // fetchedFilesCount++;
        //   // print('Fetched file count: $fetchedFilesCount');

        //   // // Check if all files are fetched
        //   // if (fetchedFilesCount >= dataResult.length) {
        //   //   print('All files have been fetched');
        //   //   setState(() {
        //   //     _isRequestInProgress = false; // Reset the flag when all files are fetched
        //   //   });
        //   _buildFileName(state.fileName.fileName.toString());
        //   print('filename 123: ${state.fileName.fileName}');
        // }
        // });
        _fileBloc.stream.listen((state) {
          if (state is FileNameLoaded) {
            setState(() {
              fileNames.add(state.fileName.fileName.toString());
              // Store filenames in the list
            });
          }
        });
      }
    } catch (e) {
      print('Error processing contract result: $e');
    } finally {
      setState(() {
        _isRequestInProgress = false; // Reset the flag when request completes
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _fileBloc,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          body: BlocConsumer<FileBloc, FileState>(listener: (context, state) {
            // if (state is FileUploadFailed) {
            //   _showSnackbar('Failed to upload files: ${state.message}');
            // }
            if (state is FileUploaded) {
              for (var file in dataResult) {
                print('object file: $file');
              }

              print('dataResult: $dataResult');
            }
            if (state is FileUsingSpaced) {
              print('fetching space state: ${state.txHash}');
              Container(
                child: Text('fetching space state12: ${state.txHash}'),
              );
              // setState(() {
              //   _isLoading = true;
              // });
              print('usespace check: ${state.txHash.TXHash}');
              _showSnackbar(
                  'Files uploaded successfully: ${state.txHash.TXHash}');
            }
          }, builder: (context, state) {
            // if (state is FileNameLoaded) {
            //   print('fileName: ${state.fileName.fileName}');
            //   // for (var file in dataResult) {
            //     Text('fileName: ${state.fileName.fileName}');
            //   // }
            // }
            return Column(
              children: [
                _buildHeader(),
                _buildFileSelectionButton(),
                _buildFileList()
                // Expanded(
                //     child: _buildFileName()) // Display result
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildFileList() {
    return Expanded(
      child: fileNames.isNotEmpty
          ? ListView.builder(
              itemCount: fileNames.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    fileNames[index],
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: GoogleFonts.robotoMono().fontFamily,
                    ),
                  ),
                );
              },
            )
          : Center(
              child: Text(
                'No files fetched',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: GoogleFonts.robotoMono().fontFamily,
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
      trailing: GestureDetector(
        // onTap: _deployContract,
        child: Container(
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
}
