local function load_module(name)
  return function()
    require(name)
  end
end
return
{
  pickers = {
    git = load_module('nvim-fzf.pickers.git'),
    colors = load_module('nvim-fzf.pickers.colors')
  }
}
