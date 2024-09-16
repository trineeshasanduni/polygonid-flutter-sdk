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
import 'package:http/http.dart';
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

  Future<void> _processContractResult(List<dynamic> dataResult) async {
    if (_isRequestInProgress) {
      // If a request is already in progress, do nothing
      return;
    }

    setState(() {
      _isRequestInProgress = true; // Set the flag to true when request starts
    });

    int filesFetched = 0; // Counter to track the number of files fetched
    final totalFiles = dataResult.length; // Total number of files to be fetched

    try {
      // Start listening to the BLoC stream outside of the loop
      _fileBloc.stream.listen((state) {
        if (state is FileNameLoaded) {
          setState(() {
            fileNames.add(state.fileName.fileName.toString());
            filesFetched++; // Increment the counter for each loaded file

            // Check if all files have been fetched
            if (filesFetched == totalFiles) {
              print('All files fetched successfully.');
              _isRequestInProgress = false; // Stop requesting further files
            }
          });
        }
      });

      // Loop through the dataResult and fetch file names
      for (var batchDetails in dataResult) {
        final batchHash = batchDetails[1].toString();
        print('batchHash123: $batchHash');
        print("Total files: $totalFiles");

        // Wait for a short delay between each request
        await Future.delayed(Duration(milliseconds: 500), () {
          if (filesFetched < totalFiles) {
            _fileBloc.add(
                GetFileNameEvent(BatchHash: batchHash)); // Fetch the next file
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

  Future<bool> isTransactionSuccessful(String txHash) async {
    // Initialize the Web3Client using your Infura or Alchemy endpoint
    final client = Web3Client(
        "https://polygon-mainnet.g.alchemy.com/v2/SOxCgJzw6PLvC02g238nlDqJRq83_j3k",
        Client());

    try {
      // Fetch the transaction receipt
      final receipt = await client.getTransactionReceipt(txHash);
      print('receipt: $receipt');

      if (receipt != null && receipt.status == true) {
        print("Transaction successful!");
        return true;
      } else {
        print("Transaction failed or still pending.");
        return false;
      }
    } catch (e) {
      print("Error fetching transaction status: $e");
      return false;
    } finally {
      client.dispose();
    }
  }

  Future<void> _checkTxHashStatus(String txHash, String owner, int size) async {
    bool isSuccess = false;

    // Add logic to check the transaction status here.
    // For example, calling a blockchain API to check the status of the txHash.

    while (!isSuccess) {
      // Call your blockchain transaction check method
      // Example: checkTransaction(txHash) which returns true/false
      isSuccess = await isTransactionSuccessful(txHash);

      if (isSuccess) {
        print('Transaction successful with hash: $txHash');
        // Dispatch the event to create proof after the transaction is successful
        _fileBloc.add(UseSpaceEvent(
          did: jsonDecode(widget.did.toString()),
          ownerDid: owner,
          batchSize: size,
        ));
      } else {
        print('Transaction is not yet successful. Retrying...');
        await Future.delayed(Duration(seconds: 5)); // Poll every 5 seconds
      }
    }
  }

  Future<void> _checkUseSpaceTxHashStatus(String txHash) async {
    bool isSuccess = false;

    // Add logic to check the transaction status here.
    // For example, calling a blockchain API to check the status of the txHash.

    while (!isSuccess) {
      // Call your blockchain transaction check method
      // Example: checkTransaction(txHash) which returns true/false
      isSuccess = await isTransactionSuccessful(txHash);

      if (isSuccess) {
        print('Transaction successful with hash: $txHash');
        // Dispatch the event to create proof after the transaction is successful
      } else {
        print('Transaction is not yet successful. Retrying...');
        await Future.delayed(Duration(seconds: 5)); // Poll every 5 seconds
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final storage = GetStorage();
    // final getDID = storage.read('did');
    final walletAddress = storage.read('walletAddress');
    print('walletAddress : $walletAddress');
    return BlocProvider(
      create: (_) => _fileBloc,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          body: BlocConsumer<FileBloc, FileState>(
              listener: (context, state) async {
            // if (state is FileUploadFailed) {
            //   _showSnackbar('Failed to upload files: ${state.message}');
            // }
            if (state is FileUploaded) {
              for (var file in dataResult) {
                print('object file: $file');
              }
              await _checkTxHashStatus(
                  state.response.TXHash!, walletAddress, size);

              print('dataResult: $dataResult');
            }
            if (state is FileUsingSpaced) {
              print('fetching space state: ${state.txHash}');
              String txHash = state.txHash.TXHash!;
              await _checkUseSpaceTxHashStatus(txHash);

              Container(
                child: Text('fetching space state12: ${state.txHash}'),
              );

              print('usespace check: ${state.txHash.TXHash}');
              _showSnackbar(
                  'Files uploaded successfully: ${state.txHash.TXHash}');
            }
          }, builder: (context, state) {
            return Column(
              children: [
                _buildHeader(),
                const SizedBox(height: 10),
                _buildFileSelectionButton(),
                const SizedBox(height: 20),
                _buildFileList(),
                _buildBlocContent(context),
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
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          fileNames[index],
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: GoogleFonts.robotoMono().fontFamily,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.2,
                            child: _buildVerifyButton(index),
                          ),
                          SizedBox(width: 50),
                          // Space between icons
                          SizedBox(
                            width: 40, // Adjust width as needed
                            child: _buildIcon(
                              Icons.download,
                              Theme.of(context).colorScheme.secondary,
                              Theme.of(context).colorScheme.secondary,
                              Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
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

  Widget _buildVerifyButton( int index) {
    return GestureDetector(
      onTap: () {
        final batchHash = dataResult[index][1].toString();
          final did = jsonDecode(widget.did.toString());
          final storage = GetStorage();
          // final getDID = storage.read('did');
          final walletAddress = storage.read('walletAddress');
          print('walletAddress123 : $walletAddress');
          _fileBloc.add(VerifyUploadEvent(
            BatchHash: batchHash,
            ownerDid: walletAddress,
            did: did,
          ));
      },
      child: _buildButton(
        "verify",
        Theme.of(context).colorScheme.secondary,
        Theme.of(context).colorScheme.secondary,
        Theme.of(context).primaryColor,
       
      ),
    );
  }

  Widget _buildBlocContent(BuildContext context) {
    return BlocBuilder<FileBloc, FileState>(
      bloc: _fileBloc,
      builder: (context, state) {
        if (state is Fileverifying) {
          return CircularProgressIndicator(
              color: Theme.of(context).secondaryHeaderColor);
        }
        if (state is FileVerifyFailed) {
          return Text(state.message, style: const TextStyle(color: Colors.red));
        }
        if (state is VerifySuccess) {
          final response = jsonEncode(state.response.claim?.toJson());
          print("response verify: $response");
          _handleVerifyResponseSuccess(state);
        }
        // if (state is StatusLoaded) {
        //   _handleStatusLoaded(state);
        // }
        return const SizedBox.shrink();
      },
    );
  }
  void _handleVerifyResponseSuccess(VerifySuccess state) {
    final response = jsonEncode(state.response.toJson());
    

    // print('Login response: $response');
    // _loginBloc.add(onLoginResponse(response));

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _loginBloc.add(onGetStatusEvent(sessionId));
    // });
  }

  Widget _buildIcon(
      IconData icon, dynamic colorScheme, dynamic border, dynamic textColor) {
    return Container(
      // width: MediaQuery.of(context).size.width * 0.25,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Icon(
        icon as IconData?,
        color: textColor,
      ),
    );
  }

  Widget _buildButton(
      String text, dynamic colorScheme, dynamic border, dynamic textColor,
  ) {
    return GestureDetector(
     
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
        decoration: BoxDecoration(
          color: colorScheme,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: border,
            width: 2,
          ),
        ),
        child: Text(
          text,
          style: GoogleFonts.robotoMono(
            color: textColor,
            fontSize: 10,
            fontWeight: FontWeight.bold,
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
        onTap: _deployContract,
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
      height: MediaQuery.of(context).size.height / 14,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildFileInfoColumn('0', 'Files'),
            _buildFileInfoColumn('0MiB', 'Usage'),
            SizedBox(width: 10),
            GestureDetector(
              onTap: _isLoading ? null : openFile,
              child: Container(
                width: MediaQuery.of(context).size.width / 3,
                alignment: Alignment.bottomCenter,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(10),
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
