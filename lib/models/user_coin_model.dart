/// @Author: cuishuxiang
/// @Date: 2022/2/11 5:27 下午
/// @Description:
class UserCoinModel {
  UserCoinData? data;
  int? errorCode;
  String? errorMsg;

  UserCoinModel({this.data, this.errorCode, this.errorMsg});

  UserCoinModel.fromJson(Map<String, dynamic> json) {
    data =
        json['data'] != null ? new UserCoinData.fromJson(json['data']) : null;
    errorCode = json['errorCode'];
    errorMsg = json['errorMsg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['errorCode'] = this.errorCode;
    data['errorMsg'] = this.errorMsg;
    return data;
  }
}

class UserCoinData {
  int? coinCount;
  int? level;
  String? nickname;
  String? rank;
  int? userId;
  String? username;

  UserCoinData(
      {this.coinCount,
      this.level,
      this.nickname,
      this.rank,
      this.userId,
      this.username});

  UserCoinData.fromJson(Map<String, dynamic> json) {
    coinCount = json['coinCount'];
    level = json['level'];
    nickname = json['nickname'];
    rank = json['rank'];
    userId = json['userId'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['coinCount'] = this.coinCount;
    data['level'] = this.level;
    data['nickname'] = this.nickname;
    data['rank'] = this.rank;
    data['userId'] = this.userId;
    data['username'] = this.username;
    return data;
  }
}
