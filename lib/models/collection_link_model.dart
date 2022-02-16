/// @Author: cuishuxiang
/// @Date: 2022/2/16 5:08 下午
/// @Description: 收藏链接

class CollectionLinkModel {
  List<CollectionLinkData>? data;
  int? errorCode;
  String? errorMsg;

  CollectionLinkModel({this.data, this.errorCode, this.errorMsg});

  CollectionLinkModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <CollectionLinkData>[];
      json['data'].forEach((v) {
        data!.add(CollectionLinkData.fromJson(v));
      });
    }
    errorCode = json['errorCode'];
    errorMsg = json['errorMsg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['errorCode'] = this.errorCode;
    data['errorMsg'] = this.errorMsg;
    return data;
  }
}

class CollectionLinkData {
  String? desc;
  String? icon;
  int? id;
  String? link;
  String? name;
  int? order;
  int? userId;
  int? visible;

  CollectionLinkData(
      {this.desc,
      this.icon,
      this.id,
      this.link,
      this.name,
      this.order,
      this.userId,
      this.visible});

  CollectionLinkData.fromJson(Map<String, dynamic> json) {
    desc = json['desc'];
    icon = json['icon'];
    id = json['id'];
    link = json['link'];
    name = json['name'];
    order = json['order'];
    userId = json['userId'];
    visible = json['visible'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['desc'] = this.desc;
    data['icon'] = this.icon;
    data['id'] = this.id;
    data['link'] = this.link;
    data['name'] = this.name;
    data['order'] = this.order;
    data['userId'] = this.userId;
    data['visible'] = this.visible;
    return data;
  }
}
