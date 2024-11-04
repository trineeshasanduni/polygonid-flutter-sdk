// import 'dart:async';
// import 'dart:convert';
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:get/get.dart';
// import 'package:get/get_navigation/src/root/get_material_app.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:gradient_borders/box_borders/gradient_box_border.dart';
// import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
// import 'package:polygonid_flutter_sdk/identity/libs/bjj/eddsa_babyjub.dart';
// import 'package:polygonid_flutter_sdk_example/src/data/secure_storage.dart';
// import 'package:polygonid_flutter_sdk_example/src/presentation/bethelBottomBar.dart';
// import 'package:polygonid_flutter_sdk_example/src/presentation/dependency_injection/dependencies_provider.dart';
// import 'package:polygonid_flutter_sdk_example/src/presentation/navigations/bottom_bar_navigations/plan_navigation.dart';
// import 'package:polygonid_flutter_sdk_example/src/presentation/ui/common/widgets/circularProgress.dart';
// import 'package:polygonid_flutter_sdk_example/src/presentation/ui/create_wallet/loading.dart';
// import 'package:polygonid_flutter_sdk_example/src/presentation/ui/dashboard/widget/bar.dart';
// import 'package:polygonid_flutter_sdk_example/src/presentation/ui/dashboard/widget/customCurveEdge.dart';
// import 'package:polygonid_flutter_sdk_example/src/presentation/ui/dashboard/dashboard_bloc/dashboard_bloc.dart';
// import 'package:polygonid_flutter_sdk_example/src/presentation/ui/files/file_bloc/file_bloc.dart';
// import 'package:polygonid_flutter_sdk_example/src/presentation/ui/home/home_bloc.dart';
// import 'package:polygonid_flutter_sdk_example/src/presentation/ui/home/home_state.dart';
// import 'package:polygonid_flutter_sdk_example/src/presentation/ui/plans/widget/add_plans.dart';
// import 'package:polygonid_flutter_sdk_example/src/presentation/ui/register/presentation/widgets/setupPassword.dart';
// import 'package:polygonid_flutter_sdk_example/utils/deploayContract.dart';
// import 'package:polygonid_flutter_sdk_example/utils/secure_storage_keys.dart';
// import 'package:web3modal_flutter/services/w3m_service/w3m_service.dart';
// import 'package:web3modal_flutter/web3modal_flutter.dart';
// import 'package:web3modal_flutter/widgets/w3m_account_button.dart';
// import 'package:web3modal_flutter/widgets/w3m_connect_wallet_button.dart';
// import 'package:web3modal_flutter/widgets/w3m_network_select_button.dart';
// import 'package:pie_chart/pie_chart.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:http/http.dart' as http;

// class FileName {
//   final String fileName;
//   final String batchHash;
//   final String fileHash;
//   bool isVerified;

//   FileName(this.fileName, this.batchHash, this.fileHash, this.isVerified);
// }

// class Dashboard extends StatefulWidget {
//   final String? did;
//   // final bool isBlureffect;

//   const Dashboard({super.key, required this.did});

//   @override
//   State<Dashboard> createState() => _DashboardState();
// }

// class _DashboardState extends State<Dashboard> {
//   late W3MService _w3mService;
//   bool isConnected = false;
//   var name;
//   var httpClient = http.Client();

//   late final FileBloc _fileBloc;

//   Web3Client? _web3Client;
//   var rpcUrl =
//       'https://polygon-mainnet.g.alchemy.com/v2/pHKWzuctaLCPxAKYc0c8bKQA8d85oPlk';

//   final _contractAddress =
//       EthereumAddress.fromHex('0x665e346D9c68587Bd51C53eAd71e0F5367E7950C');

//   final _AbiPath = 'assets/abi/FileStorage.json';
//   final _contractAddress1 =
//       EthereumAddress.fromHex('0x665e346D9c68587Bd51C53eAd71e0F5367E7950C');

//   final _ContractAddress = '0x665e346D9c68587Bd51C53eAd71e0F5367E7950C';

