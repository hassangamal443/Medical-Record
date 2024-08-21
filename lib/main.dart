import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:personal_medical_record/providers/locale_provider.dart';
import 'package:personal_medical_record/screens/login_screen.dart';
import 'package:personal_medical_record/screens/splash_screen2.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AwesomeNotifications().initialize(
    null, // icon for your app notification
    [
      NotificationChannel(
        channelKey: 'key1',
        channelName: 'Proto Coders Point',
        channelDescription: "Notification example",
        defaultColor: Color(0XFF9050DD),
        ledColor: Colors.white,
        playSound: true,
        enableLights: true,
        enableVibration: true,
      )
    ],
  );

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  LocaleProvider localeProvider = LocaleProvider();
  await localeProvider.init();
  runApp(MyApp(localeProvider: localeProvider));
}

class MyApp extends StatelessWidget {
  final LocaleProvider localeProvider;
  const MyApp({Key? key, required this.localeProvider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: localeProvider, // Use the passed localeProvider here
      child: Consumer<LocaleProvider>(
        builder: (context, localeProvider, child) {
          return WillPopScope(
            onWillPop: () async {
              // This method is called when the back button is pressed.
              // You can handle the logic here.
              // Return true to allow the app to close, return false to show the "Press again to exit" message.
              bool closeApp = false;
              if (!closeApp) {
                // Show a snackbar or a dialog to inform the user to press again to exit.
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Press again to exit'),
                    duration: Duration(seconds: 2),
                  ),
                );
                // Return false to prevent the app from closing.
                return false;
              } else {
                // Return true to allow the app to close.
                return true;
              }
            },
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                primaryIconTheme: IconThemeData(color: Colors.white),
                primaryColor: Colors.indigo,
              ),
              localizationsDelegates: [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: [
                Locale('en'),
                Locale('ar'),
              ],
              locale: localeProvider.locale,
              title: 'personal medical record',
              home: StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      return SplashScreen();
                    } else if (snapshot.hasError) {
                      return Center(child: Text('${snapshot.error}'));
                    }
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Colors.indigoAccent,
                      ),
                    );
                  }
                  return LoginScreen();
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

// Notification handling logic
void handleReceivedNotification(RemoteMessage message) {
  // Check if the notification payload contains the user ID
  if (message.data.containsKey('userId')) {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    String notificationUserId = message.data['userId'];

    // Compare the user ID in the payload with the current user's ID
    if (userId == notificationUserId) {
      // Create a notification content object
      NotificationContent notificationContent = NotificationContent(
        id: message.data['id'], // Assuming 'id' is part of your notification data
        channelKey: message.data['channelKey'], // Assuming 'channelKey' is part of your notification data
        title: message.data['title'], // Assuming 'title' is part of your notification data
        body: message.data['body'], // Assuming 'body' is part of your notification data
        payload: message.data['payload'], // Assuming 'payload' is part of your notification data
        // Add other properties as needed
      );

      // Show the notification only if it matches the current user's ID
      AwesomeNotifications().createNotification(
        content: notificationContent,
      );
    } else {
      print('Notification not intended for the current user. Ignoring...');
    }
  } else {
    print('Notification payload does not contain user ID. Ignoring...');
  }
}


