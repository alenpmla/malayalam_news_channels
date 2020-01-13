class ChannelItem {
  String imageurl;
  String name;
  String sourceUrl;

  ChannelItem({this.imageurl, this.name, this.sourceUrl});

  factory ChannelItem.fromJson(Map<String, dynamic> json) {
    return ChannelItem(
      imageurl: json["image_url"] as String,
      name: json["name"] as String,
      sourceUrl: json["source_url"] as String,
    );
  }
}
