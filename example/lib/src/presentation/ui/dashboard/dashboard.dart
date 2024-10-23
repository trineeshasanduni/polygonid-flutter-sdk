import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:polygonid_flutter_sdk_example/src/data/secure_storage.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/bethelBottomBar.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/dependency_injection/dependencies_provider.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/navigations/bottom_bar_navigations/plan_navigation.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/dashboard/bar.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/dashboard/customCurveEdge.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/dashboard/dashboard_bloc/dashboard_bloc.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/home/home_bloc.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/home/home_state.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/plans/widget/add_plans.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/register/presentation/widgets/setupPassword.dart';
import 'package:polygonid_flutter_sdk_example/utils/deploayContract.dart';
import 'package:polygonid_flutter_sdk_example/utils/secure_storage_keys.dart';
import 'package:web3modal_flutter/services/w3m_service/w3m_service.dart';
import 'package:web3modal_flutter/web3modal_flutter.dart';
import 'package:web3modal_flutter/widgets/w3m_account_button.dart';
import 'package:web3modal_flutter/widgets/w3m_connect_wallet_button.dart';
import 'package:web3modal_flutter/widgets/w3m_network_select_button.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

class Dashboard extends StatefulWidget {
  final String? did;

  const Dashboard({super.key, required this.did});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late W3MService _w3mService;
  bool isConnected = false;
  var httpClient = http.Client();

  Web3Client? _web3Client;
  var rpcUrl =
      'https://polygon-mainnet.g.alchemy.com/v2/pHKWzuctaLCPxAKYc0c8bKQA8d85oPlk';

  final _contractAddress = '0x665e346D9c68587Bd51C53eAd71e0F5367E7950C';

  final _AbiPath = 'assets/abi/FileStorage.json';
  final _contractAddress1 =
      EthereumAddress.fromHex('0x665e346D9c68587Bd51C53eAd71e0F5367E7950C');

  final _ContractAddress = '0x665e346D9c68587Bd51C53eAd71e0F5367E7950C';

  final storage = const FlutterSecureStorage();
  var _isUserAdded = false;
    late final DashboardBloc _dashboardBloc;



  @override
  void initState() {
    super.initState();
    _initW3MService();
    _initializeData();
    _deployGetUderDid();
      _dashboardBloc = getIt<DashboardBloc>();
    _initActivityLogs();
    
  }

