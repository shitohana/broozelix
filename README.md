# Broozelix

**Broozelix** is a minimal yet powerful terminal workspace combining [Helix](https://helix-editor.com/), [Broot](https://github.com/Canop/broot), [bat](https://github.com/sharkdp/bat), and [Zellij](https://zellij.dev) to deliver a fast, keyboard-driven developer experience inspired by **[Yazelix](https://github.com/helix-editor/helix/discussions/2217)**.

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

Here's an updated `README.md` section to include the new installation method using the installation script via GitHub Releases. This assumes the script is hosted as `install.sh` in the GitHub releases section.

---

## 🛠 Installation

You can install **broozelix** with a single command using the provided installation script. No need to clone the repository manually.

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
curl -sSfL https://github.com/<your-org-or-user>/broozelix/releases/latest/download/install.sh | bash -s -- -y -p ~/.config/custom-broozelix
```

If you've previously installed Broozelix, the script will detect it and ask whether to reinstall Helix.

After installation:
- Your original Zellij config will be symlinked into Broozelix.
- A marker file (~/.config/helix/broozelix) will be used to track Broozelix-specific Helix installation.

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
| Ansible Setup       | `ansible/install.yml`   |
| Custom Broot Config | `broot/broozelix.hjson` |
| Zellij Layouts      | `zellij/layouts/`       |
| Zellij Keybinds     | `zellij/config.kdl`     |

---

## 🧪 Usage

After setup:

1. Run Zellij with the `broozelix` layout:

   ```bash
   zellij -l $XDG_CONFIG_HOME/zellij/layouts/broozelix.kdl
   ```
2. Navigate files with Broot (left pane).
3. Open/edit them in Helix (right pane) via `enter` or `create {file}`.
4. Preview files with `F3` using `bat`.

---

## 📁 Structure

```txt
broozelix
├── ansible/                # Automated setup (Rust, Helix, Broot)
├── broot/                  # Custom broot config
├── zellij/                 # Layouts and Zellij config
│   ├── config.kdl
│   └── layouts/
│       ├── broozelix.kdl
│       ├── broot-loop.sh
│       └── helix-loop.sh
└── README.md
```

---

## 🧪 Requirements

* Rust toolchain
* Git

---

## 📜 License

MIT License © 2025