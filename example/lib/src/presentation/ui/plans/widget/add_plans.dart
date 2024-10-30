import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:polygonid_flutter_sdk_example/src/data/secure_storage.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/dependency_injection/dependencies_provider.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/common/widgets/circularProgress.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/dashboard/dashboard.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/plans/bloc/add_plans_bloc.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/plans/widget/basicPlanButton.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/profile/bloc/profile_bloc.dart';
import 'package:polygonid_flutter_sdk_example/utils/deploayContract.dart';
import 'package:polygonid_flutter_sdk_example/utils/image_resource.dart';
import 'package:polygonid_flutter_sdk_example/utils/secure_storage_keys.dart';
import 'package:web3modal_flutter/web3modal_flutter.dart';
import 'package:http/http.dart' as http;

class AddPlans extends StatefulWidget {
  final String? did;
  // final bool isBlureffect;
  const AddPlans({super.key, required this.did});

  @override
  State<AddPlans> createState() => _AddPlansState();
}

class _AddPlansState extends State<AddPlans> {
  late final AddPlansBloc _addPlansBloc;

  late final ProfileBloc _profileBloc;
  bool isExpanded1 = false;
  bool isExpanded2 = false;
  bool isExpanded3 = false;
  bool _hasCheckedTxHash = false;
  bool _hasLoggedNullTxHash = false;

//

  var rpcUrl =
      'https://polygon-mainnet.g.alchemy.com/v2/pHKWzuctaLCPxAKYc0c8bKQA8d85oPlk';

  final _invoiceAbiPath = 'assets/abi/BethelInvoice.json';

  final _InvoidContractAddress = '0xB05c8A8c54DDA3E4e785FD033AB63a50e09b9521';

  final _contractAddress1 =
      EthereumAddress.fromHex('0x6B7Cd2b0863e9e80b425566fEbBe15309Bb1803d');

  // final _senderAddress =
  //     EthereumAddress.fromHex('0x4534f51a912faf5dc3b799b1230ff33e8ea4f0ba');

  final _mainAddress =
      EthereumAddress.fromHex('0xe107bFe5623c95fA97Aa45bd259Da6e0cB590350');

  // final _tokenAddress = '0x8f3Cf7ad23Cd3CaDbD9735AFf958023239c6A063';
  // Variable to track verification status
  bool _isVerified = false;
  String _displayText = "Initial Text";

  bool _isFreePlanActivated = false;
  late W3MService _w3mService;

  final apiKey = "I6EHT7UCWZ61UD2USQUH3WXRFD5RN29RTH";

  final storage = GetStorage();

  final _becx = W3MChainInfo(
    chainName: 'Polygon Mainnet',
    chainId: '137',
    namespace: 'eip155:137',
    tokenName: 'BECX',
    rpcUrl:
        'https://polygon-mainnet.g.alchemy.com/v2/pHKWzuctaLCPxAKYc0c8bKQA8d85oPlk',

    //  " https://polygon-mainnet.g.alchemy.com/v2/tIKAf8oI0PuTLGas13adKmO_X8r-FUXg",
    blockExplorer: W3MBlockExplorer(
      name: 'polygonscan',
      url: 'https://polygonscan.com/',
    ),
  );

  @override
  void initState() {
    super.initState();
    _deployPlans();
    _initWalletService();
    _addPlansBloc = getIt<AddPlansBloc>();
    _profileBloc = getIt<ProfileBloc>();
    GetStorage.init();

    // Retrieve saved verification status from storage
    final storage = GetStorage();
    _isVerified = storage.read('isVerified') ?? false;

    // _initW3MService();
  }

