#!/bin/sh
gitd=$PWD
# I'll try and make this POSIX
has() {
        case "$(command -v $1 2>/dev/null)" in
                alias*|"") return 1
        esac
}
if ! has go; then
        echo "go missing, using pre-generated mapping.go"
else
        cd discordemojimap || git submodule update --init || echo "git missing!!!" && exit 1
        for i in $(echo "curl wget"); do
                if has $i; then
                        case $i in
                                curl)
                                        curl -LO http://discord.com/assets/b38205c8085075585265.js;;
                                wget)
                                        wget http://discord.com/assets/b38205c8085075585265.js ;;
                        esac
                fi
        done
        go run ./cmd/extractmap -path ./b38205c8085075585265.js
fi
cd ${gitd}
cd discordemojimap || git submodule update --init || echo "git missing!!!" && exit 1
cp mapping.go ${gitd} && cd ${gitd}
if [ $PWD != ${gitd} ]; then
        cd ${gitd} || echo "Can't find git dif!!! failing"; exit 1
fi
sed -e '0,/string/d' -e 's/"//g' -e 's/:[[:space:]]/=/g' -e 's/\\//g' -e 's/,//g' -e 's/\t//g' -e 's/}//g' -e '/^$/d' -e 's/U0001/u1/g' -i ./mapping.go
map=$(pwd)/mapping.go
