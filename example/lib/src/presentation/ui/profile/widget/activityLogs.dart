import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:polygonid_flutter_sdk/profile/data/models/activityModel.dart';
import 'package:polygonid_flutter_sdk/profile/domain/entities/activityEntity.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/dependency_injection/dependencies_provider.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/profile/bloc/profile_bloc.dart';

class NotificationPanel extends StatefulWidget {
  final String? did;
  const NotificationPanel({Key? key, this.did}) : super(key: key);

  @override
  State<NotificationPanel> createState() => _NotificationPanelState();
}

class _NotificationPanelState extends State<NotificationPanel> {
  late List<ActivityModel> activityLogs =
      []; // Store the activity logs as LogsModel
  late final ProfileBloc _profileBloc;

  // To track which card is expanded
  List<bool> _expandedStates = [];

  @override
  void initState() {
    super.initState();
    _profileBloc = getIt<ProfileBloc>();
    _initActivityLogs();
  }

  void _initActivityLogs() {
    if (widget.did != null) {
      _profileBloc.add(ActivityLogsEvent(did: widget.did!));
    } else {
      print('DID is null');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Activity Logs',
          style: TextStyle(
            color: Theme.of(context).secondaryHeaderColor,
            fontSize: 20,
            fontFamily: GoogleFonts.robotoMono().fontFamily,
            fontWeight: FontWeight.w300,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: Column(
          children: [
            // _buildHeader(),
            const SizedBox(
              height: 20,
            ),
            // Text(
            //   'Notifications',
            //   style: TextStyle(
            //     color: Theme.of(context).secondaryHeaderColor,
            //     fontSize: 20,
            //     fontFamily: GoogleFonts.robotoMono().fontFamily,
            //     fontWeight: FontWeight.w300,
            //   ),
            // ),
            // const SizedBox(
            //   height: 20,
            // ),
            Expanded(child: _buildNotifyList()),
          ],
        ),
      ),
    );
  }

  Widget _buildNotifyList() {
    return BlocBuilder<ProfileBloc, ProfileState>(
      bloc: _profileBloc,
      builder: (context, state) {
        String getDateOnly(String timestamp) {
          // Parse the timestamp to a DateTime object
          DateTime dateTime = DateTime.parse(timestamp);

          // Extract year, month, and day
          String formattedDate =
              "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";

          return formattedDate;
        }

        String getTimeOnly(String timestamp) {
          // Parse the timestamp to a DateTime object
          DateTime dateTime = DateTime.parse(timestamp);

          // Extract hour, minute, and second
          String formattedTime =
              "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}";

          return formattedTime;
        }

        if (state is LogsUpdating) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is LogsUpdated) {
          final ActivityEntity activityEntity = state.logs;
          final logLength = activityEntity.groupedLogs?.length ?? 0;

          if (logLength > 0) {
            // Initialize _expandedStates if not already done
            if (_expandedStates.isEmpty) {
              _expandedStates = List.filled(logLength, false);
            }

            return ListView.builder(
              itemCount: logLength,
              itemBuilder: (context, i) {
                final group = activityEntity.groupedLogs![i];
                final logMoreLength = group.logs?.length ?? 0;

                final logs = group.logs;
                if (logs != null && logs.isNotEmpty) {
                  final log = logs[0];

                  return Card(
                    child: Column(
                      children: [
                        ListTile(
                          leading: log.level == "INFO"
                              ? Icon(Icons.file_upload,
                                  size: 20,
                                  color:
                                      Theme.of(context).colorScheme.secondary)
                              : Icon(Icons.error,
                                  size: 20, color: Colors.redAccent),
                          title: Text(
                            log.name ?? 'No ID',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              fontFamily: GoogleFonts.robotoMono().fontFamily,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                log.data ?? 'No data',
                                style: TextStyle(
                                    fontSize: 9,
                                    fontFamily:
                                        GoogleFonts.robotoMono().fontFamily),
                              ),
                              Row(
                                children: [
                                  Text(
                                    getDateOnly(
                                        log.humanReadableTimestamp ?? ''),
                                    style: TextStyle(
                                        fontFamily:
                                            GoogleFonts.robotoMono().fontFamily,
                                        color: Colors.grey,
                                        fontSize: 8),
                                  ),
                                  const SizedBox(width: 20),
                                  Text(
                                    getTimeOnly(
                                        log.humanReadableTimestamp ?? ''),
                                    style: TextStyle(
                                        fontFamily:
                                            GoogleFonts.robotoMono().fontFamily,
                                        color: Colors.grey,
                                        fontSize: 8),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          trailing: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                icon: Icon(
                                  _expandedStates[i]
                                      ? Icons.arrow_drop_up
                                      : Icons.arrow_drop_down,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 16,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _expandedStates[i] = !_expandedStates[i];
                                  });
                                },
                              ),
                            ],
                          ),
                        ),

                        // Expanded content when the state is expanded
                        if (_expandedStates[i])
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'More Details',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    fontFamily:
                                        GoogleFonts.robotoMono().fontFamily,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                                const SizedBox(height: 8),

                                // Wrap this column in a SingleChildScrollView to prevent overflow
                                SingleChildScrollView(
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(), // Prevent nested scroll issues
                                    itemCount:
                                        logMoreLength - 1, // Show from j + 1
                                    itemBuilder: (context, j) {
                                      final groupLog = group
                                          .logs![j + 1]; // Start from j + 1

                                      return Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Left side: Icon with dotted line
                                          Column(
                                            children: [
                                              Container(
                                                width: 20,
                                                padding:
                                                    const EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  color:
                                                      groupLog.level == 'INFO'
                                                          ? Theme.of(context)
                                                              .colorScheme
                                                              .secondary
                                                              .withOpacity(0.5)
                                                          : Colors.redAccent,
                                                  // Icon background color
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                              if (j != logMoreLength - 2) ...[
                                                // Add a dotted line for all but the last item
                                                SizedBox(height: 8),
                                                Container(
                                                  width: 2,
                                                  height:
                                                      40, // Adjust as needed
                                                  color: Colors.grey
                                                      .shade400, // Color of the line
                                                ),
                                              ],
                                            ],
                                          ),
                                          const SizedBox(
                                              width:
                                                  12), // Space between icon and text

                                          // Right side: Text data
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 8.0),
                                              child: Text(
                                                '${groupLog.data}', // Assuming this is the step title
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: GoogleFonts
                                                          .robotoMono()
                                                      .fontFamily, // Adjust as needed
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ),
                                          ),

                                          // Optionally add a date or time at the end (if needed)
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                getDateOnly(groupLog
                                                        .humanReadableTimestamp ??
                                                    ''),
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontFamily:
                                                        GoogleFonts.robotoMono()
                                                            .fontFamily,
                                                    fontSize: 8),
                                              ),
                                              Text(
                                                getTimeOnly(groupLog
                                                        .humanReadableTimestamp ??
                                                    ''),
                                                style: TextStyle(
                                                    fontFamily:
                                                        GoogleFonts.robotoMono()
                                                            .fontFamily,
                                                    color: Colors.grey,
                                                    fontSize: 8),
                                              ),
                                            ],
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                      ],
                    ),
                  );
                } else {
                  // Empty container if no logs exist
                  return const SizedBox.shrink();
                }
              },
            );
          } else {
            return const Center(child: Text('No activity logs available.'));
          }
        }

        if (state is LogsUpdateFailed) {
          return Center(
            child: Text(
              state.message,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          );
        }

        return const Center(child: Text('No Notifications or Logs'));
      },
    );
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
        onTap: () {
          _initActivityLogs();
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
}
