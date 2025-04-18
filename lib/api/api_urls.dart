class APIUrl{
  static const String baseUrl = 'stirlingpdf.io';
  static const String pdfToImage = '/api/v1/convert/pdf/img';
  static const String imageToPDF = '/api/v1/convert/img/pdf';
  static const String lockPDF = '/api/v1/security/add-password';
  static const String unlockPDF = '/api/v1/security/remove-password';
  static const String splitPDF = '/api/v1/general/split-pages';
  static const String mergePDF = '/api/v1/general/merge-pdfs';
  static const String fileToPDF = '/api/v1/convert/file/pdf';
}