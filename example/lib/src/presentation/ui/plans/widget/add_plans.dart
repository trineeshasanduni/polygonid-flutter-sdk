import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:polygonid_flutter_sdk_example/src/data/secure_storage.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/dependency_injection/dependencies_provider.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/common/widgets/circularProgress.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/plans/bloc/add_plans_bloc.dart';
import 'package:polygonid_flutter_sdk_example/utils/deploayContract.dart';
import 'package:polygonid_flutter_sdk_example/utils/image_resource.dart';
import 'package:polygonid_flutter_sdk_example/utils/secure_storage_keys.dart';
import 'package:web3modal_flutter/web3modal_flutter.dart';

class AddPlans extends StatefulWidget {
  final String? did;
  const AddPlans({super.key, required this.did});

  @override
  State<AddPlans> createState() => _AddPlansState();
}

class _AddPlansState extends State<AddPlans> {
  late final AddPlansBloc _addPlansBloc;
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
  // Variable to track verification status
  bool _isVerified = false;
  String _displayText = "Initial Text";

  bool _isFreePlanActivated = false;

  @override
  void initState() {
    super.initState();
    _addPlansBloc = getIt<AddPlansBloc>();
    GetStorage.init();

    // Retrieve saved verification status from storage
    final storage = GetStorage();
    _isVerified = storage.read('isVerified') ?? false;

    _deployPlans();
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
        });
        print('free plan activated');
      } else {
        _isFreePlanActivated = false;
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
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: 20),
            Expanded(
              // Only use Expanded here for the TabBarView
              child: DefaultTabController(
                length: 4,
                child: _buildTabView(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabView() {
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
              _handleOneMonth(),
              _handleThreeMonth(), 
              _handleSixMonth(),
              _handleOneYear(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _handleOneMonth() {
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
                'assets/images/paperPlane.png'),
            SizedBox(height: 20),
            _buildAnimatedContainer(
              isExpanded2,
              "Starter Plan",
              "10\$",
              () {
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
              'ADD 10\$',
              'assets/images/rocket2.png',
            ),
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
                'assets/images/plane.png'),
          ],
        ),
      ),
    );
  }

  Widget _handleThreeMonth() {
    return SingleChildScrollView(
      // Scrollable content for large expanded plans
      child: Padding(
        padding: const EdgeInsets.all(16.0), // Add some padding if necessary
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 40),
            _buildAnimatedContainer(
              isExpanded2,
              "Starter Plan",
              "30\$",
              () {
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
            ),
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
                'assets/images/plane.png'),
          ],
        ),
      ),
    );
  }
  Widget _handleSixMonth() {
    return SingleChildScrollView(
      // Scrollable content for large expanded plans
      child: Padding(
        padding: const EdgeInsets.all(16.0), // Add some padding if necessary
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 40),
            _buildAnimatedContainer(
              isExpanded2,
              "Starter Plan",
              "60\$",
              () {
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
            ),
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
                'assets/images/plane.png'),
          ],
        ),
      ),
    );
  }

  Widget _handleOneYear() {
    return SingleChildScrollView(
      // Scrollable content for large expanded plans
      child: Padding(
        padding: const EdgeInsets.all(16.0), // Add some padding if necessary
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 40),
            _buildAnimatedContainer(
              isExpanded2,
              "Starter Plan",
              "120\$",
              () {
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
            ),
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
                'assets/images/plane.png'),
          ],
        ),
      ),
    );
  }

  Widget _buildAddPlan(String name) {
    // print('tap tap');
    return BlocBuilder<AddPlansBloc, AddPlansState>(
      bloc: _addPlansBloc,
      builder: (context, state) {
        final storage = GetStorage();
        final owner1 = storage.read('walletAddress');

        if (state is AddPlansLoading) {
          return  Center(
            child:Loading(
              Loadingcolor: Theme.of(context).primaryColor,
              color: Theme.of(context).colorScheme.secondary,
            ),
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
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Proof Generated. Ready for Verification'),
                SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    // _checkProofTxHashStatus(
                    //     state.ProofResponse.TXHash.toString(),
                    //     state.ProofResponse.a as List<String>,
                    //     state.ProofResponse.b as List<List<String>>,
                    //     state.ProofResponse.c as List<String>,
                    //     state.ProofResponse.input as List<String>,
                    //     owner1,
                    //     widget.did!);
                    _addPlansBloc.add(verifyuserEvent(
                      A: state.ProofResponse.a as List<String>,
                      B: state.ProofResponse.b as List<List<String>>,
                      C: state.ProofResponse.c as List<String>,
                      Inputs: state.ProofResponse.input as List<String>,
                      Owner: owner1,
                      Did: widget.did!, // change here
                    ));
                  },
                  child: _buildButton(
                    name,
                    Theme.of(context).colorScheme.secondary,
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          );
        }

        // if (state is VerifyProof) {
        //   print('verifyUser: ${state.VerifyResponse.TXHash}');
        //   return const Center(
        //     child: Text('User Verified Successfully',),
        //   );
        // }

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
          // _checkVeridfyTxHashStatus(
          //     state.VerifyResponse.TXHash.toString(), owner1, widget.did!);

          // Update the verification state and save it after the build phase
        }

        // Declare this variable in your class
// New flag for logging

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
                _isFreePlanActivated ? "Activated" : name,
                _isFreePlanActivated
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).colorScheme.secondary,
                _isFreePlanActivated
                    ? Colors.redAccent[700]
                    : Theme.of(context).primaryColor,
                _isFreePlanActivated
                    ? Colors.redAccent[700]
                    : Theme.of(context).primaryColor,
              ),
            ),
          );
        } else {
          // WidgetsBinding.instance.addPostFrameCallback((_) {
          // _deployPlans();
          // });

          return Center(
            // child: Text(
            //   'Plan already added and user verified',
            //   style: TextStyle(color: Colors.grey),
            // ),
            child: _buildButton(
              _isFreePlanActivated ? "Activated" : name,
              _isFreePlanActivated
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).colorScheme.secondary,
              _isFreePlanActivated
                  ? Colors.redAccent[700]
                  : Theme.of(context).primaryColor,
              _isFreePlanActivated
                  ? Colors.redAccent[700]
                  : Theme.of(context).primaryColor,
            ),
          );
        }
      },
    );
  }

  // Async function to check if the transaction hash is successful
  Future<void> _checkTxHashStatus(String txHash, String owner) async {
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
        _addPlansBloc.add(createProofEvent(
          owner: owner,
          txhash: txHash,
        ));
      } else {
        print('Transaction is not yet successful. Retrying...');
        await Future.delayed(Duration(seconds: 5)); // Poll every 5 seconds
      }
    }
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

    while (!isSuccess) {
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
    }
  }

  Future<void> _checkVeridfyTxHashStatus(
      String txHash, String Owner, String Did) async {
    bool isSuccess = false;

    while (!isSuccess) {
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
    }
  }

  Future<void> _checkFreeSpaceTxHashStatus(String txHash) async {
    bool isSuccess = false;

    // Polling until the transaction is successful
    while (!isSuccess) {
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
    }
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
        onTap: _deployPlans,
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
      String icon) {
    return BlocBuilder<AddPlansBloc, AddPlansState>(
      bloc: _addPlansBloc,
      builder: (context, state) {
        final storage = GetStorage();
        final owner1 = storage.read('walletAddress');
        return GestureDetector(
          onTap: onTap, // Expands or collapses the container when tapped
          child: AnimatedContainer(
            duration: Duration(milliseconds: 600),
            curve: Curves.easeInOut,
            width: MediaQuery.of(context).size.width * 0.9,
            height: isExpanded
                ? MediaQuery.of(context).size.width * 1.4
                : MediaQuery.of(context).size.width * 0.4,
            decoration: title == "Basic Plan" && _isFreePlanActivated ?
                       
                       isExpanded 
                ?   BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Theme.of(context).colorScheme.primary.withOpacity(0.15),
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
                  ): isExpanded
                ? BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Theme.of(context).colorScheme.primary.withOpacity(0.15),
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
                  ): BoxDecoration(
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
                            title, // Display title text
                            style: isExpanded
                                ? TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily:
                                        GoogleFonts.robotoMono().fontFamily)
                                : TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
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
                        _buildAddPlan(name1),
                       
                      ],
                      // if (title == "Starter Plan") ...[
                      //   _buildAddPlan(name1),
                      // ],

                      // _addSpaceBloc.add(freeSpaceEvent(
                      //   owner: owner1,
                      //   did: widget.did.toString(),
                      // ));
                      // }),
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
