// import 'dart:convert';
// import 'dart:io';
// import 'dart:math';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:gradient_borders/box_borders/gradient_box_border.dart';
// import 'package:http/http.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:web3dart/web3dart.dart';
// import 'package:web_socket_channel/io.dart';

// class Files extends StatefulWidget {
//   const Files({super.key});

//   @override
//   State<Files> createState() => _FilesState();
// }

// class _FilesState extends State<Files> {
//   List<PlatformFile> selectedFiles = [];
//   bool _isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     _deployContract();
//   }

//   Future<void> openFile() async {
//     FilePickerResult? result =
//         await FilePicker.platform.pickFiles(allowMultiple: true);
//     if (result != null) {
//       setState(() {
//         selectedFiles = result.files;
//       });
//       await _uploadFiles(); // Call upload method immediately after selection
//       // await _deployContract();
//     }
//   }

//   // Future<void> _deployContract() async {
    
//   //   var httpClient = Client();
//   //   late ContractAbi _abiCode;
//   //   late EthereumAddress _contractAddress;
//   //   Web3Client? _web3Client;

//   //   try{
//   //     var rpcUrl =
//   //       'https://polygon-mainnet.infura.io/'; // Replace with your Infura project ID
//   //   _web3Client = Web3Client(rpcUrl, httpClient, socketConnector: () {
//   //     return IOWebSocketChannel.connect('wss://polygon-mainnet.infura.io')
//   //         .cast<String>();
//   //   });

//   //   String abiFile = await rootBundle.loadString('assets/abi/FileStorage.json');
//   //   var jsonAbi = jsonDecode(abiFile);
//   //   _abiCode = ContractAbi.fromJson(jsonEncode(jsonAbi['abi']), 'FileStorage');

//   //   print('abiCode: $_abiCode');

//   //   //function
//   //   late DeployedContract _contract;
//   //   late ContractFunction _getAllBatchesFunction;

//   //   _contractAddress =
//   //       EthereumAddress.fromHex('0x40C17A4bA53913838a3a013c572c190cA8be3052');

//   //   _contract = DeployedContract(_abiCode, _contractAddress);

//   //   _getAllBatchesFunction = _contract.function('getAllBatches');
//   //   print('getAllBatchesFunction: $_getAllBatchesFunction');

//   //   List<dynamic> data = await _web3Client.call(
//   //     contract: _contract,
//   //     function: _getAllBatchesFunction,
//   //     params: [],
//   //   );
//   //   List<dynamic> dataResult = data[0];
//   //   print('data result: ${dataResult}');
//   //   var batches = dataResult;
//   //   print('batches: $batches');
//   //   for (var batch in batches) {
//   //     var batchDetails = batch as List<dynamic>;
//   //     String ownerDid = batchDetails[0] as String;
//   //     String batchHash = batchDetails[1] as String;
//   //     BigInt filesCount = batchDetails[2] as BigInt;
//   //     BigInt batchSize = batchDetails[3] as BigInt;
//   //     bool verified = batchDetails[4] as bool;

//   //     print('Owner DID: $ownerDid');
//   //     print('Batch Hash: $batchHash');
//   //     print('Files Count: $filesCount');
//   //     print('Batch Size: $batchSize');
//   //     print('Verified: $verified');
//   //     print('---');
    
//   //   }
//   //   } catch (e) {
//   //     print('An error occurred: $e');
//   //   } finally {
//   //     print('Cleaning up');
//   //     httpClient.close();
//   //   }
    
    
//   // }
//   Future<void> _deployContract() async {
//   var httpClient = Client();
//   late ContractAbi _abiCode;
//   late EthereumAddress _contractAddress;
//   Web3Client? _web3Client;

//   try {
//     var rpcUrl = 'https://polygon-rpc.com/'; // Replace with your Infura project ID
//     _web3Client = Web3Client(rpcUrl, httpClient, socketConnector: () {
//       return IOWebSocketChannel.connect('wss://polygon-mainnet.infura.io').cast<String>();
//     });

//     // Load ABI file
//     String abiFile = await rootBundle.loadString('assets/abi/FileStorage.json');
//     if (abiFile.isEmpty) {
//       throw FormatException('ABI file is empty');
//     }
//     print('Loaded ABI File: $abiFile');  // Debugging ABI content

//     var jsonAbi = jsonDecode(abiFile);
//     print('jsonAbi: ${jsonAbi}');  // Debugging JSON ABI content
//     _abiCode = ContractAbi.fromJson(jsonEncode(jsonAbi['abi']), 'FileStorage');
//     print('ABI Code: ${_abiCode.functions.length}');

