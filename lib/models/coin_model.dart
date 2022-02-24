/// @Author: cuishuxiang
/// @Date: 2022/2/24 10:32 上午
/// @Description:
class CoinModel {
  CoinData? data;

  CoinModel({this.data});

  CoinModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? CoinData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class CoinData {
  int? curPage;
  List<CoinItemData>? datas;
  int? offset;
  bool? over;
  int? pageCount;
  int? size;
  int? total;

  CoinData(
      {this.curPage,
      this.datas,
      this.offset,
      this.over,
      this.pageCount,
      this.size,
      this.total});

  CoinData.fromJson(Map<String, dynamic> json) {
    curPage = json['curPage'];
    if (json['datas'] != null) {
      datas = <CoinItemData>[];
      json['datas'].forEach((v) {
        datas!.add(CoinItemData.fromJson(v));
      });
    }
    offset = json['offset'];
    over = json['over'];
    pageCount = json['pageCount'];
    size = json['size'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['curPage'] = this.curPage;
    if (this.datas != null) {
      data['datas'] = this.datas!.map((v) => v.toJson()).toList();
    }
    data['offset'] = this.offset;
    data['over'] = this.over;
    data['pageCount'] = this.pageCount;
    data['size'] = this.size;
    data['total'] = this.total;
    return data;
  }
}

class CoinItemData {
  int? coinCount;
  int? date;
  String? desc;
  int? id;
  String? reason;
  int? type;
  int? userId;
  String? userName;

  CoinItemData(
      {this.coinCount,
      this.date,
      this.desc,
      this.id,
      this.reason,
      this.type,
      this.userId,
      this.userName});

  CoinItemData.fromJson(Map<String, dynamic> json) {
    coinCount = json['coinCount'];
    date = json['date'];
    desc = json['desc'];
    id = json['id'];
    reason = json['reason'];
    type = json['type'];
    userId = json['userId'];
    userName = json['userName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['coinCount'] = this.coinCount;
    data['date'] = this.date;
    data['desc'] = this.desc;
    data['id'] = this.id;
    data['reason'] = this.reason;
    data['type'] = this.type;
    data['userId'] = this.userId;
    data['userName'] = this.userName;
    return data;
  }
}
