class FoodItemModel {
  final String foodItemId;
  final String foodTitle;
  final String foodImgPath;
  final int foodPrice;
  final bool isAvailable;
  final String sellerId;

  FoodItemModel({
    this.foodItemId,
    this.foodTitle,
    this.foodImgPath,
    this.foodPrice,
    this.isAvailable,
    this.sellerId,
  });
}