//     // Setup contract
//     _contractAddress = EthereumAddress.fromHex('0xB9f09905ef2bA45b8f84DCE94465831B459bCe24');
//     DeployedContract _contract = DeployedContract(_abiCode, _contractAddress);
//     ContractFunction _getAllBatchesFunction = _contract.function('getAllBatches');
//     print('Function Loaded: ${_getAllBatchesFunction.name.length}');

//     // Call contract function
//     List<dynamic> result = await _web3Client.call(
//       contract: _contract,
//       function: _getAllBatchesFunction,
//       params: [],
//     );
    
//     print('Raw Result: $result');  // Print the raw result

//     // Process the result
//     if (result.isNotEmpty && result[0] is List) {
//       List<dynamic> dataResult = result[0];
//       print('Data Result: ${dataResult[0]}');
//       for (var batch in dataResult) {
//         var batchDetails = batch as List<dynamic>;
//         String ownerDid = batchDetails[0] as String;
//         String batchHash = batchDetails[1] as String;
//         BigInt filesCount = batchDetails[2] as BigInt;
//         BigInt batchSize = batchDetails[3] as BigInt;
//         bool verified = batchDetails[4] as bool;

//         print('Owner DID: $ownerDid');
//         print('Batch Hash: $batchHash');
//         print('Files Count: $filesCount');
//         print('Batch Size: $batchSize');
//         print('Verified: $verified');
//         print('---');
//       }
//     } else {
//       print('No data returned from contract');
//     }
//   } catch (e) {
//     print('An error occurred: $e');
//   } finally {
//     print('Cleaning up');
//     httpClient.close();
//   }
// }



//   // Future<void> _deployContract() async {
//   //   var httpClient = Client();
//   //   try {
//   //     print('Fetching contract...');

//   //     // Setup Client
//   //     var rpcUrl =
//   //         'https://polygon-mainnet.infura.io/'; // Replace with your Infura project ID
//   //     var ethClient = Web3Client(rpcUrl, httpClient);
//   //     print('ethClient: $ethClient');

//   //     final EthereumAddress contractAddress =
//   //         EthereumAddress.fromHex('0x40C17A4bA53913838a3a013c572c190cA8be3052');
//   //     print('contractAddress: $contractAddress');

//   //     // Load the ABI file
//   //     String abiCode =
//   //         await rootBundle.loadString('assets/abi/FileStorage.json');
//   //     print('Raw ABI code: $abiCode'); // Print raw ABI code for debugging

//   //     // Decode the ABI JSON
//   //     Map<String, dynamic> jsonAbi;
//   //     try {
//   //       jsonAbi = jsonDecode(abiCode);
//   //       print('Decoded ABI JSON: $jsonAbi');
//   //     } catch (e) {
//   //       print('Error decoding ABI JSON: $e');
//   //       return; // Exit if decoding fails
//   //     }

//   //     // Ensure 'abi' key exists in the JSON
//   //     if (!jsonAbi.containsKey('abi')) {
//   //       print('ABI JSON does not contain "abi" key.');
//   //       return;
//   //     }

//   //     // final getAbiCod = jsonDecode(jsonEncode(abiCode['abi']));

//   //     // Encode ABI JSON
//   //     final String getAbiCode = jsonEncode(jsonAbi['abi']);
//   //     print('ABI loaded: $getAbiCode');

//   //     // Create contract instance
//   //     final contract = DeployedContract(
//   //       ContractAbi.fromJson(getAbiCode, 'FileStorage'),
//   //       contractAddress,
//   //     );
//   //     print('Contract1: $contract');

//   //     // Define the function to call
//   //     ContractFunction getAllBatchesFunction =
//   //         contract.function('getAllBatches');

//   //     print('Function: $getAllBatchesFunction');

//   //     print('ethClient12: $ethClient');

//   //     // Call the function
//   //     List<dynamic> result;
//   //     // print('result11: $result');
//   //     try {
//   //       print('ethClient11: $ethClient');
//   //       print('contract12: $contract');

//   //       result = await ethClient.call(
//   //         contract: contract,
//   //         function: getAllBatchesFunction,
//   //         params: [] ,
//   //       );
//   //       print('Raw Result: ${result[0].toString()}'); // Print raw result for debugging
//   //     } catch (e) {
//   //       print('Error calling the contract: $e');
//   //       return; // Exit if calling fails
//   //     }

//   //     print('Result: ${result[0]}'); // Print result for debugging

