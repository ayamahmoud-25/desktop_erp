import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../model/agent_data_model.dart';


class LineChartSample extends StatelessWidget {
  final List<AgentData> agents;
  LineChartSample({required this.agents});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            isCurved: true,
            spots: agents.map((agent) {
              return FlSpot(
                agents.indexOf(agent).toDouble(),
                agent.endDebit,
              );
            }).toList(),
            dotData: FlDotData(show: true),
            belowBarData: BarAreaData(show: true),
          ),
        ],
      ),
    );
  }
}
