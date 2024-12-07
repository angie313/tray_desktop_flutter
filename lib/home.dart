import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tray_desktop/main.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';

class Tray extends StatefulWidget {
  const Tray({super.key});

  @override
  TrayState createState() => TrayState();
}

class TrayState extends State<Tray> with TrayListener, WindowListener {
  Menu? menu;
  late bool _showHome;

  @override
  void initState() {
    trayManager.addListener(this);
    windowManager.addListener(this);
    _init();
    super.initState();
  }

  void _init() async {
    _showHome = false;
  }

  @override
  void onWindowClose() {
    setState(() {
      _showHome = false;
    });
    super.onWindowClose();
  }

  void _showWindow(bool setMaximize) async {
    setMaximize
        ? await windowManager.maximize()
        : await windowManager.unmaximize();
    await windowManager.show();
  }

  @override
  void dispose() {
    trayManager.removeListener(this);
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
   if (_showHome) {
      _showWindow(false); // show window, set maximize = false
      return const MyApp();
    }
    windowManager.hide();
    return const SizedBox.shrink();
  }

  @override
  void onTrayIconMouseDown() async {
    await trayManager.popUpContextMenu();
  }

  @override
  void onTrayMenuItemClick(MenuItem menuItem) {
    if (menuItem.key == 'home') {
      setState(() {
        _showHome = true;
      });
    } else if (menuItem.key == 'exit') {
      exit(0);
    }
  }
}

Future<void> setTrayMenu() async {
  Menu menu = Menu(
    items: [
      MenuItem(
        key: 'home',
        label: 'Home',
      ),
      MenuItem(
        key: 'exit',
        label: 'Exit App',
      ),
    ],
  );
  await trayManager.setContextMenu(menu);
}

Future<void> setTrayIcon() async {
  await trayManager.setIcon(
    Platform.isWindows
        ? 'assets/test-icon.ico'
        : 'assets/test-icon.ico',
  );
}