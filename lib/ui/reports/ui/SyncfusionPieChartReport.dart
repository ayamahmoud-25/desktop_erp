import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../data/models/response/FinanceBalanceReportResponse.dart';


class SyncfusionPieChartReport extends StatelessWidget {
  final List<FinanceBalanceReportResponse> agents;
  SyncfusionPieChartReport({required this.agents});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    /*  appBar: AppBar(title: Text("Syncfusion Pie Chart")),*/
      body: Center(
        child: SfCircularChart(
          tooltipBehavior: TooltipBehavior(enable: true), // 👈 تفعيل التولتيب
          legend: Legend(
            isVisible: true,
            position: LegendPosition.bottom,   // 👈 يحطه على اليمين
            orientation: LegendItemOrientation.vertical, // 👈 يخلي العناصر عمودية
            overflowMode: LegendItemOverflowMode.wrap,  // عشان لو عناصر كتير تنزل تحت بعض
            isResponsive: true,
          ),          series: <CircularSeries>[
          PieSeries<FinanceBalanceReportResponse, String>(
            dataSource: agents,
            xValueMapper: (FinanceBalanceReportResponse agent, _) => agent.name,
            yValueMapper: (FinanceBalanceReportResponse agent, _) => agent.endDebit,
            dataLabelSettings: DataLabelSettings(
                isVisible: true,
                labelPosition: ChartDataLabelPosition.outside,
                connectorLineSettings: ConnectorLineSettings(
                  type: ConnectorType.curve, // شكل الخط: curve أو straight
                  length: '15%',             // طول الخط
                  width: 2,                  // سمك الخط
                  color: Colors.grey,        // لون الخط
                ),color: Colors.black),
            enableTooltip: true, // 👈 لازم تتفعل هنا كمان

          )
        ],
        ),
      ),
    );
  }
}