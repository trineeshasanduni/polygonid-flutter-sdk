// import 'dart:async';
// import 'dart:convert';
// import 'dart:ffi';
// import 'dart:io';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:gradient_borders/box_borders/gradient_box_border.dart';
// import 'package:http/http.dart' as http;
// import 'package:http/http.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:polygonid_flutter_sdk/file/data/model/fileName_model.dart';
// import 'package:polygonid_flutter_sdk/iden3comm/domain/entities/common/iden3_message_entity.dart';
// import 'package:polygonid_flutter_sdk_example/src/presentation/dependency_injection/dependencies_provider.dart';
// import 'package:polygonid_flutter_sdk_example/src/presentation/ui/common/widgets/circularProgress.dart';
// import 'package:polygonid_flutter_sdk_example/src/presentation/ui/files/download_bloc/download_bloc.dart';
// import 'package:polygonid_flutter_sdk_example/src/presentation/ui/files/file_bloc/file_bloc.dart';
// import 'package:polygonid_flutter_sdk_example/src/presentation/ui/files/share_bloc/share_bloc.dart';
// import 'package:polygonid_flutter_sdk_example/src/presentation/ui/home/home_bloc.dart';
// import 'package:polygonid_flutter_sdk_example/src/presentation/ui/home/home_event.dart';
// import 'package:polygonid_flutter_sdk_example/src/presentation/ui/home/home_state.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:web3dart/web3dart.dart';
// import 'package:web3modal_flutter/utils/debouncer.dart';
// import 'package:web_socket_channel/io.dart';

// class FileData {
//   final String fileName;
//   final String batchHash;
//   final String fileHash;
//   bool isVerified;

//   FileData(this.fileName, this.batchHash, this.fileHash,
//       {this.isVerified = false});
// }

// class Files extends StatefulWidget {
//   final String? did;
//   const Files({super.key, required this.did});

//   @override
//   State<Files> createState() => _FilesState();
// }

// class _FilesState extends State<Files> {
//   List<PlatformFile> selectedFiles = [];
//   int size = 0;
//   bool _isLoading = false;
//   late final FileBloc _fileBloc;
//   late final HomeBloc _homeBloc;
//   late final DownloadBloc _downloadBloc;
//   late final ShareBloc _shareBloc;
//   String identity = '';
//   final walletAddress = '';
//   bool _isRequestInProgress = false;
//   List<String> fileNames = [];
//   List<FileData> fileDataList = [];
//   var httpClient = http.Client();
//   Web3Client? _web3Client;
//   var rpcUrl =
//       'https://polygon-mainnet.g.alchemy.com/v2/pHKWzuctaLCPxAKYc0c8bKQA8d85oPlk';

//   final _contractAddress =
//       EthereumAddress.fromHex('0x665e346D9c68587Bd51C53eAd71e0F5367E7950C');

//   List<dynamic> dataResult = []; // Store contract data as a list of lists

//   @override
//   void initState() {
//     super.initState();
//     _fileBloc = getIt<FileBloc>();
//     _homeBloc = getIt<HomeBloc>();
//     _downloadBloc = getIt<DownloadBloc>();
//     _shareBloc = getIt<ShareBloc>();

//     final storage = GetStorage();
//     _deployContract();
//     _initGetIdentifier();
//   }

//   void _initGetIdentifier() {
//     _homeBloc.add(const GetIdentifierHomeEvent());
//   }

//   Future<void> openFile() async {
//     final result = await FilePicker.platform.pickFiles(allowMultiple: true);
//     if (result != null) {
//       setState(() {
//         selectedFiles = result.files;
//         size = result.files.single.size;
//         print('size: $size');
//       });
//       _uploadFiles();
//     }
//   }

//   Future<void> _uploadFiles() async {
//     BlocBuilder<HomeBloc, HomeState>(
//         bloc: _homeBloc,
//         builder: (BuildContext context, HomeState state) {
//           identity = state.identifier as String;
//           print('identity checking: $identity');
//           return const SizedBox.shrink();
//         });

//     final storage = GetStorage();
//     // final getDID = storage.read('did');
//     final walletAddress = storage.read('walletAddress');
//     print('walletAddress : $walletAddress');

