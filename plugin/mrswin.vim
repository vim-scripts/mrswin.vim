" mrswin.vim: allows one to toggle mswin on and off
" Based On:	<mswin.vim> by Bram Moolenaar
" Author:	Charles E. Campbell, Jr.
" Version:	3
" Date:		Jul 16, 2004
"
" Purpose: {{{1
"   To set options and add mapping such that Vim behaves a lot like MS-Windows
"   To unset options and remove mappings such that Vim behaves normally
"   Replaces <vim--/mswin.vim>.
"
" Usage: {{{1
"   Just source the file in to toggle the behavior between Windows-style
"   (mswin) behavior and normal Vim-style (non-Windows) behavior
"
"   :so mrswin.vim
"
" Installation: {{{1
" 	Copy <mrswin.vim> over your <mswin.vim> file.  <Mrswin.vim> normally
" 	behaves just like <mswin.vim>, in fact, it is based on <mswin.vim>.
"
"
" History: {{{1
"  3: 07/16/04 : Uses has("gui_running") rather than merely has("gui")
"                 to decide whether or not to make meta-space available
"                MrsWin_Paste() updated to 6.3's mswin's Paste()
"                Folding and debugging commands were added; to do
""                debugging, get Decho.vim from
"                 http://vim.sourceforge.net/scripts/script.php?script_id=120
"  2: 03/27/03 : bugfixes (maps are now properly restored/removed)
"                Options are now stored using script variables rather
"                than global ones to reduce namespace use
"  1: 02/17/02 : mrswin.vim first released

" ---------------------------------------------------------------------
" Initialization: {{{1
" set the 'cpoptions' to its Vim default
if 1	" only do this when compiled with expression evaluation
  let s:save_cpo = &cpoptions
endif
set cpo&vim

if !exists("g:mrswin_restoremap")
 let g:mrswin_restoremap= ""
endif
if !exists("g:mrswin_loaded")
 let g:mrswin_loaded= 1
else
 let g:mrswin_loaded= 2
endif

" ---------------------------------------------------------------------
if !exists("g:mrswin")
 " Initial loading of <mrswin.vim>
 let g:mrswin= 0
 call Decho("initial loading of <mrswin.vim>")

" ---------------------------------------------------------------------
"  Loading Mrswin: {{{1
 if g:mrswin_loaded == 1
  " SaveMap: this function sets up a buffer-variable (g:mrswin_restoremap)
  "          which will be used to restore user maps
  "          mapchx: either <something>  which is handled as one map item
  "                  or a string of single letters which are multiple maps
  "                  ex.  mapchx="abc" and maplead='\': \a \b and \c are saved
  fun! MrsWin_SaveMap(mapmode,maplead,mapchx)
    call Dfunc("MrsWin_SaveMap(mapmode<".a:mapmode."> maplead<".a:maplead."> mapchx<".a:mapchx.">)")
    if strpart(a:mapchx,0,1) == '<'
      " save single map <something>
      if maparg(a:mapchx,a:mapmode) != ""
        let g:mrswin_restoremap= a:mapmode."map ".a:mapchx." ".maparg(a:mapchx,a:mapmode)."|".g:mrswin_restoremap
        exe a:mapmode."unmap ".a:mapchx
       endif
    else
      " save multiple maps
      let i= 1
      while i <= strlen(a:mapchx)
       let amap=a:maplead.strpart(a:mapchx,i-1,1)
       if maparg(amap,a:mapmode) != ""
        let g:mrswin_restoremap= a:mapmode."map ".amap." ".maparg(amap,a:mapmode)."|".g:mrswin_restoremap
        exe a:mapmode."unmap ".amap
       endif
       let i= i + 1
      endwhile
    endif
    call Dret("MrsWin_SaveMap")
  endfun
 endif
endif

