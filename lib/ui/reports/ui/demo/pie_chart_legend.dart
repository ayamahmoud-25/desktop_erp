import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../model/agent_data_model.dart';

class PieChartWithLegend extends StatelessWidget {
  final List<AgentData> agents;
  PieChartWithLegend({required this.agents});

  final List<Color> colors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.teal,
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // --- Pie Chart ---
        SizedBox(
          height: 250,
          child: PieChart(
            PieChartData(
              sectionsSpace: 0,
              centerSpaceRadius: 0, // فراغ في النص (عشان يبقى Doughnut Chart)
              startDegreeOffset: 0,
              sections: agents.asMap().entries.map((entry) {
                int index = entry.key;
                AgentData agent = entry.value;

                return PieChartSectionData(
                  color: colors[index % colors.length],
                  value: agent.endDebit,
                  title: "",
                  radius: 120,
                  //titlePositionPercentageOffset:2, // 👈 يتحكم في مكان النص

                );
              }).toList(),
            ),
          ),
        ),

        const SizedBox(height: 20),

        // --- Legend ---
        Wrap(
          spacing: 20,
          runSpacing: 10,
          children: agents.asMap().entries.map((entry) {
            int index = entry.key;
            AgentData agent = entry.value;

            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colors[index % colors.length],
                  ),
                ),
                const SizedBox(width: 6),
                Text(agent.name,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),

              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}
