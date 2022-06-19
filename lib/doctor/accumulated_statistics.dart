import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/charts.dart';

import '../generated/l10n.dart';
import '../model/User.dart';
import 'appointment_archives.dart';
import 'list_of_appointments.dart';

class AccumulatedStatistics extends StatefulWidget {
  AccumulatedStatistics({Key? key, required this.user}) : super(key: key);
  late User user;

  @override
  _AccumulatedStatisticsState createState() => _AccumulatedStatisticsState();
}

class _AccumulatedStatisticsState extends State<AccumulatedStatistics> {
  late User user;
  static const String SERVER_IP = 'https://pz-backend2022.herokuapp.com/api';
  late List<String> monthList = [
    S.of(context).january,
    S.of(context).february,
    S.of(context).march,
    S.of(context).april,
    S.of(context).may,
    S.of(context).june,
    S.of(context).july,
    S.of(context).august,
    S.of(context).september,
    S.of(context).october,
    S.of(context).november,
    S.of(context).december
  ];
  List<int> yearList = [2021, 2022];
  int chosenMonth = 0;
  int chosenYear = 2021;
  late int visits = 400;
  late int prescriptionsIssuead = 200;
  late int women = 350;
  late int men = 250;
  late Map<String, int> bestMedicine = {
    "apap": 150,
    "duracel": 100,
    "bread": 50
  };
  late Map<String, int> durations = {"60": 50, "40": 100, "20": 150};

