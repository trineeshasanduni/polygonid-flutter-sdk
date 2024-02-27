import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/dependency_injection/dependencies_provider.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/home/home_bloc.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/home/home_event.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/home/home_state.dart';
import 'package:polygonid_flutter_sdk_example/utils/custom_button_style.dart';
import 'package:polygonid_flutter_sdk_example/utils/custom_strings.dart';
import 'package:polygonid_flutter_sdk_example/utils/custom_text_styles.dart';
import 'package:polygonid_flutter_sdk_example/utils/custom_widgets_keys.dart';
// import '..//Screens/network.dart';
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
                    // onTap: () {
                    //   Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                    //     return Network();
                    //   }
                    //   ));
                    // },
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
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            const Text(
              "My identity",
              style: TextStyle(fontSize: 15),
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              width: double.infinity,
              height: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: Colors.grey.shade200,
              ),
              child: BlocBuilder(
                bloc: _bloc,
                builder: (BuildContext context, HomeState state) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Text(
                      state.identifier ??
                          CustomStrings.homeIdentifierSectionPlaceHolder,
                      key: const Key('identifier'),
                      style: CustomTextStyles.descriptionTextStyle
                          .copyWith(fontSize: 15, color: Colors.black54),
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
}
