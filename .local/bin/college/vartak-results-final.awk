#!/bin/awk -f

BEGIN { FS="," }
FNR == 1 { next }
FILENAME ~ /\/?names.csv$/ { names[$1] = $NF; next }
FILENAME ~ /\/?marks.csv$/ { marks[$1] = $NF; next }
FILENAME ~ /\/?CGP.csv$/ { gpas[$1] = $NF; next }

END {
	i = 1
	for (sn in names) {
		order[i++] = sn
		if (marks[sn] == 0) { marks[sn] = ""; results[sn] = "AB" }
		else if (gpas[sn] == 0) results[sn] = "F"
		else results[sn] = gpas[sn]
	}

	if (sort == "yes") {
		rank="\n\t\t\t<th>Rank</th>\n"
		n = length(order)
		for (i in order) {
			max = i
			for (j = i; j <= n; j++) {
				sn1 = order[max]; sn2 = order[j]
				if (results[sn1] == results[sn2]) {
					if (marks[sn1] < marks[sn2]) max = j
				}
				else if (results[sn1] == "AB") max = j
				else if (results[sn1] == "F") {
					if (results[sn2] != "AB") max = j
				}
				else if (gpas[sn1] < gpas[sn2]) max = j
			}
			if (max != i) { t = order[i]; order[i] = order[max]; order[max] = t }
		}
	}

	print("<table>\n\
	<thead>\n\
		<tr>\n" rank\
"			<th>Seat<br>No.</th>\n\
			<th>Name</th>\n\
			<th>Total<br>Marks</th>\n\
			<th>GPA</th>\n\
		</tr>\n\
	</thead>\n\
	<tbody>")
	for (i in order) {
		sn = order[i]
		if (results[sn] == "AB") {
			print("\t\t<tr class=\"absent\">")
		} else if (results[sn] == "F") {
			print("\t\t<tr class=\"fail\">")
		} else if (gpas[sn] >= 9) {
			print("\t\t<tr class=\"pass notable\">")
		} else {
			print("\t\t<tr class=\"pass\">")
		}
		if (sort == "yes") printf("\t\t\t<td class=\"numeric\">%s</td>\n", i)
		printf("\t\t\t<td class=\"numeric\">%s</td>\n", sn)
		printf("\t\t\t<td class=\"name\">%s</td>\n", names[sn])
		printf("\t\t\t<td class=\"numeric\">%s</td>\n", marks[sn])
		printf("\t\t\t<td class=\"numeric\">%s</td>\n", results[sn])
		print("\t\t</tr>")
	}
	print("\t</tbody>")
	print("</table>")
}
