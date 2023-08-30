local g = vim.g

g.notmuch_folders = {
  { 'Today', 'tag:inbox AND (NOT tag:archive) AND date:today AND (NOT tag:event)' },
  { 'Week', 'tag:inbox AND (NOT tag:archive) AND date:this_week AND (NOT tag:github) AND (NOT tag:event)' },
  { 'Month', 'tag:inbox AND (NOT tag:archive) AND date:this_month AND (NOT tag:github) AND (NOT tag:event)' },
  { 'Github', 'tag:inbox AND tag:github AND (NOT tag:archive)' },
  { 'Events', 'tag:inbox AND tag:event' },
  { 'Inbox', 'tag:inbox' },
  { 'Sent', 'tag:sent' },
  { 'Todo', 'tag:todo' },
  { 'Archive', 'tag:archive' },
  { 'Junk', 'tag:junk' },
}

g.notmuch_custom_folder_maps = {
  [',y'] = 'search("Today")',
  [',w'] = 'search("Week")',
  [',m'] = 'search("Month")',
  [',g'] = 'search("Github")',
  [',a'] = 'search("Archive")',
  [',i'] = 'search("Inbox")',
  c = 'folders()',
  m = 'compose()',
}

g.notmuch_custom_show_maps = {
  A = 'show_tag("-inbox !archive !unread")',
  E = 'show_tag("!todo")',
  c = 'folders()',
  m = 'compose()',
}
g.notmuch_custom_search_maps = {
  c = 'folders()',
}

g.notmuch_reader = 'neomutt -f %s'