//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       final did = jsonDecode(widget.did.toString());
//       print('did12344: $did');
//       for (var file in selectedFiles) {
//         final fileToSave = await saveFile(file);
//         _fileBloc.add(FileuploadEvent(
//           did: did,
//           ownerDid: walletAddress,
//           fileData: fileToSave,
//         ));
//       }
//     } catch (e) {
//       print('Upload failed: $e');
//       setState(() {
//         selectedFiles.clear();
//       });
//       // _showSnackbar('Failed to upload files');
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   void _showSnackbar(String message, Color? backgroundColor) {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text(message),
//         duration: const Duration(seconds: 5),
//         backgroundColor: backgroundColor,
//       ));
//     });
//   }

//   Future<File> saveFile(PlatformFile file) async {
//     final storage = await getApplicationDocumentsDirectory();
//     final newFile = File('${storage.path}/${file.name}');
//     return File(file.path!).copy(newFile.path);
//   }

//   Future<void> _deployContract() async {
//     try {
//       _web3Client = Web3Client(rpcUrl, httpClient);

//       final abiFile =
//           await rootBundle.loadString('assets/abi/FileStorage.json');
//       if (abiFile.isEmpty) throw FormatException('ABI file is empty');

//       final jsonAbi = jsonDecode(abiFile);
//       final _abiCode =
//           ContractAbi.fromJson(jsonEncode(jsonAbi['abi']), 'FileStorage');

//       final _contract = DeployedContract(_abiCode, _contractAddress);
//       final _getAllBatchesFunction = _contract.function('getAllBatches');

//       final storage = GetStorage();
//       final walletAddress1 = storage.read('walletAddress');

//       final result = await _web3Client?.call(
//         contract: _contract,
//         function: _getAllBatchesFunction,
//         params: [],
//         sender: EthereumAddress.fromHex(walletAddress1),
//       );

//       if (result!.isNotEmpty && result?[0] is List) {
//         setState(() {
//           dataResult = List<dynamic>.from(result[0]);
//           WidgetsBinding.instance.addPostFrameCallback((_) {
//             // Store the result
//             _processContractResult(result[0]);
//           });
//         });
//       } else {
//         print('No data returned from contract or result format is unexpected');
//       }
//     } catch (e) {
//       print('An error occurred: $e');
//     }
//   }

//   Future<void> _deployBatchFileContract(
//       String batch_hash, String file_hash) async {
//     try {
//       _web3Client = Web3Client(rpcUrl, httpClient);

//       final abiFile =
//           await rootBundle.loadString('assets/abi/FileStorage.json');
//       if (abiFile.isEmpty) throw FormatException('ABI file is empty');

//       final jsonAbi = jsonDecode(abiFile);
//       final _abiCode =
//           ContractAbi.fromJson(jsonEncode(jsonAbi['abi']), 'FileStorage');

//       final _contract = DeployedContract(_abiCode, _contractAddress);
//       final _getAllBatchesFunction = _contract.function('getBatchFile');

//       final storage = GetStorage();
//       final walletAddress1 = storage.read('walletAddress');

//       final did = jsonDecode(widget.did.toString());

//       final result = await _web3Client?.call(
//         contract: _contract,
//         function: _getAllBatchesFunction,
//         params: [did, batch_hash, file_hash],
//         sender: EthereumAddress.fromHex(walletAddress1),
//       );
//       final walletAddress = storage.read('walletAddress');
//       print('walletAddress : $walletAddress');

//       if (result!.isNotEmpty) {
//         // Handle result based on its type
//         final index = result[0];

//         // Check if result[0] is of type BigInt and convert it to String
//         if (index is BigInt) {
//           final indexString = index.toString();
//           print('Fetched index: $indexString');

//           // Dispatch event with index and wallet address
//           _downloadBloc.add(GetCidsEvent(
//             index: indexString,
//             did: did,
//             owner: walletAddress,
//             batch_hash: batch_hash,
//           ));
//         } else {
//           print('Unexpected result type: ${index.runtimeType}');
//         }
//       } else {
//         print('No data returned from contract or result format is unexpected');
//       }
//     } catch (e) {
//       print('An error occurred: $e');
//     }
//   }

//   Future<void> _processContractResult(List<dynamic> dataResult) async {
//     if (_isRequestInProgress) {
//       return;
//     }

//     setState(() {
//       _isRequestInProgress = true;
//     });

//     int filesFetched = 0;
//     final totalFiles = dataResult.length;

//     try {
//       _fileBloc.stream.listen((state) {
//         if (state is FileNameLoaded) {
//           setState(() {
//             fileDataList.add(FileData(
//                 state.fileName.fileName.toString(),
//                 state.fileName.batchHash.toString(),
//                 state.fileName.fileHash.toString()));
//             print('File data added: ${fileDataList.last}');
//             filesFetched++;

//             if (filesFetched == totalFiles) {
//               print('All files fetched successfully.');
//               _isRequestInProgress = false;
//             }
//           });
//         }
//       });

//       for (var batchDetails in dataResult) {
//         final batchHash = batchDetails[1].toString();
//         print('Requesting file for batchHash: $batchHash');

//         if (filesFetched < totalFiles) {
//           await Future.delayed(Duration(milliseconds: 500), () {
//             _fileBloc.add(GetFileNameEvent(BatchHash: batchHash));
//           });
//         }
//       }
//     } catch (e) {
//       print('Error processing contract result: $e');
//     } finally {
//       setState(() {
//         _isRequestInProgress = false;
//       });
//     }
//   }

//   Future<bool> isTransactionSuccessful(String txHash) async {
//     // Initialize the Web3Client using your Infura or Alchemy endpoint
//     final client = Web3Client(
//         "https://polygon-mainnet.g.alchemy.com/v2/SOxCgJzw6PLvC02g238nlDqJRq83_j3k",
//         Client());

//     try {
//       // Fetch the transaction receipt
//       final receipt = await client.getTransactionReceipt(txHash);
//       print('receipt: $receipt');

//       if (receipt != null && receipt.status == true) {
//         print("Transaction successful!");
//         return true;
//       } else {
//         print("Transaction failed or still pending.");
//         return false;
//       }
//     } catch (e) {
//       print("Error fetching transaction status: $e");
//       return false;
//     } finally {
//       client.dispose();
//     }
//   }

//   Future<void> _checkTxHashStatus(String txHash, String owner, int size) async {
//     bool isSuccess = false;

//     // Add logic to check the transaction status here.
//     // For example, calling a blockchain API to check the status of the txHash.

//     while (!isSuccess) {
//       // Call your blockchain transaction check method
//       // Example: checkTransaction(txHash) which returns true/false
//       isSuccess = await isTransactionSuccessful(txHash);

//       if (isSuccess) {
//         print('Transaction successful with hash: $txHash');
//         // Dispatch the event to create proof after the transaction is successful
//         _fileBloc.add(UseSpaceEvent(
//           did: jsonDecode(widget.did.toString()),
//           ownerDid: owner,
//           batchSize: size,
//         ));
//       } else {
//         print('Transaction is not yet successful. Retrying...');
//         await Future.delayed(Duration(seconds: 5)); // Poll every 5 seconds
//       }
//     }
//   }

//   Future<void> _checkUseSpaceTxHashStatus(String txHash) async {
//     bool isSuccess = false;

//     // Add logic to check the transaction status here.
//     // For example, calling a blockchain API to check the status of the txHash.

//     while (!isSuccess) {
//       // Call your blockchain transaction check method
//       // Example: checkTransaction(txHash) which returns true/false
//       isSuccess = await isTransactionSuccessful(txHash);

//       if (isSuccess) {
//         print('Transaction successful with hash: $txHash');
//         // Dispatch the event to create proof after the transaction is successful
//       } else {
//         print('Transaction is not yet successful. Retrying...');
//         await Future.delayed(Duration(seconds: 5)); // Poll every 5 seconds
//       }
//     }
//   }

//   Future<void> _checkSharedTxHashStatus(
//       String txHash, String OwnerDid, BuildContext dialogContext) async {
//     bool isSuccess = false;

//     // Add logic to check the transaction status here.
//     // For example, calling a blockchain API to check the status of the txHash.

//     while (!isSuccess) {
//       // Call your blockchain transaction check method
//       // Example: checkTransaction(txHash) which returns true/false
//       isSuccess = await isTransactionSuccessful(txHash);

//       if (isSuccess) {
//         print('Transaction successful with hash: $txHash');
//         print('shared did: $OwnerDid');
//         print('my did: ${jsonDecode(widget.did.toString())}');
//         final String did = jsonDecode(widget.did.toString());

//         if (OwnerDid.characters == did.characters) {
//           print('ok');
//           _showSnackbar('File shared successfully',
//               Theme.of(context).colorScheme.secondary);
//           // Close the AlertDialog after DIDs match
//           Navigator.of(dialogContext).pop(); // Close the dialog
//         } else {
//           print('not ok');
//           _showSnackbar('File is not shared successfully', Colors.red);
//         }

//         // Dispatch the event to create proof after the transaction is successful
//       } else {
//         print('Transaction is not yet successful. Retrying...');
//         await Future.delayed(Duration(seconds: 5)); // Poll every 5 seconds
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final storage = GetStorage();
//     // final getDID = storage.read('did');
//     final walletAddress = storage.read('walletAddress');
//     print('walletAddress : $walletAddress');
//     return BlocProvider(
//       create: (_) => _fileBloc,
//       child: SafeArea(
//         child: Scaffold(
//           backgroundColor: Theme.of(context).primaryColor,
//           body: BlocConsumer<FileBloc, FileState>(
//               listener: (context, state) async {
//             if (state is FileUploading) {
//               Center(child:  Loading(Loadingcolor: Theme.of(context).primaryColor,color: Theme.of(context).colorScheme.secondary));
//             }
//             if (state is FileUploadFailed) {
//               _showSnackbar("File Upload Failed", Colors.red);
//             }
//             if (state is FileUploaded) {
//               for (var file in dataResult) {
//                 print('object file: $file');
//               }
//               await _checkTxHashStatus(
//                   state.response.TXHash!, walletAddress, size);

//               print('dataResult: $dataResult');
//             }
//             if (state is FileUsingSpaced) {
//               print('fetching space state: ${state.txHash}');
//               String txHash = state.txHash.TXHash!;
//               await _checkUseSpaceTxHashStatus(txHash);

//               Container(
//                 child: Text('fetching space state12: ${state.txHash}'),
//               );

//               print('usespace check: ${state.txHash.TXHash}');
//               _showSnackbar(
//                   'Files uploaded successfully: ${state.txHash.TXHash}',
//                   Theme.of(context).colorScheme.secondary);
//             }
//           }, builder: (context, state) {
//             return Column(
//               children: [
//                 _buildHeader(),
//                 const SizedBox(height: 10),
//                 _buildFileSelectionButton(),
//                 const SizedBox(height: 20),
//                 _buildFileList(),

//                 // _buildBlocContent(context),
//                 // const SizedBox(height: 20),
//                 // _buildDownloadBlocContent(context),
//               ],
//             );
//           }),
//         ),
//       ),
//     );
//   }

//   Widget _buildFileList() {
//     return Expanded(
//       child: fileDataList.isNotEmpty
//           ? ListView.builder(
//               itemCount: fileDataList.length,
//               itemBuilder: (context, index) {
//                 final fileData = fileDataList[index];
//                 return ListTile(
//                   title: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Flexible(
//                         child: Text(
//                           fileData.fileName,
//                           overflow: TextOverflow.ellipsis,
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontFamily: GoogleFonts.robotoMono().fontFamily,
//                             fontSize: 12,
//                           ),
//                         ),
//                       ),
//                       SizedBox(width: 10),
//                       Row(
//                         children: [
//                           SizedBox(
//                             width: MediaQuery.of(context).size.width * 0.2,
//                             child: _buildVerifyButton(
//                                 fileData.batchHash, fileData.isVerified),
//                           ),
//                           SizedBox(width: 20),
//                           SizedBox(
//                             // width: 20,
//                             child: _buildDownloadIcon(fileData.batchHash,
//                                 fileData.fileHash, fileData.fileName),
//                           ),
//                           SizedBox(width: 20),
//                           SizedBox(
//                             // width: 10,
//                             child: _buildShareIcon(fileData.batchHash,
//                                 fileData.fileHash, fileData.fileName),
//                           ),
//                           // SizedBox(width: 10),
//                         ],
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             )
//           : Center(
//               child: Text(
//                 'No files fetched',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 16,
//                   fontFamily: GoogleFonts.robotoMono().fontFamily,
//                 ),
//               ),
//             ),
//     );
//   }

