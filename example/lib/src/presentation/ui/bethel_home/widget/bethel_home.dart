import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/dependency_injection/dependencies_provider.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/auth/widgets/auth.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/bethel_home/widget/network.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/home/home_bloc.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/home/home_event.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/home/home_state.dart';
import 'package:polygonid_flutter_sdk_example/utils/custom_button_style.dart';
import 'package:polygonid_flutter_sdk_example/utils/custom_strings.dart';
import 'package:polygonid_flutter_sdk_example/utils/custom_text_styles.dart';
import 'package:polygonid_flutter_sdk_example/utils/custom_widgets_keys.dart';
// import '../Screens/mydata.dart';
import '../widget/bottom_nav.dart';
import '../widget/setting.dart';
// import 'splash.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final HomeBloc _bloc;
  bool showFullIdentity = false;
  @override
  void initState() {
    super.initState();
    _bloc = getIt<HomeBloc>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initGetIdentifier();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.person),
            tooltip: 'User',
            //  onPressed: (){
            //       Navigator.of(context).push(MaterialPageRoute(builder: (_) {
            //         return Identity();
            //       }));
            //     },

            onPressed: () {
              // print(object)
              Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                return _buildIdentifierSection();
              }));
            },
            color: Colors.black,
          ),
          actions: <Widget>[
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 8.0,
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                        return AuthScreen();
                      }
                      ));
                    },
                    child: Container(
                      width: 150,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        color: Colors.grey.shade200,
                      ),
                      child: Center(
                        child: Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.language),
                              tooltip: 'Search',
                              onPressed: () {
                                // Navigator.of(context)
                                //     .push(MaterialPageRoute(builder: (_) {
                                //   return Network();
                                // }));
                              },
                              color: Colors.black,
                            ),
                            const Text(
                              "Network",
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 70,
                ),
                IconButton(
                  icon: Icon(Icons.settings),
                  tooltip: 'Search',
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                      return Setting();
                    }));
                  },
                  color: Colors.black,
                ),
              ],
            ),
          ]),
      body: InkWell(
        // onTap: () {
        //   Navigator.of(context).push(MaterialPageRoute(builder: (_) {
        //     return MyData();
        //   }));
        // },
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(166, 17, 1, 1),
                  Colors.black,
                ],
              )),
          margin: const EdgeInsets.only(left: 30, right: 30, top: 20),
          child: Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: TextButton(
                        child: Text(
                          "MyData",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                        onPressed: null),
                  ),
                  const Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: TextButton(
                        child: Text(
                          "Credentials",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w400),
                        ),
                        onPressed: null),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: ElevatedButton(
                        onPressed: null,
                        child: Text(
                          'Unlocked',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w400),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                        )),
                  ),
                  SizedBox(
                    height: 80,
                    width: 60,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const MyBottom(),
    );
  }

  ///
  void _initGetIdentifier() {
    _bloc.add(const GetIdentifierHomeEvent());
  }

  Widget _buildIdentifierSection() {
    return Scaffold(
      appBar: AppBar(
          // backgroundColor: Colors.white,
          // elevation: 0,
          ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Text(
                "My identity",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.shade200,
              ),
              child: BlocBuilder(
                bloc: _bloc,
                builder: (BuildContext context, HomeState state) {
                  final String identityText = state.identifier ??
                      CustomStrings.homeIdentifierSectionPlaceHolder;
                  return Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("identifier"),
                        Row(
                          children: [
                            Container(
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey.shade100,
                                border: Border.all(
                                  color: Colors.black,
                                ),
                              ),
                              child: const Icon(
                                Icons.done, size: 15,
                                // color: iconColor,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 15.0, right: 15.0),
                              child: Text(
                                state.identifier != null
                                    ? showFullIdentity
                                        ? identityText
                                        : '. . . .   . . . .   . . . .   . . . .  ' +
                                            identityText.substring(
                                                identityText.length - 3)
                                    : CustomStrings
                                        .homeIdentifierSectionPlaceHolder,
                                key: const Key('identifier'),
                                style: CustomTextStyles.descriptionTextStyle
                                    .copyWith(
                                        fontSize: 15, color: Colors.black54),
                              ),
                            ),
                            
                            ElevatedButton(
                              onPressed: () {
                                // print(object)
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (_) {
                                  return _buildfullIdentifierSection();
                                }));
                              },
                              child: const Text("View"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
                buildWhen: (_, currentState) =>
                    currentState is LoadedIdentifierHomeState,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildfullIdentifierSection() {
    return Scaffold(
      appBar: AppBar(
          // backgroundColor: Colors.white,
          // elevation: 0,
          ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Text(
                "My identity",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: Colors.grey.shade200,
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Container(
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey.shade100,
                              border: Border.all(
                                color: Colors.black,
                              ),
                            ),
                            child: const Icon(
                              Icons.done, size: 15,
                              // color: iconColor,
                            ),
                          ),
                          const Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              "identifier",
                              style: TextStyle(fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ),
                    BlocBuilder(
                      bloc: _bloc,
                      builder: (BuildContext context, HomeState state) {
                        final String identityText = state.identifier ??
                            CustomStrings.homeIdentifierSectionPlaceHolder;
                        return Text(
                          state.identifier ??
                              CustomStrings.homeIdentifierSectionPlaceHolder,
                          key: const Key('identifier'),
                          style: CustomTextStyles.descriptionTextStyle
                              .copyWith(fontSize: 13),
                        );
                      },
                      buildWhen: (_, currentState) =>
                          currentState is LoadedIdentifierHomeState,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
