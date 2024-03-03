#!/bin/sh

export RESULT_DIR="$HOME/GDrive/vartak/results"
export SITE_BASE_DIR="$HOME/Dev/csstudent41.github.io"
export DATA_DIR="$SITE_BASE_DIR/data/results"
export CONTENT_DIR="$SITE_BASE_DIR/content/results"

hugo_new() {
	mkdir -p "$(dirname "$1")"
	echo "+++
title = \"${2:-$1}\"
date = $(date +%Y-%m-%dT%H:%M:%S%:::z)
+++" > "$1" &&
	echo "Content \"$1\" created"
}

# rm -r "$CONTENT_DIR"
# rm "$CONTENT_DIR/_index.md"
# rm -r "$CONTENT_DIR/2022-23/fycs-sem2"

cd "$SITE_BASE_DIR" || exit
[ ! -f "$CONTENT_DIR/_index.md" ] && {
	hugo_new "$CONTENT_DIR/_index.md" "📝  Vartak Exam Results"
}


find "$RESULT_DIR" -type f -iwholename "*$1*" -name '*-REGULAR-*.pdf' \
		-printf '%P\n' | while read -r file; do
	dir="$DATA_DIR/${file%.pdf}"
	outdir="$(echo "${file%.pdf}" | sed 's/-\(REGULAR\|ATKT\)-.*$//; s/\(.*\)/\L\1/')"
	outdir="$CONTENT_DIR/${outdir%-*}$(echo "${outdir##*-}" |
		sed 's/iv/iiii/; s/v/iiiiii/' | tr -d \\n | wc -m)"

	[ -d "$dir" ] || {
		case "${file%%/*}" in
			2022-23)
				case "${file##*/}" in
					SYIT*) vartak-results-data -td "$dir" "$RESULT_DIR/$file" ;;
					*) vartak-results-data -d "$dir" "$RESULT_DIR/$file" ;;
				esac
				;;

			2023-24)
				case "${file##*/}" in
					SYBCOM*|SYBBI*|FYBCOM*|FYBBI*)
						vartak-results-data -td "$dir" "$RESULT_DIR/$file" ;;
					FYBMS*|SYBMS*) continue ;;
					*) vartak-results-data -d "$dir" "$RESULT_DIR/$file" ;;
				esac
				;;

			*) vartak-results-data -d "$dir" "$RESULT_DIR/$file" ;;
		esac
		[ -d "$dir" ] && rm -rf "$outdir"
	}

	[ -f "$outdir/_index.html" ] && continue
	title="$(echo "${dir##*/}" |
		sed 's/-\(REGULAR\|ATKT\)-.*$//; s/SEM/Sem/; s/-/ /g;')"
	hugo_new "$outdir/_index.html" "📜  $title"
	echo "<p style=\"text-align: center\">Checkout <a href=\"toppers\">top scorers</a> 🚀</p>" >> "$outdir/_index.html"
	vartak-results-final.awk "$dir/names.csv" "$dir/marks.csv" "$dir/CGP.csv" >> "$outdir/_index.html"

	[ -f "$outdir/toppers.html" ] && continue
	hugo_new "$outdir/toppers.html" "🎓  $title"
	vartak-results-final.awk sort=yes "$dir/names.csv" "$dir/marks.csv" "$dir/CGP.csv" >> "$outdir/toppers.html"
done


find "$CONTENT_DIR" -mindepth 1 -maxdepth 1 -type d | while read -r dir; do
	[ -f "$dir/_index.md" ] && continue
	hugo_new "$dir/_index.md" "🗓️  ${dir##*/}"
done
