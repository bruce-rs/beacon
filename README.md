# Beacon

A Flutter app for fast, local device-to-device file transfers over a shared Wi-Fi network — no internet or cloud required.

## How it works

1. **Discovery** — On launch, Beacon registers itself as an mDNS service (`_beacon._tcp`) and scans for other devices running the app on the same network. Discovered devices appear in real time on the home screen.

2. **Select & send** — Pick a target device, then drop files onto the drop zone (desktop) or tap it to open the file picker (mobile). Files are sent one by one to the selected device.

3. **Transfer protocol** — Beacon opens a direct TCP socket to the recipient and streams the file using a lightweight binary protocol:

   ```
   [4 bytes]  filename length (uint32, big-endian)
   [N bytes]  filename (UTF-8)
   [8 bytes]  file size (uint64, big-endian)
   [N bytes]  file data (streamed in 64 KB chunks)
   [1 byte]   ACK (0x01) sent by recipient after write completes
   ```

4. **Receive & confirm** — The recipient writes the file to disk and sends an ACK back. The sender waits up to 60 seconds for confirmation. Progress is shown in real time on both ends.

## Where files are saved

| Platform                | Location                                            |
| ----------------------- | --------------------------------------------------- |
| Android                 | `Downloads/Beacon/` (via MediaStore API)            |
| iOS                     | `Documents/Beacon/` (app sandbox)                   |
| macOS / Windows / Linux | `Downloads/Beacon/` (fallback: `Documents/Beacon/`) |

The folder name (`Beacon`) is configurable via the `MEDIA_FOLDER_NAME` environment variable in the flavor-specific `.env` file.

## Tech stack

| Category              | Package / Technology                                                                |
| --------------------- | ----------------------------------------------------------------------------------- |
| Framework             | Flutter (Dart 3.11.1+)                                                              |
| Device discovery      | `nsd` — mDNS service registration & scanning                                        |
| File transfer         | Custom TCP socket via `dart:io`                                                     |
| File picking          | `file_picker`                                                                       |
| Drag & drop (desktop) | `desktop_drop`                                                                      |
| Platform paths        | `path_provider`                                                                     |
| Android Downloads     | `media_store_plus`                                                                  |
| State management      | `get` (GetX)                                                                        |
| Dependency injection  | `get_it` + `injectable`                                                             |
| Navigation            | `auto_route`                                                                        |
| Local storage         | `shared_preferences` (settings), `sqflite` (prepared for history)                   |
| Theming & fonts       | `google_fonts`                                                                      |
| Localization          | `flutter_localizations` + `intl` (English, Spanish)                                 |
| Config                | `flutter_dotenv` + `flutter_flavorizr` (dev / prod flavors)                         |
| Code generation       | `build_runner`, `json_serializable`, `injectable_generator`, `auto_route_generator` |
| Internal packages     | `sdk_helpers`, `networking`, `widget_hub` (Brandon-RS/dart_packages)                |
