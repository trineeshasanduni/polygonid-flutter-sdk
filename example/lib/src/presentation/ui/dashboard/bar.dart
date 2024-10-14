import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polygonid_flutter_sdk/dashboard/domain/entities/networkUsageEntity.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/dependency_injection/dependencies_provider.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/dashboard/dashboard_bloc/dashboard_bloc.dart';

class LineChartSample2 extends StatefulWidget {
  final String? did;
  const LineChartSample2({super.key, this.did});

  @override
  State<LineChartSample2> createState() => _LineChartSample2State();
}

class _LineChartSample2State extends State<LineChartSample2> {
  List<Color> gradientColors = [
     const Color(0xFF2CFFAE),
      const Color(0xFFa3d902),
  ];

  bool showAvg = false;
  late final DashboardBloc _dashboardBloc;
  List<String?> formattedDay = [];
  List<double?> dailyUsageMiB = [];

  @override
  void initState() {
    super.initState();
    _dashboardBloc = getIt<DashboardBloc>();
    _initActivityLogs();
  }

  void _initActivityLogs() {
    if (widget.did != null) {
      _dashboardBloc
          .add(networkUsageEvent(did: widget.did!)); // Trigger the event
    } else {
      print('DID is null');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
        bloc: _dashboardBloc,
        builder: (context, state) {
          if (state is DashboardLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is DashboardLoaded) {
            final usageData = state.usage;
            print('state usage: ${state.usage}');

            String getDateOnly(String timestamp) {
              // Parse the timestamp to a DateTime object
              DateTime dateTime = DateTime.parse(timestamp);

              // Extract year, month, and day
              String formattedDate =
                  "${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";

              return formattedDate;
            }

            List<String?> days = usageData.map((entity) => entity.day).toList();

            List<String?> formattedDays =
                days.map((day) => getDateOnly(day!)).toList();

            formattedDay = formattedDays.reversed.toList();

            List<double?> dailyUsageMiBs = usageData.map((entity) {
              return entity.dailyUsage != null
                  ? double.parse((entity.dailyUsage! / (1024 * 1024))
                      .toStringAsFixed(2)) // Convert bytes to MiB and round
                  : null; // Handle null values appropriately
            }).toList();

            dailyUsageMiB = dailyUsageMiBs.reversed.toList();

            // You can print or use these lists as needed
            print('Days: $formattedDay');
            print('Daily Usage: $dailyUsageMiB');

            return Stack(
              children: <Widget>[
                AspectRatio(
                  aspectRatio: 1.50,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 25.0,left: 15,top: 40, bottom: 40),
                    child: LineChart(
                        // showAvg
                        //     ? avgData(state.usage.cast<NetworkUsageEntity>())
                        //     : 
                            mainData(state.usage),
                      ),
                  ),
                  
                ),
                // Positioned(
                //   right: 16,
                //   top: 16,
                //   child: TextButton(
                //     onPressed: () {
                //       setState(() {
                //         showAvg = !showAvg;
                //       });
                //     },
                //     child: Text(
                //       'avg',
                //       style: TextStyle(
                //         fontSize: 12,
                //         color: showAvg
                //             ? Colors.white.withOpacity(0.5)
                //             : Colors.white,
                //       ),
                //     ),
                //   ),
                // ),
              ],
            );
          } else if (state is DashboardError) {
            return Center(
              child: Text('Error: ${state.message}'),
            );
          }
          return Container();
        });
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        formattedDay[value.toInt() % formattedDay.length]!,
        style:  TextStyle(
          color: Theme.of(context).appBarTheme.titleTextStyle?.color,
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
      ),
    );
  }

  // Widget leftTitleWidgets(double value, TitleMeta meta) {
  //   const style = TextStyle(
  //     fontWeight: FontWeight.bold,
  //     fontSize: 12,
  //   );
  //   return Text('${value.toStringAsFixed(2)}', style: style);
  // }
  Widget leftTitleWidgets(double value, TitleMeta meta) {
  double? getMaxUsage(List<double?> usageList) {
    return usageList
        .where((usage) => usage != null)
        .cast<double>()
        .reduce((a, b) => a > b ? a : b);
  }

  double? maxUsage = getMaxUsage(dailyUsageMiB);
  if (maxUsage == null) return Container(); // Handle null case

  const style = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 10,
  );

  String text;
  switch (value.toInt()) {
    case 0:
      text = '0';
      break;
    case 2:
      text = (2*maxUsage / 10).toStringAsFixed(2);
      break;
    case 4:
      text = (4*maxUsage / 10).toStringAsFixed(2);
      break;
    case 6:
      text = (6 * maxUsage / 10).toStringAsFixed(2);
      break;
      case 8:
      text = (8* maxUsage ).toStringAsFixed(2);
      break;
     case 10:
      text = (maxUsage ).toStringAsFixed(2);
      break;
    default:
      return Container();
  }

  return Text(
    text,
    style: style,
    
    textAlign: TextAlign.left,
  );
}


  LineChartData mainData(List<NetworkUsageEntity> usage) {
  final spots = dailyUsageMiB
      .asMap()
      .entries
      .map((entry) => FlSpot(entry.key.toDouble(), entry.value ?? 0.0))
      .toList();

      print('spots: $spots');

  double? maxUsage = dailyUsageMiB
      .where((usage) => usage != null)
      .cast<double>()
      .reduce((a, b) => a > b ? a : b);

      print('maxUsage: $maxUsage');

  return LineChartData(
    gridData: const FlGridData(
      show: true,
      drawVerticalLine: true,
      horizontalInterval: 1,
      verticalInterval: 1,
    ),
    titlesData: FlTitlesData(
      show: true,
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 50,
          interval: 1,
          getTitlesWidget: bottomTitleWidgets,
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          interval: 1,
          getTitlesWidget: leftTitleWidgets,
          reservedSize: 42,
        ),
        axisNameWidget: const Text(
                  'MiB',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8
                  ),
                ),
      ),
    ),
    borderData: FlBorderData(
        show: true, border: Border.all(color: const Color(0xff37434d))),
    minX: 0,
    maxX: (dailyUsageMiB.length - 1).toDouble(),
    minY: 0,
    maxY:10, // Set maxY to maxUsage
    lineBarsData: [
      LineChartBarData(
        spots: spots,
        isCurved: true,
        gradient: LinearGradient(colors: gradientColors),
        barWidth: 5,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: false),
        belowBarData: BarAreaData(
          show: true,
          gradient: LinearGradient(
            colors: gradientColors
                .map((color) => color.withOpacity(0.3))
                .toList(),
          ),
        ),
      ),
    ],
  );
}


  LineChartData avgData( List<NetworkUsageEntity> usage) {
    final averageUsage = dailyUsageMiB
            .where((e) => e != null)
            .map((e) => e!)
            .reduce((a, b) => a + b) /
        dailyUsageMiB.length;

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        verticalInterval: 1,
        horizontalInterval: 1,
        // getDrawingVerticalLine: (value) {
        //   return const FlLine(color: Color(0xff37434d), strokeWidth: 1);
        // },
        // getDrawingHorizontalLine: (value) {
        //   return const FlLine(color: Color(0xff37434d), strokeWidth: 1);
        // },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: bottomTitleWidgets,
            interval: 1,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
            interval: 1,
          ),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(
          show: true, border: Border.all(color: const Color(0xff37434d))),
      minX: 0,
      maxX: dailyUsageMiB.length.toDouble(),
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: List.generate(dailyUsageMiB.length,
              (index) => FlSpot(index.toDouble(), averageUsage)),
          isCurved: true,
          gradient: LinearGradient(colors: gradientColors),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
