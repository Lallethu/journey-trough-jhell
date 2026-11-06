# Journey Trough Jhell

> By day, a candy village. By dusk, the world have to face Jhell.

A small day/night survival game made for LÖVE Jam 2026 [B-Side](https://itch.io/jam/lve-jam-2026-b-side).

Theme: **Jelly**.

## Play

- Web: [Journey Trough Jhell](https://lallethu.itch.io/journey-trough-jhell)
- Desktop: download `journey-trough-jhell.love` and run it with LÖVE 11.5

## Controls

| Phase | Key | Action |
| --- | --- | --- |
| Day | Arrows / WASD | Move |
| Day | E | Interact |
| Night | Space | Attack |
| Night | Q | Place wall |

## How to play

Spend the day gathering sugar and hardening the village. When dusk
falls, the jelly comes out. Survive the nights.

## Content notice

Cartoon creature violence only. No mature content.

## Development

- LÖVE 11.5, LuaJIT
- Run: `love .` (or `Ctrl+Shift+B` in VS Code)
- Build: see `.vscode/tasks.json`
- Structure: `src/core` (generic tools), `src/states` (phase FSM),
  `src/world` (entities), `src/systems` (event listeners), `src/data` (tuning)

## Credits

- Code, art, design: Lallethu (me, hehe)
- Framework: by the amazing people at [Love2D](https://love2d.org/), and [Love2D Github](https://github.com/love2d/love)

## License

Code: MIT. Art and audio: CC BY-NC 4.0.
