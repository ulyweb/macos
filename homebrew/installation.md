Install Homebrew

---

Running the official setup command in your Mac's Terminal

Open Terminal

• Press Command + Space to open Spotlight search.

• Type Terminal and press Enter

Run the Installation Command

• Copy this official install script:
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Paste it into your Terminal window and press Enter

Type your Mac's login password when asked, then press Enter. (Note: Your password characters will not show on the screen as you type them).

Add Homebrew to Your PATH

Next steps section on your screen. On Apple Silicon Macs, you need to run two quick commands to add Homebrew to your shell environment path so your Mac knows where to find the brew command.

Copy and paste the specific echo and eval commands shown at the very bottom of your Terminal installation output. They typically look like this (run them one by one):
```
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
```

Verify the Installation

Type the following command to make sure everything works properly
```
brew --version
```

---

You can install CaskHub by running the following command in your Terminal:
```
brew install --cask caskhub
```




