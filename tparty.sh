#!/usr/bin/env zsh
# Preferably run with zsh
# A simulation of 'translation party'
# Requires 'termit'. To install: gem install termit

function rlang() {
	echo -e "de\njp\nfr\nno\nnl\nse\nru\nzh\nla\nit\nes\npl" | sort -R | head -n 1
}

LC_ALL=c
fromlang='en'
tolang='ja'
maxiter=23	# If we don't have agreement between two iterations by this point, just keep our last iteration
tr -d '\r' | fmt | while read line ; do
	tolang=$(rlang)
	i=maxiter
	old=$line 
	new="$(termit $tolang $fromlang "$(termit $fromlang $tolang "$old" | sed 's/^=> //' )" | sed 's/^=> //')"
	while [[ "$old" != "$new" ]] ; do
		if ( [[ $i -lt 1 ]] || [[ $(echo $new | wc -c) -gt 1023 ]] ) ; then 
			old=$new
		else
			i=$((i-1))
			old=$new
			new="$(termit $tolang $fromlang "$(termit $fromlang $tolang "$old" | sed 's/^=> //'  )" | sed 's/^=> //;s/\\\\*//g;' )"
		fi
	done
	echo "$new" | sed 's/\\\\*//g'
done 