  void _initWalletService() async {
    W3MChainPresets.chains.putIfAbsent(_becx.chainId, () => _becx);
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

    final WalletAddress14 = _w3mService.session?.address;

    print('walletAddress123: $WalletAddress14');
    print('walletAddress plan: ${_w3mService.session?.address}');
  }

// For making API calls

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
          storage.write('isFreePlanActivated', true);
        });
        print('free plan activated12');
      } else {
        storage.write('isFreePlanActivated', false);
        print('free plan not activated');
      }
    } catch (e) {
      print('An error occurred: $e');
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Transaction failed or still pending.'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
        return false;
      }
    } catch (e) {
      print("Error fetching transaction status: $e");
      return false;
    } finally {
      client.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    final _isFreePlanActive = storage.read('isFreePlanActivated') ?? false;
    print('isfreePlan build: $_isFreePlanActive');
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: Stack(children: [
          LiquidPullToRefresh(
            color: Theme.of(context).colorScheme.primary,
            onRefresh: _onRefresh,
            animSpeedFactor: 2.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildHeader(),
                SizedBox(height: 10),
                Expanded(
                  // Only use Expanded here for the TabBarView
                  child: DefaultTabController(
                    length: 4,
                    child: _buildTabView(_isFreePlanActive),
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  Future<void> _onRefresh() async {
    print("Refreshing data...");
    await _deployPlans(); // Call the initialization logic again

    await Future.delayed(Duration(seconds: 2)); // Simulate a network call

    _profileBloc.add(ResetProfileEvent());
  }

  Widget _buildTabView(bool isFreePlanActive) {
    return Column(
      children: [
        const TabBar(
          indicatorSize: TabBarIndicatorSize.label,
          dividerColor: Colors.black,
          tabs: [
            Tab(text: '1 Month'),
            Tab(text: '3 Month'),
            Tab(text: '6 Month'),
            Tab(text: '1 Year'),
          ],
        ),
        Expanded(
          // Keep this Expanded, as TabBarView should fill available space
          child: TabBarView(
            children: [
              _handleOneMonth(isFreePlanActive),
              _handleThreeMonth(isFreePlanActive),
              _handleSixMonth(isFreePlanActive),
              _handleOneYear(isFreePlanActive),
            ],
          ),
        ),
      ],
    );
  }

  Widget _handleOneMonth(bool isFreePlanActive) {
    return SingleChildScrollView(
      // Scrollable content for large expanded plans
      child: Padding(
        padding: const EdgeInsets.all(16.0), // Add some padding if necessary
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 40),
            _buildAnimatedContainer(isExpanded1, "Basic Plan", "0\$ ", () {
              _deployPlans();
              setState(() {
                isExpanded1 = !isExpanded1;
              });
            },
                'Features for creators and developers who need more storage',
                [
                  'Unlimited Uploads',
                  'Upto 1GB storage space',
                  'Hack-Proof',
                  'ZKP Protected',
                  'Blockchain-Based Secure',
                  'Decentralized Data Protection'
                ],
                'ADD 0\$ PER MONTH',
                'assets/images/paperPlane.png',
                isFreePlanActive,
                1),
            SizedBox(height: 20),

            _buildAnimatedContainer(isExpanded2, "Starter Plan", "10\$", () {
              setState(() {
                isExpanded2 = !isExpanded2;
              });
            },
                'Perfect for those managing large files or extensive data, ensuring your information is stored safely.',
                [
                  'Unlimited Uploads',
                  'Upto 1000GB storage space',
                  'Hack-Proof',
                  'ZKP Protected',
                  'Blockchain-Based Secure',
                  'Decentralized Data Protection'
                ],
                'ADD 10\$ Per Month',
                'assets/images/rocket2.png',
                isFreePlanActive,
                1),
            // Basicplanbutton(
            //   month: 1,
            //   isExpanded: isExpanded2,
            //   title: "Starter Plan",
            //   subtitle: "10\$",
            //   onTap: () {
            //     setState(() {
            //       isExpanded2 = !isExpanded2;
            //     });
            //   },
            //   description:
            //       'Perfect for those managing large files or extensive data, ensuring your information is stored safely.',
            //   features: [
            //     'Unlimited Uploads',
            //     'Upto 1000GB storage space',
            //     'Hack-Proof',
            //     'ZKP Protected',
            //     'Blockchain-Based Secure',
            //     'Decentralized Data Protection'
            //   ],
            //   name1: 'ADD 10\$ Per Month',
            //   icon: 'assets/images/rocket2.png',
            //   isFreePlanActivated: _isFreePlanActivated,
            //   // addPlansBloc: _addPlansBloc,
            // ),
            SizedBox(height: 20),
            _buildAnimatedContainer(isExpanded3, "Advance Plan", "30\$", () {
              setState(() {
                isExpanded3 = !isExpanded3;
              });
            },
                'This plan is perfect for those needing large-scale, high-security storage solutions, ensuring that all your data is protected',
                [
                  'Unlimited Uploads',
                  'Upto 5000GB storage space',
                  'Hack-Proof',
                  'ZKP Protected',
                  'Blockchain-Based Secure',
                  'Decentralized Data Protection'
                ],
                'ADD 30\$ PER MONTH',
                'assets/images/plane.png',
                isFreePlanActive,
                1),
          ],
        ),
      ),
    );
  }

  Widget _handleThreeMonth(bool isFreePlanActive) {
    return SingleChildScrollView(
      // Scrollable content for large expanded plans
      child: Padding(
        padding: const EdgeInsets.all(16.0), // Add some padding if necessary
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 40),
            _buildAnimatedContainer(isExpanded2, "Starter Plan", "30\$", () {
              setState(() {
                isExpanded2 = !isExpanded2;
              });
            },
                'Perfect for those managing large files or extensive data, ensuring your information is stored safely.',
                [
                  'Unlimited Uploads',
                  'Upto 1000GB storage space',
                  'Hack-Proof',
                  'ZKP Protected',
                  'Blockchain-Based Secure',
                  'Decentralized Data Protection'
                ],
                'ADD 30\$',
                'assets/images/rocket2.png',
                isFreePlanActive,
                3),
            SizedBox(height: 20),
            _buildAnimatedContainer(isExpanded3, "Advance Plan", "90\$", () {
              setState(() {
                isExpanded3 = !isExpanded3;
              });
            },
                'This plan is perfect for those needing large-scale, high-security storage solutions, ensuring that all your data is protected',
                [
                  'Unlimited Uploads',
                  'Upto 5000GB storage space',
                  'Hack-Proof',
                  'ZKP Protected',
                  'Blockchain-Based Secure',
                  'Decentralized Data Protection'
                ],
                'ADD 90\$ PER MONTH',
                'assets/images/plane.png',
                isFreePlanActive,
                3),
          ],
        ),
      ),
    );
  }

  Widget _handleSixMonth(bool isFreePlanActive) {
    return SingleChildScrollView(
      // Scrollable content for large expanded plans
      child: Padding(
        padding: const EdgeInsets.all(16.0), // Add some padding if necessary
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 40),
            _buildAnimatedContainer(isExpanded2, "Starter Plan", "60\$", () {
              setState(() {
                isExpanded2 = !isExpanded2;
              });
            },
                'Perfect for those managing large files or extensive data, ensuring your information is stored safely.',
                [
                  'Unlimited Uploads',
                  'Upto 1000GB storage space',
                  'Hack-Proof',
                  'ZKP Protected',
                  'Blockchain-Based Secure',
                  'Decentralized Data Protection'
                ],
                'ADD 60\$',
                'assets/images/rocket2.png',
                isFreePlanActive,
                6),
            SizedBox(height: 20),
            _buildAnimatedContainer(isExpanded3, "Advance Plan", "180\$", () {
              setState(() {
                isExpanded3 = !isExpanded3;
              });
            },
                'This plan is perfect for those needing large-scale, high-security storage solutions, ensuring that all your data is protected',
                [
                  'Unlimited Uploads',
                  'Upto 5000GB storage space',
                  'Hack-Proof',
                  'ZKP Protected',
                  'Blockchain-Based Secure',
                  'Decentralized Data Protection'
                ],
                'ADD 180\$ PER MONTH',
                'assets/images/plane.png',
                isFreePlanActive,
                6),
          ],
        ),
      ),
    );
  }

  Widget _handleOneYear(bool isFreePlanActive) {
    return SingleChildScrollView(
      // Scrollable content for large expanded plans
      child: Padding(
        padding: const EdgeInsets.all(16.0), // Add some padding if necessary
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 40),
            _buildAnimatedContainer(isExpanded2, "Starter Plan", "120\$", () {
              setState(() {
                isExpanded2 = !isExpanded2;
              });
            },
                'Perfect for those managing large files or extensive data, ensuring your information is stored safely.',
                [
                  'Unlimited Uploads',
                  'Upto 1000GB storage space',
                  'Hack-Proof',
                  'ZKP Protected',
                  'Blockchain-Based Secure',
                  'Decentralized Data Protection'
                ],
                'ADD 120\$',
                'assets/images/rocket2.png',
                isFreePlanActive,
                12),
            SizedBox(height: 20),
            _buildAnimatedContainer(isExpanded3, "Advance Plan", "360\$", () {
              setState(() {
                isExpanded3 = !isExpanded3;
              });
            },
                'This plan is perfect for those needing large-scale, high-security storage solutions, ensuring that all your data is protected',
                [
                  'Unlimited Uploads',
                  'Upto 5000GB storage space',
                  'Hack-Proof',
                  'ZKP Protected',
                  'Blockchain-Based Secure',
                  'Decentralized Data Protection'
                ],
                'ADD 360\$ PER MONTH',
                'assets/images/plane.png',
                isFreePlanActive,
                12),
          ],
        ),
      ),
    );
  }

  Widget _buildAddPlan(String name, bool isFreePlanActive) {
    // print('tap tap');
    return BlocBuilder<AddPlansBloc, AddPlansState>(
      bloc: _addPlansBloc,
      builder: (context, state) {
        final storage = GetStorage();
        final owner1 = storage.read('walletAddress');

        if (state is AddPlansLoading) {
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

        if (state is AddPlansFailure) {
          return const Center(
            child:
                Text('Failed to add plan', style: TextStyle(color: Colors.red)),
          );
        }

        if (state is GenerateSecretsSuccess) {
          print(
              'generateSecrets: ${jsonDecode(state.response.nullifierHash.toString())}');

          if (owner1 != null && owner1.isNotEmpty) {
            _addPlansBloc.add(addUserEvent(
              commitment: state.response.commitment.toString(),
              did: widget.did.toString(),
              nullifier: state.response.nullifierHash.toString(),
              owner: owner1,
            ));
          } else {
            print('Error: Wallet address is null or empty');
            return const Center(
              child: Text('Error: Wallet address not found'),
            );
          }
        }

        if (state is AddUserSuccess) {
          print('addUser: ${state.addUserResponse.TXHash}');
          // Call the asynchronous function to check the TXHash status
          _checkTxHashStatus(state.addUserResponse.TXHash.toString(), owner1);
        }

        if (state is CreateProof) {
          print('createProof a: ${state.ProofResponse.a}');
          print('createProof b: ${state.ProofResponse.b}');
          print('createProof c: ${state.ProofResponse.c}');
          print('createProof input: ${state.ProofResponse.input}');

          _addPlansBloc.add(verifyuserEvent(
            A: state.ProofResponse.a as List<String>,
            B: state.ProofResponse.b as List<List<String>>,
            C: state.ProofResponse.c as List<String>,
            Inputs: state.ProofResponse.input as List<String>,
            Owner: owner1,
            Did: widget.did!, // change here
          ));
        }

        if (state is VerifyProof) {
          print('verifyUser: ${state.VerifyResponse.TXHash}');
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('User Verified Successfully'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
              ),
            );

            _addPlansBloc.add(freeSpaceEvent(
              did: widget.did!,
              owner: owner1,
            ));
          });
        }

        if (state is FreeSpaceAdded) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return; // Check if the widget is still mounted

            setState(() {
              _isVerified = true;
            });

            // Save the verified state to local storage
            final storage = GetStorage();
            try {
              storage.write('isVerified', true);
            } catch (e) {
              // Handle storage write error (optional logging)
              print('Error saving to local storage: $e');
            }

            final txHash = state.freeSpaceResponse.TXHash;
            if (txHash != null && !_hasCheckedTxHash) {
              print('fetching tx hash');
              _checkFreeSpaceTxHashStatus(txHash.toString());
              _hasCheckedTxHash = true; // Mark as checked
              _hasLoggedNullTxHash = false; // Reset the logging flag
              _deployPlans();
            } else if (txHash == null && !_hasLoggedNullTxHash) {
              // Log the case where TXHash is null only once
              print('Transaction hash is null');
              _hasLoggedNullTxHash = true; // Mark that null was logged
            }
          });
        }

        if (!_isVerified) {
          print('isVerified: $_isVerified');
          print('isfreePlanActivated butn: $_isFreePlanActivated');
          return Center(
            child: TextButton(
              onPressed:
                  // _isFreePlanActivated
                  //     ? null // Disable the button when the plan is already activated
                  //     :
                  () {
                // Add the event when the button is pressed
                _addPlansBloc.add(GenerateSecretsEvent());
              },
              child: _buildButton(
                isFreePlanActive ? "Activated" : name,
                isFreePlanActive
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).colorScheme.secondary,
                isFreePlanActive
                    ? Colors.redAccent[700]
                    : Theme.of(context).primaryColor,
                isFreePlanActive
                    ? Colors.redAccent[700]
                    : Theme.of(context).primaryColor,
              ),
            ),
          );
        } else {
          // WidgetsBinding.instance.addPostFrameCallback((_) {
          // _deployPlans();
          // });
          final isfreePlan = storage.read('isFreePlanActivated');
          print('isfreePlan new: $isfreePlan');

          return Center(
            // child: Text(
            //   'Plan already added and user verified',
            //   style: TextStyle(color: Colors.grey),
            // ),
            child: _buildButton(
              isFreePlanActive ? "Activated" : name,
              isFreePlanActive
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).colorScheme.secondary,
              isFreePlanActive
                  ? Colors.redAccent[700]
                  : Theme.of(context).primaryColor,
              isFreePlanActive
                  ? Colors.redAccent[700]
                  : Theme.of(context).primaryColor,
            ),
          );
        }
      },
    );
  }

  Widget _buildPlan(
    String name,
    int month,
    String plan,
    int PackageType,
  ) {
    // print('tap tap');
    return BlocBuilder<ProfileBloc, ProfileState>(
      bloc: _profileBloc,
      builder: (context, state) {
        if (state is EmailUpdated) {
          print('isVerified12: ${state.email.isVerified}');
          if (state.email.isVerified == true) {
            _addPlansBloc.add(planPriceEvent(plan: plan, month: month));
          } else {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Please Verify Your Email and Password'),
                  backgroundColor: Colors.red,
                  duration: Duration(seconds: 2),
                ),
              );
            });
          }
        }

        Future.delayed(const Duration(seconds: 10), () {
          _profileBloc.add(ResetProfileEvent());
        });

        return BlocBuilder<AddPlansBloc, AddPlansState>(
          bloc: _addPlansBloc,
          builder: (context, state) {
            final storage = GetStorage();
            final owner1 = storage.read('walletAddress');

            if (state is PriceLoading &&
                state.month == month &&
                state.plan == plan) {
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

            if (state is PlanPriceFailure &&
                state.month == month &&
                state.plan == plan) {
              return const Center(
                child: Text('Failed to Fetch Price',
                    style: TextStyle(color: Colors.red)),
              );
            }

            if (state is PriceUpdated &&
                state.month == month &&
                state.plan == plan) {
              final price = {jsonDecode(state.priceResponse.price.toString())};

              print(
                  'price11: ${jsonDecode(state.priceResponse.price.toString())}');

              transferToken(jsonDecode(state.priceResponse.price.toString()),
                  PackageType, month);
              // print('tx: ${tx.toString()}');
              // if (tx != '') {

              // } else {
              //    return const Center(
              //   child: Text('Failed to Active Plan',
              //       style: TextStyle(color: Colors.red)),
              // );
              // }
            }

            if (state is PaidPlanActivated) {
              print('PaidPlanActivated: ${state.paidPlanResponse.TXHash}');
              // Call the asynchronous function to check the TXHash status
              _checkTxHashStatus(
                  state.paidPlanResponse.TXHash.toString(), owner1);
            }

            return Center(
              child: TextButton(
                onPressed:
                    // _isFreePlanActivated
                    //     ? null // Disable the button when the plan is already activated
                    //     :
                    () {
                  // _initW3MService();
                  // Add the event when the button is pressed
                  // _addPlansBloc.add(planPriceEvent(plan: plan, month: month));
                  final did = jsonDecode(widget.did.toString());
                  _profileBloc.add(GetVerifyEmailEvent(Did: did));
                },
                child: _buildButton(
                  name,
                  Theme.of(context).colorScheme.secondary,
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColor,
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> transferToken(double price, int PackageType, int month) async {
    // Format the value to wei
    BigInt _formatValue(double amount, {int decimals = 18}) {
      return BigInt.from(amount * BigInt.from(10).pow(decimals).toDouble());
    }

    final transferValue = _formatValue(price, decimals: 18);
    print('Transferring amount: $transferValue wei');

    try {
      print('Fetching Web3Modal service...');
      _w3mService.launchConnectedWallet();

      // Load ABI from the asset file
      final abiFile = await rootBundle.loadString('assets/abi/BethToken.json');
      if (abiFile.isEmpty) throw FormatException('ABI file is empty');

      final jsonAbi = jsonDecode(abiFile);
      final _abiCode =
          ContractAbi.fromJson(jsonEncode(jsonAbi['abi']), 'BethToken');
      final _contract = DeployedContract(_abiCode, _contractAddress1);
      print('Contract loaded: $_contract');

      final walletAddress = _w3mService.session?.address;

      // Execute the approve function and wait for the result
      print('Executing approve function...');
      final approveResult = _w3mService.requestWriteContract(
        topic: _w3mService.session?.topic.toString() ?? '',
        chainId: "eip155:137",
        deployedContract: _contract,
        functionName: 'approve',
        transaction: Transaction(
          from: EthereumAddress.fromHex(_w3mService.session?.address ?? ''),
        ),
        parameters: [
          _mainAddress, // Ensure _mainAddress is a valid Ethereum address
          transferValue, // Token amount in wei
        ],
      );
      await Future.delayed(Duration(minutes: 2));
      Text('Waiting for transaction confirmation...');
      final latestTxHash =
          await getLatestTransactionHash(walletAddress!, apiKey);

      if (latestTxHash != null) {
        print('Latest transaction hash: $latestTxHash');
      } else {
        print('No transactions found');
      }

      print('Approve successful with result: $latestTxHash');

      bool isApprovalConfirmed = await _checkTxHash(latestTxHash!);
      if (!isApprovalConfirmed) {
        print('Approval transaction failed or timed out.');
      }

      print('Approval transaction confirmed.');

      // Now execute the transfer function after approve is successful
      print('Executing transfer function...');
      _w3mService.launchConnectedWallet();
      final transferResult = _w3mService.requestWriteContract(
        topic: _w3mService.session?.topic.toString() ?? '',
        chainId: "eip155:137",
        deployedContract: _contract,
        functionName: 'transfer',
        transaction: Transaction(
          from: EthereumAddress.fromHex(_w3mService.session?.address ?? ''),
        ),
        parameters: [
          _mainAddress,
          transferValue, // Token amount in wei
        ],
      );

      await Future.delayed(Duration(minutes: 1));
      Text('Waiting for transaction confirmation...');
      final TransferlatestTxHash =
          await getLatestTransactionHash(walletAddress, apiKey);

      if (TransferlatestTxHash != null) {
        print('Latest transaction hash transfer: $TransferlatestTxHash');
        _addPlansBloc.add(activePaidPlanEvent(
          // change here
          DID: widget.did!,
          PackageType: PackageType,
          Duration: month,
        ));
      } else {
        print('No transactions found');
      }
    } catch (e) {
      if (e.toString().contains('User denied transaction signature')) {
        print('Transaction signature denied by the user.');
      } else {
        print('Error during transfer: $e');
      }
    }
  }

  Future<String?> getLatestTransactionHash(
      String walletAddress, String apiKey) async {
    print('fetching tx hash');
    final url = Uri.parse(
      'https://api.polygonscan.com/api?module=account&action=txlist&address=$walletAddress&startblock=0&endblock=99999999&page=1&offset=1&sort=desc&apikey=I6EHT7UCWZ61UD2USQUH3WXRFD5RN29RTH',
    );

    try {
      final response = await http.get(url);
      print('response: ${response.body}');

      if (response.statusCode == 200) {
        print('status code: ${response.statusCode}');
        final data = json.decode(response.body);
        print('data: $data');
        if (data['status'] == '1' && data['message'] == 'OK') {
          final transactions = data['result'];
          if (transactions.isNotEmpty) {
            final latestTxHash = transactions[0]['hash'];
            print('latestTxHash: $latestTxHash');
            return latestTxHash;
          }
        }
      } else {
        print('Failed to fetch transaction data');
      }
    } catch (e) {
      print('Error: $e');
    }
    return null;
  }

  Future<bool> _checkTxHash(String txHash) async {
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
        return true;
      } else {
        print('Transaction is not yet successful. Retrying...');
        await Future.delayed(Duration(seconds: 5));
      }
    }
    return false; // Ensure a boolean value is always returned
  }

  // Async function to check if the transaction hash is successful
  Future<void> _checkTxHashStatus(String txHash, String owner) async {
    bool isSuccess = false;

    // Add logic to check the transaction status here.
    // For example, calling a blockchain API to check the status of the txHash.

    // while (!isSuccess) {
    // Call your blockchain transaction check method
    // Example: checkTransaction(txHash) which returns true/false
    isSuccess = await isTransactionSuccessful(txHash);

    if (isSuccess) {
      print('Transaction successful with hash: $txHash');
      // Dispatch the event to create proof after the transaction is successful
      _addPlansBloc.add(createProofEvent(
        owner: owner,
        txhash: txHash,
      ));
    } else {
      print('Transaction is not yet successful. Retrying...');
      await Future.delayed(Duration(seconds: 5)); // Poll every 5 seconds
    }
    // }
  }

  Future<void> _checkProofTxHashStatus(
      String txHash,
      List<String> A,
      List<List<String>> B,
      List<String> C,
      List<String> Inputs,
      String Owner,
      String Did) async {
    bool isSuccess = false;

    // while (!isSuccess) {
    isSuccess = await isTransactionSuccessful(txHash);

    if (isSuccess) {
      print('proof Transaction successful with hash: $txHash');
      _addPlansBloc.add(verifyuserEvent(
        A: A,
        B: B,
        C: C,
        Inputs: Inputs,
        Owner: Owner,
        Did: Did,
      ));
    } else {
      print('proof Transaction is not yet successful. Retrying...');
      await Future.delayed(Duration(seconds: 5)); // Poll every 5 seconds
    }
    // }
  }

  Future<void> _checkVeridfyTxHashStatus(
      String txHash, String Owner, String Did) async {
    bool isSuccess = false;

    // while (!isSuccess) {
    isSuccess = await isTransactionSuccessful(txHash);

    if (isSuccess) {
      print('Verify Transaction successful with hash1: $txHash');

      _addPlansBloc.add(freeSpaceEvent(
        owner: Owner,
        did: widget.did!,
      ));
    } else {
      print('Verify Transaction is not yet successful. Retrying...');
      await Future.delayed(Duration(seconds: 5)); // Poll every 5 seconds
    }
    // }
  }

  Future<void> _checkFreeSpaceTxHashStatus(String txHash) async {
    bool isSuccess = false;

    // Polling until the transaction is successful
    // while (!isSuccess) {
    isSuccess = await isTransactionSuccessful(txHash);

    if (isSuccess) {
      print('Verify Transaction successful with hash: $txHash');

      // Show a success message with a Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Free Space Added Successfully',
            style: TextStyle(color: Colors.green),
          ),
        ),
      );

      // Exit the function after transaction success
      return;
    } else {
      print('Verify Transaction is not yet successful. Retrying...');

      // Wait for 5 seconds before trying again
      await Future.delayed(const Duration(seconds: 5));
    }
    // }
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
        // onTap: _deployPlans,
        onTap: () {
          final walletaddress = storage.read('walletAddress');
          getLatestTransactionHash(walletaddress, apiKey);
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
            Icons.wallet,
            color: Theme.of(context).secondaryHeaderColor,
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedContainer(
      bool isExpanded,
      String title,
      String subtitle,
      VoidCallback onTap,
      String description,
      List<String> features,
      String name1,
      String icon,
      bool? isFreePlanActive,
      int month) {
    return BlocBuilder<AddPlansBloc, AddPlansState>(
      bloc: _addPlansBloc,
      builder: (context, state) {
        final storage = GetStorage();
        final owner1 = storage.read('walletAddress');
        final freePlan = storage.read('isFreePlanActivated') ?? false;
        return GestureDetector(
          onTap: onTap, // Expands or collapses the container when tapped
          child: AnimatedContainer(
            duration: Duration(milliseconds: 600),
            curve: Curves.easeInOut,
            width: MediaQuery.of(context).size.width * 0.9,
            height: isExpanded
                ? MediaQuery.of(context).size.width * 1.4
                : MediaQuery.of(context).size.width * 0.4,
            decoration: title == "Basic Plan" && isFreePlanActive!
                ? isExpanded
                    ? BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.15),
                            Theme.of(context)
                                .colorScheme
                                .secondary
                                .withOpacity(0.5),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.secondary,
                          width: 2,
                        ),
                      )
                    : BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2,
                        ),
                      )
                : isExpanded
                    ? BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.15),
                            Theme.of(context)
                                .colorScheme
                                .secondary
                                .withOpacity(0.5),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2,
                        ),
                      )
                    : BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Theme.of(context).secondaryHeaderColor,
                          width: 2,
                        ),
                      ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(icon,
                              width: 50, height: 50, fit: BoxFit.fill),
                          SizedBox(width: 30),
                          Text(
                            freePlan && title == "Basic Plan" && !isExpanded
                                ? title + " Activated"
                                : title, // Display title text
                            style: isExpanded
                                ? TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily:
                                        GoogleFonts.robotoMono().fontFamily)
                                : TextStyle(
                                    color: freePlan && title == "Basic Plan"
                                        ? Colors.redAccent[700]
                                        : Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily:
                                        GoogleFonts.robotoMono().fontFamily),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      color: Colors.white,
                      thickness: 2,
                    ),
                    Center(
                      child: Column(
                        children: [
                          Text(
                            subtitle, // Display title text
                            style: isExpanded
                                ? TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    fontFamily:
                                        GoogleFonts.robotoMono().fontFamily)
                                : TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    fontFamily:
                                        GoogleFonts.robotoMono().fontFamily),
                          ),
                          Text(
                            'Per Month', // Display title text
                            style: isExpanded
                                ? TextStyle(
                                    color:
                                        Theme.of(context).secondaryHeaderColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily:
                                        GoogleFonts.robotoMono().fontFamily)
                                : TextStyle(
                                    color:
                                        Theme.of(context).secondaryHeaderColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    fontFamily:
                                        GoogleFonts.robotoMono().fontFamily),
                          ),
                        ],
                      ),
                    ),
                    if (isExpanded) ...[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 30),
                          Text(
                            description,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontFamily:
                                    GoogleFonts.robotoMono().fontFamily),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'WHAT\'S INCLUDED',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily:
                                    GoogleFonts.robotoMono().fontFamily),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            height: MediaQuery.of(context).size.width * 0.4,
                            child: ListView.builder(
                              itemCount: features.length,
                              itemBuilder: (context, index) {
                                return Row(
                                  children: [
                                    Icon(Icons.check,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        size: 12),
                                    SizedBox(width: 5),
                                    Text(
                                      features[index],
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontFamily: GoogleFonts.robotoMono()
                                              .fontFamily),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      // Button will now trigger the event when clicked
                      if (title == "Basic Plan") ...[
                        _buildAddPlan(name1, isFreePlanActive!),
                      ],
                      if (title == "Starter Plan" && month == 1) ...[
                        _buildPlan(name1, 1, "MONTH_1_STARTER", 1),
                      ],
                      if (title == "Advance Plan" && month == 1) ...[
                        _buildPlan(name1, 1, "MONTH_1_ADVANCE", 2),
                      ],
                      if (title == "Starter Plan" && month == 3) ...[
                        _buildPlan(name1, 3, "MONTH_1_STARTER", 1),
                      ],
                      if (title == "Advance Plan" && month == 3) ...[
                        _buildPlan(name1, 3, "MONTH_1_ADVANCE", 2),
                      ],
                      if (title == "Starter Plan" && month == 6) ...[
                        _buildPlan(name1, 6, "MONTH_1_STARTER", 1),
                      ],
                      if (title == "Advance Plan" && month == 6) ...[
                        _buildPlan(name1, 6, "MONTH_1_ADVANCE", 2),
                      ],
                      if (title == "Starter Plan" && month == 12) ...[
                        _buildPlan(name1, 12, "MONTH_1_STARTER", 1),
                      ],
                      if (title == "Advance Plan" && month == 12) ...[
                        _buildPlan(name1, 12, "MONTH_1_ADVANCE", 2),
                      ],
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildButton(
    String text,
    dynamic colorScheme,
    dynamic border,
    dynamic textColor,
  ) {
    return Container(
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: colorScheme,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: border,
          width: 2,
        ),
      ),
      child: Text(
        text,
        style: GoogleFonts.robotoMono(
          color: textColor,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class EthereumService {
  final Web3Client _client;

  final String _etherscanApiKey = 'YOUR_ETHERSCAN_API_KEY';

  EthereumService(String infuraUrl)
      : _client = Web3Client(infuraUrl, http.Client());

  Future<void> getLatestTransaction(String address) async {
    final String url =
        'https://api.etherscan.io/api?module=account&action=txlist&address=$address&startblock=0&endblock=99999999&sort=desc&apikey=$_etherscanApiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == '1' && data['result'].isNotEmpty) {
          final latestTransaction = data['result'][0];
          print('Latest Transaction Hash: ${latestTransaction['hash']}');
          print('From: ${latestTransaction['from']}');
          print('To: ${latestTransaction['to']}');
          print('Value: ${latestTransaction['value']} ETH');
          print(
              'Timestamp: ${DateTime.fromMillisecondsSinceEpoch(int.parse(latestTransaction['timeStamp']) * 1000)}');
        } else {
          print('No transactions found for this address.');
        }
      } else {
        print('Error fetching transactions: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
