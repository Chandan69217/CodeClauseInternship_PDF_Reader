String getIconPath(String extension) {
  switch (extension) {
    case 'pdf': return 'assets/icons/pdf.webp';
    case 'doc':
    case 'docx': return 'assets/icons/doc.webp';
    case 'ppt':
    case 'pptx': return 'assets/icons/ppt.webp';
    case 'xls':
    case 'xlsx': return 'assets/icons/xls.webp';
    default: return 'assets/icons/pdf.webp';
  }
}
