import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:ui';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:path_provider/path_provider.dart';
import 'package:polygonid_flutter_sdk/file/data/model/fileName_model.dart';
import 'package:polygonid_flutter_sdk/iden3comm/domain/entities/common/iden3_message_entity.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/dependency_injection/dependencies_provider.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/common/widgets/circularProgress.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/common/widgets/transperant_button.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/create_wallet/widget/glassEffect.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/files/download_bloc/download_bloc.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/files/file_bloc/file_bloc.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/files/share_bloc/share_bloc.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/home/home_bloc.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/home/home_event.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/home/home_state.dart';
import 'package:polygonid_flutter_sdk_example/utils/deploayContract.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web3modal_flutter/utils/debouncer.dart';
import 'package:web_socket_channel/io.dart';

class FileData {
  final String fileName;
  final String batchHash;
  final String fileHash;
  bool isVerified;

  FileData(this.fileName, this.batchHash, this.fileHash, this.isVerified);
}

class Files extends StatefulWidget {
  final String? did;
  final bool isBlureffect;
  const Files({super.key, required this.did, required this.isBlureffect});

  @override
  State<Files> createState() => _FilesState();
}

class _FilesState extends State<Files> {
  List<PlatformFile> selectedFiles = [];
  int size = 0;
  bool _isLoading = false;
  late final FileBloc _fileBloc;
  late final HomeBloc _homeBloc;
  late final DownloadBloc _downloadBloc;
  late final ShareBloc _shareBloc;
  String identity = '';
  final walletAddress = '';
  bool _isRequestInProgress = false;
  List<String> fileNames = [];
  List<FileData> fileDataList = [];
  List<FileData> sharedFileNames = [];
  // List<String> sharedFileNames = [];
  List<FileData> fileSharedDataList = [];
  List<dynamic> sharedDataResult = [];
  var httpClient = http.Client();
  Web3Client? _web3Client;
  var rpcUrl =
      'https://polygon-mainnet.g.alchemy.com/v2/pHKWzuctaLCPxAKYc0c8bKQA8d85oPlk';

  final _abiPath = 'assets/abi/FileStorage.json';
  final _invoiceAbiPath = 'assets/abi/BethelInvoice.json';

  final _contractAddress =
      EthereumAddress.fromHex('0x665e346D9c68587Bd51C53eAd71e0F5367E7950C');

  final _ContractAddress = '0x665e346D9c68587Bd51C53eAd71e0F5367E7950C';
  final _InvoidContractAddress = '0xB05c8A8c54DDA3E4e785FD033AB63a50e09b9521';

  List<dynamic> dataResult = []; // Store contract data as a list of lists

  String _fileCount = '0';
  String _fileUsage = '0MiB';
  bool isLoading = false;
  var _isBlureffect = false;

