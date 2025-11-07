# Downloading Private Google Drive Files

The videos are shared privately with your Google account, so you need to authenticate to download them.

## Method 1: Use Cookies (Recommended for automation)

### Step 1: Export Google Drive Cookies

**Option A - Using Browser Extension (Easier):**

1. Install a cookie exporter extension:

   - Chrome/Edge: [Get cookies.txt LOCALLY](https://chrome.google.com/webstore/detail/get-cookiestxt-locally/cclelndahbckbenkjhflpdbgdldlbecc)
   - Firefox: [cookies.txt](https://addons.mozilla.org/en-US/firefox/addon/cookies-txt/)

2. Go to https://drive.google.com and make sure you're logged in
3. Click the extension icon
4. Export cookies as `cookies.txt`
5. Save the file in this project directory

**Option B - Manual Method:**

1. Open Chrome/Edge DevTools (F12)
2. Go to Application → Cookies → https://drive.google.com
3. Find cookies and export to Netscape format

### Step 2: Run the Download Script

```bash
./download_videos.sh
```

The script will use `cookies.txt` to authenticate and download all videos.

---

## Method 2: Manual Download (Simpler, but slower)

If you prefer not to deal with cookies:

### Step 1: Download Videos Manually

1. Open each Google Drive link in your browser
2. Download the videos manually
3. Save them to the `videos/` folder with these names:
   - Lecture_01.mp4
   - Lecture_02.mp4
   - Lecture_03.mp4
   - Tutorial_04.mp4
   - Tutorial_05.mp4
   - Tutorial_06.mp4
   - Tutorial_07.mp4
   - Lecture_08.mp4
   - ... (up to Lecture_21.mp4)

### Step 2: Run Transcription

```bash
./transcribe_all.sh
```

---

## Google Drive Links

All videos are in this folder:
https://drive.google.com/drive/u/1/folders/1tqKHs9zU-wpVDEIyyzlo3NPLDZCVwAVv

Individual files:

- https://drive.google.com/open?id=1Eo5iaFIz-ikSMxmPuWEzcFPMMIS5bgzr (Lecture 1)
- https://drive.google.com/open?id=1cQy9cXOLETwFGo6UJUtL_1xpMKCYFVzf (Lecture 2)
- https://drive.google.com/open?id=1Hp-4yJROKE9smL8rvswXXUxXv1J1ctGk (Lecture 3)
- https://drive.google.com/open?id=1Yat-kM1lV7EpG2QdnMxHjsk6YBuSCrk1 (Tutorial 4)
- https://drive.google.com/open?id=1orJuQFGAy5CDmu14cZiItOPNinZygcgA (Tutorial 5)
- https://drive.google.com/open?id=1vrKJ5_WgRbC5l5XjWkUoBvfz55x3Hqr5 (Tutorial 6)
- https://drive.google.com/open?id=1Y-61Epav2np9IBmAFQihhQBCmrqM_lUE (Tutorial 7)
- https://drive.google.com/open?id=15lfF_-0Fce4mxBQU3r3glcznPUyCV38f (Lecture 8)
- https://drive.google.com/open?id=1tMTE2TYhmsH7VO1_AxJzkZ_3peZhxgnn (Lecture 9)
- https://drive.google.com/open?id=19woyuFvE9pgryorz6Ju4RwXWQv2a5N9N (Lecture 10)
- https://drive.google.com/open?id=1uTXnkpnOlFTT5EWz2hOLTOQ6jVXW5eXk (Lecture 11)
- https://drive.google.com/open?id=1DvdO12yVTrK17CTLXWKJZPKw0aDpvyBG (Lecture 12)
- https://drive.google.com/open?id=1Ui_xGGaNbuZU7ce0fm6w5CIhJDMqHEBJ (Lecture 13)
- https://drive.google.com/open?id=1U_RifIRGkA_wHgahL_Nc_7QLSaf3ESTg (Lecture 14)
- https://drive.google.com/open?id=1MuLvNbGOrDBz4cYWZxdlLZ0K5yNpEb7y (Lecture 15)
- https://drive.google.com/open?id=1HjPjSmfHNbOFXHGT6iWYdpdOyK0f6SDw (Lecture 16)
- https://drive.google.com/open?id=19y2d5O8EfbwUwObWW_j3VNdienSiH5Pt (Lecture 17)
- https://drive.google.com/open?id=112nGDWIh4kWnXbCjN9QCtEcCVuwf-c4G (Lecture 18)
- https://drive.google.com/open?id=1IAxOPpl-YPtC5jCpeNfiF9oH2-iZ00QE (Lecture 19)
- https://drive.google.com/open?id=1rnA8PIB445TnJSZzIf2mtjp77RUojSyv (Lecture 20)
- https://drive.google.com/open?id=13Ly1XFstSnW2hLY4LXI8NHaTfM3BmGu8 (Lecture 21)

---

## Troubleshooting

**Problem:** "Access denied" or "Cannot download"

- **Solution:** Make sure you're logged into the correct Google account that has access to these files

**Problem:** Cookie export not working

- **Solution:** Use Method 2 (manual download) instead

**Problem:** Download script fails even with cookies

- **Solution:** Cookies may have expired. Export fresh cookies and try again, or download manually
