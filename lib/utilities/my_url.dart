class MyUrl{
  MyUrl._();
  static const String appLink = 'https://play.google.com/store/apps/details?id=com.chandan.pdf_reader';
  static const String githubLink = 'https://github.com/Chandan69217';
  static const String privacyPolicyUrl = 'https://doc-hosting.flycricket.io/pdf-reader-privacy-policy/891c5e7d-2e02-4ea9-a2c6-721d1c0b4330/privacy';
  static const String termsUrl = 'https://doc-hosting.flycricket.io/pdf-reader-terms-of-use/3dcfdf98-d64b-414b-b6bf-adc6423cca4a/terms';
  static final Uri myAppUri = Uri.parse(appLink);
  static final Uri myGithubUri = Uri.parse(githubLink);
}