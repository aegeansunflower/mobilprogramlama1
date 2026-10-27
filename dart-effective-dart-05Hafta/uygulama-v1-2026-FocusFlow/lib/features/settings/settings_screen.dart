import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../blockchain/core/focus_chain_network.dart';
import '../../blockchain/utils/chain_formatters.dart';
import '../../models/app_settings.dart';
import '../../state/app_controller.dart';
import '../../widgets/app_background.dart';
import '../../widgets/app_snack_bar.dart';
import '../chain/chain_widgets.dart';

/// Pomodoro sürelerini, temayı ve yerel veri temizleme işlemini yönetir.
class SettingsScreen extends StatefulWidget {
  /// Ayarlar ekranını merkezi denetleyiciyle oluşturur.
  const SettingsScreen({super.key, required this.controller});

  /// Uygulamanın merkezi durumu.
  final AppController controller;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  static const List<_DurationPreset> _presets = <_DurationPreset>[
    _DurationPreset(
      label: 'Klasik',
      focus: 25,
      shortBreak: 5,
      longBreak: 15,
      icon: Icons.timer_outlined,
    ),
    _DurationPreset(
      label: 'Derin çalışma',
      focus: 50,
      shortBreak: 10,
      longBreak: 20,
      icon: Icons.psychology_alt_outlined,
    ),
    _DurationPreset(
      label: 'Hızlı',
      focus: 15,
      shortBreak: 3,
      longBreak: 10,
      icon: Icons.bolt_rounded,
    ),
  ];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _focusController;
  late final TextEditingController _shortBreakController;
  late final TextEditingController _longBreakController;
  late ThemeMode _themeMode;
  bool _isSaving = false;
  bool _isClearing = false;
  bool _isValidatingChain = false;
  bool _isResettingChain = false;

  @override
  void initState() {
    super.initState();
    final settings = widget.controller.settings;
    _focusController = TextEditingController(
      text: '${settings.focusDurationMinutes}',
    );
    _shortBreakController = TextEditingController(
      text: '${settings.shortBreakMinutes}',
    );
    _longBreakController = TextEditingController(
      text: '${settings.longBreakMinutes}',
    );
    _themeMode = settings.themeMode;
  }

  @override
  void dispose() {
    _focusController.dispose();
    _shortBreakController.dispose();
    _longBreakController.dispose();
    super.dispose();
  }

  String? _validateDuration(
    String? rawValue,
    String? Function(int value) rangeValidator,
  ) {
    final parsed = int.tryParse(rawValue?.trim() ?? '');
    if (parsed == null) {
      return 'Lütfen bir tam sayı girin.';
    }
    return rangeValidator(parsed);
  }

  void _applyPreset(_DurationPreset preset) {
    _focusController.text = '${preset.focus}';
    _shortBreakController.text = '${preset.shortBreak}';
    _longBreakController.text = '${preset.longBreak}';
    FocusScope.of(context).unfocus();
  }

  Future<void> _applyThemeMode(ThemeMode mode) async {
    if (mode == _themeMode) {
      return;
    }

    final previous = _themeMode;
    setState(() => _themeMode = mode);

    final saved = await widget.controller.updateSettings(
      widget.controller.settings.copyWith(themeMode: mode),
    );

    if (!mounted) {
      return;
    }
    if (!saved) {
      setState(() => _themeMode = previous);
      showAppSnackBar(
        context,
        widget.controller.lastError ?? 'Tema kaydedilemedi.',
        tone: SnackBarTone.error,
      );
    }
  }

