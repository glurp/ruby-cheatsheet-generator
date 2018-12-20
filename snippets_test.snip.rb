# string to array....
 "a,b,c,d".split(/,/)
 "a,bb,c".scan(/\w+/)
## array to string ....
 [1,2,3].inspect
 [1,2,3].join(",")
## array to hash ....
 Hash[1,2,3,4]
 @h=[1,2,3,4,5,6,7,8].group_by {|v| v%4}
#### test special html char : < ; > 
#### Hash to array....
> direct conversion !
> test special html char : < ; > 
 @h.to_a()
 @h.keys()
 @h.values()
@haa="1 ; <div>" 
@haa.size