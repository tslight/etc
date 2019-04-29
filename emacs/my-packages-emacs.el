(use-package linum
  :defer t
  :hook
  (prog-mode . linum-mode)
  (shell-script-mode . linum-mode)
  (sh-mode . linum-mode))