" ---------------------------------------------------------------------
"  Reloading MrsWin: {{{2
if g:mrswin == 0 " Turn mswin mode on
 call Decho("reloading <MrsWin.vim>")
 let g:mrswin= 1

 " Option keeping: {{{2
 let s:keep_selection   = &selection
 let s:keep_selectmode  = &selectmode
 let s:keep_mousemodel  = &mousemodel
 let s:keep_keymodel    = &keymodel
 let s:keep_backspace   = &backspace
 let s:keep_whichwrap   = &whichwrap
 let s:keep_virtualedit = &virtualedit
 let s:keep_guioptions  = &guioptions

 " Save previous settings of maps: {{{2
 call MrsWin_SaveMap("n","","<C-A>")
 call MrsWin_SaveMap("n","","<C-F4>")
 call MrsWin_SaveMap("n","","<C-Q>")
 call MrsWin_SaveMap("n","","<C-S>")
 call MrsWin_SaveMap("n","","<C-Tab>")
 call MrsWin_SaveMap("n","","<C-V>")
 call MrsWin_SaveMap("n","","<C-Y>")
 call MrsWin_SaveMap("n","","<C-Z>")
 call MrsWin_SaveMap("n","","<M-Space>")
 call MrsWin_SaveMap("n","","<S-Insert>")
 call MrsWin_SaveMap("c","","<C-A>")
 call MrsWin_SaveMap("c","","<C-F4>")
 call MrsWin_SaveMap("c","","<C-Tab>")
 call MrsWin_SaveMap("c","","<C-V>")
 call MrsWin_SaveMap("c","","<M-Space>")
 call MrsWin_SaveMap("c","","<S-Insert>")
 call MrsWin_SaveMap("i","","<C-A>")
 call MrsWin_SaveMap("i","","<C-F4>")
 call MrsWin_SaveMap("i","","<C-S>")
 call MrsWin_SaveMap("i","","<C-Tab>")
 call MrsWin_SaveMap("i","","<C-V>")
 call MrsWin_SaveMap("i","","<C-Y>")
 call MrsWin_SaveMap("i","","<C-Z>")
 call MrsWin_SaveMap("i","","<M-Space>")
 call MrsWin_SaveMap("i","","<S-Insert>")
 call MrsWin_SaveMap("v","","<BS>")
 call MrsWin_SaveMap("v","","<C-C>")
 call MrsWin_SaveMap("v","","<C-Insert>")
 call MrsWin_SaveMap("v","","<C-S>")
 call MrsWin_SaveMap("v","","<C-V>")
 call MrsWin_SaveMap("v","","<C-X>")
 call MrsWin_SaveMap("v","","<S-Del>")
 call MrsWin_SaveMap("v","","<S-Insert>")
 call MrsWin_SaveMap("v","","<C-Z>")
 call MrsWin_SaveMap("o","","<C-Z>")
 call MrsWin_SaveMap("v","","<C-Y>")
 call MrsWin_SaveMap("o","","<C-Y>")

 " ---------------------------------------------------------------------
 "  (Paste() -> MrsWinPaste() due to script visibility)
 "  MSWIN begins here... {{{2

 " set 'selection', 'selectmode', 'mousemodel' and 'keymodel' for MS-Windows
 behave mswin

 " backspace and cursor keys wrap to previous/next line
 set backspace=indent,eol,start whichwrap+=<,>,[,]

 " backspace in Visual mode deletes selection
 vnoremap <BS> d

 " CTRL-X and SHIFT-Del are Cut
 vnoremap <C-X> "+x
 vnoremap <S-Del> "+x

 " CTRL-C and CTRL-Insert are Copy
 vnoremap <C-C> "+y
 vnoremap <C-Insert> "+y

 " CTRL-V and SHIFT-Insert are Paste
 map <C-V>	"+gP
 map <S-Insert>	"+gP

 cmap <C-V>		<C-R>+
 cmap <S-Insert>	<C-R>+

 " Pasting blockwise and linewise selections is not possible in Insert and
 " Visual mode without the +virtualedit feature.  They are pasted as if they
 " were characterwise instead.
 if has("virtualedit")
   nnoremap <silent> MrsWin_Paste :call MrsWin_Paste()<CR>
   if g:mrswin_loaded == 1
    fun! MrsWin_Paste()
      let ove = &ve
      set ve=all
      normal `^
      if @+ != ''
        normal "+gP
      endif
      let c = col(".")
      normal i
      if col(".") < c	" compensate for i<ESC> moving the cursor left
        normal l
      endif
      let &ve = ove
    endfun
   endif
   inoremap <script> <C-V>	x<BS><Esc><SID>MrsWin_Pastegi
   vnoremap <script> <C-V>	"-c<Esc><SID>MrsWin_Paste
 else
  nnoremap <silent> <SID>MrsWin_Paste	"=@+.'xy'<CR>gPFx"_2x
  inoremap <script> <C-V>		x<Esc><SID>MrsWin_Paste"_s
  vnoremap <script> <C-V>		"-c<Esc>gix<Esc><SID>MrsWin_Paste"_x
 endif
 imap <S-Insert>			<C-V>
 vmap <S-Insert>			<C-V>

 " Use CTRL-Q to do what CTRL-V used to do
 noremap <C-Q>		<C-V>

 " Use CTRL-S for saving, also in Insert mode
 noremap <C-S>		:update<CR>
 vnoremap <C-S>		<C-C>:update<CR>
 inoremap <C-S>		<C-O>:update<CR>

 " For CTRL-V to work autoselect must be off.
 " On Unix we have two selections, autoselect can be used.
 if !has("unix")
   set guioptions-=a
 endif

 " CTRL-Z is Undo; not in cmdline though
 noremap <C-Z> u
 inoremap <C-Z> <C-O>u

 " CTRL-Y is Redo (although not repeat); not in cmdline though
 noremap <C-Y> <C-R>
 inoremap <C-Y> <C-O><C-R>

 " Alt-Space is System menu
 if has("gui_running")
   noremap  <M-Space> :simalt ~<CR>
   inoremap <M-Space> <C-O>:simalt ~<CR>
   cnoremap <M-Space> <C-C>:simalt ~<CR>
 endif

 " CTRL-A is Select all
 noremap <C-A> gggH<C-O>G
 inoremap <C-A> <C-O>gg<C-O>gH<C-O>G
 cnoremap <C-A> <C-C>gggH<C-O>G

 " CTRL-Tab is Next window
 noremap <C-Tab> <C-W>w
 inoremap <C-Tab> <C-O><C-W>w
 cnoremap <C-Tab> <C-C><C-W>w

 " CTRL-F4 is Close window
 noremap <C-F4> <C-W>c
 inoremap <C-F4> <C-O><C-W>c
 cnoremap <C-F4> <C-C><C-W>c

 " MSWIN ends here
 " ---------------------------------------------------------------------

else " -----------------------------------------------------------------
 " Unloading Mrswin: {{{1
 call Decho("unloading MrsWin.vim")
 let g:mrswin= 0

 " Option Restoration: {{{2
 let &selection   = s:keep_selection
 let &selectmode  = s:keep_selectmode
 let &mousemodel  = s:keep_mousemodel
 let &keymodel    = s:keep_keymodel
 let &backspace   = s:keep_backspace
 let &whichwrap   = s:keep_whichwrap
 let &virtualedit = s:keep_virtualedit
 let &guioptions  = s:keep_guioptions

 " Unmapping: {{{2
 unmap  <BS>
 unmap  <C-A>
 unmap  <C-C>
 unmap  <C-F4>
 unmap  <C-Insert>
 unmap  <C-Q>
 unmap  <C-S>
 unmap  <C-Tab>
 unmap  <C-V>
 unmap  <C-X>
 unmap  <C-Y>
 unmap  <C-Z>
 unmap  <S-Del>
 unmap  <S-Insert>
 if has("gui_running")
  unmap <M-Space>
 endif

" ---------------------------------------------------------------------
 " Map Restoration: {{{2
 if exists("g:mrswin_restoremap")
  if g:mrswin_restoremap != ""
   exe g:mrswin_restoremap
   unlet g:mrswin_restoremap
  endif
 endif

endif

" ---------------------------------------------------------------------
" Restore cpoptions: {{{2
set cpo&
if 1
  let &cpoptions = s:save_cpo
  unlet s:save_cpo
endif
" ---------------------------------------------------------------------
" vim: ts=8 fdm=marker
