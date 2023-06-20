setlocal spell

syntax enable
syntax match GPT /^GPT:/ containedin=ALL
syntax match GPT /^>/ containedin=ALL
syntax match GPT /^>>/ containedin=ALL
hi link GPT TODO
