# SaPaSa Content

Songs, notes, lyrics, and practice media for the [SaPaSa](https://github.com/bee-honey/SaPaSa) iPhone app.

The app reads `manifest.json` from this repo's `main` branch. It syncs automatically on first launch and again whenever someone taps **Settings → Refresh from GitHub**. Each refresh downloads only songs that are new or changed.

## Layout

```
manifest.json              # The list of songs, raagams, and thalams
songs/<song-id>/notes.txt  # Swara notation
songs/<song-id>/lyrics.txt # Lyrics
```

MP3 and MP4 files do **not** go in the repo. Attach them to a GitHub Release instead (see below). Release files are free to host and download, can be up to 2 GB each, and don't make the repo slow to clone.

## Adding a song

1. Create `songs/<song-id>/notes.txt` and `lyrics.txt`.
2. Add an entry to `songs` in `manifest.json`:

```json
{
  "id": "my-song",
  "version": 1,
  "title": "My Song",
  "subtitle": "Short description",
  "raagam": "mohanam",
  "thalam": "adi",
  "artists": [{ "name": "Composer Name", "role": "composer" }],
  "notesUrl": "https://raw.githubusercontent.com/bee-honey/sapasa-content/main/songs/my-song/notes.txt",
  "lyricsUrl": "https://raw.githubusercontent.com/bee-honey/sapasa-content/main/songs/my-song/lyrics.txt",
  "media": [
    {
      "id": "audio",
      "type": "audio",
      "title": "Practice audio",
      "url": "https://github.com/bee-honey/sapasa-content/releases/download/media-v1/my-song.mp3",
      "durationSeconds": 240,
      "sizeBytes": 3800000
    }
  ]
}
```

3. Commit and push.

- `raagam` and `thalam` refer to an `id` in the `raagams` / `thalams` lists. Add new ones there.
- `role` is one of `composer`, `lyricist`, `singer`, `creator`, `performer`.
- `media` `type` is `audio` or `video`. `sizeBytes` and `durationSeconds` are optional; the app uses `sizeBytes` to show the download size.
- For a short song, you can put the text inline with `"notes": "..."` instead of `notesUrl`.

## Uploading audio and video

1. On GitHub, open **Releases → Draft a new release**.
2. Use a tag such as `media-v1`. The tag name becomes part of the download URL.
3. Drag the MP3/MP4 files in and publish. Keep file names simple (no spaces).
4. The download URL is `https://github.com/bee-honey/sapasa-content/releases/download/<tag>/<file-name>`. Put it in the song's `media` entry.

You can keep adding files to the same release later.

## Updating content

| Change | What to do | What the app downloads |
|---|---|---|
| Fix notes or lyrics | Edit the `.txt` file **and** increase the song's `version` | That song's notes and lyrics |
| Replace an MP3/MP4 | Upload the new file under a **different file name** and update `url` | The new file only; the old one is deleted from the phone |
| Remove a song | Delete its entry from `manifest.json` | Nothing; its media is deleted from the phone |

If `version` doesn't change, the app keeps the copy it already has. GitHub can take up to about 5 minutes to serve an updated `manifest.json`.
