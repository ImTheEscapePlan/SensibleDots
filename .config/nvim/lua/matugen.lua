local M = {}

function M.setup()
    require('base16-colorscheme').setup {
        -- Background tones
        base00 = '#0d0736', -- Default Background
        base01 = '#180f57', -- Lighter Background (status bars)
        base02 = '#140b50', -- Selection Background
        base03 = '#605d72', -- Comments, Invisibles
        -- Foreground tones
        base04 = '#b0afb6', -- Dark Foreground (status bars)
        base05 = '#f2f2f3', -- Default Foreground
        base06 = '#f2f2f3', -- Light Foreground
        base07 = '#f2f2f3', -- Lightest Foreground
        -- Accent colors
        base08 = '#fd4663', -- Variables, XML Tags, Errors
        base09 = '#f8caf2', -- Integers, Constants
        base0A = '#e7caf8', -- Classes, Search Background
        base0B = '#d0caf8', -- Strings, Diff Inserted
        base0C = '#f08ee3', -- Regex, Escape Chars
        base0D = '#9b8ef0', -- Functions, Methods
        base0E = '#cc8ef0', -- Keywords, Storage
        base0F = '#900017', -- Deprecated, Embedded Tags
    }
end

-- Register a signal handler for SIGUSR1 (matugen updates)
local signal = vim.uv.new_signal()
signal:start(
    'sigusr1',
    vim.schedule_wrap(function()
        package.loaded['matugen'] = nil
        require('matugen').setup()
    end)
)

return M
