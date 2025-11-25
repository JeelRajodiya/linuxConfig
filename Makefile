STOW_DIR := dotfiles
TARGET := $(HOME)
PACKAGES := bash zsh vim ripgrep fastfetch kitty nvim starship television tmux work yazi scripts kde

all: stow

stow:
	stow -d $(STOW_DIR) -t $(TARGET) $(PACKAGES)

delete:
	stow -D -d $(STOW_DIR) -t $(TARGET) $(PACKAGES)

restow: delete stow

.PHONY: all stow delete restow
