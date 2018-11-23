awk 'NR == 1 || NR % 5 == 0' $1

# alternative form:
# sed -n '1p;0~3p' input.txt
# first~step Match every step'th line starting with line first. 
