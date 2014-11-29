BEGIN{
ne=0
}
{
if ($1=="Si"){
ne=ne+4
}
if ($1=="O"){
ne=ne+6
}
if ($1=="H"){
ne=ne+1
}
}
END{
bands=ne/2
print "number of e " ne
print "number of bands " bands
}
