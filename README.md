# HangulString

## Class diagram

```mermaid
classDiagram
    HangulString ..> HangulCharacter
    HangulCharacter ..> UnicodeHangulJamoScalar
    HangulCharacter ..> HangulCharacterInJamos
    UnicodeHangulJamoScalar ..> Jamo
    HangulCharacterInJamos ..> Jamo
```
