import android.graphics.Bitmap
import android.media.MediaMetadataRetriever
import java.io.File
import java.io.FileOutputStream

class VideoThumbnailPlugin {
    companion object {
        fun generateThumbnail(videoPath: String, filename: String, tempDerectory: String): String? {
            return try {
                val retriever = MediaMetadataRetriever()
                retriever.setDataSource(videoPath)
                val bitmap = retriever.getFrameAtTime(1000) // Extract frame at 1 second
                retriever.release()

                saveBitmap(bitmap, filename,tempDerectory)
            } catch (e: Exception) {
                e.printStackTrace()
                null
            }
        }

        private fun saveBitmap(bitmap: Bitmap?, filename: String, tempDerectory: String ): String? {
            bitmap ?: return null
            return try {
                val directory = File("$tempDerectory")
                if (!directory.exists()) {
                    directory.mkdirs() // Creates the directory if it doesn't exist
                }
                val file = File(directory, "$filename.png")
                val out = FileOutputStream(file)
                bitmap.compress(Bitmap.CompressFormat.PNG, 100, out)
                out.flush()
                out.close()
                file.absolutePath
            } catch (e: Exception) {
                e.printStackTrace()
                null
            }
        }
    }
}
