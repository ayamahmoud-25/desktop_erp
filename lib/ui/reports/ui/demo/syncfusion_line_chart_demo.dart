import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../model/agent_data_model.dart';

class SyncfusionLineChartDemo extends StatelessWidget {
  final List<AgentData> agents;
  SyncfusionLineChartDemo({required this.agents});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("الرسم البياني الخطي")),
      body: Center(
        child: SfCartesianChart(
          title: ChartTitle(text: 'أرصدة البنوك'),
          legend: Legend(isVisible: false),
          primaryXAxis: CategoryAxis(),   // المحور الأفقي (الأسماء)
          primaryYAxis: NumericAxis(),    // المحور الرأسي (القيم)
          series: <CartesianSeries>[
            ColumnSeries<AgentData, String>(
              dataSource: agents,
              xValueMapper: (AgentData agent, _) => agent.name,   // البنوك
              yValueMapper: (AgentData agent, _) => agent.endDebit,  // الرصيد
              dataLabelSettings: DataLabelSettings(
                isVisible: true, // عرض القيمة فوق العمود
              ),
              color: Colors.blue,
            )
          ],
        )
       /* SfCartesianChart(
          title: ChartTitle(text: 'أرصدة البنوك'),
          legend: Legend(isVisible: false),
          primaryXAxis: NumericAxis(),    // المحور الأفقي (القيم)
          primaryYAxis: CategoryAxis(),   // المحور الرأسي (الأسماء)
          series: <CartesianSeries>[
            BarSeries<AgentData, String>(
              dataSource: agents,
              xValueMapper: (AgentData agent, _) => agent.name,   // البنوك
              yValueMapper: (AgentData agent, _) => agent.endDebit,  // الرصيد
              dataLabelSettings: DataLabelSettings(
                isVisible: true, // عرض القيمة داخل/جنب العمود
              ),
              color: Colors.green,
            )
          ],
        )*/

        ,
      ),
    );
  }
}

