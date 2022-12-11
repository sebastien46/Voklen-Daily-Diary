import 'package:daily_diary/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  static const padding = EdgeInsets.only(bottom: 12);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            Padding(padding: padding, child: ThemeSetting()),
            Padding(padding: padding, child: FontSetting()),
            const Padding(padding: padding, child: ColorSetting()),
          ],
        ),
      ),
    );
  }
}

class ThemeSetting extends StatefulWidget {
  ThemeSetting({super.key});

  List<bool> _selections = _getTheme();

  static List<bool> _getTheme() {
    switch (App.settingsNotifier.value.theme) {
      case ThemeMode.light:
        return [true, false, false];
      case ThemeMode.system:
        return [false, true, false];
      case ThemeMode.dark:
        return [false, false, true];
    }
  }

  @override
  State<ThemeSetting> createState() => _ThemeSettingState();
}

class _ThemeSettingState extends State<ThemeSetting> {
  _setTheme(int index) {
    switch (index) {
      case 0:
        App.settingsNotifier.setTheme(ThemeMode.light);
        break;
      case 1:
        App.settingsNotifier.setTheme(ThemeMode.system);
        break;
      case 2:
        App.settingsNotifier.setTheme(ThemeMode.dark);
        break;
    }
    App.settings.setTheme(App.settingsNotifier.value.theme);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "Theme:",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(width: 5),
        ToggleButtons(
          isSelected: widget._selections,
          onPressed: (int index) {
            widget._selections = [false, false, false];
            setState(() {
              widget._selections[index] = true;
            });
            _setTheme(index);
          },
          renderBorder: false,
          borderRadius: BorderRadius.circular(8),
          children: const [
            Text('Light'),
            Text('System'),
            Text('Dark'),
          ],
        ),
      ],
    );
  }
}

class FontSetting extends StatelessWidget {
  FontSetting({super.key});

  final _fontSizeController = TextEditingController(
    text: App.settingsNotifier.value.fontSize.toString(),
  );

  _setFontSize(String fontSizeString) {
    try {
      final fontSize = double.parse(fontSizeString);
      App.settingsNotifier.setFontSize(fontSize);
      App.settings.setFontSize(fontSize);
    } on FormatException {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "Font size:",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(width: 5),
        SizedBox(
          width: 48,
          height: 24,
          child: TextField(
            controller: _fontSizeController,
            onChanged: _setFontSize,
            keyboardType: TextInputType.number,
          ),
        ),
      ],
    );
  }
}

class ColorSetting extends StatelessWidget {
  const ColorSetting({super.key});

  _setColorScheme(Color colorScheme) {
    App.settings.setColorScheme(colorScheme);
    App.settingsNotifier.setColorScheme(colorScheme);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "App color scheme:",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ColorPicker(
            pickerColor: App.settingsNotifier.value.colorScheme,
            onColorChanged: _setColorScheme,
            enableAlpha: false,
            colorPickerWidth: 250,
          ),
        ),
      ],
    );
  }
}
