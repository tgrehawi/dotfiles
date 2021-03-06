
# call the verb function for a root command
# print usage and return error on user error
function _verb {
	local parent=$1
	local verb=$2
	local usage=${usage:-"$parent <verb> ..."}
	shift 2
	parent=${parent// /_}
	if [ $verb ]; then
		local func="_$parent""_$verb"
		if type $func &> /dev/null; then
			eval $func $@
		else
			echo "usage: $usage"
			echo "unknown verb '$verb'"
			return 1
		fi
	else
		echo "usage: $usage"
		return 1
	fi
}

# find list of valid verbs for a given command
# (usable with compgen)
function _verbgen {
	local parent=$1
	local query=$2
	if [ $parent ]; then
		compgen -A "function" -- | (
			while read line; do
				local verb=${line#'_'$parent'_'}
				if [[ $verb != $line && $verb =~ ^$query ]]; then
					if [[ $verb == ${verb%%_*} ]]; then
						echo $verb
					fi
				fi
			done
		)
	fi
}
