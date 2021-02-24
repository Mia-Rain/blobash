#!/bin/sh
gitd=$PWD
# Ash breaks with `cd <dir> || exit` So alot of `if` checks happen
has() {
        case "$(command -v "$1" 2>/dev/null)" in
                alias*|"") return 1
        esac
}
cd "${gitd}"
if [ -f ./discordemojimap/mapping.go ]; then cd ./discordemojimap; elif has git; then git submodule update --init && cd ./discordemojimap; else 
	echo "FAIL, git missing, please find your own way to download the submods"; exit 1 # git isn't ""REALLY"" needed, you just have to trick the script into finding the submods
fi
if ! has go; then echo "go missing, using pre-generated mapping.go"; else
	if [ "${update}" != no ]; then
        	for i in curl wget; do
                	if has "$i"; then
                        	case "$i" in
                                	curl)
                                        	curl -LO http://discord.com/assets/b38205c8085075585265.js;;
                                	wget)
                                        	wget http://discord.com/assets/b38205c8085075585265.js ;;
                        	esac
                	fi
        	done
		ls ./b38205c8085075585265* && go run ./cmd/extractmap -path "./$(if [ -f b38205c8085075585265.js.1 ]; then printf 'b38205c8085075585265.js.1'; elif [ -f b38205c8085075585265.js ]; then printf 'b38205c8085075585265.js'; fi)"
	fi
fi
cd "${gitd}"
cp ./discordemojimap/mapping.go ./
if ! has sed; then echo "sed NOT FOUND!!"; exit 1; fi
sed -e '/u/,$!d' -e 's/"//g' -e 's/:[[:space:]]/=/g' -e 's/\\//g' -e 's/,//g' -e 's/\t//g' -e 's/}//g' -e '/^$/d' -i ./mapping.go
while IFS='=' read -r name val; do # Thx Perish :)
	echo ${val}
	if [ ! -f "blobmoji/png/128/emoji_${val}.png" ]; then echo "ERORR: File for ${name} missing or unmapped!!!" >> /dev/stderr; fi # This is what I figure the best way to print to stderr - idk if it's portable though
	printf 'img[alt=":%s:"],li[aria-label^=":%s:"]>div{content:var(--a);background-image:var(--a)!important;--a:url("data:image/png;base64,%s")}\n' "${name}" "${name}" $(base64 blobmoji/png/128/emoji_${val}.png | tr -d '\n')
done < ./mapping.go