//   void _handleDownloadVerifyButton(
//       DownloadSuccess state, String batchHash) async {
//     final response = jsonEncode(state.response.toJson());
//     final sessionId = state.response.sessionId.toString();
//     print('sessionId download : $sessionId');
//     print('download response: $response');

//     _downloadBloc.add(onDownloadResponse(response));

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _downloadBloc.add(onGetDownloadStatusEvent(sessionId, batchHash));
//     });
//   }

//   Widget _buildShareIcon(String BatchHash, String FileHash, String FileName) {
//     return GestureDetector(
//       onTap: () {
//         print('tap share');
//         _showShareInput(context, BatchHash, FileHash, FileName);
//       },
//       child: _buildIcon(
//         Icons.share,
//         Theme.of(context).colorScheme.secondary,
//         Theme.of(context).colorScheme.secondary,
//         Colors.white,
//       ),
//     );
//   }

//   Widget _buildDownloadIcon(
//       String BatchHash, String FileHash, String FileName) {
//     return BlocBuilder<DownloadBloc, DownloadState>(
//       bloc: _downloadBloc,
//       builder: (BuildContext context, DownloadState state) {
//         if (state is Downloading) {
//           // Return CircularProgressIndicator when downloading
//           return Center(
//               child: Loading(
//                   Loadingcolor: Theme.of(context).primaryColor,
//                   color: Theme.of(context).colorScheme.secondary));
//         }

