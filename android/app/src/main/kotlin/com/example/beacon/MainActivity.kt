package com.example.beacon

import android.app.DownloadManager
import android.content.ActivityNotFoundException
import android.content.Intent
import android.os.Environment
import android.provider.DocumentsContract
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.beacon/files").setMethodCallHandler { call, result ->
            when (call.method) {
                "openDownloadsFolder" -> result.success(openDownloadsFolder(call.argument<String>("folder")))
                else -> result.notImplemented()
            }
        }
    }

    /// Opens Download/<folder> in the system file manager (DocumentsUI / Files app).
    /// Falls back to the Downloads root if the folder can't be opened directly.
    private fun openDownloadsFolder(folder: String?): Boolean {
        val relativePath = listOfNotNull(Environment.DIRECTORY_DOWNLOADS, folder?.takeIf { it.isNotBlank() }).joinToString("/")
        val folderUri = DocumentsContract.buildDocumentUri("com.android.externalstorage.documents", "primary:$relativePath")

        val folderIntent = Intent(Intent.ACTION_VIEW)
            .setDataAndType(folderUri, DocumentsContract.Document.MIME_TYPE_DIR)
            .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_GRANT_READ_URI_PERMISSION)
        val downloadsIntent = Intent(DownloadManager.ACTION_VIEW_DOWNLOADS).addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)

        for (intent in listOf(folderIntent, downloadsIntent)) {
            try {
                startActivity(intent)
                return true
            } catch (_: ActivityNotFoundException) {
            } catch (_: SecurityException) {
            }
        }
        return false
    }
}
