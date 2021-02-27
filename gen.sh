#!/bin/sh
gitd=$PWD
# Ash breaks with `cd <dir> || exit` So alot of `if` checks happen
has() {
        case "$(command -v "$1" 2>/dev/null)" in
                alias*|"") return 1
        esac
}
cd "${gitd}"
if [ ! -f ./discordemojimap/mapping.go ]; then if has git; then git submodule update --init; else echo "FAIL, git missing, please find your own way to download the submods"; exit 1;fi;fi
# git isn't ""REALLY"" needed, you just have to trick the script into finding the submods
cp ./discordemojimap/mapping.go ./
if ! has sed; then echo "sed NOT FOUND!!"; exit 1; fi
sed -e '/\/\//d' -e '/u/,$!d' -e 's/"//g' -e 's/:[[:space:]]/=/g' -e 's/\\//g' -e 's/,//g' -e 's/\t//g' -e 's/}//g' -e '/^$/d' -i ./mapping.go
while IFS='=' read -r name val; do # Thx Perish :)
	IFS=''
	printf 'img[alt=":%s:"],li[aria-label^=":%s:"]>div{content:var(--a);background-image:var(--a)!important;--a:url("data:image/png;base64,%s");background-size:contain;object-position: var(--op);--op:-9999px -9999px;}\n' "${name}" "${name}" "$(base64 blobmoji/png/128/emoji_${val}.png | tr -d '\n')"
done < ./mapping.go
grep "//" ./discordemojimap/mapping.go | sed -e 's/:.*//g' -e 's/[[:blank:]]//g' -e 's/"//g' >> temp1
while read -r i; do
	echo "$i CANNOT BE MATCHED" >> ./missing
done < temp1
rm temp1
