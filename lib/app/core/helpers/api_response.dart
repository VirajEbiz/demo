class APIResponse {
  String message;
  dynamic data;
  dynamic status;
  dynamic code;
  dynamic total_pages;
  dynamic current_page;
  dynamic total_items;
  int? notificationCount;

  APIResponse(
      {required this.message,
      this.data,
      this.status,
      this.code,
      this.total_pages,
      this.current_page,
      this.notificationCount,
      this.total_items});

  factory APIResponse.fromJson(Map<String, dynamic> json) {
    return APIResponse(
      message: json['message'] as String,
      data: json['data'] != null ? json['data'] : "s",
      status: json['status'],
      code: json['code'],
      total_pages: json['total_pages'],
      current_page: json['current_page'],
      total_items: json['total_items'] as String?,
      notificationCount: json['notif_unread_count'] ?? 0,
    );
  }
}
