import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/planner_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  final List<Color> _seedColors = const [
    Color(0xFF6750A4), // Mor
    Color(0xFF0061A4), // Mavi
    Color(0xFF006A60), // Camgöbeği
    Color(0xFF386A20), // Yeşil
    Color(0xFF984061), // Gül / Bordo
    Color(0xFF825500), // Kehribar
  ];

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PlannerProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Uygulama Ayarları'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // User Profile Card
          Text('Kullanıcı Profili', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: theme.colorScheme.primaryContainer,
                        child: Text(
                          provider.userName.isNotEmpty ? provider.userName[0].toUpperCase() : 'E',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${provider.userName}, ${provider.userAge}',
                              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                const Icon(Icons.school_outlined, size: 14, color: Colors.grey),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    provider.userUniversity,
                                    style: TextStyle(fontSize: 12, color: theme.hintColor),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    provider.userLocation,
                                    style: TextStyle(fontSize: 12, color: theme.hintColor),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit_outlined),
                        onPressed: () => _showEditProfileDialog(context, provider),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Theme Section Header
          Text('Görünüm ve Tema', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),

          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Karanlık Tema'),
                  subtitle: const Text('Gece modunu aktif eder'),
                  value: provider.isDarkMode,
                  secondary: const Icon(Icons.dark_mode_outlined),
                  onChanged: (val) => provider.toggleDarkMode(val),
                ),
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Tema Vurgu Rengi', style: TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: _seedColors.map((color) {
                          final isSelected = provider.seedColor.value == color.value;
                          return InkWell(
                            onTap: () => provider.setSeedColor(color),
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                                border: isSelected
                                    ? Border.all(color: Colors.white, width: 3)
                                    : null,
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: color.withOpacity(0.4),
                                          blurRadius: 8,
                                          spreadRadius: 2,
                                        )
                                      ]
                                    : null,
                              ),
                              child: isSelected
                                  ? const Icon(Icons.check, color: Colors.white, size: 20)
                                  : null,
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Data Management
          Text('Veri Yönetimi', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),

          Card(
            child: ListTile(
              leading: const Icon(Icons.restore, color: Colors.orange),
              title: const Text('Örnek Verileri Sıfırla'),
              subtitle: const Text('Varsayılan görev ve rutinleri yeniden yükler'),
              onTap: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Veriler Sıfırlansın mı?'),
                    content: const Text('Bu işlem görev ve rutinleri varsayılan örnek verilere sıfırlayacaktır.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: const Text('İptal'),
                      ),
                      FilledButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        child: const Text('Sıfırla'),
                      ),
                    ],
                  ),
                );
                if (confirm == true) {
                  await provider.resetToSampleData();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Veriler varsayılan değerlere sıfırlandı.')),
                    );
                  }
                }
              },
            ),
          ),
          const SizedBox(height: 24),

          // About Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.calendar_month, color: theme.colorScheme.primary, size: 32),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Günlük Planlayıcı & Rutin', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                          const Text('Sürüm 1.0.0 • Material 3', style: TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context, PlannerProvider provider) {
    final nameCtrl = TextEditingController(text: provider.userName);
    final ageCtrl = TextEditingController(text: provider.userAge.toString());
    final locCtrl = TextEditingController(text: provider.userLocation);
    final uniCtrl = TextEditingController(text: provider.userUniversity);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Profili Düzenle'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'İsim'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: ageCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Yaş'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: locCtrl,
                decoration: const InputDecoration(labelText: 'Konum'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: uniCtrl,
                decoration: const InputDecoration(labelText: 'Üniversite / Okul'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('İptal'),
          ),
          FilledButton(
            onPressed: () {
              provider.updateProfile(
                name: nameCtrl.text.trim(),
                age: int.tryParse(ageCtrl.text.trim()) ?? provider.userAge,
                location: locCtrl.text.trim(),
                university: uniCtrl.text.trim(),
              );
              Navigator.pop(ctx);
            },
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );
  }
}
