// Imports the Flutter Driver API.
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Registration', () {
    // First, define the Finders and use them to locate widgets from the
    // test suite. Note: the Strings provided to the `byValueKey` method must
    // be the same as the Strings we used for the Keys in step 1.
    //final lableSignIn = find.byValueKey('lableSignIn');
    final titleSignIn = find.byValueKey('titleSignIn');
    final textFormEmail = find.byValueKey('textFormEmail');
    final textFormPass = find.byValueKey('textFormPass');
    final buttonSubmit = find.byValueKey('buttonSubmit');

    FlutterDriver driver;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      if (driver != null) {
        driver.close();
        print(
            " -----------------------REGISTER COMPLETED---------------------");
      }
    });

    // test('starts at 0', () async {
    //   // Use the `driver.getText` method to verify the counter starts at 0.
    //   expect(await driver.getText(lableSignIn), "Sign In");
    // });
    test('Title check', () async {
      // Use the `driver.getText` method to verify the counter starts at 0.
      expect(await driver.getText(titleSignIn), "Sign up to app");
    });
    test('Check errors messages', () async {
      await driver.tap(buttonSubmit);
      await driver.waitFor(find.text('Enter an email'));
      await driver.waitFor(find.text('Password must 6+ characters'));
    });

    test('set email', () async {
      await driver.tap(textFormEmail);
      await driver.enterText("email");
      await driver.waitFor(find.text('email'));
    });
    test('set pass', () async {
      await driver.tap(textFormPass);
      await driver.enterText("123pass");
      await driver.waitFor(find.text('123pass'));
    });
  });

  group('SignIn', () {
    final titleSignIn = find.byValueKey('title');
    final buttonSignInScreen = find.byValueKey('lableSignIn');
    final textFormEmail = find.byValueKey('textFormEmailS');
    final textFormPass = find.byValueKey('textFormPass');
    final buttonSubmit = find.byValueKey('buttonSubmitS');

    FlutterDriver driver;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('SignIn Screen button tapping', () async {
      await driver.tap(buttonSignInScreen);
    });
    test('Title check', () async {
      expect(await driver.getText(titleSignIn), "Sign in to app");
    });
    test('Check errors messages', () async {
      await driver.tap(buttonSubmit);
      await driver.waitFor(find.text('Enter an email'));
      await driver.waitFor(find.text('Password must 6+ characters'));
    });

    test('set email', () async {
      await driver.tap(textFormEmail);
      await driver.enterText("email");
      await driver.waitFor(find.text('email'));
    });
    test('set pass', () async {
      await driver.tap(textFormPass);
      await driver.enterText("pass");
      await driver.waitFor(find.text('pass'));
    });
    test('Check errors messages with credentioal', () async {
      await driver.tap(buttonSubmit);
      await driver.waitFor(find.text('Password must 6+ characters'));
    });
    test('set correct pass', () async {
      await driver.tap(textFormPass);
      await driver.enterText("password");
      await driver.waitFor(find.text('password'));
    });
    test('Check errors messages with wrong credentials', () async {
      await driver.tap(buttonSubmit);
      await driver
          .waitFor(find.text('could not signIn with those credentials'));
    });
    test('set email tt', () async {
      await driver.tap(textFormEmail);
      await driver.enterText("tt@ya.ru");
      await driver.waitFor(find.text('tt@ya.ru'));
    });
    test('set correct pass 123', () async {
      await driver.tap(textFormPass);
      await driver.enterText("123456");
      await driver.waitFor(find.text('123456'));
    });
    test('Check correct signin', () async {
      await driver.tap(buttonSubmit);
      await driver
          .waitFor(find.text('Main screen'));
    });
  });
}