  @override
  void initState() {
    user = widget.user;
    chosenMonth = DateTime.now().month;
    chosenYear = DateTime.now().year;
    _getStatistics(chosenMonth, chosenYear);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _getStatistics(chosenMonth, chosenYear);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: 1,
          backgroundColor: Colors.teal,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book),
              label: S.of(context).appList,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: S.of(context).statistics,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.library_books),
              label: S.of(context).appHistory,
            ),
          ],
          onTap: (option) {
            switch (option) {
              case 0:
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ListOfAppointments(user: user)));
                break;
              case 1:
                break;
              case 2:
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AppointmentArchives(
                              user: user,
                            )));
                break;
            }
          },
          selectedItemColor: Colors.white),
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(
          S.of(context).appointmentsStatistics,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
          child: Container(
        width: 300,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Column(
                children: [
                  Text(
                    S.of(context).chooseMonthAndYear,
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(60, 0, 0, 0),
                    child: Row(
                      children: [
                        DropdownButton(
                            value: chosenMonth,
                            items: [
                              for (String month in monthList)
                                DropdownMenuItem(
                                  child: Text(month),
                                  value: monthList.indexOf(month),
                                )
                            ],
                            onChanged: (value) {
                              if (value is int) {
                                chosenMonth = value;
                                setState(() {});
                              }
                            }),
                        SizedBox(
                          width: 10,
                        ),
                        DropdownButton(
                            value: chosenYear,
                            items: [
                              for (int year in yearList)
                                DropdownMenuItem(
                                  child: Text(year.toString()),
                                  value: year,
                                )
                            ],
                            onChanged: (value) {
                              if (value is int) {
                                chosenYear = value;
                                setState(() {});
                              }
                            }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: 300.0,
              height: MediaQuery.of(context).size.height * 0.62,
              child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                  children: _buildAccumulativeStatistics(context)),
            ),
          ],
        ),
      )),
    );
  }

  List<_PieData> sexPieData = [
    _PieData("male", 43, "43%"),
    _PieData("female", 57, "57%"),
  ];
  List<_PieData> bestMedicinePieData = [
    _PieData("Apap", 300, "50%"),
    _PieData("Bread", 200, "30%"),
    _PieData("Air", 100, "20%"),
  ];
  List<_PieData> visitDurPieData = [
    _PieData("60 min", 14, "14%"),
    _PieData("40 min", 35, "35%"),
    _PieData("20 min", 51, "51%"),
  ];
  List<_PieData> receiptGivenPieData = [
    _PieData("Yes", 76, "76%"),
    _PieData("No", 24, "24%"),
  ];

  _buildAccumulativeStatistics(BuildContext context) {
    return [
      Text(
        S.of(context).appointmentsStatistics,
        style: TextStyle(
            color: Colors.teal, fontSize: 24, fontWeight: FontWeight.bold),
      ),
      const SizedBox(
        height: 20,
      ),
      SfCircularChart(
          title: ChartTitle(
              text: S.of(context).sex,
              alignment: ChartAlignment.near,
              textStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 19)),
          legend: Legend(isVisible: true),
          series: <PieSeries<_PieData, String>>[
            PieSeries<_PieData, String>(
                explode: true,
                explodeIndex: 0,
                dataSource: sexPieData,
                xValueMapper: (_PieData data, _) => data.xData,
                yValueMapper: (_PieData data, _) => data.yData,
                dataLabelMapper: (_PieData data, _) => data.text,
                dataLabelSettings: DataLabelSettings(isVisible: true)),
          ]),
      SfCircularChart(
          title: ChartTitle(
              text: S.of(context).visitDuration,
              alignment: ChartAlignment.near,
              textStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 19)),
          legend: Legend(isVisible: true),
          series: <PieSeries<_PieData, String>>[
            PieSeries<_PieData, String>(
                explode: true,
                explodeIndex: 0,
                dataSource: visitDurPieData,
                xValueMapper: (_PieData data, _) => data.xData,
                yValueMapper: (_PieData data, _) => data.yData,
                dataLabelMapper: (_PieData data, _) => data.text,
                dataLabelSettings: DataLabelSettings(isVisible: true)),
          ]),
      SfCircularChart(
          title: ChartTitle(
              text: S.of(context).prescriptionIssued,
              alignment: ChartAlignment.near,
              textStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 19)),
          legend: Legend(isVisible: true),
          series: <PieSeries<_PieData, String>>[
            PieSeries<_PieData, String>(
                explode: true,
                explodeIndex: 0,
                dataSource: receiptGivenPieData,
                xValueMapper: (_PieData data, _) => data.xData,
                yValueMapper: (_PieData data, _) => data.yData,
                dataLabelMapper: (_PieData data, _) => data.text,
                dataLabelSettings: DataLabelSettings(isVisible: true)),
          ]),
      SfCircularChart(
          title: ChartTitle(
              text: S.of(context).mostPrescribedMedicine,
              alignment: ChartAlignment.near,
              textStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 19)),
          legend: Legend(isVisible: true),
          series: <PieSeries<_PieData, String>>[
            PieSeries<_PieData, String>(
                explode: true,
                explodeIndex: 0,
                dataSource: bestMedicinePieData,
                xValueMapper: (_PieData data, _) => data.xData,
                yValueMapper: (_PieData data, _) => data.yData,
                dataLabelMapper: (_PieData data, _) => data.text,
                dataLabelSettings: DataLabelSettings(isVisible: true)),
          ])
    ];
  }

  _getStatistics(int month, int year) async {
    var res = await http.get(
        Uri.parse("$SERVER_IP/Statistics/GetMonthly?Month=$month&Year=$year"),
        headers: {HttpHeaders.authorizationHeader: "Bearer " + user.token});
    print("getting statistics");
    if (res.statusCode != 200) {
      print(res.request?.url.path);
      print(res.statusCode);
      print(res.reasonPhrase);
    } else {
      Map jsonMap = jsonDecode(res.body);
      print(jsonMap);
      visits = jsonMap["visits"];
      prescriptionsIssuead = jsonMap["prescriptionsIssued"];
      men = jsonMap["sex"]["men"];
      women = jsonMap["sex"]["women"];
      List<String> medicineNames = [];
      List<int> medicineCounts = [];

      for (String medicine in jsonMap["bestMedicines"].keys) {
        medicineNames.add(medicine);
        medicineCounts.add(jsonMap["bestMedicines"][medicine]);
      }

      for (String duration in jsonMap["durations"].keys) {
        durations[duration] = jsonMap["durations"][duration];
      }

      sexPieData = [
        _PieData(S.of(context).male, men,
            "${((men) / (women + men) * 100).ceil()}%"),
        _PieData(S.of(context).female, women,
            "${((women) / (women + men) * 100).ceil()}%"),
      ];
      int dur60 = durations['60']?.toInt() ?? 100;
      int dur40 = durations['40']?.toInt() ?? 200;
      int dur20 = durations['20']?.toInt() ?? 300;
      visitDurPieData = [
        _PieData("60 min", dur60,
            "${((dur60) / (dur20 + dur40 + dur60) * 100).ceil()}%"),
        _PieData("40 min", dur40,
            "${((dur40) / (dur20 + dur40 + dur60) * 100).ceil()}%"),
        _PieData("20 min", dur20,
            "${((dur20) / (dur20 + dur40 + dur60) * 100).ceil()}%"),
      ];
      receiptGivenPieData = [
        _PieData(S.of(context).yes, prescriptionsIssuead,
            "${((prescriptionsIssuead / visits) * 100).ceil()}%"),
        _PieData(S.of(context).no, visits - prescriptionsIssuead,
            "${(((visits - prescriptionsIssuead) / visits) * 100).ceil()}%"),
      ];
      int allMedicineCount = 0;
      medicineCounts.forEach((medCount) {
        allMedicineCount += medCount;
      });
      bestMedicinePieData.clear();
      for (int i = 0; i < medicineNames.length; i++) {
        bestMedicinePieData.add(_PieData(medicineNames[i], medicineCounts[i],
            "${((medicineCounts[i]) / (allMedicineCount) * 100).ceil()}%"));
      }

      setState(() {});
    }
  }
}

class _PieData {
  _PieData(this.xData, this.yData, this.text);

  final String xData;
  final num yData;
  late String text;
}