//   final _invoiceAbiPath = 'assets/abi/BethelInvoice.json';

//   final _InvoidContractAddress = '0xB05c8A8c54DDA3E4e785FD033AB63a50e09b9521';

//   final storage = GetStorage();
//   var _isUserAdded = false;
//   var _isBlureffect = false;
//   late final DashboardBloc _dashboardBloc;

//   String _fileCount = '0';
//   String _folderCount = '0';
//   String _fileUsage = '0 MB';
//   double _fileUsagePieChart = 0;
//   double _packageSpace = 0;
//   List<FileName> fileDataList = [];

//   List<dynamic> dataResult = [];
//   bool _isRequestInProgress = false;

//   @override
//   void initState() {
//     super.initState();
//     _fileBloc = getIt<FileBloc>();
//     _initW3MService();
//     _initializeData();
//     _deployGetUderDid();
//     _dashboardBloc = getIt<DashboardBloc>();
//     _initActivityLogs();
//     _deployFileCount();
//     _deployPackageSpace();
//     _deployBatchHash();
//   }

//   void _initW3MService() async {
//     _w3mService = W3MService(
//       projectId: 'fe65e1d4350f3699c3aa913768035e39',
//       metadata: const PairingMetadata(
//         name: 'Web3Modal Flutter Example',
//         description: 'Web3Modal Flutter Example',
//         url: 'https://www.walletconnect.com/',
//         icons: ['https://walletconnect.com/walletconnect-logo.png'],
//         redirect: Redirect(
//           native: 'w3m://',
//           universal: 'https://www.walletconnect.com',
//         ),
//       ),
//     );
//     await _w3mService.init();

//     final WalletAddress = _w3mService.session?.address;
//     final topic = _w3mService.session?.topic;

//     final storage = GetStorage();
//     storage.write('walletAddress', WalletAddress);

//     final WW = await storage.read('walletAddress');

//     // Ensure service is properly initialized
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       await Future.delayed(Duration(seconds: 3));
//       // Set your desired delay
//       bool isConnect = await _w3mService.isConnected;

//       final getName = await _w3mService.session?.connectedWalletName;
//       storage.write('walletName', getName);

//       storage.write('isConnected', isConnect);

//       // isConnected = storage.read('isConnected');

//       setState(() {
//         isConnected = storage.read('isConnected');
//         name = storage.read('walletName');
//       });
//       if (isConnected == true) {
//         // _showWelcomeDialog();
//         _deployContract();
//         // _isBlureffect = false;
//       } else {
//         // _showMetamaskBottomSheet();
//         // _isBlureffect = widget.isBlureffect;
//         // _deployContract();
//       }
//     });
//     // _loadButtons();
//   }

//   Future<void> _deployFileCount() async {
//     final fileStorageService =
//         FileStorageService(rpcUrl, _ContractAddress, _AbiPath);

//     try {
//       await fileStorageService.initializeWeb3Client();
//       final did = jsonDecode(widget.did.toString());
//       final contract = await fileStorageService.loadContract('FileStorage');
//       final result = await fileStorageService
//           .callContractFunction(contract, 'getTotalFilesCount', []);

//       final fileSizeInBytes = (result![1] as BigInt).toInt();
//       final fileSizeInMiB = fileSizeInBytes / (1024 * 1024);

//       setState(() {
//         _fileCount = result![0].toString();
//         _fileUsage = '${fileSizeInMiB.toStringAsFixed(2)}' + 'MiB';
//         final doubleValue = double.parse(_fileUsage);
//         double _fileUsagePieChart =
//             double.parse(doubleValue.toStringAsFixed(2));
//         ;

//         print('fileUsage pie: $doubleValue');
//       });
//     } catch (e) {}
//   }

//   Future<void> _deployPackageSpace() async {
//     final fileStorageService =
//         FileStorageService(rpcUrl, _InvoidContractAddress, _invoiceAbiPath);

