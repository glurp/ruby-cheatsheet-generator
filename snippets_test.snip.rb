> Hello, this is test of cheat-sheet ruby generator.
# string to array....
 "a,b,c,d".split(/,/)
 "a,bb,c".scan(/\w+/)
# Array to string ....
 [1,2,3].inspect
 [1,2,3].join(",")
# Array to hash ....
 Hash[1,2,3,4]
 hdd = [1,2,3,4,5,6,7,8].group_by {|v| v%4}
# Hash to array....
> direct conversion !
 hdd.to_a()
 hdd.keys()
 hdd.values()
#### Test special html char 
> This comment has less-than, greater-than, ampersand : < ; > 
> Warning! global var/ressources can be  embedded in the docs!
ARGV.join(",")
$0
