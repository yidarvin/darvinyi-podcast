# litsearch-podcast — setup

The Mac-mini side is automated. You run one script through Claude Code; then
there are two small manual bits (the NAS and your phone), because those live
outside the mini. Everything routes through `dodoland` over Tailscale, so
there's no Cloudflare or port-forwarding to configure.

---

## Step 1 — Claude Code does the Mac mini

1. Get this kit onto the Mac mini and unzip it (or hand Claude Code the zip
   and say "unzip this kit").
2. Open Claude Code in the unzipped kit folder and say:

   > **Run bootstrap.sh.**

That's it for the mini. `bootstrap.sh` (idempotent — safe to re-run) will:

- install `espeak-ng` + `ffmpeg` via Homebrew,
- create the Python venv and install `kokoro`, `soundfile`, `pyyaml`,
- download and **test** the Kokoro model (writes two sample WAVs so you can
  hear a host and a guest),
- install the skill into `~/.claude/skills/litsearch-podcast`,
- copy the repo to `~/Projects/darvinyi-podcast`, `git init`, commit,
- **create the GitHub repo `yidarvin/darvinyi-podcast` and push it** (via the
  `gh` CLI),
- generate your SSH key if you don't have one,
- run the environment doctor,
- and print a short numbered "what's left for you" list for anything it
  couldn't finish.

**Prerequisites it assumes:** Homebrew and git on the mini. Two things it may
hand back to you, both one-time:
- If the GitHub CLI isn't logged in, it'll say to run `gh auth login` once and
  re-run bootstrap. (Want a private repo? `REPO_VISIBILITY=private ./bootstrap.sh`.)
- If your NAS login user differs from your Mac username, re-run as
  `NAS_SSH_USER=youruser ./bootstrap.sh` so `ssh dodoland` uses the right user.
  (Tailscale MagicDNS already resolves the *name* `dodoland` on every device —
  you never need an IP.)

---

## Step 2 — You set up the NAS (once)

**2a. Authorize the mini's SSH key** so it can publish audio. The bootstrap
prints the key and this command; run it in your terminal once (needs your NAS
password):

```bash
ssh-copy-id dodoland
```

**2b. Start the feed server.** On the NAS, run the bundled script — it creates
the folder and starts a tiny Caddy container on port 8091:

```bash
curl -O https://raw.githubusercontent.com/yidarvin/darvinyi-podcast/main/nas/setup-nas.sh
sh setup-nas.sh
```

(If step 2a is already done, you can skip logging into the NAS entirely and
just tell Claude Code on the mini: *"run nas/setup-nas.sh on dodoland over
ssh."* It'll pipe the script over for you.)

Verify from anywhere on your tailnet (a 404 is fine — nothing's published
yet): `curl -I http://dodoland:8091/feed.xml`

---

## Step 3 — You subscribe on your phone

In Overcast (or any podcast app): add by URL →

```
http://dodoland:8091/feed.xml
```

Turn on automatic downloads so episodes are on-device before the Caltrain
dead zones. Works wherever your phone has Tailscale on. (Apple Podcasts can be
fussy about plain HTTP — if you use it, see the HTTPS option at the bottom.)

---

## Step 4 — First episode (calibrate before batching)

Do this from `~/Projects/darvinyi-podcast` in Claude Code — no file editing by
hand:

1. **Queue a paper:** *"Queue up `<litsearch-slug>`"* (or paste an arXiv link
   and the matching slug). The skill appends it to `queue.md` and commits.
2. **Make it:** *"Use the litsearch-podcast skill to produce the first
   unchecked episode in queue.md."* It fetches the paper, writes the
   three-voice script, renders the MP3, rebuilds the feed, and publishes to
   the NAS.
3. **Listen** to the whole thing on a commute, then tune the two levers:
   - `~/.claude/skills/litsearch-podcast/references/script_style.md` — length
     targets, how much debate, how deep the guest goes.
   - `~/Projects/darvinyi-podcast/config.yaml` — the voice cast (hosts are
     fixed; try `af_bella`/`am_adam`), the default guest, `speed`, or the
     stereo `pan` widths.
4. **Batch the rest:** `./run.sh 10` (one fresh Claude invocation per episode;
   it halts if any episode fails, so a bad run can't burn the queue).

---

## Feed URL options (default is #1 — no action needed)

1. **Tailscale, plain (default).** `http://dodoland:8091/feed.xml`. Already
   set as `base_url` in config.yaml. Traffic is WireGuard-encrypted; nothing
   is publicly exposed.
2. **Tailscale, HTTPS** (if your podcast app insists on https). On the NAS:
   `tailscale serve --bg 8091`. Then set `base_url` to
   `https://dodoland.<your-tailnet>.ts.net` in config.yaml and re-run
   `make_feed.py` + `publish.py`.
3. **Cloudflare public domain.** On your existing tunnel, add
   `pod.darvinyi.com → http://localhost:8091`. Set `base_url` to
   `https://pod.darvinyi.com` and re-run `make_feed.py` + `publish.py`.

Switching later is just that `base_url` change plus re-running those two
scripts (the skill does this as step 8 anyway).

---

## Troubleshooting

- **`gh` not authenticated**: `gh auth login` once, then re-run `bootstrap.sh`
  — it'll create and push the repo.
- **First render hangs**: it's downloading model weights from Hugging Face
  (one-time); watch `~/.cache/huggingface`.
- **`espeak-ng not found` at render time**: `/opt/homebrew/bin` isn't on PATH
  in the shell Claude Code uses — add it.
- **`ssh dodoland` asks for a password**: redo step 2a; confirm the NAS user
  allows key auth. If the *name* doesn't resolve, check Tailscale is up and
  MagicDNS is enabled.
- **Paper won't download**: not every litsearch entry has an open PDF; the
  skill falls back to summary-only and says so. For a paywalled paper, drop it
  at `sources/<slug>.pdf` and re-run.
- **rsync "permission denied" on the NAS**: the SSH user must own
  `/volume1/docker/podcast` — `chown -R <user>` it.
- **Phone shows a stale episode list**: the feed's `Cache-Control: no-store`
  should prevent this — confirm with `curl -I .../feed.xml` — then
  pull-to-refresh.
- **Voices hard to tell apart**: widen the pan (`O: -0.4, S: 0.4` in config),
  or pick a more contrasting `guest_voice:` per episode.
- **A term is mispronounced**: respell it phonetically in the script and
  re-render that slug — scripts are the source of truth and are in git.
