@file:Suppress("DEPRECATION")

package com.chandan.pdf_reader

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.net.Uri
import java.io.*
import android.content.ContentResolver
import android.database.Cursor
import android.provider.OpenableColumns
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.Result


class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.file.resolver"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "copyFileFromUri" -> {
                    val uriString = call.argument<String>("uri")
                    if (uriString != null) {
                        val filePath = copyFileFromUri(Uri.parse(uriString))
                        if (filePath != null) {
                            result.success(filePath)
                        } else {
                            result.error("COPY_FAILED", "Failed to copy file", null)
                        }
                    } else {
                        result.error("INVALID_URI", "No URI provided", null)
                    }
                }
            }
        }
    }

    private fun copyFileFromUri(uri: Uri): String? {
        return try {
            val inputStream = contentResolver.openInputStream(uri)
            val fileName = getFileName(uri)
            val fileExtension = getFileExtension(uri)
            val file = File(cacheDir, "$fileName")
            val outputStream = FileOutputStream(file)
            inputStream?.copyTo(outputStream)

            // Close streams
            inputStream?.close()
            outputStream.close()

            file.absolutePath
        } catch (e: Exception) {
            e.printStackTrace()
            null
        }
    }

    private fun getFileName(uri: Uri): String {
        val cursor: Cursor? = contentResolver.query(uri, null, null, null, null)
        var fileName = "unknown_file"

        cursor?.apply {
            if (moveToFirst()) {
                val nameIndex = getColumnIndex(OpenableColumns.DISPLAY_NAME)
                fileName = getString(nameIndex) ?: "unknown_file"
            }
            cursor.close()
        }
        return fileName
    }

    // Method to get file extension from the MIME type
    private fun getFileExtension(uri: Uri): String {
        val mimeType = contentResolver.getType(uri)
        return mimeType?.let {
            android.webkit.MimeTypeMap.getSingleton().getExtensionFromMimeType(it) ?: "unknown"
        } ?: "unknown"
    }
}

