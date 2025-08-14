class Message {
  int? postId;
  int? id;
  String? name;
  String? email;
  String? body;
 DateTime? time;

  Message({this.postId, this.id, this.name, this.email, this.body, this.time,});

  Message.fromJson(Map<String, dynamic> json) {
    postId = json['postId'];
    id = json['id'];
    name = json['name'];
    email = json['email'];
    body = json['body'];
    time = DateTime.now();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['postId'] = postId;
    data['id'] =  id;
    data['name'] = name;
    data['email'] = email;
    data['body'] = body;
    data['time'] = time!.toIso8601String();
    return data;
  }
}