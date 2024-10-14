// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:polygonid_flutter_sdk/dashboard/domain/entities/networkUsageEntity.dart';
// import 'package:polygonid_flutter_sdk_example/src/presentation/dependency_injection/dependencies_provider.dart';
// import 'package:polygonid_flutter_sdk_example/src/presentation/ui/dashboard/dashboard_bloc/dashboard_bloc.dart';

// class BarChartSample2 extends StatefulWidget {
//   final String? did;
//   const BarChartSample2({super.key, this.did});

//   @override
//   State<StatefulWidget> createState() => BarChartSample2State();
// }

// class BarChartSample2State extends State<BarChartSample2> {
//   final double width = 7;

//   late List<BarChartGroupData> rawBarGroups;
//   late List<BarChartGroupData> showingBarGroups;

//   int touchedGroupIndex = -1;
//   late final DashboardBloc _dashboardBloc;
  
//   int get index => 0;

//   @override
//   void initState() {
//     super.initState();
//     rawBarGroups = []; // Initialize as empty
//     showingBarGroups = [];

//     _dashboardBloc = getIt<DashboardBloc>();
//     _initActivityLogs();
//   }

//   void _initActivityLogs() {
//     if (widget.did != null) {
//       _dashboardBloc.add(networkUsageEvent(did: widget.did!)); // Trigger the event
//     } else {
//       print('DID is null');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AspectRatio(
//       aspectRatio: 1.8,
//       child: Padding(
//         padding: const EdgeInsets.all(5),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: <Widget>[
//             Expanded(
//               child: BlocBuilder<DashboardBloc, DashboardState>(
//                 bloc: _dashboardBloc,
//                 builder: (context, state) {
//                   if (state is DashboardLoading) {
//                     return Center(child: CircularProgressIndicator());
//                   } else if (state is DashboardLoaded) {
//                     // Assuming state.networkUsage returns List<NetworkUsageEntity>
//                     final networkUsageData = state.usage; 
//                     print('network sage : $networkUsageData');// Replace with actual data

//                     showingBarGroups = networkUsageData.map((usage) {
//                       return makeGroupData(
//                         index , // Replace with actual data
//                         usage.dailyUsage as double  , // Replace with actual data
                        

//                       );
//                     }).toList();

//                     return BarChart(
//                       BarChartData(
//                         maxY: 28,
//                         barTouchData: BarTouchData(
//                           touchTooltipData: BarTouchTooltipData(
//                             getTooltipItem: (a, b, c, d) => null,
//                           ),
//                           touchCallback: (FlTouchEvent event, response) {
//                             if (response == null || response.spot == null) {
//                               setState(() {
//                                 touchedGroupIndex = -1;
//                                 showingBarGroups = List.of(rawBarGroups);
//                               });
//                               return;
//                             }

//                             touchedGroupIndex = response.spot!.touchedBarGroupIndex;

//                             setState(() {
//                               if (!event.isInterestedForInteractions) {
//                                 touchedGroupIndex = -1;
//                                 showingBarGroups = List.of(rawBarGroups);
//                                 return;
//                               }
//                               showingBarGroups = List.of(rawBarGroups);
//                               if (touchedGroupIndex != -1) {
//                                 var sum = 0.0;
//                                 for (final rod in showingBarGroups[touchedGroupIndex].barRods) {
//                                   sum += rod.toY;
//                                 }
//                                 final avg = sum / showingBarGroups[touchedGroupIndex].barRods.length;

//                                 showingBarGroups[touchedGroupIndex] =
//                                     showingBarGroups[touchedGroupIndex].copyWith(
//                                   barRods: showingBarGroups[touchedGroupIndex].barRods.map((rod) {
//                                     return rod.copyWith(toY: avg, color: Colors.orange);
//                                   }).toList(),
//                                 );
//                               }
//                             });
//                           },
//                         ),
//                         titlesData: FlTitlesData(
//                           show: true,
//                           rightTitles: const AxisTitles(
//                             sideTitles: SideTitles(showTitles: false),
//                           ),
//                           topTitles: const AxisTitles(
//                             sideTitles: SideTitles(showTitles: false),
//                           ),
//                           bottomTitles: AxisTitles(
//                             sideTitles: SideTitles(
//                               showTitles: true,
//                               getTitlesWidget: _bottomTitles,
//                               reservedSize: 42,
//                             ),
//                           ),
//                           leftTitles: AxisTitles(
//                             sideTitles: SideTitles(
//                               showTitles: true,
//                               reservedSize: 28,
//                               interval: 1,
//                               getTitlesWidget: _leftTitles,
//                             ),
//                           ),
//                         ),
//                         borderData: FlBorderData(
//                           show: false,
//                         ),
//                         barGroups: showingBarGroups,
//                         gridData: const FlGridData(show: false),
//                       ),
//                     );
//                   } else if (state is DashboardError) {
//                     return Center(child: Text('Failed to load data'));
//                   }
//                   return Container(); // Placeholder for other states
//                 },
//               ),
//             ),
//             const SizedBox(height: 12),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _leftTitles(double value, TitleMeta meta) {
//     final style = TextStyle(
//       color: Theme.of(context).appBarTheme.titleTextStyle?.color,
//       fontWeight: FontWeight.bold,
//       fontSize: 10,
//     );
//     String text;
//     if (value == 0) {
//       text = '1K';
//     } else if (value == 10) {
//       text = '5K';
//     } else if (value == 19) {
//       text = '10K';
//     } else {
//       return Container();
//     }
//     return SideTitleWidget(
//       axisSide: meta.axisSide,
//       space: 0,
//       child: Text(text, style: style),
//     );
//   }

//   Widget _bottomTitles(double value, TitleMeta meta) {
//     final titles = <String>['Mn', 'Te', 'Wd', 'Tu', 'Fr', 'St', 'Su'];

//     final Widget text = Text(
//       titles[value.toInt()],
//       style: TextStyle(
//         color: Theme.of(context).appBarTheme.titleTextStyle?.color,
//         fontWeight: FontWeight.bold,
//         fontSize: 10,
//       ),
//     );

//     return SideTitleWidget(
//       axisSide: meta.axisSide,
//       space: 16, //margin top
//       child: text,
//     );
//   }

//   BarChartGroupData makeGroupData(int x, double y1) {
//     return BarChartGroupData(
//       barsSpace: 4,
//       x: x ,
//       barRods: [
//         BarChartRodData(
//           toY: y1  ,
//           color: Color(0xFFa3d902),
//           width: width,
//         ),
//         // BarChartRodData(
//         //   toY: y2,
//         //   color: Color(0xFF2CFFAE),
//         //   width: width,
//         // ),
//       ],
//     );
//   }
// }
