import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:polygonid_flutter_sdk_example/src/data/secure_storage.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/dashboard/bar.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/dashboard/customCurveEdge.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/home/home_bloc.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/home/home_state.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/register/presentation/widgets/setupPassword.dart';
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

  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _initW3MService();
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
      if (isConnected) {
        print('connected: $isConnected');
        _showWelcomeDialog();
      }
    });
    // _loadButtons();
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

  

  void _showWelcomeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Welcome!'),
          content: Text('You have to connect with metamask to proceed'),
          actions: <Widget>[
            TextButton(
              child: Text('Add User'),
              onPressed: () {
                final storage = GetStorage();
                final owner1 = storage.read('walletAddress');
                // final did = storage.read('DID');
                // print('did 123: $did');
                print('owener did: $owner1');

                final did = jsonDecode(widget.did.toString());
                print('did23: $did');
                
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Safely assign WalletAddress, handling potential null values
    String? walletAddress = _w3mService.session?.address;

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
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: SingleChildScrollView(
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
                                    color:
                                        Theme.of(context).secondaryHeaderColor,
                                    fontSize: 20,
                                    fontFamily:
                                        GoogleFonts.robotoMono().fontFamily,
                                    fontWeight: FontWeight.w300))
                          ]))
                    ],
                  ),
                  subtitle: Column(
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
                  ),
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
                        _showWelcomeDialog();
                      },
                      child: Icon(
                        Icons.wallet,
                        color: Theme.of(context).secondaryHeaderColor,
                        size: 20,
                      ),
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
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SetupPasswordScreen())),
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
          const BarChartSample2(),
          Positioned(
            right: 8,
            child: Container(
              height: 38,
              width: 92,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('More',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.background,
                            fontSize: 15,
                            fontFamily: GoogleFonts.robotoMono().fontFamily,
                            fontWeight: FontWeight.w300)),
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
