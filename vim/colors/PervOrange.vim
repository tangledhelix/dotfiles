" Vim color file
" Converted from Textmate theme Perv Orange using Coloration v0.3.3 (http://github.com/sickill/coloration)

set background=dark
highlight clear

if exists("syntax_on")
  syntax reset
endif

let g:colors_name = "PervOrange"

hi Cursor ctermfg=234 ctermbg=15 cterm=NONE guifg=#211e1e guibg=#ffffff gui=NONE
hi Visual ctermfg=NONE ctermbg=24 cterm=NONE guifg=NONE guibg=#253b76 gui=NONE
hi CursorLine ctermfg=NONE ctermbg=236 cterm=NONE guifg=NONE guibg=#343131 gui=NONE
hi CursorColumn ctermfg=NONE ctermbg=236 cterm=NONE guifg=NONE guibg=#343131 gui=NONE
hi ColorColumn ctermfg=NONE ctermbg=236 cterm=NONE guifg=NONE guibg=#343131 gui=NONE
hi LineNr ctermfg=240 ctermbg=235 cterm=NONE guifg=#807e7e guibg=#282424 gui=NONE
hi VertSplit ctermfg=240 ctermbg=NONE cterm=NONE guifg=#585656 guibg=NONE gui=NONE
hi MatchParen ctermfg=208 ctermbg=NONE cterm=underline guifg=#ff7f00 guibg=NONE gui=underline
hi StatusLine ctermfg=253 ctermbg=240 cterm=bold guifg=#dedede guibg=#585656 gui=bold
hi StatusLineNC ctermfg=253 ctermbg=240 cterm=NONE guifg=#dedede guibg=#585656 gui=NONE
hi Pmenu ctermfg=69 ctermbg=NONE cterm=NONE guifg=#6680ff guibg=NONE gui=NONE
hi PmenuSel ctermfg=NONE ctermbg=24 cterm=NONE guifg=NONE guibg=#253b76 gui=NONE
hi IncSearch ctermfg=234 ctermbg=107 cterm=NONE guifg=#211e1e guibg=#8f9d6a gui=NONE
hi Search ctermfg=NONE ctermbg=NONE cterm=underline guifg=NONE guibg=NONE gui=underline
hi Directory ctermfg=190 ctermbg=NONE cterm=NONE guifg=#dcf000 guibg=NONE gui=NONE
hi Folded ctermfg=59 ctermbg=234 cterm=NONE guifg=#5f5a60 guibg=#211e1e gui=NONE