//     try {
//       await fileStorageService.initializeWeb3Client();
//       final did = jsonDecode(widget.did.toString());
//       final contract = await fileStorageService.loadContract('BethelInvoice');
//       final result = await fileStorageService
//           .callContractFunction(contract, 'checkPackageSpace', [did]);

//       final fileSizeInBytes = (result![0] as BigInt).toInt();
//       final fileSizeInMiB = fileSizeInBytes / (1024 * 1024);

//       setState(() {
//         _packageSpace = fileSizeInBytes / (1024);
//       });

//       print('space: $fileSizeInMiB');
//     } catch (e) {}
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
//       final did = jsonDecode(widget.did.toString());
//       final _contract = DeployedContract(_abiCode, _contractAddress1);
//       final _getAllBatchesFunction = _contract.function('getAdressList');

//       final storage = GetStorage();
//       final walletAddress1 = storage.read('walletAddress');

//       // Clear the current file list before fetching new data
//       final result = await _web3Client?.call(
//         contract: _contract,
//         function: _getAllBatchesFunction,
//         params: [did],
//       );

//       if (result != null && result.isNotEmpty && result[0] is List) {
//         final List<dynamic> innerList = result[0];

//         // Check if the inner list is empty
//         if (innerList.isEmpty) {
//           // _isBlureffect = widget.isBlureffect;
//           // _showWelcomeBottomSheet();
//         } else {
//           // _isBlureffect = !widget.isBlureffect;

//           // Normalize the wallet address (trim, and convert to lowercase for comparison)
//           final normalizedWalletAddress = walletAddress1?.toLowerCase().trim();

//           // Check if the wallet address is in the inner list
//           bool addressFound = innerList.any((address) =>
//               address.toString().toLowerCase().trim() ==
//               normalizedWalletAddress);

//           if (addressFound) {
//           } else {
//             // Show the alert since walletAddress1 is not in the inner list
//             // _showAddressDialog(innerList); // Pass the list of addresses
//           }
//         }
//       } else {}
//     } catch (e) {}
//   }

//   Future<void> _deployBatchHash() async {
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

//       // ** Clear the current file list before fetching new data **
//       setState(() {
//         dataResult.clear(); // Clear the list to prevent duplication
//         fileDataList.clear(); // Also clear any fileDataList if used
//       });

//       final result = await _web3Client?.call(
//         contract: _contract,
//         function: _getAllBatchesFunction,
//         params: [],
//         sender: EthereumAddress.fromHex(walletAddress1),
//       );

//       if (result!.isNotEmpty && result?[0] is List) {
//         print('list result dash: ${result[0]}');
//         setState(() {
//           dataResult = List<dynamic>.from(result[0]);
//           WidgetsBinding.instance.addPostFrameCallback((_) {
//             processFileNameResult(dataResult);
//           });
//         });
//       } else {
//         print('No data returned from contract or result format is unexpected');
//       }
//     } catch (e) {
//       print('An error occurred: $e');
//     }
//   }

//   Future<void> processFileNameResult(List<dynamic> dataResult) async {
//     if (_isRequestInProgress) {
//       return;
//     }

//     setState(() {
//       _isRequestInProgress = true;
//       fileDataList.clear(); // Clear the list before adding new data
//     });

//     // Set to store unique batch hashes and avoid duplicate requests
//     Set<String> fetchedBatchHashes = {};

//     // Keep track of the number of files fetched
//     int filesFetched = 0;
//     final totalFiles = dataResult.length;

//     print('total files dash: $totalFiles');

//     // Cancel previous listeners and use StreamSubscription to properly manage the stream
//     StreamSubscription? fileBlocSubscription;

//     // Subscribe to the stream and process file names
//     fileBlocSubscription = _fileBloc.stream.listen((state) {
//       if (state is FileNameLoaded) {
//         final batchHash = state.fileName.batchHash.toString();

//         // Check if the file has already been added based on batch hash
//         if (!fetchedBatchHashes.contains(batchHash)) {
//           setState(() {
//             fileDataList.add(FileName(
//                 state.fileName.fileName.toString(),
//                 batchHash,
//                 state.fileName.fileHash.toString(),
//                 state.fileName.isVerified!));
//           });

