# $1 variable in global vars
# returns value of variable
getvar(){
	grep "^$1" global_vars.yml | cut -d: -f2 | sed -e "s# ##g"
}

