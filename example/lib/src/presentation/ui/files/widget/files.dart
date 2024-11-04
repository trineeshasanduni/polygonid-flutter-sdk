import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:ui';
import 'package:dio/dio.dart';
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
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
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
import 'package:animated_snack_bar/animated_snack_bar.dart';

class FileData {
  final String fileName;
  final String batchHash;
  final String fileHash;
  bool isVerified;

  FileData(this.fileName, this.batchHash, this.fileHash, this.isVerified);
}

class FileBatchData {
  final String batchHash;
  final List<FileData> files;

  FileBatchData(this.batchHash, this.files);
}

class Files extends StatefulWidget {
  final String? did;
  // final bool isBlureffect;
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
  late final DownloadBloc _downloadBloc;
  late final ShareBloc _shareBloc;
  String identity = '';
  final walletAddress = '';
  bool _isRequestInProgress = false;
  List<String> fileNames = [];
  List<FileData> fileDataList = [];
  List<FileBatchData> fileBatchList = [];
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

  Map<String, bool> verificationStatus = {};

  var progress = 0.0;

  Set<String> expandedBatches = {}; // To track which batches are expanded

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

  // Future<void> openFile() async {
  //   final result = await FilePicker.platform.pickFiles(allowMultiple: true);
  //   if (result != null) {
  //     setState(() {
  //       selectedFiles = result.files;
  //       // size = result.files.single.size;
  //       // print('size: $size');
  //     });
  //     _uploadFiles();
  //   }
  // }
  Future<void> openFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      // Calculate the total size of all selected files
      // int totalSize = 0;
      for (var file in result.files) {
        size += file.size; // Add each file's size to totalSize
        print(
            'File: ${file.name}, Size: ${file.size} bytes'); // Print each file's name and size
      }

      print('Total size of selected files: $size bytes');

      setState(() {
        selectedFiles = result.files;
        print('selectedFiles: $selectedFiles');
      });

