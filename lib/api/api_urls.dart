class APIUrl{
  static const String baseUrl = 'stirlingpdf.io';
  static const String pdfToImage = '/api/v1/convert/pdf/img';
  static const String pdfToWord = '/api/v1/convert/pdf/word';
  static const String imageToPDF = '/api/v1/convert/img/pdf';
  static const String lockPDF = '/api/v1/security/add-password';
  static const String addWatermark = '/api/v1/security/add-watermark';
  static const String unlockPDF = '/api/v1/security/remove-password';
  static const String splitPDF = '/api/v1/general/split-pages';
  static const String mergePDF = '/api/v1/general/merge-pdfs';
  static const String fileToPDF = '/api/v1/convert/file/pdf';
  static const String compressPDF = '/api/v1/misc/compress-pdf';
}