  Future<void> _saveSettings() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() => _isSaving = true);

    final updated = widget.controller.settings.copyWith(
      focusDurationMinutes: int.parse(_focusController.text.trim()),
      shortBreakMinutes: int.parse(_shortBreakController.text.trim()),
      longBreakMinutes: int.parse(_longBreakController.text.trim()),
      themeMode: _themeMode,
    );
    final saved = await widget.controller.updateSettings(updated);

    if (!mounted) {
      return;
    }
    setState(() => _isSaving = false);
    showAppSnackBar(
      context,
      saved
          ? 'Ayarlar kaydedildi.'
          : widget.controller.lastError ?? 'Ayarlar kaydedilemedi.',
      tone: saved ? SnackBarTone.success : SnackBarTone.error,
    );
  }

  Future<void> _validateChain() async {
    setState(() => _isValidatingChain = true);
    final result = await widget.controller.validateChain();
    if (!mounted) {
      return;
    }
    setState(() => _isValidatingChain = false);
    if (result == null) {
      showAppSnackBar(
        context,
        widget.controller.chainError ?? 'Kanıt defteri henüz hazır değil.',
        tone: SnackBarTone.error,
      );
      return;
    }
    showAppSnackBar(
      context,
      result.message,
      tone: result.isValid ? SnackBarTone.success : SnackBarTone.error,
    );
  }

  Future<void> _resetChain() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Kanıt defterini sıfırla'),
          content: const Text(
            'Tüm bloklar, FOCUS bakiyesi ve rozetler silinip genesis bloğuna '
            'dönülecek. Görevler, oturum kayıtları ve cüzdan adresin '
            'korunacak. Bu işlem geri alınamaz.',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Vazgeç'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(dialogContext).colorScheme.error,
                foregroundColor: Theme.of(dialogContext).colorScheme.onError,
              ),
              child: const Text('Sıfırla'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) {
      return;
    }

    setState(() => _isResettingChain = true);
    final reset = await widget.controller.resetChain();
    if (!mounted) {
      return;
    }
    setState(() => _isResettingChain = false);
    showAppSnackBar(
      context,
      reset
          ? 'Kanıt defteri genesis bloğuna sıfırlandı.'
          : widget.controller.chainError ?? 'Kanıt defteri sıfırlanamadı.',
      tone: reset ? SnackBarTone.success : SnackBarTone.error,
    );
  }

  Future<void> _clearAllData() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Tüm verileri temizle'),
          content: const Text(
            'Tüm görevler, oturum kayıtları, FOCUS bakiyesi, bloklar ve '
            'rozetler silinecek. Ayarlar ve cüzdan adresin korunacak. '
            'Bu işlem geri alınamaz.',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Vazgeç'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(dialogContext).colorScheme.error,
                foregroundColor: Theme.of(dialogContext).colorScheme.onError,
              ),
              child: const Text('Temizle'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) {
      return;
    }

    setState(() => _isClearing = true);
    final cleared = await widget.controller.clearAllData();
    if (!mounted) {
      return;
    }
    setState(() => _isClearing = false);
    showAppSnackBar(
      context,
      cleared
          ? 'Görevler ve oturum kayıtları silindi.'
          : widget.controller.lastError ?? 'Veriler silinemedi.',
      tone: cleared ? SnackBarTone.success : SnackBarTone.error,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final chainReady = widget.controller.isChainReady;
    final validation = widget.controller.lastChainValidation;
    final chainStatusColor = !chainReady || validation?.isValid == false
        ? scheme.error
        : scheme.secondary;
    final chainStatusLabel = !chainReady
        ? 'KAPALI'
        : validation == null
        ? 'DOĞRULA'
        : validation.isValid
        ? 'GEÇERLİ'
        : 'HATALI';

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
        systemNavigationBarColor: scheme.surface,
        systemNavigationBarIconBrightness: isDark
            ? Brightness.light
            : Brightness.dark,
      ),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          titleSpacing: 4,
          title: const Text('Ayarlar'),
          leading: IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            tooltip: 'Geri',
            icon: const Icon(Icons.arrow_back_rounded),
          ),
        ),
        body: AppBackground(
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 120),
              children: <Widget>[
                Text(
                  'FocusFlow Proof’u kendi ritmine göre ayarla.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 16),
                _SectionCard(
                  icon: Icons.timer_outlined,
                  title: 'Pomodoro süreleri',
                  subtitle:
                      'Süreler yalnızca yeni başlatılan oturumlara uygulanır.',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'HIZLI BAŞLANGIÇ',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _presets
                            .map(
                              (preset) => ActionChip(
                                onPressed: () => _applyPreset(preset),
                                avatar: Icon(preset.icon, size: 16),
                                label: Text(preset.label),
                              ),
                            )
                            .toList(growable: false),
                      ),
                      const SizedBox(height: 18),
                      TextFormField(
                        controller: _focusController,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(3),
                        ],
                        decoration: const InputDecoration(
                          labelText: 'Odak süresi',
                          suffixText: 'dk',
                          prefixIcon: Icon(Icons.center_focus_strong_outlined),
                          helperText:
                              '${AppSettings.minFocusMinutes}-'
                              '${AppSettings.maxFocusMinutes} dakika',
                        ),
                        validator: (value) => _validateDuration(
                          value,
                          AppSettings.validateFocusMinutes,
                        ),
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _shortBreakController,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(3),
                        ],
                        decoration: const InputDecoration(
                          labelText: 'Kısa mola',
                          suffixText: 'dk',
                          prefixIcon: Icon(Icons.local_cafe_outlined),
                          helperText:
                              '${AppSettings.minShortBreakMinutes}-'
                              '${AppSettings.maxShortBreakMinutes} dakika',
                        ),
                        validator: (value) => _validateDuration(
                          value,
                          AppSettings.validateShortBreakMinutes,
                        ),
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _longBreakController,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(3),
                        ],
                        decoration: const InputDecoration(
                          labelText: 'Uzun mola',
                          suffixText: 'dk',
                          prefixIcon: Icon(Icons.self_improvement_outlined),
                          helperText:
                              '${AppSettings.minLongBreakMinutes}-'
                              '${AppSettings.maxLongBreakMinutes} dakika',
                        ),
                        validator: (value) => _validateDuration(
                          value,
                          AppSettings.validateLongBreakMinutes,
                        ),
                        onFieldSubmitted: (_) {
                          unawaited(_saveSettings());
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                _SectionCard(
                  icon: Icons.palette_outlined,
                  title: 'Görünüm',
                  subtitle: 'Tema seçimi anında uygulanır ve cihazda saklanır.',
                  child: _ThemeSelector(
                    selected: _themeMode,
                    onChanged: (mode) => unawaited(_applyThemeMode(mode)),
                  ),
                ),
                const SizedBox(height: 14),
                _SectionCard(
                  icon: Icons.verified_outlined,
                  title: 'FocusFlow Proof',
                  subtitle:
                      'Yerel FOCUS cüzdanı ve değiştirilemez kanıt defteri.',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: _ProofSettingMetric(
                              label: 'BAKİYE',
                              value:
                                  '${widget.controller.focusBalance} '
                                  '${FocusChainNetwork.tokenSymbol}',
                            ),
                          ),
                          Expanded(
                            child: _ProofSettingMetric(
                              label: 'BLOK',
                              value: '${widget.controller.chainHeight}',
                            ),
                          ),
                          Expanded(
                            child: _ProofSettingMetric(
                              label: 'ROZET',
                              value:
                                  '${widget.controller.mintedAchievements.length}',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.fromLTRB(11, 9, 11, 9),
                        decoration: BoxDecoration(
                          color: scheme.surfaceContainerLow.withValues(
                            alpha: 0.72,
                          ),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: scheme.outlineVariant.withValues(alpha: 0.6),
                          ),
                        ),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.account_balance_wallet_outlined,
                              size: 17,
                              color: scheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 7),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'CÜZDAN ADRESİ',
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: scheme.onSurfaceVariant,
                                      fontSize: 7.5,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.8,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    chainReady
                                        ? shortAddress(
                                            widget.controller.walletAddress,
                                          )
                                        : 'Cüzdan hazır değil',
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      fontFamily: 'monospace',
                                      fontSize: 10,
                                      color: scheme.onSurface,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ChainStatusPill(
                              label: chainStatusLabel,
                              color: chainStatusColor,
                              icon: validation?.isValid == true
                                  ? Icons.verified_rounded
                                  : Icons.shield_outlined,
                            ),
                          ],
                        ),
                      ),
                      if (validation != null) ...<Widget>[
                        const SizedBox(height: 8),
                        Text(
                          validation.message,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: validation.isValid
                                ? scheme.secondary
                                : scheme.error,
                            height: 1.4,
                          ),
                        ),
                      ],
                      const SizedBox(height: 12),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: !chainReady || _isValidatingChain
                                  ? null
                                  : _validateChain,
                              icon: _isValidatingChain
                                  ? const SizedBox(
                                      width: 15,
                                      height: 15,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Icon(
                                      Icons.fact_check_outlined,
                                      size: 17,
                                    ),
                              label: Text(
                                _isValidatingChain ? 'Doğrulanıyor' : 'Doğrula',
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: !chainReady || _isResettingChain
                                  ? null
                                  : _resetChain,
                              icon: _isResettingChain
                                  ? const SizedBox(
                                      width: 15,
                                      height: 15,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Icon(
                                      Icons.restart_alt_rounded,
                                      size: 17,
                                    ),
                              label: Text(
                                _isResettingChain
                                    ? 'Sıfırlanıyor...'
                                    : 'Sıfırla',
                              ),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: scheme.error,
                                side: BorderSide(
                                  color: scheme.error.withValues(alpha: 0.45),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Cüzdan anahtarı yalnızca bu cihazda saklanır. '
                        'FOCUS demo amaçlıdır; gerçek para değeri yoktur.',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                          fontSize: 9,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                _SectionCard(
                  icon: Icons.storage_outlined,
                  title: 'Veriler',
                  subtitle:
                      'Görevler ve oturum kayıtları yalnızca bu cihazda saklanır.',
                  accent: scheme.error,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: scheme.errorContainer.withValues(alpha: 0.45),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Icon(
                              Icons.warning_amber_rounded,
                              color: scheme.error,
                              size: 19,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Tüm görevleri ve oturum geçmişini silmek '
                                'için aşağıdaki seçeneği kullan. Bu işlem '
                                'geri alınamaz.',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: scheme.onErrorContainer,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      OutlinedButton.icon(
                        onPressed: _isClearing ? null : _clearAllData,
                        icon: _isClearing
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(
                                Icons.delete_outline_rounded,
                                size: 18,
                              ),
                        label: Text(
                          _isClearing ? 'Temizleniyor...' : 'Verileri temizle',
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: scheme.error,
                          side: BorderSide(
                            color: scheme.error.withValues(alpha: 0.55),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: scheme.primaryContainer.withValues(alpha: 0.55),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: scheme.outlineVariant.withValues(alpha: 0.55),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: scheme.surfaceContainerLowest.withValues(
                            alpha: 0.55,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.shield_outlined,
                          color: scheme.onPrimaryContainer,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'FocusFlow Proof hesap açmaz, internet bağlantısı '
                          'kullanmaz ve verilerini sunucuya göndermez. Tüm '
                          'bloklar ve cüzdan anahtarı cihazda kalır.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: scheme.onPrimaryContainer,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Center(
                  child: Text(
                    'FocusFlow Proof • Sürüm 2.0.0 (2) • Yerel kanıt defteri',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: scheme.onSurfaceVariant.withValues(alpha: 0.7),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: _SaveBar(
          isSaving: _isSaving,
          onSave: _saveSettings,
        ),
      ),
    );
  }
}

class _ProofSettingMetric extends StatelessWidget {
  const _ProofSettingMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: scheme.onSurfaceVariant,
            fontSize: 7.5,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w800,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}

class _DurationPreset {
  const _DurationPreset({
    required this.label,
    required this.focus,
    required this.shortBreak,
    required this.longBreak,
    required this.icon,
  });

  final String label;
  final int focus;
  final int shortBreak;
  final int longBreak;
  final IconData icon;
}

class _ThemeSelector extends StatelessWidget {
  const _ThemeSelector({required this.selected, required this.onChanged});

  final ThemeMode selected;
  final ValueChanged<ThemeMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: ThemeMode.values
          .map(
            (mode) => Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: mode == ThemeMode.dark ? 0 : 8),
                child: _ThemePreview(
                  mode: mode,
                  selected: selected == mode,
                  onTap: () => onChanged(mode),
                ),
              ),
            ),
          )
          .toList(growable: false),
    );
  }
}

class _ThemePreview extends StatelessWidget {
  const _ThemePreview({
    required this.mode,
    required this.selected,
    required this.onTap,
  });

  final ThemeMode mode;
  final bool selected;
  final VoidCallback onTap;

  String get _label => switch (mode) {
    ThemeMode.system => 'Sistem',
    ThemeMode.light => 'Açık',
    ThemeMode.dark => 'Koyu',
  };

  IconData get _icon => switch (mode) {
    ThemeMode.system => Icons.brightness_auto_rounded,
    ThemeMode.light => Icons.light_mode_rounded,
    ThemeMode.dark => Icons.dark_mode_rounded,
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Semantics(
      selected: selected,
      button: true,
      label: '$_label tema',
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 240),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: selected
                  ? scheme.secondaryContainer.withValues(alpha: 0.5)
                  : scheme.surfaceContainerLow.withValues(alpha: 0.55),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: selected ? scheme.secondary : scheme.outlineVariant,
                width: selected ? 1.8 : 1,
              ),
            ),
            child: Column(
              children: <Widget>[
                _ThemePreviewArt(mode: mode),
                const SizedBox(height: 7),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      _icon,
                      size: 13,
                      color: selected
                          ? scheme.onSecondaryContainer
                          : scheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        _label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: selected
                              ? scheme.onSecondaryContainer
                              : scheme.onSurfaceVariant,
                          fontWeight: selected
                              ? FontWeight.w800
                              : FontWeight.w600,
                          fontSize: 10,
                        ),
                      ),
                    ),
                    if (selected) ...<Widget>[
                      const SizedBox(width: 3),
                      Icon(
                        Icons.check_circle_rounded,
                        size: 13,
                        color: scheme.secondary,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ThemePreviewArt extends StatelessWidget {
  const _ThemePreviewArt({required this.mode});

  final ThemeMode mode;

  @override
  Widget build(BuildContext context) {
    const lightBackground = Color(0xFFF6F3EA);
    const darkBackground = Color(0xFF101E18);
    const lightAccent = Color(0xFF14503B);
    const darkAccent = Color(0xFFA9E5C6);

    final isSystem = mode == ThemeMode.system;
    final background = mode == ThemeMode.dark
        ? darkBackground
        : lightBackground;

    return Container(
      height: 54,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
      ),
      child: isSystem
          ? Row(
              children: <Widget>[
                Expanded(
                  child: _MiniPhone(
                    background: lightBackground,
                    accent: lightAccent,
                    dark: false,
                  ),
                ),
                Expanded(
                  child: _MiniPhone(
                    background: darkBackground,
                    accent: darkAccent,
                    dark: true,
                  ),
                ),
              ],
            )
          : _MiniPhone(
              background: background,
              accent: mode == ThemeMode.dark ? darkAccent : lightAccent,
              dark: mode == ThemeMode.dark,
            ),
    );
  }
}

class _MiniPhone extends StatelessWidget {
  const _MiniPhone({
    required this.background,
    required this.accent,
    required this.dark,
  });

  final Color background;
  final Color accent;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final surface = dark ? const Color(0xFF1A2E25) : const Color(0xFFFFFCF5);
    final muted = dark ? const Color(0xFFA9BBB0) : const Color(0xFF5C6B61);

    return Padding(
      padding: const EdgeInsets.all(7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: accent,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: muted.withValues(alpha: 0.55),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Container(
            height: 15,
            decoration: BoxDecoration(
              color: surface,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: muted.withValues(alpha: 0.25)),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: muted.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Container(
                width: 14,
                height: 4,
                decoration: BoxDecoration(
                  color: accent,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SaveBar extends StatelessWidget {
  const _SaveBar({required this.isSaving, required this.onSave});

  final bool isSaving;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest.withValues(alpha: 0.97),
        border: Border(
          top: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.7)),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: scheme.shadow.withValues(
              alpha: theme.brightness == Brightness.dark ? 0.3 : 0.06,
            ),
            blurRadius: 24,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        minimum: const EdgeInsets.fromLTRB(20, 12, 20, 12),
        child: SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: isSaving ? null : onSave,
            icon: isSaving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.save_outlined, size: 19),
            label: Text(isSaving ? 'Kaydediliyor...' : 'Ayarları kaydet'),
          ),
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.icon,
    required this.title,
    required this.child,
    this.subtitle,
    this.accent,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget child;
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final effectiveAccent = accent ?? scheme.secondary;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: scheme.outlineVariant.withValues(alpha: 0.72),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: scheme.shadow.withValues(
              alpha: theme.brightness == Brightness.dark ? 0.18 : 0.035,
            ),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: effectiveAccent.withValues(alpha: 0.13),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(icon, color: effectiveAccent, size: 21),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(title, style: theme.textTheme.titleMedium),
                    if (subtitle != null) ...<Widget>[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}
