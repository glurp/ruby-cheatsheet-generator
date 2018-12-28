# ruby-cheatsheet-generator


generate documentation from little exemple of ruby code

* write ruby code in a src file ( *.snip.rb )
* write css for rendering page ( style.css )
* append captions, comments, to ruby code ( as markdown )
* comment each code ( text , aligment precision...)
* generate html by :
> ruby generator.rb -s style.css  test.snip.rb

## style

See style.css, as (ugly!) exemple.

***selector class  code.c and code.r*** : css for code exemple and code result

***Captions*** : css for separators
Exemple withe style.css :
[html](http://htmlpreview.github.io/?https://github.com/glurp/ruby-cheatsheet-generator/blob/master/snippets_test.html

## TODO

* styles pragma (  numbers of column, page breaks ...)
* rendering in svg
* rendering in pdf ( convert svg to pdf...)

