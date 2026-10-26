import 'package:flutter/material.dart';

import '../../state/app_controller.dart';
import '../../widgets/app_background.dart';
import 'statistics_screen.dart';

/// Ana sayfadan açılan istatistik sayfası.
class StatisticsPage extends StatelessWidget {
  /// İstatistik sayfasını merkezi denetleyiciyle oluşturur.
  const StatisticsPage({super.key, required this.controller});

  /// Uygulamanın merkezi durumu.
  final AppController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        titleSpacing: 4,
        title: const Text('İstatistikler'),
      ),
      body: AppBackground(child: StatisticsScreen(controller: controller)),
    );
  }
}