  void _initW3MService() async {
    _w3mService = W3MService(
      projectId: 'fe65e1d4350f3699c3aa913768035e39',
      metadata: const PairingMetadata(
        name: 'Web3Modal Flutter Example',
        description: 'Web3Modal Flutter Example',
        url: 'https://www.walletconnect.com/',
        icons: ['https://walletconnect.com/walletconnect-logo.png'],
        redirect: Redirect(
          native: 'w3m://',
          universal: 'https://www.walletconnect.com',
        ),
      ),
    );
    await _w3mService.init();

    final WalletAddress = _w3mService.session?.address;
    print('walletAddress123: $WalletAddress');
    final storage = GetStorage();
    storage.write('walletAddress', WalletAddress);

    final WW = await storage.read('walletAddress');
    print('ww: $WW');

    // Ensure service is properly initialized
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(Duration(seconds: 3));
      // Set your desired delay
      print('timing');
      bool isConnect = await _w3mService.isConnected;

      print("isMetaMaskConnected11: $isConnect");
      setState(() {
        isConnected = isConnect;
      });
      if (isConnected == true) {
        print('connected: $isConnected');
        // _showWelcomeDialog();
        _deployContract();
      } else {
        _showMetamaskBottomSheet();
        // _deployContract();
      }
    });
    // _loadButtons();
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
      final did = jsonDecode(widget.did.toString());
      print('did dashboard: $did');
      final _contract = DeployedContract(_abiCode, _contractAddress1);
      final _getAllBatchesFunction = _contract.function('getAdressList');

      final storage = GetStorage();
      final walletAddress1 = storage.read('walletAddress');
      print('walletAddress1123: $walletAddress1');

      // Clear the current file list before fetching new data
      final result = await _web3Client?.call(
        contract: _contract,
        function: _getAllBatchesFunction,
        params: [did],
      );

      if (result != null && result.isNotEmpty && result[0] is List) {
        final List<dynamic> innerList = result[0];

        // Check if the inner list is empty
        if (innerList.isEmpty) {
          print('The result contains an empty list');
          _showWelcomeBottomSheet();
        } else {
          print('The result contains a non-empty list: $innerList');

          // Normalize the wallet address (trim, and convert to lowercase for comparison)
          final normalizedWalletAddress = walletAddress1?.toLowerCase().trim();

          // Check if the wallet address is in the inner list
          bool addressFound = innerList.any((address) =>
              address.toString().toLowerCase().trim() ==
              normalizedWalletAddress);

          if (addressFound) {
            print('Wallet address is in the list, no need to show alert');
          
          } else {
            print('innerList does not contain walletAddress1');
            // Show the alert since walletAddress1 is not in the inner list
            _showAddressDialog(innerList); // Pass the list of addresses
          }
        }
      } else {
        print('No data returned from contract or result format is unexpected');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }

  void _showAddressDialog(List<dynamic> addresses) {
    // Check if addresses are not empty
    if (addresses.isEmpty) {
      print('No addresses to show in the bottom sheet');
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
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
              mainAxisSize: MainAxisSize.min, // Adjust height based on content
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.center,
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
                Text(
                  'Please switch to Correct Wallet Address',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 12,
                    fontFamily: GoogleFonts.robotoMono().fontFamily,
                    fontWeight: FontWeight.w300,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                SingleChildScrollView(
                  child: ListBody(
                    children: addresses.asMap().entries.map((entry) {
                      int index = entry.key + 1; // Start numbering from 1
                      String address = entry.value.toString();

                      return Column(
                        children: [
                          Text(
                            '$index. $address',
                            style: TextStyle(
                              color: Theme.of(context).secondaryHeaderColor,
                              fontSize: 9,
                              fontFamily: GoogleFonts.robotoMono().fontFamily,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          Divider(
                            color: Theme.of(context)
                                .secondaryHeaderColor
                                .withOpacity(0.3),
                            thickness: 1,
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
               
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    ).then((_) {
      print('Bottom sheet closed'); // Confirm bottom sheet closure
    });
  }

  Future<void> _deployGetUderDid() async {
    final fileStorageService =
        FileStorageService(rpcUrl, _ContractAddress, _AbiPath);

    try {
      await fileStorageService.initializeWeb3Client();
      final did = jsonDecode(widget.did.toString());
      final contract = await fileStorageService.loadContract('FileStorage');
      final results = await fileStorageService
          .callContractFunction(contract, 'getUserDid', []);
      print('result12:${results}');
      if (results![0] == true) {
        setState(() {
          _isUserAdded = true;
        });
        print('free plan activated');
      } else {
        _isUserAdded = false;
        print('free plan not activated');

      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }

  void _loadButtons() {
    Column(
      children: !isConnected
          ? [
              W3MNetworkSelectButton(service: _w3mService),
              W3MConnectWalletButton(service: _w3mService),
            ]
          : [
              W3MAccountButton(service: _w3mService),
              // Text(WalletAddress.toString()),
            ],
    );
  }

void _showWelcomeBottomSheet() {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 3,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 68, 91, 0),
              Theme.of(context).primaryColor,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 4,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).secondaryHeaderColor.withOpacity(0.5),
                borderRadius: BorderRadius.circular(5),
              ),
              margin: const EdgeInsets.only(top: 5),
            ),
            const SizedBox(height: 20),
            Text(
              'Welcome!',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                fontFamily: GoogleFonts.robotoMono().fontFamily,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'You have no active plans. \nPlease navigate to Add Plans Page',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontFamily: GoogleFonts.robotoMono().fontFamily,
              ),
            ),
            TextButton(
              onPressed: () {
                // Navigator.pop(context); // Close the bottom sheet first
                PlanNav(did: widget.did,); // Navigate to PlanNav and push AddPlans
              },
              child: Text('Add Plans'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      );
    },
  );
}


  void _showMetamaskBottomSheet() {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    backgroundColor: Colors.transparent, // Transparent for custom background styling
    builder: (BuildContext context) {
      return Container(
        height: MediaQuery.of(context).size.height / 3,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 68, 91, 0),
              Theme.of(context).primaryColor,
            ], // Gradient background
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 4,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).secondaryHeaderColor.withOpacity(0.5),
                borderRadius: BorderRadius.circular(5),
              ),
              margin: const EdgeInsets.only(top: 5),
            ),
            const Text(
              'Welcome to \nBethelZkp Storage!',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            const Text(
              'You have to connect with MetaMask .',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            ),
            // Image.asset('assets/images/metamaskImg.png', width: 50, height: 50),
            Column(
                            children: !isConnected
                                ? [
                                    W3MNetworkSelectButton(service: _w3mService),
                                    W3MConnectWalletButton(service: _w3mService),
                                  ]
                                : [
                                    W3MAccountButton(
                                      service: _w3mService,
                                    ),
                                    W3MConnectWalletButton(service: _w3mService,
                                    
                                    ),
                                    // Text(WalletAddress.toString()),
                                  ],
                          ),
            const SizedBox(height: 20),
            
          ],
        ),
      );
    },
  );
}

  Future<void> _initializeData() async {
    // Your initialization logic here (fetching data, etc.)
    String? walletAddress = _w3mService.session?.address;
    if (walletAddress != null && walletAddress.isNotEmpty) {
      await SecureStorage.write(
        key: SecureStorageKeys.owner,
        value: walletAddress,
      );
      final storage = GetStorage();
      storage.write('walletAddress', walletAddress);
      print('Wallet address saved: $walletAddress');
    } else {
      print('Error: Wallet address is null or empty');
    }

    _initW3MService();
    _deployGetUderDid();

    // Any other initialization logic...
  }

  Future<void> _onRefresh() async {
    print("Refreshing data...");
    await _initializeData(); // Call the initialization logic again
    await Future.delayed(Duration(seconds: 2)); // Simulate a network call
  }

