return {
  "williamboman/mason.nvim",
  opts = {
    ensure_installed = {
      "stylua",
      "shellcheck",
      "shfmt",
      "flake8",
      "sonarlint-language-server",
      "terraform-ls",
      "isort",
      "black",
    },
  },
}
