import 'package:desktop_erp/ui/reports/ui/demo/syncfusion_line_chart_demo.dart';
import 'package:desktop_erp/ui/reports/ui/demo/syncfusion_pie_chart_demo.dart';
import 'package:flutter/material.dart';

import '../../model/agent_data_model.dart';

class DashboardPage extends StatelessWidget {
  final List<AgentData> agents;
  DashboardPage({required this.agents});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dashboard")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 400, child: SyncfusionPieChartDemo(agents: agents)),
            SizedBox(height: 300, child: SyncfusionLineChartDemo(agents: agents)),
          ],
        ),
      ),
    );
  }
}
