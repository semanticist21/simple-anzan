import 'dart:async';

class LoadingStream {
  static StreamController isLoadingStream = StreamController<bool>()..add(true);
}
