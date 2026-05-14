class OrderSubmissionResponse {
  String? orderId;

  OrderSubmissionResponse({
    this.orderId,
  });

  // Creates an instance from a Map (useful for API responses)
  factory OrderSubmissionResponse.fromJson(Map<String, dynamic> json) {
    return OrderSubmissionResponse(
      orderId: json['order_id'] as String?,
    );
  }

  // Converts the instance back to a Map
  Map<String, dynamic> toJson() {
    return {
      'order_id': orderId,
    };
  }
}