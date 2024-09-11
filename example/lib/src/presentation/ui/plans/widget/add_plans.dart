import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:polygonid_flutter_sdk_example/src/data/secure_storage.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/dependency_injection/dependencies_provider.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/plans/bloc/add_plans_bloc.dart';
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

  @override
  void initState() {
    super.initState();
    _addPlansBloc = getIt<AddPlansBloc>();
    GetStorage.init();
  }


  Future<bool> isTransactionSuccessful(String txHash) async {
  // Initialize the Web3Client using your Infura or Alchemy endpoint
  final client = Web3Client("https://polygon-mainnet.g.alchemy.com/v2/SOxCgJzw6PLvC02g238nlDqJRq83_j3k", Client());

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
      // appBar: AppBar(title: Text("Add Plans")),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildHeader(),
              Center(
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildAddPlan(),
                    SizedBox(height: 20),
                    _buildAnimatedContainer(isExpanded1, "Basic Plan", () {
                      
                      setState(() {
                        isExpanded1 = !isExpanded1;
                      });

                    },
                        'Features for creators and developers who need more storage ',
                        [
                          'Unlimited Uploads',
                          '5GB storage',
                          '100GB Bandwidth',
                          'IPFS Gateways',
                          'IPFS Pinning Service API'
                        ],
                        'ADD 0\$ PER MONTH'),
                    SizedBox(height: 20),
                    _buildAnimatedContainer(isExpanded2, "Starter Plan", () {
                      setState(() {
                        isExpanded2 = !isExpanded2;
                      });
                    },
                        'Perfect for those managing large files or extensive data, ensuring your information is safely stored across multiple locations',
                        [
                          'Unlimited Uploads',
                          'Upto 1000GB storage space',
                          'Hack-Proof',
                          'Blockchain-Based Secure',
                          'Decentralized Data Protection'
                        ],
                        'ADD 10\$ PER MONTH'),
                    SizedBox(height: 20),
                    _buildAnimatedContainer(isExpanded3, "Advance Plan", () {
                      setState(() {
                        isExpanded3 = !isExpanded3;
                      });
                    },
                        'This plan is perfect for those needing large-scale, high-security storage solutions, ensuring that all your data is protected',
                        [
                          'Unlimited Uploads',
                          'Upto 5000GB storage space',
                          'Hack-Proof',
                          'Blockchain-Based Secure',
                          'Decentralized Data Protection'
                        ],
                        'ADD 30\$ PER MONTH'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
    
    
  Widget _buildAddPlan() {
    return BlocBuilder<AddPlansBloc, AddPlansState>(
      bloc: _addPlansBloc,
      builder: (context, state) {
        final storage = GetStorage();
        final owner1 = storage.read('walletAddress');

        if (state is AddPlansLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is AddPlansFailure) {
          return const Center(
            child: Text('Failed to add plan', style: TextStyle(color: Colors.red)),
          );
        }

        if (state is GenerateSecretsSuccess) {
          print('generateSecrets: ${jsonDecode(state.response.nullifierHash.toString())}');

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

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Proof Generated. Ready for Verification'),
                SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    _addPlansBloc.add(verifyuserEvent(
                      A: state.ProofResponse.a as List<BigInt>,
                      B: state.ProofResponse.b as List<List<BigInt>>,
                      C: state.ProofResponse.c as List<BigInt>,
                      Inputs: state.ProofResponse.input as List<String>,
                      Owner: owner1,
                      Did: widget.did.toString(),
                    ));
                  },
                  child: _buildButton(
                    'VERIFY USER',
                    Theme.of(context).colorScheme.secondary,
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          );
        }

        if (state is VerifyProof) {
          print('verifyUser: ${state.VerifyResponse.TXHash}');
          return const Center(
            child: Text('User Verified Successfully'),
          );
        }

        return Center(
          child: TextButton(
            onPressed: () {
              _addPlansBloc.add(GenerateSecretsEvent());
            },
            child: _buildButton(
              'ADD PLAN',
              Theme.of(context).colorScheme.secondary,
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor,
            ),
          ),
        );
      },
    );
  }

  // Async function to check if the transaction hash is successful
  Future<void> _checkTxHashStatus(String txHash,String owner) async {
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
      trailing: Container(
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
    );
  }

  // Helper method to build an expandable AnimatedContainer
  Widget _buildAnimatedContainer(
      bool isExpanded,
      String title,
      VoidCallback onTap,
      String description,
      List<String> features,
      String name1) {
    return BlocBuilder<AddPlansBloc, AddPlansState>(
      bloc: _addPlansBloc,
      builder: (context, state) {
        return GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 600), // Animation duration
            curve: Curves.easeInOut, // Animation curve
            width: MediaQuery.of(context).size.width *
                0.9, // Adjusting the width dynamically
            height: isExpanded
                ? MediaQuery.of(context).size.width // Expanded height
                : MediaQuery.of(context).size.width * 0.3, // Collapsed height
            decoration: isExpanded
                ? BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.15), // Gradient start
                        Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.5), // Gradient end
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
                    Text(
                      title, // Display title text
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: GoogleFonts.robotoMono().fontFamily),
                    ),
                    const Divider(
                      color: Colors.white,
                      thickness: 2, // Horizontal line under the text
                    ),
                    if (isExpanded) ...[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            description,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontFamily: GoogleFonts.robotoMono().fontFamily),
                          ),
    
                          const SizedBox(height: 10),
                          Text(
                            'WHAT\'S INCLUDED',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: GoogleFonts.robotoMono().fontFamily),
                          ),
                          const SizedBox(height: 10),
                          // Constrain ListView height to avoid overflow
                          // _buildDashboardButton (),
    
                          SizedBox(
                            height: MediaQuery.of(context).size.width *
                                0.3, // Fixed height for the ListView
                            child: ListView.builder(
                              itemCount: features.length,
                              itemBuilder: (context, index) {
                                return Row(
                                  children: [
                                    Icon(Icons.check,
                                        color:
                                            Theme.of(context).colorScheme.primary,
                                        size: 12),
                                    SizedBox(width: 5),
                                    Text(
                                      features[index],
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontFamily:
                                              GoogleFonts.robotoMono().fontFamily),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      // _buildDashboardButton(name1,_addPlansBloc.),
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

  Widget _buildDashboardButton(String name,String onTap) {
    return GestureDetector(
      onTap: () {onTap;},
      child: _buildButton(name, Theme.of(context).colorScheme.secondary,
          Theme.of(context).primaryColor, Theme.of(context).primaryColor),
    );
  }

  Widget _buildButton(
      String text, dynamic colorScheme, dynamic border, dynamic textColor) {
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
