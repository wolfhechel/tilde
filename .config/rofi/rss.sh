#!/bin/sh

declare -A feeds=(
    [Dagens Nyheter]="http://www.dn.se/nyheter/m/rss/"
    [SVT]="http://www.svt.se/nyheter/rss.xml"
    [Aftonbladet]="http://www.aftonbladet.se/rss.xml"
    [Expressen]="http://expressen.se/rss/nyheter"
    [Sydsvenskan]="http://www.sydsvenskan.se/rss.xml?latest"
    [Blankspot]="http://blankspot.se/feed/"
)

xmlgetnext() {
    local IFS='>'
    read -d '<' TAG VALUE
}

open() {
    url="$@"

    coproc ( xdg-open "$url" & > /dev/null 2>&1 )
}

read_feed() {
    key="$@"
    url="${feeds[$key]}"

    echo -en "\0message\x1f$key\n"
    echo -en "\0no-custom\x1ftrue\n"
    echo -en "...\0info\x1flist_feeds\n"

    curl -sL "$url" | sed -e 's/<!\[CDATA\[//g; s/\]\]>//g' | while xmlgetnext ; do
        case $TAG in
            'item')
                title=''
                link=''
                published=''
                ;;
            'title')
                title="$(echo $VALUE | sed -e 's/<!\[CDATA\[//g; s/\]\]>//g')"
                ;;
            'link')
                link="$VALUE"
                ;;
            'published')
                published="$VALUE"
                ;;
            '/item')
                echo -en "$title\0info\x1fopen $link\n"
                ;;
        esac
    done
}

list_feeds() {
    echo -en "\0prompt\x1fRSS\n"
    echo -en "\0message\x1f\n"

    for key in "${!feeds[@]}"; do 
        echo -en "$key\0info\x1fread_feed $key\n"
    done
}

if [ $ROFI_RETV -eq 0 ]; then
    list_feeds
else
    $ROFI_INFO
fi
