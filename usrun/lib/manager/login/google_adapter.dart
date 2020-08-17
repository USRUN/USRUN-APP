import 'package:google_sign_in/google_sign_in.dart';
import 'package:usrun/core/define.dart';
import 'package:usrun/manager/login/login_adapter.dart';

class GoogleLoginAdapter extends LoginAdapter{
  GoogleSignInAccount currentUser;
  String token;
  String idToken;

  final GoogleSignIn google = GoogleSignIn();

  Future<Map<String, dynamic>> login(Map params) async {
    if (await google.isSignedIn() == false) {
      try {
        currentUser = await google.signIn();
        token = (await currentUser.authentication).accessToken;
        idToken = (await currentUser.authentication).idToken;

      }
      catch (error) {
        print(error);
      }

      if (currentUser != null) {
        return _generateLoginParams();
      }
      else {
        return null;
      }
    }
    else {
      currentUser = await google.signInSilently();
      token = (await currentUser.authentication).accessToken;
      return _generateLoginParams();
    }
  }

  Future logout() async {
    currentUser = null;
    token = null;
    google.signOut();
  }

  Future<Map<String, String>> _generateLoginParams() async{
    Map<String, String> res = {
      "type": LoginChannel.Google.index.toString(),
      "token": '$token'
    };

    saveOpenData(LoginChannel.Google, res);

    return res;
  }
}