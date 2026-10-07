# media_store_plus returns its SaveInfo to Dart as Gson JSON keyed by field name.
# R8 renames those fields (name -> a, uri -> b) and strips @SerializedName, so the
# Dart side parses {"a": ...} as null, silently losing the saved file's URI — which
# breaks "Open folder" in release builds only.
-keep class com.snnafi.media_store_plus.** { *; }
-keepattributes *Annotation*, Signature, InnerClasses, EnclosingMethod

# Gson needs generic signatures and its own type adapters intact.
-keep class com.google.gson.** { *; }
-keep class * extends com.google.gson.TypeAdapter
