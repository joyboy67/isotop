" retour à la ligne après 72 charsj
"set wraplen=72
" longuer des tab : 4 espaces
set tabstop=4
" affiche le mode : insert, visual...
set verbose showmode
" autoindentation
set autoindent
" autoindentation de 4 espaces
set shiftwidth=4 
" Voir la règle de status
set ruler
" numéro de lignes à gauche
"set number
" numéro de la ligne courante en bas
set autoprint 
" scroll leftright
set leftright
" regex etendues
set extended
" recherche incrementale
set searchinc
" montre ce qui match
set showmatch
" une seule edition par fichier
set lock 
" ne pas afficher les caractères de contrôle
set beautify 
" pas de bip
set flash
"print helpful messages (eg, 4 lines yanked)
set report=1
" Voir les commandes avec :tab.  
set cedit=	


"To open in a split :E[dit] file, then ^W to switch between windows, and to set the window height to 20 lines :res[ize] 20.
" RACCOURCIS
" ^M is return : to make it, ctrl-v then return
" paste selected text
map gp :r!xclip -o 
" copy file
map gc :!xclip -i %
" go to the top
map gg 1G
" insert date
map gd :r!date +\%d-\%m-\%Y 
" see file with less
map gv :!less %
" sort file
map gs {!}sort
map gS {!}sort -r
" git shortcuts
map ,; :!git add % && git commit -m "
map ,, :!git push 
" format to 72 char width
map gqip {!}fmt -72 -s -p
" check spell
map go :!aspell -c %
" latex recompile
map tt :w:!pdflatex "%" 
" latex shortcuts
map glit :r!printf "\%s\n\%s\n\%s" "\begin{itemize}" "    \item" "\end{itemize}" 
map glen :r!printf "\%s\n\%s\n\%s" "\begin{enumerate}" "    \item" "\end{enumerate}" 
map glt :r!printf "\%s\n\%s\n" "\begin{tabular}{m{.5\textwidth} m{.5\textwidth}}" "\end{tabular}" 
map glim :r!printf "\%s\n" "\includegraphics[width=.5\textwidth]{foo}" 
" Add # to a block
map gk :s/^/#/ 
