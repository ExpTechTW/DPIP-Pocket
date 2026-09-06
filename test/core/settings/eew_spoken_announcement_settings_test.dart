/// The monitor's spoken-announcement switch.
///
/// The default is the whole point of these tests: an EEW announcement that
/// silently defaults to off is a feature nobody ever hears, and the failure
/// looks exactly like a broken TTS engine.
library;

import 'package:dpip/core/settings/eew_spoken_announcement_settings.dart';
import 'package:dpip/core/settings/setting_keys.dart';
import 'package:dpip/core/settings/settings_store.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('defaults to on when nothing was ever saved', () {
    final settings = EewSpokenAnnouncementSettings(SettingsStore.inMemory());
    expect(settings.enabled, isTrue);
  });

  test('reads back what was saved, in both directions', () async {
    final store = SettingsStore.inMemory();
    final settings = EewSpokenAnnouncementSettings(store);

    await settings.setEnabled(false);
    expect(settings.enabled, isFalse);
    expect(store.getBool(SettingKeys.eewSpokenAnnouncement), isFalse);

    await settings.setEnabled(true);
    expect(settings.enabled, isTrue);
  });

  test('a saved value survives a new instance over the same store', () async {
    final store = SettingsStore.inMemory();
    await EewSpokenAnnouncementSettings(store).setEnabled(false);
    expect(EewSpokenAnnouncementSettings(store).enabled, isFalse);
  });

  test('notifies listeners so the monitor re-reads it mid-alert', () async {
    final settings = EewSpokenAnnouncementSettings(SettingsStore.inMemory());
    var notifications = 0;
    settings.addListener(() => notifications++);

    await settings.setEnabled(false);
    await settings.setEnabled(true);

    expect(notifications, 2);
  });
}