  @override
  void initState() {
    super.initState();
    _fileBloc = getIt<FileBloc>();
    _homeBloc = getIt<HomeBloc>();
    _downloadBloc = getIt<DownloadBloc>();
    _shareBloc = getIt<ShareBloc>();

    final storage = GetStorage();
    _deployContract();
    _initGetIdentifier();
    _deployFileCount();
    _deployShredFiles();
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

  void _showSnackbar(String message, Color? backgroundColor) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 5),
        behavior: SnackBarBehavior.floating,
        backgroundColor: backgroundColor,
      ));
    });
  }

  Future<File> saveFile(PlatformFile file) async {
    final storage = await getApplicationDocumentsDirectory();
    final newFile = File('${storage.path}/${file.name}');
    return File(file.path!).copy(newFile.path);
  }

  Future<void> _deployContract() async {
    try {
      _web3Client = Web3Client(rpcUrl, httpClient);

      final abiFile =
          await rootBundle.loadString('assets/abi/FileStorage.json');
      if (abiFile.isEmpty) throw FormatException('ABI file is empty');

      final jsonAbi = jsonDecode(abiFile);
      final _abiCode =
          ContractAbi.fromJson(jsonEncode(jsonAbi['abi']), 'FileStorage');

      final _contract = DeployedContract(_abiCode, _contractAddress);
      final _getAllBatchesFunction = _contract.function('getAllBatches');

      final storage = GetStorage();
      final walletAddress1 = storage.read('walletAddress');

      // ** Clear the current file list before fetching new data **
      setState(() {
        dataResult.clear(); // Clear the list to prevent duplication
        fileDataList.clear(); // Also clear any fileDataList if used
      });

      final result = await _web3Client?.call(
        contract: _contract,
        function: _getAllBatchesFunction,
        params: [],
        sender: EthereumAddress.fromHex(walletAddress1),
      );

      if (result!.isNotEmpty && result?[0] is List) {
        print('list result: ${result[0]}');
        setState(() {
          dataResult = List<dynamic>.from(result[0]);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            // Store the result
            _processContractResult(result[0]);
            // printLastValues(result[0]);
          });
        });
      } else {
        print('No data returned from contract or result format is unexpected');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }

  Future<void> _deployShredFiles() async {
    final fileStorageService =
        FileStorageService(rpcUrl, _ContractAddress, _abiPath);

    try {
      await fileStorageService.initializeWeb3Client();
      final did = jsonDecode(widget.did.toString());
      final contract = await fileStorageService.loadContract('FileStorage');
      final sharedFiles = await fileStorageService
          .callContractFunction(contract, 'getAllSharedFiles', []);
      print('result11:${sharedFiles![0]}');

      if (sharedFiles!.isNotEmpty && sharedFiles?[0] is List) {
        setState(() {
          sharedDataResult = List<dynamic>.from(sharedFiles[0]);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            // Store the result
            for (var batchDetails in sharedDataResult) {
              final batchHash = batchDetails[2].toString();
              final fileName = batchDetails[4].toString();
              final fileHash = batchDetails[3].toString();
              final verify = batchDetails[6].toString();
              print('Requesting shared file for batchHash: $batchHash');
              print('filehash: $fileHash');
              print('verify: $verify');
              print('fileName: $fileName');

              // _buildSharedFileList();

              setState(() {
                fileSharedDataList.add(FileData(fileName, batchHash, fileHash,
                    verify == 'true' ? true : false));
              });

              // Only fetch if this batchHash hasn't been fetched already
              // if (!fetchedBatchHashes.contains(batchHash) &&
              //     filesFetched < totalFiles) {
              //   await Future.delayed(const Duration(milliseconds: 500), () {
              //     _fileBloc.add(GetFileNameEvent(BatchHash: batchHash));
              //   });
              // }
            }
          });
        });
      } else {
        print('No data returned from contract or result format is unexpected');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }

  Future<void> _deployBatchFileContract(
      String batch_hash, String file_hash) async {
    try {
      _web3Client = Web3Client(rpcUrl, httpClient);

      final abiFile =
          await rootBundle.loadString('assets/abi/FileStorage.json');
      if (abiFile.isEmpty) throw FormatException('ABI file is empty');

      final jsonAbi = jsonDecode(abiFile);
      final _abiCode =
          ContractAbi.fromJson(jsonEncode(jsonAbi['abi']), 'FileStorage');

      final _contract = DeployedContract(_abiCode, _contractAddress);
      final _getAllBatchesFunction = _contract.function('getBatchFile');

      final storage = GetStorage();
      final walletAddress1 = storage.read('walletAddress');

      final did = jsonDecode(widget.did.toString());

      final result = await _web3Client?.call(
        contract: _contract,
        function: _getAllBatchesFunction,
        params: [did, batch_hash, file_hash],
        sender: EthereumAddress.fromHex(walletAddress1),
      );
      final walletAddress = storage.read('walletAddress');
      print('walletAddress : $walletAddress');

      if (result!.isNotEmpty) {
        // Handle result based on its type
        final index = result[0];

        // Check if result[0] is of type BigInt and convert it to String
        if (index is BigInt) {
          final indexString = index.toString();
          print('Fetched index: $indexString');

          // Dispatch event with index and wallet address
          _downloadBloc.add(GetCidsEvent(
            index: indexString,
            did: did,
            owner: walletAddress,
            batch_hash: batch_hash,
          ));
        } else {
          print('Unexpected result type: ${index.runtimeType}');
        }
      } else {
        print('No data returned from contract or result format is unexpected');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }

  Future<void> _deploysharefileContract(
      String batch_hash, String file_hash) async {
    try {
      _web3Client = Web3Client(rpcUrl, httpClient);

      final abiFile =
          await rootBundle.loadString('assets/abi/FileStorage.json');
      if (abiFile.isEmpty) throw FormatException('ABI file is empty');

      final jsonAbi = jsonDecode(abiFile);
      final _abiCode =
          ContractAbi.fromJson(jsonEncode(jsonAbi['abi']), 'FileStorage');

      final _contract = DeployedContract(_abiCode, _contractAddress);
      final _getAllBatchesFunction = _contract.function('getShareFile');

      final storage = GetStorage();
      final walletAddress1 = storage.read('walletAddress');

      final did = jsonDecode(widget.did.toString());

      final result = await _web3Client?.call(
        contract: _contract,
        function: _getAllBatchesFunction,
        params: [did, batch_hash, file_hash],
        sender: EthereumAddress.fromHex(walletAddress1),
      );
      final walletAddress = storage.read('walletAddress');
      print('walletAddress : $walletAddress');

      if (result!.isNotEmpty) {
        // Handle result based on its type
        final index = result[0];

        // Check if result[0] is of type BigInt and convert it to String
        if (index is BigInt) {
          final indexString = index.toString();
          print('Fetched index: $indexString');

          // Dispatch event with index and wallet address
          _downloadBloc.add(GetCidsEvent(
            index: indexString,
            did: did,
            owner: walletAddress,
            batch_hash: batch_hash,
          ));
        } else {
          print('Unexpected result type: ${index.runtimeType}');
        }
      } else {
        print('No data returned from contract or result format is unexpected');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }

  Future<void> _deployFileCount() async {
    final fileStorageService =
        FileStorageService(rpcUrl, _ContractAddress, _abiPath);

    try {
      await fileStorageService.initializeWeb3Client();
      final did = jsonDecode(widget.did.toString());
      final contract = await fileStorageService.loadContract('FileStorage');
      final result = await fileStorageService
          .callContractFunction(contract, 'getTotalFilesCount', []);
      print('result:${result![0]}');

      final fileSizeInBytes = (result[1] as BigInt).toInt();
      final fileSizeInMiB = fileSizeInBytes / (1024 * 1024);
      print('${fileSizeInMiB.toStringAsFixed(2)} MiB');

      setState(() {
        _fileCount = result![0].toString();
        _fileUsage = '${fileSizeInMiB.toStringAsFixed(2)}' + 'MiB';
      });
    } catch (e) {
      print('An error occurred: $e');
    }
  }

  // void printLastValues(List<dynamic> verify) {
  // for (var innerList in verify) {
  //   if (innerList.isNotEmpty) {
  //     print("verify ${innerList[5].toString()}"); // Access and print the last value of each inner list
  //   }
  // }
// }

  Future<void> _processContractResult(List<dynamic> dataResult) async {
    if (_isRequestInProgress) {
      return;
    }

    setState(() {
      _isRequestInProgress = true;
      fileDataList.clear(); // Clear the list before adding new data
    });

    // Set to store unique batch hashes and avoid duplicate requests
    Set<String> fetchedBatchHashes = {};

    // Keep track of the number of files fetched
    int filesFetched = 0;
    final totalFiles = dataResult.length;

    print('total files: $totalFiles');

    // Cancel previous listeners and use StreamSubscription to properly manage the stream
    StreamSubscription? fileBlocSubscription;

    // Subscribe to the stream and process file names
    fileBlocSubscription = _fileBloc.stream.listen((state) {
      if (state is FileNameLoaded) {
        final batchHash = state.fileName.batchHash.toString();

        // Check if the file has already been added based on batch hash
        if (!fetchedBatchHashes.contains(batchHash)) {
          setState(() {
            fileDataList.add(FileData(
                state.fileName.fileName.toString(),
                batchHash,
                state.fileName.fileHash.toString(),
                state.fileName.isVerified!));
          });

          // Mark this batch hash as fetched to prevent duplicates
          fetchedBatchHashes.add(batchHash);
          filesFetched++;
          print('File data added: ${fileDataList.last}');
        }

        // Check if all files have been fetched
        if (filesFetched >= totalFiles) {
          print('All files fetched successfully.');
          _isRequestInProgress = false;

          // Cancel the stream subscription to avoid further unnecessary listening
          fileBlocSubscription?.cancel();
        }
      }
    });

    try {
      for (var batchDetails in dataResult) {
        final batchHash = batchDetails[1].toString();
        final verify = batchDetails[4].toString();
        print('Requesting file for batchHash: $batchHash');
        print('verify: $verify');

        // Only fetch if this batchHash hasn't been fetched already
        if (!fetchedBatchHashes.contains(batchHash) &&
            filesFetched < totalFiles) {
          await Future.delayed(const Duration(milliseconds: 500), () {
            _fileBloc
                .add(GetFileNameEvent(BatchHash: batchHash, Verify: verify));
          });
        }
      }
    } catch (e) {
      print('Error processing contract result: $e');
    } finally {
      setState(() {
        _isRequestInProgress = false;
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

    while (!isSuccess) {
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

    while (!isSuccess) {
      isSuccess = await isTransactionSuccessful(txHash);

      if (isSuccess) {
        print('Transaction successful with hash: $txHash');
      } else {
        print('Transaction is not yet successful. Retrying...');
        await Future.delayed(Duration(seconds: 5)); // Poll every 5 seconds
      }
    }
  }

  Future<void> _checkSharedTxHashStatus(
      String txHash, String OwnerDid, BuildContext dialogContext) async {
    bool isSuccess = false;

    while (!isSuccess) {
      isSuccess = await isTransactionSuccessful(txHash);

      if (isSuccess) {
        print('Transaction successful with hash: $txHash');
        print('shared did: $OwnerDid');
        print('my did: ${jsonDecode(widget.did.toString())}');
        final String did = jsonDecode(widget.did.toString());

        if (OwnerDid.characters == did.characters) {
          print('ok');
          _showSnackbar('File shared successfully',
              Theme.of(context).colorScheme.secondary);
          // Close the AlertDialog after DIDs match
          Navigator.of(dialogContext).pop(); // Close the dialog
        } else {
          print('not ok');
          _showSnackbar('File is not shared successfully', Colors.red);
        }

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
    final walletAddress = storage.read('walletAddress');
    print('walletAddress : $walletAddress');

    return BlocProvider(
      create: (_) => _fileBloc,
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: SafeArea(
          child: BlocConsumer<FileBloc, FileState>(
            listener: (context, state) async {
              if (state is FileUploadFailed) {
                _showSnackbar("File Upload Failed", Colors.red);
              }
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

                _showSnackbar('Files uploaded successfully',
                    Theme.of(context).colorScheme.secondary);

                setState(() {
                  fileDataList.clear(); // Clear old file data
                });

                // // Wait for a few seconds before re-fetching contract data
                // await Future.delayed(Duration(seconds: 3));

                // Fetch new files from the contract
                _deployContract();
                _deployFileCount();
              }
            },
            builder: (context, state) {
              return Stack(
                children: [
                  Column(
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 10),
                      _buildFileSelectionButton(),
                      const SizedBox(height: 20),
                      DefaultTabController(
                          length: 2,
                          animationDuration: const Duration(milliseconds: 500),
                          child: _buildTabView()),
                      // _buildFileList(),
                      const SizedBox(height: 20),
                      _fileUpoading(),
                      const SizedBox(height: 20),
                    ],
                  ),
                  if (widget.isBlureffect) // Replace with a condition when you want the blur effect
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                color: Colors.black.withOpacity(0.1), // Optional dark overlay
              ),
            ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTabView() {
    return Expanded(
      child: Column(
        children: [
          const TabBar(
            indicatorSize: TabBarIndicatorSize.label,
            dividerColor: Colors.black,
            tabs: [
              Tab(text: 'Uploaded'),
              Tab(text: 'Shared'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildFileList(),
                _buildSharedFileList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _fileUpoading() {
    return BlocBuilder<FileBloc, FileState>(
      bloc: _fileBloc,
      builder: (context, state) {
        if (state is FileUploading) {
          return Center(
            child: Loading(
              Loadingcolor: Theme.of(context).primaryColor,
              color: Theme.of(context).colorScheme.secondary,
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  // Method to refresh the file list
  Future<void> _refreshFileList() async {
    setState(() {
      fileDataList.clear();
      fileSharedDataList.clear();
    });

    await _deployContract();
    await _deployFileCount();
    await _deployShredFiles();
  }

  Widget _buildFileList() {
    return Stack(
      children: [
        LiquidPullToRefresh(
          backgroundColor: Theme.of(context).primaryColor,
          // height: 50,
          color: Theme.of(context).colorScheme.primary,
          animSpeedFactor: 2.0,
          onRefresh: _refreshFileList,
          child: fileDataList.isNotEmpty
              ? ListView.builder(
                  itemCount: fileDataList.length,
                  itemBuilder: (context, index) {
                    final fileData = fileDataList[index];

                    print('batchHash: ${fileData.batchHash}');
                    print('fileHash: ${fileData.fileHash}');
                    print('fileName: ${fileData.fileName}');
                    print('isVerified: ${fileData.isVerified}');
                    return ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              fileData.fileName,
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
                                child: _buildVerifyButton(
                                  fileData.batchHash,
                                  fileData.isVerified,
                                  fileData.fileHash,
                                  fileData.fileName,
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              SizedBox(
                                child: _buildDownloadIcon(fileData.batchHash,
                                    fileData.fileHash, fileData.fileName),
                              ),
                              SizedBox(width: 20),
                              SizedBox(
                                child: _buildShareIcon(
                                  fileData.batchHash,
                                  fileData.fileHash,
                                  fileData.fileName,
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
                    'No files Uploaded',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: GoogleFonts.robotoMono().fontFamily,
                    ),
                  ),
                ),
        ),
        // Blur effect overlay
        // if (isLoading)
        //   BackdropFilter(
        //     filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
        //     child: Container(
        //       color: Colors.black.withOpacity(0.5), // Dark overlay
        //       child: Center(
        //         child: CircularProgressIndicator(),
        //       ),
        //     ),
        //   ),
      ],
    );
  }

  Widget _buildSharedFileList() {
    return Stack(
      children: [
        LiquidPullToRefresh(
          backgroundColor: Theme.of(context).primaryColor,
          // height: 50,
          color: Theme.of(context).colorScheme.primary,
          animSpeedFactor: 2.0,
          onRefresh: _refreshFileList,
          child: fileSharedDataList.isNotEmpty
              ? ListView.builder(
                  itemCount: fileSharedDataList.length,
                  itemBuilder: (context, index) {
                    final fileData = fileSharedDataList[index];
                    return ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              fileData.fileName,
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
                                child: _buildSharedVerifyButton(
                                    fileData.batchHash,
                                    fileData.isVerified,
                                    fileData.fileHash,
                                    fileData.fileName),
                              ),
                              SizedBox(width: 20),
                              SizedBox(
                                // width: 20,
                                child: _buildShareDownloadIcon(
                                    fileData.batchHash,
                                    fileData.fileHash,
                                    fileData.fileName),
                              ),

                              // SizedBox(width: 10),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                )
              : Center(
                  child: Text(
                    'No files shared',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: GoogleFonts.robotoMono().fontFamily,
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  void _handleDownloadVerifyButton(
      DownloadSuccess state, String batchHash) async {
    final response = jsonEncode(state.response.toJson());
    final sessionId = state.response.sessionId.toString();
    print('sessionId download : $sessionId');
    print('download response: $response');

    _downloadBloc.add(onDownloadResponse(response, batchHash));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _downloadBloc.add(onGetDownloadStatusEvent(sessionId, batchHash));
    });
  }

  Widget _buildShareIcon(String BatchHash, String FileHash, String FileName) {
    return GestureDetector(
      onTap: () {
        print('tap share');
        _showShareInput(context, BatchHash, FileHash, FileName);
      },
      child: _buildIcon(
        Icons.share,
        Theme.of(context).colorScheme.secondary,
        Theme.of(context).colorScheme.secondary,
        Colors.white,
      ),
    );
  }

  void _showShareBottomSheet(BuildContext context, String batchHash,
      String fileHash, String fileName) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize
                .min, // Ensures the bottom sheet takes the minimum height necessary
            children: [
              Text(
                'Share File',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 16),
              Text('Batch Hash: $batchHash'),
              Text('File Hash: $fileHash'),
              Text('File Name: $fileName'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Implement the sharing logic here
                  Navigator.pop(
                      context); // Close the bottom sheet after sharing
                },
                child: const Text('Share'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showShareInput(BuildContext context, String batchHash,
      String fileHash, String fileName) async {
    var pasteDid = TextEditingController();
    final storage = GetStorage();
    final walletAddress = storage.read('walletAddress');
    print('walletAddress : $walletAddress');

    showModalBottomSheet(
      backgroundColor:
          Colors.transparent, // Set to transparent to allow the gradient
      context: context,
      isScrollControlled: true, // Allows the bottom sheet to take up more space
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.3, // Initial height
          maxChildSize: 0.9, // Max height when dragged
          minChildSize: 0.3, // Minimum height when collapsed
          builder: (BuildContext context, ScrollController scrollController) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 68, 91, 0),
                    Theme.of(context).primaryColor,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    mainAxisSize:
                        MainAxisSize.min, // Adjust height based on content
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width / 4,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .secondaryHeaderColor
                                .withOpacity(0.5),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          margin: const EdgeInsets.only(top: 5),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: pasteDid,
                        enabled: true,
                        decoration: InputDecoration(
                          labelText: 'Paste your Share DID here',
                          labelStyle: TextStyle(
                            color: Colors.white.withOpacity(0.4),
                            fontFamily: GoogleFonts.robotoMono().fontFamily,
                            fontSize: 13,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red.withOpacity(0.4),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      BlocBuilder<ShareBloc, ShareState>(
                        bloc: _shareBloc,
                        builder: (context, state) {
                          if (state is Sharing) {
                            return Center(
                              child: Loading(
                                Loadingcolor: Theme.of(context).primaryColor,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            );
                          }
                          if (state is ShareFailed) {
                            _showSnackbar(
                                'Share failed: ${state.message}', Colors.red);
                          }
                          if (state is Shared) {
                            // Call the transaction hash check method
                            _checkSharedTxHashStatus(state.response.tXHash!,
                                state.response.ownerDid!, context);

                            Future.delayed(const Duration(seconds: 10), () {
                              _shareBloc.add(ResetShareStateEvent());
                            });
                          }
                          return Center(
                            child: GestureDetector(
                                onTap: () {
                                  _shareBloc.add(onClickShare(
                                    FileName: fileName,
                                    OwnerDid: jsonDecode(widget.did.toString()),
                                    ShareDid: pasteDid.text,
                                    Owner: walletAddress,
                                    file_hash: fileHash,
                                    batch_hash: batchHash,
                                  ));
                                },
                                child: TransperantButton(
                                    text: 'Share',
                                    width:
                                        MediaQuery.of(context).size.width / 4)),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _showDownloadUrl(BuildContext context, Uri url) async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows for more content control
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.transparent, // Customize background
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height / 3,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 68, 91, 0),
                Theme.of(context).primaryColor,
              ], // Add your gradient colors here
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context)
                  .viewInsets
                  .bottom, // Handle keyboard overlap
              left: 16,
              right: 16,
              top: 16,
            ),
            child: Column(
              children: [
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width / 4,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .secondaryHeaderColor
                          .withOpacity(0.5),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    margin: const EdgeInsets.only(top: 5),
                  ),
                ),
                const SizedBox(height: 20),
                Column(
                  mainAxisSize:
                      MainAxisSize.min, // Minimize height based on content
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Now You can Download File',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).secondaryHeaderColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                        onTap: () => setState(() {
                              launchUrl(url,
                                  mode: LaunchMode.externalApplication);
                            }),
                        child: TransperantButton(
                            text: 'Click here to Download File',
                            width: MediaQuery.of(context).size.width)),
                    const SizedBox(height: 20),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  

  Widget _buildurlLink(String url) {
    return GestureDetector(
      onTap: () {
        print('url: $url');
      },
      child: _buildIcon(
        Icons.link,
        Theme.of(context).colorScheme.secondary,
        Theme.of(context).colorScheme.secondary,
        Colors.white,
      ),
    );
  }

  Widget _buildVerifyButton(
      String batchHash, bool isVerified, String fileHash, String fileName) {
    print('bathash: $batchHash');
    return BlocBuilder<FileBloc, FileState>(
      bloc: _fileBloc,
      builder: (context, filestate) {
        // return BlocBuilder<DownloadBloc, DownloadState>(
        //   bloc: _downloadBloc,
        //   builder: (context, downloadState) {
        if (filestate is Fileverifying && filestate.batchhash == batchHash) {
          return Center(
            child: Loading(
                Loadingcolor: Theme.of(context).primaryColor,
                color: Theme.of(context).colorScheme.secondary),
          );
        }
        if (filestate is FileVerifyFailed) {
          _showSnackbar('Verify failed: ${filestate.message}', Colors.red);
        }
        if (filestate is VerifySuccess && filestate.batchhash == batchHash) {
          final response = jsonEncode(filestate.response.claim?.toJson());
          print("response verify: $response");
          _handleVerifyResponseSuccess(filestate, filestate.batchhash);
        }
        if (filestate is VerifyResponseloaded &&
            filestate.batchhash == batchHash) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _handleVerified(filestate.iden3message, filestate.batchhash);
          });
        }
        if (filestate is VerifiedClaims && filestate.batchhash == batchHash) {
          // _showSnackbar('File is Verified successfully:',
          //     Theme.of(context).colorScheme.secondary);
          // _buildFileList(true);
          isVerified = true;
        }

        return GestureDetector(
          onTap: () {
            final did = jsonDecode(widget.did.toString());
            final storage = GetStorage();
            final walletAddress = storage.read('walletAddress');
            _fileBloc.add(VerifyUploadEvent(
              BatchHash: batchHash,
              ownerDid: walletAddress,
              did: did,
            ));
          },
          child: Visibility(
            visible: !isVerified, // If not verified, button is visible
            child: _buildButton(
              "Verify",
              Colors.redAccent[700],
              Colors.redAccent[700],
              Theme.of(context).primaryColor,
            ),
          ),
        );
        // },
        // );
      },
    );
  }

  Widget _buildSharedVerifyButton(
      String batchHash, bool isVerified, String fileHash, String fileName) {
    print('bathash: $batchHash');
    return BlocBuilder<ShareBloc, ShareState>(
      bloc: _shareBloc,
      builder: (context, shareState) {
        if (shareState is ShareVerifying && shareState.batchhash == batchHash) {
          return Center(
            child: Loading(
                Loadingcolor: Theme.of(context).primaryColor,
                color: Theme.of(context).colorScheme.secondary),
          );
        }
        if (shareState is ShareFailed) {
          _showSnackbar('Verify failed: ${shareState.message}', Colors.red);
        }
        if (shareState is ShareVerifySuccess &&
            shareState.batchhash == batchHash) {
          final response = jsonEncode(shareState.response);
          print("response share verify: $response");
          _handleShareVerifyResponseSuccess(shareState, shareState.batchhash);
        }
        if (shareState is ShareVerifyResponseloaded &&
            shareState.batchhash == batchHash) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _handleShareVerified(shareState.iden3message, shareState.batchhash);
          });
        }
        if (shareState is ShareVerifiedClaims &&
            shareState.batchhash == batchHash) {
          // _showSnackbar('File id Verified successfully:',
          //     Theme.of(context).colorScheme.secondary);
          // _buildFileList(true);
          isVerified = true;
        }

        return GestureDetector(
          onTap: () {
            final did = jsonDecode(widget.did.toString());
            final storage = GetStorage();
            final walletAddress = storage.read('walletAddress');
            _shareBloc.add(ShareVerifyEvent(
                BatchHash: batchHash,
                FileHash: fileHash,
                Did: did,
                OwnerAddress: walletAddress));
          },
          child: Visibility(
            visible: !isVerified, // If not verified, button is visible
            child: _buildButton(
              "Verify",
              Colors.redAccent[700],
              Colors.redAccent[700],
              Theme.of(context).primaryColor,
            ),
          ),
        );
      },
    );
  }

  Widget _buildDownloadIcon(
      String batchHash, String fileHash, String fileName) {
    return BlocBuilder<DownloadBloc, DownloadState>(
      bloc: _downloadBloc,
      builder: (BuildContext context, DownloadState downloadState) {
        if (downloadState is Downloading &&
            downloadState.batchhash == batchHash) {
          // Return CircularProgressIndicator when downloading
          return Center(
              child: Loading(
                  Loadingcolor: Theme.of(context).primaryColor,
                  color: Theme.of(context).colorScheme.secondary));
        }

        if (downloadState is DownloadSuccess &&
            downloadState.batchhash == batchHash) {
          print('downloadState batch:${downloadState.batchhash}');
          _handleDownloadVerifyButton(downloadState, downloadState.batchhash);
        }
        if (downloadState is DownloadFailed) {
          _showSnackbar('Download failed', Colors.red);
        }

        if (downloadState is StatusLoaded &&
            downloadState.batchhash == batchHash) {
          print('status loaded in download');
          print('downloadState batch1:${downloadState.batchhash}');
          // _showSnackbar(
          //     'status loaded', Theme.of(context).colorScheme.secondary);
          _deployBatchFileContract(batchHash, fileHash);
        }

        if (downloadState is CidsGot && downloadState.batchhash == batchHash) {
          print('cids got');
          final cidString = downloadState.cids.cids;
          final cidList = jsonEncode(cidString);
          final cidGot = jsonEncode(cidList);

          print('responsse cids got1: $cidGot');
          print('responsse cids got: $cidList');

          print('download1 : $batchHash');
          print('download2 : $batchHash');
          print('download3 : $fileName');
          print('download4 : $cidList');
          print('download5 : ${jsonDecode(widget.did.toString())}');

          _downloadBloc.add(onClickDownloadUrl(
              BatchHash: batchHash,
              FileHash: batchHash,
              Odid: jsonDecode(widget.did.toString()),
              FileName: fileName.toString(),
              Cids: cidList));

          // _showSnackbar(
          //     'cids got', Theme.of(context).colorScheme.secondary);
        }

        if (downloadState is DownloadUrlSuccess &&
            downloadState.batchhash == batchHash) {
          // Timer(Duration(seconds: 30), () {
          //   _downloadBloc.add(ResetDownloadStateEvent());
          //   _fileBloc.add(ResetFileStateEvent());
          //   _showSnackbar('Time out', Colors.red);
          // });

          final url = downloadState.response.uRL;
          final downloadLink = Uri.parse(url as String);
          // _showSnackbar('${downloadState.response.uRL}',
          //     Theme.of(context).colorScheme.secondary);
          print('download url success: ${downloadState.response.uRL}');

          Future.delayed(const Duration(seconds: 10), () {
            _downloadBloc.add(ResetDownloadStateEvent());
            // _fileBloc.add(ResetFileStateEvent());
          });

          
          // Show download URL after URL is ready
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            await _showDownloadUrl(context, downloadLink);
          });
        }

        // Default return for other states
        return GestureDetector(
          onTap: () {
            _downloadBloc.add(onClickDownload(
                batch_hash: batchHash,
                file_hash: batchHash,
                didU: jsonDecode(widget.did.toString())));
          },
          child: _buildIcon(
            Icons.download,
            Theme.of(context).colorScheme.secondary,
            Theme.of(context).colorScheme.secondary,
            Colors.white,
          ),
        );
      },
    );
  }

  Widget _buildShareDownloadIcon(
      String batchHash, String fileHash, String fileName) {
    return BlocBuilder<DownloadBloc, DownloadState>(
      bloc: _downloadBloc,
      builder: (BuildContext context, DownloadState downloadState) {
        if (downloadState is Downloading &&
            downloadState.batchhash == batchHash) {
          // Return CircularProgressIndicator when downloading
          return Center(
              child: Loading(
                  Loadingcolor: Theme.of(context).primaryColor,
                  color: Theme.of(context).colorScheme.secondary));
        }

        if (downloadState is DownloadSuccess &&
            downloadState.batchhash == batchHash) {
          print('downloadState batch:${downloadState.batchhash}');
          _handleDownloadVerifyButton(downloadState, downloadState.batchhash);
        }
        if (downloadState is DownloadFailed) {
          _showSnackbar('Download failed', Colors.red);
        }

        if (downloadState is StatusLoaded &&
            downloadState.batchhash == batchHash) {
          print('status loaded in download');
          print('downloadState batch1:${downloadState.batchhash}');

          _deploysharefileContract(batchHash, fileHash);
        }

        if (downloadState is CidsGot && downloadState.batchhash == batchHash) {
          print('cids got');
          final cidString = downloadState.cids.cids;
          final cidList = jsonEncode(cidString);
          final cidGot = jsonEncode(cidList);

          print('responsse share cids got1: $cidGot');
          print('responsse share cids got: $cidList');

          print('download1 share: $batchHash');
          print('download2 share: $batchHash');
          print('download3 share: $fileName');
          print('download4 share: $cidList');
          print('download5 share: ${jsonDecode(widget.did.toString())}');

          _downloadBloc.add(onClickDownloadUrl(
              BatchHash: batchHash,
              FileHash: batchHash,
              Odid: jsonDecode(widget.did.toString()),
              FileName: fileName.toString(),
              Cids: cidList));
        }

        if (downloadState is DownloadUrlSuccess &&
            downloadState.batchhash == batchHash) {
          final url = downloadState.response.uRL;
          final downloadLink = Uri.parse(url as String);

          print('download url success: ${downloadState.response.uRL}');

          Future.delayed(const Duration(seconds: 10), () {
            _downloadBloc.add(ResetDownloadStateEvent());
          });

          WidgetsBinding.instance.addPostFrameCallback((_) async {
            await _showDownloadUrl(context, downloadLink);
          });
        }

        // Default return for other states
        return GestureDetector(
          onTap: () {
            _downloadBloc.add(onClickDownload(
                batch_hash: batchHash,
                file_hash: batchHash,
                didU: jsonDecode(widget.did.toString())));
          },
          child: _buildIcon(
            Icons.download,
            Theme.of(context).colorScheme.secondary,
            Theme.of(context).colorScheme.secondary,
            Colors.white,
          ),
        );
      },
    );
  }

  Future<void> _handleVerified(
      Iden3MessageEntity iden3message, String batchHash) async {
    debugPrint('File is verified');
    _fileBloc.add(fetchAndSaveUploadVerifyClaims(
        iden3message: iden3message, batchHash: batchHash));
  }

  void _handleVerifyResponseSuccess(
      VerifySuccess state, String batchHash) async {
    final response = jsonEncode(state.response.claim?.toJson());
    final txhashResponse = state.response.txHash;
    await _checkUseSpaceTxHashStatus(txhashResponse!);

    print('get verify response: $response');

    _fileBloc.add(onVerifyResponse(response, batchHash));
  }

  void _handleShareVerifyResponseSuccess(
      ShareVerifySuccess state, String batchHash) async {
    final response = jsonEncode(state.response);

    print('get share verify response: $response');

    _shareBloc.add(onShareVerifyResponse(response, batchHash));
  }

  Future<void> _handleShareVerified(
      Iden3MessageEntity iden3message, String batchHash) async {
    debugPrint('share File is verified');
    _shareBloc.add(fetchAndSaveShareVerifyClaims(
        iden3message: iden3message, batchHash: batchHash));
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
    String text,
    dynamic colorScheme,
    dynamic border,
    dynamic textColor,
    // bool isEnabled = true,
  ) {
    return GestureDetector(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
        decoration: BoxDecoration(
          color: colorScheme, // Grey out if disabled
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: border,
            width: 2,
          ),
        ),
        child: Text(
          text,
          style: GoogleFonts.robotoMono(
            color: textColor, // Grey text if disabled
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
        onTap: () {
          _refreshFileList();
        },
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
            Icons.refresh,
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
            _buildFileInfoColumn(_fileCount, 'Upload Files'),
            _buildFileInfoColumn(_fileUsage, 'Upload Usage'),
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
                      ? Center(
                          child: Loading(
                              Loadingcolor: Theme.of(context).primaryColor,
                              color: Theme.of(context).colorScheme.secondary))
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
