#!/bin/bash

tmp=$(mktemp "/tmp/card.XXXXi")
tmp2=$(mktemp "/tmp/card.m.XXXXi")
tmp_set=$(mktemp "/tmp/simb.XXXXi")
tmp_lang=$(mktemp "/tmp/simb.XXXXi")
tmp_estilo=$(mktemp "/tmp/est.XXXXi")
new_tmp_estilo=$(mktemp "/tmp/est.XXXXi")
#card=${1}
id=${1}
card_html=$(echo $card |tr [[:upper:]] [[:lower:]])
base="./cards/base_scg.mtg"

##SCG usa id para sus cartas
#http://sales.starcitygames.com/carddisplay.php?product=$id


#Me robo los datos del html que ofrece StarCityGames
get_card=$(curl -L http://sales.starcitygames.com/carddisplay.php?product=$id 2>/dev/null -o $tmp)
#old_card_name=$(cat $tmp |grep '<table cellpadding="5" width="100%">' -A2|sed -e :a -e 's/<[^>]*>//g;/</N;//ba'|tail -1)
#card_name=$(cat $tmp  |grep '<meta property="og:title" content="'|cut -d'"' -f4|cut -d'(' -f1|sed "s/'/\\\'/g")
card_name=$(cat $tmp |grep '<h2 style="margin-top: 10px; margin-left: 10px; font-size: 26px;">'|cut -d'"' -f3|sed "s/>//g"|sed "s/<\/h2//g")
#old_edition=$(cat $tmp |grep '<table cellpadding="5" width="100%">' -A3|sed -e :a -e 's/<[^>]*>//g;/</N;//ba'|tail -1)
edition=$(cat $tmp |grep '<a href="http://sales.starcitygames.com//category.php?cat='|cut -d'>' -f2|cut -d'<' -f1|sed "s/'/\\\'/g")
edition=$(cat $tmp |grep '<a href="http://www.starcitygames.com/catalog/category/'|cut -d'>' -f2)
#estilo=$(cat $tmp |grep "price_icons"|sed 's/\/\//http:\/\//g'|sed 's/^[ \t]*//;s/[ \t]*$//')
estilo="$(cat $tmp  |grep background-image -A22 -B1|dos2unix)"
#price="$(cat $tmp |grep "Price:" --color|awk -F 'Price:' '{ print $2 }'|awk -F '<a href' '{ print $1 }'|cut -d "$" -f2|sed 's/<br\/><br\/>/ /g'|sed "s/'/\\\'/g")"
price="$(cat $tmp |grep "Price:" --color|awk -F 'Price:' '{ print $2 }'|awk -F '<a href' '{ print $1 }'|cut -d "$" -f2|sed 's/<\/div>//g')"
#name=$(cat $tmp |grep '<table cellpadding="6" width="100%">' -A2|sed -e :a -e 's/<[^>]*>//g;/</N;//ba'|tail -1|sed 's/ /_/g')
not=$(cat $tmp|grep non-valid)
condition=$( cat $tmp |grep -Po 'conditions">[^ ]+'|cut -d '>' -f2|cut -d '<' -f1)
#card_text=$( cat $tmp |grep -Po 'Oracle Text:</strong> \K.*(?=\.<br)'|sed -e 's/—/-/'|sed -e 's/<br \/>/ /g'|sed -e 's/<i>/ /g'|sed -e 's/<\/i>/ /g'|sed -e 's/\x27//g')
#card_text=$( cat $tmp |grep -Po '(?<=Oracle Text:</strong> ).*(?=\.)'|sed -e 's/—/-/'|sed -e 's/<br \/>/ /g'|sed -e 's/<i>/ /g'|sed -e 's/<\/i>/ /g'|sed -e 's/\x27//g')
card_text=$( cat $tmp |grep -ozP '(?s)Oracle Text:</strong>\K.*?(?=<br /><br /><strong)'|sed -e 's/—/-/'|sed -e 's/<br \/>/ /g'|sed -e 's/<i>/ /g'|sed -e 's/<\/i>/ /g'|sed -e 's/\x27//g')
rarity=$(cat $tmp |grep -Po '(?<=Rarity:</strong> ).*'|sed -e 's/<[^>]*>//g')
card_type=$( cat $tmp|grep -Po '(?<=Card Type:</strong> ).*'|cut -d '<' -f1)
creature_type=$( cat $tmp|grep -Po '(?<=Creature Type:</strong> ).*'|cut -d '<' -f1)
artist=$( cat $tmp|grep -Po '(?<=Artist:</strong> ).*'|cut -d '<' -f1)

#echo $estilo$price > /tmp/card_$id.html
#sed -i -e 's/\/\//http:\/\//g' /tmp/card_$id.html
#cutycapt --url=file:/tmp/card_$id.html --out=/tmp/card_$id.png
#cuneiform -f text -o card_$id.txt card_$id.png
#convert -monochrome $PWD/card_$id.png $PWD/card_$id.tif
#convert /tmp/card_$id.png /tmp/card_$id.tif
#tesseract /tmp/card_$id.tif /tmp/card_$id_c &>/dev/null
#cat /tmp/card_$id_c.txt| tr -d "[:blank:]" > /tmp/card_$id.txt

#scg_price=$(cat /tmp/card_$id.txt)

echo $not

if [ -z $not ]; then
        #Armo HTML Cabeza
        #echo "<HTML>" > $tmp2
        #echo "<HEAD>" >> $tmp2
        #echo '<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />' >> $tmp2
        #echo "<TITLE>$card_name</TITLE>" >> $tmp2
        #echo "</HEAD>" >> $tmp2
        #echo "<BODY>" >> $tmp2
        #echo "Card Name: $card_name<br>" >> $tmp2
        #echo "Edition: $edition<br>" >> $tmp2
        #echo "<table><tr><td>Price: </td><td>$estilo $price</td></tr></table>" >> $tmp2
        #echo "</BODY>" >> $tmp2
        #echo "</HTML>">> $tmp2

        #Saco las mayusculas
        #card_html=$(echo $card_name |tr [[:upper:]] [[:lower:]])

        #Copio  lo que obtengo del tmp al directorio final
        #mv $tmp2 /usr/local/bin/MTG/cards/$id'_scg'.html

        #Copio al document root
        #cp /usr/local/bin/MTG/cards/$id'_scg'.html /var/www/html/MTG/$id'_scg'.html
        #chmod 644 /var/www/html/MTG/$id'_scg'.html

        #Muestro Donde deje la carta con el precio
        #ls /usr/local/bin/MTG/cards/$id'_scg'.html

        #mysql -uroot -pASDcxz111  mtg_scg -e "INSERT INTO cards_scg (id,card_name,card_edition,card_url,card_price) VALUES (default,"$card_name","$edition","http://sales.starcitygames.com/carddisplay.php?product=$id","cccc");"

        ###########################################
        #query="INSERT INTO \`buscaebay\`.\`cards_scg\` (id,card_name,card_edition,card_url,card_price) VALUES (default,'$card_name','$edition','http://sales.starcitygames.com/carddisplay.php?product=$id','$estilo$price');"



##############################################################################################################
#	query="INSERT INTO \`mtg_scg\`.\`mtg_scg\` (id,card_name,card_edition,card_url,card_price,card_condition,text_card,card_rarity,card_artist,card_type,creature_type) VALUES ('$id','$card_name','$edition','http://sales.starcitygames.com/carddisplay.php?product=$id','$scg_price','$condition','$card_text','$rarity','$artist','$card_type','$creature_type');"

#	echo $query

#        mysql -uroot -pASDcxz111 mtg_scg -e "$query"
##############################################################################################################

	echo id scg: $id
	echo card name: $card_name
	echo edition: $edition
	echo card type: $card_type
	echo creature type: $creature_type
	echo condition: $condition
	echo price scg: $price
	echo text card: $card_text
	echo rarity: $rarity
	echo artist: $artist
	echo ---------------------------------------------------------------------
else
        echo empty $id
fi

rm -rf $tmp
rm -rf $tmp2
rm -rf $tmp_set
rm -rf $tmp_lang
rm -rf $tmp_estilo
rm -rf /tmp/card_$id.html
rm -rf /tmp/card_$id.png
rm -rf /tmp/card_$id.tif
rm -rf /tmp/card_$id_c
rm -rf /tmp/card_$id.txt