//         if (state is DownloadSuccess && state.batchhash == BatchHash) {
//           print('state batch:${state.batchhash}');
//           _handleDownloadVerifyButton(state, state.batchhash);
//         }
//         if (state is DownloadFailed) {
//           _showSnackbar('Download failed', Colors.red);
//         }

//         if (state is StatusLoaded && state.batchhash == BatchHash) {
//           print('status loaded in download');
//           print('state batch1:${state.batchhash}');
//           _showSnackbar(
//               'status loaded', Theme.of(context).colorScheme.secondary);
//           _deployBatchFileContract(BatchHash, FileHash);
//         }

//         if (state is CidsGot && state.batchhash == BatchHash) {
//           print('cids got');
//           final cidString = state.cids.cids;
//           final cidList = jsonEncode(cidString);
//           final cidGot = jsonEncode(cidList);

//           print('responsse cids got1: $cidGot');
//           print('responsse cids got: $cidList');

//           print('download1 : $BatchHash');
//           print('download2 : $BatchHash');
//           print('download3 : $FileName');
//           print('download4 : $cidList');
//           print('download5 : ${jsonDecode(widget.did.toString())}');

//           _downloadBloc.add(onClickDownloadUrl(
//               BatchHash: BatchHash,
//               FileHash: BatchHash,
//               Odid: jsonDecode(widget.did.toString()),
//               FileName: FileName.toString(),
//               Cids: cidList));

