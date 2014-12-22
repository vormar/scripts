BEGIN{
x=0
y=0
z=0
n=0}{
n=n+1
x=x+$2
y=y+$3
z=z+$4
}END{
x=x/n
y=y/n
z=z/n
print"x y z n "x" "y" "z" "n
}
