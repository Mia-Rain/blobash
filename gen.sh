#!/bin/sh
gitd=$PWD
has() {
  case "$(command -v "$1" 2>/dev/null)" in
    alias*|"") return 1
  esac
}
shcat(){
  out="$(while read -r p; do
    IFS=""; echo "$p"
  done <&0)"
  IFS=""; echo "$out"
}
grep "//" mapping.go | sed -e 's/:.*//g' -e 's/[[:blank:]]//g' -e 's/"//g' >> temp1
shcat < mapping.go | sed -e '/\/\//d' -e '/u/,$!d' -e 's/"//g' -e 's/:[[:space:]]/=/g' -e 's/\\//g' -e 's/,//g' -e 's/\t//g' -e 's/}//g' -e '/^$/d' > temp2
while IFS='=' read -r name val; do # Thx Perish :)
	IFS=''
  printf 'img[alt=":%s:"],li[aria-label^=":%s:"]>div{content:var(--a);background-image:var(--a)!important;--a:url("data:image/png;base64,%s");background-size:contain;object-position: var(--op);--op:-9999px -9999px;}\n' "${name}" "${name}" "$(base64 blobmoji/png/128/emoji_${val}.png | while read -r p; do IFS=""; printf "$p"; done)"
done < ./temp2
rm temp1 temp2
