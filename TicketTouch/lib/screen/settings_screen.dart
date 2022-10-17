import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutterfire_cli/version.g.dart';
import 'package:settings_ui/settings_ui.dart';

import 'package:theme_mode_handler/theme_picker_dialog.dart';import 'package:tickettouch/theme/theme_constants.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

bool isDarkTheme = false;
bool isUseFingerprint = true;

class _SettingsScreenState extends State<SettingsScreen> {

  @override
  Widget build(BuildContext context) {

    setSystemUiOverlayStyle();

    return Scaffold(
      body: SafeArea(
        child: SettingsList(
          sections: [
            // START COMMON
            SettingsSection(
              title: const Text('Common',
                  style: TextStyle(
                    color: Color(0xFF00a9ce),
                  )),
              tiles: [
                SettingsTile.navigation(
                  title: const Text('Language'),
                  description: const Text('English'),
                  leading: const Icon(Icons.language),
                  enabled: true,
                  onPressed: (BuildContext context) {},
                ),
                SettingsTile.navigation(
                  title: const Text('Dark Theme'),
                  description: const Text('Activate Dark Theme'),
                  leading: const Icon(Icons.format_paint),
                  onPressed: (value) {
                    showThemePickerDialog(context: context);
                    setState(() {
                      isDarkTheme = !isDarkTheme;
                    });
                  },
                ),
              ],
            ),

            // Security
            SettingsSection(
              title: const Text('Security',
                  style: TextStyle(
                    color: Color(0xFF00a9ce),
                  )),
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
                  activeSwitchColor: const Color(0xFF00a9ce),
                  initialValue: isUseFingerprint,
                  onToggle: (value) {
                    setState(() {
                      isUseFingerprint = !isUseFingerprint;
                    });
                  },
                ),
              ],
            ),
            // Security
            SettingsSection(
              title: const Text('About',
                  style: TextStyle(
                    color: Color(0xFF00a9ce),
                  )),
              tiles: [
                SettingsTile(
                  title: const Text('About'),
                  leading: const Icon(Icons.auto_fix_high),
                  onPressed: (BuildContext context) {
                    showAboutDialog(
                        context: context,
                        applicationName: 'TicketTouch',
                        applicationVersion: cliVersion,
                        applicationLegalese: Platform.version,
                        applicationIcon: Image.asset(
                          'assets/logos/1024.png',
                          width: 110,
                          height: 110,
                        ));
                  },
                ),
                SettingsTile(
                  title: const Text('Licenses'),
                  leading: const Icon(Icons.local_police_outlined),
                  onPressed: (BuildContext context) {
                    showLicensePage(
                        context: context,
                        applicationName: 'TicketTouch',
                        applicationVersion: cliVersion,
                        applicationLegalese: Platform.version,
                        applicationIcon: Image.asset(
                          'assets/logos/1024.png',
                          width: 110,
                          height: 110,
                        ));
                  },
                ),
                SettingsTile(
                  title: const Text('Re'),
                  leading: const Icon(Icons.local_police_outlined),
                  onPressed: (BuildContext context) {
                    showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(DateTime(2022)));
                  }
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
