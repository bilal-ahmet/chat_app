
import 'package:shared_preferences/shared_preferences.dart';

class HelperFunction{

  //keys

  static String userLoggedInKey = "LOGGEDINKEY";
  static String userNameKey = "USERNAMEKEY";
  static String userEmailKey = "USEREMAİLKEY";


  // saving the data to SF


  // getting the data from SF

  static Future<bool?> getUserLoggedInStatus() async{
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(userLoggedInKey);
  }
}