String getIconPath(String extension) {
  switch (extension) {
    case 'pdf': return 'assets/icons/pdf.png';
    case 'doc':
    case 'docx': return 'assets/icons/doc.png';
    case 'ppt':
    case 'pptx': return 'assets/icons/ppt.png';
    case 'xls':
    case 'xlsx': return 'assets/icons/xls.png';
    default: return 'assets/icons/pdf.png';
  }
}
