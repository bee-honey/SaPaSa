# SaPaSa Mobile App Blueprint

## Product Goal

SaPaSa is a Carnatic music practice app for browsing songs, reading lyrics or notes, listening to practice audio, and watching available video references. The first app release ships with a small set of bundled songs. Future songs can be refreshed from a public GitHub source and stored locally on the device so users do not need repeated streaming or app updates.

## Core User Flow

1. User opens the app on the Home screen.
2. User sees a searchable song list.
3. User can filter by raagam, thalam, artist, content availability, or favorites.
4. User opens a song.
5. Song detail shows the song title and primary metadata.
6. More song information is available inside an expandable section.
7. User practices from Notes or Lyrics while optionally listening to audio.
8. If video exists, user can switch to the Video tab. In video mode, the bottom audio player is hidden.
9. User can favorite songs for faster access later.
10. User can refresh the library to pull new or updated songs from GitHub.

## Navigation

### Bottom Tabs

- Home
- Favorites
- Settings

### Main Screens

- HomeScreen
- FavoritesScreen
- SongDetailScreen
- SettingsScreen
- RefreshLibraryScreen or modal

## Home Screen

### Purpose

The Home screen is the main discovery and search surface. Until a user favorites songs, search and filters are the main way to reach a song.

### Layout

- App header with `SaPaSa`
- Search input
- Filter button
- Segmented control:
  - All Songs
  - Favorites
- Song list
- Pull-to-refresh or refresh action

### Empty Favorite State

When there are no favorite songs:

> Search songs and mark favorites for quick practice.

This should be subtle and not feel like a marketing screen.

### Song List Item

Each row should show:

- Song title
- Raagam
- Thalam
- Small availability indicators:
  - Notes
  - Lyrics
  - Audio
  - Video
- Favorite icon

## Filters

Filters can start simple and expand later.

Initial filters:

- Raagam
- Thalam
- Artist
- Has notes
- Has lyrics
- Has audio
- Has video
- Favorites only

## Song Detail Screen

### Header

- Song title
- Raagam name
- Thalam name
- Favorite button

### Expandable Info Section

Collapsed by default.

When expanded, show:

- Artists grouped by role:
  - Composer
  - Lyricist
  - Singer
  - Creator
  - Performer
- Thalam details
- Raagam
- Arohanam
- Avarohanam
- Melakartha status
- Hindustani name, if available

### Practice Tabs

Tabs:

- Notes
- Lyrics
- Video, only if video exists

Rules:

- Notes and Lyrics tabs can show the bottom audio player if audio exists.
- Video tab should hide the bottom audio player.
- If a song has no video, do not show the Video tab.

## Notes Tab

### Content

- Render notation text or bundled/downloaded file.
- Support scroll.
- Later enhancement: zoom controls and font size settings.

### Audio

If audio exists:

- Mini player at bottom
- Play/pause
- Seek
- Current time and duration

## Lyrics Tab

### Content

- Render lyrics text or bundled/downloaded file.
- Support scroll.
- Later enhancement: language switch if multiple lyrics versions exist.

### Audio

Same bottom mini player behavior as Notes.

## Video Tab

### Content

- Embedded local video player or external video link.
- Hide bottom audio player.

## Local And Remote Content Strategy

### Bundled Content

The app ships with a few default songs inside the app bundle.

Bundled song assets can include:

- Metadata JSON
- Lyrics text or PDF
- Notes text or PDF
- Audio files
- Video files, only if small enough for app size

### Remote GitHub Content

Use a public GitHub repository as a content source.

Recommended structure:

```text
sapasa-content/
  manifest.json
  songs/
    vatapi/
      song.json
      lyrics.txt
      notes.txt
      audio.mp3
      video.mp4
    mahaganapathim/
      song.json
      lyrics.txt
      notes.txt
      audio.mp3
```

### Manifest

The app should fetch `manifest.json` first.

Example:

```json
{
  "version": 1,
  "updated_at": "2026-05-29",
  "songs": [
    {
      "id": "vatapi-ganapathim",
      "title": "Vatapi Ganapathim",
      "version": 3,
      "metadata_url": "songs/vatapi/song.json"
    }
  ]
}
```

### Refresh Flow

1. User taps Refresh Library or pulls to refresh.
2. App downloads the remote manifest.
3. App compares remote song versions against local song versions.
4. App downloads only missing or updated songs.
5. App stores metadata in local DB.
6. App stores files in local app storage.
7. Home screen refreshes from local DB.

### Download Policy

Recommended default:

- Download metadata immediately.
- Download lyrics and notes immediately because they are small.
- Download audio/video only when user opens the song or explicitly taps download.

This keeps install and refresh lightweight while still avoiding repeated downloads.

## Data Model

### Song

- id
- title
- raagam_id
- thalam_id
- description
- source
- remote_version
- is_favorite
- is_bundled
- created_at
- updated_at

### Raagam

- id
- name
- hindustani_name
- is_melakartha

### RaagamLakshanam

- id
- raagam_id
- type
- swaras_text

Allowed `type` values:

- arohanam
- avarohanam

### Thalam

- id
- name
- beats
- structure

### Artist

- id
- name

### SongArtist

- id
- song_id
- artist_id
- role

Allowed `role` examples:

- composer
- lyricist
- singer
- creator
- performer

### SongResource

- id
- song_id
- type
- title
- local_path
- remote_url
- format
- size_bytes
- duration_seconds
- download_status
- remote_version

Allowed `type` examples:

- notes
- lyrics
- audio
- video

Allowed `download_status` values:

- bundled
- not_downloaded
- downloading
- downloaded
- failed

## Suggested Mobile Stack

Recommended starting stack:

- Expo React Native
- SQLite for local metadata
- Expo FileSystem for downloaded files
- Expo AV or replacement media package for audio/video
- React Navigation for tabs and stack navigation

Why this fits SaPaSa:

- Good local file support
- Easy bundled assets
- Fast iteration
- Works for iOS and Android
- SQLite fits the offline-first content library

## Visual Direction

SaPaSa should feel warm, musical, and rooted in Carnatic tradition without becoming heavy or decorative.

### Palette

- Deep maroon for primary actions and headers
- Turmeric gold for highlights
- Warm ivory for backgrounds
- Leaf green as an accent
- Charcoal brown for primary text

### UI Character

- Use subtle veena/tambura-inspired line patterns in headers or empty states.
- Use warm surfaces instead of flat white.
- Use clear readable typography for lyrics and notes.
- Use restrained ornamentation around section dividers, not around every card.
- Keep practice screens calm and uncluttered.

## First Build Milestone

Milestone 1 should include:

- Home screen
- Search
- Favorites
- Static bundled song data
- Song detail screen
- Expandable song info
- Notes tab
- Lyrics tab
- Conditional video tab
- Basic audio player under Notes and Lyrics

## Second Build Milestone

Milestone 2 should include:

- SQLite persistence
- GitHub manifest refresh
- Download status tracking
- Local file storage
- Settings screen with refresh and storage info

## Open Decisions

- Should notes and lyrics be stored as plain text, markdown, PDF, or images?
- Should audio/video download automatically or only when opened?
- Should GitHub content be raw files from a public repository or GitHub Releases?
- Should users be allowed to delete downloaded audio/video to save space?
- Should the first version support multiple languages for lyrics?
