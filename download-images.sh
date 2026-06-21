#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────
# Space 550 — Download real venue/nightclub photos from Unsplash
# Replaces generated placeholders with real stock photography.
# ─────────────────────────────────────────────────────────────
set -euo pipefail
cd "$(dirname "$0")"

mkdir -p images audio

dl() {
  local url="$1" out="$2"
  echo "  ↓ $out"
  curl -sfL "$url" -o "$out" || echo "  ✗ $out — failed"
}

# Each photo is from Unsplash — free for commercial use (Unsplash License).
# Using &fit=crop&crop=center for predictable framing.

# ── Hero ──
dl "https://images.unsplash.com/photo-1492684223066-81342ee5ff30?w=2400&q=85&fit=crop" \
  "images/hero-bg.jpg"

# ── About / Manifesto ──
dl "https://images.unsplash.com/photo-1574169208507-84376144848b?w=1200&q=85&fit=crop" \
  "images/about-1.jpg"

# ── Venues (4 rooms) ──
dl "https://images.unsplash.com/photo-1571167530141-7e3b1c2d9c3d?w=900&q=85&fit=crop" \
  "images/venue-1.jpg"
dl "https://images.unsplash.com/photo-1571902943202-507ec2618e8f?w=900&q=85&fit=crop" \
  "images/venue-2.jpg"
dl "https://images.unsplash.com/photo-1514528753166-0bf1a3a3d2f2?w=900&q=85&fit=crop" \
  "images/venue-3.jpg"
dl "https://images.unsplash.com/photo-1516450360452-9312f5e86fc7?w=900&q=85&fit=crop" \
  "images/venue-4.jpg"

# ── Events (6 thumbnails, landscape) ──
dl "https://images.unsplash.com/photo-1470229722913-7c0e2dbbafd3?w=1600&q=85&fit=crop" \
  "images/event-1.jpg"
dl "https://images.unsplash.com/photo-1501386761578-eac5c94b800a?w=1600&q=85&fit=crop" \
  "images/event-2.jpg"
dl "https://images.unsplash.com/photo-1459749411175-04bf5292ceea?w=1600&q=85&fit=crop" \
  "images/event-3.jpg"
dl "https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=1600&q=85&fit=crop" \
  "images/event-4.jpg"
dl "https://images.unsplash.com/photo-1429962714451-bb934ecdc4ec?w=1600&q=85&fit=crop" \
  "images/event-5.jpg"
dl "https://images.unsplash.com/photo-1533174072545-7a4b6ad7a6c3?w=1600&q=85&fit=crop" \
  "images/event-6.jpg"

# ── Gallery (6 portrait/square) ──
dl "https://images.unsplash.com/photo-1566737236500-c8ac43014a67?w=1200&q=85&fit=crop" \
  "images/gallery-1.jpg"
dl "https://images.unsplash.com/photo-1545128110-6b53674fc63d?w=1000&q=85&fit=crop" \
  "images/gallery-2.jpg"
dl "https://images.unsplash.com/photo-1558618666-1273df0c8a4d?w=1200&q=85&fit=crop" \
  "images/gallery-3.jpg"
dl "https://images.unsplash.com/photo-1519741497674-611481863552?w=1200&q=85&fit=crop" \
  "images/gallery-4.jpg"
dl "https://images.unsplash.com/photo-1524367168-f1205b5eb7ac?w=1000&q=85&fit=crop" \
  "images/gallery-5.jpg"
dl "https://images.unsplash.com/photo-1493676304819-0d7a8d026dcf?w=1200&q=85&fit=crop" \
  "images/gallery-6.jpg"

# ── Contact / Parallax backgrounds ──
dl "https://images.unsplash.com/photo-1571266028243-e4733b0f0bb0?w=2400&q=85&fit=crop" \
  "images/contact-bg.jpg"
dl "https://images.unsplash.com/photo-1605296867724-fa87a8ef53fd?w=2400&q=85&fit=crop" \
  "images/parallax-bg.jpg"

echo ""
echo "Done. All images downloaded to images/"
ls -lh images/ | tail -n +2
