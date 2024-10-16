class Hadith {
  final int id;
  final int? hadithNumber; // Make it nullable
  final String? englishNarrator;
  final String? hadithEnglish;
  final String? hadithUrdu;
  final String? urduNarrator;
  final String? hadithArabic;
  final String? headingArabic;
  final String? headingUrdu;
  final String? headingEnglish;

  @override
  String toString() {
    return 'Hadith{id: $id, hadithNumber: $hadithNumber, englishNarrator: $englishNarrator, hadithEnglish: $hadithEnglish, hadithUrdu: $hadithUrdu, urduNarrator: $urduNarrator, hadithArabic: $hadithArabic, headingArabic: $headingArabic, headingUrdu: $headingUrdu, headingEnglish: $headingEnglish}';
  }

  Hadith({
    required this.id,
    this.hadithNumber,
    this.englishNarrator,
    this.hadithEnglish,
    this.hadithUrdu,
    this.urduNarrator,
    this.hadithArabic,
    this.headingArabic,
    this.headingUrdu,
    this.headingEnglish,
  });

  factory Hadith.fromJson(Map<String, dynamic> json) {
  return Hadith(
    id: json['id'] ?? 0,
    hadithNumber: int.tryParse(json['hadithNumber'].toString()), // Convert to int
    englishNarrator: json['englishNarrator'],
    hadithEnglish: json['hadithEnglish'],
    hadithUrdu: json['hadithUrdu'],
    urduNarrator: json['urduNarrator'],
    hadithArabic: json['hadithArabic'],
    headingArabic: json['headingArabic'],
    headingUrdu: json['headingUrdu'],
    headingEnglish: json['headingEnglish'],
  );
}
}


