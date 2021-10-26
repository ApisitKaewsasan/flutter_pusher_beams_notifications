
class RemoteMessage {
  String? body;
  String? clickAction;
  bool? defaultLightSettings;
  bool? defaultSound;
  bool? defaultVibrateTimings;
  bool? localOnly;
  bool? sticky;
  String? title;
  String? icon;

  RemoteMessage(
      {this.body,
        this.clickAction,
        this.defaultLightSettings,
        this.defaultSound,
        this.defaultVibrateTimings,
        this.localOnly,
        this.sticky,
        this.title,
        this.icon});

  RemoteMessage.fromJson(Map<String, dynamic> json) {
    body = json['body'];
    clickAction = json['clickAction'];
    defaultLightSettings = json['defaultLightSettings'];
    defaultSound = json['defaultSound'];
    defaultVibrateTimings = json['defaultVibrateTimings'];
    localOnly = json['localOnly'];
    sticky = json['sticky'];
    title = json['title'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['body'] = this.body;
    data['clickAction'] = this.clickAction;
    data['defaultLightSettings'] = this.defaultLightSettings;
    data['defaultSound'] = this.defaultSound;
    data['defaultVibrateTimings'] = this.defaultVibrateTimings;
    data['localOnly'] = this.localOnly;
    data['sticky'] = this.sticky;
    data['title'] = this.title;
    data['icon'] = this.icon;
    return data;
  }
}

