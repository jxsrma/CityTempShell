#!/bin/bash

# Main Topics
# curl "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$APIKEY" > w
# jq '.main.temp' w

# echo "Today's date is: " $dateTime | figlet
# echo "Today's date is: " $dateTime
# echo "Today's date is: " $dateTime | espeak

checkcURL(){
	if [ $? -ne 0 ]; then
		echo "Check your internet connection"
		exit 1
	fi
}

if [ $# -ge 1 ]; then
	city=$(echo "$@" | sed 's/ /%20/g')
	curl 10s -s "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$APIKEY" > .tempCity
	checkcURL
else
	dateTime=`date "+%A %B %d, %Y. %I:%M %p"`
	ipInfo=$(curl 10s -s ipinfo.io)
	checkcURL
	city=$(echo "$ipInfo" | jq -r '.city')
	state=$(echo "$ipInfo" | jq -r '.region')
	country=$(echo "$ipInfo" | jq -r '.country')
	lat=$(echo "$ipInfo" | jq -r '.loc' | sed 's/,/ /g' | awk '{print $1}')
	lon=$(echo "$ipInfo" | jq -r '.loc' | sed 's/,/ /g' | awk '{print $2}')
	flag=1
	curl 10s -s "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$APIKEY" > .tempCity
	checkcURL
fi


# Emoji List
declare -A icons
icons["11d"]="⛈️"  # Thunderstorm
icons["09d"]="🌧️"  # Rain
icons["10d"]="🌦️"  # Showers
icons["13d"]="❄️"   # Snow
icons["09d"]="🌧️"  # Rain
icons["50d"]="🌫️"  # Mist
icons["01d"]="☀️"  # Clear Sky - Day
icons["01n"]="🌙"  # Clear Sky - Night
icons["02d"]="⛅"  # Few Clouds - Day
icons["02n"]="⛅"  # Few Clouds - Night
icons["03d"]="🌥️"  # Scattered Clouds - Day
icons["03n"]="🌥️"  # Scattered Clouds - Night
icons["04d"]="☁️"  # Broken Clouds - Day
icons["04n"]="☁️"  # Broken Clouds - Night

zone=`curl -s ipinfo.io | jq -r '.timezone'`
temp=$(jq -r '.main.temp' .tempCity)
weather=$(jq -r '.weather[0].description' .tempCity)
iconCode=$(jq -r '.weather[0].icon' .tempCity)
icon=`echo "${icons[$iconCode]}"`

feel=$(jq -r '.main.feels_like' .tempCity)
min=$(jq -r '.main.temp_min' .tempCity)
max=$(jq -r '.main.temp_max' .tempCity)

temp_celsius=$(echo "scale=2; $temp - 273.15" | bc)
feel_celsius=$(echo "scale=2; $feel - 273.15" | bc)
min_celsius=$(echo "scale=2; $min - 273.15" | bc)
max_celsius=$(echo "scale=2; $max - 273.15" | bc)


timezone_offset=$(date +%z)
hours=${timezone_offset:1:2}
minutes=${timezone_offset:3:2}
offset_seconds=$((hours * 3600 + minutes * 60))

tempTimeZone=`jq -r '.timezone' .tempCity`
sunr=$(jq -r '.sys.sunrise' .tempCity)
suns=$(jq -r '.sys.sunset' .tempCity)

sunrTime=$(date -d "@$(((sunr - offset_seconds) + tempTimeZone))" "+%I:%M:%S %p")
sunsTime=$(date -d "@$(((suns - offset_seconds) + tempTimeZone))" "+%I:%M:%S %p")

# Output

currHour=$(date +%H)
greet="Hello"
if [ $currHour -ge 5 ] && [ $currHour -lt 12 ]; then
        greet="Good Morning"
elif [ $currHour -ge 12 ] && [ $currHour -lt 13 ]; then
        greet="Good Noon"
elif [ $currHour -ge 13 ] && [ $currHour -lt 17 ]; then
        greet="Good Afternoon"
elif [ $currHour -ge 17 ] && [ $currHour -lt 21 ]; then
        greet="Good Evening"
elif [ $currHour -ge 21 ] || [ $currHour -lt 5 ]; then
        greet="Good Night"
else
        greet="Greetings"
fi

echo $greet | figlet

if [ "$flag" = "1" ]; then
	echo "Today's is" $dateTime
	echo "In $city, $state, $country"
else
	# date -d "@$(((sunr - offset_seconds) + tempTimeZone))" "+%I:%M:%S %p"
	systemTime=$(date +%s)
	cityTime=$(date -d "@$(((systemTime - offset_seconds) + tempTimeZone))" "+%A, %B %d, %Y, %I:%M:%S %p")
	echo "Today's is" $cityTime
	echo "In $city"
fi

echo "Temperature is $temp_celsius °C with" $weather $icon
echo "Feels Like $feel_celsius °C"
# "+%A, %B %d, %Y, %I:%M:%S %p"
echo "Sunrise" $sunrTime
echo "Sunset" $sunsTime

echo `date "+%b %d %H:%M:%S"` `whoami` "$temp_celsius °C with $weather in $city" >> .now.log
