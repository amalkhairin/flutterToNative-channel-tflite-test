# flutter_channel_test

Run TFlite dengan Flutter menggunakan Method Channel

## Language
- Dart
- Kotlin

## Cara kerja
Menggunakan Camera package di project Flutter kemudian akan melakukan stream dengan parameter CameraImage. Kemudian Plane.bytes didalam CameraImage akan dikirim ke MainActivity.kt menggunakan Method Channel yang sudah diinisialisasi, dan setelah dilakukan proses di MainActivity.kt akan dikembalikan ke Dart file sebelumnya.