//           // Mark this batch hash as fetched to prevent duplicates
//           fetchedBatchHashes.add(batchHash);
//           filesFetched++;
//           print('File data added dash: ${fileDataList.last}');
//         }

//         // Check if all files have been fetched
//         if (filesFetched >= totalFiles) {
//           print('All files fetched successfully dash.');
//           _isRequestInProgress = false;

//           // Cancel the stream subscription to avoid further unnecessary listening
//           fileBlocSubscription?.cancel();
//         }
//       }
//     });

//     try {
//       for (var batchDetails in dataResult) {
//         final batchHash = batchDetails[1].toString();
//         final verify = batchDetails[4].toString();
//         print('Requesting file for batchHash: $batchHash');
//         print('verify: $verify');

//         // Only fetch if this batchHash hasn't been fetched already
//         if (!fetchedBatchHashes.contains(batchHash) &&
//             filesFetched < totalFiles) {
//           await Future.delayed(const Duration(milliseconds: 500), () {
//             _fileBloc
//                 .add(GetFileNameEvent(BatchHash: batchHash, Verify: verify));
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

//   void _showAddressDialog(List<dynamic> addresses) {
//     // Check if addresses are not empty
//     if (addresses.isEmpty) {
//       return;
//     }

//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       backgroundColor: Colors.transparent, // Customize background
//       builder: (BuildContext context) {
//         return Container(
//           height: MediaQuery.of(context).size.height / 3,
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [
//                 Color.fromARGB(255, 68, 91, 0),
//                 Theme.of(context).primaryColor,
//               ], // Add your gradient colors here
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//             ),
//             borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
//           ),
//           child: Padding(
//             padding: EdgeInsets.only(
//               bottom: MediaQuery.of(context)
//                   .viewInsets
//                   .bottom, // Handle keyboard overlap
//               left: 16,
//               right: 16,
//               top: 16,
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min, // Adjust height based on content
//               crossAxisAlignment: CrossAxisAlignment.start,
//               // mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Center(
//                   child: Container(
//                     width: MediaQuery.of(context).size.width / 6,
//                     height: 4,
//                     decoration: BoxDecoration(
//                       color: Theme.of(context)
//                           .secondaryHeaderColor
//                           .withOpacity(0.5),
//                       borderRadius: BorderRadius.circular(5),
//                     ),
//                     margin: const EdgeInsets.only(top: 5),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 Text(
//                   'Please Use Correct Wallet Address',
//                   style: TextStyle(
//                     color: Theme.of(context).colorScheme.secondary,
//                     fontSize: 12,
//                     fontFamily: GoogleFonts.robotoMono().fontFamily,
//                     fontWeight: FontWeight.w300,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 20),
//                 SingleChildScrollView(
//                   child: ListBody(
//                     children: addresses.asMap().entries.map((entry) {
//                       int index = entry.key + 1; // Start numbering from 1
//                       String address = entry.value.toString();

//                       return Column(
//                         children: [
//                           Text(
//                             '$index. $address',
//                             style: TextStyle(
//                               color: Theme.of(context).secondaryHeaderColor,
//                               fontSize: 9,
//                               fontFamily: GoogleFonts.robotoMono().fontFamily,
//                               fontWeight: FontWeight.w300,
//                             ),
//                           ),
//                           Divider(
//                             color: Theme.of(context)
//                                 .secondaryHeaderColor
//                                 .withOpacity(0.3),
//                             thickness: 1,
//                           ),
//                         ],
//                       );
//                     }).toList(),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//               ],
//             ),
//           ),
//         );
//       },
//     ).then((_) {});
//   }

//   Future<void> _deployGetUderDid() async {
//     final fileStorageService =
//         FileStorageService(rpcUrl, _ContractAddress, _AbiPath);

//     try {
//       await fileStorageService.initializeWeb3Client();
//       final did = jsonDecode(widget.did.toString());
//       final contract = await fileStorageService.loadContract('FileStorage');
//       final results = await fileStorageService
//           .callContractFunction(contract, 'getUserDid', []);
//       print('result12:${results}');
//       if (results![0] == true) {
//         setState(() {
//           _isUserAdded = true;
//         });
//         print('getUserDid ');
//       } else {
//         _isUserAdded = false;
//         print('getUserDid not activated');
//       }
//     } catch (e) {
//       print('An error occurred: $e');
//     }
//   }

//   Widget _loadButtons() {
//     final iSConnect = storage.read('isConnected');
//     return Column(
//       children: !iSConnect
//           ? [
//               W3MNetworkSelectButton(
//                 service: _w3mService,
//               ),
//               W3MConnectWalletButton(
//                 service: _w3mService,
//               ),
//             ]
//           : [
//               W3MAccountButton(service: _w3mService),
//               W3MConnectWalletButton(service: _w3mService),

//               // Text(WalletAddress.toString()),
//             ],
//     );
//   }

//   void _showWelcomeBottomSheet() {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       backgroundColor: Colors.transparent,
//       builder: (BuildContext context) {
//         return Container(
//           width: MediaQuery.of(context).size.width,
//           height: MediaQuery.of(context).size.height / 3,
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [
//                 Color.fromARGB(255, 68, 91, 0),
//                 Theme.of(context).primaryColor,
//               ],
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//             ),
//             borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
//           ),
//           padding: EdgeInsets.only(
//             bottom: MediaQuery.of(context).viewInsets.bottom,
//             left: 16,
//             right: 16,
//             top: 16,
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Container(
//                 width: MediaQuery.of(context).size.width / 6,
//                 height: 4,
//                 decoration: BoxDecoration(
//                   color:
//                       Theme.of(context).secondaryHeaderColor.withOpacity(0.5),
//                   borderRadius: BorderRadius.circular(5),
//                 ),
//                 margin: const EdgeInsets.only(top: 5),
//               ),
//               const SizedBox(height: 20),
//               Text(
//                 'Welcome!',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 18,
//                   fontFamily: GoogleFonts.robotoMono().fontFamily,
//                 ),
//               ),
//               const SizedBox(height: 10),
//               Text(
//                 'You have no active plans. \nPlease navigate to Add Plans Page',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontFamily: GoogleFonts.robotoMono().fontFamily,
//                 ),
//               ),
//               TextButton(
//                 onPressed: () {
//                   // Navigator.pop(context); // Close the bottom sheet first
//                   PlanNav(
//                     did: widget.did,
//                     // isBlureffect: widget.isBlureffect,
//                   ); // Navigate to PlanNav and push AddPlans
//                 },
//                 child: Text('Add Plans'),
//               ),
//               const SizedBox(height: 20),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   void _showMetamaskBottomSheet() {
//     final iSConnect = storage.read('isConnected');
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       backgroundColor:
//           Colors.transparent, // Transparent for custom background styling
//       builder: (BuildContext context) {
//         return Container(
//           height: MediaQuery.of(context).size.height / 3,
//           width: MediaQuery.of(context).size.width,
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [
//                 Color.fromARGB(255, 68, 91, 0),
//                 Theme.of(context).primaryColor,
//               ], // Gradient background
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//             ),
//             borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
//           ),
//           padding: EdgeInsets.only(
//             bottom: MediaQuery.of(context).viewInsets.bottom,
//             left: 16,
//             right: 16,
//             top: 16,
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               Container(
//                 width: MediaQuery.of(context).size.width / 4,
//                 height: 4,
//                 decoration: BoxDecoration(
//                   color:
//                       Theme.of(context).secondaryHeaderColor.withOpacity(0.5),
//                   borderRadius: BorderRadius.circular(5),
//                 ),
//                 margin: const EdgeInsets.only(top: 5),
//               ),
//               const Text(
//                 'Welcome to \nBethelZkp Storage!',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 18,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               Text(
//                 iSConnect
//                     ? ' You are connected with Metamask'
//                     : 'You have to connect with Any Wallet',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(fontSize: 14),
//               ),
//               // Image.asset('assets/images/metamaskImg.png', width: 50, height: 50),
//               Column(
//                 children: !iSConnect
//                     ? [
//                         W3MNetworkSelectButton(service: _w3mService),
//                         W3MConnectWalletButton(service: _w3mService),
//                       ]
//                     : [
//                         W3MAccountButton(
//                           service: _w3mService,
//                         ),
//                         W3MConnectWalletButton(
//                           service: _w3mService,
//                         ),
//                         // Text(WalletAddress.toString()),
//                       ],
//               ),
//               const SizedBox(height: 20),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Future<void> _initializeData() async {
//     // Your initialization logic here (fetching data, etc.)
//     String? walletAddress = _w3mService.session?.address;

    
//     if (walletAddress != null && walletAddress.isNotEmpty) {
//       await SecureStorage.write(
//         key: SecureStorageKeys.owner,
//         value: walletAddress,
//       );
//       final storage = GetStorage();
//       storage.write('walletAddress', walletAddress);
//       print('Wallet address saved: $walletAddress');
//     } else {
//       print('Error: Wallet address is null or empty');
//     }

//     _initW3MService();
//     _deployGetUderDid();
//     _deployFileCount();
//     _deployPackageSpace();
//     _deployBatchHash();

//     // Any other initialization logic...
//   }

//   Future<void> _onRefresh() async {
//     print("Refreshing data...");
//     await _initializeData(); // Call the initialization logic again
//     await Future.delayed(Duration(seconds: 2)); // Simulate a network call
//   }

//   void _initActivityLogs() {
//     if (widget.did != null) {
//       _dashboardBloc.add(networkUsageEvent(did: widget.did!));
//     } else {
//       print('DID is null');
//     }
//   }

//   @override
// Widget build(BuildContext context) {
//   final isFreePlan = storage.read('isFreePlanActivated');
//   return Scaffold(
//     backgroundColor: Theme.of(context).primaryColor,
//     body: SafeArea(
//       child: LiquidPullToRefresh(
//         color: Theme.of(context).colorScheme.primary,
//         onRefresh: _onRefresh,
//         animSpeedFactor: 2.0,
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               ListTile(
//                 title: Row(
//                   children: [
//                     Image.asset('assets/images/launcher_icon.png', width: 30, height: 30),
//                     RichText(
//                       text: TextSpan(
//                         text: 'zkp',
//                         style: TextStyle(
//                           color: Theme.of(context).colorScheme.secondary,
//                           fontSize: 20,
//                           fontFamily: GoogleFonts.robotoMono().fontFamily,
//                           fontWeight: FontWeight.w300,
//                         ),
//                         children: [
//                           TextSpan(
//                             text: 'STORAGE',
//                             style: TextStyle(
//                               color: Theme.of(context).secondaryHeaderColor,
//                               fontSize: 20,
//                               fontFamily: GoogleFonts.robotoMono().fontFamily,
//                               fontWeight: FontWeight.w300,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 trailing: _buildWalletIcon(),
//               ),
//               Stack(
//                 children: [
//                   Column(
//                     children: [
//                       ListTile(
//                         title: Text(
//                           'My Storage',
//                           style: TextStyle(
//                             color: Theme.of(context).appBarTheme.titleTextStyle?.color,
//                             fontSize: 12,
//                             fontFamily: GoogleFonts.robotoMono().fontFamily,
//                             fontWeight: FontWeight.w300,
//                           ),
//                         ),
//                       ),
//                       _watchlist(),
//                       SizedBox(height: 30),
//                       _buildPieChart(),
//                       _recentUploads(),
//                       SizedBox(height: 30),
//                     ],
//                   ),
//                   if (isFreePlan == null || !isFreePlan)
//                     _buildBlurEffect(),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     ),
//   );
// }

// Widget _buildWalletIcon() {
//   return Container(
//     width: 30,
//     height: 30,
//     decoration: BoxDecoration(
//       borderRadius: BorderRadius.circular(20),
//       border: Border.all(
//         color: Theme.of(context).colorScheme.secondary,
//         width: 1,
//       ),
//     ),
//     child: GestureDetector(
//       onTap: _showMetamaskBottomSheet,
//       child: name != null && name == "MetaMask Wallet"
//           ? Image.asset('assets/images/metamaskImg.png')
//           : Icon(Icons.wallet),
//     ),
//   );
// }

// Widget _buildPieChart() {
//   return Padding(
//     padding: const EdgeInsets.only(bottom: 20.0),
//     child: PieChart(
//       dataMap: {
//         "Used": 3,
//         "Remains": 3,
//       },
//       colorList: [
//         const Color(0xFFa3d902),
//         const Color(0xFF2CFFAE),
//       ],
//       animationDuration: Duration(milliseconds: 800),
//       chartLegendSpacing: 32,
//       chartRadius: MediaQuery.of(context).size.width / 2.5,
//       chartType: ChartType.ring,
//       ringStrokeWidth: 32,
//       centerText: "Storage",
//       legendOptions: LegendOptions(
//         showLegends: true,
//         legendPosition: LegendPosition.right,
//       ),
//       chartValuesOptions: ChartValuesOptions(
//         showChartValues: true,
//         decimalPlaces: 2,
//       ),
//     ),
//   );
// }

// Widget _buildBlurEffect() {
//   return BackdropFilter(
//     filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
//     child: Container(
//       color: Colors.red.withOpacity(0.1),
//     ),
//   );
// }


//   Widget _watchlist() {
//     final List<Map<String, dynamic>> items = [
//       // {'title': 'Folders', 'subtitle': 'Total', 'icon': Icons.folder, 'route': MyFiles()},
//       {
//         'title': 'Folders',
//         'subtitle': 'Total',
//         'icon': Icons.folder,
//         'data': _folderCount
//       },
//       {
//         'title': 'Files',
//         'subtitle': 'Total',
//         'icon': Icons.file_open,
//         'data': _fileCount,
//       },
//       {
//         'title': 'Storage Plan',
//         'subtitle': 'Status',
//         'icon': Icons.storage,
//         'data': '$_fileUsage / 1 GB',
//       },
//     ];
//     return SizedBox(
//       height: 120,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: items.length,
//         itemBuilder: (context, index) {
//           return Container(
//             width: 115,
//             margin: const EdgeInsets.all(10),
//             decoration: BoxDecoration(
//               // color: Theme.of(context).colorScheme.secondary,
//               color: Colors.green.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Stack(
//               children: [
//                 //blur effect ==> the third layer of stack
//                 BackdropFilter(
//                   filter: ImageFilter.blur(
//                     //sigmaX is the Horizontal blur
//                     sigmaX: 4.0,
//                     //sigmaY is the Vertical blur
//                     sigmaY: 4.0,
//                   ),
//                 ),
//                 //gradient effect ==> the second layer of stack
//                 Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                     border: Border.all(color: Colors.white.withOpacity(0.13)),
//                     gradient: LinearGradient(
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                         colors: [
//                           //begin color
//                           Colors.white.withOpacity(0.15),
//                           //end color
//                           Colors.white.withOpacity(0.05),
//                         ]),
//                   ),
//                 ),

//                 Positioned(
//                   left: 2,
//                   top: 2,
//                   child: Container(
//                     width: 30,
//                     height: 30,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(50),
//                       border: Border.all(
//                           color: Theme.of(context).colorScheme.secondary,
//                           width: 1),
//                       color: Theme.of(context).primaryColor,
//                     ),
//                     child: Icon(
//                       items[index]['icon'],
//                       color: Theme.of(context).secondaryHeaderColor,
//                       size: 20,
//                     ),
//                   ),
//                 ),

//                 Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       SizedBox(
//                         height: 10,
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 0.0),
//                         child:
//                             // Row(
//                             //   children: [
//                             // Icon(
//                             //   items[index]['icon'],
//                             //   color: Theme.of(context).colorScheme.secondary,
//                             //   size: 15,
//                             // ),
//                             Text(' ${items[index]['title']}',
//                                 style: TextStyle(
//                                     color: Theme.of(context)
//                                         .appBarTheme
//                                         .titleTextStyle
//                                         ?.color,
//                                     fontSize: 10,
//                                     fontFamily:
//                                         GoogleFonts.robotoMono().fontFamily,
//                                     fontWeight: FontWeight.w300)),
//                         // ],
//                         // ),
//                       ),
//                       Text('${items[index]['subtitle']}',
//                           style: TextStyle(
//                               color: Theme.of(context)
//                                   .appBarTheme
//                                   .titleTextStyle!
//                                   .color
//                                   ?.withOpacity(0.5),
//                               fontSize: 8,
//                               fontFamily: GoogleFonts.robotoMono().fontFamily,
//                               fontWeight: FontWeight.w300)),
//                       Text('${items[index]['data']} ',
//                           style: TextStyle(
//                               color: Theme.of(context)
//                                   .appBarTheme
//                                   .titleTextStyle!
//                                   .color
//                                   ?.withOpacity(0.5),
//                               fontSize: 9,
//                               fontFamily: GoogleFonts.robotoMono().fontFamily,
//                               fontWeight: FontWeight.w300)),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _barChart() {
//     return Padding(
//       padding: const EdgeInsets.only(left: 8.0, right: 8.0),
//       child: Stack(
//         children: [
//           Container(
//             height: 220,
//             decoration: BoxDecoration(
//               color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(20),
//             ),
//           ),
//           ClipPath(
//             clipper: CustomCurvedEdges(),
//             child: Container(
//               height: 200,
//               decoration: BoxDecoration(
//                 color: Theme.of(context).primaryColor,
//                 borderRadius: BorderRadius.circular(20),
//               ),
//             ),
//           ),
//           LineChartSample2(did: widget.did),
//         ],
//       ),
//     );
//   }

//   Widget _recentUploads() {
//     return Container(
//       height: 200,
//       child: Column(
//         children: [
//           ListTile(
//             title: Text('Recent Uploads',
//                 style: TextStyle(
//                     color: Theme.of(context).appBarTheme.titleTextStyle?.color,
//                     fontSize: 12,
//                     fontFamily: GoogleFonts.robotoMono().fontFamily,
//                     fontWeight: FontWeight.w300)),
//           ),
//           buildFileList()
//           // _fileList(),
//         ],
//       ),
//     );
//   }

//   // void _fileNameList() {
//   //   _fileBloc.add(GetFileNameOnlyEvent(BatchHash: ));
//   // }

//   Widget buildFileList() {
//     final startIndex = fileDataList.length > 2 ? fileDataList.length - 2 : 0;
//     // Determine the starting index to get the last two items
//     if (startIndex <= 0) {
//       return Center(
//         child: Loading(
//             Loadingcolor: Theme.of(context).primaryColor,
//             color: Theme.of(context).colorScheme.secondary),
//       );
//     } else {
//       return Expanded(
//         child: ListView.builder(
//           itemCount: fileDataList.length >= 2 ? 2 : fileDataList.length,
//           itemBuilder: (context, index) {
//             // Access the last two items
//             final fileData = fileDataList[startIndex + (1 - index)];

//             print('batchHash dash: ${fileData.batchHash}');
//             print('fileHash dash: ${fileData.fileHash}');
//             print('fileName dash: ${fileData.fileName}');
//             print('isVerified dash: ${fileData.isVerified}');

//             return Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: ListTile(
//                 tileColor:
//                     Theme.of(context).colorScheme.secondary.withOpacity(0.1),
//                 leading: Icon(
//                   Icons.file_copy,
//                   color: Colors.white,
//                   size: 20,
//                 ),
//                 title: Text(
//                   fileData.fileName,
//                   overflow: TextOverflow.ellipsis,
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontFamily: GoogleFonts.robotoMono().fontFamily,
//                     fontSize: 12,
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       );
//     }
//   }
// }
