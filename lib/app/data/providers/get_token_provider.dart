import 'package:get/get.dart';
import 'package:mario/app/constant/constants.dart';
import 'package:mario/app/data/models/save_token_model.dart';

import '../models/get_token_model.dart';

class GetTokenProvider extends GetConnect {
  Future<Response<GetToken>> getXtoken() async =>
      await get('$webUrl/Api_ws/token',
          headers: {'x-username': 'priorita', 'x-password': 'Mmjkt2024!'},
          contentType: content_type, decoder: (map) {
        print("res Xtoken $map");
        return GetToken.fromJson(map);
      });

  Future<Response<SaveToken>> saveToken(
          {required noHp,
          required tokenFcm,
          required cookies,
          required xToken}) async =>
      await post('$webUrl/Api_ws/save_token_notif',
          {'no_hp': noHp, 'token_fcm': tokenFcm, 'key_cookie': cookies},
          headers: {'x-token': xToken},
          contentType: content_type, decoder: (map) {
        print("res saveToken $map");
        return SaveToken.fromJson(map);
      });
}
