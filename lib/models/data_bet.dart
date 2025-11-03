/// A data class representing all information related to
/// a bet with associated video and image URLs.
class DataBet {
  final String id;
  final String videoUrl;
  final String imgUrl;
  final String? metadata;

  DataBet({
    required this.id,
    required this.videoUrl,
    required this.imgUrl,
    this.metadata,
  });
}
