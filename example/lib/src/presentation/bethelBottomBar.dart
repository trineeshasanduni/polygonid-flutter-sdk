import 'dart:async';
import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
// import 'package:custom_navigator/custom_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/navigations/bottom_bar_navigations/claims_navigation.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/navigations/bottom_bar_navigations/file_navigation.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/navigations/bottom_bar_navigations/dashBoard_navigation.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/navigations/bottom_bar_navigations/plan_navigation.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/navigations/bottom_bar_navigations/profile_navigation.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/plans/widget/add_plans.dart';
import 'package:polygonid_flutter_sdk_example/utils/deploayContract.dart';
import 'package:web3modal_flutter/web3modal_flutter.dart';
import 'package:http/http.dart' as http;

class BethelBottomBar extends StatefulWidget {
  final String? did;
  const BethelBottomBar({
    super.key,
    required this.did,
  });

  @override
  BethelBottomBarState createState() => BethelBottomBarState();
}

class BethelBottomBarState extends State<BethelBottomBar> {
  int currentIndex = 0;
  var httpClient = http.Client();
  Web3Client? _web3Client;
  var rpcUrl =
      'https://polygon-mainnet.g.alchemy.com/v2/pHKWzuctaLCPxAKYc0c8bKQA8d85oPlk';

  final _contractAddress = '0x665e346D9c68587Bd51C53eAd71e0F5367E7950C';

  final _AbiPath = 'assets/abi/FileStorage.json';
  final _contractAddress1 =
      EthereumAddress.fromHex('0x665e346D9c68587Bd51C53eAd71e0F5367E7950C');

  final _ContractAddress = '0x665e346D9c68587Bd51C53eAd71e0F5367E7950C';

  final _invoiceAbiPath = 'assets/abi/BethelInvoice.json';

  final _InvoidContractAddress = '0xB05c8A8c54DDA3E4e785FD033AB63a50e09b9521';

  bool _isBlureffect = false;
  late W3MService _w3mService;
  bool isConnected = false;
  bool _isFreePlanActivated = false;

  final storage = GetStorage();

  @override
  void initState() {
    super.initState();
    _initW3MService();
    _deployPlans();
    _deployContract();
    print('fetching did: ${widget.did}');

    _startMetaMaskConnectionCheck();
  }

  void _startMetaMaskConnectionCheck() {
    Timer.periodic(Duration(seconds: 10), (timer) async {
      bool isMetaMaskConnected = await _w3mService.isConnected;
      if (isMetaMaskConnected && !isConnected) {
        // MetaMask connected, update state and refresh
        setState(() {
          isConnected = true;
        });
        _handleMetaMaskConnection();
      } else if (!isMetaMaskConnected && isConnected) {
        // MetaMask disconnected, handle it
        print('MetaMask disconnected. Reinitializing...');
        _handleMetaMaskDisconnection();
      }
    });
  }

  void _handleMetaMaskConnection() {
    print('MetaMask connected. Refreshing app...');

    // Reinitialize services
    // _initW3MService();
    // _deployPlans();
    // _deployContract();

    // Optionally, you can refresh the entire page if needed
    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(builder: (BuildContext context) => super.widget),
    // );
  }

  // Handle MetaMask disconnection and reinitialize services
  void _handleMetaMaskDisconnection() {
    setState(() {
      isConnected = false;
    });
    // _initW3MService();
    // _deployPlans();
    // _deployContract();
    // _showMetamaskAlert(context); // Optionally show MetaMask alert again
  }

