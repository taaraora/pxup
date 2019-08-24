# $1 variable in global vars
# returns value of variable
getvar(){
	grep "^$1" global_vars.yml | sed -e "s#^${1}: ##g"
}

