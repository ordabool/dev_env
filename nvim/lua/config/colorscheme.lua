local ok, _ = pcall(vim.cmd, 'colorscheme habamax')
if not ok then
    vim.cmd 'colorscheme default' -- if the above fails, then use default
end