  void navigateToPlans() {
    setState(() {
      currentIndex = 2; // Assuming PlanNav is at index 2
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Ensure the frame has updated before pushing a new route
      PlanNavKey.currentState?.push(
        MaterialPageRoute(
          builder: (context) => AddPlans(did: widget.did),
        ),
      );
    });
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
        print('connected1: $isConnected');
        // _showWelcomeDialog();
        _deployContract();
        _deployPlans();
        _isBlureffect = false;
      } else {
        // _showMetamaskAlert(context);
        print('not connected1: $isConnected');
        // _isBlureffect = true;
        // _deployContract();
      }
    });
    // _loadButtons();
  }

  void _showMetamaskBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor:
          Colors.transparent, // Transparent for custom background styling
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
                  color:
                      Theme.of(context).secondaryHeaderColor.withOpacity(0.5),
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
                        W3MConnectWalletButton(
                          service: _w3mService,
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

  Future<void> _showMetamaskAlert(BuildContext context) async {
    print('fetching metamask alert');
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).primaryColor,
          title: Container(
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
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 16,
              right: 16,
              top: 16,
            ),
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).secondaryHeaderColor.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  margin: const EdgeInsets.only(top: 5),
                ),
                const SizedBox(height: 20),
                Text(
                  'Please Connect with Wallet!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
                Column(
                  children: 
                  !isConnected
                      ? [
                          W3MNetworkSelectButton(service: _w3mService),
                          W3MConnectWalletButton(service: _w3mService),
                        ]
                      : [
                          W3MAccountButton(
                            service: _w3mService,
                          ),
                          W3MConnectWalletButton(
                            service: _w3mService,
                          ),
                          // Text(WalletAddress.toString()),
                        ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _deployPlans() async {
    final fileStorageService =
        FileStorageService(rpcUrl, _InvoidContractAddress, _invoiceAbiPath);

    try {
      await fileStorageService.initializeWeb3Client();
      final did = jsonDecode(widget.did.toString());
      final contract = await fileStorageService.loadContract('BethelInvoice');
      final freePlanActivate = await fileStorageService
          .callContractFunction(contract, 'isActivatedFreePlan', [did]);
      print('result11:${freePlanActivate}');

      if (freePlanActivate![0] == true) {
        setState(() {
          _isFreePlanActivated = true;
          _isBlureffect = false;
        });
        print('free plan activated');
      } else {
        _isFreePlanActivated = false;
        _isBlureffect = true;
        print('free plan not activated');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
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
          _isBlureffect = true;
          _showaAddPlanAlert();
        } else {
          print('The result contains a non-empty list: $innerList');
          _isBlureffect = false;

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

  void _showaAddPlanAlert() {
    print('fetching welcome alert');
    showDialog(
      context: context,
      // barrierDismissible: false,

      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).primaryColor,
          title: Container(
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
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
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
                    color:
                        Theme.of(context).secondaryHeaderColor.withOpacity(0.5),
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
                SizedBox(height: 20),   
                TextButton(
                  onPressed: () {
                    // Dismiss the dialog
                    Navigator.pop(context);

                    // Navigate to the second index (PlanNav page)
                    setState(() {
                      currentIndex =
                          2; // PlanNav is at index 2 in the IndexedStack
                    }); // Navigate to PlanNav and push AddPlans
                  },
                  child: Text('Add Plans'),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAddressDialog(List<dynamic> addresses) {
    // Check if addresses are not empty
    if (addresses.isEmpty) {
      print('No addresses to show in the bottom sheet');
      return;
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Popup Title'),
            content: Container(
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
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
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
                  mainAxisSize:
                      MainAxisSize.min, // Adjust height based on content
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
                                  fontFamily:
                                      GoogleFonts.robotoMono().fontFamily,
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
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close'),
              ),
            ],
          );
        });
  }

  Widget _loadButtons() {
    return Column(
      children: !isConnected
          ? [
              W3MNetworkSelectButton(service: _w3mService),
              W3MConnectWalletButton(service: _w3mService),
            ]
          : [
              W3MAccountButton(service: _w3mService),
              W3MConnectWalletButton(service: _w3mService),
              // Text(WalletAddress.toString()),
            ],
    );
  }

  void _showMetamaskPopup(BuildContext context) {
    AwesomeDialog(
      dialogBackgroundColor: Colors
          .white, // Set transparent to allow the gradient container to show
      context: context,

      dialogType: DialogType.noHeader,
      animType: AnimType.rightSlide,
      title: 'Wallet Connection',
      body: _loadButtons(),
      btnOkOnPress: () {
        Navigator.of(context).pop();
      },
      btnOkColor: Color.fromARGB(255, 68, 91, 0),
    )..show();
  }

  @override
  Widget build(BuildContext context) {
  final items = <Widget>[
    Icon(
      Icons.dashboard,
      size: 30,
      color: Theme.of(context).secondaryHeaderColor,
    ),
    Icon(
      Icons.document_scanner,
      size: 30,
      color: Theme.of(context).secondaryHeaderColor,
    ),
    Icon(
      Icons.map,
      size: 30,
      color: Theme.of(context).secondaryHeaderColor,
    ),
    Icon(
      Icons.security,
      size: 30,
      color: Theme.of(context).secondaryHeaderColor,
    ),
    Icon(
      Icons.account_circle,
      size: 30,
      color: Theme.of(context).secondaryHeaderColor,
    ),
  ];

  return PopScope(
    child: Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        items: items,
        index: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });

          if (!_isFreePlanActivated) {
            _showaAddPlanAlert();
          }

          if (!isConnected) {
            _showMetamaskAlert(context); // Show the popup if not connected
          }
        },
        height: 60,
        backgroundColor: Colors.black,
        color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
        buttonBackgroundColor: Theme.of(context).colorScheme.secondary,
      ),
      body: SafeArea(
        top: false,
        child: IndexedStack(
          index: currentIndex,
          children: <Widget>[
            DashboardNav(
              did: widget.did,
              isBlureffect: _isBlureffect,
            ),
            FileNav(
              did: widget.did,
              isBlureffect: _isBlureffect,
            ),
            PlanNav(
              did: widget.did,
            ),
            ClaimsNav(
              isBlureffect: _isBlureffect,
            ),
            ProfileNav(
              did: widget.did,
              isBlureffect: _isBlureffect,
            ),
          ],
        ),
      ),
    ),
  );
}
}