//   //     // Process the result
//   //     if (result.isNotEmpty) {
//   //       // The result should be a List of batches
//   //       List<dynamic> batches =
//   //           result[0]; // Get the first element which is the list of batches
//   //       print('Batches found: ${batches.length}');

//   //       for (var batch in batches) {
//   //         // Each batch is a tuple and needs to be cast to List<dynamic>
//   //         var batchDetails = batch as List<dynamic>;

//   //         // Extract details from each batch
//   //         String ownerDid = batchDetails[0] as String;
//   //         String batchHash = batchDetails[1] as String;
//   //         BigInt filesCount = batchDetails[2] as BigInt;
//   //         BigInt batchSize = batchDetails[3] as BigInt;
//   //         bool verified = batchDetails[4] as bool;

//   //         // Print details
//   //         print('Owner DID: $ownerDid');
//   //         print('Batch Hash: $batchHash');
//   //         print('Files Count: $filesCount');
//   //         print('Batch Size: $batchSize');
//   //         print('Verified: $verified');
//   //         print('---');
//   //       }
//   //     } else {
//   //       print('No batches found.');
//   //     }
//   //   } catch (e) {
//   //     print('An error occurred: $e');
//   //   } finally {
//   //     print('Cleaning up');
//   //     httpClient.close();
//   //   }
//   // }

//   Future<void> _uploadFiles() async {
//     setState(() {
//       _isLoading = true;
//     });

//     final storage = GetStorage();
//     final getDID = storage.read('did');
//     final walletAddress = storage.read('walletAddress');
//     print('did get: $getDID');

//     try {
//       for (var file in selectedFiles) {
//         final fileToSave = await saveFile(file);
//         // await WalletController.to.uploadFile(getDID, walletAddress, fileToSave);
//       }
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Files uploaded successfully!')),
//       );
//     } catch (e) {
//       print('Upload failed: $e');
//       setState(() {
//         selectedFiles.clear(); // Clear selected files on failure
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to upload files')),
//       );
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: Theme.of(context).primaryColor,
//         body: Column(
//           children: [
//             ListTile(
//               title: Row(
//                 children: [
//                   Image.asset('assets/images/launcher_icon.png',
//                       width: 30, height: 30),
//                   RichText(
//                     text: TextSpan(
//                       text: 'zkp',
//                       style: TextStyle(
//                         color: Theme.of(context).colorScheme.secondary,
//                         fontSize: 20,
//                         fontFamily: GoogleFonts.robotoMono().fontFamily,
//                         fontWeight: FontWeight.w300,
//                       ),
//                       children: [
//                         TextSpan(
//                           text: 'STORAGE',
//                           style: TextStyle(
//                             color: Theme.of(context).secondaryHeaderColor,
//                             fontSize: 20,
//                             fontFamily: GoogleFonts.robotoMono().fontFamily,
//                             fontWeight: FontWeight.w300,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               trailing: Container(
//                 width: 30,
//                 height: 30,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(20),
//                   border: Border.all(
//                     color: Theme.of(context).colorScheme.secondary,
//                     width: 1,
//                   ),
//                 ),
//                 child: Icon(
//                   Icons.wallet,
//                   color: Theme.of(context).secondaryHeaderColor,
//                   size: 20,
//                 ),
//               ),
//             ),
//             SizedBox(
//               width: MediaQuery.of(context).size.width,
//               height: MediaQuery.of(context).size.height / 10,
//               child: Container(
//                 decoration: BoxDecoration(),
//                 child: Center(
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text('0',
//                               style: TextStyle(
//                                   fontFamily:
//                                       GoogleFonts.robotoMono().fontFamily)),
//                           Text(
//                             'Files',
//                             style: TextStyle(
//                                 fontSize: 8,
//                                 fontFamily:
//                                     GoogleFonts.robotoMono().fontFamily),
//                           ),
//                         ],
//                       ),
//                       Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text('0MiB',
//                               style: TextStyle(
//                                   fontFamily:
//                                       GoogleFonts.robotoMono().fontFamily)),
//                           Text(
//                             'Usage',
//                             style: TextStyle(
//                                 fontSize: 8,
//                                 fontFamily:
//                                     GoogleFonts.robotoMono().fontFamily),
//                           ),
//                         ],
//                       ),
//                       GestureDetector(
//                         onTap: _isLoading
//                             ? null
//                             : openFile, // Directly open file picker
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 20.0),
//                           child: Container(
//                             width: MediaQuery.of(context).size.width / 3,
//                             alignment: Alignment.bottomCenter,
//                             decoration: BoxDecoration(
//                               color: Theme.of(context).primaryColor,
//                               borderRadius: BorderRadius.circular(6),
//                               border: const GradientBoxBorder(
//                                 gradient: LinearGradient(colors: [
//                                   Color(0xFFa3d902),
//                                   Color(0xFF2CFFAE)
//                                 ]),
//                                 width: 2,
//                               ),
//                             ),
//                             child: Center(
//                               child: _isLoading
//                                   ? CircularProgressIndicator(
//                                       color: Colors.white)
//                                   : Text(
//                                       'Select Files',
//                                       style: TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 10,
//                                         fontWeight: FontWeight.bold,
//                                         fontFamily:
//                                             GoogleFonts.robotoMono().fontFamily,
//                                       ),
//                                     ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             Expanded(child: _fileList())
//           ],
//         ),
//       ),
//     );
//   }

