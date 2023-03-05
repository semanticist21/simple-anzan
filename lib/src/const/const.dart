// routers
const String mainPageAddress = '/';
const String settingsPageAddress = 'settings';
const String errorPageAddress = 'error';

// labels
const String homeLabel = 'Home';
const String settingLabel = 'Settings';

// button strings
const String start = 'Start !';
const String hidden = '';
const String check = 'Check Answer';

// error page strings
const String error = 'The page you requested does not exist.';

// otehr
const String empty = '';
const String defaultFontFamily = 'Consolas';

class MySingleton {
  static final MySingleton _instance = MySingleton._internal();

  factory MySingleton() {
    return _instance;
  }

  MySingleton._internal();

  void doSomething() {
    print('Doing something...');
  }
}
