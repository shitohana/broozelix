# Broozelix

![Demo](https://private-user-images.githubusercontent.com/43905117/463053571-9e552748-d371-4c82-b3d2-8d248c4e6cd5.gif?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3NTE4Njg5NTUsIm5iZiI6MTc1MTg2ODY1NSwicGF0aCI6Ii80MzkwNTExNy80NjMwNTM1NzEtOWU1NTI3NDgtZDM3MS00YzgyLWIzZDItOGQyNDhjNGU2Y2Q1LmdpZj9YLUFtei1BbGdvcml0aG09QVdTNC1ITUFDLVNIQTI1NiZYLUFtei1DcmVkZW50aWFsPUFLSUFWQ09EWUxTQTUzUFFLNFpBJTJGMjAyNTA3MDclMkZ1cy1lYXN0LTElMkZzMyUyRmF3czRfcmVxdWVzdCZYLUFtei1EYXRlPTIwMjUwNzA3VDA2MTA1NVomWC1BbXotRXhwaXJlcz0zMDAmWC1BbXotU2lnbmF0dXJlPWJhM2E2MDBmZDMwYjQyMzAxZmRjMzYzMTdmYzc1MWE5NjM4NjMzNTUxYmViMTdlODQ3MWVmNDk1ZDhhZGNkMTEmWC1BbXotU2lnbmVkSGVhZGVycz1ob3N0In0.B5KHOzbA154K9xZm7ZpO_WD_cbsm_9_3GRN7goEpVRk)

**Broozelix** is a minimal yet powerful terminal workspace combining [Helix](https://helix-editor.com/), [Broot](https://github.com/Canop/broot), [bat](https://github.com/sharkdp/bat), and [Zellij](https://zellij.dev) to deliver a fast, keyboard-driven developer experience inspired by **[Yazelix](https://github.com/luccahuguet/yazelix)**.

> **Why Broozelix?**
> Because Helix doesn't yet have a stable or fully-fledged plugin ecosystem, Broozelix builds a robust integration between tools **outside the editor**, using Unix sockets and Zellij as the glue.

---

## ✨ Features

* ⚡️ **Custom Helix Build**
  A fork of Helix is included that adds support for **Unix domain socket** communication, enabling seamless file opening from external tools like Broot.

* 🗂️ **Broot Integration**
  Broot serves as the fast, fuzzy file explorer with custom verbs and shortcuts (like `touch`, `create`, `open-in-helix`) for quick navigation and action.

* 🖼️ **bat for File Preview**
  Broot uses `bat` for colorized previews inside Zellij panes (triggered with `F3`).

* 🧱 **Zellij as Window Manager**
  Zellij handles pane layout, focus switching, and floating plugin UIs with custom keybindings modeled on a tmux/Helix hybrid workflow.

* 🔁 **Tight Loop Scripts**
  Broot and Helix each run in their own auto-restarting loops (`broot-loop.sh`, `helix-loop.sh`) inside named Zellij panes.

---

## 🛠 Installation

You can install **broozelix** with a single command using the provided installation script. **No need to clone the repository manually**.

### ✅ Prerequisites

Ensure the following tools are already installed:

* `cargo`
* `git`

The script will also check for the presence of:

* `zellij`
* `broot`
* `bat`

If they are missing, the script will offer to install them using `cargo`.

### 🔽 Install via Script

Download and run the install script:

```bash
curl -sSfL https://github.com/shitohana/broozelix/releases/latest/download/install.sh | bash
```

Or with arguments

```bash
curl -sSfL https://github.com/shitohana/broozelix/releases/latest/download/install.sh | bash -s -- -y -p ~/.config/custom-broozelix
```

If you've previously installed Broozelix, the script will detect it and ask whether to reinstall Helix.

After installation:

* Your original Zellij config will be symlinked into Broozelix.
* A marker file (~/.config/helix/broozelix) will be used to track Broozelix-specific Helix installation.

Add this alias to your shell config (e.g. .bashrc, .zshrc):

```bash
alias broozelix="~/.config/broozelix/run.sh"
```

### ⚙️ Options

The script supports the following flags:

* `-y`, `--confirm` – Automatically confirm all prompts (non-interactive mode)
* `-p`, `--path PATH` – Custom installation path (default: `$XDG_CONFIG_HOME/broozelix` or `~/.config/broozelix`)
* `-h`, `--help` – Show help message

### 📌 Notes

* The script will **not overwrite** your existing `zellij`, `broot`, or `helix` configs. It appends `broozelix`-specific configurations instead.
* Helix is compiled from source (using a fork with UNIX socket support). Once upstream [PR #13896](https://github.com/helix-editor/helix/pull/13896) is merged, this custom build step may no longer be necessary.

---

## 🧠 Design Rationale

* **Plugin Gap in Helix**:
  As of now, Helix’s plugin system is not stable or actively developed. Broozelix fills this gap by **externalizing extensibility** through UNIX IPC and process orchestration.

* **Inspired by Yazelix**:
  Yazelix showcased a powerful idea of combining Zellij + Helix. Broozelix takes this further by integrating an actively used file navigator (Broot), stable preview tool (bat), and socket-powered workflows.

---

## 🔧 Configuration Overview

| Component           | Path                    |
| ------------------- | ----------------------- |
| Custom Broot Config | `broot/broozelix.hjson` |
| Zellij Layouts      | `zellij/layouts/`       |
| Zellij Keybinds     | `zellij/config.kdl`     |

---

## 🧪 Usage

* Open/edit them in Helix (right pane) via `enter` or `create {file}`.
* Preview files with `F3` using `bat`.
* Open floating terminal with `Ctrl + \`

---

## Developmrnt roadmap

- [x] Openning and closing files in `helix` from `broot`
- [ ] Openning floating terminal ('Ctrl + ')
- [ ] Syncing active helix file in `broot`
- [ ] Single theme selector script
- [ ] More tool windows (like tasks runner)

---

## 📜 License

MIT License, shitohana, 2025
