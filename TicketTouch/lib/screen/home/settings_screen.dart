import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SettingsList(
          sections: [
            // START COMMON
            SettingsSection(
              title: const Text('Common'),
              tiles: [
                SettingsTile.navigation(
                  title: const Text('Language'),
                  description: const Text('English'),
                  leading: const Icon(Icons.language),
                  onPressed: (BuildContext context) {},
                ),
                SettingsTile.switchTile(
                  title: const Text('Dark Theme'),
                  description: const Text('Activate Dark Theme'),
                  leading: const Icon(Icons.format_paint),
                  activeSwitchColor: const Color(0xFF00a9ce),
                  initialValue: false,
                  onToggle: (value) {
                    setState(() {

                    });
                  },
                ),
              ],
            ),

            // Security
            SettingsSection(
              title: const Text('Security'),
              tiles: [
                SettingsTile(
                  title: const Text('Security'),
                  description: const Text('Fingerprint'),
                  leading: const Icon(Icons.lock),
                  onPressed: (BuildContext context) {},
                ),
                SettingsTile.switchTile(
                  title: const Text('Use fingerprint'),
                  leading: const Icon(Icons.fingerprint),
                  initialValue: true,
                  onToggle: (value) {},
                ),
              ],
            ),
          ],
          // END COMMON
        ),
      ),
    );
  }
}
