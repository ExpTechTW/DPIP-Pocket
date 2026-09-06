import 'package:dpip/core/settings/setting_keys.dart';
import 'package:dpip/core/settings/settings_store.dart';
import 'package:flutter/foundation.dart';

/// Whether the visible seismic monitor speaks the estimated intensity before
/// the EEW warning sound plays, persisted via [SettingsStore]. **On** by
/// default: the announcement is what buys the seconds between the alert and
/// the shaking, so a user who wants silence opts out rather than in.
///
/// Turning it off never delays a warning. The monitor drops its announcement
/// controller to inactive, which releases anything the foreground gate is
/// holding, so the channel's own sound plays exactly as it did before this
/// feature existed.
class EewSpokenAnnouncementSettings extends ChangeNotifier {
  EewSpokenAnnouncementSettings(this._settings);

  final SettingsStore _settings;

  /// Whether the foreground monitor may speak.
  bool get enabled =>
      _settings.getBool(SettingKeys.eewSpokenAnnouncement) ?? true;

  Future<void> setEnabled(bool value) async {
    await _settings.setBool(SettingKeys.eewSpokenAnnouncement, value);
    notifyListeners();
  }
}