//   // Widget _fileList() {
//   //   return Padding(
//   //     padding: const EdgeInsets.symmetric(horizontal: 30.0),
//   //     child: Container(
//   //       child: selectedFiles.isEmpty
//   //           ? Center(child: Text('No files selected'))
//   //           : ListView.builder(
//   //               shrinkWrap: true,
//   //               itemCount: selectedFiles.length,
//   //               itemBuilder: (context, index) {
//   //                 final fileName = selectedFiles[index].name;
//   //                 return ListTile(
//   //                   tileColor: Theme.of(context).colorScheme.background.withOpacity(0.5),
//   //                   title: Row(
//   //                     children: [
//   //                       Icon(Icons.file_copy, color: Theme.of(context).colorScheme.secondary, size: 20),
//   //                       SizedBox(width: 10),
//   //                       Text(fileName, style: TextStyle(fontSize: 10)),
//   //                     ],
//   //                   ),
//   //                   trailing: Container(
//   //                     width: MediaQuery.of(context).size.width / 3,
//   //                     alignment: Alignment.bottomCenter,
//   //                     margin: const EdgeInsets.symmetric(vertical: 8),
//   //                     decoration: BoxDecoration(
//   //                       color: Theme.of(context).primaryColor,
//   //                       borderRadius: BorderRadius.circular(6),
//   //                       border: Border.all(color: Theme.of(context).colorScheme.secondary),
//   //                     ),
//   //                     child: Center(
//   //                       child: Text(
//   //                         'Download',
//   //                         style: TextStyle(
//   //                           color: Colors.white,
//   //                           fontSize: 10,
//   //                           fontWeight: FontWeight.w500,
//   //                           fontFamily: GoogleFonts.robotoMono().fontFamily,
//   //                         ),
//   //                       ),
//   //                     ),
//   //                   ),
//   //                 );
//   //               },
//   //             ),
//   //     ),
//   //   );
//   // }
//   Widget _fileList() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 30.0),
//       child: Container(
//         child: selectedFiles.isEmpty
//             ? Center(child: Text('No files selected'))
//             : ListView.builder(
//                 shrinkWrap: true,
//                 itemCount: selectedFiles.length,
//                 itemBuilder: (context, index) {
//                   final fileName = selectedFiles[index].name;
//                   return ListTile(
//                     tileColor: Theme.of(context)
//                         .colorScheme
//                         .background
//                         .withOpacity(0.5),
//                     title: Row(
//                       children: [
//                         Icon(Icons.file_copy,
//                             color: Theme.of(context).colorScheme.secondary,
//                             size: 20),
//                         SizedBox(width: 10),
//                         Text(fileName, style: TextStyle(fontSize: 10)),
//                       ],
//                     ),
//                     trailing: Container(
//                       width: MediaQuery.of(context).size.width / 3,
//                       alignment: Alignment.bottomCenter,
//                       margin: const EdgeInsets.symmetric(vertical: 8),
//                       decoration: BoxDecoration(
//                         color: Theme.of(context).primaryColor,
//                         borderRadius: BorderRadius.circular(6),
//                         border: Border.all(
//                             color: Theme.of(context).colorScheme.secondary),
//                       ),
//                       child: Center(
//                         child: Text(
//                           'Download',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 10,
//                             fontWeight: FontWeight.w500,
//                             fontFamily: GoogleFonts.robotoMono().fontFamily,
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//       ),
//     );
//   }

//   Future<File> saveFile(PlatformFile file) async {
//     final storage = await getApplicationDocumentsDirectory();
//     final newFile = File('${storage.path}/${file.name}');
//     return File(file.path!).copy(newFile.path);
//   }
// }
