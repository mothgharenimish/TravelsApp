/// Holds the logged-in user's details for the duration of the app session.
/// Populated once after a successful login, read anywhere a booking or
/// authenticated request needs the current user's identity.
class CurrentUser {
  static String userid = "";
  static String name = "";
  static String emailid = "";
  static String mobilenumber = "";

  static void setUser({
    required String userid,
    required String name,
    required String emailid,
    required String mobilenumber,
  }) {
    CurrentUser.userid = userid;
    CurrentUser.name = name;
    CurrentUser.emailid = emailid;
    CurrentUser.mobilenumber = mobilenumber;
  }

  static bool get isLoggedIn => userid.isNotEmpty;

  static void clear() {
    userid = "";
    name = "";
    emailid = "";
    mobilenumber = "";
  }
}