void _initActivityLogs() {
    if (widget.did != null) {
      _dashboardBloc.add(networkUsageEvent(did: widget.did!));
    } else {
      print('DID is null');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Safely assign WalletAddress, handling potential null values
    String? walletAddress = _w3mService.session?.address;
    String? account = _w3mService.session?.connectedWalletName;
    String? account1 = _w3mService.session?.getAccounts()?.first;
    print('account12: $account');
    print('account123: $account1');

    if (walletAddress != null && walletAddress.isNotEmpty) {
      // Write to SecureStorage, ensuring to await the async operation
      SecureStorage.write(
        key: SecureStorageKeys.owner,
        value: walletAddress,
      );

      // Write to GetStorage
      final storage = GetStorage();
      storage.write('walletAddress', walletAddress);

      print('Wallet address saved: $walletAddress');
    } else {
      print('Error: Wallet address is null or empty');
    }

    // final wA = storage.read(key: 'walletAddress');
    // print('Wallet Address: ${wA.toString()}');
    Map<String, double> dataMap = {
      "Files": 5,
      "Audio": 3,
      "Video": 2,
      "Images": 2,
    };

    final colorList = <Color>[
      const Color(0xFFa3d902),
      const Color.fromARGB(255, 95, 127, 0),
      const Color.fromARGB(255, 17, 148, 98),
      const Color(0xFF2CFFAE),
    ];
    return  Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: SafeArea(
          child: LiquidPullToRefresh(
            color: Theme.of(context).colorScheme.primary,
            onRefresh: _onRefresh,
            animSpeedFactor: 2.0,
            child: SingleChildScrollView(
              child: SizedBox(
                child: Column(
                  children: [
                    ListTile(
                      title: Row(
                        children: [
                          Image.asset('assets/images/launcher_icon.png',
                              width: 30, height: 30),
                          RichText(
                              text: TextSpan(
                                  text: 'zkp',
                                  style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.secondary,
                                      fontSize: 20,
                                      fontFamily:
                                          GoogleFonts.robotoMono().fontFamily,
                                      fontWeight: FontWeight.w300),
                                  children: [
                                TextSpan(
                                    text: 'STORAGE',
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .secondaryHeaderColor,
                                        fontSize: 20,
                                        fontFamily:
                                            GoogleFonts.robotoMono().fontFamily,
                                        fontWeight: FontWeight.w300))
                              ]))
                        ],
                      ),
                      subtitle:!isConnected? Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: Theme.of(context).colorScheme.secondary,
                                  width: 1)),
                          child: Column(
                            children: !isConnected
                                ? [
                                    W3MNetworkSelectButton(service: _w3mService),
                                    W3MConnectWalletButton(service: _w3mService,),
                                  ]
                                : [
                                    W3MAccountButton(
                                      service: _w3mService,
                                    ),
                                    W3MConnectWalletButton(service: _w3mService,
                                    
                                    ),
                                    // Text(WalletAddress.toString()),
                                  ],
                          ),
                        ),
                      ):null,
                      trailing: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          // color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: Theme.of(context).colorScheme.secondary,
                              width: 1),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            // _showWelcomeDialog();
                            // _deployContract();
                            // _showWelcomeBottomSheet();
                            _showMetamaskBottomSheet();
                          },
                          child: Image.asset('assets/images/metamaskImg.png',
                              width: 30, height: 30),
                          
                        ),
                      ),
                    ),

                    
          
                    ListTile(
                      title: Text('My Storage',
                          style: TextStyle(
                              color: Theme.of(context)
                                  .appBarTheme
                                  .titleTextStyle
                                  ?.color,
                              fontSize: 12,
                              fontFamily: GoogleFonts.robotoMono().fontFamily,
                              fontWeight: FontWeight.w300)),
                      trailing: GestureDetector(
                        onTap: () =>{},
                        child: Text('See all',
                            style: TextStyle(
                                color: Theme.of(context)
                                    .secondaryHeaderColor
                                    .withOpacity(0.3),
                                fontSize: 10,
                                fontFamily: GoogleFonts.robotoMono().fontFamily,
                                fontWeight: FontWeight.w300)),
                      ),
                    ),
                    _watchlist(),
                    SizedBox(height: 30),
                    _barChart(),
                    SizedBox(height: 30),
                    _recentUploads(),
                    SizedBox(height: 30),
                    // _pieChart(),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: PieChart(
                        dataMap: dataMap,
                        animationDuration: Duration(milliseconds: 800),
                        chartLegendSpacing: 32,
                        chartRadius: MediaQuery.of(context).size.width / 3.2,
                        colorList: colorList,
                        initialAngleInDegree: 0,
                        chartType: ChartType.ring,
                        ringStrokeWidth: 32,
                        centerText: "Storage",
                        legendOptions: LegendOptions(
                          showLegendsInRow: false,
                          legendPosition: LegendPosition.right,
                          showLegends: true,
                          // legendShape: _BoxShape.circle,
                          legendTextStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        chartValuesOptions: ChartValuesOptions(
                          showChartValueBackground: true,
                          showChartValues: true,
                          showChartValuesInPercentage: false,
                          showChartValuesOutside: false,
                          decimalPlaces: 1,
                        ),
                        // gradientList: ---To add gradient colors---
                        // emptyColorGradient: ---Empty Color gradient---
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      
    );
  }

  Widget _watchlist() {
    final List<Map<String, dynamic>> items = [
      // {'title': 'Folders', 'subtitle': 'Total', 'icon': Icons.folder, 'route': MyFiles()},
      {
        'title': 'Folders',
        'subtitle': 'Total',
        'icon': Icons.folder,
        'route': SetupPasswordScreen()
      },
      {
        'title': 'Files',
        'subtitle': 'Total',
        'icon': Icons.file_open,
        'route': ()
      },
      // {
      //   'title': 'Storage',
      //   'subtitle': 'Total',
      //   'icon': Icons.storage,
      //   'route': MyFiles()
      // },
    ];
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // Navigator.pushNamed(context, '/${items[index]['route']}');
              Navigator.pop(
                  context,
                  MaterialPageRoute(
                      builder: (context) => items[index]['route']));
            },
            child: Container(
              width: 115,
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                // color: Theme.of(context).colorScheme.secondary,
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Stack(
                children: [
                  //blur effect ==> the third layer of stack
                  BackdropFilter(
                    filter: ImageFilter.blur(
                      //sigmaX is the Horizontal blur
                      sigmaX: 4.0,
                      //sigmaY is the Vertical blur
                      sigmaY: 4.0,
                    ),
                  ),
                  //gradient effect ==> the second layer of stack
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white.withOpacity(0.13)),
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            //begin color
                            Colors.white.withOpacity(0.15),
                            //end color
                            Colors.white.withOpacity(0.05),
                          ]),
                    ),
                  ),

                  Positioned(
                    left: 2,
                    top: 2,
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                            color: Theme.of(context).colorScheme.secondary,
                            width: 1),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Icon(
                        items[index]['icon'],
                        color: Theme.of(context).secondaryHeaderColor,
                        size: 20,
                      ),
                    ),
                  ),

                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 0.0),
                          child:
                              // Row(
                              //   children: [
                              // Icon(
                              //   items[index]['icon'],
                              //   color: Theme.of(context).colorScheme.secondary,
                              //   size: 15,
                              // ),
                              Text(' ${items[index]['title']}',
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .appBarTheme
                                          .titleTextStyle
                                          ?.color,
                                      fontSize: 10,
                                      fontFamily:
                                          GoogleFonts.robotoMono().fontFamily,
                                      fontWeight: FontWeight.w300)),
                          // ],
                          // ),
                        ),
                        Text('${items[index]['subtitle']}',
                            style: TextStyle(
                                color: Theme.of(context)
                                    .appBarTheme
                                    .titleTextStyle!
                                    .color
                                    ?.withOpacity(0.5),
                                fontSize: 8,
                                fontFamily: GoogleFonts.robotoMono().fontFamily,
                                fontWeight: FontWeight.w300)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _barChart() {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: Stack(
        children: [
          Container(
            height: 220,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          ClipPath(
            clipper: CustomCurvedEdges(),
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
           LineChartSample2(did: widget.did),
          Positioned(
            right: 8,
            child: Container(
              height: 32,
              width: 92,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: (){_initActivityLogs();},
                      child: Text('Avg',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.background,
                              fontSize: 12,
                              fontFamily: GoogleFonts.robotoMono().fontFamily,
                              fontWeight: FontWeight.w300)),
                    ),
                    Icon(
                      Icons.arrow_drop_down,
                      color: Theme.of(context).colorScheme.background,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _recentUploads() {
    return Column(
      children: [
        ListTile(
          title: Text('Recent Uploads',
              style: TextStyle(
                  color: Theme.of(context).appBarTheme.titleTextStyle?.color,
                  fontSize: 12,
                  fontFamily: GoogleFonts.robotoMono().fontFamily,
                  fontWeight: FontWeight.w300)),
          trailing: GestureDetector(
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => SetupPasswordScreen())),
            child: Text('See all',
                style: TextStyle(
                    color:
                        Theme.of(context).secondaryHeaderColor.withOpacity(0.3),
                    fontSize: 10,
                    fontFamily: GoogleFonts.robotoMono().fontFamily,
                    fontWeight: FontWeight.w300)),
          ),
        ),
        _fileList(),
        _fileList(),
        // _fileList(),
      ],
    );
  }

  Widget _fileList() {
    return Container(
      child: ListTile(
        title: Row(
          children: [
            Icon(Icons.file_copy,
                color: Theme.of(context).colorScheme.secondary, size: 20),
            SizedBox(width: 10),
            Text(
              'File.png',
              style: TextStyle(fontSize: 10),
            ),
          ],
        ),
        trailing: Container(
          width: MediaQuery.of(context).size.width / 3,
          // height: 50,
          alignment: Alignment.bottomCenter,
          margin: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          child: Center(
            child: Text(
              'Download',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  fontFamily: GoogleFonts.robotoMono().fontFamily),
            ),
          ),
        ),
      ),
    );
  }
}
