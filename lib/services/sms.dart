import 'package:http/http.dart';

class Sms {

  final String number;
  final String message;
  Sms({this.number, this.message});

  String url = 'http://cheapglobalsms.com/api_v1';
  String subAccount = '2673_access';
  String subAccountPass = 'rayjowa001';

  Future<Response> sendSms() async {
    return await post(
      url,
      body: {
        "sub_account": subAccount,
        "sub_account_pass": subAccountPass,
        "action": "send_sms",
        "message": message,
        "recipients": number
      }
    );
  }
}