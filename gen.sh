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
sed -e '0,/string/d' -e 's/"//g' -e 's/:[[:space:]]/=/g' -e 's/\\//g' -e 's/,//g' -e 's/\t//g' -e 's/}//g' -e '/^$/d' -e 's/U0001/u1/g' -i ./mapping.go
map=$(pwd)/mapping.go