//           _showSnackbar('cids got', Theme.of(context).colorScheme.secondary);
//         }

//         if (state is DownloadUrlSuccess) {
//           final url = state.response.uRL;
//           final downloadLink = Uri.parse(url as String);
//           _showSnackbar(
//               '${state.response.uRL}', Theme.of(context).colorScheme.secondary);
//           print('download url success: ${state.response.uRL}');
//           WidgetsBinding.instance.addPostFrameCallback((_) {
//             _showDownloadUrl(context, downloadLink);
//           });
//         }

//         // Default return for other states
//         return GestureDetector(
//           onTap: () {
//             _downloadBloc.add(onClickDownload(
//                 batch_hash: BatchHash,
//                 file_hash: BatchHash,
//                 didU: jsonDecode(widget.did.toString())));
//           },
//           child: _buildIcon(
//             Icons.download,
//             Theme.of(context).colorScheme.secondary,
//             Theme.of(context).colorScheme.secondary,
//             Colors.white,
//           ),
//         );
//       },
//     );
//   }

//   Future<void> _showShareInput(BuildContext context, String BatchHash,
//       String FileHash, String FileName) async {
//     var pasteDid = TextEditingController();
//     final storage = GetStorage();
//     final walletAddress = storage.read('walletAddress');
//     print('walletAddress : $walletAddress');

