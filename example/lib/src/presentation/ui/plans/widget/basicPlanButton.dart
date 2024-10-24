import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/dependency_injection/dependencies_provider.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/common/widgets/circularProgress.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/plans/bloc/add_plans_bloc.dart';
import 'package:web3modal_flutter/models/w3m_chain_info.dart';
import 'package:web3modal_flutter/services/w3m_service/w3m_service.dart';
import 'package:web3modal_flutter/utils/w3m_chains_presets.dart';
import 'package:web3modal_flutter/web3modal_flutter.dart';

class Basicplanbutton extends StatefulWidget {
  final int month;
  final bool isExpanded;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final String description;
  final List<String> features;
  final String name1;
  final String icon;
  final bool isFreePlanActivated;
  // final AddPlansBloc addPlansBloc;

  const Basicplanbutton({
    Key? key,
    required this.month,
    required this.isExpanded,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.description,
    required this.features,
    required this.name1,
    required this.icon,
    required this.isFreePlanActivated,
    // required this.addPlansBloc,
  }) : super(key: key);

  @override
  State<Basicplanbutton> createState() => _BasicplanbuttonState();
}

class _BasicplanbuttonState extends State<Basicplanbutton> {
  late final AddPlansBloc _addPlansBloc;

  late W3MService _w3mService;

   final _contractAddress1 =
      EthereumAddress.fromHex('0x6B7Cd2b0863e9e80b425566fEbBe15309Bb1803d');

  final _senderAddress =
      EthereumAddress.fromHex('0x4534f51a912faf5dc3b799b1230ff33e8ea4f0ba');

  final _mainAddress =
      EthereumAddress.fromHex('0xe107bFe5623c95fA97Aa45bd259Da6e0cB590350');

