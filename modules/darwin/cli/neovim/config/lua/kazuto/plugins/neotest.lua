-- Add neotest-pest plugin for running PHP tests.
-- A package is also available for PHPUnit if needed.
--
return {
	"nvim-neotest/neotest",
	dependencies = { "V13Axel/neotest-pest" },
	opts = { adapters = { "neotest-pest" } },
}