//     BuildContext dialogContext;

//     showDialog(
//       barrierDismissible: false,
//       context: context,
//       builder: (BuildContext context) {
//         dialogContext = context; // Save the context
//         return AlertDialog(
//           title: Column(
//             children: [
//               Align(
//                 alignment: Alignment.topRight,
//                 child: IconButton(
//                   icon: Icon(Icons.close),
//                   onPressed: () {
//                     Navigator.of(context).pop(); // Close the dialog
//                   },
//                 ),
//               ),
//               Align(
//                 alignment: Alignment.centerLeft,
//                 child: Text(
//                   'Paste Your Share DID',
//                   style: TextStyle(
//                     color: Theme.of(context).secondaryHeaderColor,
//                     fontFamily: GoogleFonts.robotoMono().fontFamily,
//                     fontSize: 15,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           content: TextFormField(
//             controller: pasteDid,
//             enabled: true,
//             decoration: InputDecoration(
//               labelText: 'Paste your Share DID here',
//               labelStyle: TextStyle(
//                 color: Colors.white.withOpacity(0.4),
//                 fontFamily: GoogleFonts.robotoMono().fontFamily,
//                 fontSize: 13,
//               ),
//               border: OutlineInputBorder(
//                 borderSide: BorderSide(
//                   color: Colors.red.withOpacity(0.4),
//                 ),
//               ),
//             ),
//           ),
//           actions: <Widget>[
//             BlocBuilder<ShareBloc, ShareState>(
//               bloc: _shareBloc,
//               builder: (context, state) {
//                 if (state is Sharing) {
//                   return Center(
//                       child: Loading(
//                           Loadingcolor: Theme.of(context).primaryColor,
//                           color: Theme.of(context).colorScheme.secondary));
//                 }
//                 if (state is ShareFailed) {
//                   _showSnackbar('Share failed: ${state.message}', Colors.red);
//                 }
//                 if (state is Shared) {
//                   // Call the transaction hash check method
//                   _checkSharedTxHashStatus(state.response.tXHash!,
//                       state.response.ownerDid!, dialogContext);
//                 }
//                 return TextButton(
//                   child: const Text('Share'),
//                   onPressed: () {
//                     _shareBloc.add(onClickShare(
//                       FileName: FileName,
//                       OwnerDid: jsonDecode(widget.did.toString()),
//                       ShareDid: pasteDid.text,
//                       Owner: walletAddress,
//                       file_hash: FileHash,
//                       batch_hash: BatchHash,
//                     ));
//                   },
//                 );
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _showDownloadUrl(BuildContext context, Uri url) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: TextButton(
//               onPressed: () => setState(() {
//                     launchUrl(url, mode: LaunchMode.externalApplication);
//                   }),
//               child: Text('Click here to Download File')),
//         );
//       },
//     );
//   }

//   Widget _buildurlLink(String url) {
//     return GestureDetector(
//       onTap: () {
//         print('url: $url');
//       },
//       child: _buildIcon(
//         Icons.link,
//         Theme.of(context).colorScheme.secondary,
//         Theme.of(context).colorScheme.secondary,
//         Colors.white,
//       ),
//     );
//   }

//   // Widget _buildDownloadBlocContent(BuildContext context) {
//   //   return BlocBuilder<DownloadBloc, DownloadState>(
//   //     bloc: _downloadBloc,
//   //     builder: (BuildContext context, DownloadState state) {
//   //       if (state is Downloading) {
//   //         const CircularProgressIndicator(
//   //           color: Colors.redAccent,
//   //         );
//   //       }
//   //       if (state is DownloadSuccess) {
//   //         _handleDownloadVerifyButton(state);
//   //       }

//   //       if (state is StatusLoaded ) {
//   //         print('status loaded in download');
//   //         _showSnackbar('status loaded');
//   //         // _deployBatchFileContract(batch_hash, file_hash);
//   //       }

//   //       return const SizedBox.shrink();
//   //     },
//   //   );
//   // }

//   Widget _buildVerifyButton(String batchHash, bool isVerified) {
//   print('bathash: $batchHash');
//   return BlocBuilder<FileBloc, FileState>(
//     bloc: _fileBloc,
//     builder: (context, state) {
//       Color buttonColor; // Variable to hold the button color

//       if (state is Fileverifying) {
//         return Center(
//           child: Loading(
//             Loadingcolor: Theme.of(context).primaryColor,
//             color: Theme.of(context).colorScheme.secondary,
//           ),
//         );
//       }
//       if (state is FileVerifyFailed) {
//         _showSnackbar('Verify failed: ${state.message}', Colors.red);
//       }
//       if (state is VerifySuccess) {
//         final response = jsonEncode(state.response.claim?.toJson());
//         print("response verify: $response");
//         _handleVerifyResponseSuccess(state);
//       }
//       if (state is VerifyResponseloaded) {
//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           _handleVerified(state.iden3message);
//         });
//       }
//       if (state is VerifiedClaims) {
//         _showSnackbar('File id Verified successfully:',
//             Theme.of(context).colorScheme.secondary);
//         buttonColor = Colors.red; // Change button color to red
//       } else {
//         buttonColor = Theme.of(context).colorScheme.secondary; // Default color
//       }

//       return GestureDetector(
//         onTap: isVerified
//             ? null
//             : () {
//                 final did = jsonDecode(widget.did.toString());
//                 final storage = GetStorage();
//                 final walletAddress = storage.read('walletAddress');
//                 _fileBloc.add(VerifyUploadEvent(
//                   BatchHash: batchHash,
//                   ownerDid: walletAddress,
//                   did: did,
//                 ));
//               },
//         child: _buildButton(
//           "verify",
//           buttonColor, // Use the determined button color
//           buttonColor,
//           Theme.of(context).primaryColor,
//           isEnabled: !isVerified, // Disable button if verified
//         ),
//       );
//     },
//   );
// }


//   Widget _buildBlocContent(BuildContext context) {
//     return BlocBuilder<FileBloc, FileState>(
//       bloc: _fileBloc,
//       builder: (context, state) {
//         if (state is Fileverifying) {
//           return Loading(
//               Loadingcolor: Theme.of(context).primaryColor,
//               color: Theme.of(context).colorScheme.secondary);
//         }
//         if (state is FileVerifyFailed) {
//           _showSnackbar('Share failed: ${state.message}', Colors.red);
//         }
//         if (state is VerifySuccess) {
//           final response = jsonEncode(state.response.claim?.toJson());
//           print("response verify: $response");
//           _handleVerifyResponseSuccess(state);
//         }
//         if (state is VerifyResponseloaded) {
//           WidgetsBinding.instance.addPostFrameCallback((_) {
//             _handleVerified(state.iden3message);
//           });
//         }
//         if (state is VerifiedClaims) {
//           _showSnackbar('File id Verified successfully:',
//               Theme.of(context).colorScheme.secondary);
//           // _buildFileList(true);
//         }

//         return const SizedBox.shrink();
//       },
//     );
//   }

//   Future<void> _handleVerified(Iden3MessageEntity iden3message) async {
//     debugPrint('File is verified');
//     _fileBloc.add(fetchAndSaveUploadVerifyClaims(iden3message: iden3message));
//   }

//   void _handleVerifyResponseSuccess(VerifySuccess state) async {
//     final response = jsonEncode(state.response.claim?.toJson());
//     final txhashResponse = state.response.txHash;
//     await _checkUseSpaceTxHashStatus(txhashResponse!);

//     print('get verify response: $response');

//     _fileBloc.add(onVerifyResponse(response));
//   }

//   Widget _buildIcon(
//       IconData icon, dynamic colorScheme, dynamic border, dynamic textColor) {
//     return Container(
//       // width: MediaQuery.of(context).size.width * 0.25,
//       alignment: Alignment.center,
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: Icon(
//         icon as IconData?,
//         color: textColor,
//       ),
//     );
//   }

//   Widget _buildButton(
//     String text,
//     dynamic colorScheme,
//     dynamic border,
//     dynamic textColor, {
//     bool isEnabled = true,
//   }) {
//     return GestureDetector(
//       child: Container(
//         width: MediaQuery.of(context).size.width * 0.5,
//         alignment: Alignment.center,
//         padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
//         decoration: BoxDecoration(
//           color: isEnabled ? colorScheme : Colors.grey, // Grey out if disabled
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(
//             color: border,
//             width: 2,
//           ),
//         ),
//         child: Text(
//           text,
//           style: GoogleFonts.robotoMono(
//             color: isEnabled
//                 ? textColor
//                 : Colors.grey[800], // Grey text if disabled
//             fontSize: 10,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildHeader() {
//     return ListTile(
//       title: Row(
//         children: [
//           Image.asset('assets/images/launcher_icon.png', width: 30, height: 30),
//           RichText(
//             text: TextSpan(
//               text: 'zkp',
//               style: TextStyle(
//                 color: Theme.of(context).colorScheme.secondary,
//                 fontSize: 20,
//                 fontFamily: GoogleFonts.robotoMono().fontFamily,
//                 fontWeight: FontWeight.w300,
//               ),
//               children: [
//                 TextSpan(
//                   text: 'STORAGE',
//                   style: TextStyle(
//                     color: Theme.of(context).secondaryHeaderColor,
//                     fontSize: 20,
//                     fontFamily: GoogleFonts.robotoMono().fontFamily,
//                     fontWeight: FontWeight.w300,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//       trailing: GestureDetector(
//         // onTap: _deployContract,
//         child: Container(
//           width: 30,
//           height: 30,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(20),
//             border: Border.all(
//               color: Theme.of(context).colorScheme.secondary,
//               width: 1,
//             ),
//           ),
//           child: Icon(
//             Icons.wallet,
//             color: Theme.of(context).secondaryHeaderColor,
//             size: 20,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildFileSelectionButton() {
//     return SizedBox(
//       width: MediaQuery.of(context).size.width,
//       height: MediaQuery.of(context).size.height / 14,
//       child: Center(
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             _buildFileInfoColumn('0', 'Files'),
//             _buildFileInfoColumn('0MiB', 'Usage'),
//             SizedBox(width: 10),
//             GestureDetector(
//               onTap: _isLoading ? null : openFile,
//               child: Container(
//                 width: MediaQuery.of(context).size.width / 3,
//                 alignment: Alignment.bottomCenter,
//                 decoration: BoxDecoration(
//                   color: Theme.of(context).primaryColor,
//                   borderRadius: BorderRadius.circular(10),
//                   border: const GradientBoxBorder(
//                     gradient: LinearGradient(
//                         colors: [Color(0xFFa3d902), Color(0xFF2CFFAE)]),
//                     width: 2,
//                   ),
//                 ),
//                 child: Center(
//                   child: _isLoading
//                       ? Center(
//                           child: Loading(
//                               Loadingcolor: Theme.of(context).primaryColor,
//                               color: Theme.of(context).colorScheme.secondary)
//                       )
//                       : Text(
//                           'Select Files',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 10,
//                             fontWeight: FontWeight.bold,
//                             fontFamily: GoogleFonts.robotoMono().fontFamily,
//                           ),
//                         ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildFileInfoColumn(String value, String label) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Text(value,
//             style: TextStyle(fontFamily: GoogleFonts.robotoMono().fontFamily)),
//         Text(label,
//             style: TextStyle(
//                 fontSize: 8, fontFamily: GoogleFonts.robotoMono().fontFamily)),
//       ],
//     );
//   }
// }