hi Normal ctermfg=253 ctermbg=234 cterm=NONE guifg=#dedede guibg=#211e1e gui=NONE
hi Boolean ctermfg=106 ctermbg=NONE cterm=NONE guifg=#7ca600 guibg=NONE gui=NONE
hi Character ctermfg=190 ctermbg=NONE cterm=NONE guifg=#dcf000 guibg=NONE gui=NONE
hi Comment ctermfg=59 ctermbg=NONE cterm=NONE guifg=#5f5a60 guibg=NONE gui=italic
hi Conditional ctermfg=208 ctermbg=NONE cterm=NONE guifg=#ff7f00 guibg=NONE gui=NONE
hi Constant ctermfg=148 ctermbg=NONE cterm=NONE guifg=#ace600 guibg=NONE gui=NONE
hi Define ctermfg=208 ctermbg=NONE cterm=NONE guifg=#ff7f00 guibg=NONE gui=NONE
hi DiffAdd ctermfg=253 ctermbg=64 cterm=bold guifg=#dedede guibg=#45810b gui=bold
hi DiffDelete ctermfg=88 ctermbg=NONE cterm=NONE guifg=#8a0606 guibg=NONE gui=NONE
hi DiffChange ctermfg=253 ctermbg=23 cterm=NONE guifg=#dedede guibg=#213453 gui=NONE
hi DiffText ctermfg=253 ctermbg=24 cterm=bold guifg=#dedede guibg=#204a87 gui=bold
hi ErrorMsg ctermfg=15 ctermbg=221 cterm=NONE guifg=#ffffff guibg=#fdca49 gui=NONE
hi WarningMsg ctermfg=15 ctermbg=221 cterm=NONE guifg=#ffffff guibg=#fdca49 gui=NONE
hi Float ctermfg=148 ctermbg=NONE cterm=NONE guifg=#ace600 guibg=NONE gui=NONE
hi Function ctermfg=202 ctermbg=NONE cterm=NONE guifg=#ff4000 guibg=NONE gui=NONE
hi Identifier ctermfg=221 ctermbg=NONE cterm=NONE guifg=#fdca49 guibg=NONE gui=italic
hi Keyword ctermfg=208 ctermbg=NONE cterm=NONE guifg=#ff7f00 guibg=NONE gui=NONE
hi Label ctermfg=107 ctermbg=NONE cterm=NONE guifg=#8f9d6a guibg=NONE gui=NONE
hi NonText ctermfg=59 ctermbg=NONE cterm=NONE guifg=#3b3a32 guibg=NONE gui=NONE
hi Number ctermfg=148 ctermbg=NONE cterm=NONE guifg=#ace600 guibg=NONE gui=NONE
hi Operator ctermfg=208 ctermbg=NONE cterm=NONE guifg=#ff7f00 guibg=NONE gui=NONE
hi PreProc ctermfg=208 ctermbg=NONE cterm=NONE guifg=#ff7f00 guibg=NONE gui=NONE
hi Special ctermfg=253 ctermbg=NONE cterm=NONE guifg=#dedede guibg=NONE gui=NONE
hi SpecialKey ctermfg=59 ctermbg=236 cterm=NONE guifg=#3b3a32 guibg=#343131 gui=NONE
hi Statement ctermfg=208 ctermbg=NONE cterm=NONE guifg=#ff7f00 guibg=NONE gui=NONE
hi StorageClass ctermfg=221 ctermbg=NONE cterm=NONE guifg=#fdca49 guibg=NONE gui=italic
hi String ctermfg=107 ctermbg=NONE cterm=NONE guifg=#8f9d6a guibg=NONE gui=NONE
hi Tag ctermfg=202 ctermbg=NONE cterm=NONE guifg=#ff6a00 guibg=NONE gui=NONE
hi Title ctermfg=253 ctermbg=NONE cterm=bold guifg=#dedede guibg=NONE gui=bold
hi Todo ctermfg=59 ctermbg=NONE cterm=inverse,bold guifg=#5f5a60 guibg=NONE gui=inverse,bold,italic
hi Type ctermfg=69 ctermbg=NONE cterm=NONE guifg=#6680ff guibg=NONE gui=NONE
hi Underlined ctermfg=NONE ctermbg=NONE cterm=underline guifg=NONE guibg=NONE gui=underline
hi rubyClass ctermfg=208 ctermbg=NONE cterm=NONE guifg=#ff7f00 guibg=NONE gui=NONE
hi rubyFunction ctermfg=202 ctermbg=NONE cterm=NONE guifg=#ff4000 guibg=NONE gui=NONE
hi rubyInterpolationDelimiter ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi rubySymbol ctermfg=190 ctermbg=NONE cterm=NONE guifg=#dcf000 guibg=NONE gui=NONE
hi rubyConstant ctermfg=147 ctermbg=NONE cterm=NONE guifg=#a6a6ff guibg=NONE gui=italic
hi rubyStringDelimiter ctermfg=107 ctermbg=NONE cterm=NONE guifg=#8f9d6a guibg=NONE gui=NONE
hi rubyBlockParameter ctermfg=179 ctermbg=NONE cterm=NONE guifg=#e5a373 guibg=NONE gui=NONE
hi rubyInstanceVariable ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi rubyInclude ctermfg=208 ctermbg=NONE cterm=NONE guifg=#ff7f00 guibg=NONE gui=NONE
hi rubyGlobalVariable ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi rubyRegexp ctermfg=107 ctermbg=NONE cterm=NONE guifg=#8f9d6a guibg=NONE gui=NONE
hi rubyRegexpDelimiter ctermfg=107 ctermbg=NONE cterm=NONE guifg=#8f9d6a guibg=NONE gui=NONE
hi rubyEscape ctermfg=190 ctermbg=NONE cterm=NONE guifg=#dcf000 guibg=NONE gui=NONE
hi rubyControl ctermfg=208 ctermbg=NONE cterm=NONE guifg=#ff7f00 guibg=NONE gui=NONE
hi rubyClassVariable ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi rubyOperator ctermfg=208 ctermbg=NONE cterm=NONE guifg=#ff7f00 guibg=NONE gui=NONE
hi rubyException ctermfg=208 ctermbg=NONE cterm=NONE guifg=#ff7f00 guibg=NONE gui=NONE
hi rubyPseudoVariable ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi rubyRailsUserClass ctermfg=147 ctermbg=NONE cterm=NONE guifg=#a6a6ff guibg=NONE gui=italic
hi rubyRailsARAssociationMethod ctermfg=196 ctermbg=NONE cterm=NONE guifg=#ff2211 guibg=NONE gui=NONE
hi rubyRailsARMethod ctermfg=196 ctermbg=NONE cterm=NONE guifg=#ff2211 guibg=NONE gui=NONE
hi rubyRailsRenderMethod ctermfg=196 ctermbg=NONE cterm=NONE guifg=#ff2211 guibg=NONE gui=NONE
hi rubyRailsMethod ctermfg=196 ctermbg=NONE cterm=NONE guifg=#ff2211 guibg=NONE gui=NONE
hi erubyDelimiter ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi erubyComment ctermfg=59 ctermbg=NONE cterm=NONE guifg=#5f5a60 guibg=NONE gui=italic
hi erubyRailsMethod ctermfg=196 ctermbg=NONE cterm=NONE guifg=#ff2211 guibg=NONE gui=NONE
hi htmlTag ctermfg=69 ctermbg=NONE cterm=NONE guifg=#6680ff guibg=NONE gui=NONE
hi htmlEndTag ctermfg=69 ctermbg=NONE cterm=NONE guifg=#6680ff guibg=NONE gui=NONE
hi htmlTagName ctermfg=69 ctermbg=NONE cterm=NONE guifg=#6680ff guibg=NONE gui=NONE
hi htmlArg ctermfg=69 ctermbg=NONE cterm=NONE guifg=#6680ff guibg=NONE gui=NONE
hi htmlSpecialChar ctermfg=190 ctermbg=NONE cterm=NONE guifg=#dcf000 guibg=NONE gui=NONE
hi javaScriptFunction ctermfg=221 ctermbg=NONE cterm=NONE guifg=#fdca49 guibg=NONE gui=italic
hi javaScriptRailsFunction ctermfg=196 ctermbg=NONE cterm=NONE guifg=#ff2211 guibg=NONE gui=NONE
hi javaScriptBraces ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi yamlKey ctermfg=202 ctermbg=NONE cterm=NONE guifg=#ff6a00 guibg=NONE gui=NONE
hi yamlAnchor ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi yamlAlias ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi yamlDocumentHeader ctermfg=107 ctermbg=NONE cterm=NONE guifg=#8f9d6a guibg=NONE gui=NONE
hi cssURL ctermfg=179 ctermbg=NONE cterm=NONE guifg=#e5a373 guibg=NONE gui=NONE
hi cssFunctionName ctermfg=196 ctermbg=NONE cterm=NONE guifg=#ff2211 guibg=NONE gui=NONE
hi cssColor ctermfg=148 ctermbg=NONE cterm=NONE guifg=#ace600 guibg=NONE gui=NONE
hi cssPseudoClassId ctermfg=208 ctermbg=NONE cterm=NONE guifg=#ff7f00 guibg=NONE gui=NONE
hi cssClassName ctermfg=208 ctermbg=NONE cterm=NONE guifg=#ff7f00 guibg=NONE gui=NONE
hi cssValueLength ctermfg=148 ctermbg=NONE cterm=NONE guifg=#ace600 guibg=NONE gui=NONE
hi cssCommonAttr ctermfg=190 ctermbg=NONE cterm=NONE guifg=#dcf000 guibg=NONE gui=NONE
hi cssBraces ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
