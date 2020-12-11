#!/bin/sh
gitd=$PWD
# I'll try and make this POSIX
# Ash breaks with `cd <dir> || exit`
# So alot of `if` checks happen

has() {
        case "$(command -v $1 2>/dev/null)" in
                alias*|"") return 1
        esac
}
cd "${gitd}"
if ! has go; then
        echo "go missing, using pre-generated mapping.go"
else
        if [ -d ./discordemojimap ]; then 
		cd ./discordemojimap
	else
		git submodule update --init && cd ./discordemojimap
	fi
	if [ ${update} != no ]; then
        	for i in $(echo "curl wget"); do
                	if has "$i"; then
                        	case "$i" in
                                	curl)
                                        	curl -LO http://discord.com/assets/b38205c8085075585265.js;;
                                	wget)
                                        	wget http://discord.com/assets/b38205c8085075585265.js ;;
                        	esac
                	fi
        	done
	fi
        go run ./cmd/extractmap -path ./$(if [ -f b38205c8085075585265.js.1 ]; then printf 'b38205c8085075585265.js.1'; else printf 'b38205c8085075585265.js'; fi)
fi
cd ${gitd} 
if [ -d ./discordemojimap ]; then                
                cd ./discordemojimap                     
else                                             
                git submodule update --init && cd ./discordemojimap
fi  
cp mapping.go "${gitd}" && cd "${gitd}"
if [ "$PWD" != "${gitd}" ]; then
	if [ -d ${gitd} ];then  
        	cd ${gitd} 
	else
		echo "blobash folder missing???" 
		exit 1
	fi
fi
sed -e '/u/,$!d' -e '0,/string/d' -e 's/"//g' -e 's/:[[:space:]]/=/g' -e '0,/{$/d' -e 's/\\ufe0f//g' -e 's/\\//g' -e 's/,//g' -e 's/u200d/_200d/g' -e 's/\t//g' -e 's/}//g' -e '/^$/d' -e 's/U0001/u1/' -e 's/U0001/_1/g' -i ./mapping.go
map=$(pwd)/mapping.go
sed 's/=.*/=/g' ${map} > map-names
sed 's/=.*//g' ./map-names | while read p; do
	printf 'img[alt=":%s:"],li[aria-label^=":%s:"]>div{content:var(--a);background-image:var(--a)!important;--a:url("data:image/png;base64,%s")}\n' "${p}" "${p}" $(base64 blobmoji/png/128/emoji_$(grep -w "${p}" ${map} | sed 's/.*=//g').png | tr -d '\n')
			## Theres meant to be another case here, but it requires somehow turning the escapes into actual emojis, and i have 0 idea how to do that
			## So for now this ""SHOULD"", work, but this is just a PoC
										## golang shouldn't be used for generating things...
done
