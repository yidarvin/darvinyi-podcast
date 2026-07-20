# darvinyi-podcast

Podcast pipeline: litsearch.darvinyi.com entries + the original papers →
three-speaker scripts (AI-optimist host, AI-skeptic host, guest scholar;
Claude writes them) → MP3 (Kokoro TTS on the Mac mini, stereo-panned) →
public RSS feed on dodoland behind Cloudflare Tunnel.

- Machinery lives in the portable skill: `~/.claude/skills/litsearch-podcast/`
- This repo holds content + config: `config.yaml`, `queue.md`, `scripts/`
- `audio/`, `sources/`, `feed.xml` are derived and gitignored
- NAS server: `nas/setup-nas.sh` (run on dodoland; serves the feed over Tailscale)
- Batch: `./run.sh` (one fresh Claude invocation per episode)
- Home: GitHub (`yidarvin/darvinyi-podcast`). First-time install is automated —
  hand the kit to Claude Code and run `bootstrap.sh`; see SETUP.md.
