import 'package:abacus_simple_anzan/src/settings/option/sound_option.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class ExitWatcher extends StatefulWidget {
  const ExitWatcher({super.key, required this.item});
  final Widget item;

  @override
  State<ExitWatcher> createState() => _ExitWatcherState();
}

class _ExitWatcherState extends State<ExitWatcher> with WindowListener {
  @override
  void initState() {
    windowManager.addListener(this);
    super.initState();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    SoundOptionHandler.audioAndroidPlayer.dispose();
    SoundOptionHandler.audioAndroidPlayer2.dispose();
    SoundOptionHandler.audioplayer.dispose();
    SoundOptionHandler.countplayerOld.dispose();
    super.dispose();
  }

  @override
  void onWindowClose() {
    super.onWindowClose();
    SoundOptionHandler.audioAndroidPlayer.dispose();
    SoundOptionHandler.audioAndroidPlayer2.dispose();
    SoundOptionHandler.audioplayer.dispose();
    SoundOptionHandler.countplayerOld.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.item;
  }
}
