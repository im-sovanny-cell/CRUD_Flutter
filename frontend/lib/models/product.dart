class Product {
  final int? productId;
  final String productName;
  final double price;
  final int stock;

  Product({
    this.productId,
    required this.productName,
    required this.price,
    required this.stock,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productId: json['PRODUCTID'],
      productName: json['PRODUCTNAME'],
      price: double.parse(json['PRICE'].toString()),
      stock: json['STOCK'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'PRODUCTID': productId,
      'PRODUCTNAME': productName,
      'PRICE': price,
      'STOCK': stock,
    };
  }
}
