class ProductRating {
  late String userId;
  late double rating;
  late DateTime ratingTime;

  ProductRating(
      {required this.userId, required this.rating, required this.ratingTime});

  ProductRating.fromJson(Map<String, dynamic> data) {
    userId = data['user_id'];
    rating = data['rating'];
    ratingTime = data['rating_time'].toDate();
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': this.userId,
      'rating': this.rating,
      'rating_time': this.ratingTime
    };
  }
}