  final _becx = W3MChainInfo(
    chainName: 'Polygon Mainnet',
    chainId: '137',
    namespace: 'eip155:137',
    tokenName: 'BECX',
    rpcUrl:
        'https://polygon-mainnet.g.alchemy.com/v2/pHKWzuctaLCPxAKYc0c8bKQA8d85oPlk',
    blockExplorer: W3MBlockExplorer(
      name: 'polygonscan',
      url: 'https://polygonscan.com/',
    ),
  );
@override
  void initState() {
    super.initState();
    _initWalletService();
   
    _addPlansBloc = getIt<AddPlansBloc>();
    GetStorage.init();

    // Retrieve saved verification status from storage
    
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

  @override
  Widget build(BuildContext context) {
    final storage = GetStorage();
    final owner1 = storage.read('walletAddress');
    

    return GestureDetector(
      onTap: widget.onTap, // Expands or collapses the container when tapped
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
        width: MediaQuery.of(context).size.width * 0.9,
        height: widget.isExpanded
            ? MediaQuery.of(context).size.width * 1.4
            : MediaQuery.of(context).size.width * 0.4,
        decoration: _buildDecoration(context),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildHeader(context),
                const Divider(
                  color: Colors.white,
                  thickness: 2,
                ),
                _buildTitleSubtitle(context),
                if (widget.isExpanded) ...[
                  _buildExpandedContent(context),
                  if (widget.title == "Starter Plan") ...[
                    _buildPlan(widget.name1, 1, "MONTH_1_STARTER"),
                  ],
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildDecoration(BuildContext context) {
    return widget.title == "Basic Plan" && widget.isFreePlanActivated
        ? widget.isExpanded
            ? BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).colorScheme.primary.withOpacity(0.15),
                    Theme.of(context).colorScheme.secondary.withOpacity(0.5),
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
        : widget.isExpanded
            ? BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).colorScheme.primary.withOpacity(0.15),
                    Theme.of(context).colorScheme.secondary.withOpacity(0.5),
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
              );
  }

  Widget _buildHeader(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(widget.icon, width: 50, height: 50, fit: BoxFit.fill),
          const SizedBox(width: 30),
          Text(
            widget.title,
            style: widget.isExpanded
                ? TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: GoogleFonts.robotoMono().fontFamily)
                : TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: GoogleFonts.robotoMono().fontFamily),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleSubtitle(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            widget.subtitle,
            style: widget.isExpanded
                ? TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: GoogleFonts.robotoMono().fontFamily)
                : TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: GoogleFonts.robotoMono().fontFamily),
          ),
          Text(
            'Per Month',
            style: widget.isExpanded
                ? TextStyle(
                    color: Theme.of(context).secondaryHeaderColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: GoogleFonts.robotoMono().fontFamily)
                : TextStyle(
                    color: Theme.of(context).secondaryHeaderColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    fontFamily: GoogleFonts.robotoMono().fontFamily),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedContent(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 30),
        Text(
          widget.description,
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
        SizedBox(
          height: MediaQuery.of(context).size.width * 0.4,
          child: ListView.builder(
            itemCount: widget.features.length,
            itemBuilder: (context, index) {
              return Row(
                children: [
                  Icon(Icons.check,
                      color: Theme.of(context).colorScheme.primary, size: 12),
                  const SizedBox(width: 5),
                  Text(
                    widget.features[index],
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontFamily: GoogleFonts.robotoMono().fontFamily),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
Widget _buildPlan(String name, int month, String plan) {
    // print('tap tap');
    return BlocBuilder<AddPlansBloc, AddPlansState>(
      bloc: _addPlansBloc,
      builder: (context, state) {
        final storage = GetStorage();
        final owner1 = storage.read('walletAddress');

        if (state is PriceLoading) {
          return Center(
            // child: Loading(
            //   Loadingcolor: Theme.of(context).primaryColor,
            //   color: Theme.of(context).colorScheme.secondary,
            // ),
            child: Text(state.message,
                style: TextStyle(color: Theme.of(context).colorScheme.secondary,fontSize: 14,)),
          );
        }

        if (state is PlanPriceFailure) {
          return const Center(
            child: Text('Failed to Fetch Price',
                style: TextStyle(color: Colors.red)),
          );
        }

        if (state is PriceUpdated) {
          final price = {jsonDecode(state.priceResponse.price.toString())};

          print('price11: ${jsonDecode(state.priceResponse.price.toString())}');

          transferToken(jsonDecode(state.priceResponse.price.toString()));
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
              _addPlansBloc.add(planPriceEvent(plan: plan, month: month));
            },
            child: _buildButton(
              context,
              name,
              Theme.of(context).colorScheme.secondary,
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor,
            ),
          ),
        );
      },
    );
  }
 Future<void> transferToken(double price) async {
    // Format the value to wei
    BigInt _formatValue(double amount, {int decimals = 18}) {
      return BigInt.from(amount * BigInt.from(10).pow(decimals).toDouble());
    }

    final transferValue = _formatValue(price, decimals: 18);
    print('Transferring amount: $transferValue wei');

    try {
      print('Fetching Web3Modal service...');

      // Launch the connected wallet
      _w3mService.launchConnectedWallet();

      // Load ABI from the asset file
      final abiFile = await rootBundle.loadString('assets/abi/BethToken.json');
      if (abiFile.isEmpty) throw FormatException('ABI file is empty');

      final jsonAbi = jsonDecode(abiFile);
      final _abiCode =
          ContractAbi.fromJson(jsonEncode(jsonAbi['abi']), 'BethToken');

      final _contract = DeployedContract(_abiCode, _contractAddress1);
      print('Contract loaded: $_contract');

      // Execute the approve function and wait for the result
      print('Executing approve function...');
      final approveResult = await _w3mService.requestWriteContract(
        topic: _w3mService.session?.topic.toString() ?? '',
        chainId: "eip155:137", // Ensure you are connected to the correct chain
        deployedContract: _contract,
        functionName: 'approve',
        transaction: Transaction(
          from: EthereumAddress.fromHex(
              _w3mService.session?.address ?? ''), // Use the wallet address
        ),
        parameters: [
          _mainAddress, // Ensure _mainAddress is a valid Ethereum address
          transferValue, // Token amount in wei
        ],
      );
      // final isTransactionSuc cess = await _checkTxHashStatus(approveResult);

      print('Approve successful: $approveResult');

      // Now execute the transfer function after approve is successful
      print('Executing transfer function...');
      final transferResult = await _w3mService.requestWriteContract(
        topic: _w3mService.session?.topic.toString() ?? '',
        chainId: "eip155:137", // Ensure you are connected to the correct chain
        deployedContract: _contract,
        functionName: 'transfer',
        transaction: Transaction(
          from: EthereumAddress.fromHex(
              _w3mService.session?.address ?? ''), // Use the wallet address
        ),
        parameters: [
          _mainAddress, // Ensure _mainAddress is a valid Ethereum address
          transferValue, // Token amount in wei
        ],
      );

      print('Transfer successful: $transferResult');
    } catch (e) {
      if (e.toString().contains('User denied transaction signature')) {
        print('Transaction signature denied by the user.');
      } else {
        print('Error during transfer: $e');
      }
    }
  }

  

  Future<void> _checkTxHashStatus(String txHash) async {
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
        
      } else {
        print('Transaction is not yet successful. Retrying...');
        await Future.delayed(Duration(seconds: 5)); // Poll every 5 seconds
      }
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
  // Placeholder for _buildAddPlan method
  Widget _buildAddPlan(String name) {
    // print('tap tap');
    return Center(
      child: TextButton(
        onPressed:
            // _isFreePlanActivated
            //     ? null // Disable the button when the plan is already activated
            //     :
            () {
          // Add the event when the button is pressed
        },
        child: _buildButton(
          context,
          name,
          Theme.of(context).colorScheme.secondary,
          Theme.of(context).primaryColor,
          Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  Widget _buildButton(
    BuildContext context,
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

// Placeholder for _buildPlan method
