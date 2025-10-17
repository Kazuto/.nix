-- Enhanced phpactor.lua (focused on refactoring, no diagnostics)
return {
  settings = {},
  init_options = {
    ["language_server_phpstan.enabled"] = false,
    ["code_transform.import_globals"] = true,
    ["language_server_psalm.enabled"] = false,
    -- Memory and performance optimizations
    ["indexer.enabled_watchers"] = { "php" },
    ["indexer.exclude_patterns"] = {
      "**/vendor/**",
      "**/node_modules/**",
      "**/build/**",
      "**/storage/**",
      "**/cache/**",
      "**/.git/**",
      "**/phpstan/**",
      "**/*resultCache*",
      "**/*.cache",
      "**/bootstrap/cache/**",
    },
    ["indexer.poll_time"] = 5000,
    ["completion.dedupe"] = true,
    ["completion_worse.snippets"] = false,
    ["worse_reflection.enable_cache"] = false,
  },
  on_attach = function(client, bufnr)
    -- Phpactor handles: renaming, refactoring, code actions
    -- Disable capabilities that Intelephense does better
    client.server_capabilities.completionProvider = false
    client.server_capabilities.hoverProvider = false
    client.server_capabilities.documentSymbolProvider = false
    client.server_capabilities.workspaceSymbolProvider = false
    client.server_capabilities.definitionProvider = false
    client.server_capabilities.declarationProvider = false
    client.server_capabilities.implementationProvider = false
    client.server_capabilities.referencesProvider = false
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false

    -- DISABLE DIAGNOSTICS - Let Intelephense handle all diagnostics
    client.server_capabilities.publishDiagnostics = false

    -- Keep only what phpactor does well
    -- client.server_capabilities.renameProvider = true (keep default)
    -- client.server_capabilities.codeActionProvider = true (keep default)
  end,
}
