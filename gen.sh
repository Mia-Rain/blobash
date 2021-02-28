#!/bin/sh
gitd=$PWD
# Ash breaks with `cd <dir> || exit` So alot of `if` checks happen
has() {
        case "$(command -v "$1" 2>/dev/null)" in
                alias*|"") return 1
        esac
}
cd "${gitd}"
if ! has sed; then echo "sed NOT FOUND!!"; exit 1; fi
grep "//" mapping.go | sed -e 's/:.*//g' -e 's/[[:blank:]]//g' -e 's/"//g' >> temp1
cat mapping.go | sed -e '/\/\//d' -e '/u/,$!d' -e 's/"//g' -e 's/:[[:space:]]/=/g' -e 's/\\//g' -e 's/,//g' -e 's/\t//g' -e 's/}//g' -e '/^$/d' > temp2
while IFS='=' read -r name val; do # Thx Perish :)
	IFS=''
	printf 'img[alt=":%s:"],li[aria-label^=":%s:"]>div{content:var(--a);background-image:var(--a)!important;--a:url("data:image/png;base64,%s");background-size:contain;object-position: var(--op);--op:-9999px -9999px;}\n' "${name}" "${name}" "$(base64 blobmojis/emoji_${val}.png | tr -d '\n')"
done < ./temp2
rm ./missing
while read -r i; do
	echo "$i CANNOT BE MATCHED" >> ./missing
done < temp1
rm temp1 temp2
