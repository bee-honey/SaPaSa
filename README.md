# SaPaSa

**A SwiftUI iPhone app for practicing Carnatic music: songs with swara notation, lyrics, and raga/tala details, plus a structured beginner lesson path.**

SaPaSa (from *Sa–Pa–Sa*, the tonic–fifth–octave drone every Carnatic student tunes to) puts the material a beginner works through in one place: from Swaravali Varisaigal up to Geethams and Swarajathis.

## Features

### Song library
- Browse a library of Carnatic songs
- Search by song, raagam, thalam, or artist
- Filter by raagam, thalam, and whether audio or video is available
- Save favorites (kept on the device)

### Song practice
- **Notes** and **Lyrics** tabs for each song
- A **Video** tab that appears only when the song has video
- Expandable details: artists (composer, lyricist, singer…), thalam structure, and raaga lakshanam (arohanam / avarohanam, melakartha status, Hindustani equivalent)
- Audio player for Notes and Lyrics; audio and video download once and play offline

### Learn
A chapter-by-chapter beginner guide, with lessons loaded from bundled JSON:

| # | Chapter |
|---|---------|
| 1 | Swaravali Varisaigal (Sarali) |
| 2 | Jantai Varisaigal |
| 3–4 | Dhattu Varisaigal & Upper Sthayi Varisaigal |
| 5 | Thalas |
| 6 | Saptha Thala Alankaras |
| 7 | Swaras & Raga Symbols |
| 8 | Geethas |
| 9 | Swarajathis |
| 10–11 | Notes & Bruga Sadaka |
| — | Lakshana Geetham, Meanings & Extra Alankaras |

## Requirements

- Xcode 15 or later
- iOS 17.0+ (iPhone)
- No third-party dependencies

## Getting started

```bash
git clone <repo-url>
cd SaPaSa
open SaPaSa.xcodeproj
```

Pick an iPhone simulator and press **⌘R**.

## Project structure

```
SaPaSa/
├── SaPaSaApp.swift          # App entry point
├── Models/                  # Song, Raagam, Thalam, Artist, Resource models
├── Stores/                  # SongLibraryStore (library, search, favorites), ContentSyncService (GitHub sync, downloads)
├── Views/                   # Home, Learn, Favorites, Settings, Song detail, theme
├── Resources/
│   └── LearnLessons/        # Lesson content as JSON, one folder per chapter
└── Assets.xcassets
docs/
└── sapasa-mobile-app-blueprint.md   # Product and architecture blueprint
content/                     # Songs the app syncs from GitHub (not built into the app)
├── manifest.json
└── songs/<song-id>/         # notes.txt, lyrics.txt
```

## Adding or editing lessons

Lesson content lives in JSON, so you can change it without touching Swift code. Each chapter is a folder under `SaPaSa/Resources/LearnLessons/<chapter-id>/`. Every `.json` file in that folder is loaded, sorted by file name.

```json
{
  "id": "lesson-1-swaravali-varisaigal",
  "title": "Lesson 1 - Swaravali Varisaigal",
  "raga": "Mayamalavagowla",
  "thalam": "Adi tala",
  "note": "Optional note shown with the lesson.",
  "exercises": [
    {
      "id": "swaravali-1",
      "number": "1.",
      "lines": [
        "Sa   Ri   Ga   Ma  | Pa   Da  | Ni   Sa  ||",
        "Sa   Ni   Da   Pa  | Ma   Ga  | Ri   Sa  ||"
      ]
    }
  ]
}
```

To start a new Geetham, copy `geethas/geetha-template.json`.

## Content from GitHub

Songs live in the [`content/`](content) folder of this repo, and the app downloads them straight from GitHub. New songs don't need an app update, and hosting costs nothing.

- The app syncs `manifest.json` once on first launch, then only when the user taps **Settings → Refresh from GitHub**.
- Each refresh downloads notes and lyrics only for songs whose `version` changed.
- MP3/MP4 files are attached to this repo's [Releases](https://github.com/bee-honey/SaPaSa/releases), not committed. Each one downloads once, on request (per song, or **Download all**), and plays from the device after that.
- Everything is stored in Application Support and excluded from iCloud backup. The bundled sample songs are shown until the first sync succeeds.

The manifest URL is set in `ContentConfig` (`SaPaSa/Stores/ContentSyncService.swift`). To add or update songs, see [`content/README.md`](content/README.md).

## Roadmap

- [x] Sync content from a GitHub-hosted `manifest.json`
- [x] Download notes, lyrics, audio, and video once for offline use
- [x] Real audio and video playback
- [ ] Deliver Learn lessons through the same sync
- [ ] Background downloads that continue when the app is closed

## Contributing

Corrections to notation, raga details, or lesson content are welcome. Most content fixes are JSON-only edits under `Resources/LearnLessons`. Please open an issue or pull request.
