local themes = {}
function themes.get_dropdown(opts)
  opts = opts or {}
  local theme_opts = {
    winblend = 0;
    width = 0.8;
    show_line = false;
    prompt_prefix = 'Files>';
    prompt_title = '';
    results_title = '';
    preview_title = '';
    borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰'};
    set_env = { ['COLORTERM'] = 'truecolor' };
  }
  return vim.tbl_deep_extend("force", theme_opts, opts)
end
return themes