      _uploadFiles(); // Call upload function after setting selected files
    }
  }

  Future<void> _uploadFiles() async {
    // Get the identity from the BLoC
    String identity = '';
    _homeBloc.stream.listen((state) {
      identity = state.identifier as String;
      print('identity checking: $identity');
    });

    final storage = GetStorage();
    final walletAddress = storage.read('walletAddress');
    print('walletAddress: $walletAddress');

    setState(() {
      _isLoading = true;
    });

    try {
      final did = jsonDecode(widget.did.toString());
      print('did: $did');

      // Collect all files to upload
      List<File> filesToUpload = [];

      for (var file in selectedFiles) {
        final fileToSave = await saveFile(file);
        filesToUpload.add(fileToSave); // Add each file to the list
        print('fileToSave: $fileToSave');
      }

      // Perform a single upload with all files
      if (filesToUpload.isNotEmpty) {
        _fileBloc.add(FileuploadEvent(
          did: did,
          ownerDid: walletAddress,
          fileData: filesToUpload, // Send all files in a single request
        ));
        print('filesToUpload: $filesToUpload');
      } else {
        print('No files to upload.');
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

  void _showSnackbar(
    String message,
    Color? backgroundColor,
    IconData? ic,
  ) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(
          children: [
            Icon(ic, color: Colors.white),
            const SizedBox(width: 10),
            Text(message, style: const TextStyle(color: Colors.white)),
          ],
        ),
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

/////////////////// smart contract function ///////////////////
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
            processContractResult(result[0]);
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
              fileHash: file_hash));
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
              fileHash: file_hash));
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

  // Future<void> processContractResult(List<dynamic> dataResult) async {
  //   if (_isRequestInProgress) {
  //     return;
  //   }

  //   setState(() {
  //     _isRequestInProgress = true;
  //     fileDataList.clear(); // Clear the list before adding new data
  //   });

  //   // Set to store unique batch hashes and avoid duplicate requests
  //   Set<String> fetchedBatchHashes = {};

  //   // Keep track of the number of files fetched
  //   int filesFetched = 0;
  //   final totalFiles = dataResult.length;

  //   print('total files: $totalFiles');

  //   // Cancel previous listeners and use StreamSubscription to properly manage the stream
  //   StreamSubscription? fileBlocSubscription;

  //   // Subscribe to the stream and process file names
  //   fileBlocSubscription = _fileBloc.stream.listen((state) {
  //     if (state is FileNameLoaded) {
  //       final batchHash = state.fileName.batchHash.toString();

  //       // Check if the file has already been added based on batch hash
  //       if (!fetchedBatchHashes.contains(batchHash)) {
  //         setState(() {
  //           fileDataList.add(FileData(
  //               state.fileName.fileName.toString(),
  //               batchHash,
  //               state.fileName.fileHash.toString(),
  //               state.fileName.isVerified!));
  //         });

  //         // Mark this batch hash as fetched to prevent duplicates
  //         fetchedBatchHashes.add(batchHash);
  //         filesFetched++;
  //         print('File data added: ${fileDataList.last}');
  //       }

  //       // Check if all files have been fetched
  //       if (filesFetched >= totalFiles) {
  //         print('All files fetched successfully.');
  //         _isRequestInProgress = false;

  //         // Cancel the stream subscription to avoid further unnecessary listening
  //         fileBlocSubscription?.cancel();
  //       }
  //     }
  //   });

  //   try {
  //     for (var batchDetails in dataResult) {
  //       final batchHash = batchDetails[1].toString();
  //       final verify = batchDetails[4].toString();
  //       print('Requesting file for batchHash: $batchHash');
  //       print('verify: $verify');

  //       // Only fetch if this batchHash hasn't been fetched already
  //       if (!fetchedBatchHashes.contains(batchHash) &&
  //           filesFetched < totalFiles) {
  //         await Future.delayed(const Duration(milliseconds: 500), () {
  //           _fileBloc
  //               .add(GetFileNameEvent(BatchHash: batchHash, Verify: verify));
  //         });
  //       }
  //     }
  //   } catch (e) {
  //     print('Error processing contract result: $e');
  //   } finally {
  //     setState(() {
  //       _isRequestInProgress = false;
  //     });
  //   }
  // }

  Future<void> processContractResult(List<dynamic> dataResult) async {
    if (_isRequestInProgress) return;

    setState(() {
      _isRequestInProgress = true;
      fileDataList.clear(); // Clear the list before adding new data
    });

    // Map to hold lists of files per batch hash
    Map<String, List<FileData>> batchFileDataMap = {};

    // Count files fetched to know when all files have been processed
    int filesFetched = 0;
    final totalFiles = dataResult.length;

    print('total files: $totalFiles');

    // Cancel previous listeners and use StreamSubscription to manage the stream
    StreamSubscription? fileBlocSubscription;
    fileBlocSubscription = _fileBloc.stream.listen((state) {
      if (state is FileNameLoaded) {
        // Process each file in the response (in case there are multiple files per batch hash)
        for (var file in state.fileName) {
          final batchHash = file.batchHash;

          // Initialize the list for this batch hash if it doesn't exist
          if (!batchFileDataMap.containsKey(batchHash)) {
            batchFileDataMap[batchHash!] = [];
          }

          // Check for duplicate file entries within the same batch hash
          if (!batchFileDataMap[batchHash]!
              .any((existingFile) => existingFile.fileHash == file.fileHash)) {
            // Add the file to the list for this batch hash
            batchFileDataMap[batchHash]!.add(FileData(
              file.fileName!,
              batchHash!,
              file.fileHash!,
              file.isVerified!,
            ));

            filesFetched++;
            print('File data added: ${batchFileDataMap[batchHash]!.last}');
          }
        }

        // Check if all files have been fetched
        if (filesFetched >= totalFiles) {
          print('All files fetched successfully.');
          _isRequestInProgress = false;

          // Update fileDataList by combining all batches into a single list for display
          setState(() {
            fileBatchList = batchFileDataMap.entries
                .map((entry) => FileBatchData(entry.key, entry.value))
                .toList();
          });

          // Cancel the stream subscription
          fileBlocSubscription?.cancel();
        }
      }
    });

    try {
      for (var batchDetails in dataResult) {
        final batchHash = batchDetails[1].toString();
        final verify = batchDetails[4].toString();
        print('Requesting file for batchHash: $batchHash, verify: $verify');

        // Only fetch if this batchHash hasn't been fetched already
        if (!batchFileDataMap.containsKey(batchHash) &&
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

  /////check transaction status //////////////////////////

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

        // Show the snackbar for failed or pending transaction
        final snackBar = SnackBar(
          content: Text('Transaction failed or still pending.'),
          backgroundColor: Colors.yellow,
          duration: Duration(seconds: 10), // Display snackbar for 10 seconds
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);

        // Wait for 10 seconds before dismissing
        Future.delayed(Duration(seconds: 10), () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        });

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
              Theme.of(context).colorScheme.secondary, Icons.check_circle);
          // Close the AlertDialog after DIDs match
          Navigator.of(dialogContext).pop(); // Close the dialog
        } else {
          print('not ok');
          _showSnackbar('File is not shared successfully', Colors.red,
              Icons.error_outline);
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

    final isFreePlan = storage.read('isFreePlanActivated');
    print('isFreePlan: $isFreePlan');

    return BlocProvider(
      create: (_) => _fileBloc,
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: SafeArea(
          child: BlocConsumer<FileBloc, FileState>(
            listener: (context, state) async {
              if (state is FileUploadFailed) {
                _showSnackbar("File Upload Failed", Colors.red, Icons.error);
              }
              if (state is FileUploaded) {
                print('count:${state.response.FileCount}');
                print('txHash:${state.response.TXHash}');
                if (state.response.FileCount == 1) {
                  // for (var file in dataResult) {
                  //   print('object file: $file');
                  // }
                  await _checkTxHashStatus(
                      state.response.TXHash!, walletAddress, size);

                  print('dataResult: $dataResult');
                } else if (state.response.FileCount! > 1) {
                  print('txHash muilti:${state.response.TXHash}');
                  print('txHash wallet:${walletAddress}');
                  print('txHash size:${size}');
                  await _checkTxHashStatus(
                      state.response.TXHash!, walletAddress, size);
                }
              }
              if (state is FileUsingSpaced) {
                print('fetching space state: ${state.txHash}');
                String txHash = state.txHash.TXHash!;
                await _checkUseSpaceTxHashStatus(txHash);

                _showSnackbar(
                    'Files uploaded successfully',
                    Theme.of(context).colorScheme.secondary,
                    Icons.check_circle);

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
                      _progress(),
                      const SizedBox(height: 20),
                    ],
                  ),
                  if (isFreePlan == null ||
                      isFreePlan ==
                          false) // Replace with a condition when you want the blur effect
                    BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                      child: Container(
                        color: Colors.black
                            .withOpacity(0.1), // Optional dark overlay
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
                buildFileList(),
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
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                state.message,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 10),
              LoadingAnimationWidget.progressiveDots(
                color: Theme.of(context).colorScheme.secondary,
                size: 30.0,
              )
            ],
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

  Widget buildFileList() {
    return Stack(
      children: [
        LiquidPullToRefresh(
          backgroundColor: Theme.of(context).primaryColor,
          color: Theme.of(context).colorScheme.primary,
          animSpeedFactor: 2.0,
          onRefresh: _refreshFileList,
          child: fileBatchList.isNotEmpty
              ? ListView.builder(
                  itemCount: fileBatchList.length,
                  itemBuilder: (context, index) {
                    final batchData = fileBatchList.reversed.elementAt(index);
                    final hasMultipleFiles = batchData.files.length > 1;

                    return Column(
                      children: [
                        hasMultipleFiles
                            ? GestureDetector(
                                onTap: () {
                                  setState(() {
                                    // Toggle the expanded state of this batch
                                    if (expandedBatches
                                        .contains(batchData.batchHash)) {
                                      expandedBatches
                                          .remove(batchData.batchHash);
                                    } else {
                                      expandedBatches.add(batchData.batchHash);
                                    }
                                  });
                                },
                                child: AnimatedContainer(
                                  curve: Curves.bounceIn,
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.5),
                                    // borderRadius: BorderRadius.circular(8),
                                  ),
                                  duration: Duration(milliseconds: 600),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Batch: ${batchData.batchHash}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Icon(
                                        expandedBatches
                                                .contains(batchData.batchHash)
                                            ? Icons.expand_less
                                            : Icons.expand_more,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : _fileButtons(
                                batchData, Theme.of(context).primaryColor),
                        // Show filenames only if the batch has multiple files and is expanded
                        if (hasMultipleFiles &&
                            expandedBatches.contains(batchData.batchHash))
                          _fileButtons(
                              batchData,
                              Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.1))
                      ],
                    );
                  },
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/empty.png',
                          width: 100, height: 100),
                      const SizedBox(height: 20),
                      Text(
                        'No files Uploaded',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: GoogleFonts.robotoMono().fontFamily,
                        ),
                      ),
                    ],
                  ),
                ),
        ),
        // Optional Blur effect overlay
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

  Widget _fileButtons(FileBatchData batchData, Color tileColor) {
    return Column(
      children: batchData.files.map((fileData) {
        return ListTile(
          tileColor: tileColor,
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
                      batchData.batchHash,
                      fileData.isVerified,
                      fileData.fileHash,
                      fileData.fileName,
                    ),
                  ),
                  SizedBox(width: 20),
                  SizedBox(
                    child: _buildDownloadIcon(
                      batchData.batchHash,
                      fileData.fileHash,
                      fileData.fileName,
                    ),
                  ),
                  SizedBox(width: 20),
                  SizedBox(
                    child: _buildShareIcon(
                      batchData.batchHash,
                      fileData.fileHash,
                      fileData.fileName,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSharedFileList() {
    return Stack(
      children: [
        LiquidPullToRefresh(
          backgroundColor: Theme.of(context).primaryColor,
          color: Theme.of(context).colorScheme.primary,
          animSpeedFactor: 2.0,
          onRefresh: _refreshFileList,
          child: fileSharedDataList.isNotEmpty
              ? ListView.builder(
                  itemCount: fileSharedDataList.length,
                  itemBuilder: (context, index) {
                    final fileData = fileSharedDataList.reversed
                        .elementAt(index); // Accessing in reverse order
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
                                  fileData.fileName,
                                ),
                              ),
                              SizedBox(width: 20),
                              SizedBox(
                                child: _buildShareDownloadIcon(
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/empty.png',
                          width: 100, height: 100),
                      const SizedBox(height: 20),
                      Text(
                        'No files shared',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: GoogleFonts.robotoMono().fontFamily,
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ],
    );
  }

  void _handleDownloadVerifyButton(
      DownloadSuccess state, String batchHash, String fileHash) async {
    final response = jsonEncode(state.response.toJson());
    final sessionId = state.response.sessionId.toString();
    print('sessionId download : $sessionId');
    print('download response: $response');

    _downloadBloc.add(onDownloadResponse(response, batchHash, fileHash));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _downloadBloc
          .add(onGetDownloadStatusEvent(sessionId, batchHash, fileHash));
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
                            _showSnackbar('Share failed: ${state.message}',
                                Colors.red, Icons.error);
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

    verificationStatus.putIfAbsent(fileHash, () => false);
    return BlocBuilder<FileBloc, FileState>(
      bloc: _fileBloc,
      builder: (context, filestate) {
        // return BlocBuilder<DownloadBloc, DownloadState>(
        //   bloc: _downloadBloc,
        //   builder: (context, downloadState) {
        if (filestate is Fileverifying &&
            filestate.file_hash == fileHash &&
            filestate.batchhash == batchHash) {
          print('fileHash1: ${filestate.file_hash}');
          return Center(
            child: Loading(
                Loadingcolor: Theme.of(context).primaryColor,
                color: Theme.of(context).colorScheme.secondary),
          );
        }
        if (filestate is FileVerifyFailed) {
          print('fileHash1: $fileHash');
          _showSnackbar(
              'Verify failed: ${filestate.message}', Colors.red, Icons.error);
        }
        if (filestate is VerifySuccess &&
            filestate.fileHash == fileHash &&
            filestate.batchhash == batchHash) {
          final response = jsonEncode(filestate.response.claim?.toJson());
          print("response verify: $response");
          print('fileHash12: ${filestate.fileHash}');
          _handleVerifyResponseSuccess(
              filestate, filestate.batchhash, filestate.fileHash);
        }
        if (filestate is VerifyResponseloaded &&
            filestate.fileHash == fileHash &&
            filestate.batchhash == batchHash) {
          print('fileHash3: ${filestate.fileHash}');
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _handleVerified(filestate.iden3message, filestate.batchhash,
                filestate.fileHash);
          });
        }
        if (filestate is VerifiedClaims &&
            filestate.fileHash == fileHash &&
            filestate.batchhash == batchHash) {
          // _showSnackbar('File is Verified successfully:',
          //     Theme.of(context).colorScheme.secondary);
          // _buildFileList(true);
          isVerified = true;
          print('fileHash4: ${filestate.fileHash}');
          print('isveri123:$isVerified');
        }

        return GestureDetector(
          onTap: () {
            final did = jsonDecode(widget.did.toString());
            final storage = GetStorage();
            final walletAddress = storage.read('walletAddress');
            _fileBloc.add(VerifyUploadEvent(
              BatchHash: batchHash,
              FileHash: fileHash,
              ownerDid: walletAddress,
              did: did,
            ));
          },
          child: Visibility(
            visible: !isVerified,
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
        if (shareState is ShareVerifying && shareState.batchhash == batchHash && shareState.fileHash == fileHash) {
          return Center(
            child: Loading(
                Loadingcolor: Theme.of(context).primaryColor,
                color: Theme.of(context).colorScheme.secondary),
          );
        }
        if (shareState is ShareFailed) {
          _showSnackbar(
              'Verify failed: ${shareState.message}', Colors.red, Icons.error);
        }
        if (shareState is ShareVerifySuccess &&
            shareState.fileHash == fileHash && shareState.batchhash == batchHash) {
          final response = jsonEncode(shareState.response);
          print("response share verify: $response");
          _handleShareVerifyResponseSuccess(
              shareState, shareState.batchhash, shareState.fileHash);
        }
        if (shareState is ShareVerifyResponseloaded &&
            shareState.fileHash == fileHash && shareState.batchhash == batchHash) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _handleShareVerified(shareState.iden3message, shareState.batchhash,
                shareState.fileHash);
          });
        }
        if (shareState is ShareVerifiedClaims &&
            shareState.fileHash == fileHash && shareState.batchhash == batchHash) {
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

  Widget _progress() {
    return BlocBuilder<DownloadBloc, DownloadState>(
      bloc: _downloadBloc,
      builder: (BuildContext context, DownloadState downloadState) {
        if (downloadState is Downloading) {
          // Return CircularProgressIndicator when downloading
          // return Center(
          //     child: Loading(
          //         Loadingcolor: Theme.of(context).primaryColor,
          //         color: Theme.of(context).colorScheme.secondary));

          return Column(
            children: [
              Text(
                'Downloading...',
                style: TextStyle(
                  color: Theme.of(context).secondaryHeaderColor,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 10),
              LinearPercentIndicator(
                animation: true,
                percent: downloadState.progress,
                animationDuration: 1000,
                center: new Text(
                    '${(downloadState.progress * 100).toStringAsFixed(0)}%'),
                progressColor: Theme.of(context).colorScheme.secondary,
                backgroundColor: Theme.of(context).secondaryHeaderColor,
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildDownloadIcon(
      String batchHash, String fileHash, String fileName) {
    return BlocBuilder<DownloadBloc, DownloadState>(
      bloc: _downloadBloc,
      builder: (BuildContext context, DownloadState downloadState) {
        print('fetch download');
        if (downloadState is Downloading &&
            downloadState.batchhash == batchHash &&
            downloadState.fileHash == fileHash) {
          print('fileHash11: ${downloadState.fileHash}');
          // Return CircularProgressIndicator when downloading
          return Center(
              child: Loading(
                  Loadingcolor: Theme.of(context).primaryColor,
                  color: Theme.of(context).colorScheme.secondary));
        }

        if (downloadState is LoadingUrl &&
            downloadState.batchhash == batchHash &&
            downloadState.fileHash == fileHash) {
          print('fileHash1122: ${downloadState.fileHash}');

          print('filehas:$fileHash');

          // Return CircularProgressIndicator when downloading
          return Center(
              child: Loading(
                  Loadingcolor: Theme.of(context).primaryColor,
                  color: Theme.of(context).colorScheme.secondary));
        }

        if (downloadState is DownloadSuccess &&
            downloadState.batchhash == batchHash &&
            downloadState.fileHash == fileHash) {
          print('fileHash113: ${downloadState.fileHash}');

          print('downloadState batch:${downloadState.batchhash}');
          _handleDownloadVerifyButton(
              downloadState, downloadState.batchhash, downloadState.fileHash);
        }
        if (downloadState is DownloadFailed) {
          _showSnackbar('Download failed', Colors.red, Icons.error);
          Future.delayed(const Duration(seconds: 10), () {
            _downloadBloc.add(ResetDownloadStateEvent());
          });
        }

        if (downloadState is StatusLoaded &&
            downloadState.batchhash == batchHash &&
            downloadState.fileHash == fileHash) {
          print('fileHash116: ${downloadState.fileHash}');

          print('status loaded in download');
          print('downloadState batch1:${downloadState.batchhash}');
          // _showSnackbar(
          //     'status loaded', Theme.of(context).colorScheme.secondary);
          _deployBatchFileContract(batchHash, fileHash);
        }

        if (downloadState is CidsGot &&
            downloadState.fileHAsh == fileHash &&
            downloadState.batchhash == batchHash) {
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

          print('fileHash167: ${downloadState.fileHAsh}');

          _downloadBloc.add(onClickDownloadUrl(
              BatchHash: batchHash,
              FileHash: batchHash,
              fileHash: fileHash,
              Odid: jsonDecode(widget.did.toString()),
              FileName: fileName.toString(),
              Cids: cidList));

          // _showSnackbar(
          //     'cids got', Theme.of(context).colorScheme.secondary);
        }

        print('state124:${downloadState}');
        print('fileHash168: ${batchHash}');
        print('filehasss:$fileHash ');

        print('Expected fileHash: $fileHash');
        print('Expected batchHash: $batchHash');

        if (downloadState is DownloadUrlSuccess &&
            downloadState.fileHash == fileHash &&
            downloadState.batchhash == batchHash) {
          print('fetch success');
          // Timer(Duration(seconds: 30), () {
          //   _downloadBloc.add(ResetDownloadStateEvent());
          //   _fileBloc.add(ResetFileStateEvent());
          //   _showSnackbar('Time out', Colors.red);
          // });
          print('fileHash1675: ${downloadState.fileHash}');
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
            print('file download link: $downloadLink');
            // await _showDownloadUrl(context, downloadLink);
            _downloadFile(
                context, downloadLink.toString(), fileName.toString());
          });
        }

        // Default return for other states
        return GestureDetector(
          onTap: () {
            _downloadBloc.add(onClickDownload(
                batch_hash: batchHash,
                file_hash: batchHash,
                fileHash: fileHash,
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

// Function to download the file

  void _downloadFile(
      BuildContext context, String downloadUrl, String fileName) async {
    // Request storage permission
    var status = await Permission.storage.request();
    if (status.isGranted) {
      try {
        // Get the app-specific external storage directory
        Directory? externalDir = await getExternalStorageDirectory();

        // Ensure the directory exists
        String directoryPath = '${externalDir!.path}/Download';
        Directory downloadDir = Directory(directoryPath);

        if (!await downloadDir.exists()) {
          await downloadDir.create(recursive: true);
        }

        // Get the MIME type of the file
        // String mimeType = await getFileMimeType(downloadUrl);
        // String fileExtension = _getFileExtension(mimeType);

        // Create the file name with a timestamp
        var time = DateTime.now().millisecondsSinceEpoch;
        String newFileName = '$fileName';
        String path = '$directoryPath/$newFileName';

        // Dio dio = Dio();

        // Download the file from the IPFS link
        var response = await http.get(Uri.parse(downloadUrl));

        // Check if the response is successful
        if (response.statusCode == 200) {
          // Write the file to storage
          File file = File(path);
          await file.writeAsBytes(response.bodyBytes);

          print('File saved at: $path');
          // dio.download(downloadUrl, path,
          //     onReceiveProgress: (received, total) {
          //   print('received: $received, total: $total');
          //   var _progress = ((received / total) * 100).toStringAsFixed(0) + '%';
          //   setState(() {
          //     progress = double.parse(_progress) / 100;
          //   });
          // });
          // LinearProgressIndicator(value: progress);

          // Show success message with option to view the file
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: GestureDetector(
                onTap: () {
                  OpenFile.open(
                      path); // Open the file when the user taps the SnackBar
                },
                child: Text('File saved. Tap to view'),
              ),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 3),
            ),
          );
        } else {
          print('Failed to download file. Status Code: ${response.statusCode}');
        }
      } catch (e) {
        print('Error: $e');
      }
    } else {
      print('Storage permission not granted');
    }
  }

// Function to get the MIME type from the URL
  Future<String> getFileMimeType(String url) async {
    try {
      final response = await http.head(Uri.parse(url));
      if (response.statusCode == 200) {
        return response.headers['content-type'] ?? 'Unknown';
      } else {
        return 'Unknown';
      }
    } catch (e) {
      print('Error fetching MIME type: $e');
      return 'Unknown';
    }
  }

// Function to map MIME type to file extension
  String _getFileExtension(String mimeType) {
    switch (mimeType) {
      case 'application/pdf':
        return '.pdf';
      case 'image/jpeg':
        return '.jpg';
      case 'image/png':
        return '.png';
      case 'video/mp4':
        return '.mp4';
      case 'application/zip':
        return '.zip';
      // Add more cases as needed
      default:
        return '.bin'; // Default binary extension if MIME type is unknown
    }
  }

 
 Widget _buildShareDownloadIcon(
      String batchHash, String fileHash, String fileName) {
    return BlocBuilder<DownloadBloc, DownloadState>(
      bloc: _downloadBloc,
      builder: (BuildContext context, DownloadState downloadState) {
        print('fetch download');
        if (downloadState is Downloading &&
            downloadState.batchhash == batchHash &&
            downloadState.fileHash == fileHash) {
          print('fileHash11: ${downloadState.fileHash}');
          // Return CircularProgressIndicator when downloading
          return Center(
              child: Loading(
                  Loadingcolor: Theme.of(context).primaryColor,
                  color: Theme.of(context).colorScheme.secondary));
        }

        if (downloadState is LoadingUrl &&
            downloadState.batchhash == batchHash &&
            downloadState.fileHash == fileHash) {
          print('fileHash1122: ${downloadState.fileHash}');

          print('filehas:$fileHash');

          // Return CircularProgressIndicator when downloading
          return Center(
              child: Loading(
                  Loadingcolor: Theme.of(context).primaryColor,
                  color: Theme.of(context).colorScheme.secondary));
        }

        if (downloadState is DownloadSuccess &&
            downloadState.batchhash == batchHash &&
            downloadState.fileHash == fileHash) {
          print('fileHash113: ${downloadState.fileHash}');

          print('downloadState batch:${downloadState.batchhash}');
          _handleDownloadVerifyButton(
              downloadState, downloadState.batchhash, downloadState.fileHash);
        }
        if (downloadState is DownloadFailed) {
          _showSnackbar('Download failed', Colors.red, Icons.error);
          Future.delayed(const Duration(seconds: 10), () {
            _downloadBloc.add(ResetDownloadStateEvent());
          });
        }

        if (downloadState is StatusLoaded &&
            downloadState.batchhash == batchHash &&
            downloadState.fileHash == fileHash) {
          print('fileHash116: ${downloadState.fileHash}');

          print('status loaded in download');
          print('downloadState batch1:${downloadState.batchhash}');
          // _showSnackbar(
          //     'status loaded', Theme.of(context).colorScheme.secondary);
          _deployBatchFileContract(batchHash, fileHash);
        }

        if (downloadState is CidsGot &&
            downloadState.fileHAsh == fileHash &&
            downloadState.batchhash == batchHash) {
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

          print('fileHash167: ${downloadState.fileHAsh}');

          _downloadBloc.add(onClickDownloadUrl(
              BatchHash: batchHash,
              FileHash: batchHash,
              fileHash: fileHash,
              Odid: jsonDecode(widget.did.toString()),
              FileName: fileName.toString(),
              Cids: cidList));

          // _showSnackbar(
          //     'cids got', Theme.of(context).colorScheme.secondary);
        }

        print('state124:${downloadState}');
        print('fileHash168: ${batchHash}');
        print('filehasss:$fileHash ');

        print('Expected fileHash: $fileHash');
        print('Expected batchHash: $batchHash');

        if (downloadState is DownloadUrlSuccess &&
            downloadState.fileHash == fileHash &&
            downloadState.batchhash == batchHash) {
          print('fetch success');
          // Timer(Duration(seconds: 30), () {
          //   _downloadBloc.add(ResetDownloadStateEvent());
          //   _fileBloc.add(ResetFileStateEvent());
          //   _showSnackbar('Time out', Colors.red);
          // });
          print('fileHash1675: ${downloadState.fileHash}');
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
            print('file download link: $downloadLink');
            // await _showDownloadUrl(context, downloadLink);
            _downloadFile(
                context, downloadLink.toString(), fileName.toString());
          });
        }

        // Default return for other states
        return GestureDetector(
          onTap: () {
            _downloadBloc.add(onClickDownload(
                batch_hash: batchHash,
                file_hash: batchHash,
                fileHash: fileHash,
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


  Future<void> _handleVerified(Iden3MessageEntity iden3message,
      String batchHash, String fileHash) async {
    debugPrint('File is verified');
    _fileBloc.add(fetchAndSaveUploadVerifyClaims(
        iden3message: iden3message, batchHash: batchHash, fileHash: fileHash));
  }

  void _handleVerifyResponseSuccess(
      VerifySuccess state, String batchHash, String fileHash) async {
    final response = jsonEncode(state.response.claim?.toJson());
    final txhashResponse = state.response.txHash;
    await _checkUseSpaceTxHashStatus(txhashResponse!);

    print('get verify response: $response');

    _fileBloc.add(onVerifyResponse(response, batchHash, fileHash));
  }

  void _handleShareVerifyResponseSuccess(
      ShareVerifySuccess state, String batchHash, String fileHAsh) async {
    final response = jsonEncode(state.response);

    print('get share verify response: $response');

    _shareBloc.add(onShareVerifyResponse(response, batchHash, fileHAsh));
  }

  Future<void> _handleShareVerified(Iden3MessageEntity iden3message,
      String batchHash, String fileHash) async {
    debugPrint('share File is verified');
    _shareBloc.add(fetchAndSaveShareVerifyClaims(
        iden3message: iden3message, batchHash: batchHash, fileHash: fileHash));
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
