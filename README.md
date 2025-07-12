# Eden's Arch Linux Dotfiles

![Showcase](https://raw.githubusercontent.com/username/repo/main/screenshot.png)
> **Note:** Add a screenshot of your desktop to showcase your setup!

My personal collection of configuration files for Arch Linux, managed with [GNU Stow](https://www.gnu.org/software/stow/). This repository contains everything needed to replicate my customized desktop environment, centered around the Hyprland window manager.

---

## Key Components

This setup provides a complete and cohesive desktop experience using the following key components:

*   **Window Manager:** [Hyprland](https://hyprland.org/) (with extensive custom scripts and animations)
*   **Shell:** [Zsh](https://www.zsh.org/) & [Bash](https://www.gnu.org/software/bash/)
*   **System Info:** [Fastfetch](https://github.com/fastfetch-cli/fastfetch)
*   **Display Manager:** [SDDM](https://github.com/sddm/sddm) (with custom themes)
*   **Version Control:** [Git](https://git-scm.com/)

---

## Installation

These dotfiles are intended for an Arch-based Linux distribution. The installation is automated via a single script.

**1. Clone the repository:**

```bash
git clone https://github.com/your-username/dotfiles.git
cd dotfiles
```

**2. Run the installation script:**

The script will automatically:
*   Install all required packages from the official repositories (`pacman`).
*   Install all required packages from the AUR (`yay`).
*   Symlink the configuration files to the correct locations using `stow`.
*   Copy the SDDM themes to the system directory.

```bash
./install.sh
```

After the script finishes, it is recommended to **reboot** the system for all changes to take effect.

---

## Repository Structure

This repository uses `stow` to manage symlinks. Each top-level directory (e.g., `hypr`, `zsh`, `git`) is a "stow package." The `install.sh` script handles the stowing process automatically.

*   `packages/`: Contains lists of packages to be installed by `pacman` and an AUR helper.
*   `sddm-themes/`: Contains SDDM themes that are copied to `/usr/share/sddm/themes/`.
*   Other directories (`bash`, `hypr`, `git`, etc.): Contain the configuration files that will be symlinked into your home directory.

---

## Customization

Making changes is simple:

1.  **Edit Files:** Modify any file within this repository.
2.  **Restow:** Since the files are symlinked, changes are applied instantly. If you add new files or directories, you may need to run `stow <directory_name>` again or simply re-run the `./install.sh` script.
3.  **Add/Remove Packages:** Edit the `pacman-packages.txt` or `aur-packages.txt` files and re-run the installer to update your system's packages.

---

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
