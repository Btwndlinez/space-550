#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────
# Space 550 — Placeholder Image Generator
# Generates solid-color placeholder images for all 20 assets.
# Replace with real photos when ready.
# ─────────────────────────────────────────────────────────────
set -euo pipefail

cd "$(dirname "$0")"

cat << 'PYEOF' > /tmp/gen_placeholders.py
import struct, zlib, os, math

def make_png(width, height, r, g, b):
    def chunk(ctype, data):
        c = ctype + data
        return struct.pack('>I', len(data)) + c + struct.pack('>I', zlib.crc32(c) & 0xffffffff)

    sig = b'\x89PNG\r\n\x1a\n'
    ihdr = chunk(b'IHDR', struct.pack('>IIBBBBB', width, height, 8, 2, 0, 0, 0))
    raw = b''
    for y in range(height):
        raw += b'\x00'
        for x in range(width):
            # subtle gradient
            rf = min(255, int(r * (0.85 + 0.15 * math.sin(x / width * 3.14))))
            gf = min(255, int(g * (0.85 + 0.15 * math.cos(y / height * 3.14))))
            bf = min(255, int(b * (0.90 + 0.10 * math.sin((x+y) / (width+height) * 6.28))))
            raw += struct.pack('BBB', rf, gf, bf)
    idat = chunk(b'IDAT', zlib.compress(raw))
    iend = chunk(b'IEND', b'')
    return sig + ihdr + idat + iend

IMAGES = {
    # (filename, w, h, r, g, b)  (RGB 0-255)
    'images/hero-bg.jpg':      (2400, 1350, 13, 40, 24),
    'images/about-1.jpg':      (1200, 1500, 10, 30, 18),
    'images/venue-1.jpg':      (900, 1200, 15, 45, 28),
    'images/venue-2.jpg':      (900, 1200, 26, 50, 30),
    'images/venue-3.jpg':      (900, 1200, 5, 20, 12),
    'images/venue-4.jpg':      (900, 1200, 8, 25, 15),
    'images/event-1.jpg':      (1600, 900, 20, 48, 30),
    'images/event-2.jpg':      (1600, 900, 30, 55, 35),
    'images/event-3.jpg':      (1600, 900, 12, 38, 22),
    'images/event-4.jpg':      (1600, 900, 25, 52, 32),
    'images/event-5.jpg':      (1600, 900, 8, 30, 18),
    'images/event-6.jpg':      (1600, 900, 18, 42, 26),
    'images/gallery-1.jpg':    (1200, 1500, 22, 48, 30),
    'images/gallery-2.jpg':    (1000, 1500, 14, 35, 22),
    'images/gallery-3.jpg':    (1200, 1500, 30, 55, 35),
    'images/gallery-4.jpg':    (1200, 1500, 10, 28, 16),
    'images/gallery-5.jpg':    (1000, 1500, 18, 42, 26),
    'images/gallery-6.jpg':    (1200, 1500, 24, 50, 32),
    'images/contact-bg.jpg':   (2400, 1400, 5, 18, 10),
    'images/parallax-bg.jpg':  (2400, 1400, 15, 38, 24),
}

for path, (w, h, r, g, b) in IMAGES.items():
    os.makedirs(os.path.dirname(path), exist_ok=True)
    data = make_png(w, h, r, g, b)
    with open(path, 'wb') as f:
        f.write(data)
    size_kb = round(os.path.getsize(path) / 1024)
    print(f"  ✓ {path}  ({w}×{h}, {size_kb} KB)")

# Also generate ambient silence as WAV-header wrapped in jpg to not break
# Actually generate a minimal valid WAV and write as .mp3
# The site will fail to play it but won't error out.
import wave, struct as ws
audio_path = 'audio/ambient.mp3'
os.makedirs(os.path.dirname(audio_path), exist_ok=True)
# Generate a tiny 0.5s of silence as WAV (won't play as mp3 but prevents 404)
sample_rate = 22050
duration = 0.5
num_samples = int(sample_rate * duration)
# Write minimal WAV
with open(audio_path, 'wb') as f:
    # Minimal valid MP3 frame: just a sync word
    # 0xFF 0xFB = MPEG1 Layer3, 320kbps, 44100Hz
    frame = bytes([0xFF, 0xFB, 0x90, 0x00]) + b'\x00' * 413
    for _ in range(10):
        f.write(frame)

print(f"  ✓ {audio_path}  (silent MP3 placeholder)")
print("\nDone — 20 placeholders + 1 audio placeholder generated.")
print("Replace with real assets when ready.")
PYEOF

python3 /tmp/gen_placeholders.py
rm /tmp/gen_placeholders.py
