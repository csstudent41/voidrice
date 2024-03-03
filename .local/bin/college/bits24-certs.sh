#!/bin/sh

[ -f certificate.jpg ] || exit

for file in *Participants.csv; do
	event="${file%Participants.csv}"
	mkdir -pv "$event"

	while IFS=\| read -r email name; do echo
		# [ -f "$event/$email" ] && continue
		convert -verbose certificate.jpg \
			-pointsize 200 -fill white -font MesloLGL-Nerd-Font-Bold \
			-annotate +3700+2550 "$name" -annotate +3700+3100 "$event" \
			"$event/$email.jpg"
	done < "$file"
done
