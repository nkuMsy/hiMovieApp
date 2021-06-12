class FriendmodelEntity {
	List<FriendmodelData> data;

	FriendmodelEntity({this.data});

	FriendmodelEntity.fromJson(dynamic json) {
		print(json);
		if (json != null) {
			data = new List<FriendmodelData>();
			(json as List).forEach((v) {
				data.add(new FriendmodelData.fromJson(v));
				print("hh");
			});
		}
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		if (this.data != null) {
      data['data'] =  this.data.map((v) => v.toJson()).toList();
    }
		return data;
	}
}

class FriendmodelData {
	String username;
	String date;
	String review;

	FriendmodelData({this.username, this.date, this.review});

	FriendmodelData.fromJson(Map<String, dynamic> json) {
		username = json['username'];
		date = json['date'];
		review = json['review'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['username'] = this.username;
		data['date'] = this.date;
		data['date'] = this.date;
		return data;
	}
}
